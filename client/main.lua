--
--	#     #
--	##    #  ######  #    #  ######   ####   #    #   ####
--	# #   #  #       ##  ##  #       #       #    #  #
--	#  #  #  #####   # ## #  #####    ####   #    #   ####
--	#   # #  #       #    #  #            #  #    #       #
--	#    ##  #       #    #  #       #    #  #    #  #    #
--	#     #  ######  #    #  ######   ####    ####    ####
--
-- Created by Nemesus for ESX Framework
-- Website: https://nemesus.de
-- Youtube: https://youtube.nemesus.de

-- Console / Delete if you want

print("^0======================================================================^7")
print("^0ESX_NJ_JOB loaded:")
print("^0[^4Author^0] ^7:^0 ^0Nemesus | Version 1.2^7")
print("^0[^2Website^0] ^7:^0 ^5https://nemesus.de^7")
print("^0[^2Youtube^0] ^7:^0 ^5https://youtube.nemesus.de^7")
print("^0======================================================================^7")

-- ONLY EDIT IF YOU KNOW WHAT YOU ARE DOING!

-- Local variables
ESX = nil
xSound = exports.xsound
local objectTableCreated = nil
local objectDJCreated = nil
local objectSpeaker1Created = nil
local objectSpeaker2Created = nil
local objectSpot1Created = nil
local objectSpot2Created = nil
local objectSpot3Created = nil
local PlayerData = {}
local isInService = false
local playerVolume = 20
local IsMenuOpen = false
local playAnimation = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

--Register Net Events
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	Citizen.Wait(1)
	PlayerData.job = job
end)

RegisterNetEvent("dj:soundStatus")
AddEventHandler("dj:soundStatus", function(type, musicId, data)
    if type == "position" then
        if xSound:soundExists(musicId) then
            xSound:Position(musicId, data.position)
	        xSound:Distance(musicId, Config.MusicRange)
        end
    end

    if type == "play" then
        xSound:PlayUrlPos(musicId, data.link, 0.4, data.position)
        xSound:Distance(musicId, Config.MusicRange)
    end

    if type == "stop" then
		if xSound:soundExists(musicId) then
	  		xSound:Destroy(musicId)
		end
    end
end)

-- Creating Stuff like Npcs
Citizen.CreateThread(function()
	Citizen.Wait(1)
	RequestModel( GetHashKey( "a_m_o_tramp_01" ) )
	while ( not HasModelLoaded( GetHashKey( "a_m_o_tramp_01" ) ) ) do
		Citizen.Wait(1)
	end
	local modelHash = GetHashKey("a_m_o_tramp_01")
	local created_ped = CreatePed(4,modelHash,-568.8,-864.12,26.33-1.0,28.05,true,true)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)

	Citizen.Wait(1)
	local infoblip = AddBlipForCoord(-568.8,-864.12,26.33)
      SetBlipSprite(infoblip, 136)
      SetBlipDisplay(infoblip, 4)
      SetBlipScale(infoblip, 0.9)
      SetBlipColour(infoblip, 69)
      SetBlipAsShortRange(infoblip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(_U('dj_bliptext'))
      EndTextCommandSetBlipName(infoblip)
end)

