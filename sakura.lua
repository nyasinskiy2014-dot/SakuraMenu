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

	return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

if getgenv().SakuraLoaded then return end
getgenv().SakuraLoaded = true

local GUI_PARENT = getGuiParent()

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "SakuraMenu"
pcall(function() gui.Parent = GUI_PARENT end)
pcall(function() if protect_gui then protect_gui(gui) end end)

-- OPEN BUTTON
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(36,36)
openBtn.Position = UDim2.new(1,-46,0,12)
openBtn.Text = "■"
openBtn.BackgroundColor3 = Color3.fromRGB(255,170,190)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Visible = false
Instance.new("UICorner", openBtn)

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(430,270)
main.Position = UDim2.new(0.5,-215,0.5,-135)
main.BackgroundColor3 = Color3.fromRGB(255,220,230)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,-40,0,40)
title.Position = UDim2.fromOffset(12,4)
title.Text = "🌸 Sakura Menu"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(120,60,80)

-- CLOSE
local close = Instance.new("TextButton", main)
close.Size = UDim2.fromOffset(30,30)
close.Position = UDim2.new(1,-36,0,6)
close.Text = "✖"
close.BackgroundTransparency = 1
close.TextColor3 = Color3.fromRGB(120,60,80)

close.MouseButton1Click:Connect(function()
	main.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	main.Visible = true
	openBtn.Visible = false
end)

-- ===== ACTIVE =====
local fly = false
local flySpeed = 60

local flyBtn = Instance.new("TextButton", main)
flyBtn.Size = UDim2.fromOffset(180,32)
flyBtn.Position = UDim2.fromOffset(20,60)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(255,170,190)
flyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", flyBtn)

flyBtn.MouseButton1Click:Connect(function()
	fly = not fly
	flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
end)

RunService.RenderStepped:Connect(function()
	if fly then
		root.Velocity = hum.MoveDirection * flySpeed
	end
end)

-- ===== VISUAL (ESP) =====
local esp = false
local highlights = {}

local espBtn = Instance.new("TextButton", main)
espBtn.Size = UDim2.fromOffset(180,32)
espBtn.Position = UDim2.fromOffset(20,105)
espBtn.Text = "ESP"
espBtn.BackgroundColor3 = Color3.fromRGB(255,170,190)
espBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espBtn)

local function toggleESP(state)
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			if state then
				if not highlights[plr] then
					local h = Instance.new("Highlight")
					h.FillTransparency = 1
					h.OutlineColor = Color3.fromRGB(255,120,160)
					h.Parent = plr.Character
					highlights[plr] = h
				end
			else
				if highlights[plr] then
					highlights[plr]:Destroy()
					highlights[plr] = nil
				end
			end
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	toggleESP(esp)
end)

-- ===== DO =====
local txt = Instance.new("TextLabel", main)
txt.Size = UDim2.fromOffset(200,40)
txt.Position = UDim2.fromOffset(20,150)
txt.BackgroundTransparency = 1
txt.Text = "🚧 В разработке"
txt.TextScaled = true
txt.TextColor3 = Color3.fromRGB(120,60,80)
