local Config = {}

Config.Framework =
'AUTO'                                  -- Available: 'AUTO', 'ESX', 'ESX185' for ESX 1.8.5 and higher, 'QB' for QBCore.
Config.FrameworkTrigger = 'es_extended' -- Set the framework resource name for ESX 1.8.5 and higher.

Config.VehicleName = false              -- Activate the vehicle name sync feature.
Config.VehicleDB = 'owned_vehicles'     -- Insert your owned vehicles table name here. Only if Config.VehicleName = true.


Config.Jobs = {
    copnet = {
        ['police'] = 0, -- 'jobName' = min. Rank
    },
    medicnet = {
        ['ambulance'] = 0,
    },
    carnet = {
        ['car'] = 0,
    },
    firenet = {
        ['fire'] = 0,
    },
}

Config.Animation = true        -- Should the character take a tablet in hand when opening the VPC?

Config.ItemTab = 'tab'         -- Name of the item required to open the VPC. If not required, set to nil.
Config.UseableItem = { 'tab' } -- Which items should be useable to open the VPC. If not required, set to nil.

Config.EnableLivemap = false   -- Should the livemap be active?
Config.LivemapItem = 'gps'     -- Name of the item required to be shown on the livemap. If not required, set to nil.

Config.PlayerIdentifier =
'license:'                              -- Please be aware that this identifier should be the one set in VPC. (https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/GetPlayerIdentifiers/)
Config.OpenVpcMode = 0                  -- Available: 0 = anywhere, 1 = only in vehicles, 2 = only in emergency vehicles.

Config.OpenTabHotkey = 'Q'              --- To disable the keybind set to nil or 'nil'

Config.OpenCommand = 'vpc'              --- To disable the command set to nil.
Config.OpenCopNetCommand = 'copnet'     --- To disable the command set to nil.
Config.OpenCarNetCommand = 'carnet'     --- To disable the command set to nil.
Config.OpenMedicNetCommand = 'medicnet' --- To disable the command set to nil.
Config.OpenFireNetCommand = 'firenet'   --- To disable the command set to nil.
Config.CopyCoordsCommand = 'vpccoords'  --- To disable the command set to nil.
Config.IdentifierCommand = 'vpcid'      --- To disable the command set to nil.

--[[
    Soll die qb-target integration aktiviert werden?
    Die einrichtung der Punkte erfolgt mittels der target.lua Datei in deinem shared Ordner.
    NUR bei verwendung von QB-Core in verbindung mit qb-target
]]
Config.ActivateQbTarget = false

--[[
   Sollen die normalen Zones aktiviert werden?
   Wenn du qb-target nutzt, sollte dies deaktivert werden.
   Die Zonen richtest du ab Zeile 214 ein.
]]
Config.ActivateZones = false

--[[
    Zum einrichten normaler Zonen befolge die anweisungen weiter unten.
]]
Config.Zones = {

    {
        Coords = vector3(189.17802429199, -854.22857666016, 30.370969772339),
        Info = 'Drücke E um den PC zu nutzen.',
        Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
        -- cop, medic, fire oder car
        VPCNET = 'copnet',
        -- pc , bewerben oder shop
        Type = 'pc',
        -- Job der benötigt wird um den PC zu nutzen
        NeedJob = 'police',
        -- Im Folgenden Radius soll der PC nutzbar sein
        Radius = 4
    },


    {
        Coords = vector3(427.29, -597.218, 43.2821),
        Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
        Info = 'Drücke E um den PC zu nutzen.',
        VPCNET = 'medicnet',
        Type = 'pc',
        NeedJob = 'ambulance',
        Radius = 4
    },

    --[[ Besp. Für einen CarNet - Shop
    {
        Coords = vector3(312.9, -1447, 29.69),
        Info = 'Drücke E um den Shop zu nutzen.',
        Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
        Type = 'shop',
        Radius = 4,
        PublicID = '' -- <--Deine PublicID vom Shop hier einfügen
    },

    ]]


    --[[  Beispiel für ein Bewerbungsformular
    {
        Coords = vector3(427.5, -985.6, 30.71),
        Info = 'Drücke E um das Bewerbungsformular zu nutzen.',
        Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
        VPCNET = 'copnet',
        Type = 'bewerben',
        Radius = 4,
        PublicID = '' -- <--Deine PublicID vom PC hier einfügen
    },

    ]]

    --[[  Beispiel für einen Punkt für das Strafgesetzbuch
    {
        Coords = vector3(427.29, -597.218, 28.6),
        Info = 'Drücke E um in das Strafgesetzbuch zu schauen.',
        Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
        VPCNET = 'copnet',
        Type = 'stgb',
        Radius = 4,
        PublicID = '' -- <--Deine PublicID vom PC hier einfügen
    },

    ]]
}

return Config