-- Commands
Citizen.CreateThread(function()
	Citizen.Wait(3)
	RegisterCommand("djset", function() 
		if not objectDJCreated then
			if isInService and IsPlayerDJ() then
				local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.85, -1.05)
				--Create Objects
				objectDJCreated = CreateObject(GetHashKey("prop_dj_deck_02"), x, y, z, true, true, true)
				objectTableCreated = CreateObject(GetHashKey("bkr_prop_weed_table_01b"), pos.x, pos.y, pos.z, true, true, true)
				objectSpeaker1Created = CreateObject(GetHashKey("prop_speaker_06"), pos.x, pos.y, pos.z, true, true, true)
				objectSpeaker2Created = CreateObject(GetHashKey("prop_speaker_06"), pos.x, pos.y, pos.z, true, true, true)
				objectSpot1Created = CreateObject(GetHashKey("v_club_roc_spot_g"), pos.x, pos.y, pos.z, true, true, true)
				objectSpot2Created = CreateObject(GetHashKey("v_club_roc_spot_r"), pos.x, pos.y, pos.z, true, true, true)
				objectSpot3Created = CreateObject(GetHashKey("v_club_roc_spot_b"), pos.x, pos.y, pos.z, true, true, true)
				-- Attach Objects
				AttachEntityToEntity(objectDJCreated, objectTableCreated, 0, -0.35, 0.1, 0.90, 0.0, 0.0, 0.0, 0, 0, 1, 0, 0, 1)
				AttachEntityToEntity(objectSpeaker1Created, objectTableCreated, 0, 0.80, -0.25, 1.09, 0.3, 0.0, 0.0, 0, 0, 1, 0, 0, 1)
				AttachEntityToEntity(objectSpeaker2Created, objectTableCreated, 0, -0.80, -0.25, 1.09, 0.3, 0.0, 0.0, 0, 0, 1, 0, 0, 1)
				AttachEntityToEntity(objectSpot1Created, objectTableCreated, 0, -0.80, -0.25, 0.82, 0.3, 0.0, 0.0, 0, 0, 1, 0, 0, 1)
				AttachEntityToEntity(objectSpot2Created, objectTableCreated, 0, 0.80, -0.25, 0.82, 0.3, 0.0, 0.0, 0, 0, 1, 0, 0, 1)
				AttachEntityToEntity(objectSpot3Created, objectTableCreated, 0, -0.045, -0.25, 0.82, 0.3, 0.0, 0.0, 0, 0, 1, 0, 0, 1)
				makeEntityFaceEntity(objectTableCreated, GetPlayerPed(-1))
				playerVolume = 20
				ESX.ShowNotification(_U('start_dj'))
			else
				ESX.ShowNotification(_U('no_dj'))
			end
		else
			DeleteObject(objectDJCreated);
			DeleteObject(objectTableCreated);
			DeleteObject(objectSpeaker1Created);
			DeleteObject(objectSpeaker2Created);
			DeleteObject(objectSpot1Created);
			DeleteObject(objectSpot2Created);
			DeleteObject(objectSpot3Created);
			objectDJCreated = nil
			objectTableCreated = nil
			ESX.ShowNotification(_U('stop_dj'))
		end
	end)

	Citizen.Wait(1)
	RegisterCommand("djmusic", function() 
		if isInService and IsPlayerDJ() and not IsMenuOpen then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			local pos2 = GetEntityCoords(objectDJCreated)
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z, true)
			if distance < 1.5 then
				OpenDJMenu()
			else
				ESX.ShowNotification(_U('pos_dj'))
			end
		else
			ESX.ShowNotification(_U('no_dj'))
		end
	end)
end)

-- Keys
Citizen.CreateThread(function()
	Citizen.Wait(5)
	while true do
		
		if objectTableCreated and IsControlJustReleased(0, 38) and not IsMenuOpen then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			local pos2 = GetEntityCoords(objectDJCreated)
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z, true)
			if distance < 1.5 then
				OpenDJMenu()
			end
		end
		if objectTableCreated and not IsMenuOpen then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			local pos2 = GetEntityCoords(objectDJCreated)
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z, true)
			if distance < 1.5 and not IsMenuOpen then
				ESX.ShowHelpNotification(_U('help_dj2'))
			end
		end
		if not IsMenuOpen then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, -568.8,-864.12,26.33, true)
			if distance < 2.25 and IsPlayerDJ() then
				ESX.ShowHelpNotification(_U('djhelp'))
			end
		end
		if IsControlJustPressed(0, 23) and not IsMenuOpen then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, -568.8,-864.12,26.33, true)
			if distance < 2.25 and IsPlayerDJ() then
				if isInService then
					isInService = false
					if not objectTableCreated then
						ESX.ShowNotification(_U('duty_off'))
					end
				else
					isInService = true
					ESX.ShowNotification(_U('duty_on'))
				end
			end
	end
	Citizen.Wait(1)
	end
