-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Target position
local TARGET_CFRAME = CFrame.new(4995.16, 212.23, 56.85)
local INSTAGRAM_URL = "https://instagram.com/eofallen"

local autoTeleport = false
local minimized = false

-- ===== UI ROOT =====
local gui = Instance.new("ScreenGui")
gui.Name = "FallenAura"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== MAIN FRAME =====
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0.6, -110, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Animated Border
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Parent = frame

-- Border animation
task.spawn(function()
	while true do
		for i = 0, 1, 0.02 do
			stroke.Color = Color3.fromRGB(
				255,
				200 + (55 * i),
				50 * (1 - i)
			)
			task.wait(0.03)
		end
	end
end)

-- ===== TITLE BAR =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "fallen aura"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Minimize Button
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 24, 0, 24)
minimize.Position = UDim2.new(1, -30, 0, 6)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.fromRGB(220,220,220)
minimize.BackgroundTransparency = 1
minimize.Parent = frame

-- ===== CONTENT FRAME =====
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1
content.Parent = frame

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, 0)
divider.BackgroundColor3 = Color3.fromRGB(80,80,80)
divider.Parent = content

-- ===== DRAG (MOUSE + TOUCH) =====
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging then
		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end
end)

-- ===== BUTTON STYLE =====
local function styleButton(btn)
	btn.AutoButtonColor = false
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(230,230,230)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
end

-- ===== BUTTON 1: AUTO TP (ON/OFF) =====
local autoButton = Instance.new("TextButton")
autoButton.Size = UDim2.new(1, -20, 0, 34)
autoButton.Position = UDim2.new(0, 10, 0, 10)
autoButton.Text = "Auto TP: OFF"
autoButton.BackgroundColor3 = Color3.fromRGB(120,60,60)
autoButton.Parent = content
styleButton(autoButton)

autoButton.MouseButton1Click:Connect(function()
	autoTeleport = not autoTeleport

	if autoTeleport then
		autoButton.Text = "Auto TP: ON"
		autoButton.BackgroundColor3 = Color3.fromRGB(60,130,90)
	else
		autoButton.Text = "Auto TP: OFF"
		autoButton.BackgroundColor3 = Color3.fromRGB(120,60,60)
	end
end)

-- ===== BUTTON 2: COPIAR INSTAGRAM =====
local instaButton = Instance.new("TextButton")
instaButton.Size = UDim2.new(1, -20, 0, 34)
instaButton.Position = UDim2.new(0, 10, 0, 52)
instaButton.Text = "Copiar Instagram"
instaButton.BackgroundColor3 = Color3.fromRGB(90,90,120)
instaButton.Parent = content
styleButton(instaButton)

instaButton.MouseButton1Click:Connect(function()
	pcall(function()
		setclipboard(INSTAGRAM_URL)
	end)

	instaButton.Text = "Link Copiado.."
	task.delay(1.5, function()
		instaButton.Text = "Instagram"
	end)
end)

-- ===== MINIMIZE =====
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	content.Visible = not minimized
	minimize.Text = minimized and "+" or "-"
	frame.Size = minimized
		and UDim2.new(0, 220, 0, 40)
		or UDim2.new(0, 220, 0, 150)
end)

-- ===== AUTO TELEPORT LOOP =====
task.spawn(function()
	while true do
		if autoTeleport then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = TARGET_CFRAME
			end
		end
		task.wait(0.15)
	end
end)