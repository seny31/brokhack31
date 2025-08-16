local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- GUI oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HackMenu"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.25, 0, 0.25, 0)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local title = Instance.new("TextLabel", titleBar)
title.Text = "Hack Menu"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 24)
closeBtn.Position = UDim2.new(1, -35, 0, 3)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeBtn.BorderSizePixel = 0

local resizeBtn = Instance.new("TextButton", titleBar)
resizeBtn.Size = UDim2.new(0, 30, 0, 24)
resizeBtn.Position = UDim2.new(1, -70, 0, 3)
resizeBtn.Text = "+"
resizeBtn.Font = Enum.Font.GothamBold
resizeBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
resizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
resizeBtn.BorderSizePixel = 0

local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

-- Checkbox fonksiyonu
local function createOption(text, parent, y)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -20, 0, 30)
    container.Position = UDim2.new(0, 10, 0, y)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Text = text
    label.Size = UDim2.new(1, -40, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left

    local checkbox = Instance.new("TextButton", container)
    checkbox.Size = UDim2.new(0, 25, 0, 25)
    checkbox.Position = UDim2.new(1, -25, 0, 2)
    checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    checkbox.BorderSizePixel = 0
    checkbox.Text = ""

    local tick = Instance.new("TextLabel", checkbox)
    tick.Text = "✓"
    tick.Size = UDim2.new(1, 0, 1, 0)
    tick.BackgroundTransparency = 1
    tick.TextColor3 = Color3.fromRGB(100, 255, 100)
    tick.Font = Enum.Font.GothamBold
    tick.TextSize = 20
    tick.Visible = false

    return checkbox, tick
end

local flyCheckbox, flyTick = createOption("Fly", content, 0)
local noclipCheckbox, noclipTick = createOption("Noclip", content, 40)

-- Sürükleme
local dragging = false
local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X),
            startPos.Y.Scale,
            math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
        )
    end
end)

-- Kapatma
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Küçült/Büyüt
local minimized = false
local originalSize = frame.Size
local minimizedSize = UDim2.new(0, 120, 0, 30)

resizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        frame.Size = originalSize
        content.Visible = true
        minimized = false
        resizeBtn.Text = "+"
    else
        frame.Size = minimizedSize
        content.Visible = false
        minimized = true
        resizeBtn.Text = "-"
    end
end)

-- Fly mekanizması
local flyActive = false
local bodyVelocity

local function startFly()
    if bodyVelocity then bodyVelocity:Destroy() end
    bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
end

local function stopFly()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

RunService.Heartbeat:Connect(function()
    if flyActive and bodyVelocity then
        local direction = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - workspace.CurrentCamera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + workspace.CurrentCamera.CFrame.RightVector
        end

        direction = Vector3.new(direction.X, 0, direction.Z)
        if direction.Magnitude > 0 then
            direction = direction.Unit
            bodyVelocity.Velocity = direction * 100
        else
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end
end)

local function toggleFly(state)
    flyActive = state
    flyTick.Visible = state
    if state then
        startFly()
        humanoid.PlatformStand = true
    else
        stopFly()
        humanoid.PlatformStand = false
    end
end

flyCheckbox.MouseButton1Click:Connect(function()
    toggleFly(not flyActive)
end)

-- Noclip mekanizması
local noclipActive = false

local function noclipOn()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function noclipOff()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

local function toggleNoclip(state)
    noclipActive = state
    noclipTick.Visible = state
    if state then
        noclipOn()
    else
        noclipOff()
    end
end

noclipCheckbox.MouseButton1Click:Connect(function()
    toggleNoclip(not noclipActive)
end)
