getgenv().SoldierESP = getgenv().SoldierESP or false
getgenv().SoldierColour = getgenv().SoldierColour or Color3.fromRGB(0, 80, 199)
if not game:IsLoaded() then
    game.Loaded:Wait()
end
pcall(function()
local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local soldierCache = {}
local function drawESP(soldierModel)
    if soldierCache[soldierModel] then return end
    local label = Drawing.new("Text")
    label.Size = 13
    label.Font = 2
    label.Color = getgenv().SoldierColour
    label.Outline = true
    label.OutlineColor = Color3.fromRGB(0, 0, 0)
    label.Center = true
    label.Visible = true
    soldierCache[soldierModel] = label
end
game:GetService("RunService").RenderStepped:Connect(function()
    if not getgenv().SoldierESP then return end
    for _, folder in pairs(workspace.Military:GetChildren()) do
        if folder:IsA("Folder") then
            for _, model in ipairs(folder:GetChildren()) do
                if model:IsA("Model") and model:FindFirstChild("Humanoid") and model.Name == "Soldier" then
                    if not soldierCache[model] then
                        drawESP(model)
                    end
                    local humanoid = model:FindFirstChild("Humanoid")
                    local health = humanoid and math.floor(humanoid.Health) or 0
                    local soldierPos = model:GetPivot().Position
                    local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(soldierPos)
                    local label = soldierCache[model]
                    label.Text = "NPC\n" .. health .. " HP"
                    if onScreen then
                        label.Position = Vector2.new(screenPos.X, screenPos.Y)
                        label.Visible = true
                    else
                        label.Visible = false
                    end
                end
            end
        end
    end
    for soldierModel, label in pairs(soldierCache) do
        if soldierModel.Parent == nil then
            label:Remove()
            soldierCache[soldierModel] = nil
        end
    end
end)
end)
