commands:Register("slay", function(playerid, args, argsCount, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "f")

        if not hasAccess then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission")) end
    end

    if argsCount < 1 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.slay.syntax"), prefix))
    end

    local players = FindPlayersByTarget(args[1], false)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.invalid_player")) -- translation
    end

    local admin = nil
    if playerid ~= -1 then
        admin = GetPlayer(playerid)
    end

    for i = 1, #players do
        local pl = players[i]
        pl:Kill()
        ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation(string.format("admins.slay.message"):gsub("{ADMIN_NAME}", admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName)))
    end
end)

commands:Register("slap", function(playerid, args, argsCount, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "f")

        if not hasAccess then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission")) end
    end

    if argsCount < 1 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.slap.syntax"), prefix))
    end

    local players = FindPlayersByTarget(args[1], false)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), "No players found.") -- translation
    end

    local health = (args[2] or 0)

    local admin = nil
    if playerid ~= -1 then
        admin = GetPlayer(playerid)
    end

    for i = 1, #players do
        local pl = players[i]
        local vel = pl:CBaseEntity().AbsVelocity
        vel.x = vel.x + math.random(50, 230) * (math.random(0, 1) == 1 and -1 or 1)
        vel.y = vel.y + math.random(50, 230) * (math.random(0, 1) == 1 and -1 or 1)
        vel.z = vel.z + math.random(100, 300)
        pl:CBaseEntity().AbsVelocity = vel
        pl:CBaseEntity().Health = pl:CBaseEntity().Health - health
        
        ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.slap.message"):gsub("{ADMIN_NAME}", admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName):gsub("{HEALTH}", tostring(health)))
    end
end)


commands:Register("rename", function(playerid, args, argsCount, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "j")

        if not hasAccess then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission")) end
    end

    if argsCount < 2 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.rename.syntax"), prefix))
    end

    local players = FindPlayersByTarget(args[1], false)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), "No players found.") -- translation
    end

    local pl = players[1]
    local name = args[2]
    if name == pl:CBasePlayerController().PlayerName then 
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), "Same name.") -- translation
    end

    local admin = nil
    if playerid ~= -1 then
        admin = GetPlayer(playerid)
    end

    local oldname = pl:CBasePlayerController().PlayerName
    pl:CBasePlayerController().PlayerName = name    
    
    ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.rename.message"):gsub("{ADMIN_NAME}", admin:CBasePlayerController().PlayerName):gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName)) -- translation
end)

commands:Register("csay", function(playerid, args, argsCount, silent, prefix)
    if playerid == -1 then
        if argc < 1 then return print(string.format(FetchTranslation("admins.csay.syntax"), config:Fetch("admins.prefix"), "sw_")) end

        local message = table.concat(args, " ")
        playermanager:SendMsg(MessageType.Center, string.format("%s: %s", "CONSOLE", message))
    else
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "j")
        if not hasAccess then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission")) end

        if argsCount < 1 then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.csay.syntax"), prefix)) end

        local message = table.concat(args, " ")
        playermanager:SendMsg(MessageType.Center, string.format("%s: %s", player:CBasePlayerController().PlayerName, message))
    end
end)


commands:Register("rcon", function(playerid, args, argsCount, silent, prefix)
    if playerid == -1 then return end

    local player = GetPlayer(playerid)
    if not player then return end

    local hasAccess = exports["admins"]:HasFlags(playerid, "m")
    if not hasAccess then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission")) end

    if argsCount < 1 then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.rcon.syntax"), prefix)) end
    
    local cmd = table.concat(args, " ")
    if cmd:find("sw ") then return player:SendMsg(MessageType.Chat, string.format(FetchTranslation("admins.no_access"), config:Fetch("admins.prefix"))) end

    server:Execute(cmd)
end)

local ChangeMap = function(playerid, args, argsCount, silent)
    if playerid == -1 then
        if argc < 1 then return print(string.format(FetchTranslation("admins.changemap.syntax"), config:Fetch("admins.prefix"), "sw_")) end
        local map = args[1]
        if server:IsMapValid(map) == 0 then return print(string.format(FetchTranslation("admins.invalid_map"), config:Fetch("admins.prefix"), map)) end
        playermanager:SendMsg(MessageType.Chat, string.format(FetchTranslation("admins.changing_map"), config:Fetch("admins.prefix"), map))

        SetTimeout(3000, function()
            server:ChangeMap(map)
        end)
    end
end
commands:Register("map", ChangeMap)
commands:Register("changemap", ChangeMap)
