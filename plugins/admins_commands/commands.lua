commands:Register("slay", function(playerid, args, argsCount, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "f")

        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
        end
    end

    if argsCount < 1 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            string.format(FetchTranslation("admins.slay.syntax"), prefix))
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
        if not pl:CBasePlayerController():IsValid() then return end
        ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.slay.message"):gsub("{ADMIN_NAME}",
                admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{PLAYER_NAME}",
                pl:CBasePlayerController().PlayerName))
    end
end)

commands:Register("slap", function(playerid, args, argsCount, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "f")

        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
        end
    end

    if argsCount < 1 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            string.format(FetchTranslation("admins.slap.syntax"), prefix))
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
        if not pl:CBaseEntity():IsValid() then return end
        local vel = pl:CBaseEntity().AbsVelocity
        vel.x = vel.x + math.random(50, 230) * (math.random(0, 1) == 1 and -1 or 1)
        vel.y = vel.y + math.random(50, 230) * (math.random(0, 1) == 1 and -1 or 1)
        vel.z = vel.z + math.random(100, 300)
        pl:CBaseEntity().AbsVelocity = vel
        pl:CBaseEntity().Health = pl:CBaseEntity().Health - health

        if not pl:CBasePlayerController():IsValid() then return end
        ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.slap.message"):gsub("{ADMIN_NAME}",
                admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{PLAYER_NAME}",
                pl:CBasePlayerController().PlayerName):gsub("{HEALTH}", tostring(health)))
    end
end)


commands:Register("rename", function(playerid, args, argsCount, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "j")

        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
        end
    end

    if argsCount < 2 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            string.format(FetchTranslation("admins.rename.syntax"), prefix))
    end

    local players = FindPlayersByTarget(args[1], false)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), "No players found.") -- translation
    end

    local pl = players[1]
    local name = args[2]
    if not pl:CBasePlayerController():IsValid() then return end
    if name == pl:CBasePlayerController().PlayerName then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), "Same name.") -- translation
    end

    local admin = nil
    if playerid ~= -1 then
        admin = GetPlayer(playerid)
    end


    local oldname = pl:CBasePlayerController().PlayerName
    pl:CBasePlayerController().PlayerName = name
    if not admin:CBasePlayerController():IsValid() then return end
    ReplyToCommand(playerid, config:Fetch("admins.prefix"),
        FetchTranslation("admins.rename.message"):gsub("{ADMIN_NAME}", admin:CBasePlayerController().PlayerName):gsub(
            "{PLAYER_NAME}", pl:CBasePlayerController().PlayerName)) -- translation
end)

commands:Register("csay", function(playerid, args, argsCount, silent, prefix)
    if playerid == -1 then
        if argc < 1 then
            return print(string.format(FetchTranslation("admins.csay.syntax"), config:Fetch("admins.prefix"),
                "sw_"))
        end

        local message = table.concat(args, " ")
        playermanager:SendMsg(MessageType.Center, string.format("%s: %s", "CONSOLE", message))
    else
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "j")
        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
        end

        if argsCount < 1 then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                string.format(FetchTranslation("admins.csay.syntax"), prefix))
        end

        local message = table.concat(args, " ")
        if not player:CBasePlayerController():IsValid() then return end
        playermanager:SendMsg(MessageType.Center,
            string.format("%s: %s", player:CBasePlayerController().PlayerName, message))
    end
end)


commands:Register("rcon", function(playerid, args, argsCount, silent, prefix)
    if playerid == -1 then return end

    local player = GetPlayer(playerid)
    if not player then return end

    local hasAccess = exports["admins"]:HasFlags(playerid, "m")
    if not hasAccess then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.no_permission"))
    end

    if argsCount < 1 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            string.format(FetchTranslation("admins.rcon.syntax"), prefix))
    end

    local cmd = table.concat(args, " ")
    if cmd:find("sw ") then
        return player:SendMsg(MessageType.Chat,
            string.format(FetchTranslation("admins.no_access"), config:Fetch("admins.prefix")))
    end

    server:Execute(cmd)
end)

local ChangeMap = function(playerid, args, argsCount, silent)
    if playerid == -1 then
        if argc < 1 then
            return print(string.format(FetchTranslation("admins.changemap.syntax"),
                config:Fetch("admins.prefix"), "sw_"))
        end
        local map = args[1]
        if server:IsMapValid(map) == 0 then
            return print(string.format(FetchTranslation("admins.invalid_map"),
                config:Fetch("admins.prefix"), map))
        end
        playermanager:SendMsg(MessageType.Chat,
            string.format(FetchTranslation("admins.changing_map"), config:Fetch("admins.prefix"), map))

        SetTimeout(3000, function()
            server:ChangeMap(map)
        end)
    end
end
commands:Register("map", ChangeMap)
commands:Register("changemap", ChangeMap)


local AddSlapMenuSelectedPlayer = {}
local AddSlapMenuSelectedHealth = {}

