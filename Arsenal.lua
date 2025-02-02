local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Serenity | Arsenal",
    LoadingTitle = "Serenity Loading...", 
    LoadingSubtitle = "by Cody991",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SerenityConfig",
        FileName = "Arsenal"
    }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local MainSection = MainTab:CreateSection("Player")

-- Enhanced movement controls
MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

MainTab:CreateSlider({
    Name = "Jump Power", 
    Range = {50, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
})

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().InfiniteJump = Value
        game:GetService("UserInputService").JumpRequest:connect(function()
            if getgenv().InfiniteJump then
                game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
            end
        end)
    end,
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local CombatSection = CombatTab:CreateSection("Combat Features")

-- Fixed Advanced Aimbot with strict team check
CombatTab:CreateToggle({
    Name = "Advanced Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().Aimbot = Value
        getgenv().AimbotSettings = {
            Sensitivity = 0.5,
            LockTarget = true,
            PredictMovement = true,
            TargetPart = "Head",
            TeamCheck = true
        }
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().Aimbot and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local closest = math.huge
                local target = nil
                
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and 
                       player.Character and 
                       player.Character:FindFirstChild("Humanoid") and 
                       player.Character.Humanoid.Health > 0 and
                       player.Character:FindFirstChild(getgenv().AimbotSettings.TargetPart) and
                       player.Team ~= game.Players.LocalPlayer.Team then
                        
                        local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(player.Character[getgenv().AimbotSettings.TargetPart].Position)
                        local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)).Magnitude
                        
                        if distance < closest then
                            closest = distance
                            target = player.Character[getgenv().AimbotSettings.TargetPart]
                        end
                    end
                end
                
                if target then
                    local pos = target.Position
                    if getgenv().AimbotSettings.PredictMovement then
                        pos = pos + (target.Velocity * 0.165)
                    end
                    
                    local targetPos = workspace.CurrentCamera:WorldToViewportPoint(pos)
                    local mousePos = Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)
                    local moveVector = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * getgenv().AimbotSettings.Sensitivity
                    
                    mousemoverel(moveVector.X, moveVector.Y)
                end
            end
        end)
    end,
})

-- Enhanced silent aim
CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().SilentAim = Value
        getgenv().SilentAimSettings = {
            FOV = 100,
            HitChance = 100,
            TargetPart = "Head"
        }
        
        local circle = Drawing.new("Circle")
        circle.Transparency = 1
        circle.Thickness = 2
        circle.Color = Color3.fromRGB(255, 255, 255)
        circle.Filled = false
        circle.NumSides = 50
        
        game:GetService("RunService").RenderStepped:Connect(function()
            circle.Radius = getgenv().SilentAimSettings.FOV
            circle.Position = Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y + 36)
            circle.Visible = getgenv().SilentAim
        end)
        
        local oldNamecall = nil
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().SilentAim and method == "FindPartOnRayWithIgnoreList" then
                local closest = math.huge
                local target = nil
                
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and 
                       player.Team ~= game.Players.LocalPlayer.Team and 
                       player.Character and 
                       player.Character:FindFirstChild("Humanoid") and 
                       player.Character.Humanoid.Health > 0 and 
                       player.Character:FindFirstChild(getgenv().SilentAimSettings.TargetPart) then
                        
                        local pos = workspace.CurrentCamera:WorldToScreenPoint(player.Character[getgenv().SilentAimSettings.TargetPart].Position)
                        local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)).magnitude
                        
                        if magnitude < closest and magnitude <= getgenv().SilentAimSettings.FOV then
                            closest = magnitude
                            target = player.Character[getgenv().SilentAimSettings.TargetPart]
                        end
                    end
                end
                
                if target and math.random(1, 100) <= getgenv().SilentAimSettings.HitChance then
                    args[2] = Ray.new(workspace.CurrentCamera.CFrame.Position, (target.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
                end
            end
            
            return oldNamecall(unpack(args))
        end))
    end,
})

