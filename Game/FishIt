-- IcyHub - Fish It Script v3.0
-- UI Luna Edition | Working Version

repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- UI Library Luna
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna/main/source.lua", true))()
local Window = Luna:CreateWindow({
    Name = "🧊 IcyHub - Fish It",
    LoadingTitle = "IcyHub Loading...",
    LoadingSubtitle = "by IcyHub Team",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "IcyHub",
        FileName = "FishIt"
    },
    KeySystem = false
})

-- Variables
local Settings = {
    AutoFish = false,
    AutoCast = false,
    AutoSell = false,
    AutoReel = false,
    PerfectCatch = false,
    AutoEquipRod = false,
    SellDelay = 5,
    WalkSpeed = 16,
    JumpPower = 50
}

-- Functions
local function Notify(title, text, duration)
    Luna:Notification({
        Title = title,
        Content = text,
        Duration = duration or 3
    })
end

-- Get Player's Inventory/Backpack
local function GetInventory()
    local inv = {}
    for _, item in pairs(Player.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(inv, item)
        end
    end
    return inv
end

-- Get Current Rod
local function GetCurrentRod()
    local rod = Character:FindFirstChildOfClass("Tool")
    if rod then
        return rod
    end
    
    for _, tool in pairs(Player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("rod") or tool.Name:lower():find("pole")) then
            return tool
        end
    end
    return nil
end

-- Equip Rod
local function EquipRod()
    local rod = GetCurrentRod()
    if rod and rod.Parent == Player.Backpack then
        Humanoid:EquipTool(rod)
        task.wait(0.3)
    end
end

-- Get Fishing GUI
local function GetFishingGUI()
    local gui = Player.PlayerGui:FindFirstChild("FishingGui") or 
                Player.PlayerGui:FindFirstChild("FishGui") or
                Player.PlayerGui:FindFirstChild("Fishing")
    return gui
end

-- Auto Fish Function (Instant Perfect Catch)
local function AutoFish()
    spawn(function()
        while Settings.AutoFish do
            task.wait(0.05)
            pcall(function()
                local gui = GetFishingGUI()
                if gui and gui.Enabled then
                    -- Find catch button or bar
                    for _, v in pairs(gui:GetDescendants()) do
                        if v:IsA("TextButton") or v:IsA("ImageButton") then
                            if v.Visible and v.Name:lower():find("catch") or 
                               v.Name:lower():find("reel") or
                               v.Text:lower():find("catch") then
                                -- Perfect catch
                                if Settings.PerfectCatch then
                                    task.wait(0.1) -- Perfect timing
                                end
                                
                                -- Fire button
                                for _, conn in pairs(getconnections(v.MouseButton1Click)) do
                                    conn:Fire()
                                end
                                
                                firesignal(v.MouseButton1Click)
                                task.wait(0.2)
                            end
                        elseif v:IsA("Frame") and v.Name:lower():find("bar") then
                            -- Handle minigame bar
                            if Settings.PerfectCatch then
                                local sweet_spot = v:FindFirstChild("SweetSpot") or v:FindFirstChild("Target")
                                if sweet_spot then
                                    -- Click on sweet spot
                                    firesignal(sweet_spot.MouseButton1Click)
                                end
                            end
                        end
                    end
                    
                    -- Try RemoteEvent method
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            if remote.Name:lower():find("catch") or 
                               remote.Name:lower():find("fish") or
                               remote.Name:lower():find("reel") then
                                remote:FireServer("Catch")
                                remote:FireServer("Perfect")
                                remote:FireServer(100) -- Perfect score
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Auto Cast Function
local function AutoCast()
    spawn(function()
        while Settings.AutoCast do
            task.wait(1)
            pcall(function()
                if Settings.AutoEquipRod then
                    EquipRod()
                end
                
                local rod = GetCurrentRod()
                if rod and rod.Parent == Character then
                    -- Method 1: Activate tool
                    rod:Activate()
                    
                    -- Method 2: Fire remote
                    if rod:FindFirstChild("Cast") then
                        rod.Cast:FireServer()
                    end
                    
                    if rod:FindFirstChild("Throw") then
                        rod.Throw:FireServer()
                    end
                    
                    -- Method 3: Search for cast remote
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            if remote.Name:lower():find("cast") or 
                               remote.Name:lower():find("throw") then
                                remote:FireServer()
                            end
                        end
                    end
                    
                    task.wait(2) -- Wait before next cast
                end
            end)
        end
    end)
end

-- Auto Reel Function
local function AutoReel()
    spawn(function()
        while Settings.AutoReel do
            task.wait(0.1)
            pcall(function()
                local gui = GetFishingGUI()
                if gui and gui.Enabled then
                    -- Hold reel button
                    for _, v in pairs(gui:GetDescendants()) do
                        if v:IsA("TextButton") and v.Name:lower():find("reel") then
                            for _, conn in pairs(getconnections(v.MouseButton1Down)) do
                                conn:Fire()
                            end
                        end
                    end
                    
                    -- Fire reel remote
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and remote.Name:lower():find("reel") then
                            remote:FireServer(true)
                        end
                    end
                end
            end)
        end
    end)
end

-- Auto Sell Function
local function AutoSell()
    spawn(function()
        while Settings.AutoSell do
            task.wait(Settings.SellDelay)
            pcall(function()
                local oldPos = HumanoidRootPart.CFrame
                
                -- Find sell location
                local sellLocation
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") or v:IsA("Part") then
                        if v.Name:lower():find("sell") or 
                           v.Name:lower():find("shop") or
                           v.Name:lower():find("merchant") or
                           v.Name:lower():find("buyer") then
                            sellLocation = v
                            break
                        end
                    end
                end
                
                if sellLocation then
                    -- Teleport to sell
                    local sellPart = sellLocation:IsA("Model") and 
                                    (sellLocation:FindFirstChild("HumanoidRootPart") or 
                                     sellLocation:FindFirstChildOfClass("Part")) or 
                                    sellLocation
                    
                    if sellPart then
                        HumanoidRootPart.CFrame = sellPart.CFrame * CFrame.new(0, 3, 0)
                        task.wait(0.5)
                        
                        -- Fire sell remote
                        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                            if remote:IsA("RemoteEvent") then
                                if remote.Name:lower():find("sell") or 
                                   remote.Name:lower():find("shop") then
                                    remote:FireServer()
                                    remote:FireServer("SellAll")
                                    remote:FireServer("All")
                                end
                            end
                        end
                        
                        -- Try ProximityPrompt
                        for _, prompt in pairs(sellLocation:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                fireproximityprompt(prompt)
                            end
                        end
                        
                        -- Click sell button in GUI
                        local gui = Player.PlayerGui:FindFirstChild("ShopGui") or 
                                   Player.PlayerGui:FindFirstChild("SellGui")
                        if gui then
                            for _, btn in pairs(gui:GetDescendants()) do
                                if btn:IsA("TextButton") and 
                                   (btn.Text:lower():find("sell") or btn.Name:lower():find("sell")) then
                                    firesignal(btn.MouseButton1Click)
                                end
                            end
                        end
                        
                        task.wait(1)
                        HumanoidRootPart.CFrame = oldPos
                    end
                end
            end)
        end
    end)
end

-- Anti AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Tabs
local MainTab = Window:CreateTab("🎣 Main", "fishing_pole")
local PlayerTab = Window:CreateTab("👤 Player", "user")
local TeleportTab = Window:CreateTab("📍 Teleport", "map_pin")
local MiscTab = Window:CreateTab("⚙️ Settings", "settings")

-- Main Tab
local FishingSection = MainTab:CreateSection("Auto Fishing", "left")

MainTab:CreateToggle({
    Name = "Auto Fish (Perfect Catch)",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(Value)
        Settings.AutoFish = Value
        if Value then
            Notify("Auto Fish", "Auto Fish Enabled!", 3)
            AutoFish()
        else
            Notify("Auto Fish", "Auto Fish Disabled!", 3)
        end
    end,
})

MainTab:CreateToggle({
    Name = "Perfect Catch Mode",
    CurrentValue = false,
    Flag = "PerfectCatch",
    Info = "Always catches fish perfectly",
    Callback = function(Value)
        Settings.PerfectCatch = Value
        Notify("Perfect Catch", Value and "Enabled" or "Disabled", 2)
    end,
})

MainTab:CreateToggle({
    Name = "Auto Cast Rod",
    CurrentValue = false,
    Flag = "AutoCast",
    Callback = function(Value)
        Settings.AutoCast = Value
        if Value then
            Notify("Auto Cast", "Auto Cast Enabled!", 3)
            AutoCast()
        else
            Notify("Auto Cast", "Auto Cast Disabled!", 3)
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Reel",
    CurrentValue = false,
    Flag = "AutoReel",
    Callback = function(Value)
        Settings.AutoReel = Value
        if Value then
            AutoReel()
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Equip Rod",
    CurrentValue = false,
    Flag = "AutoEquipRod",
    Callback = function(Value)
        Settings.AutoEquipRod = Value
    end,
})

local SellSection = MainTab:CreateSection("Auto Sell", "right")

MainTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        Settings.AutoSell = Value
        if Value then
            Notify("Auto Sell", "Auto Sell Enabled!", 3)
            AutoSell()
        else
            Notify("Auto Sell", "Auto Sell Disabled!", 3)
        end
    end,
})

MainTab:CreateSlider({
    Name = "Sell Delay (seconds)",
    Range = {1, 30},
    Increment = 1,
    CurrentValue = 5,
    Flag = "SellDelay",
    Callback = function(Value)
        Settings.SellDelay = Value
    end,
})

MainTab:CreateButton({
    Name = "Sell Now",
    Callback = function()
        task.spawn(function()
            local oldPos = HumanoidRootPart.CFrame
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:lower():find("sell") then
                    local part = v:IsA("Model") and v:FindFirstChildOfClass("Part") or v
                    if part then
                        HumanoidRootPart.CFrame = part.CFrame
                        task.wait(1)
                        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("sell") then
                                remote:FireServer()
                                remote:FireServer("SellAll")
                            end
                        end
                        task.wait(1)
                        HumanoidRootPart.CFrame = oldPos
                        Notify("Success", "Sold all fish!", 3)
                        break
                    end
                end
            end
        end)
    end,
})

-- Player Tab
local MovementSection = PlayerTab:CreateSection("Movement", "left")

PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        Settings.WalkSpeed = Value
        Humanoid.WalkSpeed = Value
    end,
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        Settings.JumpPower = Value
        Humanoid.JumpPower = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(Value)
        local InfJump = Value
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if InfJump and Humanoid then
                Humanoid:ChangeState("Jumping")
            end
        end)
    end,
})

