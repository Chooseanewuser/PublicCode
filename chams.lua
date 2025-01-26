task.spawn(function()
    local lplr = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local highlights = {}
    getgenv().Chams = getgenv().Chams or false
    local function is_within_range(player)
        if not lplr.Character or not player.Character then return false end
        local localRoot = lplr.Character:FindFirstChild("HumanoidRootPart")
        local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
        if not localRoot or not playerRoot then return false end
        return (localRoot.Position - playerRoot.Position).Magnitude <= 1000
    end
    local function create_highlight(character)
        if not character or highlights[character] then return end
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.Adornee = character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.1
        highlight.OutlineTransparency = 1
        highlights[character] = highlight
    end
    local function destroy_highlight(character)
        if not character or not highlights[character] then return end
        highlights[character]:Destroy()
        highlights[character] = nil
    end
    local function on_character_added(player, character)
        if player == lplr then return end
        if getgenv().Chams then
            create_highlight(character)
        end
    end
    local function on_player_added(player)
        player.CharacterAdded:Connect(function(character)
            on_character_added(player, character)
        end)
        if player.Character then
            on_character_added(player, player.Character)
        end
    end
    local function on_player_removing(player)
        if player.Character and highlights[player.Character] then
            destroy_highlight(player.Character)
        end
    end
    for _, player in ipairs(game.Players:GetPlayers()) do
        on_player_added(player)
    end
    game.Players.PlayerAdded:Connect(on_player_added)
    game.Players.PlayerRemoving:Connect(on_player_removing)
    local time = 0
    local function get_player_color(player, t)
        local players = game.Players:GetPlayers()
        local index = table.find(players, player) or 1
        local hueOffset = (index / #players) % 1
        local hue = (t + hueOffset) % 1
        return Color3.fromHSV(hue, 1, 1)
    end
    game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
        time = time + deltaTime * 0.5
        if getgenv().Chams then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player == lplr then continue end
                local character = player.Character
                if not character then continue end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local highlight = highlights[character]
                if is_within_range(player) and humanoidRootPart then
                    if not highlight then
                        create_highlight(character)
                        highlight = highlights[character]
                    end
                    if highlight then
                        highlight.FillColor = get_player_color(player, time)
                    end
                else
                    destroy_highlight(character)
                end
            end
        else
            for character, highlight in pairs(highlights) do
                destroy_highlight(character)
            end
        end
    end)
end)
