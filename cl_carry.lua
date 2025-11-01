-- CLIENT SIDE

local carry = {
	InProgress = false,
	targetSrc = -1,
	type = "",
	personCarrying = {
		animDict = "missfinale_c2mcs_1",
		anim = "fin_c2_mcs_1_camman",
		flag = 49,
	},
	personCarried = {
		animDict = "nm",
		anim = "firemans_carry",
		attachX = 0.27,
		attachY = 0.15,
		attachZ = 0.63,
		flag = 33,
	}
}

local function GetClosestPlayer(radius)
	local players = GetActivePlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)

	for _,playerId in ipairs(players) do
		local targetPed = GetPlayerPed(playerId)
		if targetPed ~= playerPed then
			local targetCoords = GetEntityCoords(targetPed)
			local distance = #(targetCoords-playerCoords)
			if closestDistance == -1 or closestDistance > distance then
				closestPlayer = playerId
				closestDistance = distance
			end
		end
	end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

local function ensureAnimDict(animDict)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Wait(0)
		end        
	end
	return animDict
end

local function isDead()
    return LocalPlayer.state.isDead or LocalPlayer.state.isIncapacitated
end

RegisterCommand("carry",function()
	if isDead() then
    	drawNativeNotification("~r~You can't use this while dead or unconscious!")
    	return
	end

	if not carry.InProgress then
		local closestPlayer = GetClosestPlayer(3)
		if closestPlayer then
			local targetSrc = GetPlayerServerId(closestPlayer)
			if targetSrc ~= -1 then
				TriggerServerEvent("CarryPeople:tryCarry", targetSrc)
			else
				lib.notify({title = "Carry", description = "There's no one around to charge!", type = "error"})
			end
		else
			lib.notify({title = "Carry", description = "There's no one around to charge!", type = "error"})
		end
	else
		carry.InProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		TriggerServerEvent("CarryPeople:stop", carry.targetSrc)
		carry.targetSrc = 0
	end
end,false)

RegisterCommand("tcarry", function()
	TriggerServerEvent("CarryPeople:toggleConsent")
end, false)

RegisterNetEvent("CarryPeople:startCarry", function(targetSrc)
	carry.InProgress = true
	carry.targetSrc = targetSrc
	carry.type = "carrying"
	ensureAnimDict(carry.personCarrying.animDict)
	TaskPlayAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, -1, carry.personCarrying.flag, 0, false, false, false)
end)

RegisterNetEvent("CarryPeople:syncTarget", function(targetSrc)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	if not DoesEntityExist(targetPed) or targetPed == 0 then return end

	carry.InProgress = true
	carry.targetSrc = targetSrc
	ensureAnimDict(carry.personCarried.animDict)
	TaskPlayAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, -1, carry.personCarried.flag, 0, false, false, false)
	Wait(300)
	if DoesEntityExist(targetPed) and DoesEntityExist(PlayerPedId()) then
		AttachEntityToEntity(PlayerPedId(), targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
	end
	carry.type = "beingcarried"
end)

RegisterNetEvent("CarryPeople:cl_stop", function()
	carry.InProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if carry.InProgress then
			if carry.type == "beingcarried" then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000, carry.personCarried.flag, 0, false, false, false)
				end
			elseif carry.type == "carrying" then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000, carry.personCarrying.flag, 0, false, false, false)
				end
			end
		end
		Wait(0)
	end
end)
