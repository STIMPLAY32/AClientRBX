-- ==========================================
-- ЧАСТЬ 1: СОЗДАНИЕ ИНТЕРФЕЙСА (ОКНА МЕНЮ)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyControlMenu"
screenGui.ResetOnSpawn = false 

local player = game.Players.LocalPlayer
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true 
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Control Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Parent = frame

-- Переменные для отслеживания состояния кнопок
local noclipActive = false
local speedActive = false

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
            humanoid.WalkSpeed = 100 
        else
            speedBtn.Text = "Speed: OFF"
            speedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            humanoid.WalkSpeed = 16 
        end
    end
end)
