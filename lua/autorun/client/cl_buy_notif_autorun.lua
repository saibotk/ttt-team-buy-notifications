-------------------------------------------------------------------------------
--    TTT team buy notifications
--    Copyright (C) 2017-2019 saibotk (tkindanight)
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
local tbl

-- Save last Role
local role

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


		local curRole = (TTT2 and ply:GetSubRole()) or (not TTT2 and ply:GetRole())

		-- Copy equipment table
		if tbl == nil or role ~= curRole then
			if TTT2 and MSTACK.AddColoredImagedMessage then
				-- new TTT2 Update changed this
				tbl = GetEquipmentForRole(ply, curRole, true)
			else
				tbl = GetEquipmentForRole(curRole)
			end
			role = curRole
		end

		-- Set defaults
		local itemName = "Undefined"
		local itemMaterial = "entities/npc_kleiner.png"

		if is_item then
			for _, item in pairs(tbl) do
				if TTT2 and item.id == equipment or not TTT2 and item.id == tonumber(equipment) then
					itemName = SafeTranslate(item.name or item.EquipMenuData.name) or item.id
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
		if not itemName then
			itemName = "Undefined"
		end

		if not itemMaterial then
			itemMaterial = "entities/npc_kleiner.png"
		end

		local bgColor = Color(255, 0, 0)

		if TTT2 then
			bgColor = ply:GetRoleColor()
		elseif ply.GetRoleTable then
			bgColor = ply:GetRoleTable().DefaultColor
		elseif ply:IsTraitor() then
			bgColor = Color(255, 0, 0)
		elseif ply:IsDetective() then
			bgColor = Color(0, 0, 255)
		end

		bgColor.a = 240

		if TTT2 and MSTACK.AddColoredImagedMessage then
			local message = "bought „" .. itemName .. "“"
			local mat = Material(itemMaterial)
			MSTACK:AddImagedMessage(message, mat, ply:GetName())
		else
			ENHANCED_NOTIFICATIONS:NewNotification({title = ply:GetName(), color = bgColor, subtext = itemName, image = itemMaterial})
		end

		chat.AddText(Color(255, 255, 255), ply:GetName(), Color(200, 200, 200), " bought ", Color(255, 255, 255), itemName)
	end)
end)
