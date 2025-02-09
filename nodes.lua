getgenv().NodeDistance = getgenv().NodeDistance or 10000
getgenv().Nodes = getgenv().Nodes or "None"

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local nodeFolder = workspace:WaitForChild("Nodes", 30)
if not nodeFolder then
    warn("Nodes folder not found!")
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

local nodeCache = {}

local function clearCache()
    for _, label in pairs(nodeCache) do
        label:Remove()
    end
    table.clear(nodeCache)
end

local function getNodeColor(nodeName)
    return Color3.fromRGB(255, 255, 255)
end

local function getNodeName(nodeName)
    if nodeName == "Metal_Node" then
        return "Metal"
    elseif nodeName == "Phosphate_Node" then
        return "Phosphate"
    elseif nodeName == "Stone_Node" then
        return "Stone"
    else
        return nodeName
    end
end

local function drawESP(nodeModel)
    if nodeCache[nodeModel] then
        nodeCache[nodeModel]:Remove()
        nodeCache[nodeModel] = nil
    end

    local label = Drawing.new("Text")
    label.Text = getNodeName(nodeModel.Name)
    label.Size = 13
    label.Font = 2
    label.Color = getNodeColor(nodeModel.Name)
    label.Outline = true
    label.OutlineColor = Color3.fromRGB(0, 0, 0)
    label.Center = true
    label.Visible = true
    nodeCache[nodeModel] = label
end

game:GetService("RunService").RenderStepped:Connect(function()
    if not hrp or not hrp.Parent then
        updateHRP()
        return
    end

    for _, node in ipairs(nodeFolder:GetChildren()) do
        if not node:IsA("Model") then
            continue
        end

        local nodeColor = getNodeColor(node.Name)
        if nodeColor then
            if not nodeCache[node] then
                drawESP(node)
            end

            local nodePos = node:GetPivot().Position
            local distance = (hrp.Position - nodePos).Magnitude
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(nodePos)

            if distance <= getgenv().NodeDistance then
                local label = nodeCache[node]
                if onScreen then
                    label.Position = Vector2.new(screenPos.X, screenPos.Y)
                    label.Text = string.format("%s\n%.0fm", getNodeName(node.Name), distance)
                    label.Visible = true
                else
                    label.Visible = false
                end
            else
                if nodeCache[node] then
                    nodeCache[node]:Remove()
                    nodeCache[node] = nil
                end
            end
        else
            if nodeCache[node] then
                nodeCache[node]:Remove()
                nodeCache[node] = nil
            end
        end
    end

    for nodeModel, label in pairs(nodeCache) do
        if nodeModel.Parent == nil then
            label:Remove()
            nodeCache[nodeModel] = nil
        end
    end
end)

local oldNodeDistance = getgenv().NodeDistance
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().NodeDistance ~= oldNodeDistance then
        oldNodeDistance = getgenv().NodeDistance
        clearCache()
        for _, node in ipairs(nodeFolder:GetChildren()) do
            if node:IsA("Model") then
                local nodeColor = getNodeColor(node.Name)
                if nodeColor then
                    drawESP(node)
                end
            end
        end
    end
end)
