-- [ FOV CIRCLE ]
task.spawn(function()
    getgenv().FOVtoggle = getgenv().FOVtoggle or false
    getgenv().FOVsize = getgenv().FOVsize or 100
    getgenv().FOVcolour = getgenv().FOVcolour or Color3.fromRGB(255, 255, 255)
    local rs = game:GetService("RunService")
    local uis = game:GetService("UserInputService")
    local circle, lastColor = nil, getgenv().FOVcolour
    rs.RenderStepped:Connect(function()
        if getgenv().FOVtoggle then
            if getgenv().FOVcolour ~= lastColor then
                if circle then circle.Color = getgenv().FOVcolour end
                lastColor = getgenv().FOVcolour
            end
            local mousePos = uis:GetMouseLocation()
            if not circle then
                circle = Drawing.new("Circle")
                circle.Color = getgenv().FOVcolour
                circle.Thickness = 1
                circle.NumSides = 50
                circle.Filled = false
                circle.Transparency = 1
            end
            circle.Position = mousePos
            circle.Radius = getgenv().FOVsize
            circle.Visible = true
        elseif circle then
            circle.Visible = false
        end
    end)
end)
