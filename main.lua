local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50

local bv
local bg

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Fly fonksiyonu (değişmedi)
local function startFly()
    if flying then return end
    flying = true
    bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.new(0,0,0)

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

-- Hareket güncelleme (değişmedi)
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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyMenu"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = ScreenGui
frame.Active = true
frame.Draggable = true

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 150, 0, 40)
label.Position = UDim2.new(0, 40, 0, 20)
label.BackgroundTransparency = 1
label.Text = "Fly"
label.TextColor3 = Color3.fromRGB(200, 200, 200)
label.Font = Enum.Font.GothamBold
label.TextSize = 28
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = frame

local checkbox = Instance.new("TextButton")
checkbox.Size = UDim2.new(0, 30, 0, 30)
checkbox.Position = UDim2.new(0, 5, 0, 20)
checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
checkbox.Text = ""
checkbox.TextColor3 = Color3.new(0,0,0)
checkbox.Font = Enum.Font.SourceSansBold
checkbox.TextSize = 24
checkbox.Parent = frame

local function updateCheckbox()
    if flying then
        checkbox.Text = "✔"
        checkbox.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        checkbox.Text = ""
        checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end

checkbox.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
    updateCheckbox()
end)

updateCheckbox()
