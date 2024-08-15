local core = 'cT-Interface' -- nil to use basic notifs, esx or qb if you use any frameworks
local coordsThread = false

if (core == 'esx') then 
    ESX = exports['es_extended']:getSharedObject()
elseif ( core == 'qb' ) then 
    QBCore = exports["qb-core"]:GetCoreObject()
end

RegisterCommand('coords', function() 
    OpenUI()
end)

RegisterCommand('activeCoordsScreen', function()
    coordsThread = not coordsThread
    initThread()
end)


function initThread()
    Citizen.CreateThread(function()
        while coordsThread do
            local getCoords = GetEntityCoords(PlayerPedId())
            DrawGenericText(string.format("~g~Coords~w~ ( X: %s Y: %s Z: %s H: %s )", getCoords.x, getCoords.y, getCoords.z, GetEntityHeading(PlayerPedId())))
            Citizen.Wait(0)
        end
    end)
end

function DrawGenericText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(8)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(5, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.30, 0.00)
end

function OpenUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "open",
        coords = getCoordsTable(),
    })
end

function getCoordsTable()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local coordFormats = {
        string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z),
        string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, heading),
        string.format("x = %.2f, y = %.2f, z = %.2f", coords.x, coords.y, coords.z),
        string.format("x = %.2f, y = %.2f, z = %.2f, h = %.2f", coords.x, coords.y, coords.z, heading),
        string.format("vec3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z),
        string.format("vec4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, heading)
    }

    return coordFormats
end

RegisterNUICallback('int', function(data)
    if (data.type == 'close') then
        SetNuiFocus(false, false)
    elseif (data.type == 'noti') then 
        calculteCoreAndSendNoti(data.msg)
    end
end)
  

function calculteCoreAndSendNoti(msg)

    if (core == 'esx') then 
        return ESX.ShowNotification('This is a test notification')
    end

    if (core == 'qb') then 
        return QBCore.Functions.Notify('This is a test notification')
    end

    if (core == 'cT-Interface') then 
        return exports["cT-Interface"]:Notify(msg, "success")
    end

    if (core == nil) then 
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        SetNotificationMessage('CHAR_SOCIAL_CLUB', 'CHAR_SOCIAL_CLUB', false, 4, "Notify", msg)
        DrawNotification(false, true)
    end

end
