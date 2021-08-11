local rentDistance = {}
local hasRented = false
local money = 0
local spawned = false

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local player = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(player)
        for i, v in pairs(cfg.locations) do
            if rentDistance[i] then
                if rentDistance[i] < 60 then
                    DrawMarker(36, v[1], v[2], v[3]-0.2, 0, 0, 0, 0, 0, 0, 1.6001, 1.6001, 1.6001, 255, 255, 255, 200, 0, 0, 0, 1, 0, 0, 0)
                    if rentDistance[i] < 4 then
                        DrawText3D(v[1], v[2], v[3]+0.6, cfg.lang.pressButton, 150)
                        if IsControlJustPressed(1, 51) then 
                            if hasRented == false then
                                TriggerEvent('rent-a-car:rent')
                            else 
                                Notify(cfg.lang.alreadyRented)
                            end
                        end
                    end
                end
            end
        end 
    end
end)

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs (cfg.locations) do
            x = v[1]
            y = v[2]
            z = v[3]
			distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, x, y, z)
			rentDistance[k] = distance
		end
		Citizen.Wait(1500)
	end
end)

RegisterNetEvent('rent-a-car:rentTimer')
AddEventHandler('rent-a-car:rentTimer', function()
    Wait(cfg.timeForRent)
    hasRented = false
    money = 0
    spawned = false
end)

RegisterNetEvent('rent-a-car:checkMoney')
AddEventHandler('rent-a-car:checkMoney', function(_money)
    money = _money
end)

RegisterNetEvent('rent-a-car:rent')
AddEventHandler('rent-a-car:rent', function()
  TriggerEvent('rent-a-car:showMenu', function(data)
    if data.carToSpawn ~= 'none' then
        TriggerServerEvent('rent-a-car:checkMoney')
        Wait(500)
        if money >= cfg.prices[data.carToSpawn].price then
            if spawned == false then
                spawned = true
                TriggerServerEvent('rent-a-car:spawnCar', data.carToSpawn)
                hasRented = true
                TriggerEvent('rent-a-car:rentTimer')
            end
        else
            Notify(cfg.lang.notEnoughMoney)
        end
    else
        Notify(cfg.lang.cancelled)
    end
  end)
end)

RegisterNetEvent('rent-a-car:showMenu')
AddEventHandler('rent-a-car:showMenu', function(cb)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'show'
    })
    RegisterNUICallback('exit', function(data)
        SetNuiFocus(false, false)
        cb(data)
    end)
end)

function DrawText3D(x,y,z, text, alpha)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(0.5, 0.5)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, alpha)
        SetTextDropshadow(0, 0, 0, 0, alpha)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        SetDrawOrigin(x,y,z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

RegisterNetEvent('rent-a-car:notify')
AddEventHandler('rent-a-car:notify', function(msg)
    Notify(msg)
end)

function Notify(msg) 
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(true, false)
end