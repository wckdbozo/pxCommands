if Config and Config.CheckUpdates then
    log("Checking for updates...")
    Citizen.CreateThread(function()
        local owner = "CodeMeAPixel"
        local repo = "pxCommands"
        
        local function compareVersions(current, latest)
            if current == "dev" or latest == "dev" then
                return current ~= latest
            end
            return tonumber(current) and tonumber(latest) and tonumber(current) < tonumber(latest)
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
                        callback("dev")
                    end
                else
                    callback("dev")
                end
            end, "GET")
        end
        
        getLatestRelease(function(latestVersion)
            local currentVersion = "dev"
            local versionFile = LoadResourceFile(GetCurrentResourceName(), "version")
            if versionFile then
                currentVersion = versionFile:match("^%s*(.-)%s*$")
            end
            
            if compareVersions(currentVersion, latestVersion) then
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
            
            local downloadUrl = releaseData.zipball_url
            if not downloadUrl then
                log("No download URL found in release")
                return
            end
            
            log("Downloading release " .. (releaseData.tag_name or "latest") .. "...")
            PerformHttpRequest(downloadUrl, function(code, zipData, headers)
                if code ~= 200 then
                    log("Failed to download release: HTTP " .. code)
                    return
                end
                
                log("Downloaded release successfully")
                log("Please manually extract and restart: /restart " .. GetCurrentResourceName())
            end, "GET")
        end, "GET")
    else
        log("Usage: /" .. GetCurrentResourceName() .. " autoupdate")
        log("Note: Manual extraction required due to FiveM permissions")
    end
end, true)
