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
local uis = game:GetService("UserInputService")

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "SakuraMenu"
pcall(function() gui.Parent = GUI_PARENT end)
pcall(function() if protect_gui then protect_gui(gui) end end)

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

-- CLOSE BUTTON
local close = Instance.new("TextButton", main)
close.Size = UDim2.fromOffset(30,30)
close.Position = UDim2.new(1,-36,0,6)
close.Text = "✖"
close.BackgroundTransparency = 1
close.TextColor3 = Color3.fromRGB(120,60,80)

-- OPEN BUTTON (Sakura icon)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(36,36)
openBtn.Position = UDim2.new(1,-46,0,12)
openBtn.Text = "🌸"
openBtn.BackgroundColor3 = Color3.fromRGB(255,170,190)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Visible = false
Instance.new("UICorner", openBtn)

close.MouseButton1Click:Connect(function()
	main.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	main.Visible = true
	openBtn.Visible = false
end)

-- ===== ACTIVE (Fly с регулировкой скорости) =====
local fly = false
local flySpeed = 50

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

-- Fly Speed Slider
local flyLabel = Instance.new("TextLabel", main)
flyLabel.Size = UDim2.fromOffset(180,20)
flyLabel.Position = UDim2.fromOffset(20,95)
flyLabel.BackgroundTransparency = 1
flyLabel.TextColor3 = Color3.fromRGB(120,60,80)
flyLabel.TextScaled = true
flyLabel.Text = "Speed: "..flySpeed

local flySlider = Instance.new("TextBox", main)
flySlider.Size = UDim2.fromOffset(180,20)
flySlider.Position = UDim2.fromOffset(20,115)
flySlider.BackgroundColor3 = Color3.fromRGB(255,200,220)
flySlider.TextColor3 = Color3.new(1,1,1)
flySlider.Text = tostring(flySpeed)
Instance.new("UICorner", flySlider)

flySlider.FocusLost:Connect(function()
	local val = tonumber(flySlider.Text)
	if val and val >= 1 and val <= 100 then
		flySpeed = val
		flyLabel.Text = "Speed: "..flySpeed
	else
		flySlider.Text = tostring(flySpeed)
	end
end)

-- BodyVelocity для Fly
local vel = Instance.new("BodyVelocity")
vel.MaxForce = Vector3.new(1e5,1e5,1e5)
vel.Velocity = Vector3.new(0,0,0)
vel.Parent = root
vel.Enabled = false

RunService.RenderStepped:Connect(function()
	if fly then
		vel.Enabled = true
		local dir = Vector3.new(0,0,0)
		if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + root.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - root.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - root.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + root.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
		if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
		if dir.Magnitude > 0 then
			vel.Velocity = dir.Unit * flySpeed
		else
			vel.Velocity = Vector3.new(0,0,0)
		end
	else
		vel.Enabled = false
	end
end)

-- ===== VISUAL (ESP) =====
local esp = false
local highlights = {}

local espBtn = Instance.new("TextButton", main)
espBtn.Size = UDim2.fromOffset(180,32)
espBtn.Position = UDim2.fromOffset(20,145)
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

-- ===== HIGH JUMP =====
local highJump = false
local jumpPower = 50

local jumpBtn = Instance.new("TextButton", main)
jumpBtn.Size = UDim2.fromOffset(180,32)
jumpBtn.Position = UDim2.fromOffset(20,190)
jumpBtn.Text = "High Jump: OFF"
jumpBtn.BackgroundColor3 = Color3.fromRGB(255,180,200)
jumpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", jumpBtn)

jumpBtn.MouseButton1Click:Connect(function()
	highJump = not highJump
	jumpBtn.Text = highJump and "High Jump: ON" or "High Jump: OFF"
end)

local jumpLabel = Instance.new("TextLabel", main)
jumpLabel.Size = UDim2.fromOffset(180,20)
jumpLabel.Position = UDim2.fromOffset(20,225)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.fromRGB(120,60,80)
jumpLabel.TextScaled = true
jumpLabel.Text = "Power: "..jumpPower

local jumpSlider = Instance.new("TextBox", main)
jumpSlider.Size = UDim2.fromOffset(180,20)
jumpSlider.Position = UDim2.fromOffset(20,245)
jumpSlider.BackgroundColor3 = Color3.fromRGB(255,200,220)
jumpSlider.TextColor3 = Color3.new(1,1,1)
jumpSlider.Text = tostring(jumpPower)
Instance.new("UICorner", jumpSlider)

jumpSlider.FocusLost:Connect(function()
	local val = tonumber(jumpSlider.Text)
	if val and val >= 1 and val <= 100 then
		jumpPower = val
		jumpLabel.Text = "Power: "..jumpPower
	else
		jumpSlider.Text = tostring(jumpPower)
	end
end)

RunService.RenderStepped:Connect(function()
	if highJump then
		hum.Jump = true
		hum.JumpPower = jumpPower
	end
end)

-- ===== SPEED BOOST =====
local speedBoost = false
local boostSpeed = 50

local speedBtn = Instance.new("TextButton", main)
speedBtn.Size = UDim2.fromOffset(180,32)
speedBtn.Position = UDim2.fromOffset(220,190)
speedBtn.Text = "Speed Boost: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(255,180,200)
speedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedBtn)

speedBtn.MouseButton1Click:Connect(function()
	speedBoost = not speedBoost
	speedBtn.Text = speedBoost and "Speed Boost: ON" or "Speed Boost: OFF"
	if speedBoost then
		hum.WalkSpeed = boostSpeed
	else
		hum.WalkSpeed = 16
	end
end)

local speedLabel = Instance.new("TextLabel", main)
speedLabel.Size = UDim2.fromOffset(180,20)
speedLabel.Position = UDim2.fromOffset(220,225)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(120,60,80)
speedLabel.TextScaled = true
speedLabel.Text = "Speed: "..boostSpeed

local speedSlider = Instance.new("TextBox", main)
speedSlider.Size = UDim2.fromOffset(180,20)
speedSlider.Position = UDim2.fromOffset(220,245)
speedSlider.BackgroundColor3 = Color3.fromRGB(255,200,220)
speedSlider.TextColor3 = Color3.new(1,1,1)
speedSlider.Text = tostring(boostSpeed)
Instance.new("UICorner", speedSlider)

speedSlider.FocusLost:Connect(function()
	local val = tonumber(speedSlider.Text)
	if val and val >= 16 and val <= 100 then
		boostSpeed = val
		speedLabel.Text = "Speed: "..boostSpeed
		if speedBoost then
			hum.WalkSpeed = boostSpeed
		end
	else
		speedSlider.Text = tostring(boostSpeed)
	end
end)
