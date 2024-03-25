CreateThread(function()
    player = PlayerPedId()
    isPedInAnyVehicle = IsPedInAnyVehicle(player)
    while (true) do
        if (player ~= PlayerPedId()) then 
            player = PlayerPedId()
        end
        if (isPedInAnyVehicle ~= IsPedInAnyVehicle(player)) then 
            isPedInAnyVehicle = IsPedInAnyVehicle(player)
        end
        DisplayRadar(isPedInAnyVehicle)
        Wait(1000)
    end
end)