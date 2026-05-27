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
frame.Size = UDim2.new(0, 200, 0, 530) -- Увеличили высоту для новой кнопки
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
local espActive = false

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
gravityBtn.Position = UDim2.new(0, 10, 0, 295) -- Встает ровно под поле ввода прыжка
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



-- --- КНОПКА 5: CRASH/STRESS TEST (ИСПРАВЛЕНО) ---
local crashBtn = Instance.new("TextButton")
crashBtn.Size = UDim2.new(0, 180, 0, 40)
-- Сдвинули по координате X на 10, чтобы кнопка стояла ровно по центру, как и остальные
crashBtn.Position = UDim2.new(0, 10, 0, 345) 
crashBtn.Text = "Crash: OFF"
crashBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
crashBtn.Font = Enum.Font.SourceSansBold
crashBtn.TextSize = 14
crashBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
crashBtn.Parent = frame

local uiCornerCrash = Instance.new("UICorner")
uiCornerCrash.CornerRadius = UDim.new(0, 6)
uiCornerCrash.Parent = crashBtn

-- Логика работы стресс-теста
crashBtn.MouseButton1Click:Connect(function()
    crashActive = not crashActive -- Переключаем состояние true / false
    
    if crashActive then
        crashBtn.Text = "Crash: ON"
        crashBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        -- task.spawn запускает цикл в отдельном потоке, чтобы кнопка не намертво зависала
        task.spawn(function()
            -- Цикл работает только ПОКА переменная crashActive равна true
            while crashActive do
                task.wait(0.3) -- Небольшая пауза между волнами спавна
                
                -- Спавним блоки локально
                for i = 1, 30 do
                    if not crashActive then break end -- Мгновенная остановка, если кнопку выключили
                    
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(4, 4, 4)
                    part.Position = Vector3.new(math.random(-50, 50), 50, math.random(-50, 50)) 
                    part.Material = Enum.Material.Concrete
                    part.Parent = workspace -- Исправлено на строчную букву
                    
                    -- Обязательно автоматически удаляем блоки через 5 секунд, 
                    -- иначе ваш компьютер полностью зависнет или игра вылетит (Crash)
                    game:GetService("Debris"):AddItem(part, 5)
                end
            end
        end)
        
    else
        -- Логика выключения
        crashBtn.Text = "Crash: OFF"
        crashBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        print("Стресс-тест остановлен, новые блоки больше не создаются")
    end
end)



-- --- КНОПКА 6: ESP (Подсветка игроков) ---
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 180, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0, 395) -- Встает ровно под кнопку краша
espBtn.Text = "ESP: OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 14
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Parent = frame

local uiCornerEsp = Instance.new("UICorner")
uiCornerEsp.CornerRadius = UDim.new(0, 6)
uiCornerEsp.Parent = espBtn

-- Функция для добавления подсветки на одного конкретного игрока
local function addHighlight(targetPlayer)
    if targetPlayer == player then return end -- Себя не подсвечиваем
    
    -- Ждем, пока у игрока загрузится персонаж
    local character = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
    
    -- Проверяем, нет ли уже подсветки, чтобы не создавать дубликаты
    if character and not character:FindFirstChild("EspHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "EspHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Цвет заливки (Красный) [3]
        highlight.FillTransparency = 0.5 -- Прозрачность заливки (от 0 до 1)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Цвет обводки (Белый) [3]
        highlight.OutlineTransparency = 0 -- Обводка полностью видимая
        highlight.Adornee = character
        highlight.Parent = character
    end
end

-- Функция для удаления подсветки у всех игроков
local function removeHighlight()
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Character then
            local highlight = p.Character:FindFirstChild("EspHighlight")
            if highlight then
                highlight:Destroy() -- Удаляем объект подсветки
            end
        end
    end
end

-- Переменная для хранения отслеживания новых игроков
local playerAddedConnection = nil

-- Логика работы кнопки
espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive -- Переключаем true/false
    
    if espActive then
        espBtn.Text = "ESP: ON"
        espBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        -- 1. Подсвечиваем всех игроков, которые СЕЙЧАС есть на сервере
        for _, p in ipairs(game.Players:GetPlayers()) do
            task.spawn(function()
                addHighlight(p)
            end)
            -- Если игрок возродится после смерти, подсвечиваем заново
            p.CharacterAdded:Connect(addHighlight)
        end
        
        -- 2. Отслеживаем НОВЫХ игроков, которые только заходят на сервер
        playerAddedConnection = game.Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(addHighlight)
        end)
        
        print("Подсветка игроков включена")
    else
        espBtn.Text = "ESP: OFF"
        espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        -- Отключаем отслеживание новых игроков
        if playerAddedConnection then
            playerAddedConnection:Disconnect()
            playerAddedConnection = nil
        end
        
        -- Удаляем всю текущую подсветку в игре
        removeHighlight()
        print("Подсветка игроков выключена")
    end
