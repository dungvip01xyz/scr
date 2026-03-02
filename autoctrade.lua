-- Map
local Dressrosa = workspace:WaitForChild("Map"):WaitForChild("Dressrosa")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")

-- Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Variables
local count = 0
local fruitName = getgenv().fruitName
local Lenhtrade = getgenv().Lenh
local Lenhdongy = getgenv().dongy 

-- Xóa GUI cũ
if PlayerGui:FindFirstChild("AutoTradeGUI") then
    PlayerGui.AutoTradeGUI:Destroy()
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoTradeGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 350, 0, 80)
textLabel.Position = UDim2.new(0.5, -175, 0.1, 0)
textLabel.Text = "Fruit: " .. tostring(fruitName)
    .. "\nTrade: " .. tostring(Lenhtrade)
    .. " | Accept: " .. tostring(Lenhdongy)
textLabel.TextScaled = true
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
textLabel.BorderSizePixel = 0
textLabel.BackgroundTransparency = 0.2
textLabel.Font = Enum.Font.GothamBold

-- Tween
function Tween2(targetCFrame)
    local distance = (targetCFrame.Position - root.Position).Magnitude
    local speed = 350
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)

    local tween = TweenService:Create(root, tweenInfo, {
        CFrame = targetCFrame
    })

    tween:Play()
    tween.Completed:Wait()
end

-- Add fruit
local function FruitAdd(name)
    ReplicatedStorage.Remotes.TradeFunction:InvokeServer("addItem", name)
end

-- Chat event
TextChatService.OnIncomingMessage = function(message)
    if not message.Text then return end

    if message.Text == Lenhtrade then
        for _, obj in pairs(Dressrosa:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == "TradeTable" then
                
                local P1 = obj:FindFirstChild("P1")
                local P2 = obj:FindFirstChild("P2")
                local SeatWeldP1 = P1 and P1:FindFirstChild("SeatWeld")
                local SeatWeldP2 = P2 and P2:FindFirstChild("SeatWeld")

                if SeatWeldP1 and not SeatWeldP2 then
                    Tween2(P2.CFrame)
                    task.wait(3)
                    FruitAdd(fruitName)

                elseif SeatWeldP2 and not SeatWeldP1 then
                    Tween2(P1.CFrame)
                    task.wait(3)
                    FruitAdd(fruitName)
                end
            end
        end
    end

    if message.Text == Lenhdongy then
        ReplicatedStorage.Remotes.TradeFunction:InvokeServer("accept")
    end
end
