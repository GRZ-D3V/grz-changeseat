-- DESACTIVER LE CHANGEMENT DE PLACE AUTO
-- DISABLE CHANGE SEAT AUTOMATIC

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId() --one ped is enough my guy, no need to call it 4 million times
		Citizen.Wait(0)
		if IsPedInAnyVehicle(ped, false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
				if GetIsTaskActive(ped, 165) then
					SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
				end
			end
		end
	end
end)

-- SI LE JOUEUR MONTE À L'ARRIERE DU VEHICULE
-- IF PED GO BEHIND (SEATS)

local doors = {
	{"seat_dside_f", -1},
	{"seat_pside_f", 0},
	{"seat_dside_r", 1},
	{"seat_pside_r", 2}
}

function VehicleInFront(ped)
    local pos = GetEntityCoords(ped)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
    local _, _, _, _, result = GetRaycastResult(rayHandle)
	
    return result
end

Citizen.CreateThread(function()
	while true do
    	Citizen.Wait(0)
			
		local ped = PlayerPedId()
			
   		if IsControlJustReleased(0, 23) and running ~= true and GetVehiclePedIsIn(ped, false) == 0 then
      		local vehicle = VehicleInFront(ped)
				
      		running = true
				
      		if vehicle ~= nil then
				local plyCoords = GetEntityCoords(ped, false)
        		local doorDistances = {}
					
        		for k, door in ipairs(doors) do
          			local doorBone = GetEntityBoneIndexByName(vehicle, door[k])
          			local doorPos = GetWorldPositionOfEntityBone(vehicle, doorBone)
          			local distance = #(plyCoords-doorPos)
						
          			table.insert(doorDistances, distance)
        		end
					
        		local key, min = 1, doorDistances[1]
					
        		for k, v in ipairs(doorDistances) do
          			if doorDistances[k] < min then
           				key, min = k, v
          			end
        		end
					
        		TaskEnterVehicle(ped, vehicle, -1, doors[key][2], 1.5, 1, 0)
     		end
				
      		running = false
    	end
  	end
end)

-- KEYBIND CHANGEMENT PLACE VEHICLE
-- KEYBIND FOR CHANGESEAT
--[[
Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(plyPed) then
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
			CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h -- Get car speed
			if CarSpeed < 60.0 then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 60 km/h -- Can't change place when car is 60 km/h 
				if IsControlJustReleased(0, 157) then -- conducteur -- driver
					SetPedIntoVehicle(plyPed, plyVehicle, -1)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 158) then -- avant droit -- front right
					SetPedIntoVehicle(plyPed, plyVehicle, 0)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 160) then -- arriere gauche -- back left
					SetPedIntoVehicle(plyPed, plyVehicle, 1)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 164) then -- arriere gauche -- back left
					SetPedIntoVehicle(plyPed, plyVehicle, 2)
					Citizen.Wait(10)
				end
			end
		end
		Citizen.Wait(10) -- anti crash
	end
end)
]]

function isEligibleForSwitch() 
	local plyPed <const> = PlayerPedId()
	local plyVehicle <const> = GetVehiclePedIsIn(plyPed, false)
	if IsPedSittingInAnyVehicle(plyPed) then
		CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 
		if CarSpeed < 60.0 then
			return true, plyVehicle, plyPed
		end
	end
return false
end

RegisterCommand("driverEnter", function(source, args) 
	local valid, veh, ped = isEligibleForSwitch()
	if valid then
		SetPedIntoVehicle(ped, veh, -1)
	end
end)
RegisterCommand("fRightEnter", function(source, args) 
	local valid, veh, ped = isEligibleForSwitch()
	if valid then
		SetPedIntoVehicle(ped, veh, 0)
	end
end)
RegisterCommand("bLeftEnter", function(source, args) 
	local valid, veh, ped = isEligibleForSwitch()
	if valid then
		SetPedIntoVehicle(ped, veh, 1)
	end
end)
RegisterCommand("bRightEnter", function(source, args) 
	local valid, veh, ped = isEligibleForSwitch()
	if valid then
		SetPedIntoVehicle(ped, veh, 2)
	end
end)



RegisterKeyMapping("driverEnter", "Enter front left seat", "keyboard", "1")
RegisterKeyMapping("fRightEnter", "Enter front right seat", "keyboard", "2")
RegisterKeyMapping("bLeftEnter", "Enter back left seat", "keyboard", "3")
RegisterKeyMapping("bRightEnter", "Enter back right seat", "keyboard", "4")
-- By GRZ & WowJesus