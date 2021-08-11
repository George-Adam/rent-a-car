local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","rent-a-car")

RegisterNetEvent('rent-a-car:spawnCar')
AddEventHandler('rent-a-car:spawnCar', function(spawnName)
    local src = source
    local ped = GetPlayerPed(src)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local heading = GetEntityHeading(ped)
    local vehicle = CreateVehicle(GetHashKey(spawnName), x, y, z, heading, true, true)
    local user_id = vRP.getUserId({source})
    local money = vRP.getMoney({user_id})
    vRP.setMoney({user_id, money - cfg.prices[spawnName].price})
    SetVehicleNumberPlateText(vehicle, "RENT " .. math.random(100,999))
    SetPedIntoVehicle(ped, vehicle, -1)
    TriggerClientEvent('rent-a-car:notify', src, cfg.lang.timeUntilDeletion .. " " .. math.ceil(cfg.timeForRent/60/1000) .. " " .. cfg.lang.minutes)
    SetTimeout(cfg.timeForRent, function()
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
            end
            TriggerClientEvent('rent-a-car:notify', src, cfg.lang.rentTimerDone)
        end
    end)
end)

RegisterNetEvent('rent-a-car:checkMoney')
AddEventHandler('rent-a-car:checkMoney', function()
    local money = vRP.getMoney({vRP.getUserId({source})})
    TriggerClientEvent('rent-a-car:checkMoney', source, money)
end)