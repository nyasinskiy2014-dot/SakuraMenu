-- 🌸 Sakura Menu | Delta / Heno / Skibix iOS

-- ===== GUI PARENT (Skibix-safe) =====
local function getGuiParent()
	local ok, cg = pcall(function()
		return game:GetService("CoreGui")
	end)
	if ok and cg then return cg end

	local ok2, hui = pcall(function()
		return gethui()
	end)
	if ok2 and hui then return hui end

	return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGu
