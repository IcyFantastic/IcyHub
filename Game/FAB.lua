--!strict
local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v0.0.1"

getgenv().Changelog = [[
v0.0.1
- Initial Release
]]

do
  local Core = loadstring(game:HttpGet("https://github.com/IcyFantastic/IcyHub/raw/main/Core.lua"))
  if not Core then return warn("Failed to load the IcyHub Core") end
  Core()
end

-- Types

type Element = {
	CurrentValue: any,
	CurrentOption: {string},
	Set: (self: Element, any) -> ()
}

type Flags = {
	[string]: Element
}

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Element,
	CreateDivider: (self: Tab) -> Element,
	CreateToggle: (self: Tab, any) -> Element,
	CreateSlider: (self: Tab, any) -> Element,
	CreateDropdown: (self: Tab, any) -> Element,
	CreateButton: (self: Tab, any) -> Element,
	CreateLabel: (self: Tab, any, any?) -> Element,
	CreateParagraph: (self: Tab, any) -> Element,
}

-- Variables

local Notify: (Title: string, Content: string, Image: string?, Source: string?) -> () = getgenv().Notify
local CreateFeature: (Tab: Tab, FeatureName: string) -> () = getgenv().CreateFeature
local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getgenv().HandleConnection

local queue_on_teleport: (Code: string) -> () = getfenv().queue_on_teleport

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInput = game:GetService("VirtualInputManager")
local Services = ReplicatedStorage.Packages._Index:WaitForChild("sleitnick_knit@1.7.0").knit.Services

local function clickScreen()
  local screenSize = workspace.CurrentCamera.ViewportSize
  local x = screenSize.X / 2
  local y = screenSize.Y / 2
  
  VirtualInput:SendMouseButtonEvent(x, y, 0, true, game, 1)
  wait(0.1)
  VirtualInput:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

local Flags: Flags = getgenv().Flags
local Window = getgenv().Window

-- Automation Tab
local Tab: Tab = Window:CreateTab({
	Name = "Automation",
	Icon = "code",
	ImageSource = "Lucide",
	ShowTitle = false
})

Tab:CreateSection("Fishing")

local fishingConn = nil
local lastTargetPos = nil

local function startFishing()
  if fishingConn then fishingConn:Disconnect() fishingConn = nil end
  fishingConn = RunService.RenderStepped:Connect(function()
    if not Flags.SemiAutoFishing.CurrentValue then
      if fishingConn then fishingConn:Disconnect() fishingConn = nil end
      return
    end
    local fishingGui = Player.PlayerGui:FindFirstChild("Fishing")
    if fishingGui then
      local reelBar = fishingGui:FindFirstChild("Container"):FindFirstChild("ReelFrame"):FindFirstChild("ReelBar")
      local target = fishingGui:FindFirstChild("Container"):FindFirstChild("ReelFrame"):FindFirstChild("Target")
      if reelBar and target then
        reelBar.Position = target.Position
        reelBar.AnchorPoint = target.AnchorPoint
        if math.abs(reelBar.Position.X.Scale - target.Position.X.Scale) <= 0.01 and
           math.abs(reelBar.Position.Y.Scale - target.Position.Y.Scale) <= 0.01 then
          if lastTargetPos ~= target.Position then
            clickScreen()
            lastTargetPos = target.Position
          end
        end
      end
    end
  end)
end

Tab:CreateToggle({
  Name = "Semi Auto Fishing",
  Callback = function()
    if Flags.SemiAutoFishing.CurrentValue then 
      startFishing() 
    elseif fishingConn then 
      fishingConn:Disconnect() 
      fishingConn = nil 
    end
  end
}, "SemiAutoFishing")

-- Shopping Tab
Tab:CreateSection("Shopping")

Tab:CreateToggle({
  Name = "Auto Sell All",
  Callback = function()
    while Flags.AutoSellAll.CurrentValue and task.wait(.1) do
      Services.FishingService.RF.SellInventory:InvokeServer()
    end
  end
}, "AutoSellAll")

-- Teleport Tab
Tab:CreateSection("Teleport")

Tab:CreateButton({
  Name = "Go To Hotspot",
  Description = "Go to the hotspot if exists",
  Callback = function()
    local Hotspots = workspace:WaitForChild("Hotspots")
    for _, Hotspot in ipairs(Hotspots:GetChildren()) do
      if Hotspot:IsA("Model") then
        Character:PivotTo(Hotspot:GetPivot())
        break
      end
    end
  end
})

-- Misc Tab
Tab:CreateSection("Misc")

local Baits = require(ReplicatedStorage.Shared.Data.Baits)

