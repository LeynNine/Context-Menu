--[[
addons/darkrpmodification/lua/darkrp_modules/contexmenuextension/cl_contexmenuextension.lua
--]]
local Menu = {}

Menu.founder = {"founder"}
Menu.superadmin = {"superadmin"}
Menu.admin 		= {"admin"}
Menu.moderator 	= {"moderator"}
Menu.dsadmin 	= {"dsadmin"}

local function Option(title, icon, cmd, check)
	table.insert(Menu, {title = title, icon = icon, cmd = cmd, check = check})
end

local function SubMenu(title, icon, func, check)
	table.insert(Menu, {title = title, icon = icon, func = func, check = check})
end

local function Spacer(check)
	table.insert(Menu, {check = check})
end

local function Request(title, text, func)
	return function()
		Derma_StringRequest(DarkRP.getPhrase(title) or title, DarkRP.getPhrase(text) or text, nil, function(s)
			func(s)
		end)
	end
end

local function isCP()
	return LocalPlayer():isCP()
end

local function isMayor()
	return LocalPlayer():isMayor()
end

local function isSuperAdmin()
	return table.HasValue(Menu.superadmin, LocalPlayer():GetUserGroup())
end

local function isAdmin()
	if table.HasValue(Menu.founder, LocalPlayer():GetUserGroup()) then
	return true
	elseif table.HasValue(Menu.superadmin, LocalPlayer():GetUserGroup()) then
	return true
	elseif table.HasValue(Menu.admin, LocalPlayer():GetUserGroup()) then
	return true
	elseif table.HasValue(Menu.moderator, LocalPlayer():GetUserGroup()) then
	return true
	elseif table.HasValue(Menu.helpman, LocalPlayer():GetUserGroup()) then
	return true
	elseif table.HasValue(Menu.tpman, LocalPlayer():GetUserGroup()) then
	return true
	elseif table.HasValue(Menu.dsadmin, LocalPlayer():GetUserGroup()) then
	return true
	elseif table.HasValue(Menu.king, LocalPlayer():GetUserGroup()) then
	return true
	else return false
	end
end

local function add(t)
	table.insert(Menu, t)
end

--[[-------------------------------------------------------
	CMD Start
---------------------------------------------------------]]

Option(REPORT_PLAYER, "icon16/flag_green.png", function(s)
    RunConsoleCommand("say", "!report", s)
end)

Spacer()

--Option("Список репортов", "icon16/zoom.png", function()
--	RunConsoleCommand("say", "!reportadmin")
--end, isAdmin)
--
--Option("Список варнов", "icon16/zoom.png", function()
--	RunConsoleCommand("say", "!warns")
--end, isAdmin)
--
--Option("Мини лог", "icon16/zoom.png", function()
--	RunConsoleCommand("say", "!logs")
--end, isAdmin)
--Option("История репортов", "icon16/zoom.png", function()
--	RunConsoleCommand("say", "!reporthistory")
--end, isAdmin)

--Spacer()

Option(C_LANGUAGE_ADMINMENU, "icon16/zoom.png", function()
	RunConsoleCommand("say", "!menu")
end, isAdmin)


Spacer(isAdmin)

--Option("СИСТЕМА УРОВНЕЙ", "icon16/key_go.png", function(s)
--    RunConsoleCommand("say", "!level", s)
--end)



--Option("Pointshop", "icon16/award_star_add.png", function(s)
--    RunConsoleCommand("say", "!pointshop", s)
--end)


--Option("Меню системы уровней F8", "icon16/rosette.png", function(s)
--    RunConsoleCommand("say", "!glevel", s)
--end)



--Option("Открыть карту", "icon16/map.png", function(s)
--    RunConsoleCommand("say", "/gmaps", s)
--end)

Spacer()

Option("Бросить кости", "icon16/controller_add.png", function(s)
    RunConsoleCommand("say", "/roll", s)
end)

Option(C_LANGUAGE_MONEY_DROP, "icon16/money_delete.png", Request(C_LANGUAGE_MONEY_DROP, C_LANGUAGE_ENTER_AMOUNT, function(s)
	RunConsoleCommand("darkrp", "dropmoney", s)
end))

Option(C_LANGUAGE_MONEY_GIVE, "icon16/money_add.png", Request(C_LANGUAGE_MONEY_GIVE, C_LANGUAGE_ENTER_AMOUNT, function(s)
	RunConsoleCommand("darkrp", "give", s)
end))

