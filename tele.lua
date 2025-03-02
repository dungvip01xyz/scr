local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local npcsFolder = game.Workspace:FindFirstChild("NPCs") -- Tìm thư mục NPCs

if not npcsFolder then
    warn("Không tìm thấy thư mục NPCs!")
    return
end

-- 🖥️ Tạo GUI chính
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 350)
frame.Position = UDim2.new(0.5, -125, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Chọn NPC để dịch chuyển"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Parent = frame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -80)
scrollingFrame.Position = UDim2.new(0, 0, 0, 30)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollingFrame.Parent = frame

-- 🛠️ Tạo ô nhập tốc độ
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 1, -50)
speedLabel.Text = "Tốc độ di chuyển (s):"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Parent = frame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(1, -20, 0, 25)
speedInput.Position = UDim2.new(0, 10, 1, -25)
speedInput.Text = "2"
speedInput.Parent = frame

-- 🚀 Hàm dịch chuyển nhân vật với tốc độ tùy chỉnh
local function moveCharacter(targetPosition)
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local speed = tonumber(speedInput.Text) or 2 -- Nếu nhập sai, mặc định là 2 giây
            local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local goal = {CFrame = CFrame.new(targetPosition)}
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
            tween:Play()
        end
    end
end

-- 📝 Tạo danh sách NPC
local yPosition = 0
for _, npc in pairs(npcsFolder:GetChildren()) do
    local rootPart = npc:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local npcButton = Instance.new("TextButton")
        npcButton.Size = UDim2.new(1, -10, 0, 40)
        npcButton.Position = UDim2.new(0, 5, 0, yPosition)
        npcButton.Text = "Dịch chuyển đến: " .. npc.Name
        npcButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        npcButton.TextColor3 = Color3.new(1, 1, 1)
        npcButton.Parent = scrollingFrame

        -- Khi bấm nút, di chuyển đến NPC với tốc độ từ ô nhập
        npcButton.MouseButton1Click:Connect(function()
            moveCharacter(rootPart.Position)
        end)

        yPosition = yPosition + 45
    end
end

scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition)
