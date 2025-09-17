local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer 
local HttpService = game:GetService("HttpService")
local playerNames = getgenv().CheckpPlayer
local Timecheck = getgenv().Timecheck
local fixlagcheck = getgenv().fixlagcheck
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
        wait(3)
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

if fixlagcheck == true then
    task.spawn(fixlag)
    print("Fix lag đang bật")
end
task.spawn(Getdata)
task.spawn(checkBeli, Timecheck)
