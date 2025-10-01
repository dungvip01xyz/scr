local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

-- Hàm nhấn phím
local function sendKey(keyCode, holdTime)
    holdTime = tonumber(holdTime) or 0.1
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)  -- nhấn
    task.wait(holdTime)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game) -- thả
end

-- Hàm tween di chuyển
function Tween2(v204)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local v205 = (v204.Position - root.Position).Magnitude
    local v206 = 350
    if v205 >= 350 then
        v206 = 350
    end

    local v207 = TweenInfo.new(v205 / v206, Enum.EasingStyle.Linear)
    local v208 = TweenService:Create(root, v207, { CFrame = v204 })
    v208:Play()

    if _G.CancelTween2 then
        v208:Cancel()
    end
    _G.Clip2 = true
    task.wait(v205 / v206)
    _G.Clip2 = false
    task.wait(1)
end
TextChatService.OnIncomingMessage = function(message)
    if message.Text and message.Text == "/gocafe" then
        local sender
        if message.TextSource then
            sender = Players:GetPlayerByUserId(message.TextSource.UserId)
        end
        if sender and sender.Character and sender.Character:FindFirstChild("HumanoidRootPart") then
            local targetCFrame = sender.Character.HumanoidRootPart.CFrame
            Tween2(targetCFrame)
            sendKey(Enum.KeyCode.F, 0.2)
            Tween2(targetCFrame + Vector3.new(0, 200, 0))
            Tween2(CFrame.new(-461.385986328125, 100, 257.468994140625))
            sendKey(Enum.KeyCode.F, 0.2)
            Tween2(targetCFrame + Vector3.new(0, 200, 0))
        end
    end
end
