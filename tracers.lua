local players = game:GetService("Players")
local rs = game:GetService("RunService")
local camera = workspace.CurrentCamera
local localPlayer = players.LocalPlayer
local line = nil
getgenv().Snaplines = getgenv().Snaplines or false
local last = getgenv().Snaplines
rs.RenderStepped:Connect(function()
    if getgenv().Snaplines ~= last then
        last = getgenv().Snaplines
        if line then
            line:Remove()
            line = nil
        end
    end
    if not getgenv().Snaplines then
        return
    end
    local closestplr = nil
    local closestdist = math.huge
    local screenctr = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local headpos, active = camera:WorldToViewportPoint(head.Position)
                if active then
                    local distance = (Vector2.new(headpos.X, headpos.Y) - screenctr).Magnitude
                    if distance < closestdist then
                        closestdist = distance
                        closestplr = player
                    end
                end
            end
        end
    end
    if line then
        line:Remove()
        line = nil
    end
    if closestplr and closestplr.Character then
        local head = closestplr.Character:FindFirstChild("Head")
        if head then
            local headpos, active = camera:WorldToViewportPoint(head.Position)
            if active then
                line = Drawing.new("Line")
                line.Visible = true
                line.From = screenctr
                line.To = Vector2.new(headpos.X, headpos.Y)
                line.Color = Color3.new(1, 1, 1)
                line.Thickness = 2
            end
        end
    end
end)
