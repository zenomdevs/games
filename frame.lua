local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local lastPos

print("📍 CFrame Tracker iniciado")

RunService.Heartbeat:Connect(function()
	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local p = hrp.Position

	-- só imprime se mudou de posição
	if not lastPos or (p - lastPos).Magnitude > 0.5 then
		lastPos = p

		print(string.format(
			"TARGET_CFRAME = CFrame.new(%.2f, %.2f, %.2f)",
			p.X, p.Y, p.Z
		))
	end
end)
