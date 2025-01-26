getgenv().Skeleton = getgenv().Skeleton or false
getgenv().SkeletonColour = Color3.fromRGB(255, 255, 255)
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local Workspace = cloneref(game:GetService("Workspace"))
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local SkeletonBones = {}
local function Lerp(a, b, t)
    return a + (b - a) * t
end
local function LerpColor(color1, color2, t)
    return Color3.new(
        Lerp(color1.R, color2.R, t),
        Lerp(color1.G, color2.G, t),
        Lerp(color1.B, color2.B, t)
    )
end
local function CreateESP()
    local Skeleton = {}
    local skeletonParts = {
        "HeadTorso",
        "TorsoToRightLeg",
        "TorsoToLeftLeg",
        "LeftLegToFoot",
        "RightLegToFoot",
        "TorsoToRightArm",
        "RightArmToHand",
        "TorsoToLeftArm",
        "LeftArmToHand"
    }
    for _, partName in ipairs(skeletonParts) do
        Skeleton[partName .. "Outline"] = Drawing.new("Line")
        Skeleton[partName .. "Outline"].Visible = false
        Skeleton[partName .. "Outline"].Thickness = 3
        Skeleton[partName .. "Outline"].Transparency = 1
        Skeleton[partName .. "Outline"].Color = Color3.new(0, 0, 0)

        Skeleton[partName] = Drawing.new("Line")
        Skeleton[partName].Visible = false
        Skeleton[partName].Thickness = 2
        Skeleton[partName].Transparency = 1
        Skeleton[partName].Color = getgenv().SkeletonColour
    end
    return Skeleton
end
local function GetBoundingBox(Character)
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end
    local CF, Size = Character:GetBoundingBox()
    return CF, Size, RootPart
end
local function UpdateESP(Skeleton, Character)
    local CF, Size, RootPart = GetBoundingBox(Character)
    if not CF or not Size then return end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end
    local HeadCFrame = HumanoidRootPart.CFrame
    local Corners = {
        (HeadCFrame * CFrame.new(Size.X / 2, Size.Y / 2, 0)).Position,
        (HeadCFrame * CFrame.new(-Size.X / 2, Size.Y / 2, 0)).Position,
        (HeadCFrame * CFrame.new(-Size.X / 2, -Size.Y / 2, 0)).Position,
        (HeadCFrame * CFrame.new(Size.X / 2, -Size.Y / 2, 0)).Position,
        (HeadCFrame * CFrame.new(Size.X / 1.82, Size.Y / 2, 0)).Position,
        (HeadCFrame * CFrame.new(Size.X / 1.82, -Size.Y / 2, 0)).Position,
    }
    local joints = {
        HeadTorso = {"Head", "LowerTorso"},
        TorsoToRightLeg = {"LowerTorso", "RightUpperLeg"},
        TorsoToLeftLeg = {"LowerTorso", "LeftUpperLeg"},
        LeftLegToFoot = {"LeftUpperLeg", "LeftFoot"},
        RightLegToFoot = {"RightUpperLeg", "RightFoot"},
        TorsoToRightArm = {"UpperTorso", "RightUpperArm"},
        RightArmToHand = {"RightUpperArm", "RightHand"},
        TorsoToLeftArm = {"UpperTorso", "LeftUpperArm"},
        LeftArmToHand = {"LeftUpperArm", "LeftHand"}
    }
    for partName, parts in pairs(joints) do
        local part1, part2 = Character:FindFirstChild(parts[1]), Character:FindFirstChild(parts[2])
        if part1 and part2 then
            local pos1, vis1 = Camera:WorldToViewportPoint(part1.Position)
            local pos2, vis2 = Camera:WorldToViewportPoint(part2.Position)
            if vis1 and vis2 then
                Skeleton[partName .. "Outline"].Visible = true
                Skeleton[partName .. "Outline"].From = Vector2.new(pos1.X, pos1.Y)
                Skeleton[partName .. "Outline"].To = Vector2.new(pos2.X, pos2.Y)
                Skeleton[partName].Visible = true
                Skeleton[partName].From = Vector2.new(pos1.X, pos1.Y)
                Skeleton[partName].To = Vector2.new(pos2.X, pos2.Y)
                Skeleton[partName].Color = getgenv().SkeletonColour
            else
                Skeleton[partName .. "Outline"].Visible = false
                Skeleton[partName].Visible = false
            end
        else
            Skeleton[partName .. "Outline"].Visible = false
            Skeleton[partName].Visible = false
        end
    end
end
local function RemoveSkeleton(Skeleton)
    if Skeleton then
        for _, line in pairs(Skeleton) do
            if line and line.Visible then
                line.Visible = false
            end
            if line then
                line:Remove()
            end
        end
    end
end
RunService.RenderStepped:Connect(function()
    if not getgenv().Skeleton then
        for _, Player in ipairs(Players:GetPlayers()) do
            if SkeletonBones[Player] then
                RemoveSkeleton(SkeletonBones[Player])
                SkeletonBones[Player] = nil
            end
        end
        return
    end
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            if not SkeletonBones[Player] then
                SkeletonBones[Player] = CreateESP()
            end
            UpdateESP(SkeletonBones[Player], Player.Character)
        else
            if SkeletonBones[Player] then
                RemoveSkeleton(SkeletonBones[Player])
                SkeletonBones[Player] = nil
            end
        end
    end
end)
Players.PlayerRemoving:Connect(function(Player)
    if SkeletonBones[Player] then
        RemoveSkeleton(SkeletonBones[Player])
        SkeletonBones[Player] = nil
    end
end)
