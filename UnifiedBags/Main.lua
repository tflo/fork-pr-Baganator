local function SetupView()
  local mainView = CreateFrame("Frame", "Baganator_MainViewFrame", UIParent, "BaganatorMainViewTemplate")
  mainView:SetClampedToScreen(true)
  mainView:SetUserPlaced(false)

  local bankOnlyView = CreateFrame("Frame", "Baganator_BankOnlyViewFrame", UIParent, "BaganatorBankOnlyViewTemplate")
  bankOnlyView:SetClampedToScreen(true)
  bankOnlyView:SetUserPlaced(false)

  local function SetPositions()
    mainView:ClearAllPoints()
    mainView:SetPoint(unpack(Baganator.Config.Get(Baganator.Config.Options.MAIN_VIEW_POSITION)))
    bankOnlyView:ClearAllPoints()
    bankOnlyView:SetPoint(unpack(Baganator.Config.Get(Baganator.Config.Options.BANK_ONLY_VIEW_POSITION)))
  end

  SetPositions()

  local customiseDialog = CreateFrame("Frame", "BaganatorCustomiseDialogFrame", UIParent, "BaganatorCustomiseDialogTemplate")
  customiseDialog:SetPoint("CENTER")

  table.insert(UISpecialFrames, mainView:GetName())
  table.insert(UISpecialFrames, bankOnlyView:GetName())
  table.insert(UISpecialFrames, customiseDialog:GetName())

  Baganator.CallbackRegistry:RegisterCallback("ResetFramePositions", function()
    Baganator.Config.ResetOne(Baganator.Config.Options.MAIN_VIEW_POSITION)
    Baganator.Config.ResetOne(Baganator.Config.Options.BANK_ONLY_VIEW_POSITION)
    SetPositions()
  end)

  Baganator.CallbackRegistry:RegisterCallback("ShowCustomise", function()
    customiseDialog:RefreshOptions()
    customiseDialog:SetShown(not customiseDialog:IsShown())
    customiseDialog:Raise()
  end)

  local function ToggleMainView()
      mainView:SetShown(not mainView:IsShown())
      if mainView:IsVisible() then
        mainView:UpdateForCharacter(Baganator.Cache.currentCharacter, true)
      end
  end

  if not Baganator.Config.Get(Baganator.Config.Options.INVERTED_BAG_SHORTCUTS) then
    hooksecurefunc("ToggleAllBags", ToggleMainView)
  end

  Baganator.CallbackRegistry:RegisterCallback("BagShow",  function(_, ...)
    mainView:Show()
    mainView:UpdateForCharacter(Baganator.Cache.currentCharacter, true)
  end)

  Baganator.CallbackRegistry:RegisterCallback("BagHide",  function(_, ...)
    mainView:Hide()
  end)

  hooksecurefunc("OpenAllBags", function()
    mainView:Show()
    mainView:UpdateForCharacter(Baganator.Cache.currentCharacter, true)
  end)

  hooksecurefunc("CloseAllBags", function()
    mainView:Hide()
  end)

  -- Backpack button
  MainMenuBarBackpackButton:SetScript("OnClick", ToggleMainView)
  -- Bags 1-4, hookscript so that changing bags remains
  for i = 0, 3 do
    _G["CharacterBag" .. i .. "Slot"]:HookScript("OnClick", ToggleMainView)
  end
  -- Reagent bas
  if CharacterReagentBag0Slot then
    CharacterReagentBag0Slot:HookScript("OnClick", ToggleMainView)
  end

  if Baganator.Constants.IsEra or Baganator.Config.Get(Baganator.Config.Options.INVERTED_BAG_SHORTCUTS) then
    hooksecurefunc("ToggleBackpack", ToggleMainView)
  end
end

local function HideDefaultBags()
  local hidden = CreateFrame("Frame")
  hidden:Hide()

  if Baganator.Constants.IsRetail then
    ContainerFrameCombinedBags:SetParent(hidden)

    for i = 1, 6 do
      _G["ContainerFrame" .. i]:SetParent(hidden)
    end
    -- Prevent glitchy tutorial popups that cannot be closed from showing
    -- These would ordinarily be attached to the Blizzard bag frames
    SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_HUD_REVAMP_BAG_CHANGES, true)
    SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_BAG_SLOTS_AUTHENTICATOR, true)
    GetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_MOUNT_EQUIPMENT_SLOT_FRAME, true)
  else
    for i = 1, 5 do
      _G["ContainerFrame" .. i]:SetParent(hidden)
    end
  end

  BankFrame:SetParent(hidden)
  BankFrame:SetScript("OnHide", nil)
  BankFrame:SetScript("OnShow", nil)
  BankFrame:SetScript("OnEvent", nil)
end

function Baganator.InitializeUnifiedBags()
  Baganator.Search.Initialize()

  SetupView()
  HideDefaultBags()

  Baganator.ItemButtonUtil.UpdateSettings()
end
