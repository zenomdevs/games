-- ===============================
-- BATTLE HUB - EXECUTOR SCRIPT
-- ===============================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
repeat task.wait() until LP.Character
local Char = LP.Character
local Hum = Char:WaitForChild("Humanoid")
local Root = Char:WaitForChild("HumanoidRootPart")

-- CoreGui support (executor-safe)
local CoreGui = game:GetService("CoreGui")
local ParentGui = gethui and gethui() or CoreGui

-- ===============================
-- STATE
-- ===============================
local UI_OPEN = true
local KillAura = false
local SpinBot = false
local KillAll = false
local GodMode = false

-- ===============================
-- UI
-- ===============================
local gui = Instance.new("ScreenGui")
gui.Name = "BattleHub"
gui.Parent = ParentGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(260, 230)
main.Position = UDim2.fromScale(0.4, 0.35)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Drag
do
	local dragging, dragInput, startPos, startInput
	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startPos = main.Position
			startInput = input.Position
		end
	end)

	main.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - startInput
			main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "⚔ Battle Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(240,240,240)

-- Button creator
local function Button(text, y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0.9,0,0,32)
	b.Position = UDim2.new(0.05,0,0,y)
	b.Text = text .. ": OFF"
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	return b
end

local auraBtn = Button("Kill Aura", 50)
local spinBtn = Button("Spin Bot", 90)
local killBtn = Button("Kill All", 130)
local godBtn  = Button("God Mode", 170)

-- ===============================
-- BUTTON LOGIC
-- ===============================
local function toggle(btn, stateName)
	_G[stateName] = not _G[stateName]
	btn.Text = stateName .. ": " .. (_G[stateName] and "ON" or "OFF")
	btn.BackgroundColor3 = _G[stateName] and Color3.fromRGB(20,120,60) or Color3.fromRGB(35,35,35)
end

auraBtn.MouseButton1Click:Connect(function() toggle(auraBtn, "KillAura") end)
spinBtn.MouseButton1Click:Connect(function() toggle(spinBtn, "SpinBot") end)
killBtn.MouseButton1Click:Connect(function() toggle(killBtn, "KillAll") end)
godBtn.MouseButton1Click:Connect(function() toggle(godBtn, "GodMode") end)

-- ===============================
-- KEYBIND (OPEN / CLOSE)
-- ===============================
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		UI_OPEN = not UI_OPEN
		main.Visible = UI_OPEN
	end
end)

-- ===============================
-- LOGIC LOOP
-- ===============================
RunService.Heartbeat:Connect(function()
	if not Char or not Hum then return end

	-- GodMode
	if GodMode then
		Hum.Health = Hum.MaxHealth
	end

	-- SpinBot
	if SpinBot then
		Root.CFrame *= CFrame.Angles(0, math.rad(25), 0)
	end

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Humanoid") then
			local h = plr.Character.Humanoid
			local r = plr.Character:FindFirstChild("HumanoidRootPart")
			if r and (r.Position - Root.Position).Magnitude < 12 then
				if KillAura then
					h.Health = 0
				end
				if KillAll then
					h.Health = 0
				end
			end
		end
	end
end)