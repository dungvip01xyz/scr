local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer 
local HttpService = game:GetService("HttpService")
local playerNames = getgenv().CheckpPlayer
function selectTeam()
    while localPlayer.Neutral do
        local args = {
            [1] = "SetTeam",
            [2] = "Pirates"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        wait(1)
    end
end

function Hop()
    local v372 = game.PlaceId;
    local v373 = {};
    local v374 = "";
    local v375 = os.date("!*t").hour;
    local v376 = false;
    function TPReturner()
        local v556;
        if (v374 == "") then
            v556 = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. v372 .. "/servers/Public?sortOrder=Asc&limit=100"));
        else
            v556 = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. v372 .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. v374));
        end
        local v557 = "";
        if (v556.nextPageCursor and (v556.nextPageCursor ~= "null") and (v556.nextPageCursor ~= nil)) then
            v374 = v556.nextPageCursor;
        end
        local v558 = 0;
        for v651, v652 in pairs(v556.data) do
            local v653 = true;
            v557 = tostring(v652.id);
            if (tonumber(v652.maxPlayers) > tonumber(v652.playing)) then
                for v872, v873 in pairs(v373) do
                    if (v558 ~= 0) then
                        if (v557 == tostring(v873)) then
                            v653 = false;
                        end
                    elseif (tonumber(v375) ~= tonumber(v873)) then
                        local v1472 = pcall(function()
                            v373 = {};
                            table.insert(v373, v375);
                        end);
                    end
                    v558 = v558 + 1 ;
                end
                if (v653 == true) then
                    table.insert(v373, v557);
                    wait();
                    pcall(function()
                        wait();
                        game:GetService("TeleportService"):TeleportToPlaceInstance(v372, v557, game.Players.LocalPlayer);
                    end);
                    wait();
                end
            end
        end
    end
    function v118()
        while wait() do
            pcall(function()
                TPReturner();
                if (v374 ~= "") then
                    TPReturner();
                end
            end);
        end
    end
    v118();
end
function fixlag()
    local lighting = game:GetService("Lighting")
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    if lighting:FindFirstChild("FantasySky") then
        lighting.FantasySky:Destroy()
    end
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    for _, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then 
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
            v.TextureID = "rbxassetid://10385902758728957"
        end
    end
    for _, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or 
           e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
    for _, v in pairs(game:GetService("Workspace").Camera:GetDescendants()) do
        if v:IsA("Part") and v.Material == Enum.Material.Water then
            v.Transparency = 1
            v.Material = Enum.Material.Plastic
        end
    end
end
function checkBeli(time)
    while true do
        local beliBefore = localPlayer.Data.Beli.Value -- Lấy giá trị Beli ban đầu
        local startTime = tick() -- Lấy thời gian bắt đầu
        while tick() - startTime < time do
            local remainingTime = time - (tick() - startTime) -- Tính thời gian còn lại
            print("Thời gian còn lại: " .. math.ceil(remainingTime) .. " giây") -- Làm tròn lên
            wait(1)
        end
        local beliAfter = localPlayer.Data.Beli.Value 
        if beliAfter > beliBefore then
            print("Beli đã tăng! 🤑")
        elseif beliAfter < beliBefore then
            print("Beli đã giảm! 😢")
            while true do
                task.spawn(Hop)
                task.wait(1) -- nên có delay nếu không thì Roblox sẽ crash hoặc lag
            end            
            break
        else
            print("Beli không thay đổi. 😐")
            while true do
                task.spawn(Hop)
                task.wait(1) -- nên có delay nếu không thì Roblox sẽ crash hoặc lag
            end            
            break
        end
    end
end
local function Getdata()
    while true do
        if localPlayer and localPlayer:FindFirstChild("Data") then
            local playerData = {
                DisplayName = localPlayer.DisplayName,
                Username = localPlayer.Name,
                Level = localPlayer.Data.Level.Value,
                Beli = localPlayer.Data.Beli.Value,
                Fragments = localPlayer.Data.Fragments.Value,
                Race = localPlayer.Data.Race.Value,
                DevilFruit = localPlayer.Data.DevilFruit.Value
            }
            local jsonData = HttpService:JSONEncode(playerData)
            writefile("data.json", jsonData)
            print("Đã lưu thông tin người chơi vào data.json")
        else
            print("Không tìm thấy dữ liệu người chơi!")
        end
        wait(60)
    end
end
for _, playerName in ipairs(playerNames) do 
    if playerName == localPlayer.Name then
        print("Tên tôi có trong danh sách, bỏ qua kiểm tra.") 
    else
        local player = Players:FindFirstChild(playerName)
        if player then
            print(playerName .. " đang ở trong server, tôi thoát game.")
            while true do
                task.spawn(Hop)
                task.wait(1) -- nên có delay nếu không thì Roblox sẽ crash hoặc lag
            end            
            break 
        else
            print(playerName .. " không có trong server, tôi ở lại.")
        end
    end
