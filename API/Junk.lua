Baganator.Utilities.OnAddonLoaded("Peddler", function()
  if not PeddlerAPI then
    return
  end

  Baganator.API.RegisterJunkPlugin(BAGANATOR_L_PEDDLER, "peddler", function(bagID, slotID, ...)
    local itemID, uniqueItemID, isSoulbound, itemLink = PeddlerAPI.getUniqueItemID(bagID, slotID)

    return uniqueItemID and PeddlerAPI.itemIsToBeSold(itemID, uniqueItemID, isSoulbound)
  end)
end)

Baganator.Utilities.OnAddonLoaded("SellJunk", function()
  Baganator.API.RegisterJunkPlugin(BAGANATOR_L_SELLJUNK, "selljunk", function(bagID, slotID, itemID, itemLink)
    return SellJunk:CheckItemIsJunk(itemLink, bagID, slotID)
  end)
  hooksecurefunc(SellJunk, "Add", function()
    Baganator.API.RequestItemButtonsRefresh()
  end)
  hooksecurefunc(SellJunk, "Rem", function()
    Baganator.API.RequestItemButtonsRefresh()
  end)
end)

Baganator.Utilities.OnAddonLoaded("Scrap", function()
  Baganator.API.RegisterJunkPlugin(BAGANATOR_L_SCRAP, "scrap", function(bagID, slotID, itemID, itemLink)
    return Scrap:IsJunk(itemID, bagID, slotID)
  end)
  hooksecurefunc(Scrap, "ToggleJunk", function()
    Baganator.API.RequestItemButtonsRefresh()
  end)
end)

Baganator.Utilities.OnAddonLoaded("Vendor", function()
  Baganator.API.RegisterJunkPlugin(BAGANATOR_L_VENDOR, "vendor", function(bagID, slotID, itemID, itemLink)
    return Vendor.EvaluateItem(bagID, slotID) == 1
  end)

  local extension = {
    Addon = BAGANATOR_L_BAGANATOR,
    Source = BAGANATOR_L_BAGANATOR,
    Version = 1.0,
    OnRuleUpdate = function()
      Baganator.API.RequestItemButtonsRefresh()
    end,
  }
  C_Timer.After(0, function()
    Vendor.RegisterExtension(extension)
  end)
end)
