-- SERVER SIDE

local QBCore = exports['qb-core']:GetCoreObject()
local carryEnabled = {}   
local carrying = {}
local carried = {}

RegisterNetEvent("CarryPeople:toggleConsent", function()
    local src = source
    carryEnabled[src] = not carryEnabled[src]

    if carryEnabled[src] then
        TriggerClientEvent('ox_lib:notify', src, {title = "Carry", description = "Now you ALLOW them to carry you.", type = "success"})
    else
        TriggerClientEvent('ox_lib:notify', src, {title = "Carry", description = "You NO longer allow them to carry you.", type = "error"})
    end
end)

RegisterNetEvent("CarryPeople:tryCarry", function(targetSrc)
    local src = source

    if not carryEnabled[targetSrc] then
        TriggerClientEvent('ox_lib:notify', src, {title = "Carry", description = "That person does not allow themselves to be carried.", type = "error"})
        return
    end

    carrying[src] = targetSrc
    carried[targetSrc] = src

    TriggerClientEvent("CarryPeople:startCarry", src, targetSrc)   
    TriggerClientEvent("CarryPeople:syncTarget", targetSrc, src)   
end)

RegisterNetEvent("CarryPeople:stop", function(targetSrc)
    local src = source

    if carrying[src] then
        TriggerClientEvent("CarryPeople:cl_stop", carrying[src])
        TriggerClientEvent("CarryPeople:cl_stop", src)
        carried[carrying[src]] = nil
        carrying[src] = nil
    elseif carried[src] then
        TriggerClientEvent("CarryPeople:cl_stop", carried[src])
        TriggerClientEvent("CarryPeople:cl_stop", src)
        carrying[carried[src]] = nil
        carried[src] = nil
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    if carrying[src] then
        TriggerClientEvent("CarryPeople:cl_stop", carrying[src])
        carried[carrying[src]] = nil
        carrying[src] = nil
    end
    if carried[src] then
        TriggerClientEvent("CarryPeople:cl_stop", carried[src])
        carrying[carried[src]] = nil
        carried[src] = nil
    end
    carryEnabled[src] = nil
end)
