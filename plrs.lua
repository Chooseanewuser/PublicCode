local dwEntities = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local dwEntity = cloneref(game.Players.LocalPlayer)
local dwcamera = cloneref(workspace.CurrentCamera)
local headOff = Vector3.new(0, 0.5, 0)
local legOff = Vector3.new(0, 3, 0)
getgenv().Boxes = getgenv().Boxes or false
getgenv().ESP_Color = getgenv().ESP_Color or Color3.new(1, 1, 1)
getgenv().BoxFilled = getgenv().BoxFilled or false
getgenv().boxTransparency = getgenv().boxTransparency or 1
getgenv().Outline = getgenv().Outline or false
getgenv().Name = getgenv().Name or getgenv().Name or false
getgenv().Name_Color = getgenv().Name_Color or Color3.new(1, 1, 1)
getgenv().Weapon = getgenv().Weapon or false
getgenv().Weapon_Color = getgenv().Weapon_Color or Color3.new(1, 1, 1)
getgenv().Distance = getgenv().Distance or false
getgenv().Distance_Color = getgenv().Distance_Color or Color3.new(1, 1, 1)
getgenv().Health = getgenv().Health or false
getgenv().lookV = getgenv().lookV or false
getgenv().lookV_Color = getgenv().lookV_Color or Color3.new(1, 1, 1)
getgenv().lookV_length = getgenv().lookV_length or 2
getgenv().headDot = getgenv().headDot or false
getgenv().headDot_Color = getgenv().headDot_Color or Color3.new(1, 1, 1)
getgenv().visCheck = getgenv().visCheck or false
getgenv().Healthbar = getgenv().Healthbar or false
getgenv().HealthbarOutline = getgenv().HealthbarOutline or false

function getchartool(Character)
    for _, v in ipairs(Character:GetChildren()) do
        if v:IsA("Model") and not v.Name:match("Armor") and v.Name ~= "HolsterModel" and v.Name ~= "Hair" and v.Name ~= "NameTag" and not v.Name:match("TorsoController") and not v.Name:match("Humanoid") and v.Name ~= "Shirt" and v.Name ~= "Pants" then
            return v.Name
        end
    end
    return "hands"
end

