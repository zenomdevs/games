local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CFrameSaver"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(90,90,90)
stroke.Transparency = 0.3

-- Output (SEM alignment)
local output = Instance.new("TextLabel")
output.Parent = frame
output.Size = UDim2.new(1, -20, 0, 70)
output.Position = UDim2.new(0, 10, 0, 10)
output.BackgroundTransparency = 1
output.TextWrapped = true
output.Text = "Clique em SALVAR POSIÇÃO"
output.Font = Enum.Font.Code
output.TextSize = 14
output.TextColor3 = Color3.fromRGB(220,220,220)

-- Botão
local button = Instance.new("TextButton")
button.Parent = frame
button.Size = UDim2.new(1, -20, 0, 36)
button.Position = UDim2.new(0, 10, 1, -46)
button.Text = "SALVAR POSIÇÃO"
button.Font = Enum.Font.GothamMedium
button.TextSize = 14
button.TextColor3 = Color3.fromRGB(230,230,230)
button.BackgroundColor3 = Color3.fromRGB(60,130,90)
button.BorderSizePixel = 0

local btnCorner = Instance.new("UICorner", button)
btnCorner.CornerRadius = UDim.new(0, 8)

-- Função
button.MouseButton1Click:Connect(function()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local p = hrp.Position
	local text = string.format(
		"TARGET_CFRAME = CFrame.new(%.2f, %.2f, %.2f)",
		p.X, p.Y, p.Z
	)

	output.Text = text

	-- Copiar se possível
	pcall(function()
		setclipboard(text)
	end)
end)
