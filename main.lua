-- Basit Fly ve Noclip Menü Scripti

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flyActive = false
local noclipActive = false
local bodyVelocity, bodyGyro

local moveVector = Vector3.new()
local speed = 100

-- UI
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "FlyNoclipMenu"

local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Fly & Noclip Menu"
title.TextColor3 = Color3.fromRGB(0,170,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24

local flyCheckbox = Instance.new("TextButton", frame)
flyCheckbox.Size = UDim2.new(0, 30, 0, 30)
flyCheckbox.Position = UDim2.new(0, 10, 0, 50)
flyCheckbox.BackgroundColor3 = Color3.fromRGB(30,30,30)
flyCheckbox.Text = ""
local flyChecked = false

local flyLabel = Instance.new("TextLabel", frame)
flyLabel.Size = UDim2.new(0, 100, 0, 30)
flyLabel.Position = UDim2.new(0, 50, 0, 50)
flyLabel.Text = "Fly"
flyLabel.TextColor3 = Color3.fromRGB(200,200,200)
flyLabel.BackgroundTransparency = 1
flyLabel.Font = Enum.Font.Gotham
flyLabel.TextSize = 22
flyLabel.TextXAlignment = Enum.TextXAlignment.Left

local noclipCheckbox = Instance.new("TextButton", frame)
noclipCheckbox.Size = UDim2.new(0, 30, 0, 30)
noclipCheckbox.Position = UDim2.new(0, 10, 0, 90)
noclipCheckbox.BackgroundColor3 = Color3.fromRGB(30,30,30)
noclipCheckbox.Text = ""
local noclipChecked = false

local noclipLabel = Instance.new("TextLabel", frame)
noclipLabel.Size = UDim2.new(0, 100, 0, 30)
noclipLabel.Position = UDim2.new(0, 50, 0, 90)
noclipLabel.Text = "Noclip"
noclipLabel.TextColor3 = Color3.fromRGB(200,200,200)
noclipLabel.BackgroundTransparency = 1
noclipLabel.Font = Enum.Font.Gotham
noclipLabel.TextSize = 22
noclipLabel.TextXAlignment = Enum.TextXAlignment.Left

local function toggleFly()
    flyChecked = not flyChecked
    flyCheckbox.Text = flyChecked and "✔" or ""
    if flyChecked then
        startFly()
    else
        stopFly()
    end
end

local function toggleNoclip()
    noclipChecked = not noclipChecked
    noclipCheckbox.Text = noclipChecked and "✔" or ""
    if noclipChecked then
        startNoclip()
    else
        stopNoclip()
    end
end

flyCheckbox.MouseButton1Click:Connect(toggleFly)
flyLabel.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then toggleFly() end end)

noclipCheckbox.MouseButton1Click:Connect(toggleNoclip)
noclipLabel.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then toggleNoclip() end end)

-- Fly Fonksiyonları
function startFly()
    if flyActive then return end
    flyActive = true

    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end

    bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new()

    bodyGyro = Instance.new("BodyGyro", rootPart)
    bodyGyro.MaxTorque = Vector3.new(4e4, 4e4, 4e4)
    bodyGyro.P = 10000
    bodyGyro.D = 1000
end

function stopFly()
    flyActive = false
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    humanoid.PlatformStand = false
    moveVector = Vector3.new()
end

-- Noclip Fonksiyonları
local noclipConnection
function startNoclip()
    if noclipActive then return end
    noclipActive = true

    noclipConnection = RunService.Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

function stopNoclip()
    noclipActive = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Sağ tıkla yön değiştirme
mouse.Button2Down:Connect(function()
    if not flyActive then return end
    local mousePos = mouse.Hit.p
    local rootPos = rootPart.Position
    local lookVector = (Vector3.new(mousePos.X, rootPos.Y, mousePos.Z) - rootPos).Unit
    if bodyGyro then
        bodyGyro.CFrame = CFrame.new(rootPos, rootPos + lookVector)
    end
end)

-- WASD Hareketi
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

-- Hareket Güncelleme
RunService.Heartbeat:Connect(function()
    if flyActive and bodyVelocity and bodyGyro then
        humanoid.PlatformStand
