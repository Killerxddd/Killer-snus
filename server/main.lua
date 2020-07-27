ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('snustock', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local snushelvetetQuantity = xPlayer.getInventoryItem('snustock').count
    
    if snushelvetetQuantity > 0 then
        xPlayer.removeInventoryItem('snustock', 1)
		xPlayer.addInventoryItem('snusdosa', 10)
		
		TriggerClientEvent("pNotify:SendNotification", -1, {text = "Du öppnar en stock snus..", layout = "BottomCenter"})
    else
		TriggerClientEvent("pNotify:SendNotification", -1, {text = "Du har ingen snus stock?", layout = "BottomCenter"})
    end
end)

ESX.RegisterUsableItem('snusdosa', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local snushelvetetQuantity = xPlayer.getInventoryItem('snusdosa').count
    
    if snushelvetetQuantity > 0 then
        xPlayer.removeInventoryItem('snusdosa', 1)
		xPlayer.addInventoryItem('snus', 24)
		TriggerClientEvent("pNotify:SendNotification", -1, {text = "Du öppnar din snusdosa...", layout = "BottomCenter"})
    else
		TriggerClientEvent("pNotify:SendNotification", -1, {text = "Du har ingen snusdosa?", layout = "BottomCenter"})
    end
end)

ESX.RegisterUsableItem('snus', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local snushelvetetQuantity = xPlayer.getInventoryItem('snus').count
    
    if snushelvetetQuantity > 0 then
		TriggerClientEvent('Killer-snus:prepareActions', source)
    end
end)

ESX.RegisterServerCallback('Killer-snus:getCooldown', function(source, callback, id)
	local identifier = ESX.GetPlayerFromId(source).identifier
    MySQL.Async.fetchAll('SELECT * FROM snus_cooldown WHERE identifier=@identifier', {['@identifier'] = identifier}, function(fetched)
        local found = false
 
        for i=1, #fetched, 1 do
            local row = fetched[i]
 
            if row ~= nil then
                if row.id == id then
                    if ((row.timestamp + row.cooldown) - os.time()) < 0 then
                        MySQL.Async.execute('UPDATE snus_cooldown SET cooldown=0 WHERE id=@id and identifier=@identifier',
                            {
                                ["@id"] = id,
                                ["@identifier"] = identifier
                            }
                        )

                        callback(0)
                    else
                        callback((row.timestamp + row.cooldown) - os.time())
                    end
 
                    found = true
                end
            end
        end
 
        if found == false then 
            callback(0)
        end
    end)
end)

ESX.RegisterServerCallback('Killer-snus:setCooldown', function(source, callback, id, seconds)
	local identifier = ESX.GetPlayerFromId(source).identifier
    MySQL.Async.fetchAll('SELECT * FROM snus_cooldown WHERE identifier=@identifier', {['@identifier'] = identifier}, function(fetched)
        local found = false
 
        for i=1, #fetched, 1 do
            local row = fetched[i]
 
            if row ~= nil then
                if row.id == id then
                    found = true
                end
            end
        end
 
        if found == true then
            MySQL.Async.execute('UPDATE snus_cooldown SET cooldown=@cooldown, timestamp=@timestamp WHERE id=@id and identifier=@identifier',
                {
                    ["@id"] = id,
                    ["@cooldown"] = seconds,
                    ["identifier"] = identifier,
                    ["@timestamp"] = os.time()
                }
            )
        else
            MySQL.Async.execute('INSERT INTO snus_cooldown (id, cooldown, timestamp, identifier) VALUES (@id, @cooldown, @timestamp, @identifier)',
                {
                    ["@id"] = id,
                    ["@cooldown"] = seconds,
                    ["identifier"] = identifier,
                    ["@timestamp"] = os.time()
                }
            )
        end
    end)
 
    callback()
end)

RegisterServerEvent('Killer-snus:removeSnusItem')
AddEventHandler('Killer-snus:removeSnusItem', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('snus', 1)
end)