-- Advanced ESP system
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local VisualsSection = VisualsTab:CreateSection("ESP Settings")

VisualsTab:CreateToggle({
    Name = "Advanced ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().ESP = Value
        getgenv().ESPSettings = {
            BoxesEnabled = true,
            TracersEnabled = true,
            NametagsEnabled = true,
            HealthEnabled = true,
            TeamCheck = true,
            TeamColor = false
        }
        
        local function createESP(player)
            local esp = Instance.new("Folder")
            esp.Name = "ESP"
            esp.Parent = player.Character
            
            -- Box ESP
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "Box"
            box.Size = player.Character:GetExtentsSize()
            box.Adornee = player.Character
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Color3 = player.TeamColor.Color
            box.Transparency = 0.5
            box.Parent = esp
            
            -- Tracer ESP
            local tracer = Instance.new("LineHandleAdornment")
            tracer.Name = "Tracer"
            tracer.Length = 1000
            tracer.Thickness = 2
            tracer.AlwaysOnTop = true
            tracer.ZIndex = 5
            tracer.Color3 = player.TeamColor.Color
            tracer.Parent = esp
            
            -- Nametag ESP
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "Nametag"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.AlwaysOnTop = true
            billboard.Parent = esp
            
            local name = Instance.new("TextLabel")
            name.Name = "PlayerName"
            name.Size = UDim2.new(1, 0, 0.5, 0)
            name.BackgroundTransparency = 1
            name.Text = player.Name
            name.TextColor3 = player.TeamColor.Color
            name.TextScaled = true
            name.Parent = billboard
            
            local health = Instance.new("TextLabel")
            health.Name = "Health"
            health.Size = UDim2.new(1, 0, 0.5, 0)
            health.Position = UDim2.new(0, 0, 0.5, 0)
            health.BackgroundTransparency = 1
            health.Text = tostring(math.floor(player.Character.Humanoid.Health))
            health.TextColor3 = Color3.fromRGB(255, 0, 0)
            health.TextScaled = true
            health.Parent = billboard
            
            game:GetService("RunService").RenderStepped:Connect(function()
                if player.Character and getgenv().ESP then
                    box.Visible = getgenv().ESPSettings.BoxesEnabled
                    tracer.Visible = getgenv().ESPSettings.TracersEnabled
                    billboard.Enabled = getgenv().ESPSettings.NametagsEnabled or getgenv().ESPSettings.HealthEnabled
                    
                    if getgenv().ESPSettings.TeamCheck and player.Team == game.Players.LocalPlayer.Team then
                        box.Visible = false
                        tracer.Visible = false
                        billboard.Enabled = false
                    end
                    
                    if getgenv().ESPSettings.TeamColor then
                        box.Color3 = player.TeamColor.Color
                        tracer.Color3 = player.TeamColor.Color
                        name.TextColor3 = player.TeamColor.Color
                    end
                    
                    health.Text = tostring(math.floor(player.Character.Humanoid.Health))
                    health.Visible = getgenv().ESPSettings.HealthEnabled
                else
                    box.Visible = false
                    tracer.Visible = false
                    billboard.Enabled = false
                end
            end)
        end
        
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                createESP(player)
            end
        end
        
        game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end)
    end,
})

-- Additional combat features
CombatTab:CreateToggle({
    Name = "Rapid Fire",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().RapidFire = Value
        
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__index
        
        mt.__index = newcclosure(function(self, k)
            if getgenv().RapidFire then
                if k == "FireRate" or k == "AutoRate" or k == "ReloadTime" then
                    return 0
                end
            end
            return old(self, k)
        end)
        
        setreadonly(mt, true)
    end,
})

CombatTab:CreateToggle({
    Name = "Auto Wall",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoWall = Value
        
        if Value then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end,
})

-- Advanced Target System
local TargetTab = Window:CreateTab("Target", 4483362458)
local TargetSection = TargetTab:CreateSection("Target Settings")

