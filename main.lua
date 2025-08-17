local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local espEnabled = true
local guiEnabled = true
local espTags = {}

-- GUI Menü
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "ESPMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "ESP Menü"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(1, -20, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 40)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Text = "ESP: ON"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.BorderSizePixel = 0
toggleButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	toggleButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	for _, tag in pairs(espTags) do
		tag.Enabled = espEnabled
	end
end)

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(1, -20, 0, 30)
closeButton.Position = UDim2.new(0, 10, 0, 80)
closeButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "Scripti Kapat"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.BorderSizePixel = 0
closeButton.MouseButton1Click:Connect(function()
	guiEnabled = false
	screenGui:Destroy()
	for _, tag in pairs(espTags) do
		tag:Destroy()
	end
end)

-- ESP GUI Oluştur
local function createESP(player)
	if espTags[player] then return end

	local function tryCreate()
		if not player.Character or not player.Character:FindFirstChild("Head") then return end

		local billboard = Instance.new("BillboardGui")
		billboard.Name = "ESPTag"
		billboard.Adornee = player.Character.Head
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 2, 0)
		billboard.AlwaysOnTop = true
		billboard.Enabled = espEnabled
		billboard.Parent = player.Character.Head

		local nameLabel = Instance.new("TextLabel", billboard)
		nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.new(1, 1, 1)
		nameLabel.TextStrokeTransparency = 0
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextSize = 16
		nameLabel.Text = player.Name

		local wantedLabel = Instance.new("TextLabel", billboard)
		wantedLabel.Size = UDim2.new(1, 0, 0.5, 0)
		wantedLabel.Position = UDim2.new(0, 0, 0.5, 0)
		wantedLabel.BackgroundTransparency = 1
		wantedLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		wantedLabel.TextStrokeTransparency = 0
		wantedLabel.Font = Enum.Font.GothamBold
		wantedLabel.TextSize = 16
		wantedLabel.Text = ""

		-- WANTED kontrolü
		local wd = player:FindFirstChild("PlayerScripts") and player.PlayerScripts:FindFirstChild("Code") and player.PlayerScripts.Code:FindFirstChild("producer") and player.PlayerScripts.Code.producer:FindFirstChild("wantedData")
		if wd and tostring(wd.Value) == "true" or tostring(wd.Value) == "1" then
			wantedLabel.Text = "WANTED"
		end

		espTags[player] = billboard
	end

	-- Karakter hazır değilse bekle
	if not player.Character or not player.Character:FindFirstChild("Head") then
		player.CharacterAdded:Connect(function()
			repeat wait() until player.Character and player.Character:FindFirstChild("Head")
			tryCreate()
		end)
	else
		tryCreate()
	end
end

-- Oyunculara ESP ekle
for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		createESP(player)
	end
end

Players.PlayerAdded:Connect(function(player)
	if player ~= LocalPlayer then
		player.CharacterAdded:Connect(function()
			wait(1)
			createESP(player)
		end)
	end
end)