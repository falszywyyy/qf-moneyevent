local PlayerGrabbing, entity, taked = false, nil, false

local function MoneyEvent()
    while true do
        Citizen.Wait(0)

        Citizen.Wait(5 * 1000)
        TriggerClientEvent('qf-moneyevent:useScaleForm', -1, "~y~Stop, wait!~s~", "A new reward event will appear on the map in 30 minutes.", 2, 9)
        Citizen.Wait(15 * 60 * 1000)
        TriggerClientEvent('qf-moneyevent:useScaleForm', -1, "~y~Stop, wait!~s~", "A new reward event will appear on the map in 15 minutes.", 2, 9)
        Citizen.Wait(10 * 60 * 1000)
        TriggerClientEvent('qf-moneyevent:useScaleForm', -1, "~y~Stop, wait!~s~", "A new reward event will appear on the map in 5 minutes.", 2, 9)
        Citizen.Wait(2 * 60 * 1000)
        TriggerClientEvent('qf-moneyevent:useScaleForm', -1, "~y~Stop, wait!~s~", "A new reward event will appear on the map in 3 minutes.", 2, 9)
        Citizen.Wait(2 * 60 * 1000)
        TriggerClientEvent('qf-moneyevent:useScaleForm', -1, "~y~Stop, wait!~s~", "A new reward event will appear on the map in 1 minute.", 2, 9)
        Citizen.Wait(1 * 60 * 1000)
        TriggerClientEvent('qf-moneyevent:useScaleForm', -1, "~y~Stop, wait!~s~", "The reward event has started! Go to the location on the map!", 2, 9)
        
        if entity and DoesEntityExist(entity) then
            DeleteEntity(entity)
        end

        TriggerClientEvent('qf-moneyevent:pedRemoved', -1)
        Citizen.Wait(5000)

        local rand = math.random(1, #Config.Peds)
        local obj = Config.Peds[rand]

        TriggerClientEvent('qf-moneyevent:requestModel', -1, obj.ped)
        entity = CreatePed(28, GetHashKey(obj.ped), obj.coords.x, obj.coords.y, obj.coords.z, obj.coords.w, true, false)
        FreezeEntityPosition(entity, true)
        TriggerClientEvent('qf-moneyevent:pedSpawned', -1, obj, NetworkGetNetworkIdFromEntity(entity), false)
        PlayerGrabbing = false
    end
end

Citizen.CreateThread(MoneyEvent)

RegisterServerEvent('qf-moneyevent:reward', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local randomReward = math.random(1, 3)
    local money = 0
    
    if not Player(src).state.InMoneyEvent then
        return
    end

    if xPlayer and not PlayerGrabbing then
        if randomReward == 1 then
            money = 15000
        elseif randomReward == 2 then
            money = 25000
        elseif randomReward == 3 then
            money = 50000
        end

        taked = true
        xPlayer.addMoney(money)
        TriggerClientEvent('qf-moneyevent:useScaleForm', src, "~y~Congratulations!~s~", "You received a reward "..money.."$", 2, 9)
        PlayerGrabbing = true
        DeleteEntity(entity)
        Player(src).state.InMoneyEvent = false
    end

    TriggerClientEvent('qf-moneyevent:pedRemoved', -1, taked)
end)