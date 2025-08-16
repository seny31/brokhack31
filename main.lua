local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flyActive = false
local noclipActive = false
local bodyVelocity

local mouse = player:GetMouse()
local rightClick = false

-- Fly fonksiyonları
local function startFly()
    if bodyVelocity then bodyVelocity:Destroy() end
    bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    humanoid.PlatformStand = true
end

local function stopFly()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    humanoid.PlatformStand = false
end

-- Noclip fonksiyonları
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

-- GUI oluştur
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "FlyNoclipMenu"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false -- Draggable devre dışı, kendi sürükleme scriptimiz var

local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,20)

local title = Instance.new("TextLabel", titleBar)
title.Text = "Fly & Noclip Menu"
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22
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

local function createOption(text, parent, y)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -20, 0, 40)
    container.Position = UDim2.new(0, 10, 0, y)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Text = text
    label.Size = UDim2.new(1, -40, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left

    local checkbox = Instance.new("TextButton", container)
    checkbox.Size = UDim2.new(0, 30, 0, 30)
    checkbox.Position = UDim2.new(1, -35, 0, 5)
    checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    checkbox.BorderSizePixel = 0
    checkbox.Text = ""

    local tick = Instance.new("TextLabel", checkbox)
    tick.Text = "✓"
    tick.Size = UDim2.new(1, 0, 1, 0)
    tick.BackgroundTransparency = 1
    tick.TextColor3 = Color3.fromRGB(100, 255, 100)
    tick.Font = Enum.Font.GothamBold
    tick.TextSize = 26
    tick.Visible = false

    return checkbox, tick
end

local flyCheckbox, flyTick = createOption("Fly", content, 0)
local noclipCheckbox, noclipTick = createOption("Noclip", content, 50)

-- Menü sürükleme kodu (sınır yok)
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
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

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

-- Fly toggle fonksiyonu
local function toggleFly(state)
    flyActive = state
    flyTick.Visible = state
    if state then
        startFly()
    else
        stopFly()
    end
end

flyCheckbox.MouseButton1Click:Connect(function()
    toggleFly(not flyActive)
end)

-- Noclip toggle fonksiyonu
local function toggleNoclip(state)
    noclipActive = state
    noclipTick.Visible = state
end

noclipCheckbox.MouseButton1Click:Connect(function()
    toggleNoclip(not noclipActive)
end)

-- Sağ tıklama dinle
mouse.Button2Down:Connect(function()
    rightClick = true
    if flyActive then startFly() end
end)

mouse.Button2Up:Connect(function()
    rightClick = false
    if flyActive then stopFly() end
end)

-- Her frame güncellemesi
RunService.Heartbeat:Connect(function()
    if flyActive and bodyVelocity and rightClick then
        -- Fare pozisyonu ve karakterin root pozisyonu
        local mousePos = mouse.Hit.p
        local rootPos = rootPart.Position

        -- Yatayda (Y ekseni sabit) fare yönüne vektör
        local direction = (Vector3.new(mousePos.X, rootPos.Y, mousePos.Z) - rootPos).Unit

        -- Karakteri bu yöne döndür
        rootPart.CFrame = CFrame.new(rootPos, rootPos + direction)

        -- Uçuş hızı
        bodyVelocity.Velocity = direction * 100

    elseif flyActive and bodyVelocity then
        -- Sağ tıklama yoksa durdur
        bodyVelocity.Velocity = Vector3.new(0,0,0)
    end

    -- Noclip uygulama
    if noclipActive then
        noclipOn()
    else
        noclipOff()
    end
end)