commands:Register("addslapmenu", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, "f") then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
    end

    AddSlapMenuSelectedPlayer[playerid] = nil
    AddSlapMenuSelectedHealth[playerid] = nil

    local players = {}

    for i = 0, playermanager:GetPlayerCap() - 1, 1 do
        local pl = GetPlayer(i)
        if pl then
            if not pl:IsFakeClient() then
                if pl:CBasePlayerController():IsValid() then
                    table.insert(players, { pl:CBasePlayerController().PlayerName, "sw_addslapmenu_selectplayer " .. i })
                end
            end
        end
    end

    if #players == 0 then
        table.insert(players, { FetchTranslation("admins.no_players"), "" })
    end

    menus:RegisterTemporary("addslapmenuadmintempplayer_" .. playerid, FetchTranslation("admins.add.slap"), config:Fetch("admins.amenucolor"), players)

    player:HideMenu()
    player:ShowMenu("addslapmenuadmintempplayer_" .. playerid)
end)

commands:Register("addslapmenu_selectplayer", function(playerid, args, argc, silent)
    if playerid == -1 then return end
    
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, "f") then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
    end

    if argc == 0 then return end

    local pid = tonumber(args[1])
    if pid == nil then return end
    local pl = GetPlayer(pid)
    if not pl then return end

    AddSlapMenuSelectedPlayer[playerid] = pid

    local options = {}

    for i = 0, config:FetchArraySize("admin_commands.health") - 1, 1 do
        table.insert(options, { config:Fetch("admin_commands.health[" .. i .. "]"), "sw_addslapmenu_selecthealth \""..config:Fetch("admin_commands.health[" .. i .. "]").."\"" })
    end

    menus:RegisterTemporary("addslapmenuadmintempplayerhealth_" .. playerid, FetchTranslation("admins.slap.select_health"), config:Fetch("admins.amenucolor"), options)
    player:HideMenu()
    player:ShowMenu("addslapmenuadmintempplayerhealth_" .. playerid)
end)

commands:Register("addslapmenu_selecthealth", function (playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, "d") then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
    end

    if argc == 0 then return end
    if not AddSlapMenuSelectedPlayer[playerid] then return player:HideMenu() end

    local health = args[1]
    AddSlapMenuSelectedHealth[playerid] = health

    local pid = AddSlapMenuSelectedPlayer[playerid]
    local pl = GetPlayer(pid)
    if not pl then
        player:HideMenu()
        ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.not_connected"))
        return
    end

    if not pl:CBaseEntity():IsValid() then return end
    local vel = pl:CBaseEntity().AbsVelocity
    vel.x = vel.x + math.random(50, 230) * (math.random(0, 1) == 1 and -1 or 1)
    vel.y = vel.y + math.random(50, 230) * (math.random(0, 1) == 1 and -1 or 1)
    vel.z = vel.z + math.random(100, 300)

    pl:CBaseEntity().AbsVelocity = vel
    pl:CBaseEntity().Health = pl:CBaseEntity().Health - AddSlapMenuSelectedHealth[playerid]

    if not player:CBasePlayerController():IsValid() then return end
    if not pl:CBasePlayerController():IsValid() then return end
    ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.slap.message"):gsub("{ADMIN_NAME}",
                player and player:CBasePlayerController().PlayerName):gsub("{PLAYER_NAME}",
                pl:CBasePlayerController().PlayerName):gsub("{HEALTH}", tostring(health)))

end)

local AddSlayMenuSelectedPlayer = {}

commands:Register("addslaymenu", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, "f") then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
    end

    AddSlayMenuSelectedPlayer[playerid] = nil

    local players = {}

    for i = 0, playermanager:GetPlayerCap() - 1, 1 do
        local pl = GetPlayer(i)
        if pl then
            if not pl:IsFakeClient() then
                if pl:CBasePlayerController():IsValid() then
                    table.insert(players, { pl:CBasePlayerController().PlayerName, "sw_addslaymenu_selectplayer " .. i })
                end
            end
        end
    end

    if #players == 0 then
        table.insert(players, { FetchTranslation("admins.no_players"), "" })
    end

    menus:RegisterTemporary("addslaymenuadmintempplayer_" .. playerid, FetchTranslation("admins.add.slay"), config:Fetch("admins.amenucolor"), players)

    player:HideMenu()
    player:ShowMenu("addslaymenuadmintempplayer_" .. playerid)
end)

commands:Register("addslaymenu_selectplayer", function(playerid, args, argc, silent)
    if playerid == -1 then return end
    
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, "f") then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
    end

    if argc == 0 then return end

    local pid = tonumber(args[1])
    if pid == nil then return end
    local pl = GetPlayer(pid)
    if not pl then return end

    AddSlayMenuSelectedPlayer[playerid] = pid

    if not pl:CBaseEntity():IsValid() then return end
    if not pl:CBasePlayerController():IsValid() then return end
    if pl:CBaseEntity().Health <= 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.slay.already_dead"):gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName))
    end

    pl:Kill()
    if not player:CBasePlayerController():IsValid() then return end
    ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.slay.message"):gsub("{ADMIN_NAME}",
                player and player:CBasePlayerController().PlayerName):gsub("{PLAYER_NAME}",
                pl:CBasePlayerController().PlayerName))
    
end)
