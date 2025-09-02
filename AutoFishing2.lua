local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")
local vim = game:GetService("VirtualInputManager")

-- Biến chính
local key = "Four" -- mặc định bấm số 4
local holdingMouse = false
local autoFishing = false

-- Hàm bấm phím
local function sendKey(keyName, holdTime)
    holdTime = tonumber(holdTime) or 0.1
    local keyCode = Enum.KeyCode[keyName]
    if not keyCode then
        warn("Phím '" .. tostring(keyName) .. "' không hợp lệ!")
        return
    end
    vim:SendKeyEvent(true, keyCode, false, game)
    task.wait(holdTime)
    vim:SendKeyEvent(false, keyCode, false, game)
end

-- Vị trí click (giữa ngang, 1/4 dọc màn hình)
local screenX = camera.ViewportSize.X / 2
local screenY = camera.ViewportSize.Y / 4

-- Hàm nhấn chuột
local function pressMouse()
    if not holdingMouse then
        VirtualInputManager:SendMouseButtonEvent(screenX, screenY, 0, true, game, 1)
        holdingMouse = true
    end
end

-- Hàm thả chuột
local function releaseMouse()
    if holdingMouse then
        VirtualInputManager:SendMouseButtonEvent(screenX, screenY, 0, false, game, 1)
        holdingMouse = false
    end
end

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)

-- Nút bật/tắt AutoFishing
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 160, 0, 40)
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleButton.Text = "AutoFishing: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18

-- Label hiển thị phím hiện tại
local CurrentKeyLabel = Instance.new("TextLabel", ScreenGui)
CurrentKeyLabel.Size = UDim2.new(0, 160, 0, 30)
CurrentKeyLabel.Position = UDim2.new(0.05, 0, 0.1, 45)
CurrentKeyLabel.Text = "Key hiện tại: " .. key
CurrentKeyLabel.BackgroundTransparency = 1
CurrentKeyLabel.TextColor3 = Color3.new(1,1,1)
CurrentKeyLabel.Font = Enum.Font.SourceSansBold
CurrentKeyLabel.TextSize = 16

ToggleButton.MouseButton1Click:Connect(function()
    autoFishing = not autoFishing
    if autoFishing then
        ToggleButton.Text = "AutoFishing: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleButton.Text = "AutoFishing: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        releaseMouse()
    end
end)

-- Frame chọn phím
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 160, 0, 200)
KeyFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local Scrolling = Instance.new("ScrollingFrame", KeyFrame)
Scrolling.Size = UDim2.new(1, 0, 1, 0)
Scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
Scrolling.ScrollBarThickness = 6
Scrolling.BackgroundTransparency = 1

-- Danh sách phím hiển thị
local keyList = {"One","Two","Three","Four","Five","Six","Seven"}

for i, keyName in ipairs(keyList) do
    local btn = Instance.new("TextButton", Scrolling)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, (i-1)*35)
    btn.Text = "Chọn phím: " .. keyName
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16

    btn.MouseButton1Click:Connect(function()
        key = keyName
        CurrentKeyLabel.Text = "Key hiện tại: " .. key
        print("Đã chọn phím: " .. key)
    end)
end
Scrolling.CanvasSize = UDim2.new(0, 0, 0, #keyList * 35)

-- ================= AUTO FISHING =================

-- Kiểm tra ParticleEmitter
task.spawn(function()
    while task.wait(0.5) do
        if autoFishing then
            local ok, emitter = pcall(function()
                return Workspace.Characters[player.Name].Head.Attachment.ParticleEmitter
            end)
            if ok and emitter then
                pressMouse()
                task.wait(0.1)
                releaseMouse()
            end
        end
    end
end)

-- Kiểm tra Rope + VanityBobber
task.spawn(function()
    while task.wait(0.2) do
        if autoFishing then
            local character = Workspace:FindFirstChild("Characters"):FindFirstChild(player.Name)
            if character then
                local fishingRod = character:FindFirstChild("Fishing Rod")
                if fishingRod then
                    -- Rope
                    local bobber = fishingRod:FindFirstChild("Bobber")
                    if bobber then
                        local rope = bobber:FindFirstChild("RopeConstraint")
                        if rope and rope.Length == 0 then
                            print("Rope = 0 -> bấm phím " .. key)
                            sendKey(key, 0.2)
                            task.wait(1)
                            sendKey(key, 0.2)
                        end
                    end
                    -- VanityBobber
                    local vanityBobber = fishingRod:FindFirstChild("VanityBobber")
                    if vanityBobber then
                        print("Có VanityBobber -> Auto click")
                        pressMouse()
                        task.wait(1)
                        releaseMouse()
                        pressMouse()
                        task.wait(2)
                        releaseMouse()
                    end
                end
            end
        end
    end
end)

-- Minigame (Fish & ReelZone)
local function getReelZone()
    local ok, reelZone = pcall(function()
        return playerGui.Fishing_Reeling.Minigame.Container.ReelZone
    end)
    if ok then return reelZone end
end

local function getFish()
    local ok, fish = pcall(function()
        return playerGui.Fishing_Reeling.Minigame.Container.Fish
    end)
    if ok then return fish end
end

RunService.RenderStepped:Connect(function()
    if autoFishing then
        local fish = getFish()
        local reelZone = getReelZone()
        if fish and reelZone then
            if fish.AbsolutePosition.X > reelZone.AbsolutePosition.X then
                pressMouse()
            else
                releaseMouse()
            end
        end
    end
end)
