getgenv().FOVtoggle = getgenv().FOVtoggle or true
getgenv().FOVsize = getgenv().FOVsize or 100
getgenv().FOVcolour = getgenv().FOVcolour or Color3.fromRGB(255, 255, 255)
getgenv().FillToggle = getgenv().FillToggle or true
getgenv().FillColour = getgenv().FillColour or Color3.fromRGB(66, 135, 245)
getgenv().FillTransparency = getgenv().FillTransparency or 0.2
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local fillCircle, outlineCircle, lastColor, lastFillColor = nil, nil, getgenv().FOVcolour, getgenv().FillColour
local function getScreenCenter()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
end
rs.RenderStepped:Connect(function()
    if getgenv().FOVtoggle then
        if getgenv().FOVcolour ~= lastColor or getgenv().FillColour ~= lastFillColor then
            if fillCircle then
                fillCircle.Color = getgenv().FillColour
                fillCircle.Transparency = getgenv().FillTransparency
            end
            if outlineCircle then
                outlineCircle.Color = getgenv().FOVcolour
            end
            lastColor = getgenv().FOVcolour
            lastFillColor = getgenv().FillColour
        end
        if not fillCircle then
            fillCircle = Drawing.new("Circle")
            fillCircle.Color = getgenv().FillColour
            fillCircle.Thickness = 0
            fillCircle.NumSides = 50
            fillCircle.Filled = true
            fillCircle.Transparency = getgenv().FillTransparency
        end
        if not outlineCircle then
            outlineCircle = Drawing.new("Circle")
            outlineCircle.Color = getgenv().FOVcolour
            outlineCircle.Thickness = 3
            outlineCircle.NumSides = 50
            outlineCircle.Filled = false
            outlineCircle.Transparency = 1
        end
        local center = getScreenCenter()
        fillCircle.Position = center
        fillCircle.Radius = getgenv().FOVsize
        fillCircle.Visible = getgenv().FillToggle
        outlineCircle.Position = center
        outlineCircle.Radius = getgenv().FOVsize
        outlineCircle.Visible = true
    else
        if fillCircle then fillCircle.Visible = false end
        if outlineCircle then outlineCircle.Visible = false end
    end
end)
