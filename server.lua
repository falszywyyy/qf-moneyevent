local peds = {
    {
        coords = vec4(-1160.5491, -228.9025, 37.9388, 316.2390),
        ped = 'a_f_m_soucentmc_01'
    },
    {
        coords = vec4(-1195.3673095703, -1577.2663574219, 4.6064839363098, 117.39),
        ped = 'a_f_m_soucentmc_01'
    },
    {
        coords = vec4(-1183.1405029297, -884.00524902344, 13.750907897949, 309.38),
        ped = 'a_f_m_soucentmc_01'
    },
    {
        coords = vec4(620.505859375, -645.44586181641, 14.00341129303, 87.95),
        ped = 'a_f_m_soucentmc_01'
    },
    {
        coords = vec4(208.02380371094, -921.91955566406, 30.691987991333, 148.2),
        ped = 'a_f_m_soucentmc_01'
    },
    {
        coords = vec4(83.554443359375, -1401.5601806641, 29.420972824097, 299.25),
        ped = 'a_f_m_soucentmc_01'
    },
    {
        coords = vec4(171.19033813477, -1224.3941650391, 29.524499893188, 90.03),
        ped = 'a_f_m_soucentmc_01'
    },
    {
        coords = vec4(-1696.3597412109, -399.95391845703, 46.69270324707, 95.86),
        ped = 'a_f_m_soucentmc_01'
    },
    {
        coords = vec4(-852.61553955078, -122.43365478516, 37.713958740234, 122.17),
        ped = 'a_f_m_soucentmc_01'
    },
}

local PlayerGrabbing = false
local entity = nil
local taked = false

local function LocalEvent()
    while true do
        Citizen.Wait(0)

        Citizen.Wait(5 * 1000)
        TriggerClientEvent("qf-moneyevent", -1, "~y~Stop, wait!~s~", "A new reward event will appear on the map in 30 minutes.", 2, 9, true)
        Citizen.Wait(15 * 60 * 1000)
        TriggerClientEvent("qf-moneyevent", -1, "~y~Stop, wait!~s~", "A new reward event will appear on the map in 15 minutes.", 2, 9, true)
        Citizen.Wait(10 * 60 * 1000)
        TriggerClientEvent("qf-moneyevent", -1, "~y~Stop, wait!~s~", "A new reward event will appear on the map in 5 minutes.", 2, 9, true)
        Citizen.Wait(2 * 60 * 1000)
        TriggerClientEvent("qf-moneyevent", -1, "~y~Stop, wait!~s~", "A new reward event will appear on the map in 3 minutes.", 2, 9, true)
        Citizen.Wait(2 * 60 * 1000)
        TriggerClientEvent("qf-moneyevent", -1, "~y~Stop, wait!~s~", "A new reward event will appear on the map in 1 minute.", 2, 9, true)
        Citizen.Wait(1 * 60 * 1000)
        TriggerClientEvent("qf-moneyevent", -1, "~y~Stop, wait!~s~", "The reward event has started! Go to the location on the map!", 2, 9, true)
        
        if entity and DoesEntityExist(entity) then
            DeleteEntity(entity)
        end

        TriggerClientEvent('qf-moneyevent:pedRemoved', -1)
        Citizen.Wait(5000)

        local rand = math.random(1, #peds)
        local obj = peds[rand]

        TriggerClientEvent('qf-moneyevent:requestModel', -1, obj.ped)
        entity = CreatePed(28, GetHashKey(obj.ped), obj.coords.x, obj.coords.y, obj.coords.z, obj.coords.w, true, false)
        FreezeEntityPosition(entity, true)
        TriggerClientEvent('qf-moneyevent:pedSpawned', -1, obj, NetworkGetNetworkIdFromEntity(entity), false)
        PlayerGrabbing = false
    end
end

Citizen.CreateThread(LocalEvent)

RegisterServerEvent('qf-moneyevent:reward', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local randomReward = math.random(1, 3)
    local money = 0
    
    if not Player(src).state.InLocalEvent then
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
        TriggerClientEvent("qf-moneyevent", src, "~y~Congratulations!~s~", "You received a reward "..money.."$", 2, 9, true)
        PlayerGrabbing = true
        DeleteEntity(entity)
        Player(src).state.InLocalEvent = false
    end

    TriggerClientEvent('qf-moneyevent:pedRemoved', -1, taked)
end)