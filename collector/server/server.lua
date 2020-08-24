RegisterServerEvent('collector:AddPlayer')
    AddEventHandler('collector:AddPlayer',function(src)
        local identifiers = ExtractIdentifiers()
        local steam = identifiers.steam
        exports.ghmattimysql:scalar("SELECT `identifier` FROM collectables WHERE identifier = @identifier",
        { ['@identifier'] = steam}, function (results)
            if results == steam then
                -- Add Welcome Back Message 
            else
                exports.ghmattimysql:execute("INSERT INTO collectables (identifier, xp) VALUES (@identifier, @xp)",
                { ['@identifier'] = steam, ['@xp'] = 1})
                -- send a Welcome to Collectables message 
            end
    end)
end)
local CheckLevel = 0
RegisterServerEvent('collector:AddXP') -- this updates XP
    AddEventHandler('collector:AddXP', function(src)
        local identifiers = ExtractIdentifiers()
        local steam = identifiers.steam
        exports.ghmattimysql:scalar("SELECT `xp` FROM collectables WHERE identifier = @identifier",
        { ['@identifier'] = steam}, function (results)
            oldXP = results
            AddXP = results + 100
            CheckLevel = AddXP / 2500 -- this is the leveling system 

        if CheckLevel < 20 then  --20 is cap for now
            exports.ghmattimysql:execute("UPDATE collectables SET `xp` = @xp WHERE identifier = @identifier", 
            { ['@identifier'] = steam, ['@xp'] = AddXP})
        end
    end)
end)

RegisterServerEvent('collector:AddCollectable')
    AddEventHandler('collector:AddCollectable', function(item, type, source)
        local identifiers = ExtractIdentifiers()
        local steam = identifiers.steam
        source = _source
        DBType = item
        exports.ghmattimysql:scalar("SELECT `"..DBType.."` FROM collectables WHERE identifier = @identifier",
        { ['@identifier'] = steam}, function (results)
          
            Collected = results
            AppendItems =  Collected +1
            if AppendItems < 10 then
            exports.ghmattimysql:execute("UPDATE collectables SET `"..DBType.."` = @"..DBType.." WHERE identifier = @identifier", 
            { ['@identifier'] = steam, ['@'..DBType..''] = AppendItems})
            end
            if AppendItems == 10 then
                TriggerClientEvent("vorp:TipBottom", _source, "You can't carry anymore "..item , 3000)
            end
        end)
end)

function ExtractIdentifiers()
    local identifiers = {steam = ""}
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        end
    end
    return identifiers
end



