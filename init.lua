local idHudText = 0
local idHudImage = 0
local imgSelect = 0
local f = 0 
local playerPos = 0
local entry = ""
local text = ""

local function processHud(result)
	for _,player in ipairs(minetest.get_connected_players()) do--hud_change broken
		if result < 39.99 then
			imgSelect="face_lowLag.jpg"
		elseif result >= 40 and result < 69.99 then
			imgSelect = "face_medLag.jpg"
		elseif result >= 70 and result < 99.99 then
			imgSelect = "face_highLag.jpg"
		elseif result >= 100 then
			imgSelect="face_lagExceeded.jpg"
			local f = io.open("log.txt","a+")
			playerPos = player:getpos()
			entry = minetest.serialize(tostring(os.date())..": "..tostring(player:get_player_name()).." exceeded average lag at "..playerPos["x"]..", "..playerPos["y"]..", "..playerPos["z"])
			text = text.."\n"..entry
			f:write(entry,"\n")
		end
		player:hud_remove(idHudText)
		player:hud_remove(idHudImage)
		idHudImage = player:hud_add({
			hud_elem_type = "image",
			position  = {x = 0.95,y = 0.05},
			text      = imgSelect,
			scale     = {x = 0.15,y = 0.15},
			alignment = {x = -1,y = 0},
		})
		idHudText = player:hud_add({--data saved even after death; using local will keep creating new instances
			hud_elem_type = "text",
			position      = {x = 0.90,y = 0.05},			
			text          = "Average lag: "..tostring(result).."%; Server staff:",
			alignment     = {x = -1,y = 0}, 
			scale         = {x = 100,y = 100},
			number        = 0xFFFFFF,
		})
	end
end

local name="singleplayer"
lagalert={}
minetest.register_chatcommand("laglog", {
    func = function(name)
        lagalert.show_to(name)
    end,
})

function lagalert.show_to(name)
	minetest.show_formspec(name, "lagalert:log", lagalert.get_formspec(name))
end

function lagalert.get_formspec(name)
	local formspec = {
        "size[15,10]",
        "real_coordinates[true]",
		"textarea[0.05,0.05;15,9;name;Lag Alert v0.4.7.1 Login Log. Warning! Data in this formspec will be erased upon disconnect.;", minetest.formspec_escape(text), "]"
    }
	return table.concat(formspec, "")
end

local diff = 0
local i = 0
local values = {}
local limit = 5--other values: 5,10,2;1-20
for j = 1,100 do
	values[j] = 0
end
local result = 0

minetest.register_on_leaveplayer(function(ObjectRef)
	io.close("log.txt")
end)

minetest.register_globalstep(function (dtime)	
	--diff = math.abs(incr2-incr1)
	diff = dtime
	i = i+1
	values[i] = diff
	if i == 100 then
		local sum = 0
		for a,b in pairs(values) do
			sum = sum+b	
		end
		i = 0
		result = (sum/limit)*100
		processHud(result)
	end			
end)
