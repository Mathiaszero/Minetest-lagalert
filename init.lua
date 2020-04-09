--credits to SwissalpS for original mod

local samples=0
local incr1=0
local incr2=0
local diff=0
local bool=0
local i=0
local values={}
local limit= 10--other values: 5
for j=1,100 do
	values[j]=0
end

minetest.register_globalstep(function (dtime)
	if bool==0 then
		bool=1
		incr1=os.clock()
	elseif bool==1 then
		bool=0
		incr2=os.clock()
	end
	diff=math.abs(incr2-incr1)
	i=i+1
	values[i]=diff
	if i==100 then
		local sum=0
		for a,b in pairs(values) do
			sum=sum+b	
		end
		i=0
		if (sum/10)*100<100 then
			minetest.chat_send_all(tostring((sum/10)*100).."%")
		elseif (sum/10)*100>=100 then
			minetest.chat_send_all("!!!Alert!!! "..tostring((sum/10)*100).."%".." !!!Alert!!!")
		end
	end			
end)

