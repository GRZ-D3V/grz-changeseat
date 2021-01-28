-- DESACTIVER LE CHANGEMENT DE PLACE AUTO
-- DISABLE CHANGE SEAT AUTOMATIC

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end



function isEligibleForSwitch() 
	local plyPed <const> = PlayerPedId()
	local plyVehicle <const> = GetVehiclePedIsIn(plyPed, false)
	if IsPedSittingInAnyVehicle(plyPed) and disableShuffle and AreAnyVehicleSeatsFree(plyVehicle) then
		CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 
		if CarSpeed < 60.0 then
			return true, plyVehicle, plyPed
		end
	end
return false
end
function GetPedSeatIndex(veh, ped) 
	local seats = GetVehicleModelNumberOfSeats(GetEntityModel(veh))
	for i = -1, seats do
		if tostring(GetPedInVehicleSeat(veh, i)) == tostring(ped) then
		return i
	end
	end
return -2
end
RegisterCommand("driverEnter", function(source, args) 
	local valid, veh, ped = isEligibleForSwitch()
	if valid and IsVehicleSeatFree(veh, -1) then
		SetPedIntoVehicle(ped, veh, -1)
	end
end)
RegisterCommand("fRightEnter", function(source, args) 
	local valid, veh, ped = isEligibleForSwitch()
	if valid and IsVehicleSeatFree(veh, 0) then
		SetPedIntoVehicle(ped, veh, 0)
	end
end)
RegisterCommand("bLeftEnter", function(source, args) 
	local valid, veh, ped = isEligibleForSwitch()
	if valid and IsVehicleSeatFree(veh, 1) then
		SetPedIntoVehicle(ped, veh, 1)
	end
end)
RegisterCommand("bRightEnter", function(source, args) 
	local valid, veh, ped = isEligibleForSwitch()
	if valid and IsVehicleSeatFree(veh, 2) then
		SetPedIntoVehicle(ped, veh, 2)
	end
end)
local moveToNext = function(source, args, rawComm, index)
	local valid, veh, ped = isEligibleForSwitch()
	local seats = GetVehicleModelNumberOfSeats(GetEntityModel(veh))
	local seatIndex = index or GetPedSeatIndex(veh, ped) + 1
	if valid then
	 if IsVehicleSeatFree(veh, seatIndex) then
		SetPedIntoVehicle(ped, veh, seatIndex)
	end
else
	print("Invalid seat, recursing function")
		moveToNext(nil, nil, nil, seatIndex + 1)
	end

end

local moveToPrev = function(source, args, rawComm, index)
	local valid, veh, ped = isEligibleForSwitch()
	local seats = GetVehicleModelNumberOfSeats(GetEntityModel(veh))
	local seatIndex = index or GetPedSeatIndex(veh, ped) - 1
	if valid then
	 if IsVehicleSeatFree(veh, seatIndex) then
		SetPedIntoVehicle(ped, veh, seatIndex)
	end
else
	print("Invalid seat, recursing function")
		moveToNext(nil, nil, nil, seatIndex - 1)
	end

end
RegisterCommand("moveToNext", moveToNext)
RegisterCommand("moveToPrev", moveToPrev)
--Keymaps
RegisterKeyMapping("enterVehicle", "Enter vehicle", "keyboard", "F")
RegisterKeyMapping("driverEnter", "Enter front left seat", "keyboard", "1")
RegisterKeyMapping("fRightEnter", "Enter front right seat", "keyboard", "2")
RegisterKeyMapping("bLeftEnter", "Enter back left seat", "keyboard", "3")
RegisterKeyMapping("bRightEnter", "Enter back right seat", "keyboard", "4")
RegisterKeyMapping("moveToNext", "Move to the next seat", "keyboard", "RIGHT")
RegisterKeyMapping("moveToPrev", "Move to the next seat", "keyboard", "LEFT")

-- By GRZ & WowJesus