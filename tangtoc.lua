local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

if humanoid then
    humanoid.WalkSpeed = 500 -- Tốc độ mặc định là 16, tăng lên 50
end