--SubMenu(C_LANGUAGE_MONEY_CHEQUE, "icon16/report_edit.png", function(self)
--	for k, v in pairs(player.GetAll()) do
--		if v == LocalPlayer() then continue end
--			self:AddOption(v:Name(), Request(C_LANGUAGE_MONEY_CHEQUE, C_LANGUAGE_ENTER_AMOUNT, function(s) 
--				RunConsoleCommand("darkrp", "cheque", v:UserID(), s)
--			end)):SetColor(v:getJobTable().color)
--	end
--end)

Spacer()

--Option(CALL_911, "icon16/stop.png", function(s)
--    RunConsoleCommand("say", "!911", s)
--end)
Option(CALL_LAWS, "icon16/date_error.png", function(s)
    RunConsoleCommand("say", "/laws", s)
end)
Spacer()

Option(C_LANGUAGE_DROP, "icon16/gun.png", function()
	RunConsoleCommand("darkrp", "dropweapon")
end)

Option(C_LANGUAGE_REQUEST_LICENSE, "icon16/page_add.png", function()
	RunConsoleCommand("darkrp", "requestlicense")
end)

Option(C_LANGUAGE_WRITE, "icon16/book_edit.png", Request(C_LANGUAGE_WRITE, C_LANGUAGE_WRITE_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "write", s)
end))

Spacer()

Option(C_LANGUAGE_RPNAME, "icon16/user_edit.png", Request(C_LANGUAGE_RPNAME, C_LANGUAGE_RPNAME_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "rpname", s)
end))

Option(C_LANGUAGE_CUSTOM_JOB, "icon16/user_add.png", Request(C_LANGUAGE_CUSTOM_JOB, C_LANGUAGE_CUSTOM_JOB_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "job", s)
end))

SubMenu(C_LANGUAGE_DEMOTE, "icon16/user_delete.png", function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		self:AddOption(v:Name(), Request(C_LANGUAGE_DEMOTE, C_LANGUAGE_ENTER_REASON, function(s) 
			RunConsoleCommand("darkrp", "demote", v:UserID(), s)
		end)):SetColor(v:getJobTable().color)
	end
end)

Option(C_LANGUAGE_UNOWN_ALL, "icon16/door.png", function()
	RunConsoleCommand("darkrp", "unownalldoors")
end)


Spacer(isCP)

Option(C_LANGUAGE_GIVE_LICENSE, "icon16/script.png", function(self)
	RunConsoleCommand("darkrp", "givelicense")
end, function()
	local ply = LocalPlayer()
	local noMayorExists = fn.Compose{fn.Null, fn.Curry(fn.Filter, 2)(ply.isMayor), player.GetAll}
	local noChiefExists = fn.Compose{fn.Null, fn.Curry(fn.Filter, 2)(ply.isChief), player.GetAll}

	local canGiveLicense = fn.FOr{
		ply.isMayor,
		fn.FAnd{ply.isChief, noMayorExists},
		fn.FAnd{ply.isCP, noChiefExists, noMayorExists}
	}

	return canGiveLicense(ply)
end)

SubMenu(C_LANGUAGE_WANTED, "icon16/add.png", function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		if !v:isWanted() then
			self:AddOption(v:Name(), Request(C_LANGUAGE_WANTED, C_LANGUAGE_ENTER_REASON, function(s) 
				RunConsoleCommand("darkrp", "wanted", v:UserID(), s)
			end)):SetColor(v:getJobTable().color)
		end
	end
end, isCP)

SubMenu(C_LANGUAGE_UNWANTED, "icon16/delete.png", function(self)
	for k, v in pairs(player.GetAll()) do
		if v:isWanted() then
			self:AddOption(v:Name(), function() RunConsoleCommand("darkrp", "unwanted", v:UserID(), s) end):SetColor(v:getJobTable().color)
		end
	end
end, isCP)

SubMenu(C_LANGUAGE_WARRANT, "icon16/briefcase.png", function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		self:AddOption(v:Name(), Request(C_LANGUAGE_WARRANT, C_LANGUAGE_ENTER_REASON, function(s) 
			if v == nil or s == nil then return end
			RunConsoleCommand("darkrp", "warrant", v:UserID(), s)
		end)):SetColor(v:getJobTable().color)
	end
end, isCP)

Spacer(function() return LocalPlayer():isMayor() end)

Option(C_LANGUAGE_LOCKDOWN, "icon16/tick.png", function(s)
	RunConsoleCommand("darkrp", "lockdown")
end, isMayor)

