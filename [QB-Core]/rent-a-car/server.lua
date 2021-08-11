RegisterNetEvent('rent-a-car:spawnCar')
AddEventHandler('rent-a-car:spawnCar', function(spawnName)
    local src = source
    local ped = GetPlayerPed(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local heading = GetEntityHeading(ped)
    local vehicle = CreateVehicle(GetHashKey(spawnName), x, y, z, heading, true, true)
    Player.Functions.RemoveMoney("cash", cfg.prices[spawnName].price, "Renting a car")
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
    local Player = QBCore.Functions.GetPlayer(source)
    local money = Player.Functions.GetMoney("cash")
    TriggerClientEvent('rent-a-car:checkMoney', source, money)
end)