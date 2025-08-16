local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local ESPObjects = {}
local connections = {}

-- 🔴 Arananlar listesi
local wantedList = {
    "Player1",
    "Player2",
    "Player3"
}

-- GUI Oluştur
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MainGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0, 50, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.2
Frame.Active = true
Frame.Draggable = true
Frame.Name = "MainFrame"

-- Kapatma Tuşu
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Toggle Kutucuk
local ESPToggle = Instance.new("TextButton", Frame)
ESPToggle.Size = UDim2.new(0, 200, 0, 40)
ESPToggle.Position = UDim2.new(0, 25, 0, 50)
ESPToggle.Text = "ESP: OFF"
ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPToggle.TextColor3 = Color3.new(1,1,1)

local espEnabled = false
ESPToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPToggle.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
end)

-- Slider (örnek: daire boyutu)
local Slider = Instance.new("TextButton", Frame)
Slider.Size = UDim2.new(0, 200, 0, 40)
Slider.Position = UDim2.new(0, 25, 0, 100)
Slider.Text = "ESP Size: 5"
Slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Slider.TextColor3 = Color3.new(1,1,1)

local espSize = 5
Slider.MouseButton1Click:Connect(function()
    espSize = (espSize % 10) + 1
    Slider.Text = "ESP Size: " .. espSize
end)

-- ESP Fonksiyonu
local function createESP(player)
    if player == localPlayer then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local root = char.HumanoidRootPart
    local billboard = Instance.new("BillboardGui", root)
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.Adornee = root
    billboard.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Text = player.Name

    -- 🔴 Arananlar kırmızı renkte
    if table.find(wantedList, player.Name) then
        nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    else
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
    end

    local circle = Drawing.new("Circle")
    circle.Radius = espSize
    circle.Thickness = 2
    circle.Color = Color3.fromRGB(0, 255, 0)
    circle.Filled = false

    ESPObjects[player] = {circle = circle, gui = billboard}
end

-- ESP Güncelleme
table.insert(connections, RunService.RenderStepped:Connect(function()
    if not espEnabled then
        for _, obj in pairs(ESPObjects) do
            obj.circle.Visible = false
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            if not ESPObjects[player] then
                createESP(player)
            end
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                local obj = ESPObjects[player]
                obj.circle.Position = Vector2.new(pos.X, pos.Y)
                obj.circle.Visible = onScreen
                obj.circle.Radius = espSize
            end
        end
    end
end))

-- K Tuşuyla Tam Kapatma
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.K and not gp then
        if ScreenGui then ScreenGui:Destroy() end
        for _, obj in pairs(ESPObjects) do
            if obj.circle then obj.circle:Remove() end
            if obj.gui then obj.gui:Destroy() end
        end
        ESPObjects = {}
        for _, conn in ipairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        connections = {}
        script:Destroy()
    end
end)