end)


-- Переменные для работы полёта
local flyActive = false
local flySpeed = 50 -- Скорость полёта

-- Объекты физики (создаются при включении)
local flyVelocity = nil
local flyOrientation = nil
local flyAttachment = nil
local flyConnection = nil

-- --- КНОПКА 7: FLY (Полёт) ---
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 180, 0, 40)
flyBtn.Position = UDim2.new(0, 10, 0, 445) -- Позиция ровно под кнопкой ESP
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextSize = 14
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Parent = frame

local uiCornerFly = Instance.new("UICorner")
uiCornerFly.CornerRadius = UDim.new(0, 6)
uiCornerFly.Parent = flyBtn

-- Сервисы для отслеживания ввода и камеры
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- Функция отключения полёта и удаления физических объектов
local function disableFly()
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if flyVelocity then flyVelocity:Destroy() flyVelocity = nil end
    if flyOrientation then flyOrientation:Destroy() flyOrientation = nil end
    if flyAttachment then flyAttachment:Destroy() flyAttachment = nil end
    
    -- Возвращаем персонажу обычную анимацию падения/стояния
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- Логика работы кнопки
flyBtn.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    
    if flyActive then
        flyBtn.Text = "Fly: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if rootPart and humanoid then
            -- Создаем точку крепления физики (Attachment)
            flyAttachment = Instance.new("Attachment")
            flyAttachment.Parent = rootPart
            
            -- Настраиваем удерживание направления (чтобы не падать лицом в пол)
            flyOrientation = Instance.new("AlignOrientation")
            flyOrientation.Mode = Enum.OrientationMode.OneAttachment
            flyOrientation.Attachment0 = flyAttachment
            flyOrientation.RigidityEnabled = true
            flyOrientation.Parent = rootPart
            
            -- Настраиваем вектор скорости для перемещения (LinearVelocity)
            flyVelocity = Instance.new("LinearVelocity")
            flyVelocity.Mode = Enum.LinearVelocityMode.ForceLimitMode
            flyVelocity.Attachment0 = flyAttachment
            flyVelocity.MaxForce = math.huge -- Бесконечная сила для удержания веса
            flyVelocity.VectorVelocity = Vector3.new(0, 0, 0)
            flyVelocity.Parent = rootPart
            
            -- Переводим гуманоида в режим полёта (отключает стандартную физику ходьбы)
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            
            -- Цикл, который рассчитывает куда лететь каждый кадр
            flyConnection = RunService.RenderStepped:Connect(function()
                if not rootPart or not flyVelocity then return end
                
                -- Проверяем, какие клавиши зажаты игроком
                local moveDirection = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0) -- Вверх на пробел
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0) -- Вниз на Shift
                end
                
                -- Если направление выбрано, двигаем персонажа туда
                if moveDirection.Magnitude > 0 then
                    flyVelocity.VectorVelocity = moveDirection.Unit * flySpeed
                else
                    flyVelocity.VectorVelocity = Vector3.new(0, 0, 0) -- Зависаем на месте
                end
                
                -- Поворачиваем персонажа лицом туда, куда смотрит камера (горизонтально)
                local camLook = camera.CFrame.LookVector
                flyOrientation.CFrame = CFrame.lookAt(Vector3.new(0,0,0), Vector3.new(camLook.X, 0, camLook.Z))
            end)
        end
        print("Режим полёта активирован. Управление: W/A/S/D + Пробел/Shift")
    else
        flyBtn.Text = "Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        disableFly()
        print("Режим полёта выключен")
    end
end)

-- Безопасность: если персонаж умер во время полета, очищаем физику
player.CharacterRemoving:Connect(function()
    if flyActive then
        flyActive = false
        flyBtn.Text = "Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        disableFly()
    end
end)
