local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Ayarlar
local flying = false
local noclip = false
local espEnabled = false
local gravityEnabled = true
local guiVisible = true
local speed = 50

-- Fly fonksiyonları
local bv, bg
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

local function stopFly()
    if not flying then return end
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    humanoid.PlatformStand = false
end

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

-- Gravity toggle
local function toggleGravity(state)
    gravityEnabled = state
    workspace.Gravity = state and 196.2 or 80
end

-- ESP (BillboardGui + mesafe)
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then return end
    local head = targetPlayer.Character.Head
    local espGui = Instance.new("BillboardGui")
    espGui.Name = "ESP"
    espGui.Adornee = head
    espGui.Size = UDim2.new(0, 100, 0, 40)
    espGui.StudsOffset = Vector3.new(0, 2, 0)
    espGui.AlwaysOnTop = true
    espGui.Parent = head
    local textLabel = Instance.new("TextLabel", espGui)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.Text = "..."
    RunService.RenderStepped:Connect(function()
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local distance = (player.Character.Head.Position - targetPlayer.Character.Head.Position).Magnitude
            textLabel.Text = targetPlayer.Name .. " [" .. math.floor(distance) .. "m]"
        end
    end)
end

local function toggleESP(state)
    espEnabled = state
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Character then
            if state then
                createESP(plr)
            else
                local head = plr.Character:FindFirstChild("Head")
                if head and head:FindFirstChild("ESP") then
                    head.ESP:Destroy()
                end
            end
        end
    end
end

game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        wait(1)
        if espEnabled then
            createESP(plr)
        end
    end)
end)

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DeltaFlyMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 260)
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
title.Text = "🚀 Delta Fly Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 240, 0, 30)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
end

createButton("Toggle Fly", 50, function() if flying then stopFly() else startFly() end end)
createButton("Toggle Noclip", 90, function() setNoclip(not noclip) end)
createButton("Toggle ESP", 130, function() toggleESP(not espEnabled) end)
createButton("Toggle Gravity", 170, function() toggleGravity(not gravityEnabled) end)
createButton("Close/Open Menu (G)", 210, function() guiVisible = not guiVisible frame.Visible = guiVisible end)

-- G tuşuyla menü aç/kapa
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end
end)