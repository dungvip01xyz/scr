-- Map
local Dressrosa = workspace:WaitForChild("Map"):WaitForChild("Dressrosa")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variables
local count = 0
local fruitNames = getgenv().fruitNames
local Lenhtrade = getgenv().Lenh
local Lenhdongy = getgenv().dongy 
-- Xóa GUI cũ nếu tồn tại
if PlayerGui:FindFirstChild("AutoTradeGUI") then
    PlayerGui.AutoTradeGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoTradeGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 350, 0, 80)
textLabel.Position = UDim2.new(0.5, -175, 0.1, 0)
textLabel.Text = "Fruit: " .. tostring(fruitNames) .. "\nTrade: " .. Lenhtrade .. " | Accept: " .. Lenhdongy
textLabel.TextScaled = true
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
textLabel.BorderSizePixel = 0
textLabel.BackgroundTransparency = 0.2
textLabel.Font = Enum.Font.GothamBold
function Tween2(v204)
    local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if human then
        human:ChangeState(Enum.HumanoidStateType.Jumping)
    end
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
    _G.Clip2 = false
end
local function FruitAdd(fruitName)
    ReplicatedStorage.Remotes.TradeFunction:InvokeServer("addItem", fruitName)
end

TextChatService.OnIncomingMessage = function(message)
    if not message.Text then return end

    if message.Text == Lenhtrade then
        
        for _, obj in pairs(Dressrosa:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == "TradeTable" then
                
                local P1 = obj:FindFirstChild("P1") and obj.P1.CFrame
                local P2 = obj:FindFirstChild("P2") and obj.P2.CFrame
                local SeatWeldP1 = obj:FindFirstChild("P1") and obj.P1:FindFirstChild("SeatWeld")
                local SeatWeldP2 = obj:FindFirstChild("P2") and obj.P2:FindFirstChild("SeatWeld")

                count = count + 1
                print("📌 TradeTable #" .. count)

                if SeatWeldP1 and SeatWeldP2 then
                    print("✅ Cả hai ghế đều có người ngồi")
                    
                elseif SeatWeldP1 then
                    print("👉 Ghế 2 trống, di chuyển đến P2")
                    Tween2(P2)
                    task.wait(3)
                    for _, fruit in ipairs(fruitNames) do
                        FruitAdd(fruit)
                    end
                elseif SeatWeldP2 then
                    print("👉 Ghế 1 trống, di chuyển đến P1")
                    Tween2(P1)
                    task.wait(3)
                    for _, fruit in ipairs(fruitNames) do
                        FruitAdd(fruit)
                    end
                else
                    print("❌ Không có ai ở bàn trade")
                end
            end
        end
    end

    if message.Text == Lenhdongy then
        ReplicatedStorage.Remotes.TradeFunction:InvokeServer("accept")
    end
end
