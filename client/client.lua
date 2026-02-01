---******************************************************
--- Local Variables                                   ***
---******************************************************

--- The Config object
local Config = require 'config.shared'

local isTabletOpen = false
local playerJobName = nil
local playerNetSite = nil
local currentNetSite = nil
local playerLoadState = "NOTLOAD"
local activeJobName = nil
local tabletProp = nil

---******************************************************
--- Global Functions                                  ***
---******************************************************

function CopyToClipboard(text)
	SendNUIMessage({ type = 'clipboard', data = text })
end

function ShowHelpNotification(itext)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(itext)
	EndTextCommandDisplayHelp(0, false, true, -1)
end

function StartAnimation()
	local PlayerPed = PlayerPedId()
	if Config.Animation == true and not IsPedInAnyVehicle(PlayerPed, false) then
		RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")

		while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
			Citizen.Wait(1)
		end

		TaskPlayAnim(PlayerPed, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 50, 0, false, false,
			false)
		tabletProp = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
		AttachEntityToEntity(tabletProp, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.17, 0.10, -0.13, 20.0,
			180.0, 180.0, true, true, false, true, 1, true)
	end
end

function StopAnimation()
	local PlayerPed = PlayerPedId()
	if Config.Animation == true then
		ClearPedTasks(PlayerPed)
		if tabletProp ~= nil then
			DeleteObject(tabletProp)
			tabletProp = nil
		end
	end
end

function ShowTablet(NET, PID, BSite)
	local Netgiver = nil
	local Bseite = nil
	if BSite == "cop" then
		Bseite = "copnet"
	elseif BSite == "medic" then
		Bseite = "medicnet"
	elseif BSite == "car" then
		Bseite = "carnet"
	elseif BSite == "fire" then
		Bseite = "firenet"
	end

	if isTabletOpen == false then
		if NET == "cop" then
			Netgiver = 'https://pc.copnet.li/'
		elseif NET == "medic" then
			Netgiver = 'https://pc.medicnet.li/'
		elseif NET == "car" then
			Netgiver = 'https://pc.carnet.li/'
		elseif NET == "fire" then
			Netgiver = 'https://pc.firenet.li/'
		elseif NET == "shop" then
			Netgiver = 'https://pc.carnet.li/shop.php?sp=' .. PID
		elseif NET == "bewerben" then
			Netgiver = 'https://pc.' .. Bseite .. '.li/bewerbung.php?sp=' .. PID
		elseif NET == "stgb" then
			Netgiver = 'https://pc.' .. Bseite .. '.li/strafgesetzbuch.php?sp=' .. PID
		end

		SetNuiFocus(true, true)
		SendNUIMessage({ type = "Enable", site = Netgiver })
		isTabletOpen = true
		StartAnimation()
	end
end

function ShowItem(NET)
	if Config.ItemTab ~= nil then
		local haveitem = lib.callback.await('vpc_connector:cb:hasItem', false, Config.ItemTab)
		if haveitem == true then
			ShowTablet(NET)
		end
	else
		ShowTablet(NET)
	end
end

function GetNetSiteCoo()
	return playerNetSite
end

local function CanOpenVpc()
	if Config.OpenVpcMode == 1 then
		return IsPedInAnyVehicle(PlayerPedId(), false)
	end
	if Config.OpenVpcMode == 2 then
		return GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) == 18
	end
	return true
end

---******************************************************
--- Network Events                                    ***
---******************************************************

RegisterNetEvent('vpc_connector:command:opentab', function()
	TriggerEvent('vpc_connector:client:openTablet')
end)

RegisterNetEvent('vpc_connector:command:lookvehicle', function(net)
	TriggerEvent('vpc_connector:client:lookVehicle', net)
end)

RegisterNetEvent('vpc_connector:command:copycoords', function()
	local playerPed = PlayerPedId()
	local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
	local betterZ = playerZ - 1.5
	CopyToClipboard("vector3(" .. playerX .. ", " .. playerY .. ", " .. betterZ .. "),")
end)

RegisterNetEvent('vpc_connector:command:identifier', function(target)
	local identifier = lib.callback.await('vpc_connector:cb:getLicense', false, target)
	if identifier ~= nil then
		CopyToClipboard(identifier)
	end
end)


RegisterPlayerLoadedHandler(function()
	playerLoadState = "Geladen"
	--https://www.youtube.com/watch?v=y6NSdGL8czw
end)


AddEventHandler('onResourceStart', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		EnsureFramework()
		playerLoadState = "Geladen"
	end
end)


CreateThread(function()
	while playerLoadState == 'NOTLOAD' do
		Wait(0)
	end

	EnsureFramework()

	activeJobName = lib.callback.await('vpc_connector:cb:getJobName', false)
	playerJobName = activeJobName

	currentNetSite = lib.callback.await('vpc_connector:cb:getJob', false)
	playerNetSite = currentNetSite
end)

--Job update on new Job (set from ESX or QB-Core Framework)
RegisterJobUpdateHandler(function(job)
	if type(job) ~= 'table' then
		return
	end

	activeJobName = job.name
	playerJobName = job.name

	local net = GetNetForJob(job.name, GetJobGrade(job))
	if net == nil then
		net = "noNET"
	end
	currentNetSite = net
	playerNetSite = net
end)

