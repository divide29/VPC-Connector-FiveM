---******************************************************
--- Local Variables                                   ***
---******************************************************

--- The Config object
local Config = require 'config.shared'

--- Is the sync active?
local syncactive = false

EnsureFramework()

---******************************************************
--- Callbacks                                         ***
---******************************************************

lib.callback.register('vpc_connector:cb:getJob', function(source)
  local player = GetPlayer(source)
  if player == nil then
    return "noNET"
  end

  local net = GetNetForJob(GetPlayerJobName(player), GetPlayerJobGrade(player))
  if net == nil then
    return "noNET"
  end

  return net
end)

lib.callback.register('vpc_connector:cb:getJobName', function(source)
  local player = GetPlayer(source)
  if player == nil then return nil end
  return GetPlayerJobName(player)
end)

lib.callback.register('vpc_connector:cb:hasItem', function(source, itemName)
  return PlayerHasItem(source, itemName)
end)

lib.callback.register('vpc_connector:cb:getLicense', function(source, target)
  local targetId = target or source
  return GetIdentifierByPrefix(targetId, Config.PlayerIdentifier)
end)

if Config.UseableItem ~= nil then
  for k, v in pairs(Config.UseableItem) do
    RegisterUseableItem(v, function(source)
      local player = GetPlayer(source)
      if player == nil then return end

      local net = GetNetForJob(GetPlayerJobName(player), GetPlayerJobGrade(player))
      if net ~= nil then
        TriggerClientEvent('vpc_connector:BOSS', source, net)
      end
    end)
  end
end


if Config.VehicleName == true then
  Citizen.CreateThread(function()
    RegisterServerEvent('vpc:syncVehicleData')
    AddEventHandler('vpc:syncVehicleData', function(source)
      if syncactive == false then
        syncactive = true

        MySQL.Async.fetchAll("SELECT plate, vehicle, vpcname FROM " .. Config.VehicleDB .. " WHERE vpcname IS NULL",
          function(result)
            dati = result
          end)

        while dati == nil do Citizen.Wait(0) end

        for k, v in pairs(dati) do
          hash = json.decode(v.vehicle).model
          TriggerClientEvent('vpc:getVehicleData', source, hash, json.decode(v.vehicle).plate)
          Citizen.Wait(10)
        end

        Citizen.Wait(600000)
        syncactive = false
      end
    end)
  end)


  RegisterServerEvent('vpc:setVehicleData')
  AddEventHandler('vpc:setVehicleData', function(updatevehicledata, plate)
    MySQL.Async.execute("UPDATE owned_vehicles SET vpcname = ? WHERE plate = ?", { updatevehicledata, plate })
  end)
end
