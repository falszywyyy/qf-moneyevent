LocalPlayer.state:set('InLocalEvent', false, true)

local HasModelLoaded = HasModelLoaded
local RequestModel = RequestModel
local NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId
local SetEntityInvincible = SetEntityInvincible
local qtarget = exports.qtarget

RegisterNetEvent('qf-moneyevent:requestModel', function(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
    end
end)

local spawned, taked = false, nil

RegisterNetEvent('qf-moneyevent:pedRemoved', function(value)
    spawned = false
    taked = value
    LocalPlayer.state:set('InLocalEvent', false, true)
end)

local function LocalEvent(blip, obj, entity)
    local InHere = nil
    spawned = true

    SetBlipSprite (blip, 464)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 1.0)
    SetBlipColour (blip, 27)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("# Money Event")
    EndTextCommandSetBlipName(blip)

    while spawned do
        Citizen.Wait(1)
        local dist = #(GetEntityCoords(PlayerPedId()) - vec3(obj.coords.x, obj.coords.y, obj.coords.z))

        if dist < 50.0 then
            local ped = NetworkGetEntityFromNetworkId(entity)
            if ped then
                SetEntityInvincible(ped, true)
            end
            if dist < 1.5 then
                if not InHere then
                    InHere = true
                    qtarget:AddTargetEntity(ped, {
                        options = {
                            {
                                icon = 'fas fa-sack-dollar',
                                label = 'Claim reward',
                                action = function()
                                    qtarget:RemoveTargetEntity(ped, { 'Claim reward' })
                                    if spawned and not taked then
                                        LocalPlayer.state:set('InLocalEvent', true, true)
                                        TriggerServerEvent('qf-moneyevent:reward')
                                    end
                                end
                            }
                        },
                        distance = 2.0
                    })
                end
            elseif InHere then
                InHere = nil
                qtarget:RemoveTargetEntity(ped, { 'Claim reward' })
            end
        else
            Citizen.Wait(500)
        end
    end

    RemoveBlip(blip)
end

RegisterNetEvent('qf-moneyevent:pedSpawned', function(obj, entity, value)
    local blip = AddBlipForCoord(obj.coords.x, obj.coords.y, obj.coords.z)

    Citizen.CreateThread(function ()
        taked = value
        LocalEvent(blip, obj, entity)
    end)
end)

local function Request(scaleform)
    local scaleform_handle = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform_handle) do
        Citizen.Wait(0)
    end
    return scaleform_handle
end

local function CallFunction(scaleform, returndata, the_function, ...)
    BeginScaleformMovieMethod(scaleform, the_function)
    local args = {...}

    if args ~= nil then
        for i = 1,#args do
            local arg_type = type(args[i])

            if arg_type == "boolean" then
                ScaleformMovieMethodAddParamBool(args[i])
            elseif arg_type == "number" then
                if not string.find(args[i], '%.') then
                    ScaleformMovieMethodAddParamInt(args[i])
                else
                    ScaleformMovieMethodAddParamFloat(args[i])
                end
            elseif arg_type == "string" then
                ScaleformMovieMethodAddParamTextureNameString(args[i])
            end
        end

        if not returndata then
            EndScaleformMovieMethod()
        else
            return EndScaleformMovieMethodReturnValue()
        end
    end
end

local function showMidsizeBanner(_title, _subtitle, _bannerColor)
    local scaleform = Request('MIDSIZED_MESSAGE')

    CallFunction(scaleform, false, "SHOW_COND_SHARD_MESSAGE", _title, _subtitle, _bannerColor, true)

    return scaleform
end

RegisterNetEvent("qf-moneyevent")
AddEventHandler("qf-moneyevent", function(_title, subtitle, _bannerColor, _waitTime, _playSound)
    local showMidBanner = true
    local scale = 0

    if _playSound ~= nil and _playSound == true then
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end

    scale = showMidsizeBanner(_title, subtitle, _bannerColor)

    Citizen.CreateThread(function()
        Citizen.Wait((_waitTime * 1000) - 1000)
        CallFunction(scale, false, "SHARD_ANIM_OUT", 2, 0.3, true)
        Citizen.Wait(1000)
        showMidBanner = false
    end)

    Citizen.CreateThread(function()
        while showMidBanner do
            Citizen.Wait(1)
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end)