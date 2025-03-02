local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🖥️ Tạo GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Chỉnh tốc độ di chuyển"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 30)
speedLabel.Text = "Tốc độ: 2 giây"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Parent = frame

local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(1, -20, 0, 30)
speedSlider.Position = UDim2.new(0, 10, 0, 70)
speedSlider.Text = "2"
speedSlider.Parent = frame

local moveButton = Instance.new("TextButton")
moveButton.Size = UDim2.new(1, -20, 0, 30)
moveButton.Position = UDim2.new(0, 10, 0, 110)
moveButton.Text = "Di chuyển đến (100, 5, 50)"
moveButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
moveButton.TextColor3 = Color3.new(1, 1, 1)
moveButton.Parent = frame

-- 🚀 Hàm di chuyển nhân vật
local function moveCharacter(x, y, z, speed)
    local targetPosition = Vector3.new(x, y, z)
    local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPosition)}

    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
end

-- Khi bấm nút, lấy tốc độ từ Slider và di chuyển
moveButton.MouseButton1Click:Connect(function()
    local speed = tonumber(speedSlider.Text) or 2 -- Mặc định 2 giây
    moveCharacter(100, 5, 50, speed)
    speedLabel.Text = "Tốc độ: " .. speed .. " giây"
end)
