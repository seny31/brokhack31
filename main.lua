local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local flying = false
local noclip = false
local speed = 50

local bv
local bg

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Fly fonksiyonları
local function startFly()
    if flying then return end
    flying = true
    bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.new(0,0,0)

    bg = Instance.new("BodyGyro", root)
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.CFrame = root.CFrame

    humanoid.PlatformStand = true
end

local function stopFly()
    if not flying then return end
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    humanoid.PlatformStand = false
end

-- Noclip fonksiyonu
local function setNoclip(state)
    noclip = state
    if noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Noclip bazen engellere takılmayı azaltmak için sürekli kontrol (nadir engeller için)
RunService.Stepped:Connect(function()
    if noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly hareket güncelleme
RunService.Heartbeat:Connect(function()
    if flying then
        local moveDir = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * speed
        end

        if bv then
            bv.Velocity = moveDir
        end
        if bg then
            bg.CFrame = workspace.CurrentCamera.CFrame
        end
    end
end)

-- Menü oluşturma

local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Seny31HackMenu"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 140)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "seny31 hack mk mert"
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

local function createCheckbox(text, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 30)
    label.Position = UDim2.new(0, 60, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 35, 0, 35)
    checkbox.Position = UDim2.new(0, 15, 0, posY)
    checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    checkbox.Text = ""
    checkbox.TextColor3 = Color3.new(0,0,0)
    checkbox.Font = Enum.Font.SourceSansBold
    checkbox.TextSize = 28
    checkbox.Parent = frame

    return checkbox
end

local flyCheckbox = createCheckbox("Enable Fly", 55)
local noclipCheckbox = createCheckbox("Enable Noclip", 95)

local function updateCheckbox(checkbox, state)
    if state then
        checkbox.Text = "✔"
        checkbox.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        checkbox.Text = ""
        checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end

flyCheckbox.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
    updateCheckbox(flyCheckbox, flying)
end)

noclipCheckbox.MouseButton1Click:Connect(function()
    setNoclip(not noclip)
    updateCheckbox(noclipCheckbox, noclip)
end)

updateCheckbox(flyCheckbox, flying)
updateCheckbox(noclipCheckbox, noclip)

-- Menü küçült/büyüt butonu

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 35)
toggleButton.Position = UDim2.new(1, -45, 0, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.TextColor3 = Color3.fromRGB(230, 230, 230)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 28
toggleButton.Text = "-"
toggleButton.Parent = frame

local menuExpanded = true

toggleButton.MouseButton1Click:Connect(function()
    if menuExpanded then
        -- Küçült
        frame.Size = UDim2.new(0, 280, 0, 50)
        flyCheckbox.Visible = false
        noclipCheckbox.Visible = false
        toggleButton.Text = "+"
        menuExpanded = false
    else
        -- Büyüt
        frame.Size = UDim2.new(0, 280, 0, 140)
        flyCheckbox.Visible = true
        noclipCheckbox.Visible = true
        toggleButton.Text = "-"
        menuExpanded = true
    end
end)
