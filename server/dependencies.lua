---******************************************************
--- Local Variables                                   ***
---******************************************************

--- The Dependencies object
local dependencies = {
  {
    name = 'ox_lib',
    level = 'required',
    link = 'https://github.com/CommunityOx/ox_lib',
    versions = {
      min = '3.32.1',
      max = nil,
      exceptions = {},
    },
  },
  {
    name = 'oxmysql',
    level = 'required',
    link = 'https://github.com/CommunityOx/oxmysql',
    versions = {
      min = '2.12.3',
      max = nil,
      exceptions = {},
    },
  }
}

---******************************************************
--- Local Functions                                   ***
---******************************************************

--- Runs the dependency checks and prints the results to the console.
local function RunDependencyChecks()
  local results = {}
  local hasErrors = false
  local hasWarnings = false

  for _, dependency in ipairs(dependencies) do
    local result = {
      name = dependency.name,
      state = GetResourceState(dependency.name),
      version = nil,
      required = dependency.versions.min,
      status = 'OK',
      statusColor = '^2',
      icon = '✓',
      message = nil,
    }

    if result.state ~= 'started' then
      result.status = 'ERROR'
      result.statusColor = '^1'
      result.icon = '✗'
      result.message = 'Not started'
      hasErrors = true
    else
      result.version = GetResourceVersion(dependency.name)
      if result.version == nil then
        result.status = 'WARN'
        result.statusColor = '^3'
        result.icon = '⚠'
        result.message = 'Version unknown'
        hasWarnings = true
      else
        local minOk = IsVersionAtLeast(result.version, dependency.versions.min)
        local maxOk = dependency.versions.max == nil or IsVersionAtMost(result.version, dependency.versions.max)

        if not minOk then
          result.status = 'ERROR'
          result.statusColor = '^1'
          result.icon = '✗'
          result.message = 'Version too old'
          hasErrors = true
        elseif not maxOk then
          result.status = 'ERROR'
          result.statusColor = '^1'
          result.icon = '✗'
          result.message = 'Version too new'
          hasErrors = true
        end
      end
    end

    results[#results + 1] = result
  end

  local boxWidth = 100
  local line = string.rep('─', boxWidth)

  print('')
  print('^7┌' .. line .. '┐^7')
  print('^7│^5' .. string.rep(' ', 32) .. 'DEPENDENCY CHECK RESULTS' .. string.rep(' ', 44) .. '^7│^7')
  print('^7├' .. line .. '┤^7')
  print('^7│ Resource Name            │ Version    │ Required   │ Status      │ Info                            │^7')
  print('^7├' .. line .. '┤^7')

  for _, r in ipairs(results) do
    local nameCol = r.name .. string.rep(' ', math.max(0, 25 - r.name:len()))
    local versionCol = (r.version or 'N/A') .. string.rep(' ', math.max(0, 11 - (r.version or 'N/A'):len()))
    local requiredCol = r.required .. string.rep(' ', math.max(0, 11 - r.required:len()))

    local statusText = r.icon .. ' ' .. r.status
    local statusCol = r.statusColor .. statusText .. '^7' .. string.rep(' ', math.max(0, 12 - statusText:len()))

    local info = r.message or 'OK'
    local infoCol = info .. string.rep(' ', math.max(0, 28 - info:len()))

    print(string.format('^7│ %s │ %s │ %s │ %s │ %s  │^7', nameCol, versionCol, requiredCol, statusCol, infoCol))
  end

  print('^7└' .. line .. '┘^7')

  local errorCount = 0
  local warnCount = 0
  for _, r in ipairs(results) do
    if r.status == 'ERROR' then errorCount = errorCount + 1 end
    if r.status == 'WARN' then warnCount = warnCount + 1 end
  end
  local okCount = #results - errorCount - warnCount

  local summary = string.format(
    '^7Summary: ^2%d OK^7, ^3%d WARN^7, ^1%d ERROR^7',
    okCount,
    warnCount,
    errorCount
  )
  print(summary)

  if hasErrors then
    print('^1⚠ Some dependencies are missing or outdated.^7')
    print('')
    print('^7Please install/update the following resources:^7')
    for i, dep in ipairs(dependencies) do
      local r = results[i]
      if r.status == 'ERROR' then
        print(string.format('^7  • ^1%s^7: %s (required: ^3%s^7+) - ^6%s^7',
          dep.name,
          r.version or 'not found',
          dep.versions.min,
          dep.link
        ))
      end
    end
  elseif hasWarnings then
    print('^3⚠ Some dependency versions could not be verified.^7')
  else
    print('^2✓ All dependencies are satisfied!^7')
  end
  print('')
end

---******************************************************
--- Global Functions                                  ***
---******************************************************

---Checks if a dependency resource is available (started or starting)
---@param name string
---@return boolean
function IsDependencyAvailable(name)
  local state = GetResourceState(name)
  return state == 'started' or state == 'starting'
end

---Gets the dependency resource version
---@param name string
---@return string|nil
function GetDependencyResourceVersion(name)
  local version = GetResourceVersion(name)
  return version
end

---Checks whether actualVersion <= maximumVersion using SemVer-ish comparison.
---Returns nil if versions cannot be compared.
---@param actualVersion string
---@param minimumVersion string
---@return boolean|nil
function IsVersionAtLeast(actualVersion, minimumVersion)
  local compareResult = CompareSemverVersions(actualVersion, minimumVersion)
  if compareResult == nil then return nil end
  return compareResult >= 0
end

---Checks whether actualVersion <= maximumVersion using SemVer-ish comparison.
---Returns nil if versions cannot be compared.
---@param actualVersion string
---@param maximumVersion string
---@return boolean|nil
function IsVersionAtMost(actualVersion, maximumVersion)
  local compareResult = CompareSemverVersions(actualVersion, maximumVersion)
  if compareResult == nil then return nil end
  return compareResult <= 0
end

---******************************************************
--- Threads                                           ***
---******************************************************

CreateThread(function()
  Wait(1000)

  RunDependencyChecks()
end)
