local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local speed = 350
_G.AutoCollectChest = true
local function flyTo(targetPos)
    local platform = Instance.new("Part")
    platform.Transparency = 1
    platform.Size = Vector3.new(8, 1, 8)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Material = Enum.Material.Neon
    platform.Color = Color3.fromRGB(255, 255, 255)
    platform.Parent = workspace
    local startPos = root.Position
    platform.CFrame = CFrame.new(startPos.X, startPos.Y - 3, startPos.Z)
    local distance = (targetPos - startPos).Magnitude
    local time = distance / speed
    local tween = TweenService:Create(platform, TweenInfo.new(time, Enum.EasingStyle.Linear), {Position = targetPos})

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if root and platform then
            root.CFrame = platform.CFrame + Vector3.new(0, 3, 0)
        else
            connection:Disconnect()
        end
    end)
    tween:Play()
    tween.Completed:Wait()
    connection:Disconnect()
    platform:Destroy()
end
spawn(function()
    while wait() do
        if _G.AutoCollectChest then
            local char = player.Character or player.CharacterAdded:Wait()
            local pos = char:GetPivot().Position
            local chests = game:GetService("CollectionService"):GetTagged("_ChestTagged")
            local minDist, closest = math.huge, nil
            for i = 1, #chests do
                local chest = chests[i]
                local dist = (chest:GetPivot().Position - pos).Magnitude
                if not chest:GetAttribute("IsDisabled") and dist < minDist then
                    minDist, closest = dist, chest
                end
            end
            if closest then
                flyTo(closest:GetPivot().Position)
            end
        end
    end
end)
