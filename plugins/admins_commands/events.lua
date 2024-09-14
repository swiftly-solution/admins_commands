AddEventHandler("OnPluginStart", function (event)
    GenerateMenu()
end)

AddEventHandler("OnAllPluginsLoaded", function(event)
    if GetPluginState("admins") == PluginState_t.Started then
        exports["admins"]:RegisterMenuCategory("admins.adminmenu.commands.title", "admin_commands", "f")
    end

    return EventResult.Continue
end)
