Config = {}

-----------------------------------
-- ITENS CONFIGURÁVEIS
-----------------------------------
Config.ItemMaterial = "material_repair"
Config.ItemRepairKit = "repairkit"
Config.MaterialsPerKit = 10

-----------------------------------
-- INÍCIO DA ROTA
-----------------------------------
Config.StartFarm = vector3(-962.61, -2055.83, 9.74)

-----------------------------------
-- NPC DE FABRICAÇÃO
-----------------------------------
Config.Fabricar = {
    coords = vector3(-954.46, -2043.49, 8.5), -- ↓ Z diminuído para encostar no chão
    heading = 90.0,
    ped = "u_m_y_proldriver_01" -- modelo do NPC
}

-----------------------------------
-- PONTOS DE COLETA (LOOP INFINITO)
-----------------------------------
Config.Coletas = {
    vector3(-514.14, -2202.42, 6.39),
    vector3(207.82, -1976.94, 19.87),
    vector3(-201.11, -1379.78, 31.26),
    vector3(65.07, -224.16, 52.57),
    vector3(954.27, -197.36, 73.21),
    vector3(706.65, -303.7, 59.24),
    vector3(642.77, 262.94, 103.29),
    vector3(-698.9,317.04,83.07),
    vector3(-570.81, -323.01, 35.06),
    vector3(-577.52, -1011.17, 22.33)
}

-----------------------------------
-- DRAW MARKERS CONFIGS
-----------------------------------
Config.Draw = {
    distToSee = 10.0,
    distToPress = 1.5,
    scale = vector3(0.35, 0.35, 0.35),
    color = {r = 255, g = 0, b = 0, a = 180},
}

-----------------------------------
-- ROTA NO MAPA (COR AMARELA)
-----------------------------------
Config.GPSColor = 65 -- amarelo
