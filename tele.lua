local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Chờ nhân vật xuất hiện
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 Tắt va chạm để nhân vật xuyên vật thể
for _, part in pairs(character:GetChildren()) do
    if part:IsA("BasePart") then
        part.CanCollide = false
    end
end

-- 🖥️ Tạo GUI nhập tọa độ
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Nhập Tọa Độ"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Parent = frame

local textBoxX = Instance.new("TextBox")
textBoxX.Size = UDim2.new(1, -20, 0, 30)
textBoxX.Position = UDim2.new(0, 10, 0, 40)
textBoxX.PlaceholderText = "Nhập X"
textBoxX.Parent = frame

local textBoxY = textBoxX:Clone()
textBoxY.Position = UDim2.new(0, 10, 0, 80)
textBoxY.PlaceholderText = "Nhập Y"
textBoxY.Parent = frame

local textBoxZ = textBoxX:Clone()
textBoxZ.Position = UDim2.new(0, 10, 0, 120)
textBoxZ.PlaceholderText = "Nhập Z"
textBoxZ.Parent = frame

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 30)
teleportButton.Position = UDim2.new(0, 10, 0, 160)
teleportButton.Text = "Di chuyển"
teleportButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.Parent = frame

-- 🚀 Hàm di chuyển nhân vật
local function moveCharacter(x, y, z)
    local targetPosition = Vector3.new(x, y, z)
    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPosition)}

    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
end

-- ⏩ Khi bấm nút, di chuyển nhân vật
teleportButton.MouseButton1Click:Connect(function()
    local x = tonumber(textBoxX.Text) or 0
    local y = tonumber(textBoxY.Text) or 0
    local z = tonumber(textBoxZ.Text) or 0
    moveCharacter(x, y, z)
end)
