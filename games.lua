-- =============================
-- CONFIGURAÇÕES
-- =============================
local MatchLength = 60
local IntermissionLength = 20

-- =============================
-- SERVIÇOS
-- =============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- =============================
-- STATUS
-- =============================
local AutomationEnabled = false
local GameActive = false
local MainLoopRunning = false

-- =============================
-- UI DA GUI
-- =============================
local gui = Instance.new("ScreenGui")
gui.Name = "BattleUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromScale(0.22, 0.18)
main.Position = UDim2.fromScale(0.39, 0.4)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
main.BackgroundTransparency = 0.12
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Titulo
local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1, 0.25)
title.BackgroundTransparency = 1
title.Text = "⚔ BATTLE MINI"
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = main

-- Toggle Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromScale(0.85, 0.3)
toggle.Position = UDim2.fromScale(0.075, 0.33)
toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggle.Text = "Ativar"
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.Gotham
toggle.TextScaled = true
toggle.Parent = main
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.fromScale(1, 0.18)
status.Position = UDim2.fromScale(0, 0.68)
status.BackgroundTransparency = 1
status.Text = "Status: OFF"
status.TextColor3 = Color3.fromRGB(160, 160, 160)
status.Font = Enum.Font.Gotham
status.TextScaled = true
status.Parent = main

-- =============================
-- GAME LOOP
-- =============================
local function StartMainLoop()
	if MainLoopRunning then return end
	MainLoopRunning = true

	task.spawn(function()
		while AutomationEnabled do
			-- Intermission
			GameActive = false
			for i = IntermissionLength, 1, -1 do
				if not AutomationEnabled then break end
				status.Text = "Intermission: " .. i
				task.wait(1)
			end
			if not AutomationEnabled then break end

			-- Match
			GameActive = true
			for i = MatchLength, 1, -1 do
				if not AutomationEnabled then break end
				status.Text = "Batalha: " .. i
				task.wait(1)
			end

			GameActive = false
			status.Text = "Round finalizado"
			task.wait(2)
		end

		status.Text = "Status: OFF"
		MainLoopRunning = false
	end)
end

-- =============================
-- BUTTON LOGIC
-- =============================
toggle.MouseButton1Click:Connect(function()
	AutomationEnabled = not AutomationEnabled

	if AutomationEnabled then
		toggle.Text = "Desativar"
		toggle.BackgroundColor3 = Color3.fromRGB(20, 120, 60)
		status.Text = "Iniciando.."
		StartMainLoop()
	else
		toggle.Text = "Ativar"
		toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
end)