local SelectedPlayer = nil
local PlayerDropdown = TargetTab:CreateDropdown({
    Name = "Select Target",
    Options = {},
    CurrentOption = "",
    Flag = "TargetPlayer",
    Callback = function(Value)
        SelectedPlayer = Value
    end,
})

-- Update player list
local function UpdatePlayerList()
    local PlayerList = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(PlayerList, player.Name)
        end
    end
    PlayerDropdown:Refresh(PlayerList, true)
end

UpdatePlayerList()
game.Players.PlayerAdded:Connect(UpdatePlayerList)
game.Players.PlayerRemoving:Connect(UpdatePlayerList)

-- Fixed Target Lock with strict team check
TargetTab:CreateToggle({
    Name = "Lock On Target",
    CurrentValue = false,
    Flag = "TargetLock",
    Callback = function(Value)
        getgenv().TargetLock = Value
        while getgenv().TargetLock do
            task.wait()
            if SelectedPlayer then
                local target = game.Players:FindFirstChild(SelectedPlayer)
                if target and 
                   target.Team ~= game.Players.LocalPlayer.Team and
                   target.Character and 
                   target.Character:FindFirstChild("Humanoid") and
                   target.Character.Humanoid.Health > 0 and
                   target.Character:FindFirstChild("HumanoidRootPart") then
                    
                    workspace.CurrentCamera.CFrame = CFrame.new(
                        workspace.CurrentCamera.CFrame.Position,
                        target.Character.HumanoidRootPart.Position
                    )
                end
            end
        end
    end,
})

-- Advanced FOV Settings
local FOVTab = Window:CreateTab("FOV", 4483362458)
local FOVSection = FOVTab:CreateSection("FOV Settings")

FOVTab:CreateSlider({
    Name = "FOV Size",
    Range = {30, 120},
    Increment = 1,
    CurrentValue = 70,
    Flag = "FOVSize",
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end,
})

FOVTab:CreateColorPicker({
    Name = "FOV Circle Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "FOVColor",
    Callback = function(Value)
        circle.Color = Value
    end,
})

FOVTab:CreateSlider({
    Name = "FOV Circle Thickness",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 2,
    Flag = "FOVThickness",
    Callback = function(Value)
        circle.Thickness = Value
    end,
})

-- Gun Mods
local GunModsTab = Window:CreateTab("Gun Mods", 4483362458)
local GunModsSection = GunModsTab:CreateSection("Weapon Modifications")

GunModsTab:CreateToggle({
    Name = "Infinite Ammo",
    CurrentValue = false,
    Flag = "InfiniteAmmo",
    Callback = function(Value)
        getgenv().InfiniteAmmo = Value
        
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__index
        
        mt.__index = newcclosure(function(self, k)
            if getgenv().InfiniteAmmo then
                if k == "Ammo" or k == "StoredAmmo" then
                    return 999
                end
            end
            return old(self, k)
        end)
        
        setreadonly(mt, true)
    end,
})

GunModsTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(Value)
        getgenv().NoRecoil = Value
        
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__namecall
        
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().NoRecoil and method == "FireServer" and args[1] == "RecoilCamera" then
                return
            end
            return old(self, ...)
        end)
        
        setreadonly(mt, true)
    end,
})

GunModsTab:CreateToggle({
    Name = "No Spread",
    CurrentValue = false,
    Flag = "NoSpread",
    Callback = function(Value)
        getgenv().NoSpread = Value
        
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__index
        
        mt.__index = newcclosure(function(self, k)
            if getgenv().NoSpread then
                if k == "Spread" or k == "MaxSpread" or k == "MinSpread" then
                    return 0
                end
            end
            return old(self, k)
        end)
        
        setreadonly(mt, true)
    end,
})

-- Advanced Movement
local MovementTab = Window:CreateTab("Movement", 4483362458)
local MovementSection = MovementTab:CreateSection("Movement Mods")

