local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Serenity | Da Hood",
    LoadingTitle = "Serenity Loading...",
    LoadingSubtitle = "by Cody991",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SerenityConfig",
        FileName = "DaHood"
    }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local MainSection = MainTab:CreateSection("Player")

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

MainTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().NoClip = Value
        game:GetService("RunService").Stepped:Connect(function()
            if getgenv().NoClip then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end,
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483362458)
local CombatSection = CombatTab:CreateSection("Fighting")

-- Advanced Combat Features
CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().KillAura = Value
        while getgenv().KillAura do
            task.wait()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and 
                   (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                    game:GetService("ReplicatedStorage").MainEvent:FireServer("Combat", player)
                end
            end
        end
    end,
})

CombatTab:CreateToggle({
    Name = "Auto Reload",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoReload = Value
        while getgenv().AutoReload do
            task.wait()
            if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Combat") then
                game:GetService("ReplicatedStorage").MainEvent:FireServer("Reload")
            end
        end
    end,
})

CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().SilentAim = Value
        while getgenv().SilentAim do
            task.wait()
            local closest = math.huge
            local target = nil
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closest then
                        closest = distance
                        target = player.Character.HumanoidRootPart
                    end
                end
            end
            if target then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
            end
        end
    end,
})

CombatTab:CreateToggle({
    Name = "Anti Stomp",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AntiStomp = Value
        while getgenv().AntiStomp do
            task.wait()
            if game.Players.LocalPlayer.Character.Humanoid.Health <= 5 then
                for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if v:IsA('MeshPart') or v:IsA('Part') then
                        v:Destroy()
                    end
                end
            end
        end
    end,
})

-- Auto Farm Section
local FarmTab = Window:CreateTab("Farming", 4483362458)
local FarmSection = FarmTab:CreateSection("Auto Farm")

FarmTab:CreateToggle({
    Name = "Auto Cash Farm",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        while getgenv().AutoFarm do
            task.wait()
            for _, v in pairs(workspace.Cashiers:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    repeat
                        task.wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Head.CFrame * CFrame.new(0, -2.5, 3)
                        game:GetService("ReplicatedStorage").MainEvent:FireServer("Combat", v)
                    until v.Humanoid.Health <= 0 or not getgenv().AutoFarm
                end
            end
        end
    end,
})

-- ESP Features
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local VisualsSection = VisualsTab:CreateSection("ESP")

VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().ESP = Value
        while getgenv().ESP do
            task.wait()
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and not v.Character:FindFirstChild("ESP") then
                    local esp = Instance.new("Highlight")
                    esp.Name = "ESP"
                    esp.FillColor = Color3.fromRGB(255, 0, 0)
                    esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                    esp.Parent = v.Character
                end
            end
        end
    end,
})

VisualsTab:CreateToggle({
    Name = "Cash ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().CashESP = Value
        while getgenv().CashESP do
            task.wait()
            for _, v in pairs(workspace.Ignored.Drop:GetChildren()) do
                if v.Name == "MoneyDrop" and not v:FindFirstChild("ESP") then
                    local esp = Instance.new("BillboardGui")
                    esp.Name = "ESP"
                    esp.Size = UDim2.new(0, 200, 0, 50)
                    esp.AlwaysOnTop = true
                    esp.Parent = v
                    
                    local text = Instance.new("TextLabel")
                    text.Text = "💵"
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.fromRGB(0, 255, 0)
                    text.Parent = esp
                end
            end
        end
    end,
})

-- Enhanced ESP Features
VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().BoxESP = Value
        while getgenv().BoxESP do
            task.wait()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    if not player.Character:FindFirstChild("BoxESP") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "BoxESP"
                        box.Size = player.Character.HumanoidRootPart.Size + Vector3.new(0.1, 0.1, 0.1)
                        box.Adornee = player.Character.HumanoidRootPart
                        box.AlwaysOnTop = true
                        box.ZIndex = 5
                        box.Color3 = Color3.fromRGB(255, 0, 0)
                        box.Transparency = 0.7
                        box.Parent = player.Character
                    end
                end
            end
        end
    end,
})

