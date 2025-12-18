local servico = false
local atual = 1
local pedNPC = nil

---------------------------------------------------------------------
-- CRIAR NPC NO LOCAL DE FABRICAÇÃO
---------------------------------------------------------------------
CreateThread(function()
    local model = GetHashKey(Config.Fabricar.ped)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    pedNPC = CreatePed(4, model, Config.Fabricar.coords.x, Config.Fabricar.coords.y, Config.Fabricar.coords.z, Config.Fabricar.heading, false, false)
    FreezeEntityPosition(pedNPC, true)
    SetEntityInvincible(pedNPC, true)
    SetBlockingOfNonTemporaryEvents(pedNPC, true)
end)

---------------------------------------------------------------------
-- LOOP PRINCIPAL
---------------------------------------------------------------------
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - Config.StartFarm)

        -- INICIAR / FINALIZAR ROTA
        if dist < Config.Draw.distToSee then
            DrawMarker(2, Config.StartFarm.x, Config.StartFarm.y, Config.StartFarm.z - 0.98, 0,0,0,0,0,0,
                Config.Draw.scale.x, Config.Draw.scale.y, Config.Draw.scale.z,
                Config.Draw.color.r, Config.Draw.color.g, Config.Draw.color.b, Config.Draw.color.a,
                false,true,2,false)

            if dist < Config.Draw.distToPress then
                if not servico then
                    DrawText3D(Config.StartFarm, "~g~E~w~ INICIAR ROTA DE FARM")
                    if IsControlJustPressed(0, 38) then
                        servico = true
                        atual = 1
                        SetMissionWaypoint(Config.Coletas[atual])  -- GPS amarelo
                        TriggerEvent("Notify", "sucesso", "Rota iniciada!")
                    end
                else
                    DrawText3D(Config.StartFarm, "~r~E~w~ ENCERRAR ROTA")
                    if IsControlJustPressed(0, 38) then
                        servico = false
                        TriggerEvent("Notify", "negado", "Você saiu da rota.")
                    end
                end
            end
        end

        -- COLETA DE MATERIAIS
        if servico then
            local destino = Config.Coletas[atual]
            local dist2 = #(coords - destino)

            if dist2 < Config.Draw.distToSee then
                DrawMarker(2, destino.x, destino.y, destino.z - 0.98, 0,0,0,0,0,0,
                    Config.Draw.scale.x, Config.Draw.scale.y, Config.Draw.scale.z,
                    Config.Draw.color.r, Config.Draw.color.g, Config.Draw.color.b, Config.Draw.color.a,
                    false,true,2,false)

                if dist2 < Config.Draw.distToPress then
                    DrawText3D(destino, "~g~E~w~ COLETAR")

                    if IsControlJustPressed(0, 38) then
                        startPickupAnimation(destino)

                        local qtd = math.random(2,8)
                        TriggerServerEvent("farm:giveMaterial", qtd)
                        TriggerEvent("Notify", "sucesso", "Você coletou <b>"..qtd.." materiais</b>.")

                        atual = atual + 1
                        if atual > #Config.Coletas then
                            atual = 1 -- LOOP INFINITO
                        end
                        SetMissionWaypoint(Config.Coletas[atual])
                    end
                end
            end
        end

        -- FABRICAR REPAIR KIT
        local dist3 = #(coords - Config.Fabricar.coords)
        if dist3 < 2.0 then
            DrawText3D(Config.Fabricar.coords, "~b~E~w~ FABRICAR REPAIR KIT")

            if IsControlJustPressed(0, 38) then
                TriggerServerEvent("farm:Fabricar")
            end
        end

        Wait(1)
    end
end)

---------------------------------------------------------------------
-- ANIMAÇÃO + PROP DA CAIXA
---------------------------------------------------------------------
function startPickupAnimation(pos)
    local ped = PlayerPedId()

    -- carregar animação
    RequestAnimDict("anim@mp_snowball")
    while not HasAnimDictLoaded("anim@mp_snowball") do Wait(10) end

    -- criar prop apenas para o player
    local propModel = GetHashKey("prop_tool_box_04")
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do Wait(10) end

    local prop = CreateObject(propModel, pos.x, pos.y, pos.z - 1.0, true, false, false)

    SetEntityCollision(prop, false, false)

    -- tocar anim
    TaskPlayAnim(ped, "anim@mp_snowball", "pickup_snowball", 8.0, -8.0, 1200, 0, 0, false, false, false)
    Wait(900)

    DeleteEntity(prop)
    ClearPedTasks(ped)
end

---------------------------------------------------------------------
-- FUNÇÃO TEXTO 3D
---------------------------------------------------------------------
function DrawText3D(coord, text)
    local onScreen,_x,_y = World3dToScreen2d(coord.x, coord.y, coord.z)
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255,255,255,215)
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(_x,_y)
end

---------------------------------------------------------------------
-- GPS AMARELO
---------------------------------------------------------------------
function SetMissionWaypoint(vec)
    ClearGpsMultiRoute()

    StartGpsMultiRoute(Config.GPSColor, true, true)
    AddPointToGpsMultiRoute(vec.x, vec.y, vec.z)
    SetGpsMultiRouteRender(true)
end
