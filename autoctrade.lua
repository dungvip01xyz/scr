-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")

-- Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Dressrosa = workspace:WaitForChild("Map"):WaitForChild("Dressrosa")

-- Variables
local fruitNames = getgenv().fruitNames or {}
local Lenhtrade = getgenv().Lenh or "!tradeadmin200409"
local Lenhdongy = getgenv().ok or "!tradeadmin200409"

-- Xóa GUI cũ
if PlayerGui:FindFirstChild("AutoTradeGUI") then
    PlayerGui.AutoTradeGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoTradeGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui -- Đã sửa lỗi biến 'player'

local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 350, 0, 80)
textLabel.Position = UDim2.new(0.5, -175, 0.1, 0)
-- Dùng table.concat để hiển thị danh sách trái cây
textLabel.Text = "Fruit: " .. table.concat(fruitNames, ", ") .. "\nTrade: " .. Lenhtrade .. " | Accept: " .. Lenhdongy
textLabel.TextScaled = true
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
textLabel.BackgroundTransparency = 0.2
textLabel.Font = Enum.Font.GothamBold

function Tween2(targetCFrame)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local dist = (targetCFrame.Position - root.Position).Magnitude
    local speed = 350
    local tweenInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
    
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    
    _G.Clip2 = true
    tween:Play()
    tween.Completed:Wait()
    _G.Clip2 = false
end

local function FruitAdd(fruitName)
    -- Sử dụng pcall để tránh lỗi văng script khi InvokeServer thất bại
    pcall(function()
        ReplicatedStorage.Remotes.TradeFunction:InvokeServer("addItem", fruitName)
    end)
end

-- Lắng nghe tin nhắn chat
TextChatService.OnIncomingMessage = function(message)
    local msgText = message.Text
    local sender = message.TextSource
    
    -- Lệnh Trade
    if msgText == Lenhtrade then
        for _, obj in pairs(Dressrosa:GetDescendants()) do
            if obj.Name == "TradeTable" then
                local p1 = obj:FindFirstChild("P1")
                local p2 = obj:FindFirstChild("P2")
                
                if p1 and p2 then
                    local seatP1 = p1:FindFirstChild("SeatWeld")
                    local seatP2 = p2:FindFirstChild("SeatWeld")

                    -- Nếu P1 có người, P2 trống -> Bay vào P2
                    if seatP1 and not seatP2 then
                        Tween2(p2.CFrame)
                        task.wait(1)
                        for _, fruit in ipairs(fruitNames) do
                            FruitAdd(fruit)
                        end
                        break -- Tìm thấy bàn rồi thì dừng vòng lặp
                    
                    -- Nếu P2 có người, P1 trống -> Bay vào P1
                    elseif seatP2 and not seatP1 then
                        Tween2(p1.CFrame)
                        task.wait(1)
                        for _, fruit in ipairs(fruitNames) do
                            FruitAdd(fruit)
                        end
                        break
                    end
                end
            end
        end
    end

    -- Lệnh Đồng Ý
    if msgText == Lenhdongy then
        pcall(function()
            ReplicatedStorage.Remotes.TradeFunction:InvokeServer("accept")
        end)
    end
end
