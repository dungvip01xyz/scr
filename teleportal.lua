local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local holdingMouse = false -- khai báo biến giữ chuột

-- Hàm nhấn + thả phím
local function sendKey(keyCode, holdTime)
    holdTime = tonumber(holdTime) or 0.1
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)  -- nhấn
    task.wait(holdTime)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game) -- thả
end

-- Hàm nhấn chuột
local function pressMouse()
    if not holdingMouse then
        VirtualInputManager:SendMouseButtonEvent(231, 370, 0, true, game, 1)
        holdingMouse = true
    end
end

-- Hàm thả chuột (đã fix)
local function releaseMouse()
    if holdingMouse then
        VirtualInputManager:SendMouseButtonEvent(231, 370, 0, false, game, 1) -- false = thả
        holdingMouse = false
    end
end

-- Tween di chuyển
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
end

-- Lấy vị trí nhân vật
local function getPlayerPosition(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return player.Character.HumanoidRootPart.Position
    end
    return nil
end

-- Vòng lặp chính
while true do
    local myPos = getPlayerPosition(LocalPlayer)
    if myPos then
        Tween2(CFrame.new(myPos + Vector3.new(0, 200, 0)))
        Tween2(CFrame.new(-9.307762145996094, 15.624999046325684, 2833.193603515625))
        sendKey(Enum.KeyCode.C, 0.2)
        task.wait(3)
        pressMouse()
        releaseMouse()
        task.wait(12)
    else
        task.wait(1)
    end
end
