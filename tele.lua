local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local npcsFolder = game.Workspace:FindFirstChild("NPCs")

if not npcsFolder then
    warn("Không tìm thấy thư mục NPCs!")
    return
end

-- 🖥️ Tạo GUI chính
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- 🛠️ Nút bật/tắt menu
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Menu"
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Parent = screenGui

-- 📌 Frame 1: Nhập tốc độ di chuyển
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0, 200, 0, 100)
speedFrame.Position = UDim2.new(0.1, 0, 0.5, -50)
speedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedFrame.Visible = false -- Mặc định ẩn
speedFrame.Parent = screenGui

local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(1, 0, 0, 30)
speedTitle.Text = "Nhập tốc độ di chuyển"
speedTitle.TextColor3 = Color3.new(1, 1, 1)
speedTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedTitle.Parent = speedFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(1, -20, 0, 30)
speedInput.Position = UDim2.new(0, 10, 0, 40)
speedInput.Text = "2"
speedInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Parent = speedFrame

-- 📌 Frame 2: Chọn NPC để dịch chuyển
local npcFrame = Instance.new("Frame")
npcFrame.Size = UDim2.new(0, 250, 0, 300)
npcFrame.Position = UDim2.new(0.6, 0, 0.5, -150)
npcFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
npcFrame.Visible = false -- Mặc định ẩn
npcFrame.Parent = screenGui

local npcTitle = Instance.new("TextLabel")
npcTitle.Size = UDim2.new(1, 0, 0, 30)
npcTitle.Text = "Chọn NPC để dịch chuyển"
npcTitle.TextColor3 = Color3.new(1, 1, 1)
npcTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
npcTitle.Parent = npcFrame

local npcScrollingFrame = Instance.new("ScrollingFrame")
npcScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
npcScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
npcScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
npcScrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
npcScrollingFrame.Parent = npcFrame

-- 🚀 Hàm dịch chuyển nhân vật
local function moveCharacter(targetPosition)
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local speed = tonumber(speedInput.Text) or 2 -- Nếu nhập sai, mặc định 2 giây
            local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local goal = {CFrame = CFrame.new(targetPosition)}
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
            tween:Play()
        end
    end
end

-- 📝 Chọn 2 NPC để dịch chuyển
local yPosition = 0
local npcCount = 0
for _, npc in pairs(npcsFolder:GetChildren()) do
    if npcCount >= 2 then break end -- Chỉ lấy 2 NPC
    local rootPart = npc:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local npcButton = Instance.new("TextButton")
        npcButton.Size = UDim2.new(1, -10, 0, 40)
        npcButton.Position = UDim2.new(0, 5, 0, yPosition)
        npcButton.Text = "Dịch chuyển đến: " .. npc.Name
        npcButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        npcButton.TextColor3 = Color3.new(1, 1, 1)
        npcButton.Parent = npcScrollingFrame

        -- Khi bấm nút, di chuyển đến NPC với tốc độ nhập vào
        npcButton.MouseButton1Click:Connect(function()
            moveCharacter(rootPart.Position)
        end)

        yPosition = yPosition + 45
        npcCount = npcCount + 1
    end
end

npcScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition)

-- 🔄 Toggle menu khi bấm nút
toggleButton.MouseButton1Click:Connect(function()
    local isVisible = not speedFrame.Visible
    speedFrame.Visible = isVisible
    npcFrame.Visible = isVisible
end)
