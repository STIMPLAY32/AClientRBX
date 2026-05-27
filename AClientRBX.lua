---@diagnostic disable: undefined-global
-- ==========================================
-- ЧАСТЬ 1: СОЗДАНИЕ ИНТЕРФЕЙСА (ОКНА МЕНЮ)
-- ==========================================
local speedValue = 100
local jumpValue = 10 

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyControlMenu"
screenGui.ResetOnSpawn = false 

local player = game.Players.LocalPlayer
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Главное окно
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 430)
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

-- Скруглим углы главному меню для красоты
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- ==========================================
-- КНОПКА СВЕРНУТЬ / РАЗВЕРНУТЬ (В ПРАВОМ ВЕРХНЕМ УГЛУ)
-- ==========================================
local toggleGuiBtn = Instance.new("TextButton")
toggleGuiBtn.Size = UDim2.new(0, 100, 0, 35) -- Чуть увеличили размер

-- ИСПРАВЛЕНО: Позиционируем в правый верхний угол (отступ 50px от правого края и 20px сверху)
toggleGuiBtn.Position = UDim2.new(1, -120, 0, 20) 

toggleGuiBtn.Text = "Скрыть панель"
toggleGuiBtn.TextSize = 14
toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Серый цвет по умолчанию
toggleGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiBtn.Font = Enum.Font.SourceSansBold
toggleGuiBtn.Parent = screenGui

-- Скругление углов
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleGuiBtn

-- Обводка, чтобы кнопка выделялась на любом фоне
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 1
uiStroke.Parent = toggleGuiBtn

-- Логика скрытия панели
toggleGuiBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible -- Переключаем видимость
    
    if frame.Visible then
        toggleGuiBtn.Text = "Скрыть панель"
        toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        toggleGuiBtn.Text = "Показать панель"
        toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100) -- Ярко-зеленый, когда скрыто
    end
end)

-- Переменные для отслеживания состояния функций игры
local noclipActive = false
local speedActive = false
local jumpActive = false
crashactive = false

-- ==========================================
-- ЧАСТЬ 2: ЛОГИКА И КНОПКИ ФУНКЦИЙ
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
speedInput.Position = UDim2.new(0, 10, 0, 145) 
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

-- --- КНОПКА 3: JUMP ---
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0, 180, 0, 40)
jumpBtn.Position = UDim2.new(0, 10, 0, 195) 
jumpBtn.Text = "SuperJump: OFF"
jumpBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
jumpBtn.Parent = frame

jumpBtn.MouseButton1Click:Connect(function()
    jumpActive = not jumpActive
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid.UseJumpPower = false 
        if jumpActive then
            jumpBtn.Text = "SuperJump: ON"
            jumpBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            humanoid.JumpHeight = jumpValue 
        else
            jumpBtn.Text = "SuperJump: OFF"
            jumpBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            humanoid.JumpHeight = 7.2 
        end
    end
end)



-- ПОЛЕ ВВОДА ПРЫЖКА
local jumpInput = Instance.new("TextBox")
jumpInput.Size = UDim2.new(0, 180, 0, 35)
jumpInput.Position = UDim2.new(0, 10, 0, 245) 
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
        
        if parsedJump then 
            jumpValue = parsedJump
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
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


local gravityActive = false

-- --- КНОПКА 4: LOW GRAVITY (Пониженная гравитация) ---
local gravityBtn = Instance.new("TextButton")
gravityBtn.Size = UDim2.new(0, 180, 0, 40)
gravityBtn.Position = UDim2.new(0, 60, 0, 40) -- Встает ровно под поле ввода прыжка
gravityBtn.Text = "Low Gravity: OFF"
gravityBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
gravityBtn.Font = Enum.Font.SourceSansBold
gravityBtn.TextSize = 14
gravityBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityBtn.Parent = frame

-- Скругляем углы новой кнопки
local uiCornerGravity = Instance.new("UICorner")
uiCornerGravity.CornerRadius = UDim.new(0, 6)
uiCornerGravity.Parent = gravityBtn

-- Логика работы кнопки гравитации
gravityBtn.MouseButton1Click:Connect(function()
    gravityActive = not gravityActive
    
    if gravityActive then
        gravityBtn.Text = "Low Gravity: ON"
        gravityBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        -- Устанавливаем низкую гравитацию (стандартная в Roblox: 196.2)
        workspace.Gravity = 50 
        print("Гравитация снижена")
    else
        gravityBtn.Text = "Low Gravity: OFF"
        gravityBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        -- Возвращаем стандартную гравитацию игры
        workspace.Gravity = 196.2 
        print("Гравитация восстановлена")
    end
end)



-- --- КНОПКА 4: LOW GRAVITY (Пониженная гравитация) ---
local crashBtn = Instance.new("TextButton")
crashBtn.Size = UDim2.new(0, 180, 0, 40)
crashBtn.Position = UDim2.new(0, 60, 0, 100) -- Встает ровно под поле ввода прыжка
crashBtn.Text = "Crash: OFF"
crashBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
crashBtn.Font = Enum.Font.SourceSansBold
crashBtn.TextSize = 14
crashBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
crashBtn.Parent = frame

-- Скругляем углы новой кнопки
local uiCornerCrash = Instance.new("UICorner")
uiCornerCrash.CornerRadius = UDim.new(0, 6)
uiCornerCrash.Parent = crashBtn

-- Логика работы кнопки гравитации
crashBtn.MouseButton1Click:Connect(function()
    if crashactive then
        crashactive = true
        crashBtn.Text = "Crash: ON"
        crashBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        -- Устанавливаем низкую гравитацию (стандартная в Roblox: 196.2)
        while true do
            task.wait(0.5) -- Каждые полсекунды
    
            for i = 1, 50 do -- Спавним сразу по 50 блоков за раз
                local part = Instance.new("Part")
                part.Size = Vector3.new(4, 4, 4)
                -- Случайное появление в небе над центром карты
                part.Position = Vector3.new(math.random(-50, 50), 100, math.random(-50, 50)) 
                part.Material = Enum.Material.Concrete -- Тяжелый материал
                part.Parent = Workspace
            end
        end
    else
        crashBtn.Text = "Crash: OFF"
        gravcrashBtnityBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        game:GetService("Debris"):AddItem(part, 1)

    end
end)
