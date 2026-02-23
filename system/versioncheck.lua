if Config and Config.CheckUpdates then
    log("Checking for updates...")
    Citizen.CreateThread(function()
        local owner = "CodeMeAPixel"
        local repo = "pxCommands"
        local resourceName = GetCurrentResourceName()
        
        local function parseVersion(versionStr)
            local parts = {}
            for part in versionStr:gmatch("(%d+)") do
                table.insert(parts, tonumber(part))
            end
            return parts
        end
        
        local function compareVersions(current, latest)
            local currentParts = parseVersion(current)
            local latestParts = parseVersion(latest)
            
            local maxLen = math.max(#currentParts, #latestParts)
            for i = 1, maxLen do
                currentParts[i] = currentParts[i] or 0
                latestParts[i] = latestParts[i] or 0
                
                if currentParts[i] < latestParts[i] then
                    return true
                elseif currentParts[i] > latestParts[i] then
                    return false
                end
            end
            
            return false
        end
        
        local function getLatestRelease(callback)
            PerformHttpRequest("https://api.github.com/repos/" .. owner .. "/" .. repo .. "/releases/latest", function(code, response, headers)
                if code == 200 then
                    local success, result = pcall(function()
                        local json = json.decode(response)
                        return json.tag_name:gsub("^v", "")
                    end)
                    if success and result then
                        callback(result)
                    else
                        callback(nil)
                    end
                else
                    callback(nil)
                end
            end, "GET")
        end
        
        getLatestRelease(function(latestVersion)
            local currentVersion = GetResourceMetadata(resourceName, "version", 0) or "0.1.0"
            
            if latestVersion and compareVersions(currentVersion, latestVersion) then
                log("Resource is outdated")
                log("Current: " .. currentVersion .. " | Latest: " .. latestVersion)
                log("Download from: https://github.com/" .. owner .. "/" .. repo .. "/releases")
            else
                log("Resource is up to date (" .. currentVersion .. ")")
            end
        end)
    end)
end

RegisterCommand(GetCurrentResourceName(), function(_, args)
    if args[1] == "autoupdate" then
        log("Checking for latest release...")
        local owner = "CodeMeAPixel"
        local repo = "pxCommands"
        local resourceName = GetCurrentResourceName()
        
        PerformHttpRequest("https://api.github.com/repos/" .. owner .. "/" .. repo .. "/releases/latest", function(code, response, headers)
            if code ~= 200 then
                log("Failed to fetch release info from GitHub")
                return
            end
            
            local success, releaseData = pcall(function()
                return json.decode(response)
            end)
            
            if not success or not releaseData then
                log("Failed to parse GitHub response")
                return
            end
            
            local currentVersion = GetResourceMetadata(resourceName, "version", 0) or "unknown"
            local latestVersion = releaseData.tag_name:gsub("^v", "") or "unknown"
            local downloadUrl = releaseData.zipball_url
            
            if not downloadUrl then
                log("No download URL found in release")
                return
            end
            
            log("Current version: " .. currentVersion .. " | Latest version: " .. latestVersion)
            log("Downloading release " .. latestVersion .. "...")
            PerformHttpRequest(downloadUrl, function(code, zipData, headers)
                if code ~= 200 then
                    log("Failed to download release: HTTP " .. code)
                    return
                end
                
                log("Downloaded release successfully")
                log("Please manually extract and restart: /restart " .. resourceName)
            end, "GET")
        end, "GET")
    else
        log("Usage: /" .. GetCurrentResourceName() .. " autoupdate")
        log("Note: Manual extraction required due to FiveM permissions")
    end
end, true)
