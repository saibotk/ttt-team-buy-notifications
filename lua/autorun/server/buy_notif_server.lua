-- TTT TEAM EQUIPMENT BUY NOTIFICATION
-- MADE BY saibotk (tkindanight)
local buyNotificationEnabled = CreateConVar("ttt_buy_notification","1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should TTT Buy Notifications be active?"):GetBool()
util.AddNetworkString("ItemBought")

local function SendBoughtNotif(ply_o, equipment, is_item)
  if not buyNotificationEnabled then return end
  -- Get player role and find other teammembers
  local teammembers = {}
  for _, ply in pairs( player.GetAll() ) do
    -- Added Compat for TTT Totem by GamefreakDE
     if IsValid( ply ) and ply:IsActive() and ( ( ply.GetTeam and ply:GetTeam() == ply_o:GetTeam() and not ply_o:GetDetective() ) or ( ply:GetRole() == ply_o:GetRole() ) ) and ply != ply_o then
        table.insert(teammembers, ply)
     end
  end

  -- Send net message to teammembers to display the information
  net.Start("ItemBought")
  net.WriteEntity(ply_o)
  net.WriteString(equipment)
  net.WriteBool(is_item)
  net.Send(teammembers)

end
hook.Add("TTTOrderedEquipment", "SendBoughtNotification", SendBoughtNotif)
