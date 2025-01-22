local onDutyOfficers = {}

RegisterCommand('patrolPD', function(source, args, rawCommand)
    startPatrol(source, 'PD')
end, false)

RegisterCommand('patrolSO', function(source, args, rawCommand)
    startPatrol(source, 'SO')
end, false)

RegisterCommand('patrolUSM', function(source, args, rawCommand)
    startPatrol(source, 'USM')
end, false)

RegisterCommand('patrolST', function(source, args, rawCommand)
    startPatrol(source, 'ST')
end, false)

RegisterCommand('patrolend', function(source, args, rawCommand)
    endPatrol(source)
end, false)

function startPatrol(source, department)
    local playerName = GetPlayerName(source)
    local playerID = tostring(source)
    local departmentName = getDepartmentName(department)
    local webhookURL = Config.Webhooks[department]

    if onDutyOfficers[playerID] then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = "You are already on patrol!",
            duration = 5000
        })
        return
    end

    onDutyOfficers[playerID] = {
        name = playerName,
        department = department,
        startTime = os.time() -- Record the patrol start time
    }

    -- Send to Discord webhook
    sendToDiscord(webhookURL, "**Patrol Start**", playerName .. " has started their patrol in " .. departmentName)

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = "You have started your patrol in " .. departmentName .. "!",
        duration = 5000
    })
end

function endPatrol(source)
    local playerID = tostring(source)

    if not onDutyOfficers[playerID] then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = "You are not currently on patrol!",
            duration = 5000
        })
        return
    end

    local officerData = onDutyOfficers[playerID]
    local departmentName = getDepartmentName(officerData.department)
    local webhookURL = Config.Webhooks[officerData.department]

    -- Calculate total patrol time
    local endTime = os.time()
    local elapsedTime = os.difftime(endTime, officerData.startTime)
    local hours, minutes, seconds = formatTime(elapsedTime)

    -- Send to Discord webhook
    sendToDiscord(
        webhookURL,
        "**Patrol End**",
        officerData.name .. " has ended their patrol in " .. departmentName ..
        "! Total time on patrol: " .. hours .. " Hours, " .. minutes .. " Minutes, and " .. seconds .. " Seconds."
    )

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = "You have ended your patrol in " .. departmentName .. "! Total time: " .. hours .. "h " .. minutes .. "m " .. seconds .. "s.",
        duration = 7000
    })

    onDutyOfficers[playerID] = nil
end

function getDepartmentName(departmentCode)
    local departmentNames = {
        PD = "Police Department",
        SO = "Sheriff's Office",
        USM = "US Marshals",
        ST = "Super Troopers"
    }
    return departmentNames[departmentCode] or "Unknown Department"
end

function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    return hours, minutes, seconds
end

function sendToDiscord(webhookURL, title, message)
    local payload = {
        username = "Patrol Logger",
        embeds = {{
            ["title"] = title,
            ["description"] = message,
            ["color"] = 3447003
        }}
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end
