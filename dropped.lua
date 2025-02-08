getgenv().DroppedItems = getgenv().DroppedItems or false
getgenv().DroppedItemsColour = getgenv().DroppedItemsColour or Color3.fromRGB(255, 255, 255)
getgenv().DroppedItemsDistance = getgenv().DroppedItemsDistance or 1000

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local dropsFolder = workspace:WaitForChild("Drops", 30)
if not dropsFolder then
    warn("Drops folder not found!")
    return
end

local lp = game.Players.LocalPlayer
local hrp = nil

local function updateHRP()
    local char = lp.Character or lp.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
end

lp.CharacterAdded:Connect(updateHRP)
updateHRP()

local dropsCache = {}

local function clearCache()
    for _, label in pairs(dropsCache) do
        label:Remove()
    end
    table.clear(dropsCache)
end

local function drawESP(dropModel)
    if dropsCache[dropModel] then
        dropsCache[dropModel]:Remove()
        dropsCache[dropModel] = nil
    end

    local label = Drawing.new("Text")
    label.Text = dropModel.Name
    label.Size = 13
    label.Font = 2
    label.Color = getgenv().DroppedItemsColour
    label.Outline = true
    label.OutlineColor = Color3.fromRGB(0, 0, 0)
    label.Center = true
    label.Visible = getgenv().DroppedItems
    dropsCache[dropModel] = label
end

game:GetService("RunService").RenderStepped:Connect(function()
    if not hrp or not hrp.Parent then
        updateHRP()
        return
    end

    if not getgenv().DroppedItems then
        clearCache()
        return
    end

    for _, drop in ipairs(dropsFolder:GetChildren()) do
        if not drop:IsA("Model") then
            continue
        end

        local dropPos = drop:GetPivot().Position
        local distance = (hrp.Position - dropPos).Magnitude
        if distance > getgenv().DroppedItemsDistance then
            if dropsCache[drop] then
                dropsCache[drop].Visible = false
            end
            continue
        end

        if not dropsCache[drop] then
            drawESP(drop)
        end

        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(dropPos)
        local label = dropsCache[drop]
        if onScreen then
            label.Position = Vector2.new(screenPos.X, screenPos.Y)
            label.Text = string.format("%s\n%.0fm", drop.Name, distance)
            label.Visible = true
        else
            label.Visible = false
        end
    end

    for dropModel, label in pairs(dropsCache) do
        if dropModel.Parent == nil then
            label:Remove()
            dropsCache[dropModel] = nil
        end
    end
end)

local oldDroppedItemsColour = getgenv().DroppedItemsColour
local oldDroppedItemsDistance = getgenv().DroppedItemsDistance

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().DroppedItemsColour ~= oldDroppedItemsColour then
        oldDroppedItemsColour = getgenv().DroppedItemsColour
        clearCache()
        for _, drop in ipairs(dropsFolder:GetChildren()) do
            if drop:IsA("Model") then
                drawESP(drop)
            end
        end
    end

    if getgenv().DroppedItemsDistance ~= oldDroppedItemsDistance then
        oldDroppedItemsDistance = getgenv().DroppedItemsDistance
        clearCache()
    end
end)
