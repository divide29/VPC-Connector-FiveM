-- DE: Hier kannst du jegliche Client-Funktionen finden die nicht Encrypted werden. Hier kannst du Anpassungen vornehmen. (Es werden mit der Zeit immer mehr und mehr Funktionen hinzugefügt.)
-- EN: Here you can find any client-functions that are not encrypted. You can make adjustments. (Over time, more and more functions will be added.)




-- DE: Funktion um die richtigen Framework Trigger zu bekommen
-- EN: Function to get the right framework trigger
function getframework()
    if Config.Framework == "ESX"  then
        ESX	= nil
        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent(Config.FrameworkTrigger, function(obj) ESX = obj end)
                Citizen.Wait(0)
            end
        
            Citizen.Wait(5000)
            PlayerData = ESX.GetPlayerData()
        end)
    elseif Config.Framework == "QB" then
        QBCore = exports['qb-core']:GetCoreObject()
        
    elseif Config.Framework == "ESX185" then
        ESX = exports[Config.FrameworkTrigger]:getSharedObject()
    else
        print("WRONG FRAMEWORK!!")
    
    end
end