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

--- Gets the player object for the given source based on the framework.
--- @param source number
--- @return any|nil
function GetPlayer(source)
  local fw = EnsureFramework()
  if fw == 'QB' then
    return QBCore.Functions.GetPlayer(source)
  end
  if fw == 'ESX' then
    return ESX.GetPlayerFromId(source)
  end
  return nil
end

--- Gets the job object for the given player based on the framework.
--- @param player any
--- @return table|nil
function GetPlayerJob(player)
  if player == nil then return nil end

  local fw = EnsureFramework()
  if fw == 'QB' then
    return player.PlayerData.job
  end
  if fw == 'ESX' then
    return player.job
  end
  return nil
end

--- Gets the job grade for the given job object based on the framework.
--- @param player any
--- @return string|nil
function GetPlayerJobName(player)
  local job = GetPlayerJob(player)
  if type(job) == 'table' then
    return job.name
  end
  return nil
end

--- Gets the job grade number for the given player based on the framework.
---@param player any
---@return number
function GetPlayerJobGrade(player)
  local job = GetPlayerJob(player)
  return GetJobGrade(job)
end

--- Checks whether the player has the specified item.
---@param source number
---@param itemName string
---@return boolean
function PlayerHasItem(source, itemName)
  if itemName == nil then return false end

  local fw = EnsureFramework()
  if fw == 'ESX' then
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.getInventoryItem(itemName).count >= 1
  end
  if fw == 'QB' then
    local Player = QBCore.Functions.GetPlayer(source)
    local HasItem = Player.Functions.GetItemByName(itemName)
    return HasItem ~= nil
  end

  return false
end

--- Gets the first identifier of a player matching the specified prefix.
---@param source number
---@return string|nil
function GetIdentifierByPrefix(source, prefix)
  if prefix == nil then return nil end

  for _, v in pairs(GetPlayerIdentifiers(source)) do
    if string.sub(v, 1, string.len(prefix)) == prefix then
      return v
    end
  end

  return nil
end

--- Registers a useable item with the framework.
--- @param itemName string
--- @param cb function
function RegisterUseableItem(itemName, cb)
  if itemName == nil then return end

  local fw = EnsureFramework()
  if fw == 'ESX' then
    ESX.RegisterUsableItem(itemName, function(source)
      cb(source)
    end)
    return
  end

  if fw == 'QB' then
    QBCore.Functions.CreateUseableItem(itemName, function(source, item)
      cb(source, item)
    end)
  end
end
