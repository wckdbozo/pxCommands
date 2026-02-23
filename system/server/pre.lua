function log(text)
    if Config and Config.Logging then
        print("[pxCommands] " .. text)
    end
end

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            if type(orig_value) == 'table' then
                copy[orig_key] = shallowcopy(orig_value)
            else
                copy[orig_key] = orig_value
            end
        end
    else
        copy = orig
    end
    return copy
end

ESX = nil
QBCore = nil

if Config.Framework == 'esx' then
    log('Enabling ESX compatibility')
    local ok = pcall(function()
        ESX = exports['es_extended']:getSharedObject()
    end)
    if not ok or not ESX then
        AddEventHandler('esx:getSharedObject', function(obj) ESX = obj end)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
    log('ESX enabled')
elseif Config.Framework == 'qbcore' or Config.Framework == 'qbox' then
    log('Enabling QBCore compatibility')
    if exports and exports['qb-core'] then
        QBCore = exports['qb-core']:GetCoreObject()
        log('QBCore enabled')
    else
        log('QBCore export not found')
    end
end

COMMANDS = {}

local function AddCommand(command)
    if not command.command then return "Missing command parameter" end
    if not command.format and not command.reply then return "Missing format parameter" end
    table.insert(COMMANDS, command)
    return nil
end

local function AddAlias(alias, commandName)
    for _, command in next, COMMANDS do
        if command.command == commandName then
            local aliasCommand = shallowcopy(command)
            aliasCommand.command = alias
            table.insert(COMMANDS, aliasCommand)
            return true
        end
    end
    return false
end

function AddCommandAlias(alias, commandName)
    return AddAlias(alias, commandName)
end

function CommandPack(packName, packAuthor, commands, defaults, aliases)
    for _, command in next, commands do
        command.author = packAuthor
        command.pack = packName
        if defaults then
            for default, value in next, defaults do
                if command[default] == nil then
                    command[default] = value
                end
            end
        end
        local result = AddCommand(command)
        if result then
            log(("Could not add /%s: %s"):format(command.command, result))
        end
    end
    if aliases then
        for _, alias in next, aliases do
            if alias[1] and alias[2] then
                AddAlias(alias[1], alias[2])
            end
        end
    end
end

log('Starting pxCommands load')