MovementTab:CreateToggle({
    Name = "Bunny Hop",
    CurrentValue = false,
    Flag = "BunnyHop",
    Callback = function(Value)
        getgenv().BunnyHop = Value
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if getgenv().BunnyHop and game.Players.LocalPlayer.Character then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
            end
        end)
    end,
})

MovementTab:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(Value)
        getgenv().SpeedBoost = Value
        while getgenv().SpeedBoost do
            task.wait()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = game.Players.LocalPlayer.Character.Humanoid
                if humanoid.MoveDirection.Magnitude > 0 then
                    game.Players.LocalPlayer.Character:TranslateBy(humanoid.MoveDirection * 0.5)
                end
            end
        end
    end,
})

-- Utility Features
local UtilityTab = Window:CreateTab("Utility", 4483362458)
local UtilitySection = UtilityTab:CreateSection("Utilities")

UtilityTab:CreateToggle({
    Name = "Auto Respawn",
    CurrentValue = false,
    Flag = "AutoRespawn",
    Callback = function(Value)
        getgenv().AutoRespawn = Value
        while getgenv().AutoRespawn do
            task.wait()
            if game.Players.LocalPlayer.Character and 
               game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and 
               game.Players.LocalPlayer.Character.Humanoid.Health <= 0 then
                game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
            end
        end
    end,
})

UtilityTab:CreateButton({
    Name = "Unlock All Skins",
    Callback = function()
        for _, item in pairs(game:GetService("ReplicatedStorage").Skins:GetChildren()) do
            local clone = item:Clone()
            clone.Parent = game.Players.LocalPlayer.PlayerGui.Inventory.Grid
        end
    end,
})

local TriggerTab = Window:CreateTab("Trigger", 4483362458)
local TriggerSection = TriggerTab:CreateSection("Triggerbot Settings")

TriggerTab:CreateToggle({
    Name = "Triggerbot",
    CurrentValue = false,
    Flag = "Triggerbot",
    Callback = function(Value)
        getgenv().Triggerbot = Value
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().Triggerbot then
                local mouse = game.Players.LocalPlayer:GetMouse()
                local target = mouse.Target
                
                if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
                    local player = game.Players:GetPlayerFromCharacter(target.Parent)
                    if player and player.Team ~= game.Players.LocalPlayer.Team then
                        mouse1press()
                        task.wait()
                        mouse1release()
                    end
                end
            end
        end)
    end,
})

TriggerTab:CreateSlider({
    Name = "Trigger Delay",
    Range = {0, 1000},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = 100,
    Flag = "TriggerDelay",
    Callback = function(Value)
        getgenv().TriggerDelay = Value / 1000
    end,
})

TriggerTab:CreateToggle({
    Name = "Trigger Through Walls",
    CurrentValue = false,
    Flag = "TriggerWalls",
    Callback = function(Value)
        getgenv().TriggerThroughWalls = Value
    end,
})

-- Advanced Combat Additions
CombatTab:CreateToggle({
    Name = "Wallbang",
    CurrentValue = false,
    Flag = "Wallbang",
    Callback = function(Value)
        getgenv().Wallbang = Value
        
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().Wallbang and method == "FindPartOnRayWithIgnoreList" then
                table.insert(args[2], workspace.Map)
            end
            
            return oldNamecall(self, unpack(args))
        end)
    end,
})

CombatTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Flag = "AutoShoot",
    Callback = function(Value)
        getgenv().AutoShoot = Value
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().AutoShoot then
                local mouse = game.Players.LocalPlayer:GetMouse()
                if mouse.Target and mouse.Target.Parent then
                    local character = mouse.Target.Parent
                    local humanoid = character:FindFirstChild("Humanoid")
                    local player = game.Players:GetPlayerFromCharacter(character)
                    
                    if player and 
                       player.Team ~= game.Players.LocalPlayer.Team and 
                       humanoid and 
                       humanoid.Health > 0 then
                        mouse1press()
                        task.wait(0.01)
                        mouse1release()
                    end
                end
            end
        end)
    end,
})

