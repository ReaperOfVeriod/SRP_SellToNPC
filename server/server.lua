ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

itemprice = nil
itemamount = nil


function countPolice()
    local xPlayers = ESX.GetPlayers()
    copsConnected = 0
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
			copsConnected = copsConnected + 1
			TriggerClientEvent('copCheck', copsConnected)
        end
    end
	SetTimeout(30000, countPolice)
end
countPolice()


RegisterNetEvent('np_selltonpc:dodeal')
AddEventHandler('np_selltonpc:dodeal', function(drugtype)

	drugitemname = drugtype

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		-- Start with the most frequent drug.
		if drugtype == 'ogkush' then
			itemprice = Config.WeedPrice
			itemamount = Config.WeedAmount
		elseif drugtype == 'coke' then
			itemprice = Config.CokePrice
			itemamount = Config.CokeAmount
		elseif drugtype == 'meth' then
			itemprice = Config.MethPrice
			itemamount = Config.MethAmount
		elseif drugtype == 'crack' then
			itemprice = Config.OpiumPrice
			itemamount = Config.OpiumAmount
		end

            local inventoryamount = xPlayer.getInventoryItem(drugitemname).count

		if inventoryamount == 1 then
			itemamount = 1
		elseif inventoryamount == 2 then
			itemamount = 2
		elseif inventoryamount == 3 then
			itemamount = 3
		elseif inventoryamount == 4 then
			itemamount = 4
		elseif inventoryamount == 5 then
			itemamount = 5
		elseif inventoryamount == 6 then
			itemamount = 6
		end

		if inventoryamount >= itemamount then
			xPlayer.removeInventoryItem(drugitemname, itemamount)
			local moneyamount = itemamount * itemprice
			xPlayer.addAccountMoney('black_money', moneyamount)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold ' .. itemamount .. ' ' .. drugtype ..  ' for $' .. moneyamount, length = 5000 })
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You arent holding enough ' .. drugtype .. ' to sell.', length = 6000, })
		end
	end
end)

RegisterServerEvent('np_selltonpc:saleInProgress')
AddEventHandler('np_selltonpc:saleInProgress', function(streetName, playerGender)
	if playerGender == 0 then
		playerGender = 'Female'
	else
		playerGender = 'Male'
	end

	TriggerClientEvent('np_selltonpc:policeNotify')
end)

RegisterCommand('cornersell', function(source,args,raw)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		if Config.EnableWeed then
			local weed = xPlayer.getInventoryItem('ogkush').count
			if weed >= 1 then
				TriggerClientEvent("setDrugType", source, 'ogkush')
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You are now able to sell cannabis'})
				return
			end
		end

		if Config.EnableCoke then
			local coke = xPlayer.getInventoryItem('coke').count
			if coke >= 1 then
				print('coke')
				TriggerClientEvent("setDrugType", source, 'coke')
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You are now able to sell coke'})
				return
			end
		end

		if Config.EnableMeth then
			local meth = xPlayer.getInventoryItem('meth').count
			if meth >= 1 then
				TriggerClientEvent("setDrugType", source, 'meth')
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You are now able to sell meth'})
				return
			end
		end

		if Config.EnableOpium then
			local opium = xPlayer.getInventoryItem('crack').count
			if opium >= 1 then
				print('opium')
				TriggerClientEvent("setDrugType", source, 'crack')
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You are now able to sell crack'})
				return
			end
		end
		-- If they have nothing of the above, do this...
		TriggerClientEvent("setDrugType", source, false)
	end
end)