---******************************************************
--- Local Variables                                   ***
---******************************************************

--- The frameworkType variable
local frameworkType = nil

---******************************************************
--- Global Functions                                  ***
---******************************************************

--- Ensures that the framework is detected and set.
--- @return string|nil
function EnsureFramework()
  if frameworkType ~= nil then
    return frameworkType
  end

  GetFramework()
  if QBCore ~= nil then
    frameworkType = 'QB'
    return frameworkType
  end
  if ESX ~= nil then
    frameworkType = 'ESX'
    return frameworkType
  end

  return nil
end

--- Register a handler for when a player is loaded.
--- @param cb function
function RegisterPlayerLoadedHandler(cb)
  RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    EnsureFramework()
    cb('QB')
  end)

  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(playerData)
    EnsureFramework()
    cb('ESX', playerData)
  end)
end

--- Register a handler for when a player's job is updated.
--- @param cb function
function RegisterJobUpdateHandler(cb)
  RegisterNetEvent('QBCore:Client:OnJobUpdate')
  AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    EnsureFramework()
    cb(job, 'QB')
  end)

  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
    EnsureFramework()
    cb(job, 'ESX')
  end)
end
