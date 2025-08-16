local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomMenu"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 600, 0, 300)
main.Position = UDim2.new(0.5, -300, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 4
main.BorderColor3 = Color3.fromRGB(255, 255, 255)

-- Kenar yumuşatma
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 8)

-- Kapatma tuşu
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 120, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local function createSidebarButton(name, y)
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(0, 100, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	btn.Text = name
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

createSidebarButton("Hacks", 20)
createSidebarButton("Settings", 80)

-- İçerik alanı
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -140, 1, -20)
content.Position = UDim2.new(0, 130, 0, 10)
content.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

-- Hile fonksiyonları (örnek)
local function activateHack(name)
	print("Hile açıldı: " .. name)
end

-- Checkbox sistemi
local function createOption(name, y)
	local label = Instance.new("TextLabel", content)
	label.Size = UDim2.new(0, 100, 0, 30)
	label.Position = UDim2.new(0, 10, 0, y)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 20
	label.Text = name

	local box = Instance.new("TextButton", content)
	box.Size = UDim2.new(0, 30, 0, 30)
	box.Position = UDim2.new(0, 120, 0, y)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(0, 255, 0)
	box.Font = Enum.Font.SourceSansBold
	box.TextSize = 24
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

	local toggled = false
	box.MouseButton1Click:Connect(function()
		toggled = not toggled
		box.Text = toggled and "✓" or ""
		if toggled then
			activateHack(name)
		end
	end)
end

createOption("FLY", 10)
createOption("ESP", 50)
createOption("NO GRA.", 90)
createOption("NOCLIP", 130)

-- Slider sistemi
local function createSlider(name, y)
	local label = Instance.new("TextLabel", content)
	label.Size = UDim2.new(0, 100, 0, 30)
	label.Position = UDim2.new(0, 10, 0, y)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 18
	label.Text = name .. ": 50"

	local bar = Instance.new("Frame", content)
	bar.Size = UDim2.new(0, 200, 0, 6)
	bar.Position = UDim2.new(0, 120, 0, y + 12)
	bar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)

	local knob = Instance.new("Frame", bar)
	knob.Size = UDim2.new(0, 10, 0, 20)
	knob.Position = UDim2.new(0.25, 0, -0.5, 0)
	knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	knob.BorderSizePixel = 0
	knob.Name = "Knob"
	knob.Active = true
	knob.Draggable = true
	Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 5)

	local dragging = false
	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	knob.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	game:GetService("RunService").RenderStepped:Connect(function()
		if dragging then
			local relX = math.clamp(mouse.X - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
			local percent = relX / bar.AbsoluteSize.X
			knob.Position = UDim2.new(percent, -5, -0.5, 0)
			label.Text = name .. ": " .. math.floor(percent * 100)
		end
	end)
end

createSlider("Speed", 180)
createSlider("Jump Speed", 220)