local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")
local vim = VirtualInputManager
local hotbar = player.PlayerGui.Backpack.Hotbar.Container
local fishingRodSlot = nil
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 60)
frame.Position = UDim2.new(0, 436, 0, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.AnchorPoint = Vector2.new(0.5, 0)

-- Bo góc Frame
local uICorner = Instance.new("UICorner")
uICorner.CornerRadius = UDim.new(0, 15)
uICorner.Parent = frame

-- Tạo TextLabel với chữ màu xanh
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -20, 1, -20)
textLabel.Position = UDim2.new(0, 10, 0, 10)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- chữ màu xanh lá
-- textLabel.TextColor3 = Color3.fromRGB(0, 170, 255) -- chữ màu xanh dương nếu muốn
textLabel.Font = Enum.Font.GothamBold
textLabel.TextScaled = true
textLabel.Text = "Status"
textLabel.Parent = frame


loadstring(game:HttpGet("https://raw.githubusercontent.com/dungvip01xyz/scr/refs/heads/main/fist.lua"))()

-- Hàm nhấn phím
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

-- Auto fishing
local holdingMouse = false
local autoFishing = false
local screenX = camera.ViewportSize.X / 2
local screenY = camera.ViewportSize.Y / 4

local function pressMouse()
    if not holdingMouse then
        vim:SendMouseButtonEvent(screenX, screenY, 0, true, game, 1)
        holdingMouse = true
    end
end

local function releaseMouse()
    if holdingMouse then
        vim:SendMouseButtonEvent(screenX, screenY, 0, false, game, 1)
        holdingMouse = false
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", playerGui)

-- Toggle AutoFishing
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 140, 0, 40)
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleButton.Text = "AutoFishing: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18

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
-- Tìm slot có Fishing Rod
for _, child in ipairs(hotbar:GetChildren()) do
    if child:GetAttribute("ItemName") == "Fishing Rod" then
        fishingRodSlot = child
        break
    end
end

local keys = {"One","Two","Three","Four","Five","Six"}
local key = nil  -- Biến key khởi tạo trước

if fishingRodSlot then
    local numberLabel = fishingRodSlot:FindFirstChild("Number")
    if numberLabel then
        local so = tonumber(numberLabel.Text)
        if so and so >= 1 and so <= #keys then
            key = keys[so]
            print("Number text: "..so)
            textLabel.Text = "đã tim thấy cần cầu ở cần ở" ..so
            print("Key tương ứng: "..key)
        else
            print("Số trong slot Fishing Rod không hợp lệ: "..tostring(so))
        end
    else
        print("Không tìm thấy Number trong slot Fishing Rod.")
    end
else
    print("Không có Fishing Rod trong hotbar.")
end
task.spawn(function()
    while task.wait(0.1) do
        local character = Workspace:FindFirstChild("Characters"):FindFirstChild(player.Name)
        if character then
            local fishingRod = character:FindFirstChild("Fishing Rod")
            if fishingRod then
                local bobber = fishingRod:FindFirstChild("Bobber")
                if bobber then
                    local rope = bobber:FindFirstChild("RopeConstraint")
                    if rope and rope.Length == 0 then
                        pressMouse()
                        task.wait(1)
                        releaseMouse()
                        task.wait(1)
                        textLabel.Text = "cất cá"
                        pressMouse()
                        task.wait(1)
                        releaseMouse()
                        task.wait(1)
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        if autoFishing then
            local ok, emitter = pcall(function()
                return Workspace.Characters[player.Name].Head.Attachment.ParticleEmitter
            end)
            if ok and emitter then
                textLabel.Text = "bắt đầu kéo cần"
                pressMouse()
                task.wait(0.1)
                releaseMouse()
            end
        end
    end
end)
task.spawn(function()
    while task.wait(1) do
        if autoFishing then
            local character = Workspace:FindFirstChild("Characters"):FindFirstChild(player.Name)
            if character then
                local fishingRod = character:FindFirstChild("Fishing Rod")
                if fishingRod then
                    local bobber = fishingRod:FindFirstChild("Bobber")
                    local vanityBobber = fishingRod:FindFirstChild("VanityBobber")
                    if vanityBobber then
                        textLabel.Text = "Bắt đầu mén cần"
                        pressMouse()
                        task.wait(1)
                        releaseMouse()
                        pressMouse()
                        task.wait(2)
                        releaseMouse()
                        task.wait(1)
                    end
                -- else
                --     textLabel.Text = "Trang bị cần câu"
                --     sendKey(key, 0.2)
                end
            end
        end
    end
end)

local sentZ = false -- cờ để gửi Z 1 lần

RunService.RenderStepped:Connect(function()
    if autoFishing then
        local ok, reelZone = pcall(function()
            return playerGui.Fishing_Reeling.Minigame.Container.ReelZone
        end)
        local ok2, fish = pcall(function()
            return playerGui.Fishing_Reeling.Minigame.Container.Fish
        end)

        if ok and reelZone and ok2 and fish then
            -- Gửi Z chỉ 1 lần khi điều kiện đúng
            if not sentZ then
                textLabel.Text = "Boost"
                sendKey("Z", 0.1)
                sentZ = true
            end

            if fish.AbsolutePosition.X > reelZone.AbsolutePosition.X then
                textLabel.Text = "bắt đầu click"
                pressMouse()
            else
                releaseMouse()
                textLabel.Text = "bỏ click"
            end
        else
            sentZ = false
        end
    else
        sentZ = false
    end
end)

