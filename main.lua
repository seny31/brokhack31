local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
end)

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomMenu"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 600, 0, 300)
main.Position = UDim2.new(0.5, -300, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 4
main.BorderColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

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
end

createSidebarButton("Hacks", 20)
createSidebarButton("Settings", 80)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -140, 1, -20)
content.Position = UDim2.new(0, 130, 0, 10)
content.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

local toggles = {
	FLY = false,
	NOCLIP = false,
	ESP = false,
	["NO GRA."] = false
}
local flySpeed = 50
local bodyGyro, bodyVelocity

-- FLY
local function enableFly()
	if not character:FindFirstChild("HumanoidRootPart") then return end
	character.Humanoid.PlatformStand = true
	bodyGyro = Instance.new("BodyGyro", character.HumanoidRootPart)
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.CFrame = character.HumanoidRootPart.CFrame

	bodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart)
	bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
	bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
end

local function disableFly()
	character.Humanoid.PlatformStand = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
end

-- NOCLIP
RunService.Stepped:Connect(function()
	if toggles.NOCLIP and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- ESP
local function toggleESP(state)
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
			if state then
				local gui = Instance.new("BillboardGui", plr.Character)
				gui.Name = "ESPTag"
				gui.Size = UDim2.new(0, 100, 0, 50)
				gui.Adornee = plr.Character.Head
				gui.AlwaysOnTop = true

				local circle = Instance.new("ImageLabel", gui)
				circle.Name = "ESPCircle"
				circle.Size = UDim2.new(0, 50, 0, 50)
				circle.BackgroundTransparency = 1
				circle.Image = "rbxassetid://200527618"
				circle.ImageColor3 = Color3.fromRGB(255, 0, 0)

				local label = Instance.new("TextLabel", gui)
				label.Size = UDim2.new(1, 0, 0, 20)
				label.Position = UDim2.new(0, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.TextColor3 = Color3.fromRGB(255, 255, 255)
				label.Font = Enum.Font.SourceSansBold
				label.TextSize = 14

				RunService.RenderStepped:Connect(function()
					if plr.Character and plr.Character:FindFirstChild("Head") then
						local dist = (plr.Character.Head.Position - character.Head.Position).Magnitude
						label.Text = plr.Name .. " | Mesafe: " .. math.floor(dist)
					end
				end)
			else
				if plr.Character:FindFirstChild("ESPTag") then
					plr.Character.ESPTag:Destroy()
				end
			end
		end
	end
end

-- Hile güncelleme
local function updateHack(name, state)
	toggles[name] = state
	if name == "FLY" then state and enableFly() or disableFly()
	elseif name == "NOCLIP" then -- handled in Stepped
	elseif name == "ESP" then toggleESP(state)
	elseif name == "NO GRA." then game.Workspace.Gravity = state and 0 or 196.2
	end
end

-- Kutucuklar
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

	box.MouseButton1Click:Connect(function()
		toggles[name] = not toggles[name]
		box.Text = toggles[name] and "✓" or ""
		updateHack(name, toggles[name])
	end)
end

createOption("FLY", 10)
createOption("ESP", 50)
createOption("NO GRA.", 90)
createOption("NO