-- urutan fix bait
local baitOrder = {"Common", "Uncommon", "Rare", "Epic", "Legendary"}
local rarityToBaits = {}

-- simpan semua bait sesuai rarity
for baitName, baitData in pairs(Baits) do
    local rarity = baitData.Rarity or "Common"
    if table.find(baitOrder, rarity) then
        rarityToBaits[rarity] = rarityToBaits[rarity] or {}
        table.insert(rarityToBaits[rarity], baitName)
    end
end

Tab:CreateDropdown({
    Name = "Select Bait",
    Description = "Select the bait you want to use",
    Options = baitOrder,
    CurrentOption = {},
    MultipleOptions = true,
    Callback = function() end
}, "SelectBait")

-- Auto Buy Toggle (loop semua bait per rarity)
Tab:CreateToggle({
    Name = "Auto Buy Selected Bait",
    Callback = function()
        while Flags.AutoBuySelectedBait.CurrentValue and task.wait(0.1) do
            for _, selectedRarity in ipairs(Flags.SelectBait.CurrentOption) do
                local baitList = rarityToBaits[selectedRarity]
                if baitList then
                    for _, baitName in ipairs(baitList) do
                        Services.BaitService.RF.PurchaseBait:InvokeServer(baitName)
                    end
                end
            end
        end
    end
}, "AutoBuySelectedBait")

Tab:CreateToggle({
	Name = "Auto Collect Money",
	Callback = function()
		while Flags.AutoCollectMoney.CurrentValue and task.wait(.1) do
			for i = 1, 11 do
				Services.MoneyCollectionService.RF.CollectMoney:InvokeServer("PlaceableArea_" .. i)
			end
		end
	end
}, "AutoCollectMoney")

-- -- Favorite Tab
-- Tab:CreateSection("Favorite")

-- -- fix urutan rarity ikan
-- local fishRarityOrder = {
-- 	"Common", "Uncommon", "Rare", "Epic", "Legendary",
-- 	"Mythic", "Secret", "Abyssal", "Transcendent"
-- }

-- Tab:CreateDropdown({
-- 	Name = "Select Fish Rarity",
-- 	Description = "Select the rarity of fish you want to auto-favorite",
-- 	Options = fishRarityOrder,
-- 	CurrentOption = {},
-- 	MultipleOptions = true,
-- 	Callback = function() end
-- }, "SelectFishRarity")

-- -- Auto Favorite pas dapet ikan via FishBite
-- Tab:CreateToggle({
-- 	Name = "Auto Favorite New Fish",
-- 	CurrentValue = false,
-- 	Flag = "AutoFavoriteNewFish",
-- 	Callback = function(Value)
-- 		if Value then
-- 			-- connect ke event FishBite
-- 			_autoFavConn = Services.FishingService.RE.FishBite.OnClientEvent:Connect(function(fishData)
-- 				-- pastikan fishData ada Rarity & Id
-- 				if fishData and fishData.Rarity and fishData.Id then
-- 					for _, selectedRarity in ipairs(Flags.SelectFishRarity.CurrentOption or {}) do
-- 						if fishData.Rarity == selectedRarity then
-- 							Services.BackpackService.RE.FavoritedToolsUpdate:FireServer(fishData.Id, true)
-- 							Notify("Auto Favorite", "Favorited " .. (fishData.UnitType or "Unknown") .. " (" .. fishData.Rarity .. ")", "check")
-- 						end
-- 					end
-- 				end
-- 			end)
-- 		else
-- 			-- matikan listener kalau toggle off
-- 			if _autoFavConn then
-- 				_autoFavConn:Disconnect()
-- 				_autoFavConn = nil
-- 			end
-- 		end
-- 	end
-- }, "AutoFavoriteNewFish")

-- QoL Tab
local Tab: Tab = Window:CreateTab({
	Name = "QoL",
	Icon = "leaf",
	ImageSource = "Lucide",
	ShowTitle = false
})

Tab:CreateSection("QoL")
CreateFeature(Tab, "QoL")

-- Safety Tab
local Tab: Tab = Window:CreateTab({
	Name = "Safety",
	Icon = "shield",
	ImageSource = "Material",
	ShowTitle = false
})

Tab:CreateSection("Identity")
CreateFeature(Tab, "HideIdentity")

-- Settings Tab
local Tab: Tab = Window:CreateTab({
	Name = "Settings",
	Icon = "settings",
	ImageSource = "Lucide",
	ShowTitle = false
})

Tab:BuildConfigSection()

getgenv().CreateUniversalTabs()

