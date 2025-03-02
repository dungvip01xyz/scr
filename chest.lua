local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local chestsFolder = game.Workspace:FindFirstChild("ChestModels")

if not chestsFolder then
    warn("Không tìm thấy thư mục ChestModels!")
    return
end

-- 🖥️ Tạo GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local chestCounter = Instance.new("TextLabel")
chestCounter.Size = UDim2.new(0, 200, 0, 50)
chestCounter.Position = UDim2.new(0.5, -100, 0.1, 0)
chestCounter.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
chestCounter.TextColor3 = Color3.new(1, 1, 1)
chestCounter.TextSize = 24
chestCounter.Parent = screenGui

-- 🎛️ Nút bật/tắt dịch chuyển
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0.5, -75, 0.2, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = 24
toggleButton.Text = "Bật dịch chuyển"
toggleButton.Parent = screenGui

local isMoving = false -- Trạng thái dịch chuyển

-- 🔄 Cập nhật số rương còn lại
local function updateChestCount()
    local count = #chestsFolder:GetChildren()
    chestCounter.Text = "Rương còn lại: " .. count
end

-- 🏃 Hàm dịch chuyển đến Part
local function moveToPosition(targetPart, speed)
    if humanoidRootPart and targetPart then
        local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local goal = {CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)} -- Dịch lên 3 đơn vị để tránh kẹt
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
        tween:Play()
        tween.Completed:Wait() -- Đợi di chuyển xong
    end
end

-- 🚀 Tự động dịch chuyển đến các rương
local function autoMoveToChests()
    while isMoving do
        local chests = chestsFolder:GetChildren()
        updateChestCount()
        
        if #chests == 0 then
            toggleButton.Text = "Hết rương!"
            isMoving = false
            return
        end

        for _, chest in ipairs(chests) do
            if not isMoving then return end -- Nếu tắt giữa chừng, dừng ngay

            -- Tìm Part trong rương để dịch chuyển đến
            local targetPart = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChildWhichIsA("BasePart")
            if targetPart then
                moveToPosition(targetPart, 2) -- Dịch chuyển với tốc độ 2 giây
                chest:Destroy() -- Xóa rương khi đến nơi
                updateChestCount()
            end
        end
    end
end

-- 🎛️ Xử lý khi bấm nút bật/tắt
toggleButton.MouseButton1Click:Connect(function()
    isMoving = not isMoving
    toggleButton.Text = isMoving and "Tắt dịch chuyển" or "Bật dịch chuyển"

    if isMoving then
        autoMoveToChests()
    end
end)

-- 🔥 Hiển thị số rương ban đầu
updateChestCount()