-- Commands are registered server-side via ox_lib

--Function for qb-target whitch allow to open Shops etc.
RegisterNetEvent('vpc_connector:client:openTablet:target', function(data)
	local net = data.net
	local pid = data.pid
	local showType = data.showType

	if pid == nil then
		if showType == "pc" then
			ShowTablet(net)
		end
	else
		ShowTablet(showType, pid, net)
	end
end)


--Create Normal Zones with Nativelements
if Config.ActivateZones then
	CreateThread(function()
		while playerLoadState == "NOTLOAD" do
			Wait(0)
		end

		while true do
			Wait(0)
			if isTabletOpen == false then
				for k, v in ipairs(Config.Zones) do
					if v.Type == "pc" then
						if playerJobName == v.NeedJob then
							local playerPed = PlayerPedId()
							local playerCoords = GetEntityCoords(playerPed)
							local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, v.Coords.x, v.Coords.y, v.Coords.z)

							if distance <= v.Radius then
								DrawMarker(v.Marker.type, v.Coords.x, v.Coords.y, v.Coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x,
									v.Marker.y, v.Marker.z,
									v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, "", "", false)
								ShowHelpNotification(v.Info)

								if IsControlJustReleased(0, 38) then
									ShowTablet(v.VPCNET)
								end
							end
						end
					elseif v.Type == "shop" then
						local playerPed = PlayerPedId()
						local playerCoords = GetEntityCoords(playerPed)
						local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, v.Coords.x, v.Coords.y, v.Coords.z)
						if distance <= v.Radius then
							DrawMarker(v.Marker.type, v.Coords.x, v.Coords.y, v.Coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x,
								v.Marker.y, v.Marker.z,
								v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, "", "", false)
							ShowHelpNotification(v.Info)

							if IsControlJustReleased(0, 38) then
								ShowTablet("shop", v.PublicID)
							end
						end
					elseif v.Type == "bewerben" then
						local playerPed = PlayerPedId()
						local playerCoords = GetEntityCoords(playerPed)
						local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, v.Coords.x, v.Coords.y, v.Coords.z)
						if distance <= v.Radius then
							DrawMarker(v.Marker.type, v.Coords.x, v.Coords.y, v.Coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x,
								v.Marker.y, v.Marker.z,
								v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, "", "", false)
							ShowHelpNotification(v.Info)

							if IsControlJustReleased(0, 38) then
								ShowTablet("bewerben", v.PublicID, v.VPCNET)
							end
						end
					elseif v.Type == "stgb" then
						local playerPed = PlayerPedId()
						local playerCoords = GetEntityCoords(playerPed)
						local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, v.Coords.x, v.Coords.y, v.Coords.z)
						if distance <= v.Radius then
							DrawMarker(v.Marker.type, v.Coords.x, v.Coords.y, v.Coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x,
								v.Marker.y, v.Marker.z,
								v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, "", "", false)
							ShowHelpNotification(v.Info)

							if IsControlJustReleased(0, 38) then
								ShowTablet("stgb", v.PublicID, v.VPCNET)
							end
						end
					end
				end
			end
		end
	end)
end


RegisterNetEvent('vpc_connector:client:openTablet', function()
	if currentNetSite == "cop" or currentNetSite == "medic" or currentNetSite == "car" or currentNetSite == "fire" then
		TriggerEvent('vpc_connector:client:lookVehicle', currentNetSite)
	else
		print("Error 2811")
	end
end)


--Function that checks if people are in Vehicles or Emergency Vehicles
RegisterNetEvent('vpc_connector:client:lookVehicle', function(NET)
	if CanOpenVpc() then
		ShowItem(NET)
	end
end)


--Funtion to open Tab from other Scripts
RegisterNetEvent('vpc_connector:client:openTabletFromOtherScripts', function(NET)
	if CanOpenVpc() then
		ShowTablet(NET)
	end
end)

---@deprecated Use 'vpc_connector:client:openTabletFromOtherScripts' instead.
RegisterNetEvent('vpc_connector:BOSS', function(NET)
	if CanOpenVpc() then
		ShowTablet(NET)
	end
end)


--Fuction to close the Tab
RegisterNUICallback('NUIFocusOff', function()
	if isTabletOpen == true then
		SetNuiFocus(false, false)
		SendNUIMessage({ type = "disable" })
		isTabletOpen = false
		StopAnimation()
	end
end)

--Vehicle Sync Integration
RegisterNetEvent('vpc:getVehicleData')
AddEventHandler('vpc:getVehicleData', function(hash, plate)
	local updatestring = GetDisplayNameFromVehicleModel(hash)

	TriggerServerEvent('vpc:setVehicleData', updatestring, plate)
end)

CreateThread(function()
	if Config.VehicleName == true then
		while true do
			while playerLoadState == "NOTLOAD" do
				Wait(0)
			end
			TriggerServerEvent('vpc:syncVehicleData', GetPlayerServerId(PlayerId()))

			Wait(600000) -- 10 minutes
		end
	end
end)
