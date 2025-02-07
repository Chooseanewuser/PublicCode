getgenv().Skeleton = getgenv().Skeleton or false
getgenv().SkeletonColour = Color3.fromRGB(255, 255, 255)

local players = cloneref(game:GetService("Players"))
local rs = cloneref(game:GetService("RunService"))
local workspace = cloneref(game:GetService("Workspace"))
local camera = workspace.CurrentCamera
local lplr = players.LocalPlayer
local skeles = {}

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function lerpclr(color1, color2, t)
    return Color3.new(
        lerp(color1.R, color2.R, t),
        lerp(color1.G, color2.G, t),
        lerp(color1.B, color2.B, t)
    )
end

local function create()
    local skele = {}
    local options = {
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight"
    }
    for _, name in ipairs(options) do
        skele[name] = Drawing.new("Line")
        skele[name].Visible = false
        skele[name].Thickness = 2
        skele[name].Transparency = 1
        skele[name].Color = getgenv().SkeletonColour
    end
    return skele
end

local function bnds(character)
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local cf, size = character:GetBoundingBox()
    return cf, size, root
end

local function upd(skele, character)
    local cf, size, root = bnds(character)
    if not cf or not size then return end
    local joints = {
        one = {"Head", "LowerTorso"},
        two = {"LowerTorso", "RightUpperLeg"},
        three = {"LowerTorso", "LeftUpperLeg"},
        four = {"LeftUpperLeg", "LeftFoot"},
        five = {"RightUpperLeg", "RightFoot"},
        six = {"RightUpperArm", "RightHand"},
        seven = {"LeftUpperArm", "LeftHand"},
        eight = {"LeftUpperArm", "RightUpperArm"}
    }
    for name, parts in pairs(joints) do
        local part1, part2 = character:FindFirstChild(parts[1]), character:FindFirstChild(parts[2])
        if part1 and part2 then
            local pos1, vis1 = camera:WorldToViewportPoint(part1.Position)
            local pos2, vis2 = camera:WorldToViewportPoint(part2.Position)
            if vis1 and vis2 then
                skele[name].Visible = true

                if name == "one" then
                    local head_pos = part1.Position
                    local adjusted_pos = head_pos - Vector3.new(0, part1.Size.Y / 3, 0)
                    pos1 = camera:WorldToViewportPoint(adjusted_pos)
                end

                skele[name].From = Vector2.new(pos1.X, pos1.Y)
                skele[name].To = Vector2.new(pos2.X, pos2.Y)
                skele[name].Color = getgenv().SkeletonColour
            else
                skele[name].Visible = false
            end
        else
            skele[name].Visible = false
        end
    end
end

local function rem(skele)
    if skele then
        for _, line in pairs(skele) do
            if line and line.Visible then
                line.Visible = false
            end
            if line then
                line:Remove()
            end
        end
    end
end

rs.RenderStepped:Connect(function()
    pcall(function()
        if not getgenv().Skeleton then
            for _, player in ipairs(players:GetPlayers()) do
                if skeles[player] then
                    rem(skeles[player])
                    skeles[player] = nil
                end
            end
            return
        end
        for _, player in ipairs(players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= lplr then
                if not skeles[player] then
                    skeles[player] = create()
                end
                upd(skeles[player], player.Character)
            else
                if skeles[player] then
                    rem(skeles[player])
                    skeles[player] = nil
                end
            end
        end
    end)
end)

players.PlayerRemoving:Connect(function(player)
    if skeles[player] then
        rem(skeles[player])
        skeles[player] = nil
    end
end)
