local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local speed = 50
local bv
local bg

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

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDir += workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDir -= workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDir -= workspace.CurrentCamera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDir += workspace.CurrentCamera.CFrame.RightVector
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * speed
        end

        bv.Velocity = moveDir
        bg.CFrame = workspace.CurrentCamera.CFrame
    end
end)

-- GUI oluştur
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0, 30, 0, 30)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.AnchorPoint = Vector2.new(0, 0)
frame.BackgroundTransparency = 0.1

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🚀 Fly Control Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(0, 260, 0, 40)
flyButton.Position = UDim2.new(0, 20, 0, 50)
flyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
flyButton.Text = "Toggle Fly"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 20
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.AutoButtonColor = true

flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyButton.Text = "Toggle Fly (Off)"
        flyButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    else
        startFly()
        flyButton.Text = "Toggle Fly (On)"
        flyButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    end
end)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0, 260, 0, 30)
speedLabel.Position = UDim2.new(0, 20, 0, 100)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. speed
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local speedSlider = Instance.new("TextButton", frame)
speedSlider.Size = UDim2.new(0, 260, 0, 30)
speedSlider.Position = UDim2.new(0, 20, 0, 130)
speedSlider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
speedSlider.Text = "Click to Increase Speed"
speedSlider.Font = Enum.Font.Gotham
speedSlider.TextSize = 16
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)

speedSlider.MouseButton1Click:Connect(function()
    speed += 10
    if speed > 200 then speed = 10 end
    speedLabel.Text = "Speed: " .. speed
end)