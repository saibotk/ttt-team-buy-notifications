-- TTT TEAM EQUIPMENT BUY NOTIFICATION
-- MADE BY saibotk (tkindanight)

-- Create equip table for chache
local tbl = nil

local SafeTranslate = LANG.TryTranslation

-- Receive Callback
net.Receive( "ItemBought", function()

  -- Read sent information
  local ply = net.ReadEntity()
  local equipment = net.ReadString()
  local is_item = net.ReadBool()

  -- Copy equipment table
  if tbl == nil then
    tbl = GetEquipmentForRole( ply:GetRole() )
  end

  -- Set defaults
  local itemName = "Undefined"
  local itemMaterial = "entities/npc_kleiner.png"

  if is_item then
    for _, item in pairs( tbl ) do
      if item.id == tonumber( equipment ) and item.name and item.material then
        itemName = SafeTranslate(item.name)
        itemMaterial = item.material
        break
      end
    end
  else
    local item = weapons.GetStored( equipment )
    itemName = item.PrintName
    itemMaterial = item.Icon
  end

  -- Fallback to prevent errors
  if not itemName then itemName = "Undefined" end
  if not itemMaterial then itemMaterial = "entities/npc_kleiner.png" end

  -- Create notification GUI
  local notif = vgui.Create( "DNotify" )
  notif:SetPos( 15, 15 )
  notif:SetSize( 300, 74 )
  notif:SetLife( 4 )

  -- Create background panel
  local bg = vgui.Create( "DPanel", notif )
  bg:Dock(FILL)

  local bgColor = Color( 255, 0, 0 )
  if ply.GetRoleTable then
    bgColor = ply:GetRoleTable().DefaultColor
  elseif ply:IsTraitor() then
    bgColor = Color( 255, 0, 0 )
  elseif ply:IsDetective() then
    bgColor = Color( 0, 0, 255 )
  end
  bgColor.a = 240
  bg:SetBackgroundColor( bgColor )

  -- Add icon GUI element
  local img = vgui.Create( "DImage", bg )
  img:SetPos( 5, 5 )
  img:SetSize( 64, 64 )
  img:SetImage( itemMaterial )

  -- Add name label
  local lblPlayerNick = vgui.Create( "DLabel", bg )
  lblPlayerNick:SetPos( 80, 5 )
  lblPlayerNick:SetSize( 215, 32 )
  lblPlayerNick:SetText( ply:GetName() )
  lblPlayerNick:SetTextColor( Color( 255, 250, 250 ) )
  lblPlayerNick:SetFont( "Trebuchet24" )
  lblPlayerNick:SetWrap( false )

  -- Add item name label
  local lblItemName = vgui.Create( "DLabel", bg )
  lblItemName:SetPos( 80, 37 )
  lblItemName:SetSize( 215, 32 )
  lblItemName:SetText( itemName )
  lblItemName:SetTextColor( Color( 255, 250, 250 ) )
  lblItemName:SetFont( "HudHintTextLarge" )
  lblItemName:SetWrap( false )

  -- Add all to notification
  notif:AddItem( bg )
end )
