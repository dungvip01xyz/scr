local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Tween2 như bạn đưa
function Tween2(v204)
    local distance = (v204.Position - humanoidRootPart.Position).Magnitude
    local speed = 350
    if distance >= 350 then
        speed = 350
    end
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(humanoidRootPart, tweenInfo, {
        CFrame = v204
    })
    tween:Play()
    if _G.CancelTween2 then
        tween:Cancel()
    end
    _G.Clip2 = true
    task.wait(distance / speed)
    _G.Clip2 = false
end

-- Tạo GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Text = "Đang kiểm tra Fisherman..."

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 50)
button.Text = "Dịch chuyển tới Fisherman"
button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true

-- Kiểm tra Fisherman
local function checkFisherman()
    local npcs = workspace:FindFirstChild("NPCs")
    if npcs then
        local fisherman = npcs:FindFirstChild("Fisherman")
        if fisherman and fisherman:FindFirstChild("HumanoidRootPart") then
            statusLabel.Text = "✅ Fisherman tồn tại"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            return fisherman.HumanoidRootPart
        else
            statusLabel.Text = "❌ Không tìm thấy Fisherman"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    else
        statusLabel.Text = "❌ Không có folder NPCs"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
    return nil
end

-- Nút dịch chuyển
button.MouseButton1Click:Connect(function()
    local target = checkFisherman()
    if target then
        Tween2(target.CFrame)
    end
end)

-- Kiểm tra liên tục
task.spawn(function()
    while task.wait(2) do
        checkFisherman()
    end
end)
