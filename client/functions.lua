local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local hud_stats = {}
local radio = false
local health, armor, hunger, thirst, stress, stamina, oxygen = 0, 0, 0, 0, 0, 0, 0
local inVehicle = false


-- local seatbelt = false

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst) -- Triggered in qb-core
  hunger = newHunger
  thirst = newThirst
end)

-- RegisterNetEvent('hud:client:UpdateThirst', function(newThirst) -- Triggered in qb-core
--   thirst = newThirst
-- end)



RegisterNetEvent('hud:client:UpdateStress', function(newStress) -- Add this event with adding stress elsewhere
    stress = newStress
end)

function buildHud(state)
  if(state) then

      CreateThread(function()
          PlayerData = QBCore.Functions.GetPlayerData()

          while not PlayerData.metadata do
              Wait(100)
          end

          hunger = PlayerData.metadata['hunger']
          thirst = PlayerData.metadata['thirst']
          stress = PlayerData.metadata['stress']

          while (true) do

              plyState = LocalPlayer.state;

              if(not IsPauseMenuActive()) then

                  hud_stats = {
                      health = math.ceil(GetEntityHealth(PlayerPedId()) / 2),
                      shield = math.ceil(GetPedArmour(PlayerPedId())),
                      -- stamina = math.ceil(GetPlayerSprintStaminaRemaining(PlayerId())),
                      hunger = hunger,
                      thirst = thirst,
                      stress = stress,
                      radar = IsRadarHidden(),
                      voice_mode = plyState.proximity.mode,
                      voice_active = (NetworkIsPlayerTalking(PlayerId()) == 1),
                      radio_active = radio,
                      -- radio_channel = plyState.radioChannel
                  }
  
                  -- TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                  --     hud_stats.hunger = math.ceil(status.val / 10000)
                  -- end)
          
                  -- TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                  --     hud_stats.thirst = math.ceil(status.val / 10000)
                  -- end)

                  SendNUIMessage({
                      action = state,
                      type = 'show:interfaz:hud',
                      data_hud = hud_stats
                  })

              else
                  SendNUIMessage({
                      action = false
                  })
              end

              Wait(350)

          end
      end)
  else
      SendNUIMessage({
          action = false
      })
  end
end

-- CreateThread(function()
--     while true do
--       Wait(7 * 1000 * 60)
  
--       if LocalPlayer.state.isLoggedIn then
--         TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
--       end
--     end
-- end)

-- CreateThread(function()
--     while true do
--         if LocalPlayer.state.isLoggedIn then
--             local ped = PlayerPedId()
--             local weapon = GetSelectedPedWeapon(ped)
    
--             if weapon ~= `WEAPON_UNARMED` then
--                 if IsPedShooting(ped) and not Config.WhitelistedWeaponStress[weapon] then
--                     if math.random() < Config.StressChance then
--                         TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
--                     end
--                     Wait(100)
--                 else
--                     Wait(500)
--                 end
--             else
--                 Wait(500)
--             end
--         else
--             Wait(1000)
--         end
--     end
-- end)


RegisterNetEvent('pma-voice:radioActive')
AddEventHandler("pma-voice:radioActive", function(radioTalking)
    radio = radioTalking
end)

-- RegisterNetEvent('hud:client:notify', function(title, position, type)
--     lib.notify({
--         title = title,
--         position = position,
--         type = type
--     })
-- end)

--compass--
CreateThread(function()
  while true do
    Wait(500)
    if IsPedInAnyVehicle(PlayerPedId(), false) and (not IsPauseMenuActive()) then

      if not inVehicle then

        SendNUIMessage({
          action = true,
          type = 'showCompass',
        })

        inVehicle = true
      end

      local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
      local coords = GetEntityCoords(vehicle)
      local direction = GetEntityHeading(vehicle)
      local directionText = GetDirectionText(direction)
      local street = ''
      local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)

      if street1 ~= 0 and street2 ~= 0 then
        street = GetStreetNameFromHashKey(street1) .. ' & ' .. GetStreetNameFromHashKey(street2)
      elseif street1 ~= 0 then
        street = GetStreetNameFromHashKey(street1)
      elseif street2 ~= 0 then
        street = GetStreetNameFromHashKey(street2)
      else
        street = 'Unknown'
      end

      SendNUIMessage({
        action = true,
        type = 'updateStreet',
        -- text = (directionText .. ' | ' .. street)
        data_street = {
          text = (street .. ' | ' .. directionText),
        }
      })
    else

      if inVehicle then

        SendNUIMessage({
          action = true,
          type = 'hideCompass',
        })

        inVehicle = false
      end
    end
  end



end)


