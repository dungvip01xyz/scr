_G.AutoCollectChest = true
_G.EnableFootPlate = true
loadstring(game:HttpGet("https://raw.githubusercontent.com/dungvip01xyz/scr/refs/heads/main/showbeli"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local VirtualUser = game:GetService("VirtualUser")
task.spawn(function()
	while task.wait(0.3) do
		if _G.EnableFootPlate and root and root.Parent then
			local part = Instance.new("Part")
			part.Size = Vector3.new(6, 1, 6)
			part.Anchored = true
			part.CanCollide = true -- ✅ Có thể đứng được
			part.Material = Enum.Material.ForceField
			part.Color = Color3.fromRGB(0, 255, 0)
			part.Transparency = 0.2
			part.CFrame = root.CFrame * CFrame.new(0, -4, 0)
			part.Parent = workspace

			-- ✨ Mờ dần và biến mất
			task.spawn(function()
				for i = 1, 20 do
					part.Transparency = part.Transparency + 0.04
					task.wait(0.1)
				end
				part:Destroy()
			end)
		end
	end
end)
local LocalPlayer = Players.LocalPlayer
local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
player.Idled:Connect(function()
    print("[ANTI-AFK] Detected idle, preventing...")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
task.spawn(function()
    while true do
        task.wait(300) -- 300 giây

        print("[ANTI-AFK] Auto Move + Click")

        -- Click chuột phải
        VirtualUser:ClickButton2(Vector2.new())

        -- Di chuột nhẹ (5px → 10px)
        VirtualUser:MoveMouse(Vector2.new(5, 10))
        task.wait(0.1)
        VirtualUser:MoveMouse(Vector2.new(10, 5))
    end
end)
function Tween2(v204)
    local v205 = (v204.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude;
    local v206 = 350;
    if (v205 >= 350) then
        v206 = 350;
    end
    local v207 = TweenInfo.new(v205 / v206, Enum.EasingStyle.Linear);
    local v208 = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, v207, {
        CFrame = v204
    });
    v208:Play();
    if _G.CancelTween2 then
        v208:Cancel();
    end
    _G.Clip2 = true;
    wait(v205 / v206);
    _G.Clip2 = false;
    wait(1)
    local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if human then
        human:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end
spawn(function()
    while wait() do
        if _G.AutoCollectChest then
            local v673 = game:GetService("Players");
            local v674 = v673.LocalPlayer;
            local v675 = v674.Character or v674.CharacterAdded:Wait() ;
            local v676 = v675:GetPivot().Position;
            local v677 = game:GetService("CollectionService");
            local v678 = v677:GetTagged("_ChestTagged");
            local v679, v680 = math.huge;
            for v765 = 1, # v678 do
                local v766 = v678[v765];
                local v767 = (v766:GetPivot().Position - v676).Magnitude;
                if (not v766:GetAttribute("IsDisabled") and (v767 < v679)) then
                    v679, v680 = v767, v766;
                end
            end
            if v680 then
                local v840 = v680:GetPivot().Position;
                local v841 = CFrame.new(v840);
                Tween2(v841);
            end
        end
    end
end);
