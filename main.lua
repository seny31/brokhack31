local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")

-- 🛡️ Anti-Ban Başlat
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" or method == "InvokeServer" then
        local name = tostring(self)
        if string.find(name:lower(), "ban") or string.find(name:lower(), "kick") or string.find(name:lower(), "log") or string.find(name:lower(), "report") then
            warn("⛔ Anti-Ban engelledi: " .. name)
            return nil
        end
    end

    return old(self, ...)
end)

LP.Kick = function() return nil end
hookfunction(LP.Kick, function() return nil end)
pcall(function()
    game:GetService("CoreGui"):WaitForChild("RobloxPromptGui"):Destroy()
end)

-- ⚡ Speed Hack GUI
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "ArdaSpeedAntiBan"

local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 240, 0, 160)
f.Position = UDim2.new(0.5, -120, 0.5, -80)
f.BackgroundColor3 = Color3.fromRGB(30,30,30)
f.Active = true f.Draggable = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", f)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Speed Hack + Anti-Ban"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local slider = Instance.new("TextBox", f)
slider.Size = UDim2.new(0.8, 0, 0, 30)
slider.Position = UDim2.new(0.1, 0, 0.4, 0)
slider.PlaceholderText = "Hız gir (örn: 100)"
slider.TextColor3 = Color3.new(1,1,1)
slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
slider.Font = Enum.Font.Gotham
slider.TextSize = 14
Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 8)

local btn = Instance.new("TextButton", f)
btn.Size = UDim2.new(0.8, 0, 0, 30)
btn.Position = UDim2.new(0.1, 0, 0.7, 0)
btn.Text = "Uygula"
btn.BackgroundColor3 = Color3.fromRGB(60,200,100)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.Gotham
btn.TextSize = 14
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

btn.MouseButton1Click:Connect(function()
    local speed = tonumber(slider.Text)
    if speed and Humanoid then
        Humanoid.WalkSpeed = speed
        btn.Text = "✅ " .. speed .. " aktif"
        wait(2)
        btn.Text = "Uygula"
    end
end)

local x = Instance.new("TextButton", f)
x.Size = UDim2.new(0, 24, 0, 24)
x.Position = UDim2.new(1, -28, 0, 4)
x.Text = "✕"
x.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
x.TextColor3 = Color3.new(1,1,1)
x.Font = Enum.Font.GothamBold
x.TextSize = 14
Instance.new("UICorner", x).CornerRadius = UDim.new(0, 6)
x.MouseButton1Click:Connect(function()
    gui:Destroy()
end)