VisualsTab:CreateToggle({
    Name = "Tracers ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().TracersESP = Value
        while getgenv().TracersESP do
            task.wait()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    if not player.Character:FindFirstChild("TracerLine") then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.fromRGB(255, 0, 0)
                        line.Thickness = 1
                        line.Transparency = 1
                        line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                        line.To = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                        line.Name = "TracerLine"
                        line.Parent = player.Character
                    end
                end
            end
        end
    end,
})

VisualsTab:CreateToggle({
    Name = "Health ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().HealthESP = Value
        while getgenv().HealthESP do
            task.wait()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    if not player.Character:FindFirstChild("HealthESP") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "HealthESP"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = player.Character
                        
                        local healthLabel = Instance.new("TextLabel")
                        healthLabel.Text = tostring(math.floor(player.Character.Humanoid.Health)).. "/" ..tostring(player.Character.Humanoid.MaxHealth)
                        healthLabel.Size = UDim2.new(1, 0, 1, 0)
                        healthLabel.BackgroundTransparency = 1
                        healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        healthLabel.Parent = billboard
                    end
                end
            end
        end
    end,
})

-- Enhanced Combat Features
CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().Aimbot = Value
        while getgenv().Aimbot do
            task.wait()
            local closest = math.huge
            local target = nil
            
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
                    local vectorDistance = (Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                    
                    if vectorDistance < closest then
                        closest = vectorDistance
                        target = player.Character.HumanoidRootPart
                    end
                end
            end
            
            if target and closest <= 400 then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
            end
        end
    end,
})

CombatTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoShoot = Value
        while getgenv().AutoShoot do
            task.wait()
            if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Combat") then
                mouse1click()
            end
        end
    end,
})

CombatTab:CreateToggle({
    Name = "Rage Mode",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().RageMode = Value
        while getgenv().RageMode do
            task.wait()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 30 then
                        game:GetService("ReplicatedStorage").MainEvent:FireServer("Combat", player)
                        task.wait()
                        mouse1click()
                    end
                end
            end
        end
    end,
})

CombatTab:CreateToggle({
    Name = "Anti Lock",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AntiLock = Value
        while getgenv().AntiLock do
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-1,1), math.random(-1,1), math.random(-1,1))
        end
    end,
})

-- Auto Farm Section
local FarmTab = Window:CreateTab("Farming", 4483362458)
local FarmSection = FarmTab:CreateSection("Auto Farm")

FarmTab:CreateToggle({
    Name = "Auto Muscle Farm",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().MuscleFarm = Value
        while getgenv().MuscleFarm do
            task.wait()
            game:GetService("ReplicatedStorage").MainEvent:FireServer("GymWeight", "Weight1")
            wait(0.5)
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Box Farm",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().BoxFarm = Value
        while getgenv().BoxFarm do
            task.wait()
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "BoxingBag" and v:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    game:GetService("ReplicatedStorage").MainEvent:FireServer("Combat", v)
                end
            end
        end
    end,
})

-- ESP Features
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local VisualsSection = VisualsTab:CreateSection("ESP")

VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().ESP = Value
        while getgenv().ESP do
            task.wait()
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and not v.Character:FindFirstChild("ESP") then
                    local esp = Instance.new("Highlight")
                    esp.Name = "ESP"
                    esp.FillColor = Color3.fromRGB(255, 0, 0)
                    esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                    esp.Parent = v.Character
                end
            end
        end
    end,
})

VisualsTab:CreateToggle({
    Name = "Cash ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().CashESP = Value
        while getgenv().CashESP do
            task.wait()
            for _, v in pairs(workspace.Ignored.Drop:GetChildren()) do
                if v.Name == "MoneyDrop" and not v:FindFirstChild("ESP") then
                    local esp = Instance.new("BillboardGui")
                    esp.Name = "ESP"
                    esp.Size = UDim2.new(0, 200, 0, 50)
                    esp.AlwaysOnTop = true
                    esp.Parent = v
                    
                    local text = Instance.new("TextLabel")
                    text.Text = "💵"
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.fromRGB(0, 255, 0)
                    text.Parent = esp
                end
            end
        end
    end,
})

-- Advanced Teleports
local TeleportTab = Window:CreateTab("Teleports", 4483362458)
local TeleportSection = TeleportTab:CreateSection("Location Teleports")

