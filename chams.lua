task.spawn(function()
    local lplr, camera, highlights = game.Players.LocalPlayer, workspace.CurrentCamera, {}
    getgenv().Chams = getgenv().Chams or false
    local vfx, plants, rayparts, vegetation = workspace:FindFirstChild("VFX"), workspace:FindFirstChild("Plants"), workspace:FindFirstChild("RayParts"), workspace:FindFirstChild("Vegetation")
    
    local function is_within_range(player)
        if not lplr.Character or not player.Character then return false end
        local localRoot, playerRoot = lplr.Character:FindFirstChild("HumanoidRootPart"), player.Character:FindFirstChild("HumanoidRootPart")
        return localRoot and playerRoot and (localRoot.Position - playerRoot.Position).Magnitude <= 1000
    end
    
    local function create_highlight(character)
        if not character or highlights[character] then return end
        local highlight = Instance.new("Highlight")
        highlight.Parent, highlight.Adornee, highlight.DepthMode = character, character, Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency, highlight.OutlineTransparency = 0.1, 1
        highlights[character] = highlight
    end
    
    local function destroy_highlight(character)
        if not character or not highlights[character] then return end
        highlights[character]:Destroy()
        highlights[character] = nil
    end
    
    local function on_character_added(player, character)
        if player ~= lplr and getgenv().Chams then create_highlight(character) end
    end
    
    local function on_player_added(player)
        player.CharacterAdded:Connect(function(character) on_character_added(player, character) end)
        if player.Character then on_character_added(player, player.Character) end
    end
    
    local function on_player_removing(player)
        if player.Character and highlights[player.Character] then destroy_highlight(player.Character) end
    end
    
    for _, player in ipairs(game.Players:GetPlayers()) do on_player_added(player) end
    game.Players.PlayerAdded:Connect(on_player_added)
    game.Players.PlayerRemoving:Connect(on_player_removing)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if not getgenv().Chams then
            for character in pairs(highlights) do destroy_highlight(character) end
            return
        end
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player == lplr then continue end
            local character, humanoidRootPart = player.Character, player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if character and humanoidRootPart and is_within_range(player) then
                if not highlights[character] then create_highlight(character) end
                highlights[character].FillColor = getgenv().ChamsColour or Color3.fromRGB(255, 255, 255)
            else
                destroy_highlight(character)
            end
        end
    end)
end)
