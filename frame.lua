local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

print("Pressione F para capturar o CFrame atual")

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.F then
		local character = player.Character or player.CharacterAdded:Wait()
		local hrp = character:WaitForChild("HumanoidRootPart")

		local cf = hrp.CFrame
		local pos = cf.Position

		local output = string.format(
			"CFrame.new(%.2f, %.2f, %.2f)",
			pos.X, pos.Y, pos.Z
		)

		print("TARGET_CFRAME = " .. output)
	end
end)
