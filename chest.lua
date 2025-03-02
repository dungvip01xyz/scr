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
    local chests = chestsFolder:GetChildren()
    updateChestCount(#chests) -- Hiển thị số rương ban đầu

    for _, chest in ipairs(chests) do
        local chestRoot = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChild("PrimaryPart")
        if chestRoot then
            moveToPosition(chestRoot.Position, 3) -- Di chuyển với tốc độ 3 giây
            chest:Destroy() -- Xóa rương khi đến nơi
            updateChestCount(#chestsFolder:GetChildren()) -- Cập nhật số rương
        end
    end
end

-- 🔥 Bắt đầu di chuyển tự động
autoMoveToChests()
