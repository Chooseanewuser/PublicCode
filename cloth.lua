getgenv().HempColour = getgenv().HempColour or Color3.fromRGB(0, 255, 0)
getgenv().HempESP = getgenv().HempESP or false

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local plantFolder = workspace:WaitForChild("Plants", 30)
if not plantFolder then 
    warn("Plants folder not found!") 
    return 
end

local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

lp.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
end)

local plantCache = {}

local function clearCache()
    for _, label in pairs(plantCache) do
        label:Remove()
    end
    table.clear(plantCache)
end

local function drawESP(plantModel)
    if plantCache[plantModel] then 
        plantCache[plantModel]:Remove()
        plantCache[plantModel] = nil
    end
    
    local label = Drawing.new("Text")
    label.Text = "Cloth"
    label.Size = 13
    label.Font = 2
    label.Color = getgenv().HempColour
    label.Outline = true
    label.OutlineColor = Color3.fromRGB(0, 0, 0)
    label.Center = true
    label.Visible = getgenv().HempESP
    plantCache[plantModel] = label
end

game:GetService("RunService").RenderStepped:Connect(function()
    for _, plant in ipairs(plantFolder:GetChildren()) do
        if not plant:IsA("Model") or plant.Name ~= "Wool Plant" then continue end

        if not plantCache[plant] then
            drawESP(plant)
        end

        local plantPos = plant:GetPivot().Position
        local distance = (hrp.Position - plantPos).Magnitude
        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(plantPos)

        if onScreen then
            local label = plantCache[plant]
            label.Position = Vector2.new(screenPos.X, screenPos.Y)
            label.Text = "Cloth"
            label.Visible = getgenv().HempESP
            label.Position = Vector2.new(screenPos.X, screenPos.Y + 15)
            label.Text = string.format("Cloth\n%.0fm", distance)
        else
            local label = plantCache[plant]
            if label then
                label.Visible = false
            end
        end
    end

    for plantModel, label in pairs(plantCache) do
        if plantModel.Parent == nil then
            label:Remove()
            plantCache[plantModel] = nil
        end
    end
end)

local oldHempColour = getgenv().HempColour
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().HempColour ~= oldHempColour then
        oldHempColour = getgenv().HempColour
        clearCache()
        for _, plant in ipairs(plantFolder:GetChildren()) do
            if plant:IsA("Model") and plant.Name == "Wool Plant" then
                drawESP(plant)
            end
        end
    end
end)