local function getDist(Character, v)
    local success, dist = pcall(function() return (Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude end)
    return success and dist or nil
end

local function isvisible(player)
    local localPlayer = game.Players.LocalPlayer
    local localChar = localPlayer.Character
    local targetChar = player.Character
    if not localChar or not targetChar then
        return false
    end
    local startPos = localChar:WaitForChild("Head").Position
    local endPos = targetChar:WaitForChild("Head").Position
    local direction = endPos - startPos
    local ray = Ray.new(startPos, direction)
    local hitPart = workspace:FindPartOnRay(ray, localChar)
    return hitPart == nil or hitPart:IsDescendantOf(targetChar)
end

local function isstaff(player)
    return false
end

for i, v in pairs(game.Players:GetChildren()) do 

    -------------------------------------------------------------------------------------------------------------// BOX & OUTLINE \\-------------------------------------------------------------------------------------------------------------

    local BoxOutline = Drawing.new("Square") 
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0, 0, 0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1, 1, 1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false
    Box.ZIndex = 4
    
    -------------------------------------------------------------------------------------------------------------// NAME \\-------------------------------------------------------------------------------------------------------------

    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.new(1, 1, 1)
    Name.Font = 2
    Name.Transparency = 1
    Name.Outline = true
    Name.Center = true
    Name.Size = 12

    -------------------------------------------------------------------------------------------------------------// WEAPON \\-------------------------------------------------------------------------------------------------------------

    local Weapon = Drawing.new("Text")
    Weapon.Visible = false
    Weapon.Color = Color3.new(1, 1, 1)
    Weapon.Font = 2
    Weapon.Transparency = 1
    Weapon.Outline = true
    Weapon.Center = true
    Weapon.Size = 11

    -------------------------------------------------------------------------------------------------------------// HEALTH \\-------------------------------------------------------------------------------------------------------------

    local Health = Drawing.new("Text")
    Health.Visible = false
    Health.Font = 2
    Health.Transparency = 1
    Health.Outline = true
    Health.Center = true
    Health.Size = 12

    -------------------------------------------------------------------------------------------------------------// DISTANCE \\-------------------------------------------------------------------------------------------------------------

    local Distance = Drawing.new("Text")
    Distance.Visible = false
    Distance.Font = 2
    Distance.Transparency = 1
    Distance.Outline = true
    Distance.Center = true
    Distance.Size = 12

    -------------------------------------------------------------------------------------------------------------// STAFF CHECK \\-------------------------------------------------------------------------------------------------------------

    local staffCheck = Drawing.new("Text")
    staffCheck.Visible = false
    staffCheck.Font = 2
    staffCheck.Transparency = 1
    staffCheck.Outline = true
    staffCheck.Center = true
    staffCheck.Size = 12

    -------------------------------------------------------------------------------------------------------------// VIS CHECK \\-------------------------------------------------------------------------------------------------------------

    local visCheck = Drawing.new("Text")
    visCheck.Visible = false
    visCheck.Font = 2
    visCheck.Transparency = 1
    visCheck.Outline = true
    visCheck.Center = true
    visCheck.Size = 12
    -------------------------------------------------------------------------------------------------------------// LOOK VECTOR \\-------------------------------------------------------------------------------------------------------------

    local lookV = Drawing.new("Line")
    lookV.Visible = false

    -------------------------------------------------------------------------------------------------------------// HEAD DOT \\-------------------------------------------------------------------------------------------------------------

    local headDot = Drawing.new("Circle")
    headDot.Visible = false
    headDot.Transparency = 1
    headDot.NumSides = 20
    headDot.Radius = 5
    headDot.Filled = true
    headDot.Color = Color3.new(1, 1, 1)

    -------------------------------------------------------------------------------------------------------------// HEALTH BAR & HEALTH BAR OUTLINE \\-------------------------------------------------------------------------------------------------------------

    local healthbarOutline = Drawing.new("Square")
    healthbarOutline.Thickness = 3
    healthbarOutline.Filled = false
    healthbarOutline.Color = Color3.new(0, 0, 0)
    healthbarOutline.Transparency = 1
    healthbarOutline.Visible = false

    local healthBar = Drawing.new("Square")
    healthBar.Thickness = 1
    healthBar.Filled = false
    healthBar.Color = Color3.new(0, 1, 0)
    healthBar.Transparency = 1
    healthBar.Visible = false

    -------------------------------------------------------------------------------------------------------------// boxesp \\-------------------------------------------------------------------------------------------------------------

    function boxesp()
        RunService.RenderStepped:Connect(
            function()
                if
                    v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and
                        v.Character:FindFirstChild("HumanoidRootPart") ~= nil and
                        v ~= dwEntities.LocalPlayer and
                        v.Character.Humanoid.Health > 0 and
                        v.Character:FindFirstChild("Head")
                 then
                    workspace.CurrentCamera.FieldOfView = getgenv().fieldofview or 80
                    local rootpart = v.Character.HumanoidRootPart
                    local root_pos, RootVis = dwcamera:WorldToViewportPoint(rootpart.Position)
                    local fov = workspace.CurrentCamera.FieldOfView
                    local distance = (dwcamera.CFrame.Position - rootpart.Position).Magnitude
                    local scale = (1 / distance) * (70 / fov) * 1000

                    if RootVis then
                        -------------------------------------------------------------------------------------------------------------// BOX & OUTLINE \\-------------------------------------------------------------------------------------------------------------

                        BoxOutline.Size = Vector2.new(4 * scale, 5.6 * scale)
                        BoxOutline.Position = Vector2.new(root_pos.X - BoxOutline.Size.X / 2, root_pos.Y - BoxOutline.Size.Y / 2)
                        BoxOutline.Visible = getgenv().Outline

                        Box.Size = Vector2.new(4 * scale, 5.6 * scale)
                        Box.Position = Vector2.new(root_pos.X - Box.Size.X / 2, root_pos.Y - Box.Size.Y / 2)
                        Box.Visible = getgenv().Boxes
                        Box.Color = getgenv().ESP_Color
                        Box.Filled = getgenv().BoxFilled
                        Box.Transparency = getgenv().boxTransparency

                        -------------------------------------------------------------------------------------------------------------// OFFSETS \\-------------------------------------------------------------------------------------------------------------

                        local boxWidth = BoxOutline.Size.X -- width
                        local boxHeight = BoxOutline.Size.Y -- height
                        
                        local boxCenterX = root_pos.X
                        local boxCenterY = root_pos.Y - (boxHeight / 2)
            
                        local rightSide = (boxWidth / 2 + 12)

                        local headCFrame = v.Character.Head.CFrame
                        local viewVector = (headCFrame * CFrame.new(0, 0, - getgenv().lookV_length)).Position
                        local viewViewport = dwcamera:WorldToViewportPoint(viewVector)

                        -------------------------------------------------------------------------------------------------------------// NAME \\-------------------------------------------------------------------------------------------------------------

                        local isStaff = isstaff(v)
                        Name.Position = Vector2.new(root_pos.X, root_pos.Y - BoxOutline.Size.Y / 2 - 15)
                        Name.Text = isStaff and "[STAFF]: "..v.DisplayName or v.DisplayName
                        Name.Visible = getgenv().Name
                        Name.Color = getgenv().Name_Color

                        -------------------------------------------------------------------------------------------------------------// TOOL \\-------------------------------------------------------------------------------------------------------------

                        local tool = getchartool(v.Character)

                        Weapon.Position = Vector2.new(root_pos.X, root_pos.Y + BoxOutline.Size.Y / 2)
                        Weapon.Text = " " .. tostring(tool) .. " "
                        Weapon.Visible = getgenv().Weapon
                        Weapon.Color = getgenv().Weapon_Color

                        -------------------------------------------------------------------------------------------------------------// DISTANCE \\-------------------------------------------------------------------------------------------------------------

                        local distance = getDist(dwEntity.Character, v)
                        Distance.Position = Vector2.new(Weapon.Position.X, Weapon.Position.Y + 15)
                        if distance then
                            Distance.Text = " " .. tostring(math.round(distance)) .. " "
                        else
                            Distance.Text = " "
                        end
                        Distance.Visible = getgenv().Distance
                        Distance.Color = getgenv().Distance_Color

                        -------------------------------------------------------------------------------------------------------------// HEALTH \\-------------------------------------------------------------------------------------------------------------

                        local headPosition = v.Character.Head.Position
                        local headViewport = dwcamera:WorldToViewportPoint(headPosition)
                        local healthVal = v.Character.Humanoid.Health

                        local fullHP = Color3.new(0, 1, 0)
                        local emptyHP = Color3.new(1, 0, 0)

                        local interpfactor = 1 - (healthVal / 100)

                        local currentColor = fullHP:Lerp(emptyHP, interpfactor)

                        -------------------------------------------------------------------------------------------------------------// HEALTH BAR \\-------------------------------------------------------------------------------------------------------------
                        
                        healthbarOutline.Visible = getgenv().HealthbarOutline
                        healthbarOutline.Size = Vector2.new(2, boxHeight)
                        healthbarOutline.Position = BoxOutline.Position - Vector2.new(6,0)

                        healthBar.Visible = getgenv().Healthbar
                        local clampedHealthVal = math.clamp(healthVal, 0, 100)

                        healthBar.Size = Vector2.new(2, boxHeight * (clampedHealthVal / 100))
                        healthBar.Position = Vector2.new(healthbarOutline.Position.X, healthbarOutline.Position.Y + boxHeight - healthBar.Size.Y)
                        healthBar.Color = currentColor

                        -------------------------------------------------------------------------------------------------------------// HEALTH TEXT \\-------------------------------------------------------------------------------------------------------------

                        Health.Position = Vector2.new(healthBar.Position.X - 10, healthBar.Position.Y)
                        if healthVal then
                            Health.Text = " " .. tostring(math.round(healthVal)) .. " "
                        else
                            Health.Text = " "
                        end
                        Health.Visible = getgenv().Health
                        Health.Color = currentColor

                        -------------------------------------------------------------------------------------------------------------// LOOK VECTOR \\-------------------------------------------------------------------------------------------------------------

                        lookV.Visible = getgenv().lookV
                        lookV.From = Vector2.new(headViewport.X, headViewport.Y)
                        lookV.To = Vector2.new(viewViewport.X, viewViewport.Y)
                        lookV.Color = getgenv().lookV_Color

                        -------------------------------------------------------------------------------------------------------------// HEAD DOT \\-------------------------------------------------------------------------------------------------------------

                        headDot.Visible = getgenv().headDot
                        headDot.Position = Vector2.new(headViewport.X, headViewport.Y)
                        headDot.Color = getgenv().headDot_Color

                        -------------------------------------------------------------------------------------------------------------// VISIBLE CHECK \\-------------------------------------------------------------------------------------------------------------
                        local isplrVis = isvisible(v)
                        
                        if isplrVis then
                            visCheck.Visible = getgenv().visCheck
                            visCheck.Position = Vector2.new(boxCenterX + rightSide, boxCenterY)
                            visCheck.Color = Color3.new(0, 1, 0)
                            headDot.Visible = getgenv().headDot
                            headDot.Color = Color3.new(1, 0.768627, 0)
                            visCheck.Text = " VIS "
                        else
                            visCheck.Text = "  "
                            headDot.Visible = false
                            visCheck.Position = Vector2.new(boxCenterX + rightSide, boxCenterY)
                            visCheck.Color = Color3.new(255, 0, 0)
                            headDot.Color = Color3.new(1, 1, 1)
                        end
                    else
                        Box.Visible = false
                        BoxOutline.Visible = false
                        Name.Visible = false
                        Weapon.Visible = false
                        Distance.Visible = false
                        Health.Visible = false
                        lookV.Visible = false
                        visCheck.Visible = false
                        headDot.Visible = false
                        healthbarOutline.Visible = false
                        healthBar.Visible = false
                    end
                else
                    Box.Visible = false
                    BoxOutline.Visible = false
                    Name.Visible = false
                    Weapon.Visible = false
                    Distance.Visible = false
                    Health.Visible = false
                    lookV.Visible = false
                    visCheck.Visible = false
                    headDot.Visible = false
                    healthbarOutline.Visible = false
                    healthBar.Visible = false
                end
            end
        )
    end
    coroutine.wrap(boxesp)()
end

dwEntities.PlayerAdded:Connect(function(v)
    
    -------------------------------------------------------------------------------------------------------------// BOX & OUTLINE \\-------------------------------------------------------------------------------------------------------------

    local BoxOutline = Drawing.new("Square") 
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0, 0, 0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1, 1, 1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false
    Box.ZIndex = 4
    
    -------------------------------------------------------------------------------------------------------------// NAME \\-------------------------------------------------------------------------------------------------------------

    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.new(1, 1, 1)
    Name.Font = 2
    Name.Transparency = 1
    Name.Outline = true
    Name.Center = true
    Name.Size = 12

    -------------------------------------------------------------------------------------------------------------// WEAPON \\-------------------------------------------------------------------------------------------------------------

    local Weapon = Drawing.new("Text")
    Weapon.Visible = false
    Weapon.Color = Color3.new(1, 1, 1)
    Weapon.Font = 2
    Weapon.Transparency = 1
    Weapon.Outline = true
    Weapon.Center = true
    Weapon.Size = 11

    -------------------------------------------------------------------------------------------------------------// HEALTH \\-------------------------------------------------------------------------------------------------------------

    local Health = Drawing.new("Text")
    Health.Visible = false
    Health.Font = 2
    Health.Transparency = 1
    Health.Outline = true
    Health.Center = true
    Health.Size = 12

    -------------------------------------------------------------------------------------------------------------// DISTANCE \\-------------------------------------------------------------------------------------------------------------

    local Distance = Drawing.new("Text")
    Distance.Visible = false
    Distance.Font = 2
    Distance.Transparency = 1
    Distance.Outline = true
    Distance.Center = true
    Distance.Size = 12

    -------------------------------------------------------------------------------------------------------------// VIS CHECK \\-------------------------------------------------------------------------------------------------------------

    local visCheck = Drawing.new("Text")
    visCheck.Visible = false
    visCheck.Font = 2
    visCheck.Transparency = 1
    visCheck.Outline = true
    visCheck.Center = true
    visCheck.Size = 12
    -------------------------------------------------------------------------------------------------------------// LOOK VECTOR \\-------------------------------------------------------------------------------------------------------------

    local lookV = Drawing.new("Line")
    lookV.Visible = false

    -------------------------------------------------------------------------------------------------------------// HEAD DOT \\-------------------------------------------------------------------------------------------------------------

    local headDot = Drawing.new("Circle")
    headDot.Visible = false
    headDot.Transparency = 1
    headDot.NumSides = 20
    headDot.Radius = 5
    headDot.Filled = true
    headDot.Color = Color3.new(1, 1, 1)

    -------------------------------------------------------------------------------------------------------------// HEALTH BAR & HEALTH BAR OUTLINE \\-------------------------------------------------------------------------------------------------------------

    local healthbarOutline = Drawing.new("Square")
    healthbarOutline.Thickness = 3
    healthbarOutline.Filled = false
    healthbarOutline.Color = Color3.new(0, 0, 0)
    healthbarOutline.Transparency = 1
    healthbarOutline.Visible = false

    local healthBar = Drawing.new("Square")
    healthBar.Thickness = 1
    healthBar.Filled = false
    healthBar.Color = Color3.new(0, 1, 0)
    healthBar.Transparency = 1
    healthBar.Visible = false

    -------------------------------------------------------------------------------------------------------------// boxesp \\-------------------------------------------------------------------------------------------------------------

    function boxesp()
        RunService.RenderStepped:Connect(
            function()
                if
                    v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and
                        v.Character:FindFirstChild("HumanoidRootPart") ~= nil and
                        v ~= dwEntities.LocalPlayer and
                        v.Character.Humanoid.Health > 0 and
                        v.Character:FindFirstChild("Head")
                 then
                    workspace.CurrentCamera.FieldOfView = getgenv().fieldofview or 80
                    local rootpart = v.Character.HumanoidRootPart
                    local root_pos, RootVis = dwcamera:WorldToViewportPoint(rootpart.Position)
                    local fov = workspace.CurrentCamera.FieldOfView
                    local distance = (dwcamera.CFrame.Position - rootpart.Position).Magnitude
                    local scale = (1 / distance) * (70 / fov) * 1000

                    if RootVis then
                        -------------------------------------------------------------------------------------------------------------// BOX & OUTLINE \\-------------------------------------------------------------------------------------------------------------

                        BoxOutline.Size = Vector2.new(4 * scale, 5.6 * scale)
                        BoxOutline.Position = Vector2.new(root_pos.X - BoxOutline.Size.X / 2, root_pos.Y - BoxOutline.Size.Y / 2)
                        BoxOutline.Visible = getgenv().Outline

                        Box.Size = Vector2.new(4 * scale, 5.6 * scale)
                        Box.Position = Vector2.new(root_pos.X - Box.Size.X / 2, root_pos.Y - Box.Size.Y / 2)
                        Box.Visible = getgenv().Boxes
                        Box.Color = getgenv().ESP_Color
                        Box.Filled = getgenv().BoxFilled
                        Box.Transparency = getgenv().boxTransparency

                        -------------------------------------------------------------------------------------------------------------// OFFSETS \\-------------------------------------------------------------------------------------------------------------

                        local boxWidth = BoxOutline.Size.X -- width
                        local boxHeight = BoxOutline.Size.Y -- height
                        
                        local boxCenterX = root_pos.X
                        local boxCenterY = root_pos.Y - (boxHeight / 2)
            
                        local rightSide = (boxWidth / 2 + 12)

                        local headCFrame = v.Character.Head.CFrame
                        local viewVector = (headCFrame * CFrame.new(0, 0, - getgenv().lookV_length)).Position
                        local viewViewport = dwcamera:WorldToViewportPoint(viewVector)

                        -------------------------------------------------------------------------------------------------------------// NAME \\-------------------------------------------------------------------------------------------------------------

                        local isStaff = isstaff(v)
                        Name.Position = Vector2.new(root_pos.X, root_pos.Y - BoxOutline.Size.Y / 2 - 15)
                        Name.Text = isStaff and "[STAFF]: "..v.DisplayName or v.DisplayName
                        Name.Visible = getgenv().Name
                        Name.Color = getgenv().Name_Color

                        -------------------------------------------------------------------------------------------------------------// TOOL \\-------------------------------------------------------------------------------------------------------------

                        local tool = getchartool(v.Character)

                        Weapon.Position = Vector2.new(root_pos.X, root_pos.Y + BoxOutline.Size.Y / 2)
                        Weapon.Text = " " .. tostring(tool) .. " "
                        Weapon.Visible = getgenv().Weapon
                        Weapon.Color = getgenv().Weapon_Color

                        -------------------------------------------------------------------------------------------------------------// DISTANCE \\-------------------------------------------------------------------------------------------------------------

                        local distance = getDist(dwEntity.Character, v)

                        Distance.Position = Vector2.new(Weapon.Position.X, Weapon.Position.Y + 15)
                        local distance = getDist(dwEntity.Character, v)
                        Distance.Position = Vector2.new(Weapon.Position.X, Weapon.Position.Y + 15)
                        if distance then
                            Distance.Text = " " .. tostring(math.round(distance)) .. " "
                        else
                            Distance.Text = " "
                        end
                        Distance.Visible = getgenv().Distance
                        Distance.Color = getgenv().Distance_Color
                        Distance.Visible = getgenv().Distance
                        Distance.Color = getgenv().Distance_Color

                        -------------------------------------------------------------------------------------------------------------// HEALTH \\-------------------------------------------------------------------------------------------------------------

                        local headPosition = v.Character.Head.Position
                        local headViewport = dwcamera:WorldToViewportPoint(headPosition)
                        local healthVal = v.Character.Humanoid.Health

                        local fullHP = Color3.new(0, 1, 0)
                        local emptyHP = Color3.new(1, 0, 0)

                        local interpfactor = 1 - (healthVal / 100)

                        local currentColor = fullHP:Lerp(emptyHP, interpfactor)

                        -------------------------------------------------------------------------------------------------------------// HEALTH BAR \\-------------------------------------------------------------------------------------------------------------
                        
                        healthbarOutline.Visible = getgenv().HealthbarOutline
                        healthbarOutline.Size = Vector2.new(2, boxHeight)
                        healthbarOutline.Position = BoxOutline.Position - Vector2.new(6,0)

                        healthBar.Visible = getgenv().Healthbar
                        local clampedHealthVal = math.clamp(healthVal, 0, 100)

                        healthBar.Size = Vector2.new(2, boxHeight * (clampedHealthVal / 100))
                        healthBar.Position = Vector2.new(healthbarOutline.Position.X, healthbarOutline.Position.Y + boxHeight - healthBar.Size.Y)
                        healthBar.Color = currentColor

                        -------------------------------------------------------------------------------------------------------------// HEALTH TEXT \\-------------------------------------------------------------------------------------------------------------

                        Health.Position = Vector2.new(healthBar.Position.X - 10, healthBar.Position.Y)
                        if healthVal then
                            Health.Text = " " .. tostring(math.round(healthVal)) .. " "
                        else
                            Health.Text = " "
                        end
                        Health.Visible = getgenv().Health
                        Health.Color = currentColor

                        -------------------------------------------------------------------------------------------------------------// LOOK VECTOR \\-------------------------------------------------------------------------------------------------------------

                        lookV.Visible = getgenv().lookV
                        lookV.From = Vector2.new(headViewport.X, headViewport.Y)
                        lookV.To = Vector2.new(viewViewport.X, viewViewport.Y)
                        lookV.Color = getgenv().lookV_Color

                        -------------------------------------------------------------------------------------------------------------// HEAD DOT \\-------------------------------------------------------------------------------------------------------------

                        headDot.Visible = getgenv().headDot
                        headDot.Position = Vector2.new(headViewport.X, headViewport.Y)
                        headDot.Color = getgenv().headDot_Color

                        -------------------------------------------------------------------------------------------------------------// VISIBLE CHECK \\-------------------------------------------------------------------------------------------------------------
                        local isplrVis = isvisible(v)
                        
                        if isplrVis then
                            visCheck.Visible = getgenv().visCheck
                            visCheck.Position = Vector2.new(boxCenterX + rightSide, boxCenterY)
                            visCheck.Color = Color3.new(0, 1, 0)
                            headDot.Visible = getgenv().headDot
                            headDot.Color = Color3.new(1, 0.768627, 0)
                            visCheck.Text = " VIS "
                        else
                            visCheck.Text = "  "
                            headDot.Visible = false
                            visCheck.Position = Vector2.new(boxCenterX + rightSide, boxCenterY)
                            visCheck.Color = Color3.new(255, 0, 0)
                            headDot.Color = Color3.new(1, 1, 1)
                        end

                        -------------------------------------------------------------------------------------------------------------// STAFF CHECK \\-------------------------------------------------------------------------------------------------------------

                        local isStaffCall, role = isstaff(v)

                        local offset2 = 10

                        if isStaffCall then
                            staffCheck.Visible = isStaffCall
                            staffCheck.Position = Vector2.new(boxCenterX + rightSide + 15, boxCenterY + offset2)
                            staffCheck.Text = ' [ STAFF ]: '
                            staffCheck.Color = Color3.new(0.690196, 0.8, 1)
                        end
                    else
                        Box.Visible = false
                        BoxOutline.Visible = false
                        Name.Visible = false
                        Weapon.Visible = false
                        Distance.Visible = false
                        Health.Visible = false
                        lookV.Visible = false
                        visCheck.Visible = false
                        headDot.Visible = false
                        healthbarOutline.Visible = false
                        healthBar.Visible = false
                    end
                else
                    Box.Visible = false
                    BoxOutline.Visible = false
                    Name.Visible = false
                    Weapon.Visible = false
                    Distance.Visible = false
                    Health.Visible = false
                    lookV.Visible = false
                    visCheck.Visible = false
                    headDot.Visible = false
                    healthbarOutline.Visible = false
                    healthBar.Visible = false
                end
            end
        )
    end
    coroutine.wrap(boxesp)()
end)
