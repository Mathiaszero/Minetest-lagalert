local idHudText = 0
local idHudImage = 0
local imgSelect = ""

local function processHud(result)
	if result < 39.99 then
		imgSelect="face_lowLag.jpg"
	elseif result >= 40 and result < 69.99 then
		imgSelect = "face_medLag.jpg"
	elseif result >= 70 and result < 99.99 then
		imgSelect = "face_highLag.jpg"
	elseif result >= 100 then
		imgSelect="face_lagExceeded.jpg"
	end
	for _,player in ipairs(minetest.get_connected_players()) do--hud_change broken
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

local diff = 0
local i = 0
local values = {}
local limit = 10--other values: 5
for j = 1,100 do
	values[j] = 0
end
local result = 0

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
