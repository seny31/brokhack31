local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

local flying = false
local noclip = false
local espEnabled = false
local gravityEnabled = true
local theme = "dark"
local guiVisible = true
local speed = 50

local bv, bg

-- Fly başlat
local function startFly()
    if flying then return end
    flying = true
    bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.zero
    bg = Instance.new("BodyGyro", root)
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.CFrame = root.CFrame
    humanoid.PlatformStand = true
end

-- Fly durdur
local function stopFly()
    if not flying then return end
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    humanoid.PlatformStand = false
end

-- Hareket güncelleme
RunService.Heartbeat:Connect(function()
    if flying then
        local moveDir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * speed end
        bv.Velocity = moveDir
        bg.CFrame = workspace.CurrentCamera.CFrame
    end
end)

-- Noclip
local function setNoclip(state)
    noclip = state
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

RunService.Stepped:Connect(function()
    if noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- ESP
local function toggleESP(state)
    espEnabled = state
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            if state then
                if not head:FindFirstChild("ESP") then
                    local box = Instance.new("BoxHandleAdornment", head)
                    box.Name = "ESP"
                    box.Size = Vector3.new(2, 2, 1)
                    box.Color3 = Color3.new(1, 0, 0)
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Adornee = head
                end
            else
                if head:FindFirstChild("ESP") then
                    head.ESP:Destroy()
                end
            end
        end
    end
end

-- Gravity
local function toggleGravity(state)
    gravityEnabled = state
    workspace.Gravity = state and 196.2 or 0
end

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 400)
frame.Position = UDim2.new(0, 40, 0, 40)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🚀 Fly Control Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 280, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
end

createButton("Toggle Fly", 50, function()
    if flying then stopFly() else startFly() end
end)

createButton("Toggle Noclip", 95, function()
    setNoclip(not noclip)
end)

createButton("Toggle ESP", 140, function()
    toggleESP(not espEnabled)
end)

createButton("Toggle Gravity", 185, function()
    toggleGravity(not gravityEnabled)
end)

createButton("Switch Theme", 230, function()
    if theme == "dark" then
        frame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        title.TextColor3 = Color3.fromRGB(30, 30, 30)
        theme = "light"
    else
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        theme = "dark"
    end
end)

-- Slider
local sliderLabel = Instance.new("TextLabel", frame)
sliderLabel.Size = UDim2.new(0, 280, 0, 20)
sliderLabel.Position = UDim2.new(0, 20, 0, 275)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Fly Speed: " .. speed
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 16
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local sliderBar = Instance.new("Frame", frame)
sliderBar.Size = UDim2.new(0, 280, 0, 8)
sliderBar.Position = UDim2.new(0, 20, 0, 300)
sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 4)

local sliderHandle = Instance.new("Frame", sliderBar)
sliderHandle.Size = UDim2.new(0, 12, 0, 20)
sliderHandle.Position = UDim2.new(0, (speed - 10)/190 * 280, 0, -6)
sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(0, 6)
sliderHandle.Active = true
sliderHandle.Draggable = true

sliderHandle:GetPropertyChangedSignal("Position"):Connect(function()
    local x = math.clamp(sliderHandle.Position.X.Offset, 0, 280)
    speed = math.floor(10 + (x / 280) * 190)
    sliderLabel.Text = "Fly Speed: " .. speed
end)

-- GUI toggle (G tuşu)
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end
end)