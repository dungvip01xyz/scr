-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "PlayerListGui"

-- Tạo Frame chứa danh sách
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.Position = UDim2.new(0, 10, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

-- Tạo Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Danh sách người chơi"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = Frame

-- Scroll để chứa tên người chơi
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScrollingFrame.Parent = Frame

-- Hàm cập nhật danh sách người chơi
local function updatePlayerList()
    ScrollingFrame:ClearAllChildren()
    local yPosition = 0

    for _, player in ipairs(game.Players:GetPlayers()) do
        local PlayerLabel = Instance.new("TextLabel")
        PlayerLabel.Size = UDim2.new(1, -10, 0, 25)
        PlayerLabel.Position = UDim2.new(0, 5, 0, yPosition)
        PlayerLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        PlayerLabel.Text = player.Name
        PlayerLabel.TextColor3 = Color3.new(1, 1, 1)
        PlayerLabel.Parent = ScrollingFrame

        yPosition = yPosition + 30
    end

    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition)
end

-- Cập nhật danh sách lúc bắt đầu
updatePlayerList()

-- Cập nhật lại khi có người chơi vào hoặc rời
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)