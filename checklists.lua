local categories = {}
local dsl = {}

dsl.tasks = function(name)
	return function(list)
		list.name = name
		return list
	end
end

dsl.category = function(name)
	if categories[name] == nil then
		categories[name] = {}
	end
	local mycat = categories[name]
	return function(tasklists)
		for _, tasklist in ipairs(tasklists) do
			local listname = tasklist.name
			tasklist.name = nil
			if mycat[listname] == nil then
				mycat[listname] = tasklist
			else
				local mylist = mycat[listname]
				for _, item in ipairs(tasklist) do
					table.insert(mylist, item)
				end
			end
		end
	end

			
