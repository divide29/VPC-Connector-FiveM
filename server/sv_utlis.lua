-- DE: Hier kannst du jegliche Server-Funktionen finden die nicht Encrypted werden. Hier kannst du Anpassungen vornehmen. (Es werden mit der Zeit immer mehr und mehr Funktionen hinzugefügt.)
-- EN: Here you can find any server-functions that are not encrypted. You can make adjustments. (Over time, more and more functions will be added.)


-- DE: Funktion um die richtigen Framework Trigger zu bekommen
-- EN: Function to get the right framework trigger
function getframework()
    if Config.Framework == "QB" then
        QBCore = exports['qb-core']:GetCoreObject()
      end
      
      if Config.Framework == "ESX" then
        TriggerEvent(Config.FrameworkTrigger, function(obj) 
          ESX = obj
        end)
      end
      
      if Config.Framework == "ESX185" then
        ESX = exports[Config.FrameworkTrigger]:getSharedObject()
      end
end