Option(C_LANGUAGE_UNLOCKDOWN, "icon16/cross.png", function(s)
	RunConsoleCommand("darkrp", "unlockdown")
end, isMayor)

Option("Оповещение городу", "icon16/sound.png",
    Request("Оповещение городу", "Введите сообщение", function(s)
        RunConsoleCommand("say", "/broadcast " .. s)
    end),
function() return LocalPlayer():isMayor() end)

Option(C_LANGUAGE_PLACELAWS, "icon16/application_form.png", function(s)
	RunConsoleCommand("darkrp", "placelaws")
end, isMayor)

Option(C_LANGUAGE_ADDLAW, "icon16/application_form_add.png", Request(C_LANGUAGE_ADDLAW, C_LANGUAGE_ADDLAW_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "addlaw", s)
end), isMayor)

Option(C_LANGUAGE_REMOVELAW, "icon16/application_form_delete.png", Request(C_LANGUAGE_REMOVELAW, C_LANGUAGE_REMOVELAW_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "removelaw", s)
end), isMayor)

--[[
Option(C_LANGUAGE_BROADCAST, "icon16/ipod_cast.png", Request(C_LANGUAGE_BROADCAST, C_LANGUAGE_BROADCAST_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "broadcast", s)
end), isMayor)

Option(C_LANGUAGE_AGENDA, "icon16/application.png", Request(C_LANGUAGE_AGENDA, C_LANGUAGE_AGENDA_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "agenda", s)
end), function()
	for k, v in pairs(DarkRPAgendas) do
		if type(v.Manager) == "table" then
			if table.HasValue(v.Manager, LocalPlayer():Team()) then
				return true
			end
		elseif v.Manager == LocalPlayer():Team() then
			return true
		end
	end
end)
]]
--[[-------------------------------------------------------
	CMD End
---------------------------------------------------------]]

local menu
hook.Add("OnContextMenuOpen", "CMenuOnContextMenuOpen", function()
	if not g_ContextMenu:IsVisible() then
		local orig = g_ContextMenu.Open
		g_ContextMenu.Open = function(self, ...)
			self.Open = orig
			orig(self, ...)

			menu = vgui.Create("CMenuExtension")
			menu:SetDrawOnTop(false)

			for k, v in pairs(Menu) do
				if not v.check or v.check() then
					if v.cmd then
						menu:AddOption(v.title, isfunction(v.cmd) and v.cmd or function() RunConsoleCommand(v.cmd) end):SetImage(v.icon)
					elseif v.func then
						local m, s = menu:AddSubMenu(v.title)
						if m == nil then return end
						if s == nil then return end
						s:SetImage(v.icon)
						v.func(m)
					else
						menu:AddSpacer()
					end
				end
			end

			menu:Open()
			menu:CenterHorizontal()
			menu.y = ScrH()
			menu:MoveTo(menu.x, ScrH() - menu:GetTall() - 8, .1, 0)
			menu:MakePopup()
		end
	end
end)

hook.Add( "CloseDermaMenus", "CMenuCloseDermaMenus", function()
	if menu && menu:IsValid() then
		menu:MakePopup()
	end
end)

hook.Add("OnContextMenuClose", "CMenuOnContextMenuClose", function()
	menu:Remove()
end)


local PANEL = {}

AccessorFunc( PANEL, "m_bBorder", 			"DrawBorder" 	)
AccessorFunc( PANEL, "m_bDeleteSelf", 		"DeleteSelf" 	)
AccessorFunc( PANEL, "m_iMinimumWidth", 	"MinimumWidth" 	)
AccessorFunc( PANEL, "m_bDrawColumn", 		"DrawColumn" 	)
AccessorFunc( PANEL, "m_iMaxHeight", 		"MaxHeight" 	)
AccessorFunc( PANEL, "m_pOpenSubMenu", 		"OpenSubMenu" 	)

function PANEL:Init()

	self:SetIsMenu( true )
	self:SetDrawBorder( true )
	self:SetPaintBackground( true )
	self:SetMinimumWidth( 100 )
	self:SetDrawOnTop( true )
	self:SetMaxHeight( ScrH() * 0.9 )
	self:SetDeleteSelf( true )
	self:SetPadding( 0 )
	RegisterDermaMenuForClose( self )
	
end

function PANEL:AddPanel( pnl )

	self:AddItem( pnl )
	pnl.ParentMenu = self
	
