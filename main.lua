-- Slider destekli FLY sistemi (Delta uyumlu, mobil optimize)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

local flying = false
local flySpeed = 100
local bodyGyro, bodyVelocity
local flyLoop

-- FLY başlat
local function startFly()
    if flying then return end
    flying = true

    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = hrp.CFrame

    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    flyLoop = RunService.RenderStepped:Connect(function()
        if not flying then return end
        local moveVec = Vector3.zero
        local mouse = player:GetMouse()
        if mouse.W then moveVec += workspace.CurrentCamera.CFrame.LookVector end
        if mouse.S then moveVec -= workspace.CurrentCamera.CFrame.LookVector end
        if mouse.A then moveVec -= workspace.CurrentCamera.CFrame.RightVector end
        if mouse.D then moveVec += workspace.CurrentCamera.CFrame.RightVector end
        bodyVelocity.Velocity = moveVec.Unit * flySpeed
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end)
end

-- FLY durdur
local function stopFly()
    flying = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    if flyLoop then flyLoop:Disconnect() flyLoop = nil end
end

-- GUI Başlat
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 220)
frame.Position = UDim2.new(0.5, -130, 0.8, -110)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🛫 Brookhaven FLY Menü"
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0.9, 0, 0, 40)
flyBtn.Position = UDim2.new(0.05, 0, 0, 40)
flyBtn.Text = "✅ FLY Aç"
flyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 16
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 6)

-- 🔘 Slider barı
local sliderLabel = Instance.new("TextLabel", frame)
sliderLabel.Size = UDim2.new(0.9, 0, 0, 20)
sliderLabel.Position = UDim2.new(0.05, 0, 0, 90)
sliderLabel.Text = ⚙️ Hız: " .. tostring(flySpeed)
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 16

local sliderBar = Instance.new("Frame", frame)
sliderBar.Size = UDim2.new(0.9, 0, 0, 6)
sliderBar.Position = UDim2.new(0.05, 0, 0, 115)
sliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 3)

local sliderKnob = Instance.new("Frame", sliderBar)
sliderKnob.Size = UDim2.new(0, 12, 0, 12)
sliderKnob.Position = UDim2.new(flySpeed / 200, -6, 0.5, -6)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(0, 6)

-- 🖱️ Slider kontrolü
local dragging = false
sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
        local percent = relX / sliderBar.AbsoluteSize.X
        flySpeed = math.floor(percent * 200)
        sliderKnob.Position = UDim2.new(percent, -6, 0.5, -6)
        sliderLabel.Text = "⚙️ Hız: " .. tostring(flySpeed)
    end
end)

-- ❌ Kapat butonu
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0.9, 0, 0, 30)
closeBtn.Position = UDim2.new(0.05, 0, 0, 160)
closeBtn.Text = "❌ Menüyü Kapat"
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Buton işlevleri
flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyBtn.Text = "✅ FLY Aç"
    else
        startFly()
        flyBtn.Text = "🚫 FLY Kapat"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    stopFly()
end)