local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

-- Trạng thái
local holdingMouse = false
local autoFishing = false

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

-- GUI Toggle
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
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
        releaseMouse() -- đảm bảo chuột thả khi tắt
    end
end)

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
                            print("Rope = 0 -> Click!")
                            pressMouse()
                            task.wait(0.2)
                            releaseMouse()
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
