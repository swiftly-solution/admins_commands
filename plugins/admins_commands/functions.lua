function GetAllAdminsOnline()
    local admins = {}

    for i=1,playermanager:GetPlayerCap() do
        if exports["admins"]:HasFlags(i-1,"b") then
            table.insert(admins, i-1)
        end
    end

    return admins
end