end)

-- Money
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(180000)
		if objectTableCreated and IsMenuOpen then
			local count = 0;
			for i,player in ipairs(GetActivePlayers()) do
				local ped = GetPlayerPed(player)
				local pos = GetEntityCoords(GetPlayerPed(-1))
				local pos2 = GetEntityCoords(GetPlayerPed(player))
				local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z, true)
				if distance < Config.MusicRange and ped ~= GetPlayerPed(-1) then
					count = count + 1
				end
			end
			if count > 0 then
				local salary = Config.Salary*count
				if(salary >= Config.HighestSalary) then
					salary = Config.HighestSalary
				end
				TriggerServerEvent('esx_dj_job:pay',salary)
				ESX.ShowNotification(_U('salara_dj')..salary.."$");
			else
				ESX.ShowNotification(_U('no_listeners'));
			end
		end
	end
end)

-- Functions
function OpenDJMenu()

	IsMenuOpen = true

	FreezeEntityPosition(GetPlayerPed(-1), true)

	local options = {
		{label = _U('play_music'), value = 'play_music'},
		{label = _U('stop_music'), value = 'stop_music'},
		{label = _U('play_animation'), value = 'play_animation'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dj_menu', {
		title = _U('menu_dj'),
		align = "top-left",
		elements = options
	}, function (data, menu)
		if data.current.value == 'play_music' then
			menu.close()
			OpenInputMenu()
		end
		if data.current.value == 'stop_music' then
			TriggerServerEvent("dj:soundStatus", "stop", "sound_dj_"..PlayerPedId(), { position = pos, link = "" })
			ESX.ShowNotification(_U('music_stopping'))
		end
		if data.current.value == 'play_animation' then
			if not playAnimation then
				startAnim("anim@mp_player_intcelebrationmale@dj","dj")
				ESX.ShowNotification(_U('animation_start'))
				playAnimation = true
			else
				ClearPedTasks(PlayerPedId())
				StopAnimTask(PlayerPedId(), 'anim@mp_player_intcelebrationmale@dj', 'dj_facial', 1.0)
				ESX.ShowNotification(_U('animation_stop'))
				playAnimation = false
			end
		end

	end,
	function(data, menu)
		menu.close();
		IsMenuOpen = false
		playAnimation = false
		TriggerServerEvent("dj:soundStatus", "stop", "sound_dj_"..PlayerPedId(), { position = pos, link = "" })
		FreezeEntityPosition(GetPlayerPed(-1), false)
		ClearPedTasks(PlayerPedId())
		StopAnimTask(PlayerPedId(), 'anim@mp_player_intcelebrationmale@dj', 'dj_facial', 1.0)
	end)
end

function OpenInputMenu()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dj_menu', {
		title = _U('music_title')
	}, function (data, menu)
			OpenDJMenu()
			local pos = GetEntityCoords(GetPlayerPed(-1))
			TriggerServerEvent("dj:soundStatus", "play", "sound_dj_"..PlayerPedId(), { position = pos, link = data.value })
			ESX.ShowNotification(_U('music_playing'))
	end,
	function(data, menu)
		OpenDJMenu()
	end)
end

function makeEntityFaceEntity(entity1,entity2 )
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(GetPlayerPed(-1), lib, anim, -1, -1, -1, 49, 0, false, false, false)
		RemoveAnimDict(lib)
	end)
end

function IsPlayerDJ()
	if PlayerData ~= nil then
		local isDJ = false
		if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == 'dj' then
			isDJ = true
		end
		return isDJ
	end
	Citizen.Wait(1)
end

