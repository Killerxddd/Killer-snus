ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('Killer-snus:prepareActions')
AddEventHandler('Killer-snus:prepareActions', function(source)
	ESX.TriggerServerCallback('Killer-snus:getCooldown', function(cooldown)
		if cooldown == 0 then
			ESX.TriggerServerCallback('Killer-snus:setCooldown', function()
			end, 'snus-cooldown', Config.SnusCooldown)
			TriggerServerEvent("Killer-snus:removeSnusItem")
		
			local playerPed = GetPlayerPed(-1)
			local animDict = 'mp_suicide'
			local animName = 'pill_fp' 
			
			RequestAnimDict(animDict)
			TriggerServerEvent('3dme:shareDisplay', 'Stoppar in en prilla')
			
			while not HasAnimDictLoaded(animDict) do
				Citizen.Wait(10)
			end
			
			TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8.0, 2500, 2, 0, false, false, false)
			Citizen.Wait(1500)
		else
			ESX.ShowNotification('Du har redan en snus inne!, du kan stoppa in en ny om ' .. (math.floor(cooldown / 60) .. ' minuter...'))
		end
	end, 'snus-cooldown')
end)