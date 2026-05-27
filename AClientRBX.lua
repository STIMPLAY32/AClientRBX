---@diagnostic disable: undefined-global
-- ==========================================
-- ЧАСТЬ 1: СОЗДАНИЕ ИНТЕРФЕЙСА (ОКНА МЕНЮ)
-- ==========================================
local speedValue = 100
local jumpValue = 10 -- Стандартная высота прыжка в метрах ~7.2

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyControlMenu"
screenGui.ResetOnSpawn = false 

local player = game.Players.LocalPlayer
screenGui.Parent = player:WaitForChild("PlayerGui")

-- УВЕЛИЧИЛИ ВЫСОТУ ОКНА ДО 330, чтобы поместились все элементы
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 330)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true 
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Super Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Parent = frame

-- Переменные для отслеживания состояния кнопок
local noclipActive = false
local speedActive = false
local jumpActive = false

-- ==========================================
-- ЧАСТЬ 2: ЛОГИКА И КНОПКИ
-- ==========================================

-- --- КНОПКА 1: NOCLIP ---
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0, 180, 0, 40)
noclipBtn.Position = UDim2.new(0, 10, 0, 45)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
noclipBtn.Parent = frame

noclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive 
    if noclipActive then
        noclipBtn.Text = "Noclip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        noclipBtn.Text = "Noclip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclipActive and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- --- КНОПКА 2: SPEED ---
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0, 180, 0, 40)
speedBtn.Position = UDim2.new(0, 10, 0, 95)
speedBtn.Text = "Speed: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
speedBtn.Parent = frame

speedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        if speedActive then
            speedBtn.Text = "Speed: ON"
            speedBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            humanoid.WalkSpeed = speedValue
        else
            speedBtn.Text = "Speed: OFF"
            speedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            humanoid.WalkSpeed = 16 
        end
    end
end)

-- ПОЛЕ ВВОДА СКОРОСТИ
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 180, 0, 35)
speedInput.Position = UDim2.new(0, 10, 0, 145) -- Сдвинули выше
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 16
speedInput.Text = "100" 
speedInput.PlaceholderText = "Скорость/Speed" 
speedInput.Parent = frame

local uiCornerSpeed = Instance.new("UICorner")
uiCornerSpeed.CornerRadius = UDim.new(0, 6)
uiCornerSpeed.Parent = speedInput

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = speedInput.Text
        local parsedSpeed = tonumber(text)
        
        if parsedSpeed then
            speedValue = parsedSpeed
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            -- Если функция сейчас включена, сразу обновляем скорость персонажу
            if humanoid and speedActive then
                humanoid.WalkSpeed = speedValue
            end
            print("Сохраненное значение скорости: " .. speedValue)
        else
            speedInput.Text = ""
            speedInput.PlaceholderText = "Ошибка! Число"
        end
    end
end)

-- --- КНОПКА 3: JUMP (ИСПРАВЛЕНО: привязана к jumpBtn) ---
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0, 180, 0, 40)
jumpBtn.Position = UDim2.new(0, 10, 0, 195) -- Новая позиция ниже скорости
jumpBtn.Text = "SuperJump: OFF"
jumpBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
jumpBtn.Parent = frame

jumpBtn.MouseButton1Click:Connect(function()
    jumpActive = not jumpActive
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid.UseJumpPower = false -- Принудительно включаем расчет высоты в метрах
        if jumpActive then
            jumpBtn.Text = "SuperJump: ON"
            jumpBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            humanoid.JumpHeight = jumpValue -- ИСПРАВЛЕНО: Заглавная буква
        else
            jumpBtn.Text = "SuperJump: OFF"
            jumpBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            humanoid.JumpHeight = 7.2 -- Стандартная высота
        end
    end
end)

-- ПОЛЕ ВВОДА ПРЫЖКА (ИСПРАВЛЕНО)
local jumpInput = Instance.new("TextBox")
jumpInput.Size = UDim2.new(0, 180, 0, 35)
jumpInput.Position = UDim2.new(0, 10, 0, 245) -- Размещено корректно внутри рамки
jumpInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jumpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpInput.TextSize = 16
jumpInput.Text = "30" 
jumpInput.PlaceholderText = "Высота прыжка" 
jumpInput.Parent = frame

local uiCornerJump = Instance.new("UICorner")
uiCornerJump.CornerRadius = UDim.new(0, 6)
uiCornerJump.Parent = jumpInput

jumpInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = jumpInput.Text
        local parsedJump = tonumber(text)
        
        if parsedJump then -- ИСПРАВЛЕНО: проверяем именно прыжок, а не скорость
            jumpValue = parsedJump
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            -- Если функция включена, сразу меняем высоту прыжка
            if humanoid and jumpActive then
                humanoid.UseJumpPower = false
                humanoid.JumpHeight = jumpValue
            end
            print("Сохраненное значение высоты прыжка: " .. jumpValue)
        else
            jumpInput.Text = ""
            jumpInput.PlaceholderText = "Ошибка! Число"
        end
    end
end)