CombatTab:CreateToggle({
    Name = "Instant Kill",
    CurrentValue = false,
    Flag = "InstantKill",
    Callback = function(Value)
        getgenv().InstantKill = Value
        
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().InstantKill and method == "FireServer" and args[1] == "Hit" then
                args[2].Damage = 100
            end
            
            return oldNamecall(self, unpack(args))
        end)
    end,
})

-- Fixed Smooth Aim with strict team check
CombatTab:CreateToggle({
    Name = "Smooth Aim",
    CurrentValue = false,
    Flag = "SmoothAim",
    Callback = function(Value)
        getgenv().SmoothAim = Value
        getgenv().SmoothAimSettings = {
            Smoothness = 0.5,
            FOV = 100,
            TargetPart = "Head",
            TeamCheck = true
        }
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().SmoothAim and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local closest = math.huge
                local target = nil
                
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and 
                       player.Team ~= game.Players.LocalPlayer.Team and 
                       player.Character and 
                       player.Character:FindFirstChild("Humanoid") and 
                       player.Character.Humanoid.Health > 0 and
                       player.Character:FindFirstChild(getgenv().SmoothAimSettings.TargetPart) then
                        
                        local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(player.Character[getgenv().SmoothAimSettings.TargetPart].Position)
                        local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)).Magnitude
                        
                        if distance < closest and distance <= getgenv().SmoothAimSettings.FOV then
                            closest = distance
                            target = player.Character[getgenv().SmoothAimSettings.TargetPart]
                        end
                    end
                end
                
                if target then
                    local targetPos = workspace.CurrentCamera:WorldToScreenPoint(target.Position)
                    local mousePos = Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)
                    local moveVector = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * getgenv().SmoothAimSettings.Smoothness
                    
                    mousemoverel(moveVector.X, moveVector.Y)
                end
            end
        end)
    end,
})

CombatTab:CreateSlider({
    Name = "Aim Smoothness",
    Range = {0.1, 1},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "AimSmoothness",
    Callback = function(Value)
        if getgenv().SmoothAimSettings then
            getgenv().SmoothAimSettings.Smoothness = Value
        end
    end,
})

-- Character Customization
local CustomTab = Window:CreateTab("Custom", 4483362458)
local CustomSection = CustomTab:CreateSection("Character Customization")

CustomTab:CreateToggle({
    Name = "Rainbow Character",
    CurrentValue = false,
    Flag = "RainbowCharacter",
    Callback = function(Value)
        getgenv().RainbowCharacter = Value
        while getgenv().RainbowCharacter do
            task.wait()
            if game.Players.LocalPlayer.Character then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    end
                end
            end
        end
    end,
})

CustomTab:CreateToggle({
    Name = "Bullet Tracers",
    CurrentValue = false,
    Flag = "BulletTracers",
    Callback = function(Value)
        getgenv().BulletTracers = Value
        
        local function createBeam(origin, destination)
            local beam = Instance.new("Beam")
            local a0 = Instance.new("Attachment")
            local a1 = Instance.new("Attachment")
            
            a0.Position = origin
            a1.Position = destination
            
            beam.Attachment0 = a0
            beam.Attachment1 = a1
            beam.Width0 = 0.2
            beam.Width1 = 0.2
            beam.LightEmission = 1
            beam.FaceCamera = true
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
            
            a0.Parent = workspace.Terrain
            a1.Parent = workspace.Terrain
            beam.Parent = workspace.Terrain
            
            game:GetService("Debris"):AddItem(a0, 1)
            game:GetService("Debris"):AddItem(a1, 1)
            game:GetService("Debris"):AddItem(beam, 1)
        end
    end,
})

-- Advanced Visual Effects
VisualsTab:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Flag = "Chams",
    Callback = function(Value)
        getgenv().Chams = Value
        while getgenv().Chams do
            task.wait()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            if not part:FindFirstChild("Cham") then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "Cham"
                                highlight.FillColor = player.Team == game.Players.LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.FillTransparency = 0.5
                                highlight.OutlineTransparency = 0
                                highlight.Parent = part
                            end
                        end
                    end
                end
            end
        end
    end,
})