-- Teleport Tab
local TeleportSection = TeleportTab:CreateSection("Quick Teleports")

TeleportTab:CreateButton({
    Name = "Teleport to Sell",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower():find("sell") or v.Name:lower():find("shop") then
                local part = v:IsA("Model") and v:FindFirstChildOfClass("Part") or v
                if part and part:IsA("BasePart") then
                    HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 5, 0)
                    Notify("Teleport", "Teleported to Sell!", 3)
                    break
                end
            end
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        local spawn = workspace:FindFirstChild("SpawnLocation")
        if spawn then
            HumanoidRootPart.CFrame = spawn.CFrame * CFrame.new(0, 5, 0)
            Notify("Teleport", "Teleported to Spawn!", 3)
        end
    end,
})

-- Misc Tab
local ServerSection = MiscTab:CreateSection("Server")

MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end,
})

MiscTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"
        
        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
        
        function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        
        local Server, Next
        repeat
            local Servers = ListServers(Next)
            Server = Servers.data[1]
            Next = Servers.nextPageCursor
        until Server
        
        TPS:TeleportToPlaceInstance(_place, Server.id, Player)
    end,
})

local InfoSection = MiscTab:CreateSection("Information")

MiscTab:CreateParagraph({
    Title = "🧊 IcyHub",
    Content = "Version: 3.0\nUI: Luna\nGame: Fish It\n\nCreated by IcyHub Team ❄️"
})

MiscTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        game:GetService("CoreGui"):FindFirstChild("Luna"):Destroy()
    end,
})

-- Character Respawn Handler
Player.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    
    task.wait(1)
    Humanoid.WalkSpeed = Settings.WalkSpeed
    Humanoid.JumpPower = Settings.JumpPower
end)

-- Initialize
Notify("🧊 IcyHub Loaded!", "Fish It Script v3.0 Ready!", 5)
task.wait(2)
Notify("Tip 💡", "Enable Auto Cast + Auto Fish to start!", 4)
