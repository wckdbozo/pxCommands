local FloatingText = {}
local FloatingTextDuration = 5000
local FloatingTextSize = 1.0
local FloatingTextColor = {255, 255, 255, 255}
local FloatingTextFont = 4
local FloatingTextMaxDistance = 50.0

RegisterNetEvent("pxc:showFloatingText")
AddEventHandler("pxc:showFloatingText", function(target, text)
    if source ~= '' and tonumber(source) ~= nil then
        return
    end
    table.insert(FloatingText, {target = GetPlayerFromServerId(target), text = text, life = GetGameTimer() + FloatingTextDuration})
end)

local function DrawText3D(text, x, y, z)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, true)
    local s = FloatingTextSize
    local scale = ((1 / dist) * 2) * s
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    if onScreen then
        SetDrawOrigin(x, y, z, 0)
        SetTextScale(0.0 * scale, 1.1 * scale)
        SetTextFont(FloatingTextFont)
        SetTextProportional(true)
        SetTextColour(FloatingTextColor[1], FloatingTextColor[2], FloatingTextColor[3], FloatingTextColor[4])
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

Citizen.CreateThread(function()
    while true do
        if #FloatingText == 0 then
            Wait(500)
        else
            Wait(0)
            local now = GetGameTimer()
            local lpos = GetEntityCoords(PlayerPedId())
            for n = #FloatingText, 1, -1 do
                local text = FloatingText[n]
                if text.life < now then
                    table.remove(FloatingText, n)
                elseif NetworkIsPlayerActive(text.target) then
                    local ply = GetPlayerPed(text.target)
                    local pos = GetWorldPositionOfEntityBone(ply, GetEntityBoneIndexByName(ply, "head"))
                    if #(lpos - pos) <= FloatingTextMaxDistance then
                        DrawText3D(text.text, pos.x, pos.y, pos.z + 0.2)
                    end
                end
            end
        end
    end
end)
