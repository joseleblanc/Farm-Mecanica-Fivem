local Tunnel = module("vrp", "lib/Tunnel")
local Proxy  = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

RegisterServerEvent("farm:giveMaterial")
AddEventHandler("farm:giveMaterial", function(qtd)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        vRP.giveInventoryItem(user_id, Config.ItemMaterial, qtd)
        
    end
end)

RegisterServerEvent("farm:Fabricar")
AddEventHandler("farm:Fabricar", function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return end

    local materiais = vRP.getInventoryItemAmount(user_id, Config.ItemMaterial)

    if materiais >= Config.MaterialsPerKit then
        local kits = math.floor(materiais / Config.MaterialsPerKit)

        vRP.tryGetInventoryItem(user_id, Config.ItemMaterial, kits * Config.MaterialsPerKit)
        vRP.giveInventoryItem(user_id, Config.ItemRepairKit, kits)

        TriggerClientEvent("Notify", source, "sucesso", 
            "Você fabricou <b>"..kits.." Repair Kits</b>.")
    else
        TriggerClientEvent("Notify", source, "negado", 
            "Você precisa de pelo menos "..Config.MaterialsPerKit.." materiais.")
    end
end)
RegisterServerEvent("farm:giveMaterial")
AddEventHandler("farm:giveMaterial", function(qtd)
    local source = source

    if qtd > 0 then
        TriggerEvent("inventory:give", source, Config.ItemMaterial, qtd)
        
    end
end)

RegisterServerEvent("farm:Fabricar")
AddEventHandler("farm:Fabricar", function()
    local source = source
    TriggerEvent("inventory:fabricarRepair", source)
end)
