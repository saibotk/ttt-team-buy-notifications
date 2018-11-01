-------------------------------------------------------------------------------
--    TTT team buy notifications
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

-- Create equip table for chache
local tbl = nil

-- Create notification framework
include("enhancednotificationscore/shared.lua")


hook.Add("PostGamemodeLoaded", "TTT_Buy_Notifications_Init", function()

	-- Receive Callback
	net.Receive("TEBN_ItemBought", function()
		local SafeTranslate = LANG.TryTranslation
		-- Read sent information
		local ply = net.ReadEntity()
		local equipment = net.ReadString()
		local is_item = net.ReadBool()

		-- Copy equipment table
		if tbl == nil then
			tbl = GetEquipmentForRole(TTT2 and ply:GetSubRole() or not TTT2 and ply:GetRole())
		end

		-- Set defaults
		local itemName = "Undefined"
		local itemMaterial = "entities/npc_kleiner.png"

		if is_item then
			for _, item in pairs(tbl) do
				if item.id == tonumber(equipment) and item.name and item.material then
					itemName = SafeTranslate(item.name)
					itemMaterial = item.material

					break
				end
			end
		else
			local item = weapons.GetStored(equipment)

			itemName = item.PrintName
			itemMaterial = item.Icon
		end

		-- Fallback to prevent errors
		if not itemName then itemName = "Undefined" end
		if not itemMaterial then itemMaterial = "entities/npc_kleiner.png" end

		local bgColor = Color(255, 0, 0)

		if TTT2 then
			bgColor = ply:GetSubRoleData().color
		elseif ply.GetRoleTable then
			bgColor = ply:GetRoleTable().DefaultColor
		elseif ply:IsTraitor() then
			bgColor = Color(255, 0, 0)
		elseif ply:IsDetective() then
			bgColor = Color(0, 0, 255)
		end

		bgColor.a = 240

		ENHANCED_NOTIFICATIONS:NewNotification({title = ply:GetName(), color = bgColor, subtext = itemName, image = itemMaterial})
	end)
end)