end

function PANEL:AddOption( strText, funcFunction )

	local pnl = vgui.Create( "DMenuOption", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	
	self:AddPanel( pnl )
	
	return pnl

end

function PANEL:AddCVar( strText, convar, on, off, funcFunction )

	local pnl = vgui.Create( "DMenuOptionCVar", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end

	pnl:SetConVar( convar )
	pnl:SetValueOn( on )
	pnl:SetValueOff( off )

	self:AddPanel( pnl )

	return pnl

end

function PANEL:AddSpacer( strText, funcFunction )

	local pnl = vgui.Create( "DPanel", self )
	pnl.Paint = function( p, w, h )
		derma.SkinHook( "Paint", "MenuSpacer", p, w, h )
	end

	pnl:SetTall( 1 )
	self:AddPanel( pnl )

	return pnl

end

function PANEL:AddSubMenu( strText, funcFunction )

	local pnl = vgui.Create( "DMenuOption", self )
	local SubMenu = pnl:AddSubMenu( strText, funcFunction )

	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end

	self:AddPanel( pnl )

	return SubMenu, pnl

end

function PANEL:Hide()

	local openmenu = self:GetOpenSubMenu()
	if ( openmenu ) then
		openmenu:Hide()
	end
	
	self:SetVisible( false )
	self:SetOpenSubMenu( nil )
	
end

function PANEL:OpenSubMenu( item, menu )

	local openmenu = self:GetOpenSubMenu()
	if ( IsValid( openmenu ) ) then

		if ( menu && openmenu == menu ) then return end

		self:CloseSubMenu( openmenu )
		
	end

	if ( !IsValid( menu ) ) then return end

	local x, y = item:LocalToScreen( self:GetWide(), 0 )
	menu:Open( x - 3, y, false, item )

	self:SetOpenSubMenu( menu )

end

function PANEL:CloseSubMenu( menu )

	menu:Hide()
	self:SetOpenSubMenu( nil )

end

function PANEL:Paint( w, h )

	if ( !self:GetPaintBackground() ) then return end

	derma.SkinHook( "Paint", "Menu", self, w, h )
	return true

end

function PANEL:ChildCount()
	return #self:GetCanvas():GetChildren()
end

function PANEL:GetChild( num )
	return self:GetCanvas():GetChildren()[ num ]
end

function PANEL:PerformLayout()

	local w = self:GetMinimumWidth()

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
	
		pnl:PerformLayout()
		w = math.max( w, pnl:GetWide() )
	
	end

	self:SetWide( w )
	
	local y = 0
	
	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
	
		pnl:SetWide( w )
		pnl:SetPos( 0, y )
		pnl:InvalidateLayout( true )
		
		y = y + pnl:GetTall()
	
	end
	
	y = math.min( y, self:GetMaxHeight() )
	
	self:SetTall( y )

	derma.SkinHook( "Layout", "Menu", self )
	
	DScrollPanel.PerformLayout( self )

end

function PANEL:Open( x, y, skipanimation, ownerpanel )

	RegisterDermaMenuForClose( self )

	local maunal = x && y

	x = x or gui.MouseX()
	y = y or gui.MouseY()

	local OwnerHeight = 0
	local OwnerWidth = 0

	if ( ownerpanel ) then
		OwnerWidth, OwnerHeight = ownerpanel:GetSize()
	end

	self:PerformLayout()

	local w = self:GetWide()
	local h = self:GetTall()

	self:SetSize( w, h )

	if ( y + h > ScrH() ) then y = ( ( maunal && ScrH() ) or ( y + OwnerHeight ) ) - h end
	if ( x + w > ScrW() ) then x = ( ( maunal && ScrW() ) or x ) - w end
	if ( y < 1 ) then y = 1 end
	if ( x < 1 ) then x = 1 end

	self:SetPos( x, y )
	self:MakePopup()
	self:SetVisible( true )
	self:SetKeyboardInputEnabled( false )

end

function PANEL:OptionSelectedInternal( option )

	self:OptionSelected( option, option:GetText() )

end

function PANEL:OptionSelected( option, text ) end

function PANEL:ClearHighlights()

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		pnl.Highlight = nil
	end

end

function PANEL:HighlightItem( item )

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		if ( pnl == item ) then
			pnl.Highlight = true
		end
	end

end

derma.DefineControl( "CMenuExtension", "A Menu", PANEL, "DScrollPanel" )


