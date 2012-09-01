--[[
LuCI - Lua Configuration Interface

Copyright 2012 Frank Schiebel <frank@linuxmuster.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

]]--

module("luci.controller.perfectprivacy", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/perfectprivacy") then
		return
	end
	
	local page

	page = entry({"admin", "services", "perfectprivacy"}, cbi("perfectprivacy/perfectprivacy"), _("Perfect Privacy"), 60)
	page.i18n = "perfectprivacy"
	page.dependent = true

	page = entry({"mini", "network", "perfectprivacy"}, cbi("perfectprivacy/perfectprivacy", {autoapply=true}), _("Perfect Privacy"), 60)
	page.i18n = "perfectprivacy"
	page.dependent = true
end
