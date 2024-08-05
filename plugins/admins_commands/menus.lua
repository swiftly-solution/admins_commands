function GenerateMenu()
    menus:Unregister("admin_commands")

    menus:Register("admin_commands", FetchTranslation("admins.adminmenu.commands.title"), tostring(config:Fetch("admins.amenucolor")), {
        { FetchTranslation("admins.adminmenu.slay"), "sw_addslaymenu" },
        { FetchTranslation("admins.adminmenu.slap"), "sw_addslapmenu" }
    })
end
