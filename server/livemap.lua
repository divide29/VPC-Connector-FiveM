---******************************************************
--- Local Variables                                   ***
---******************************************************

--- The Config object
local Config = require 'config.shared'
if not Config.EnableLivemap then return end

---******************************************************
--- Threads                                           ***
--- ******************************************************

CreateThread(function()
  while true do
    MySQL.Async.execute("DELETE FROM vpcLS")
    Wait(900000) -- 15 minutes
  end
end)

---******************************************************
--- Event Handlers                                    ***
---******************************************************
RegisterServerEvent('vpc_connector:server:updateCoords', function(plID, coord, statusa, network)
  local coordx = coord.x
  local coordy = coord.y

  MySQL.Async.execute("UPDATE vpcLS SET coordsx = ?, coordsy = ?, NET = ? WHERE playerId = ?",
    { coordx, coordy, network, plID },
    function(rowsChanged)
      if rowsChanged == 0 then
        MySQL.Async.execute("INSERT INTO vpcLS (playerId, coordsx, coordsy, NET) VALUES (?, ?, ?, ?)",
          { plID, coordx, coordy, network })
      end
    end)
end)

RegisterServerEvent('vpc_connector:server:updateDuty', function(plID, statusa)
  MySQL.Async.execute("DELETE FROM vpcLS WHERE playerId = ?", { plID })
end)
