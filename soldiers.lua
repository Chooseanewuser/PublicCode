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
        if not getgenv().SoldierESP then
            for _, label in pairs(soldierCache) do
                label:Remove()
            end
            soldierCache = {}
            return
        end
        
        for _, folder in pairs(workspace.Military:GetChildren()) do
            if folder:IsA("Folder") then
                for _, model in ipairs(folder:GetChildren()) do
                    if model:IsA("Model") and model:FindFirstChild("Humanoid") and model.Name == "Soldier" then
                        local humanoid = model:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            if not soldierCache[model] then
                                drawESP(model)
                            end
                            local health = math.floor(humanoid.Health)
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
                        elseif soldierCache[model] then
                            soldierCache[model]:Remove()
                            soldierCache[model] = nil
                        end
                    end
                end
            end
        end
        
        for soldierModel, label in pairs(soldierCache) do
            if soldierModel.Parent == nil or (soldierModel:FindFirstChild("Humanoid") and soldierModel.Humanoid.Health <= 0) then
                label:Remove()
                soldierCache[soldierModel] = nil
            end
        end
    end)
end)