local locations = {
    ["Bank"] = CFrame.new(-375, 21, -361),
    ["Gun Shop"] = CFrame.new(-582, 7, -739),
    ["Police Station"] = CFrame.new(-266, 21, -121),
    ["Admin Base"] = CFrame.new(-872, -32, -532),
    ["Hood Kicks"] = CFrame.new(-223, 21, -410),
    ["Da Boxing Place"] = CFrame.new(-236, 21, -1119),
    ["School"] = CFrame.new(-586, 21, 290),
    ["Casino"] = CFrame.new(-962, 21, -186)
}

for name, cframe in pairs(locations) do
    TeleportTab:CreateButton({
        Name = "Teleport to " .. name,
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
        end,
    })
end

-- Anti-Cheat Bypass
local function BypassAnticheat()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local namecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if method == "FireServer" and self.Name == "MainEvent" and args[1] == "CHECKER_1" then
            return
        end
        
        return namecall(self, ...)
    end)
end

BypassAnticheat()

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local SettingsSection = SettingsTab:CreateSection("Configuration")

SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

SettingsTab:CreateToggle({
    Name = "Auto Save Settings",
    CurrentValue = true,
    Callback = function(Value)
        Rayfield.ConfigurationSaving.Enabled = Value
    end,
})

-- FOV Circle Setup
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Radius = 100
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

-- Advanced Combat Section
CombatTab:CreateSection("Aim Settings")

CombatTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Callback = function(Value)
        FOVCircle.Visible = Value
    end,
})

CombatTab:CreateSlider({
    Name = "FOV Size",
    Range = {0, 800},
    Increment = 1,
    CurrentValue = 100,
    Callback = function(Value)
        FOVCircle.Radius = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Right Click Lock",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().RightClickLock = Value
        local UserInputService = game:GetService("UserInputService")
        
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 and getgenv().RightClickLock then
                local closest = math.huge
                local target = nil
                local mouse = game.Players.LocalPlayer:GetMouse()
                local mousePos = Vector2.new(mouse.X, mouse.Y)
                
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
                        local vectorDistance = (mousePos - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                        
                        if vectorDistance <= FOVCircle.Radius and vectorDistance < closest then
                            closest = vectorDistance
                            target = player.Character.HumanoidRootPart
                        end
                    end
                end
                
                if target then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
                end
            end
        end)
    end,
})

CombatTab:CreateToggle({
    Name = "One Punch",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().OnePunch = Value
        while getgenv().OnePunch do
            task.wait()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 15 then
                        game:GetService("ReplicatedStorage").MainEvent:FireServer("Combat", player)
                        for i = 1, 10 do
                            game:GetService("ReplicatedStorage").MainEvent:FireServer("Combat", player)
                        end
                    end
                end
            end
        end
    end,
})

-- Enhanced Auto Farm Section
FarmTab:CreateSection("Advanced Farming")

