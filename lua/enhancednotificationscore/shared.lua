-------------------------------------------------------------------------------
--    ENHANCED NOTIFICATION FRAMEWORK
--    Copyright (C) 2017 saibotk (tkindanight)
-------------------------------------------------------------------------------
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------
if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("cl_init.lua")

	resource.AddFile("materials/vgui/ttt/tbn_ic_default")
end

do
	local initpath = SERVER and "enhancednotificationscore/init.lua" or "enhancednotificationscore/cl_init.lua"

	if not ENHANCED_NOTIFICATIONS then
		ENHANCED_NOTIFICATIONS = include(initpath)
	else
		local fwtoload = include(initpath)
		local fwtlver = fwtoload:GetVersion()
		local fwalver = ENHANCED_NOTIFICATIONS:GetVersion()
		local intfwvtl = tonumber(string.sub(fwtlver, 1, string.find(fwtlver, "%.", 1)) .. string.gsub(string.sub(fwtlver, string.find(fwtlver, "%.", 1) + 1), "%.", ""))
		local intfwval = tonumber(string.sub(fwalver, 1, string.find(fwalver, "%.", 1)) .. string.gsub(string.sub(fwalver, string.find(fwalver, "%.", 1) + 1), "%.", ""))

		if intfwval and intfwtl and intfwval < intfwvtl then
			ENHANCED_NOTIFICATIONS = include(initpath)
		end
	end

	print("Loaded ENHANCED NOTIFICATIONS FRAMEWORK v" .. ENHANCED_NOTIFICATIONS:GetVersion())
end
