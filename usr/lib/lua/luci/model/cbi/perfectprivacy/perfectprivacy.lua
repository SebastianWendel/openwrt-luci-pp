--[[
LuCI - Lua Configuration Interface

Copyright 2012 Frank Schiebel <frank@linuxmuster.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

local is_mini = (luci.dispatcher.context.path[1] == "mini")

m = Map("perfectprivacy", translate("Perfect Privacy"),
	translate("Perfect Privacy allow you to connct to a VPN server via openvn"))

s = m:section(TypedSection, "service", "")
s.addremove = false
s.anonymous = false

s:option(Flag, "enabled", translate("Enable"))
s:option(Flag, "persistent", translate("Persistent"))
s:option(Value, "check_interval", translate("Check for changed configuration every ... seconds")).default = 300
	

svc = s:option(ListValue, "server_name", translate("Server"))
svc.rmempty = false

local services = { }
local fd = io.open("/usr/lib/perfectprivacy/servers", "r")
if fd then
	local ln
	repeat
		ln = fd:read("*l")
--[[		local s = ln and ln:match('^%s*"([^"]+)"') ]]--
		local s = ln
		if s then services[#services+1] = s end
	until not ln
	fd:close()
end

local v
for _, v in luci.util.vspairs(services) do
	svc:value(v)
end

function svc.cfgvalue(...)
	local v = Value.cfgvalue(...)
	if not v or #v == 0 then
		return "-"
	else
		return v
	end
end

function svc.write(self, section, value)
	if value == "-" then
		m.uci:delete("perfectprivacy", section, self.option)
	else
		Value.write(self, section, value)
	end
end

svc:value("-", "-- "..translate("custom").." --")

s:option(Value, "username", translate("Username")).rmempty = true
pw = s:option(Value, "password", translate("Password"))
pw.rmempty = true
pw.password = true


return m
