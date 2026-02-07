local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local label = Instance.new("TextLabel", gui)
label.Size = UDim2.new(0, 500, 0, 40)
label.Position = UDim2.new(0.5, -250, 0.9, 0)
label.BackgroundTransparency = 0.3
label.BackgroundColor3 = Color3.fromRGB(20,20,20)
label.TextColor3 = Color3.fromRGB(220,220,220)
label.Font = Enum.Font.Code
label.TextSize = 16
label.Text = "Aguardando personagem..."

RunService.RenderStepped:Connect(function()
	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local p = hrp.Position
	label.Text = string.format(
		"CFrame.new(%.2f, %.2f, %.2f)",
		p.X, p.Y, p.Z
	)
end)