-- Performance Options
local PerfTab = Window:CreateTab("Performance", 4483362458)
local PerfSection = PerfTab:CreateSection("Performance Settings")

PerfTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = false,
    Flag = "FPSBoost",
    Callback = function(Value)
        getgenv().FPSBoost = Value
        if Value then
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").FogEnd = 9e9
            settings().Rendering.QualityLevel = 1
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") or part:IsA("UnionOperation") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                end
            end
        end
    end,
})

PerfTab:CreateButton({
    Name = "Clear Map Decorations",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Decoration") or v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") then
                v:Destroy()
            end
        end
    end,
})

-- Hitbox Modification
CombatTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Flag = "HitboxExpander",
    Callback = function(Value)
        getgenv().HitboxExpander = Value
        
        -- Reset all hitboxes when disabled
        if not Value then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    if player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                        player.Character.HumanoidRootPart.Transparency = 1
                    end
                end
            end
            return
        end
        
        -- Function to modify hitbox
        local function updateHitbox(player)
            if player ~= game.Players.LocalPlayer and 
               player.Team ~= game.Players.LocalPlayer.Team and 
               player.Character and 
               player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Size = Vector3.new(5, 5, 5)
                player.Character.HumanoidRootPart.Transparency = 0.7
                player.Character.HumanoidRootPart.CanCollide = false
            end
        end
        
        -- Update existing players
        for _, player in pairs(game.Players:GetPlayers()) do
            updateHitbox(player)
        end
        
        -- Update for new players
        game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                if getgenv().HitboxExpander then
                    updateHitbox(player)
                end
            end)
        end)
    end,
})

-- Sound Control
local SoundTab = Window:CreateTab("Sound", 4483362458)
local SoundSection = SoundTab:CreateSection("Sound Control")

SoundTab:CreateToggle({
    Name = "Mute Gun Sounds",
    CurrentValue = false,
    Flag = "MuteGuns",
    Callback = function(Value)
        getgenv().MuteGuns = Value
        
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__namecall
        
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().MuteGuns then
                if method == "Play" and self:IsA("Sound") and 
                   (self.Name:find("Gun") or self.Name:find("Fire") or self.Name:find("Shoot")) then
                    return
                end
            end
            return old(self, ...)
        end)
        
        -- Also mute existing gun sounds
        if Value then
            for _, sound in pairs(game:GetDescendants()) do
                if sound:IsA("Sound") and 
                   (sound.Name:find("Gun") or sound.Name:find("Fire") or sound.Name:find("Shoot")) then
                    sound.Volume = 0
                end
            end
        else
            for _, sound in pairs(game:GetDescendants()) do
                if sound:IsA("Sound") and 
                   (sound.Name:find("Gun") or sound.Name:find("Fire") or sound.Name:find("Shoot")) then
                    sound.Volume = sound.OriginalVolume.Value or 0.5
                end
            end
        end
        
        setreadonly(mt, true)
    end,
})

SoundTab:CreateSlider({
    Name = "Game Volume",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 100,
    Flag = "GameVolume",
    Callback = function(Value)
        UserSettings():GetService("UserGameSettings").MasterVolume = Value / 100
    end,
})

-- Crosshair Customization
VisualsTab:CreateToggle({
    Name = "Custom Crosshair",
    CurrentValue = false,
    Flag = "CustomCrosshair",
    Callback = function(Value)
        getgenv().CustomCrosshair = Value
        if Value then
            local crosshair = Drawing.new("Circle")
            crosshair.Visible = true
            crosshair.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
            crosshair.Color = Color3.fromRGB(255, 0, 0)
            crosshair.Thickness = 1
            crosshair.Radius = 3
            
            game:GetService("RunService").RenderStepped:Connect(function()
                if getgenv().CustomCrosshair then
                    crosshair.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
                else
                    crosshair.Visible = false
                end
            end)
        end
    end,
})

