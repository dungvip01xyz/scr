local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

-- Chờ nhân vật xuất hiện
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart") -- Gốc di chuyển nhân vật

-- Hàm di chuyển nhân vật đến vị trí mới (x, y, z)
local function moveCharacter(x, y, z)
    local targetPosition = Vector3.new(x, y, z) -- Vị trí đích
    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out) -- 3 giây
    local goal = {CFrame = CFrame.new(targetPosition)} -- Tween CFrame

    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
end

-- Chạy thử nghiệm: di chuyển nhân vật đến (100, 5, 50) sau 2 giây
task.wait(2)
moveCharacter(100, 5, 50)
