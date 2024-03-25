local QBCore = exports['qb-core']:GetCoreObject()

-- RegisterNetEvent('build:interfaz', function(state)
--     PlayerData = QBCore.Functions.GetPlayerData()

--     buildHud(state)
--     -- buildVehicleHud(state)
--     -- LocalPlayer.state.isLoggedIn = true
-- end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function(state)
    Wait(2000)

    PlayerData = QBCore.Functions.GetPlayerData()
    buildHud(true)
    LocalPlayer.state.isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    buildHud(false)
    -- buildVehicleHud(true)
    LocalPlayer.state.isLoggedIn = false

end)




AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    buildHud(true)
    -- buildVehicleHud(true)
    LocalPlayer.state.isLoggedIn = true

end)


exports('showNotification', appendNotification)

local function testNotifications()
    for k, v in pairs({ 'admin' }) do
        QBCore.Functions.Notify('Esto es una prueba de notificaciones kakakakakakakakkakkakakkak kakkakakkakkakakakakkakkaka kkakakkakakkakakakak kakakakkakakak kakakakkakakak kakakakkakakak kakakakkakakak kakakakkakakak ', v)
    end

    SetClockTime(12,12,20)
end

RegisterCommand('test', testNotifications)