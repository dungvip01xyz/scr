local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Name = "TeleportGui"

-- Tạo Frame (khung menu)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0.5, -125, 0.5, -90) -- Canh giữa màn hình
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

-- Tạo TextLabel (tiêu đề)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Nhập Tọa Độ"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Parent = frame

-- Tạo 3 TextBox để nhập X, Y, Z
local textBoxX = Instance.new("TextBox")
textBoxX.Size = UDim2.new(1, -20, 0, 30)
textBoxX.Position = UDim2.new(0, 10, 0, 40)
textBoxX.PlaceholderText = "Nhập X"
textBoxX.Parent = frame

local textBoxY = textBoxX:Clone()
textBoxY.Position = UDim2.new(0, 10, 0, 80)
textBoxY.PlaceholderText = "Nhập Y"
textBoxY.Parent = frame

local textBoxZ = textBoxX:Clone()
textBoxZ.Position = UDim2.new(0, 10, 0, 120)
textBoxZ.PlaceholderText = "Nhập Z"
textBoxZ.Parent = frame

-- Tạo nút "Di chuyển"
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 30)
teleportButton.Position = UDim2.new(0, 10, 0, 160)
teleportButton.Text = "Di chuyển"
teleportButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.Parent = frame

-- Xử lý khi bấm nút
teleportButton.MouseButton1Click:Connect(function()
    local x = tonumber(textBoxX.Text) or 0
    local y = tonumber(textBoxY.Text) or 0
    local z = tonumber(textBoxZ.Text) or 0

    if player.Character then
        player.Character:SetPrimaryPartCFrame(CFrame.new(x, y, z)) -- Dịch chuyển nhân vật
    end
end)
