---@diagnostic disable: undefined-global
-- ==========================================
-- ЧАСТЬ 1: СОЗДАНИЕ ИНТЕРФЕЙСА (ОКНА МЕНЮ)
-- ==========================================
speedValue = 100

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyControlMenu"
screenGui.ResetOnSpawn = false 

local player = game.Players.LocalPlayer
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 170)
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

-- --- КНОПКА 1: NOCLIP (Сквозь стены) ---
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

-- Цикл для постоянного отключения коллизии
game:GetService("RunService").Stepped:Connect(function()
    if noclipActive and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

--Speed input
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 180, 0, 35)
speedInput.Position = UDim2.new(0, 10, 0, 180) -- Размещаем ниже предыдущих кнопок
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 16
speedInput.Text = "100" -- Изначально поле пустое
speedInput.PlaceholderText = "Скорость/Speed" -- Подсказка серого цвета
speedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
speedInput.Parent = frame

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 6)
uiCorner.Parent = speedInput

local player = game.Players.LocalPlayer

-- Слушаем, когда игрок завершит ввод текста и нажмет Enter
speedInput.FocusLost:Connect(function(enterPressed)
    -- Проверяем, что игрок нажал именно Enter, а не просто кликнул мимо поля
    if enterPressed then
        local text = speedInput.Text
        speedValue = tonumber(text) -- Пробуем превратить текст в число
        
        -- Проверяем, корректное ли число ввел игрок
        if speedValue then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                humanoid.WalkSpeed = speedValue -- Устанавливаем введенную скорость
                speedInput.Text = "" -- Очищаем поле после успешного ввода
                print("Скорость изменена на: " .. speedValue)
            end
        else
            -- Если ввели буквы вместо цифр, выводим предупреждение
            speedInput.Text = ""
            speedInput.PlaceholderText = "Ошибка! Введите число"
            speedInput.PlaceholderColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)



-- --- КНОПКА 2: SPEED (Скорость) ---
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

--Jump

local JumpInput = Instance.new("TextBox")
JumpInput.Size = UDim2.new(0, 180, 0, 35)
JumpInput.Position = UDim2.new(0, 10, 0, 230) -- Размещаем ниже предыдущих кнопок
JumpInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JumpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpInput.TextSize = 16
JumpInput.Text = "100" -- Изначально поле пустое
JumpInput.PlaceholderText = "Скорость/Speed" -- Подсказка серого цвета
JumpInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
JumpInput.Parent = frame

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 6)
uiCorner.Parent = speedInput

local player = game.Players.LocalPlayer

-- Слушаем, когда игрок завершит ввод текста и нажмет Enter
JumpInput.FocusLost:Connect(function(enterPressed)
    -- Проверяем, что игрок нажал именно Enter, а не просто кликнул мимо поля
    if enterPressed then
        local text = JumpInput.Text
        JumpHeig = tonumber(text) -- Пробуем превратить текст в число
        
        -- Проверяем, корректное ли число ввел игрок
        if speedValue then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                humanoid.jumpHeight = JumpHeig -- Устанавливаем введенную скорость
                speedInput.Text = "" -- Очищаем поле после успешного ввода
                print("Сила прыжка изменена на: " .. JumpHeig)
            end
        else
            -- Если ввели буквы вместо цифр, выводим предупреждение
            speedInput.Text = ""
            speedInput.PlaceholderText = "Ошибка! Введите число"
            speedInput.PlaceholderColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)



local jumpBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0, 180, 0, 40)
noclipBtn.Position = UDim2.new(0, 10, 0, 45)
noclipBtn.Text = "SuperJump: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
noclipBtn.Parent = frame
speedBtn.MouseButton1Click:Connect(function()
    jumpActive = not jumpHeight
    local humoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        if jumpActive then
            speedBtn.Text = "SuperJump: ON"
            speedBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            humanoid.jumpHeight = speedValue
        else
            speedBtn.Text = "SuperJump: OFF"
            speedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            humanoid.WalkSpeed = 16 
        end
    end
end)


