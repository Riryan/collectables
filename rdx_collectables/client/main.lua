RDX = nil
Ready = false

Player = {}
Collectables = {}
Active = {}

Citizen.CreateThread(function()
    while RDX == nil do
        Citizen.Wait(10)
        TriggerEvent("rdx:getSharedObject", function(response)
            RDX = response
        end)
    end
    Wait(1000)
    while not RDX.IsPlayerLoaded() do
        Citizen.Wait(10)
    end
    PlayerData = RDX.GetPlayerData()

    InitCollectables()
end)

-- Update player coords
Citizen.CreateThread(function()
    local delay = 100

    if Config.Debug then
        delay = 0
    end

    while true do
        if Ready then
            Player.Ped = PlayerPedId()
            Player.Pos = GetEntityCoords(Player.Ped)

            if Config.Debug then
                RenderDebugHud(Collectables)
            end
        end
        Citizen.Wait(delay)
    end
end)

-- Only get items in range of player so later check only has a small table to check
Citizen.CreateThread(function()
    while true do
        if Ready then
            for k, v in pairs(Collectables) do
                -- Reset active table
                Active[k] = {}

                local ItemsCount = #v.Items
                for i = 1, ItemsCount do
                    local Item = v.Items[i]

                    if not Item.Collected then

                        -- Add debug blip
                        if Config.Debug and not Item.Blip then
                            AddDebugBlip(Item, v.Blip, v.Title)
                        end                       

                        local dist = #(Item.Pos - Player.Pos)                     

                        -- Add item to active table
                        if dist < Config.DrawDistance then
                            Item.InRange = true
                            table.insert(Active[k], Item)       
                        end
                    end
                end
            end
        end
        Citizen.Wait(5000)
    end
end)

function EnableCollectable(Type)

    Active[Type] = {}

    -- Check the active table
    Citizen.CreateThread(function()
        while true do
            if Ready and not Collectables[Type].Completed then
                local Collection = Active[Type]
                local ItemsCount = #Collection
                for i = 1, ItemsCount do
                    local Item = Collection[i]

                    if not Item.Collected then
                        local dist = #(Item.Pos - Player.Pos) 

                        -- spawn entity when player is in range
                        if not Item.Spawned then
                            SpawnItem(Item, Collectables[Type].Prop)
                        end                            

                        -- Only do checks if player is in range
                        if dist < Config.DrawDistance then
                            -- Only do collisions check if player is really close to collectable
                            if dist < 1 then
                                -- Trigger collection
                                CollectItem(Item, Type)
                            end               
                        end
                    end
                end
            end

            Citizen.Wait(0)
        end
    end)
end


-- Initialise
function InitCollectables()
    RDX.TriggerServerCallback("rdx_collectables:ready", function(xPlayer, _collectables)
        Player.Ped = PlayerPedId()
        Player.Pos = GetEntityCoords(Player.Ped)

        Collectables = _collectables
        Ready = true

        for k, v in pairs(_collectables) do
            if v.Enabled then
                EnableCollectable(k)
            end
        end
    end)
end

function SpawnItem(item, prop)
    item.Spawned = true
    item.Collected = false

    RDX.Game.SpawnLocalObject(prop, item.Pos, function(entity)
        if Config.PlaceCollectables and item.Fixed == nil then
            PlaceObjectOnGroundProperly(entity)
        end
        FreezeEntityPosition(entity, true)
    
        item.Entity = entity
    end)
end

function DespawnItem(item)
    RDX.Game.DeleteObject(item.Entity)

    -- Remove debug blip
    if item.Blip ~= nil then
        if DoesBlipExist(item.Blip) then
            SetBlipAsMissionCreatorBlip(item.Blip,false)
            RemoveBlip(item.Blip)
            item.Blip = nil
        end
    end    

    item.Spawned = false    
    item.InRange = false    
end

