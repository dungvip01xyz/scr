local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local chestsFolder = game.Workspace:FindFirstChild("ChestModels")

if not chestsFolder then
    warn("Không tìm thấy thư mục ChestModels!")
    return
end

-- 🏃 Hàm di chuyển đến 1 vị trí
local function moveToPosition(targetPosition, speed)
    local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPosition)}
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait() -- Đợi di chuyển xong
end

-- 🔄 Hàm tự động di chuyển qua từng rương
local function autoMoveToChests()
    for _, chest in ipairs(chestsFolder:GetChildren()) do
        local chestRoot = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChild("PrimaryPart")
        if chestRoot then
            moveToPosition(chestRoot.Position, 3) -- Di chuyển với tốc độ 3 giây mỗi lần
        end
    end
end

-- 🚀 Bắt đầu di chuyển tự động
autoMoveToChests()
