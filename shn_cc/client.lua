local loading = true
local id = GetPlayerServerId(PlayerId(-1))
local _data = {}

ESX = exports["es_extended"]:getSharedObject()

---------Komendy w grze---------
RegisterCommand("kp", function(source)
	SetNuiFocus(true, true)
	if source > 0 then
		id = source
	end
	SendNUIMessage({
		open = true,
	})
end, false)

RegisterCommand("DemoAddPoints", function(source, args)
	setData(args[1],args[2])
end, false)

------------CallBacki------------
--Zamyka UI w grze
RegisterNUICallback('CloseMenu', function()
	SetNuiFocus(false, false)

end)

--Wysyla informacje do UI w grze
RegisterNUICallback('GetData', function(data)

	if getCurrentlvl(data.class) == 3 then
		SendNUIMessage({
		open = true,
		class = data.class,
		lvl = 3,
		precent = 100
	})
	else
		SendNUIMessage({
			open = true,
			class = data.class,
			lvl = getCurrentlvl(data.class),
			precent = getDatalvl(data.class) * 100/Config.Classlvl[data.class][getCurrentlvl(data.class) + 1]
		})
	end
	
end)


--!dodac notifie (masz wybranego perka ktory wyklucza innego)
--[[ Ten callback wywolywany jest po wybraniu przez gracza jakiegos perka (jeszcze nie zaakceptowania go), 
	otzymuje nazwe klasy (jako string) i wywoluje funkcje getDatalvl ktora wyciaga wartosci z MySql (z tablei users kolumna kp),
	jezeli obie klasy zwroca wartosc 0 to wywolywana jest funckja setData, ktora DODAJE do poprzedniej wartosci nowa wartosc --]]
RegisterNUICallback('SetData', function(data)
	if data.class == "Charisma" then 
		if getDatalvl('Herbalist') == 0 and getDatalvl('Charisma') == 0  then
			setData("Charisma",1)
		end
	elseif data.class == "Herbalist" then
		if getDatalvl('Herbalist') == 0 and getDatalvl('Charisma') == 0  then
			setData("Herbalist",1)
		end
	elseif data.class == "Fitness" then
		if getDatalvl('Fitness') == 0 and getDatalvl('Strength') == 0  then
			setData("Fitness",1)
		end
	elseif data.class == "Strength" then
		if getDatalvl('Fitness') == 0 and getDatalvl('Strength') == 0  then
			setData("Strength",1)
		end
	elseif data.class == "Hacker" then
		if getDatalvl('Hacker') == 0 and getDatalvl('Daredevil') == 0  then
			setData("Hacker",1)
		end
	elseif data.class == "Daredevil" then
		if getDatalvl('Hacker') == 0 and getDatalvl('Daredevil') == 0  then
			setData("Daredevil",1)
		end
	elseif data.class == "Visitor" then
		if getDatalvl('Visitor') == 0 and getDatalvl('Profligacy') == 0  then
			setData("Visitor",1)
		end
	elseif data.class == "Profligacy" then
		if getDatalvl('Visitor') == 0 and getDatalvl('Profligacy') == 0  then
			setData("Profligacy",1)
		end
	end

	--Wysyla informacje do UI w grze
	if getCurrentlvl(data.class) == 3 then
		SendNUIMessage({
		open = true,
		class = data.class,
		lvl = 3,
		precent = 100
	})
	else
		SendNUIMessage({
			open = true,
			class = data.class,
			lvl = getCurrentlvl(data.class),
			precent = getDatalvl(data.class) * 100/Config.Classlvl[data.class][getCurrentlvl(data.class) + 1]
		})
	end
end)

--Funkcja setData DODAJE do poprzedniej wartosci nowa wartosc
function setData(class,point)
    TriggerServerEvent('setDataS',class, point, id)
end

--Eksport, z ktorego beda mogly korzystac inne skrypty spoza tego folderu
exports("AddData", function(class, points, ID)
	TriggerServerEvent('setDataS',class, point, ID)
end)

--Podobne do AddData, tylko ze zrobione dla uzytku z wewnatrz tego folderu
function addData(class,point)
    TriggerServerEvent('addDataS',class,point)
end


RegisterNetEvent('getData')
AddEventHandler('getData', function()
	TriggerServerEvent("getDataS", id)
end)

--Zwraca lvl (0, 1, 2 lub 3) na podstawie podanych w configu wartosci
function getCurrentlvl(data)
	if getDatalvl(data) >= Config.Classlvl[data][3] then
		return 3
	elseif getDatalvl(data) >= Config.Classlvl[data][2] then
		return 2
	elseif getDatalvl(data) >= Config.Classlvl[data][1] then
		return 1
	elseif getDatalvl(data) == 0 then
		return 0
	end
end

--Zwraca ilosc punktow danej klasy zapisana w bazie danych
function getDatalvl(class)	
	TriggerServerEvent("getDataS", id)
	loading = true

	while loading do
		Citizen.Wait(100)
		ESX.TriggerServerCallback("kp:getData", 
			function(dane) 
				_data = dane
				loading = false
		end)
	end
		local points = _data[class]	
		return points
end
