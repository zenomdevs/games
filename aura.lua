-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- Target position
local TARGET_CFRAME = CFrame.new(3890, 210.46, 39.72)

-- State
local autoTeleport = false

-- ===== UI ROOT =====
local gui = Instance.new("ScreenGui")
gui.Name = "FallenAura"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Blur (glass effect)
local blur = Instance.new("BlurEffect")
blur.Size = 14
blur.Parent = Lighting

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 170)
frame.Position = UDim2.new(0.6, -120, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90, 90, 90)
stroke.Thickness = 1
stroke.Transparency = 0.3
stroke.Parent = frame

-- ===== TITLE =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "fallen aura"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, 42)
divider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
divider.BackgroundTransparency = 0.7
divider.BorderSizePixel = 0
divider.Parent = frame

-- ===== DRAG SYSTEM =====
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- ===== TELEPORT LOGIC =====
local function teleport()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	hrp.CFrame = TARGET_CFRAME
end

task.spawn(function()
	while true do
		if autoTeleport then
			teleport()
		end
		task.wait(0.1)
	end
end)

-- ===== BUTTON STYLE FUNCTION =====
local function styleButton(btn)
	btn.AutoButtonColor = false
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(230, 230, 230)
	btn.BorderSizePixel = 0

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = btn

	btn.MouseEnter:Connect(function()
		btn.BackgroundTransparency = 0.1
	end)

	btn.MouseLeave:Connect(function()
		btn.BackgroundTransparency = 0
	end)
end

-- ===== BUTTONS =====
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(1, -20, 0, 36)
tpButton.Position = UDim2.new(0, 10, 0, 55)
tpButton.Text = "Auto Once"
tpButton.BackgroundColor3 = Color3.fromRGB(60, 120, 90)
tpButton.Parent = frame
styleButton(tpButton)

tpButton.MouseButton1Click:Connect(teleport)

local autoButton = Instance.new("TextButton")
autoButton.Size = UDim2.new(1, -20, 0, 36)
autoButton.Position = UDim2.new(0, 10, 0, 100)
autoButton.Text = "Teleporte: OFF"
autoButton.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
autoButton.Parent = frame
styleButton(autoButton)

autoButton.MouseButton1Click:Connect(function()
	autoTeleport = not autoTeleport

	if autoTeleport then
		autoButton.Text = "Teleporte: ON"
		autoButton.BackgroundColor3 = Color3.fromRGB(60, 130, 90)
	else
		autoButton.Text = "Teleporte: OFF"
		autoButton.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
	end
end)