end
function EnableAntiAFK()
    local vu = game:GetService("VirtualUser")
    repeat wait() until game:IsLoaded()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end

_G.FarmChest = true
task.spawn(selectTeam)
task.spawn(fixlag)
task.spawn(Getdata)
task.spawn(checkBeli, 120)
task.spawn(EnableAntiAFK)

function WaitHRP(q0)
    if not q0 then return end
    return q0.Character:WaitForChild("HumanoidRootPart", 9)
end
function requestEntrance(teleportPos)
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", teleportPos)
    local char = game.Players.LocalPlayer.Character.HumanoidRootPart
    char.CFrame = char.CFrame + Vector3.new(0, 50, 0)
    task.wait(0.5)
end
function CheckNearestTeleporter(aI)
    local vcspos = aI.Position
    local minDist = math.huge
    local chosenTeleport = nil
    local y = game.PlaceId

    local TableLocations = {}

    if y == 2753915549 then
        TableLocations = {
            ["Sky3"] = Vector3.new(-7894, 5547, -380),
            ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
            ["UnderWater"] = Vector3.new(61163, 11, 1819),
            ["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),
            ["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.787059783935547, 3901.282958984375),
            ["UnderwaterExit"] = Vector3.new(4050, -1, -1814)
        }
    elseif y == 4442272183 then
        TableLocations = {
            ["Swan Mansion"] = Vector3.new(-390, 332, 673),
            ["Swan Room"] = Vector3.new(2285, 15, 905),
            ["Cursed Ship"] = Vector3.new(923, 126, 32852),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    elseif y == 7449423635 then
        TableLocations = {
            ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
            ["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),
            ["Mansion"] = Vector3.new(-12462, 375, -7552),
            ["Castle"] = Vector3.new(-5036, 315, -3179),
            ["Dimensional Shift"] = Vector3.new(-2097.3447265625, 4776.24462890625, -15013.4990234375),
            ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
            ["Beautiful Room"] = Vector3.new(5314.58203, 22.5364361, -125.942276, 1, 2.14762768e-08, -1.99111154e-13, -2.14762768e-08, 1, -3.0510602e-08, 1.98455903e-13, 3.0510602e-08, 1),
            ["Temple of Time"] = Vector3.new(28286, 14897, 103)
        }
    end

    for _, v in pairs(TableLocations) do
        local dist = (v - vcspos).Magnitude
        if dist < minDist then
            minDist = dist
            chosenTeleport = v
        end
    end

    local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    if minDist <= (vcspos - playerPos).Magnitude then
        return chosenTeleport
    end
end

function topos(Pos)
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("HumanoidRootPart") then
        local Distance = (Pos.Position - plr.Character.HumanoidRootPart.Position).Magnitude
        if not Pos then 
            return 
        end
        local nearestTeleport = CheckNearestTeleporter(Pos)
        if nearestTeleport then
            requestEntrance(nearestTeleport)
        end
        if not plr.Character:FindFirstChild("PartTele") then
            local PartTele = Instance.new("Part", plr.Character)
            PartTele.Size = Vector3.new(10,1,10)
            PartTele.Name = "PartTele"
            PartTele.Anchored = true
            PartTele.Transparency = 1
            PartTele.CanCollide = true
            PartTele.CFrame = WaitHRP(plr).CFrame 
            PartTele:GetPropertyChangedSignal("CFrame"):Connect(function()
                if not isTeleporting then return end
                task.wait()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    WaitHRP(plr).CFrame = PartTele.CFrame
                end
            end)
        end
        isTeleporting = true
        local Tween = game:GetService("TweenService"):Create(plr.Character.PartTele, TweenInfo.new(Distance / 360, Enum.EasingStyle.Linear), {CFrame = Pos})
        Tween:Play()
        Tween.Completed:Connect(function(status)
            if status == Enum.PlaybackState.Completed then
                if plr.Character:FindFirstChild("PartTele") then
                    plr.Character.PartTele:Destroy()
                end
                isTeleporting = false
            end
        end)
    end
end
spawn(function()
	while wait() do
		if _G.FarmChest then
			local Players = game:GetService("Players")
			local Player = Players.LocalPlayer
			local Character = Player.Character or Player.CharacterAdded:Wait()
			local Position = Character:GetPivot().Position
			local CollectionService = game:GetService("CollectionService")
			local Chests = CollectionService:GetTagged("_ChestTagged")
			local Distance, Nearest = math.huge
			for i = 1, #Chests do
				local Chest = Chests[i]
				local Magnitude = (Chest:GetPivot().Position - Position).Magnitude
				if (not Chest:GetAttribute("IsDisabled") and (Magnitude < Distance)) then
					Distance, Nearest = Magnitude, Chest
				end
			end
			if Nearest then
				local ChestPosition = Nearest:GetPivot().Position
				local CFrameTarget = CFrame.new(ChestPosition)
				topos(CFrameTarget)
			end
		end
	end
end)
