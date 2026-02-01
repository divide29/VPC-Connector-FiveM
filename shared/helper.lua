---******************************************************
--- Local Variables                                   ***
---******************************************************

local SharedConfig = require 'config.shared'

--- The color codes for different log levels
local levelColors = {
  DEBUG = '^5',
  INFO = '^2',
  WARN = '^3',
  WARNING = '^3',
  ERROR = '^1',
}

---******************************************************
--- Global Functions                                  ***
---******************************************************

---Prints a formatted log with a level prefix.
---@param level 'DEBUG'|'INFO'|'WARN'|'WARNING'|'ERROR'|string
---@vararg any
function Log(level, ...)
  level = tostring(level or 'INFO'):upper()

  if level == 'DEBUG' and SharedConfig.Debug == false then return end

  local color = levelColors[level] or '^7'
  local prefix = string.format('%s[%s]', color, level)

  local msgParts = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(msgParts, tostring(v))
  end
  local msg = table.concat(msgParts, ' ')

  print(string.format('%s %s^7', prefix, msg))
end

---Reads the version metadata from a resource's fxmanifest.
---@param resourceName string
---@return string|nil
function GetResourceVersion(resourceName)
  local count = GetNumResourceMetadata(resourceName, 'version') or 0
  if count <= 0 then
    return nil
  end

  local version = GetResourceMetadata(resourceName, 'version', 0)
  if type(version) == 'string' and version ~= '' then
    return version
  end
  return nil
end

---Compares two SemVer-ish version strings.
---Returns:
---- `1` if actualVersion > minimumVersion
--- `0` if actualVersion == minimumVersion
--- `-1` if actualVersion < minimumVersion
--- `nil` if versions cannot be compared
--- @param actualVersion string
--- @param minimumVersion string
--- @return number|nil
function CompareSemverVersions(actualVersion, minimumVersion)
  local function parseVersion(version)
    local parts = {}
    for part in string.gmatch(version, '([0-9]+)') do
      table.insert(parts, tonumber(part))
    end
    return parts
  end

  local actualParts = parseVersion(actualVersion)
  local minimumParts = parseVersion(minimumVersion)

  local length = math.max(#actualParts, #minimumParts)
  for i = 1, length do
    local actualPart = actualParts[i] or 0
    local minimumPart = minimumParts[i] or 0

    if actualPart < minimumPart then
      return -1
    elseif actualPart > minimumPart then
      return 1
    end
  end

  return 0
end

---Gets a numeric job grade from a framework job object.
---@param job table|nil
---@return number
function GetJobGrade(job)
  if type(job) ~= 'table' then
    return 0
  end

  if type(job.grade) == 'number' then
    return job.grade
  end

  if type(job.grade_level) == 'number' then
    return job.grade_level
  end

  if type(job.grade) == 'table' and type(job.grade.level) == 'number' then
    return job.grade.level
  end

  return 0
end

---Resolves the net type (cop/medic/car/fire) based on Config.Jobs.
---@param jobName string|nil
---@param jobGrade number|nil
---@return string|nil
function GetNetForJob(jobName, jobGrade)
  local name = tostring(jobName or '')
  if name == '' then
    return nil
  end

  local grade = tonumber(jobGrade) or 0

  local function meets(netKey)
    local netTable = SharedConfig.Jobs[netKey]
    if type(netTable) ~= 'table' then
      return false
    end

    local minRank = netTable[name]
    if minRank == nil then
      return false
    end

    local min = tonumber(minRank) or 0
    return grade >= min
  end

  if meets('copnet') then return 'cop' end
  if meets('medicnet') then return 'medic' end
  if meets('carnet') then return 'car' end
  if meets('firenet') then return 'fire' end

  return nil
end

---Resolves and initializes the configured framework.
---Sets global `ESX` or `QBCore` and returns it.
---@return table|nil
function GetFramework()
  local framework = tostring(SharedConfig.Framework or ''):upper()

  local function tryResolveEsx()
    if ESX ~= nil then return ESX end

    if SharedConfig.FrameworkTrigger ~= nil and SharedConfig.FrameworkTrigger ~= '' and
        GetResourceState(SharedConfig.FrameworkTrigger) == 'started' then
      local ok, result = pcall(function()
        return exports[SharedConfig.FrameworkTrigger]:getSharedObject()
      end)
      if ok then
        ESX = result
        return ESX
      end
    end

    if GetResourceState('es_extended') == 'started' then
      if exports['es_extended'] and exports['es_extended'].getSharedObject then
        ESX = exports['es_extended']:getSharedObject()
      else
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      end
      return ESX
    end

    return nil
  end

  if framework == '' or framework == 'AUTO' then
    if GetResourceState('qb-core') == 'started' then
      if QBCore == nil then
        QBCore = exports['qb-core']:GetCoreObject()
      end
      return QBCore
    end

    local esx = tryResolveEsx()
    if esx ~= nil then
      return esx
    end

    Log('ERROR', 'No supported framework detected.')
    return nil
  end

  if (framework == 'ESX' or framework == 'ESX185') and
      (SharedConfig.FrameworkTrigger == nil or SharedConfig.FrameworkTrigger == '') then
    Log('ERROR', 'Config.FrameworkTrigger is not set. Please check your config.lua')
    return nil
  end

  if framework == 'QB' then
    if QBCore == nil then
      QBCore = exports['qb-core']:GetCoreObject()
    end
    return QBCore
  end

  if framework == 'ESX' then
    if ESX == nil then
      if IsDuplicityVersion() then
        TriggerEvent(SharedConfig.FrameworkTrigger, function(obj) ESX = obj end)
        if ESX == nil then
          Log('ERROR', 'Failed to resolve ESX on server. Check FrameworkTrigger:', SharedConfig.FrameworkTrigger)
        end
      else
        Citizen.CreateThread(function()
          TriggerEvent(SharedConfig.FrameworkTrigger, function(obj) ESX = obj end)
          if ESX == nil then
            Log('ERROR', 'Failed to resolve ESX on client. Check FrameworkTrigger:', SharedConfig.FrameworkTrigger)
            return
          end

          Citizen.Wait(500)
          if ESX.GetPlayerData ~= nil then
            PlayerData = ESX.GetPlayerData()
          end
        end)
      end
    end
    return ESX
  end

  if framework == 'ESX185' then
    if ESX == nil then
      local ok, result = pcall(function()
        return exports[SharedConfig.FrameworkTrigger]:getSharedObject()
      end)

      if ok then
        ESX = result
      else
        Log('ERROR', 'Failed to resolve ESX185 export. Check FrameworkTrigger:', SharedConfig.FrameworkTrigger)
      end
    end
    return ESX
  end

  Log('ERROR', 'Wrong framework configured:', SharedConfig.Framework)
  return nil
end
