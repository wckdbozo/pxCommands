RegisterNetEvent('pxc:proximity')
AddEventHandler('pxc:proximity', function(source, range, payload)
    local src = source
    local ply = GetPlayerFromServerId(src)
    local ped = GetPlayerPed(ply)
    local ppos = GetEntityCoords(ped)
    for _, id in ipairs(GetActivePlayers()) do
        local tgt = GetPlayerPed(id)
        local tpos = GetEntityCoords(tgt)
        if #(ppos - tpos) <= range then
            TriggerEvent('chat:addMessage', payload)
        end
    end
end)