-- Trigger player collected item
function CollectItem(item, type)
    local Collectable = Collectables[type]
    item.Collected = true

    -- Allow player to pass through entity
    SetEntityCollision(item.Entity, false, true)

    table.insert(Collectable.Collected, item.ID)

    RDX.TriggerServerCallback('rdx_collectables:collected', function(success, _type, _completed)
        if success then
            -- Remove the item
            DespawnItem(item)

            Collectable.Completed = _completed

            -- play sound
            PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        
            -- show notification
            if Collectable.Completed then
                RDX.Scaleform.ShowFreemodeMessage(
                    _U('completed_title', Collectable.Title),
                    _U('completed_msg', #Collectable.Items, Collectable.Title),
                    3
                )
            else
                RDX.Scaleform.ShowFreemodeMessage(
                    _U('found_title', Collectable.Title),
                    _U('found_msg', #Collectable.Collected, #Collectable.Items, Collectable.Title),
                    3
                ) 
            end
        else
            -- there was a problem so respawn item
            SpawnItem(item)
        end
    end, item, type, Collectable)
end


-- Remove spawned items
function RemoveItems()
    for k, v in pairs(Collectables) do
        for i = 1, #Collectables[k].Items do
            local Item = Collectables[k].Items[i]
                            
            if not Item.Collected and Item.Entity then
                DespawnItem(Item)            
            end
        end   
    end 
end

-- Menu thread
Citizen.CreateThread(function()
    while true do
        if Ready then
            if IsControlJustReleased(0, Config.MenuKey) then
                OpenMenu()
            end
        end

        Citizen.Wait(0)
    end
end)

function OpenMenu()								
    local Resource = GetCurrentResourceName()
    local Elements = {}

    for k, v in pairs(Collectables) do
        local Total = #v.Items
        local Collected = #v.Collected
        table.insert(Elements,  {
            label = ("%s: <span style='color: green;'>%s/%s</span>"):format(v.Title, Collected, Total),
            value = v.ID,
            title = v.Title,
            total = Total,
            collected = Collected,
            type = k
        })
    end

    RDX.UI.Menu.CloseAll()		
    
    RDX.UI.Menu.Open(
        'default', Resource, 'progress',
        {
            title       = _U('menu_title'),
            align       = Config.MenuPosition,
            elements    = Elements
        },
        function(data, menu)
            -- RDX.ShowNotification(data.current.value)
            RDX.UI.Menu.Open('default', Resource, data.current.value, {
                title = ('%s (%s)'):format(data.current.title, data.current.total),
                align = Config.MenuPosition,
                elements = {
                    {label = ("%s: <span style='color: green;'>%s</span>"):format('Collected', data.current.collected),  value = 'collected'},
                    {label = ("<span style='color: red;'>%s</span>"):format(_U('menu_reset')),  value = 'reset'},
            }}, function(data2, menu2)
                if data2.current.value == 'reset' then
                    RDX.UI.Menu.Open('default', Resource, data2.current.value, {
                        title       = _U('menu_reset'),
                        align       = Config.MenuPosition,
                        elements    = {
                                        {label = _U('menu_no'),  value = 'no'},
                                        {label = ("<span style='color: red;'>%s</span>"):format(_U('menu_yes')), value = 'yes'}
                                    }
                    }, function(data3, menu3)
                        if data3.current.value == 'yes' then
                            RDX.TriggerServerCallback('rdx_collectables:reset', function(success, total)
                                if success then
                                    if total > 0 then
                                        RDX.ShowNotification(_U('money_removed', total))
                                    end

                                    RDX.UI.Menu.CloseAll()

                                    RemoveItems()
                                    Wait(500)
                                    InitCollectables()	
                                end
                            end, Collectables[data.current.type])
                        end

                        menu3.close()
                    end, function(data3, menu3)
                        menu3.close()
                    end)
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end,
        function(data, menu)
            menu.close()
        end
    )
end

-- Restart
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if Ready then
            InitCollectables()
        end
    end
end)

-- Reset collectables on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        RemoveItems()
    end
end)