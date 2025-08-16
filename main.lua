local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local LP = game.Players.LocalPlayer
local mouse = LP:GetMouse()

-- Blur efekti
local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 10

-- Menü
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = game.CoreGui
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

TS:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 300, 0, 500)
}):Play()

-- Sürüklenebilirlik
local dragging, dragOffset = false, nil
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragOffset = input.Position - frame.AbsolutePosition
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        frame.Position = UDim2.new(0, input.Position.X - dragOffset.X, 0, input.Position.Y - dragOffset.Y)
    end
end)

-- Kapatma tuşu (❌)
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "❌"
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    blur.Enabled = false
    flying = false
    RS:UnbindFromRenderStep("Fly")
    if bv then bv:Destroy() end
    noclip = false
    espActive = false
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character then
            for _, a in pairs(p.Character:GetChildren()) do
                if a:IsA("BoxHandleAdornment") then
                    a:Destroy()
                end
            end
        end
    end
end)

-- Buton oluşturucu
local function createButton(text, yPos)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 260, 0, 30)
    btn.Position = UDim2.new(0, 20, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    return btn
end

-- Fly
local speed = 100
local flying = false
local bv = nil
local flyBtn = createButton("Fly Aç/Kapat", 240)
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, 0, 0)
        RS:BindToRenderStep("Fly", 0, function()
            bv.Velocity = mouse.Hit.lookVector * speed
        end)
    else
        RS:UnbindFromRenderStep("Fly")
        if bv then bv:Destroy() end
    end
    flyBtn.BackgroundColor3 = flying and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40)
end)

-- Noclip
local noclip = false
local noclipBtn = createButton("Noclip Aç/Kapat", 280)
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40)
end)
RS.Stepped:Connect(function()
    if noclip then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ESP
local espActive = false
local espBtn = createButton("ESP Aç/Kapat", 320)
espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(4, 5, 2)
                box.Adornee = player.Character.HumanoidRootPart
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Color3 = Color3.new(1, 0, 0)
                box.Transparency = 0.5
                box.Parent = player.Character
            end
        end
    else
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character then
                for _, a in pairs(p.Character:GetChildren()) do
                    if a:IsA("BoxHandleAdornment") then
                        a:Destroy()
                    end
                end
            end
        end
    end
    espBtn.BackgroundColor3 = espActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40)
end)

-- Speed etiketi
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0, 240, 0, 25)
speedLabel.Position = UDim2.new(0, 20, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 16
speedLabel.Text = "Fly Speed: " .. speed

-- Speed ayarı
local function updateSpeedLabel()
    speedLabel.Text = "Fly Speed: " .. speed
end
local speedPlus = createButton("Speed +", 160)
speedPlus.MouseButton1Click:Connect(function()
    speed = math.clamp(speed + 10, 10, 200)
    updateSpeedLabel()
end)
local speedMinus = createButton("Speed -", 200)
speedMinus.MouseButton1Click:Connect(function()
    speed = math.clamp(speed - 10, 10, 200)
    updateSpeedLabel()
end)

-- Gravity ayarı
local gravityPlus = createButton("Gravity +", 80)
gravityPlus.MouseButton1Click:Connect(function()
    game.Workspace.Gravity = math.clamp(game.Workspace.Gravity + 25, 0, 500)
end)
local gravityMinus = createButton("Gravity -", 120)
gravityMinus.MouseButton1Click:Connect(function()
    game.Workspace.Gravity = math.clamp(game.Workspace.Gravity - 25, 0, 500)
end)

-- Tema seçimi
local themes = {
    ["Koyu"] = Color3.fromRGB(25,25,25),
    ["Siberpunk"] = Color3.fromRGB(10,10,30),
    ["Matrix"] = Color3.fromRGB(0,10,0)
}
local temaKoyu = createButton("Tema: Koyu", 360)
temaKoyu.MouseButton1Click:Connect(function() frame.BackgroundColor3 = themes["Koyu"] end)
local temaSiber = createButton("Tema: Siberpunk