function GetDirectionText(direction)
  local directionText = ''

  if direction >= 0 and direction <= 45 then
    directionText = 'N'
  elseif direction > 45 and direction <= 90 then
    directionText = 'NE'
  elseif direction > 90 and direction <= 135 then
    directionText = 'E'
  elseif direction > 135 and direction <= 180 then
    directionText = 'SE'
  elseif direction > 180 and direction <= 225 then
    directionText = 'S'
  elseif direction > 225 and direction <= 270 then
    directionText = 'SW'
  elseif direction > 270 and direction <= 315 then
    directionText = 'W'
  elseif direction > 315 and direction <= 360 then
    directionText = 'NW'
  end

  return directionText
end

--voz--
RegisterCommand('rvoz', function()
  NetworkClearVoiceChannel()
  NetworkSessionVoiceLeave()
  Wait(50)
  NetworkSetVoiceActive(false)
  MumbleClearVoiceTarget(2)
  Notify('Reiniciando chat de voz...', 'success', 5000)
  Wait(1000)
  MumbleSetVoiceTarget(2)
  NetworkSetVoiceActive(true)
  Notify('Chat de voz reiniciado', 'success', 5000)
end, false)

--minimap--
Citizen.CreateThread(
  function()
    
    local minimap = RequestScaleformMovie("minimap")
    while not HasScaleformMovieLoaded(minimap) do
      Wait(0)
    end

    SetMinimapClipType(0)
    
    SetMinimapComponentPosition('minimap', 'L', 'B', -0.015, -0.020, 0.150, 0.188888)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.01, 0.035, 0.111, 0.159)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.0405, 0.005, 0.266, 0.237)
    -- SetMinimapComponentPosition("minimap", "L", "B", -0.0045, 0.002, 0.150, 0.188888)
    -- SetMinimapComponentPosition("minimap_mask", "L", "B", 0.020, 0.032, 0.111, 0.159)
    -- SetMinimapComponentPosition("minimap_blur", "L", "B", -0.03, 0.002, 0.266, 0.237)

    SetBigmapActive(true, false)
    Wait(1000)
    SetBigmapActive(false, false)
  end
)

-- Notificaciones
function appendNotification(text, type)
  if(text ~= '') then
      SendNUIMessage({
          action = 'true',
          type = 'show:interfaz:notification',
          data_notification = {
              text = ConvertLuaTextIntoHtml(text),
              type = type
          }
      })
  end
end

function ConvertLuaTextIntoHtml(text)
  text = text:gsub("~r~", "<span style=Color:red;>") 
  text = text:gsub("~b~", "<span style='Color:rgb(0, 213, 255);'>")
  text = text:gsub("~f~", "<span style='Color:rgb(4, 69, 155);'>")
  text = text:gsub("~g~", "<span style='Color:rgb(0, 255, 68);'>")
  text = text:gsub("~y~", "<span style=Color:yellow;>")
  text = text:gsub("~p~", "<span style='Color:rgb(220, 0, 255);'>")
  text = text:gsub("~c~", "<span style=Color:grey;>")
  text = text:gsub("~m~", "<span style=Color:darkgrey;>")
  text = text:gsub("~u~", "<span style=Color:black;>")
  text = text:gsub("~o~", "<span style=Color:gold;>")
  text = text:gsub("~s~", "</span>")
  text = text:gsub("~w~", "</span>")
  text = text:gsub("~b~", "<b>")
  text = text:gsub("~n~", "<br>")
  text = text

  return text
end



-- local function convertText(text)
--     text = text:gsub("~r~", "<span style=Color:red;>") 
--     text = text:gsub("~b~", "<span style=Color:blue;>")
--     text = text:gsub("~g~", "<span style=Color:green;>")
--     text = text:gsub("~y~", "<span style=Color:yellow;>")
--     text = text:gsub("~p~", "<span style=Color:purple;>")
--     text = text:gsub("~c~", "<span style=Color:grey;>")
--     text = text:gsub("~m~", "<span style=Color:darkgrey;>")
--     text = text:gsub("~u~", "<span style=Color:black;>")
--     text = text:gsub("~o~", "<span style=Color:gold;>")
--     text = text:gsub("~s~", "</span>")
--     text = text:gsub("~w~", "</span>")
--     text = text:gsub("~b~", "<b>")
--     text = text:gsub("~n~", "<br>")
--     text = "<span>" .. text .. "</span>"
  
--     return text
--   end
  
--   function Notify(text, type, time)
--     if time < 5000 then
--       time = 5000
--     end
  
--     SendNUIMessage({
--       action = 'true',
--       type = 'show:interfaz:notification',
--       data_notification = {
--         text = convertText(text),
--         type = type,
--         time = time,
--         id = math.random(1, 99999999)
--       }
--       -- text = convertText(text),
--       -- type = type,
--       -- time = time,
--       -- id = math.random(1, 99999999)
--     })
--   end
  
--   exports('Notify', Notify)
  
  
  function GetMinimapAnchor()
    -- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
    -- 0.05 * ((safezone - 0.9) * 10)
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(false)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
  end

