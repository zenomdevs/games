-- =========================================
-- BATTLE MINI HUB | DELTA / EXECUTOR SAFE
-- =========================================

-- ===== SAFE EXEC =====
local function safe(f) pcall(f) end
print("Battle Hub carregando..")

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
repeat task.wait() until LP.Character
local Char = LP.Character
local Hum = Char:WaitForChild("Humanoid")
local Root = Char:WaitForChild("HumanoidRootPart")

-- ===== GUI PARENT (DELTA SAFE) =====
local GuiParent
safe(function()
	GuiParent = gethui()
end)
if not GuiParent then
	safe(function()
		GuiParent = game:GetService("CoreGui")
	end)
end
if not GuiParent then return end

-- ===== STATE =====
local UI_OPEN = true
local KillAura = false
local KillAll = false
local SpinBot = false
local GodMode = false

local AuraRange = 30

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "BattleHub"
gui.IgnoreGuiInset = true
gui.Parent = GuiParent

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(260, 260)
main.Position = UDim2.fromScale(0.4, 0.3)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- ===== DRAG =====
do
	local dragging, startPos, startInput
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startPos = main.Position
			startInput = i.Position
		end
	end)
	main.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - startInput
			main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- ===== TITLE =====
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "⚔ Battle Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(240,240,240)

-- ===== BUTTON FACTORY =====
local function mkButton(text, y)
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

local auraBtn = mkButton("Kill Aura", 50)
local killBtn = mkButton("Kill All", 90)
local spinBtn = mkButton("Spin Bot", 130)
local godBtn  = mkButton("God Mode", 170)

-- ===== TOGGLE =====
local function toggle(btn, var)
	_G[var] = not _G[var]
	btn.Text = var .. ": " .. (_G[var] and "ON" or "OFF")
	btn.BackgroundColor3 = _G[var] and Color3.fromRGB(20,120,60) or Color3.fromRGB(35,35,35)
end

auraBtn.MouseButton1Click:Connect(function() toggle(auraBtn,"KillAura") end)
killBtn.MouseButton1Click:Connect(function() toggle(killBtn,"KillAll") end)
spinBtn.MouseButton1Click:Connect(function() toggle(spinBtn,"SpinBot") end)
godBtn.MouseButton1Click:Connect(function() toggle(godBtn,"GodMode") end)

-- ===== KEYBIND =====
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		UI_OPEN = not UI_OPEN
		main.Visible = UI_OPEN
	end
end)

-- ===== COMBAT CORE =====
local function AutoClick()
	VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	task.wait()
	VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end

local function PullAndHit(plr)
	local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	hrp.CFrame = Root.CFrame * CFrame.new(0,0,-3)
	AutoClick()
end

-- ===== LOOP =====
RunService.Heartbeat:Connect(function()
	if GodMode and Hum then
		Hum.MaxHealth = math.huge
		Hum.Health = math.huge
	end

	if SpinBot then
		Root.CFrame *= CFrame.Angles(0, math.rad(40), 0)
	end

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Humanoid") then
			local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
			if hrp and (hrp.Position - Root.Position).Magnitude <= AuraRange then
				if KillAura or KillAll then
					PullAndHit(plr)
				end
			end
		end
	end
end)

-- ===== NOTIFY =====
safe(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Battle Hub",
		Text = "Script carregado (RightShift)",
		Duration = 5
	})
end)

print("Battle Hub carregado com sucesso.")