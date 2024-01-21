local id = nil
local nigger = {}

ESX = exports["es_extended"]:getSharedObject()

--Zwraca Licke
function GetID(id)
	
    for k,v in ipairs(GetPlayerIdentifiers(id)) do
        if string.match(v, 'license:') then
            identifier = string.sub(v, 9)
            identifier = ("char1:"..identifier)
            break
        end
    end
    return identifier
end

--Nadpisuje tabele w bazie danych podanymi wartosciami (rownierz sprawdza czy dane istnieja dla danego gracza)
RegisterServerEvent("setDataS")
AddEventHandler("setDataS", function(class, point, id)
    nyger = GetID(id)
        MySQL.Async.fetchScalar('SELECT kp FROM users WHERE identifier = @identifier AND kp IS NOT NULL', {['@identifier'] = nyger}, 
            function(result)
                if result then
                    AddData(class, point, id)
                else
                    local kp = {
                        ["Charisma"] = 0,
                        ["Herbalist"] = 0,
                        ["Fitness"] = 0,
                        ["Strength"] = 0,
                        ["Hacker"] = 0,
                        ["Daredevil"] = 0,
                        ["Visitor"] = 0,
                        ["Profligacy"] = 0}
                    MySQL.Async.execute('UPDATE users SET kp = @kp WHERE identifier = @identifier', {['@kp'] = json.encode(kp), ['@identifier'] = nyger})
                    TriggerEvent("getDataS", id)
                end
        end)
end)

--[[Sprawdza czy dane istnieja dla danego gracza, jesli nie dodaje je z domyslnymi wartosciami, 
jesli tak to je wczytuje z bazy danych i wysyla dalej --]]
RegisterServerEvent("getDataS")
AddEventHandler("getDataS", function(id)
    nyger = GetID(id)
    local _data = {}
    MySQL.Async.fetchScalar('SELECT kp FROM users WHERE identifier = @identifier AND kp IS NOT NULL', {['@identifier'] = nyger}, 
        function(result)
            if result then
                MySQL.Async.fetchAll('SELECT kp FROM users WHERE identifier = @identifier AND kp IS NOT NULL', {['@identifier'] = nyger},
                function(result)
                    _data = json.decode(result[1].kp) 
                    ESX.RegisterServerCallback('kp:getData', 
                        function(source, cb, target)
                            cb(_data)
                    end)
                end)
            else
                TriggerEvent("setDataS", nil, nil, id)
            end
    end)
end)

--Zczytuje z bazy danych wartosci, dodaje do niej podane warosci i ja zwraca
function AddData(class, point, id)
    nyger = GetID(id)
    local _data = {}
    local nigger = {}
    MySQL.Async.fetchAll('SELECT kp FROM users WHERE identifier = @identifier AND kp IS NOT NULL', {['@identifier'] = nyger}, 
        function(result)
            if result then
                nigger = json.decode(result[1].kp)
                nigger[class] = nigger[class] + point
                MySQL.Async.execute('UPDATE users SET kp = @kp WHERE identifier = @identifier', {['@kp'] = json.encode(nigger), ['@identifier'] = nyger})
                TriggerEvent("getDataS", id)
            end
        end)
end
