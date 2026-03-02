local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")

-- Настройки
local BUTTON_SIZE = UDim2.new(0, 30, 0, 30)
local IMAGE_ID = "rbxassetid://123456789" -- Замени на ID картинки месяца
local CUBE_COUNT = 20
local RADIUS = 6
local ROTATION_SPEED = 1
local SELF_ROTATION_SPEED = 2

-- Создание кнопки
local screenGui = Instance.new("ScreenGui", Player.PlayerGui)
local button = Instance.new("ImageButton", screenGui)
button.Size = BUTTON_SIZE
button.Position = UDim2.new(0.5, -15, 0.8, 0)
button.Image = IMAGE_ID
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local activeCubes = {}
local currentTarget = nil

-- Функция создания кубика с эффектом свечения
local function createCube()
	local cube = Instance.new("Part")
	cube.Size = Vector3.new(0.5, 0.5, 0.5)
	cube.Color = Color3.fromRGB(173, 216, 230) -- Голубой
	cube.Transparency = 0.3
	cube.CanCollide = false
	cube.Anchored = true
	cube.Parent = workspace
	
	-- Создаем эффект "отблеска" (SelectionBox или Light)
	local selection = Instance.new("SelectionBox", cube)
	selection.Adornee = cube
	selection.LineThickness = 0.05
	selection.SurfaceColor3 = cube.Color
	selection.SurfaceTransparency = 0.8 -- Тот самый отблеск на 20% больше
	
	local light = Instance.new("PointLight", cube)
	light.Color = cube.Color
	light.Brightness = 1
	light.Range = 3
	
	return cube
end

-- Логика движения
button.MouseButton1Click:Connect(function()
	-- Ищем цель (на кого наведен курсор)
	local target = Mouse.Target
	if target and target.Parent:FindFirstChild("Humanoid") then
		currentTarget = target.Parent:FindFirstChild("HumanoidRootPart")
		
		-- Очистка старых кубиков
		for _, v in pairs(activeCubes) do v:Destroy() end
		activeCubes = {}
		
		-- Создание новых 20 кубиков
		for i = 1, CUBE_COUNT do
			table.insert(activeCubes, createCube())
		end
	end
end)

RunService.RenderStepped:Connect(function(dt)
	if currentTarget and #activeCubes > 0 then
		local time = tick()
		for i, cube in ipairs(activeCubes) do
			local angle = (i / CUBE_COUNT) * math.pi * 2 + (time * ROTATION_SPEED)
			local offsetX = math.cos(angle) * RADIUS
			local offsetZ = math.sin(angle) * RADIUS
			local offsetY = math.sin(time + i) * 1.5 -- Плавное движение вверх-вниз
			
			-- Позиция вокруг персонажа
			cube.Position = currentTarget.Position + Vector3.new(offsetX, offsetY, offsetZ)
			
			-- Собственное вращение кубика
			cube.CFrame = cube.CFrame * CFrame.Angles(dt * SELF_ROTATION_SPEED, dt * SELF_ROTATION_SPEED, 0)
		end
	end
end)
