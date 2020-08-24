
showcoords = false
hasCollected = false
ActiveShovel = true
ActiveMetal =  true

Citizen.CreateThread(function()
    SetupCollectPrompt()
    SetupDigPrompt()
    TriggerServerEvent("collector:AddPlayer") --checks to see if it needs to add player to the database on startup
    while true do
        Wait(0)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        if showcoords then 
          print(coords)
          Wait (10000)
        end
        for i, row in pairs(PickUps)do
            local myV = vector3(coords)
            local collectableV = vector3(PickUps[i]["x"], PickUps[i]["y"], PickUps[i]["z"])
            local dst = Vdist(collectableV, myV)
            if dst < 3 and not IsPedInAnyVehicle(player, true) then
                if not hasCollected then
                    PromptSetEnabled(CollectPrompt, true)
                    PromptSetVisible(CollectPrompt, true)
                    if PromptHasHoldModeCompleted(CollectPrompt) then 
                        PromptSetEnabled(CollectPrompt, false)
                        PromptSetVisible(CollectPrompt, false)
                        hasCollected= true
                        pickupAnim()
                        item = PickUps[i]["name"]
                        type = PickUps[i]["name"]
                       TriggerServerEvent("collector:AddXP")
                       TriggerEvent("vorp:TipRight", "+100 Collector XP", 2000)
                       TriggerServerEvent("collector:AddCollectable",item, type,player)
                        break
                    end
                end
            else
                if dst > 3.5 then
                    --Might Need a check for dist
                end
            end
        end
        --stage 2 -- this is just a fleshed out outline of whats gonna happen
 
        if ActiveShovel then
        end
        --stage 3
        if ActiveMetal then
            --Check Collectors level 
            --check to see if holding MetalDec.
            for i, row in pairs(Metal)do
                local myV = vector3(coords)
                local collectableV = vector3(Metal[i]["x"], Metal[i]["y"], Metal[i]["z"])
                local dst = Vdist(collectableV, myV)
                if dst < 3 and not IsPedInAnyVehicle(player, true) then
                    if not hasCollected then
                        PromptSetEnabled(DigPrompt, true)
                        PromptSetVisible(DigPrompt, true)
                        if PromptHasHoldModeCompleted(DigPrompt) then 
                            PromptSetEnabled(DigPrompt, false)
                            PromptSetVisible(DigPrompt, false)
                            hasCollected= true
                            pickupAnim()
                            item = Metal[i]["name"]
                            type = Metal[i]["name"]
                           TriggerServerEvent("collector:AddXP")
                           TriggerEvent("vorp:TipRight", "+100 Collector XP", 2000)
                           TriggerServerEvent("collector:AddCollectable",item, type,player)
                            break
                        end
                    end
                else
                    if dst > 3.5 then
                    --Might Need a check for dist
                    end
                end
            end
        end
	end
end)
--pickup anims
function pickupAnim()
    -- world_human_bottle_pickup --maybe?!?
end
function shovelAnim()
    --spawn a shovel then attach to hand
    --spawn a chest for 60 then delete it
end
--Prompt Setup here
function SetupCollectPrompt ()
	Citizen.CreateThread(function()
        local str = 'COLLECT'
        CollectPrompt  = PromptRegisterBegin()
        PromptSetControlAction(CollectPrompt , 0xDFF812F9) --[[E]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(CollectPrompt , str)
        PromptSetEnabled(CollectPrompt , false)
        PromptSetVisible(CollectPrompt , false)
        PromptSetHoldMode(CollectPrompt , true)
		PromptRegisterEnd(CollectPrompt )
    end)
end
function SetupDigPrompt ()
	Citizen.CreateThread(function()
        local str = 'Dig'
        DigPrompt  = PromptRegisterBegin()
        PromptSetControlAction(DigPrompt , 0xDFF812F9) --[[E]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(DigPrompt , str)
        PromptSetEnabled(DigPrompt , false)
        PromptSetVisible(DigPrompt , false)
        PromptSetHoldMode(DigPrompt , true)
		PromptRegisterEnd(DigPrompt )
    end)
end
-- Collected UI for Selling 
function showUI()-- learn UI
end
function closeUI()-- learn UI
end
--creates npc to sell too.
Citizen.CreateThread(function()-- add npc to config
end)

