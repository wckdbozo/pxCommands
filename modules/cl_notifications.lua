local typePrefix = {
    success = "~g~",
    error   = "~r~",
    warning = "~y~",
    info    = "~b~",
}

local function showNotification(message, notifType)
    local prefix = typePrefix[notifType] or ""
    SetNotificationTextEntry("STRING")
    AddTextComponentString(prefix .. message)
    DrawNotification(false, true)
end

RegisterNetEvent("pxc:notify")
AddEventHandler("pxc:notify", function(message, notifType)
    if source ~= "" and tonumber(source) ~= nil then return end
    showNotification(message, notifType or "info")
end)

AddEventHandler("pxc:notifyLocal", function(message, notifType)
    showNotification(message, notifType or "info")
end)
