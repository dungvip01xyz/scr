local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local chestsFolder = game.Workspace:FindFirstChild("ChestModels")

if not chestsFolder then
    warn("Không tìm thấy thư mục ChestModels!")
    return
end

-- 🖥️ Tạo GUI hiển thị số rương
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local chestCounter = Instance.new("TextLabel")
chestCounter.Size = UDim2.new(0, 200, 0, 50)
chestCounter.Position = UDim2.new(0.5, -100, 0.1, 0)
chestCounter.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
chestCounter.TextColor3 = Color3.new(1, 1, 1)
chestCounter.TextSize = 24
chestCounter.Parent = screenGui

-- 🎛️ Tạo nút bật/tắt
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0.5, -75, 0.2, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = 24
toggleButton.Text = "Bật dịch chuyển"
toggleButton.Parent = screenGui

local isMoving = false -- Biến kiểm soát trạng thái bật/tắt

-- 🔄 Cập nhật số rương
local function updateChestCount(count)
    chestCounter.Text = "Rương còn lại: " .. count
end

-- 🏃 Hàm di chuyển đến 1 vị trí
local function moveToPosition(targetPosition, speed)
    local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPosition)}
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait() -- Đợi di chuyển xong
end

-- 🚀 Hàm tự động di chuyển qua từng rương
local function autoMoveToChests()
    if not isMoving then return end -- Nếu tắt thì dừng
    
    local chests = chestsFolder:GetChildren()
    updateChestCount(#chests) -- Hiển thị số rương ban đầu

    for _, chest in ipairs(chests) do
        if not isMoving then return end -- Nếu bị tắt giữa chừng thì dừng ngay
        local chestRoot = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChild("PrimaryPart")
        if chestRoot then
            moveToPosition(chestRoot.Position, 3) -- Di chuyển với tốc độ 3 giây
            chest:Destroy() -- Xóa rương khi đến nơi
            updateChestCount(#chestsFolder:GetChildren()) -- Cập nhật số rương
        end
    end
end

-- 🎛️ Xử lý khi bấm nút bật/tắt
toggleButton.MouseButton1Click:Connect(function()
    isMoving = not isMoving -- Đảo trạng thái
    toggleButton.Text = isMoving and "Tắt dịch chuyển" or "Bật dịch chuyển"

    if isMoving then
        autoMoveToChests()
    end
end)

-- 🔥 Cập nhật số rương ban đầu
updateChestCount(#chestsFolder:GetChildren())
