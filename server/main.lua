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

-- ONLY EDIT IF YOU KNOW WHAT YOU ARE DOING!

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_dj_job:pay')
AddEventHandler('esx_dj_job:pay', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(tonumber(amount))
end)

RegisterNetEvent("dj:soundStatus")
AddEventHandler("dj:soundStatus", function(type, musicId, data)
    TriggerClientEvent("dj:soundStatus", -1, type, musicId, data)
end)
