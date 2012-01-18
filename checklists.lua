--[[ Checklist Specification Language ]]
--[[
            Copyright Ryan Pavlik 2011-2012.
Distributed under the Boost Software License, Version 1.0.
    (See accompanying file LICENSE_1_0.txt or copy at
          http://www.boost.org/LICENSE_1_0.txt)
]]

local markdown
pcall(function() markdown = require "markdown" end)

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
end

checklists = {}

checklists.load = function(fn)
	local component = assert(loadfile(fn))
	setfenv(component, dsl)
	component()
end

checklists.to_markdown = function()
	local ret = {}
	for cat, contents in pairs(categories) do
		table.insert(ret, "# " .. cat)
		table.insert(ret, "\n")
		for tasklistname, t in pairs(contents) do
			table.insert(ret, "## " .. tasklistname)
			table.insert(ret, "\n")
			for _, task in ipairs(t) do
				table.insert(ret, "- " .. task)
				table.insert(ret, "\n")
			end
		end
	end
	return table.concat(ret, "\n")
end

if markdown then
	checklists.to_html = function()
		return markdown(checklists.to_markdown())
	end
end

return checklists
