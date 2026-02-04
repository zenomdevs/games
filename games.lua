-- =====================================
-- REMOTE INSPECTOR | BATTLE MINIGAMES
-- =====================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

print("=== REMOTE INSPECTOR INICIADO ===")

-- ===============================
-- UTIL
-- ===============================
local function safePrint(...)
	pcall(function()
		print(...)
	end)
end

-- ===============================
-- LISTAR REMOTES EXISTENTES
-- ===============================
safePrint(">> Scanning ReplicatedStorage...")

for _,obj in ipairs(RS:GetDescendants()) do
	if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
		safePrint("[REMOTE FOUND]", obj.ClassName, obj:GetFullName())
	end
end

-- ===============================
-- HOOK __namecall (FireServer / InvokeServer)
-- ===============================
local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = {...}

	if method == "FireServer" or method == "InvokeServer" then
		if typeof(self) == "Instance" then
			if self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
				safePrint(" ")
				safePrint("🔥 REMOTE CALL DETECTED")
				safePrint("Name:", self.Name)
				safePrint("Path:", self:GetFullName())
				safePrint("Method:", method)
				safePrint("Args:", unpack(args))
				safePrint("Caller:", debug.traceback())
			end
		end
	end

	return oldNamecall(self, ...)
end)

-- ===============================
-- LOG CLIENT EVENTS (OnClientEvent)
-- ===============================
for _,obj in ipairs(RS:GetDescendants()) do
	if obj:IsA("RemoteEvent") then
		obj.OnClientEvent:Connect(function(...)
			safePrint(" ")
			safePrint("📩 SERVER → CLIENT EVENT")
			safePrint("Remote:", obj:GetFullName())
			safePrint("Args:", ...)
		end)
	end
end

safePrint("=== REMOTE INSPECTOR PRONTO ===")
safePrint("Agora jogue normalmente e observe o console.")