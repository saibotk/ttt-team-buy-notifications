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

-- Create notification framework
include("enhancednotificationscore/shared.lua")

local buyNotificationEnabledVar = CreateConVar("ttt_buy_notification", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should TTT Buy Notifications be active?")
local buyNotificationDebugVar = CreateConVar("ttt_buy_notification_debug", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Should TTT Buy Notifications DEBUG MODE be active?")

util.AddNetworkString("TEBN_ItemBought")

local function SendBoughtNotif(ply_o, equipment, is_item)
	if not buyNotificationEnabledVar:GetBool() then return end

	-- Get player role and find other teammembers
	local teammembers = {}

	for _, ply in pairs(player.GetAll()) do
		-- Added Compat for TTT Totem by GamefreakDE
		-- Added Compat for TTT2 by Alf21
		if IsValid(ply) and ply:IsActive() and ply:IsSpecial() and ply_o:IsSpecial() and (buyNotificationDebugVar:GetBool() or ply ~= ply_o) and (
			TTT2 and ply:IsInTeam(ply_o) and not ply:GetSubRoleData().unknownTeam
			or not TTT2 and (ply.GetTeam and ply:GetTeam() == ply_o:GetTeam() or ply:GetRole() == ply_o:GetRole())
		) then
			table.insert(teammembers, ply)
		end
	end

	-- Send net message to teammembers to display the information
	net.Start("TEBN_ItemBought")
	net.WriteEntity(ply_o)
	net.WriteString(equipment)
	net.WriteBool(is_item)
	net.Send(teammembers)
end
hook.Add("TTTOrderedEquipment", "SendBoughtNotification", SendBoughtNotif)
