-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()

-- Variables
local flyActive = false
local noclipActive = false
local bodyVelocity, bodyGyro

local moveVector = Vector3.new(0,0,0)
local speed = 75

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "SimpleFlyNoclipMenu"

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0,0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

local UIStroke = Instance.new("UIStroke", mainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Transparency = 0.3

-- Shadow Effect
local shadow = Instance.new("Frame", mainFrame)
shadow.Size = UDim2.new(1, 8, 1, 8)
shadow.Position = UDim2.new(0, -4, 0, -4)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.ZIndex = 0
shadow.BorderSizePixel = 0
shadow.ClipsDescendants = false

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Fly & Noclip Menu"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextStrokeTransparency = 0.7
title.Position = UDim2.new(0,0,0,0)

-- Close button (X)
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = true

closeBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
    stopFly()
    stopNoclip()
end)

-- Minimize/Maximize button (+)
local minMaxBtn = Instance.new("TextButton", mainFrame)
minMaxBtn.Size = UDim2.new(0, 30, 0, 30)
minMaxBtn.Position = UDim2.new(1, -70, 0, 5)
minMaxBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minMaxBtn.Text = "+"
minMaxBtn.Font = Enum.Font.GothamBold
minMaxBtn.TextSize = 28
minMaxBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
minMaxBtn.BorderSizePixel = 0
minMaxBtn.AutoButtonColor = true

local minimized = false
minMaxBtn.MouseButton1Click:Connect(function()
    if minimized then
        mainFrame.Size = UDim2.new(0, 400, 0, 250)
        minimized = false
    else
        mainFrame.Size = UDim2.new(0, 200, 0, 40)
        minimized = true
    end
end)

-- Checkbox Creator
local function createCheckbox(parent, text, pos)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0, 180, 0, 40)
    frame.Position = pos
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.Size = UDim2.new(1, -40, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 22
    label.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextButton", frame)
    box.Size = UDim2.new(0, 30, 0, 30)
    box.Position = UDim2.new(1, -35, 0, 5)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.BorderSizePixel = 1
    box.BorderColor3 = Color3.fromRGB(0, 170, 255)
    box.Text = ""
    box.AutoButtonColor = false

    local checked = false
    local checkMark = Instance.new("TextLabel", box)
    checkMark.Text = "✔"
    checkMark.Font = Enum.Font.GothamBold
    checkMark.TextSize = 24
    checkMark.TextColor3 = Color3.fromRGB(0, 170, 255)
    checkMark.BackgroundTransparency = 1
    checkMark.Size = UDim2.new(1,0,1,0)
    checkMark.Visible = false

    box.MouseButton1Click:Connect(function()
        checked = not checked
        checkMark.Visible = checked
        if text == "Fly" then
            if checked then
                startFly()
            else
                stopFly()
            end
        elseif text == "Noclip" then
            if checked then
                startNoclip()
            else
                stopNoclip()
            end
        end
    end)

    return box
end

-- Fly Functions
function startFly()
    if flyActive then return end
    flyActive = true

    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end

    bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)

    bodyGyro = Instance.new("BodyGyro", rootPart)
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.P = 1e4
end

function stopFly()
    flyActive = false
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    moveVector = Vector3.new(0,0,0)
    humanoid.PlatformStand = false
end

-- Noclip Functions
local noclipConn
function startNoclip()
    if noclipActive then return end
    noclipActive = true

    noclipConn = RunService.Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

function stopNoclip()
    noclipActive = false
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Sağ tıkla yön değiştir
mouse.Button2Down:Connect(function()
    if not flyActive then return end
    local mousePos = mouse.Hit.p
    local rootPos = rootPart.Position
    local lookVector = (Vector3.new(mousePos.X, rootPos.Y, mousePos.Z) - rootPos).Unit
    if bodyGyro then
        bodyGyro.CFrame = CFrame.new(rootPos, rootPos + lookVector)
    end
end)

-- WASD hareketi
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then
        moveVector = moveVector + Vector3.new(0, 0, -1)
    elseif input.KeyCode == Enum.KeyCode.S then
        moveVector = moveVector + Vector3.new(0, 0, 1)
    elseif input.KeyCode == Enum.KeyCode.A then
        moveVector = moveVector + Vector3.new(-1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.D then
        moveVector = moveVector + Vector3.new(1, 0, 0)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        moveVector = moveVector - Vector3.new(0, 0, -1)
    elseif input.KeyCode == Enum.KeyCode.S then
        moveVector = moveVector - Vector3.new(0, 0, 1)
    elseif input.KeyCode == Enum.KeyCode.A then
        moveVector = moveVector - Vector3.new(-1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.D then
        moveVector = moveVector - Vector3.new(1, 0, 0)
    end
end)

-- Hareketi güncelle
RunService.Heartbeat:Connect(function()
    if flyActive and bodyVelocity and bodyGyro then
        humanoid.PlatformStand = true
        local lookCFrame = bodyGyro.CFrame
        local forward = lookCFrame.LookVector
        local right = lookCFrame.RightVector

        local direction = (forward * moveVector.Z + right * moveVector.X)
        if direction.Magnitude > 0 then
            direction = direction.Unit
        end

        bodyVelocity.Velocity = direction * speed
    else
        humanoid.PlatformStand = false
    end
end)

-- Menü içi tik kutucukları oluştur
local flyCheckbox = createCheckbox(mainFrame, "Fly", UDim2.new(0, 20, 0, 60))
local noclipCheckbox = createCheckbox(mainFrame, "Noclip", UDim2.new(0, 20, 0, 110))
