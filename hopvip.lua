local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerNames = getgenv().CheckpPlayer
function HopLower()
    local maxplayers, gamelink, goodserver, data_table = math.huge, "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    if not _G.FailedServerID then _G.FailedServerID = {} end
    local function serversearch()
        data_table = game:GetService"HttpService":JSONDecode(game:HttpGetAsync(gamelink))
        for _, v in pairs(data_table.data) do
            pcall(function()
                if type(v) == "table" and v.id and v.playing and tonumber(maxplayers) > tonumber(v.playing) and not table.find(_G.FailedServerID, v.id) then
                    maxplayers = v.playing
                    goodserver = v.id
                end
            end)
        end
    end
    function getservers()
        pcall(serversearch)
        for i, v in pairs(data_table) do
            if i == "nextPageCursor" then
                if gamelink:find"&cursor=" then
                    local a = gamelink:find"&cursor="
                    local b = gamelink:sub(a)
                    gamelink = gamelink:gsub(b, "")
                end
                gamelink = gamelink .. "&cursor=" .. v
                pcall(getservers)
            end
        end
    end
    pcall(getservers)
    wait(.1)
    if goodserver == game.JobId or maxplayers == #game:GetService"Players":GetChildren() - 1 then
    end
    table.insert(_G.FailedServerID, goodserver)
    game:GetService"TeleportService":TeleportToPlaceInstance(game.PlaceId, goodserver)

    while wait(.1) do
        pcall(function()
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end
            game.CoreGui.RobloxPromptGui.promptOverlay.DescendantAdded:Connect(function()
                local GUI = game.CoreGui.RobloxPromptGui.promptOverlay:FindFirstChild("ErrorPrompt")
                if GUI then
                    if GUI.TitleFrame.ErrorTitle.Text == "Disconnected" then
                        if #game.Players:GetPlayers() <= 1 then
                            game.Players.LocalPlayer:Kick("\nRejoining...")
                            wait(.1)
                            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
                        else
                            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
                        end
                    end
                end
            end)
        end)
    end
end
function SuperFixLagMAX()
	wait(10)
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local Terrain = Workspace.Terrain

    -- Tắt hoàn toàn hiệu ứng ánh sáng
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or 
           v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v:Destroy()
        end
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e9
    Lighting.Brightness = 0

    -- Tắt hiệu ứng nước
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1

    -- Xóa toàn bộ hiệu ứng và chi tiết không cần thiết
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("Union") or obj:IsA("MeshPart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.Color = Color3.fromRGB(128, 128, 128) -- Tô màu xám để giảm lag
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj:Destroy()
        elseif obj:IsA("Explosion") then
            obj.BlastPressure = 0
            obj.BlastRadius = 0
        elseif obj:IsA("Fire") or obj:IsA("SpotLight") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj:Destroy()
        end
    end

    -- Xóa mọi vật thể thừa trong Workspace để giảm lag
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Clothing") or obj:IsA("ForceField") or 
           obj:IsA("FaceInstance") or obj:IsA("SpecialMesh") or obj:IsA("SurfaceAppearance") then
            obj:Destroy()
        end
    end

    -- Giảm tải camera tối đa
    local Camera = Workspace.CurrentCamera
    Camera.FieldOfView = 50 -- Giảm xuống để tối ưu FPS
    for _, obj in pairs(Camera:GetDescendants()) do
        if obj:IsA("Part") and obj.Material == Enum.Material.Water then
            obj.Transparency = 1
            obj.Material = Enum.Material.Plastic
        end
    end

    -- Xóa luôn skybox nếu cần
    if Lighting:FindFirstChildOfClass("Sky") then
        Lighting:FindFirstChildOfClass("Sky"):Destroy()
    end

    print("🚀 SuperFixLagMAX: Đã xóa mọi thứ gây lag, FPS tăng cực mạnh!")
end
function CheckpPlayer()
    while true do
        if table.find(playerNames, localPlayer.Name) then
            print("Tên tôi có trong danh sách, bỏ qua kiểm tra.") 
            return
        end
        for _, playerName in ipairs(playerNames) do
            local player = Players:FindFirstChild(playerName)
            if player then
                print(playerName .. " đang ở trong server, tôi thoát game.")
                HopLower()
                return
            end
        end
        print("Không có người chơi nào trong danh sách trong server, tiếp tục kiểm tra...")
        wait(5)  
    end
end
task.spawn(CheckpPlayer)
task.spawn(SuperFixLagMAX)
