local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- Tạo TextLabel
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 200, 0, 50)
textLabel.Position = UDim2.new(0, 50, 0, 50) -- Vị trí ban đầu
textLabel.Text = "Di chuyển tôi!"
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textLabel.Parent = screenGui

-- Tạo nút bấm
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0, 50, 0, 120)
button.Text = "Di chuyển"
button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
button.TextColor3 = Color3.new(1, 1, 1)
button.Parent = screenGui

-- Hàm di chuyển chữ đến vị trí chỉ định (X, Y)
local function moveText(x, y)
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out) -- 2 giây
    local goal = {Position = UDim2.new(0, x, 0, y)} -- Vị trí mới
    local tween = TweenService:Create(textLabel, tweenInfo, goal)
    tween:Play()
end

-- Khi bấm nút, di chuyển chữ đến (300, 200)
button.MouseButton1Click:Connect(function()
    moveText(300, 200)
end)
