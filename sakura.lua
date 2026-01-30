-- 🌸 Sakura Menu | iOS Fixed Full Version

-- ===== GUI PARENT (Skibix-safe) =====
local function getGuiParent()
	local ok, cg = pcall(function() return game:GetService("CoreGui") end)
	if ok and cg then return cg end
	local ok2, hui = pcall(function() return gethui() end)
	if ok2 and hui then return hui end
	return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

if getgenv().SakuraLoaded then return end
getgenv().SakuraLoaded = true

local GUI_PARENT = getGuiParent()

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "SakuraMenu"
pcall(function() gui.Parent = GUI_PARENT end)
pcall(function() if protect_gui then protect_gui(gui) end end)

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(450,300)
main.Position = UDim2.new(0.5,-225,0.5,-150)
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

-- OPEN BUTTON (mini lotus 🪷)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(36,36)
openBtn.Position = UDim2.new(1,-46,0,12)
openBtn.Text = "🪷"
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

-- ===== FLY =====
local fly = false
local flySpeed = 3
local flyVel = Instance.new("BodyVelocity")
flyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
flyVel.Velocity = Vector3.new(0,0,0)
flyVel.Parent = root
flyVel.Enabled = false

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
	flyVel.Enabled = fly
end)

local flyLabel = Instance.new("TextLabel", main)
flyLabel.Size = UDim2.fromOffset(180,20)
flyLabel.Position = UDim2.fromOffset(20,95)
flyLabel.BackgroundTransparency = 1
flyLabel.TextColor3 = Color3.fromRGB(120,60,80)
flyLabel.TextScaled = true
flyLabel.Text = "Fly Speed: "..flySpeed

local flyBox = Instance.new("TextBox", main)
flyBox.Size = UDim2.fromOffset(180,20)
flyBox.Position = UDim2.fromOffset(20,115)
flyBox.BackgroundColor3 = Color3.fromRGB(255,200,220)
flyBox.TextColor3 = Color3.new(1,1,1)
flyBox.Text = tostring(flySpeed)
Instance.new("UICorner", flyBox)

flyBox.FocusLost:Connect(function()
	local val = tonumber(flyBox.Text)
	if val and val >= 1 and val <= 100 then
		flySpeed = val
		flyLabel.Text = "Fly Speed: "..flySpeed
	else
		flyBox.Text = tostring(flySpeed)
	end
end)

RunService.RenderStepped:Connect(function()
	if fly then
		local dir = Vector3.new(0,0,0)
		if uis:IsKeyDown(Enum.KeyCode.W) then dir += root.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.S) then dir -= root.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.A) then dir -= root.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.D) then dir += root.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
		if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
		flyVel.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.new(0,0,0)
	end
end)

-- ===== SPEED BOOST =====
local speedBoost = false
local boostSpeed = 16
local speedBtn = Instance.new("TextButton", main)
speedBtn.Size = UDim2.fromOffset(180,32)
speedBtn.Position = UDim2.fromOffset(220,60)
speedBtn.Text = "Speed Boost: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(255,180,200)
speedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedBtn)

speedBtn.MouseButton1Click:Connect(function()
	speedBoost = not speedBoost
	speedBtn.Text = speedBoost and "Speed Boost: ON" or "Speed Boost: OFF"
	hum.WalkSpeed = speedBoost and boostSpeed or 16
end)

local speedLabel = Instance.new("TextLabel", main)
speedLabel.Size = UDim2.fromOffset(180,20)
speedLabel.Position = UDim2.fromOffset(220,95)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(120,60,80)
speedLabel.TextScaled = true
speedLabel.Text = "Speed: "..boostSpeed

local speedBox = Instance.new("TextBox", main)
speedBox.Size = UDim2.fromOffset(180,20)
speedBox.Position = UDim2.fromOffset(220,115)
speedBox.BackgroundColor3 = Color3.fromRGB(255,200,220)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Text = tostring(boostSpeed)
Instance.new("UICorner", speedBox)

speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and val >= 16 and val <= 100 then
		boostSpeed = val
		speedLabel.Text = "Speed: "..boostSpeed
		if speedBoost then hum.WalkSpeed = boostSpeed end
	else
		speedBox.Text = tostring(boostSpeed)
	end
end)

-- ===== HIGH JUMP =====
local jumpBtn = Instance.new("TextButton", main)
jumpBtn.Size = UDim2.fromOffset(180,32)
jumpBtn.Position = UDim2.fromOffset(20,150)
jumpBtn.Text = "High Jump"
jumpBtn.BackgroundColor3 = Color3.fromRGB(200,180,255)
jumpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", jumpBtn)

local jumpPower = 50
local highJump = false

jumpBtn.MouseButton1Click:Connect(function()
	highJump = not highJump
	jumpBtn.Text = highJump and "High Jump: ON" or "High Jump: OFF"
	hum.JumpPower = highJump and jumpPower or 50
end)

local jumpLabel = Instance.new("TextLabel", main)
jumpLabel.Size = UDim2.fromOffset(180,20)
jumpLabel.Position = UDim2.fromOffset(20,185)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.fromRGB(120,60,80)
jumpLabel.TextScaled = true
jumpLabel.Text = "Jump Power: "..jumpPower

local jumpBox = Instance.new("TextBox", main)
jumpBox.Size = UDim2.fromOffset(180,20)
jumpBox.Position = UDim2.fromOffset(20,205)
jumpBox.BackgroundColor3 = Color3.fromRGB(230,200,255)
jumpBox.TextColor3 = Color3.new(1,1,1)
jumpBox.Text = tostring(jumpPower)
Instance.new("UICorner", jumpBox)

jumpBox.FocusLost:Connect(function()
	local val = tonumber(jumpBox.Text)
	if val and val >= 1 and val <= 100 then
		jumpPower = val
		jumpLabel.Text = "Jump Power: "..jumpPower
		if highJump then hum.JumpPower = jumpPower end
	else
		jumpBox.Text = tostring(jumpPower)
	end
end)

-- ===== ESP =====
local esp = false
local highlights = {}

local espBtn = Instance.new("TextButton", main)
espBtn.Size = UDim2.fromOffset(180,32)
espBtn.Position = UDim2.fromOffset(220,150)
espBtn.Text = "ESP"
espBtn.BackgroundColor3 = Color3.fromRGB(255,200,180)
espBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espBtn)

local function toggleESP(state)
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			if state then
				if not highlights[plr] then
					local h = Instance.new("Highlight")
					h.FillTransparency = 0.5
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
