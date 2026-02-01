---******************************************************
--- Local Variables                                   ***
---******************************************************

--- The Config object
local Config = require 'config.shared'

if not Config.EnableLivemap then return end

local doesPlayerHasLiveMapItem = false
local playerLoaded = false

RegisterPlayerLoadedHandler(function()
  playerLoaded = true
end)

AddEventHandler('onResourceStart', function(resourceName)
  if GetCurrentResourceName() == resourceName then
    playerLoaded = true
  end
end)

---******************************************************
--- Threads                                           ***
---******************************************************

CreateThread(function()
  while not playerLoaded do
    Wait(0)
  end

  local license = lib.callback.await('vpc_connector:cb:getLicense', false)
  while license == nil do
    Wait(0)
  end

  while true do
    local conet = GetNetSiteCoo()

    if conet ~= nil then
      local playerCoords = GetEntityCoords(PlayerPedId())
      if (Config.LivemapItem and not doesPlayerHasLiveMapItem) or conet == "noNET" then
        TriggerServerEvent('vpc_connector:server:updateDuty', license, "offduty")
      else
        TriggerServerEvent('vpc_connector:server:updateCoords', license, playerCoords, "onduty", conet)
      end
    end

    Wait(5000) -- 5 seconds
  end
end)

CreateThread(function()
  while not playerLoaded do
    Wait(0)
  end

  if not Config.LivemapItem then
    doesPlayerHasLiveMapItem = true
    return
  end

  while true do
    local result = lib.callback.await('vpc_connector:cb:hasItem', false, Config.LivemapItem)
    doesPlayerHasLiveMapItem = result == true

    Wait(30000) -- Check every 30 seconds
  end
end)
