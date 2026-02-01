---******************************************************
--- Local Variables                                   ***
---******************************************************

--- The Config object
local Config = require 'config.shared'

---******************************************************
--- Local Functions                                   ***
---******************************************************

--- Checks if a command value is disabled.
--- @param value string|nil
--- @return boolean
local function isDisabled(value)
  return value == nil or value == '' or value == 'nil'
end

---******************************************************
--- Commands                                          ***
---******************************************************

if not isDisabled(Config.OpenCommand) then
  lib.addCommand(Config.OpenCommand, {
    help = 'Open VPC-Tab'
  }, function(source)
    TriggerClientEvent('vpc_connector:command:opentab', source)
  end)
end

if not isDisabled(Config.OpenCopNetCommand) then
  lib.addCommand(Config.OpenCopNetCommand, {
    help = 'Open CopNET'
  }, function(source)
    TriggerClientEvent('vpc_connector:command:lookvehicle', source, 'cop')
  end)
end

if not isDisabled(Config.OpenCarNetCommand) then
  lib.addCommand(Config.OpenCarNetCommand, {
    help = 'Open CarNET'
  }, function(source)
    TriggerClientEvent('vpc_connector:command:lookvehicle', source, 'car')
  end)
end

if not isDisabled(Config.OpenMedicNetCommand) then
  lib.addCommand(Config.OpenMedicNetCommand, {
    help = 'Open MedicNET'
  }, function(source)
    TriggerClientEvent('vpc_connector:command:lookvehicle', source, 'medic')
  end)
end

if not isDisabled(Config.OpenFireNetCommand) then
  lib.addCommand(Config.OpenFireNetCommand, {
    help = 'Open FireNET'
  }, function(source)
    TriggerClientEvent('vpc_connector:command:lookvehicle', source, 'fire')
  end)
end

if not isDisabled(Config.CopyCoordsCommand) then
  lib.addCommand(Config.CopyCoordsCommand, {
    help = 'Copy current coords'
  }, function(source)
    TriggerClientEvent('vpc_connector:command:copycoords', source)
  end)
end

if not isDisabled(Config.IdentifierCommand) then
  lib.addCommand(Config.IdentifierCommand, {
    help = 'Copy identifier of target player',
    params = {
      {
        name = 'target',
        type = 'playerId',
        help = "Target player's server id"
      }
    }
  }, function(source, args)
    TriggerClientEvent('vpc_connector:command:identifier', source, args.target)
  end)
end