FarmTab:CreateToggle({
    Name = "Auto ATM Farm",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().ATMFarm = Value
        while getgenv().ATMFarm do
            task.wait()
            for _, atm in pairs(workspace.Cashiers:GetChildren()) do
                if atm:FindFirstChild("Humanoid") and atm.Humanoid.Health > 0 then
                    repeat
                        task.wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = atm.Head.CFrame * CFrame.new(0, -2.5, 3)
                        game:GetService("ReplicatedStorage").MainEvent:FireServer("Combat", atm)
                    until atm.Humanoid.Health <= 0 or not getgenv().ATMFarm
                    
                    -- Collect dropped cash
                    for _, cash in pairs(workspace.Ignored.Drop:GetChildren()) do
                        if cash.Name == "MoneyDrop" and (cash.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 50 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cash.CFrame
                            wait(0.5)
                        end
                    end
                end
            end
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Hospital Farm",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().HospitalFarm = Value
        while getgenv().HospitalFarm do
            task.wait()
            local hospital = workspace.Ignored.HospitalJob
            if hospital then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hospital.CFrame
                fireproximityprompt(hospital.ProximityPrompt)
            end
        end
    end,
})

-- Additional ESP Features
VisualsTab:CreateToggle({
    Name = "Tool ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().ToolESP = Value
        while getgenv().ToolESP do
            task.wait()
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Tool") and not v:FindFirstChild("ToolESP") then
                    local esp = Instance.new("BillboardGui")
                    esp.Name = "ToolESP"
                    esp.Size = UDim2.new(0, 200, 0, 50)
                    esp.AlwaysOnTop = true
                    esp.Parent = v
                    
                    local text = Instance.new("TextLabel")
                    text.Text = "🔫 " .. v.Name
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.fromRGB(255, 255, 0)
                    text.Parent = esp
                end
            end
        end
    end,
})

VisualsTab:CreateToggle({
    Name = "Distance ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().DistanceESP = Value
        while getgenv().DistanceESP do
            task.wait()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    if not player.Character:FindFirstChild("DistanceESP") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "DistanceESP"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = player.Character
                        
                        local distanceLabel = Instance.new("TextLabel")
                        local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        distanceLabel.Text = math.floor(distance) .. " studs"
                        distanceLabel.Size = UDim2.new(1, 0, 1, 0)
                        distanceLabel.BackgroundTransparency = 1
                        distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        distanceLabel.Parent = billboard
                    end
                end
            end
        end
    end,
})

-- More Combat Features
CombatTab:CreateToggle({
    Name = "Auto Stomp",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoStomp = Value
        while getgenv().AutoStomp do
            task.wait()
            game:GetService("ReplicatedStorage").MainEvent:FireServer("Stomp")
        end
    end,
})

CombatTab:CreateToggle({
    Name = "Anti Grab",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AntiGrab = Value
        while getgenv().AntiGrab do
            task.wait()
            if game.Players.LocalPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT") then
                game.Players.LocalPlayer.Character.GRABBING_CONSTRAINT:Destroy()
            end
        end
    end,
})

-- More Farming Features
FarmTab:CreateToggle({
    Name = "Auto Muscle Farm",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().MuscleFarm = Value
        while getgenv().MuscleFarm do
            task.wait()
            game:GetService("ReplicatedStorage").MainEvent:FireServer("GymWeight", "Weight1")
            wait(0.5)
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Box Farm",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().BoxFarm = Value
        while getgenv().BoxFarm do
            task.wait()
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "BoxingBag" and v:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    game:GetService("ReplicatedStorage").MainEvent:FireServer("Combat", v)
                end
            end
        end
    end,
})

-- Additional Visual Features
VisualsTab:CreateToggle({
    Name = "Bullet Tracers",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().BulletTracers = Value
        
        local function createTracer(origin, destination)
            local beam = Instance.new("Beam")
            local attachment1 = Instance.new("Attachment")
            local attachment2 = Instance.new("Attachment")
            
            attachment1.Position = origin
            attachment2.Position = destination
            
            beam.Attachment0 = attachment1
            beam.Attachment1 = attachment2
            beam.Width0 = 0.1
            beam.Width1 = 0.1
            beam.FaceCamera = true
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
            
            attachment1.Parent = workspace.Terrain
            attachment2.Parent = workspace.Terrain
            beam.Parent = workspace.Terrain
            
            game:GetService("Debris"):AddItem(attachment1, 1)
            game:GetService("Debris"):AddItem(attachment2, 1)
            game:GetService("Debris"):AddItem(beam, 1)
        end
        
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(...)
            local args = {...}
            local method = getnamecallmethod()
            if method == "FireServer" and args[2] == "ShootGun" and getgenv().BulletTracers then
                createTracer(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, args[3])
            end
            return old(...)
        end)
    end,
})

-- Player Modifications
MainTab:CreateToggle({
    Name = "Anti Ragdoll",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AntiRagdoll = Value
        while getgenv().AntiRagdoll do
            task.wait()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Ragdolled") then
                game.Players.LocalPlayer.Character.Ragdolled:Destroy()
            end
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Reset on Low Health",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoReset = Value
        while getgenv().AutoReset do
            task.wait()
            if game.Players.LocalPlayer.Character and 
               game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and 
               game.Players.LocalPlayer.Character.Humanoid.Health <= 15 then
                game.Players.LocalPlayer.Character:BreakJoints()
            end
        end
    end,
})


