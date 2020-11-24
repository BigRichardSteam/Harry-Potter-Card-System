function CreatePanel( Parent, sx, sy, posx, posy, backcolor, scroll, bar, grip, btn)
	
	Parent = Parent or ""
	sx = sx or 100
	sy = sy or 100
	backcolor = backcolor or Color(35, 35, 35, 255)
	posx = posx or 0
	posy = posy or 0
	scroll = scroll or false
	bar = bar or Color( 30, 30, 30 )
	grip = grip or Color( 0, 140, 208 )
	btn = btn or Color( 4,95,164 )
	
	local typ = "DPanel"
	if scroll then
		typ = "DScrollPanel"
	else
		typ = "DPanel"
	end
	
	local Panel = vgui.Create(typ, Parent)
		Panel:SetSize(sx,sy)
		Panel:SetPos(posx,posy)
		Panel.Paint = function(s , w , h)
			draw.RoundedBox(0,0,0,w , h, backcolor)
		end
		
	if typ == "DScrollPanel" then
	
		local sbar = Panel:GetVBar()
	
		function sbar:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, bar )
		end
		
		function sbar.btnUp:Paint( w, h )
			draw.SimpleText( "▲", HogwartsConfig.FontOne, -3, -4, btn )
		end
		
		function sbar.btnDown:Paint( w, h )
			draw.SimpleText( "▼", HogwartsConfig.FontOne, -3, -4, btn )
		end
		
		function sbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, grip )
		end
	end
		
	return Panel
	
end

local BackgroundHog = Material( "materials/background_hogwarts.jpg" )


function OpenMenuBuyFrogs( CardsTable )

	local CardsTable = CardsTable
	
	local FramePrincipal = vgui.Create( "DFrame" )
		FramePrincipal:SetSize( ScrW(), ScrH() )
		FramePrincipal:SetPos( 0,0 )
		FramePrincipal:SetTitle( "" )
		FramePrincipal:SetDraggable( false )
		FramePrincipal:ShowCloseButton( false )
		FramePrincipal:MakePopup()
		FramePrincipal.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( BackgroundHog )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end
	
	local CloseButton = vgui.Create("DButton", FramePrincipal)
		CloseButton:SetPos(ScrW() - 70 - 20, 20)
		CloseButton:SetSize(70,30)
		CloseButton:SetText("Close")
		CloseButton:SetFont(HogwartsConfig.FontOne)
		CloseButton.Paint = function(s , w , h)
			draw.RoundedBox(3,0,0,w , h,Color(255,255,255,100))
		end
		function CloseButton:DoClick()
			FramePrincipal:Close()
		end
	
	local FrogLogo = vgui.Create("DButton", FramePrincipal)
		FrogLogo:SetPos(ScrW()- 156/2 - 20,70 )
		FrogLogo:SetSize(156/2,109/2)
		FrogLogo:SetText("")
		local imgfrog = Material(HogwartsConfig.FrogImg)
		FrogLogo.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( imgfrog )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end

	local Label1 = vgui.Create("DLabel", FramePrincipal)
		Label1:SetPos( ScrW()- 156/2 - 20 - 156/2 - 156/2 - 30,80 )
		Label1:SetSize( 200, 30 )
		Label1:SetWrap( false )
		Label1:SetTextColor(Color(255,255,255))
		Label1:SetFont(HogwartsConfig.FontOne)
		Label1:SetText( LocalPlayer():GetNWInt("Frogs").." chocolate frog(s)" )
	
	local ReturnButton = vgui.Create("DButton", FramePrincipal)
		ReturnButton:SetPos(ScrW()- 170, 70+50+20 )
		ReturnButton:SetSize(150,50)
		ReturnButton:SetText("See cards")
		ReturnButton:SetTextColor(Color(80,80,80))
		ReturnButton:SetFont(HogwartsConfig.FontOne)
		ReturnButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(0,161,255) )
		end
		function ReturnButton:DoClick()
			FramePrincipal:Close()
			OpenMenuCards( CardsTable )
		end
	
	local RedeemButton = vgui.Create("DButton", FramePrincipal)
		RedeemButton:SetPos(ScrW()- 170, 70+50+20+70 )
		RedeemButton:SetSize(150,50)
		RedeemButton:SetText("Redeem frogs")
		RedeemButton:SetTextColor(Color(80,80,80))
		RedeemButton:SetFont(HogwartsConfig.FontOne)
		RedeemButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(0,161,255) )
		end
		function RedeemButton:DoClick()
			FramePrincipal:Close()
			OpenMenuRedeemCards( CardsTable )
		end

	local FrogLogo10 = vgui.Create("DButton", FramePrincipal)
		FrogLogo10:SetPos(ScrW()/4-140,ScrH()/4+50)
		FrogLogo10:SetSize(156,109)
		FrogLogo10:SetText("")
		local frogimg2 = Material(HogwartsConfig.FrogImg)
		FrogLogo10.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( frogimg2 )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end
	
	local Label2 = vgui.Create("DLabel", FramePrincipal)
		Label2:SetPos( ScrW()/4-100,ScrH()/4+200 )
		Label2:SetSize( 200, 50 )
		Label2:SetWrap( false )
		Label2:SetTextColor(Color(255,255,255))
		Label2:SetFont(HogwartsConfig.FontOne)
		Label2:SetText( "10 frogs : \n  "..HogwartsConfig.Price10Frogs.." "..HogwartsConfig.TypeOfMoney )
		
	local Buy10FrogsButton = vgui.Create("DButton", FramePrincipal)
		Buy10FrogsButton:SetPos( ScrW()/4-120,ScrH()/4+200 + 80 )
		Buy10FrogsButton:SetSize(130,40)
		Buy10FrogsButton:SetText("Buy")
		Buy10FrogsButton:SetTextColor(Color(255,255,255))
		Buy10FrogsButton:SetFont(HogwartsConfig.FontOne)
		Buy10FrogsButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(205, 127, 50) )
		end
		function Buy10FrogsButton:DoClick()
			net.Start("BuyFrogs")
				net.WriteInt(1, 32)
			net.SendToServer()
			FramePrincipal:Close()
			OpenMenuBuyFrogs( CardsTable )
		end
	
	local FrogLogo30 = vgui.Create("DButton", FramePrincipal)
		FrogLogo30:SetPos(ScrW()-ScrW()/4-140,ScrH()/4+50)
		FrogLogo30:SetSize(156,109)
		FrogLogo30:SetText("")
		FrogLogo30.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( frogimg2 )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end

	local Buy30FrogsButton = vgui.Create("DButton", FramePrincipal)
		Buy30FrogsButton:SetPos( ScrW()-ScrW()/4-115,ScrH()/4+200 + 80 )
		Buy30FrogsButton:SetSize(130,40)
		Buy30FrogsButton:SetText("Buy")
		Buy30FrogsButton:SetTextColor(Color(255,255,255))
		Buy30FrogsButton:SetFont(HogwartsConfig.FontOne)
		Buy30FrogsButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(212, 175, 55) )
		end
		function Buy30FrogsButton:DoClick()
			net.Start("BuyFrogs")
				net.WriteInt(3, 32)
			net.SendToServer()
			FramePrincipal:Close()
			OpenMenuBuyFrogs( CardsTable )
		end
	
	local Label3 = vgui.Create("DLabel", FramePrincipal)
		Label3:SetPos( ScrW()-ScrW()/4-80,ScrH()/4+200 )
		Label3:SetSize( 200, 50 )
		Label3:SetWrap( false )
		Label3:SetTextColor(Color(255,255,255))
		Label3:SetFont(HogwartsConfig.FontOne)
		Label3:SetText( "30 frogs : \n  "..HogwartsConfig.Price30Frogs.." "..HogwartsConfig.TypeOfMoney )
		
	local FrogLogo20 = vgui.Create("DButton", FramePrincipal)
		FrogLogo20:SetPos(ScrW()/2-120,ScrH()/4+50)
		FrogLogo20:SetSize(156,109)
		FrogLogo20:SetText("")
		FrogLogo20.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( frogimg2 )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end
	
	local Buy20FrogsButton = vgui.Create("DButton", FramePrincipal)
		Buy20FrogsButton:SetPos( ScrW()/2-100,ScrH()/4+200 + 80 )
		Buy20FrogsButton:SetSize(130,40)
		Buy20FrogsButton:SetText("Buy")
		Buy20FrogsButton:SetTextColor(Color(255,255,255))
		Buy20FrogsButton:SetFont(HogwartsConfig.FontOne)
		Buy20FrogsButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(204, 204, 204) )
		end
		function Buy20FrogsButton:DoClick()
			net.Start("BuyFrogs")
				net.WriteInt(2, 32)
			net.SendToServer()
			FramePrincipal:Close()
			OpenMenuBuyFrogs( CardsTable )
		end
	
	local Label4 = vgui.Create("DLabel", FramePrincipal)
		Label4:SetPos( ScrW()/2-80,ScrH()/4+200 )
		Label4:SetSize( 200, 50 )
		Label4:SetWrap( false )
		Label4:SetTextColor(Color(255,255,255))
		Label4:SetFont(HogwartsConfig.FontOne)
		Label4:SetText( "20 frogs : \n  "..HogwartsConfig.Price20Frogs.." "..HogwartsConfig.TypeOfMoney )
	
end


function OpenMenuRedeemCards( tablec )

	local CardsTable = tablec
	
	local FramePrincipal = vgui.Create( "DFrame" )
		FramePrincipal:SetSize( ScrW(), ScrH() )
		FramePrincipal:SetPos( 0,0 )
		FramePrincipal:SetTitle( "" )
		FramePrincipal:SetDraggable( false )
		FramePrincipal:ShowCloseButton( false )
		FramePrincipal:MakePopup()
		FramePrincipal.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( BackgroundHog )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end
	
	local CloseButton = vgui.Create("DButton", FramePrincipal)
		CloseButton:SetPos(ScrW() - 70 - 20, 20)
		CloseButton:SetSize(70,30)
		CloseButton:SetText("Close")
		CloseButton:SetFont(HogwartsConfig.FontOne)
		CloseButton.Paint = function(s , w , h)
			draw.RoundedBox(3,0,0,w , h,Color(255,255,255,100))
		end
		function CloseButton:DoClick()
			FramePrincipal:Close()
		end
	
	local FrogLogo = vgui.Create("DButton", FramePrincipal)
		FrogLogo:SetPos(ScrW()- 156/2 - 20,70 )
		FrogLogo:SetSize(156/2,109/2)
		FrogLogo:SetText("")
		local frogimg3 = Material(HogwartsConfig.FrogImg)
		FrogLogo.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( frogimg3 )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end

	local Label1 = vgui.Create("DLabel", FramePrincipal)
		Label1:SetPos( ScrW()- 156/2 - 20 - 156/2 - 156/2 - 30,80 )
		Label1:SetSize( 200, 30 )
		Label1:SetWrap( false )
		Label1:SetTextColor(Color(255,255,255))
		Label1:SetFont(HogwartsConfig.FontOne)
		Label1:SetText( LocalPlayer():GetNWInt("Frogs").." chocolate frog(s)" )
	
	local ReturnButton = vgui.Create("DButton", FramePrincipal)
		ReturnButton:SetPos(ScrW()- 170, 70+50+20 )
		ReturnButton:SetSize(150,50)
		ReturnButton:SetText("See cards")
		ReturnButton:SetTextColor(Color(80,80,80))
		ReturnButton:SetFont(HogwartsConfig.FontOne)
		ReturnButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(0,161,255) )
		end
		function ReturnButton:DoClick()
			FramePrincipal:Close()
			OpenMenuCards( CardsTable )
		end
	
	local BuyFrogsButton = vgui.Create("DButton", FramePrincipal)
		BuyFrogsButton:SetPos(ScrW()- 170, 70+50+20+70 )
		BuyFrogsButton:SetSize(150,50)
		BuyFrogsButton:SetText("Buy frogs")
		BuyFrogsButton:SetTextColor(Color(80,80,80))
		BuyFrogsButton:SetFont(HogwartsConfig.FontOne)
		BuyFrogsButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(0,161,255) )
		end
		function BuyFrogsButton:DoClick()
			FramePrincipal:Close()
			OpenMenuBuyFrogs( CardsTable )
		end
	
	local imgbuycard = Material("materials/defaultcard.png")
	
	local BronzeCard = vgui.Create("DButton", FramePrincipal)
		BronzeCard:SetPos(ScrW()/4-140,ScrH()/4)
		BronzeCard:SetSize(190,190)
		BronzeCard:SetText("")
		BronzeCard.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( imgbuycard )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end
	
	local Label2 = vgui.Create("DLabel", FramePrincipal)
		Label2:SetPos( ScrW()/4-100,ScrH()/4+200 )
		Label2:SetSize( 200, 50 )
		Label2:SetWrap( false )
		Label2:SetTextColor(Color(255,255,255))
		Label2:SetFont(HogwartsConfig.FontOne)
		Label2:SetText( "Bronze cards : \n   "..HogwartsConfig.PriceBronze.." frogs" )
		
	local BronzeButton = vgui.Create("DButton", FramePrincipal)
		BronzeButton:SetPos( ScrW()/4-110,ScrH()/4+200 + 80 )
		BronzeButton:SetSize(130,40)
		BronzeButton:SetText("Buy")
		BronzeButton:SetTextColor(Color(255,255,255))
		BronzeButton:SetFont(HogwartsConfig.FontOne)
		BronzeButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(205, 127, 50) )
		end
		function BronzeButton:DoClick()
			net.Start("BuyCard")
				net.WriteInt(1, 32)
			net.SendToServer()
			FramePrincipal:Close()
		end
		
	local GoldCard = vgui.Create("DButton", FramePrincipal)
		GoldCard:SetPos(ScrW()-ScrW()/4-140,ScrH()/4)
		GoldCard:SetSize(190,190)
		GoldCard:SetText("")
		GoldCard.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( imgbuycard )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end
	
	local GoldButton = vgui.Create("DButton", FramePrincipal)
		GoldButton:SetPos( ScrW()-ScrW()/4-105,ScrH()/4+200 + 80 )
		GoldButton:SetSize(130,40)
		GoldButton:SetText("Buy")
		GoldButton:SetTextColor(Color(255,255,255))
		GoldButton:SetFont(HogwartsConfig.FontOne)
		GoldButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(212, 175, 55) )
		end
		function GoldButton:DoClick()
			net.Start("BuyCard")
				net.WriteInt(3, 32)
			net.SendToServer()
			FramePrincipal:Close()
		end
	
	local Label3 = vgui.Create("DLabel", FramePrincipal)
		Label3:SetPos( ScrW()-ScrW()/4-100,ScrH()/4+200 )
		Label3:SetSize( 200, 50 )
		Label3:SetWrap( false )
		Label3:SetTextColor(Color(255,255,255))
		Label3:SetFont(HogwartsConfig.FontOne)
		Label3:SetText( "Gold cards : \n   "..HogwartsConfig.PriceGold.." frogs" )
		
	local SilverCard = vgui.Create("DButton", FramePrincipal)
		SilverCard:SetPos(ScrW()/2-140,ScrH()/4)
		SilverCard:SetSize(190,190)
		SilverCard:SetText("")
		SilverCard.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( imgbuycard )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end
	
	local SilverButton = vgui.Create("DButton", FramePrincipal)
		SilverButton:SetPos( ScrW()/2-107,ScrH()/4+200 + 80 )
		SilverButton:SetSize(130,40)
		SilverButton:SetText("Buy")
		SilverButton:SetTextColor(Color(255,255,255))
		SilverButton:SetFont(HogwartsConfig.FontOne)
		SilverButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(204, 204, 204) )
		end
		function SilverButton:DoClick()
			net.Start("BuyCard")
				net.WriteInt(2, 32)
			net.SendToServer()
			FramePrincipal:Close()
		end
	
	local Label4 = vgui.Create("DLabel", FramePrincipal)
		Label4:SetPos( ScrW()/2-100,ScrH()/4+200 )
		Label4:SetSize( 200, 50 )
		Label4:SetWrap( false )
		Label4:SetTextColor(Color(255,255,255))
		Label4:SetFont(HogwartsConfig.FontOne)
		Label4:SetText( "Silver cards : \n  "..HogwartsConfig.PriceSilver.." frogs" )
	
end


function OpenMenuCards( CardsTable )

	local CardsTable = CardsTable
	
	local FramePrincipal = vgui.Create( "DFrame" )
		FramePrincipal:SetSize( ScrW(), ScrH() )
		FramePrincipal:SetPos( 0,0 )
		FramePrincipal:SetTitle( "" )
		FramePrincipal:SetDraggable( false )
		FramePrincipal:ShowCloseButton( false )
		FramePrincipal:MakePopup()
		FramePrincipal.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( BackgroundHog )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end
	
	local CloseButton = vgui.Create("DButton", FramePrincipal)
		CloseButton:SetPos(ScrW() - 70 - 20, 20)
		CloseButton:SetSize(70,30)
		CloseButton:SetText("Close")
		CloseButton:SetFont(HogwartsConfig.FontOne)
		CloseButton.Paint = function(s , w , h)
			draw.RoundedBox(3,0,0,w , h,Color(255,255,255,100))
		end
		function CloseButton:DoClick()
			FramePrincipal:Close()
		end
	
	local FrogLogo = vgui.Create("DButton", FramePrincipal)
		FrogLogo:SetPos(ScrW()- 156/2 - 20,70 )
		FrogLogo:SetSize(156/2,109/2)
		FrogLogo:SetText("")
		local imgfrog4 = Material(HogwartsConfig.FrogImg)
		FrogLogo.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( imgfrog4 )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end
		
	local RedeemButton = vgui.Create("DButton", FramePrincipal)
		RedeemButton:SetPos(ScrW()- 170, 70+50+20 )
		RedeemButton:SetSize(150,50)
		RedeemButton:SetText("Redeem frogs")
		RedeemButton:SetTextColor(Color(80,80,80))
		RedeemButton:SetFont(HogwartsConfig.FontOne)
		RedeemButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(0,161,255) )
		end
		function RedeemButton:DoClick()
			FramePrincipal:Close()
			OpenMenuRedeemCards( CardsTable )
		end
	local BuyFrogsButton = vgui.Create("DButton", FramePrincipal)
		BuyFrogsButton:SetPos(ScrW()- 170, 70+50+20+70 )
		BuyFrogsButton:SetSize(150,50)
		BuyFrogsButton:SetText("Buy frogs")
		BuyFrogsButton:SetTextColor(Color(80,80,80))
		BuyFrogsButton:SetFont(HogwartsConfig.FontOne)
		BuyFrogsButton.Paint = function(s , w , h)
			draw.RoundedBox( 3, 0, 0, w, h, Color(0,161,255) )
		end
		function BuyFrogsButton:DoClick()
			FramePrincipal:Close()
			OpenMenuBuyFrogs( CardsTable )
		end

	local Label3 = vgui.Create("DLabel", FramePrincipal)
		Label3:SetPos( ScrW()- 156/2 - 20 - 156/2 - 156/2 - 30,80 )
		Label3:SetSize( 200, 30 )
		Label3:SetWrap( false )
		Label3:SetTextColor(Color(255,255,255))
		Label3:SetFont(HogwartsConfig.FontOne)
		Label3:SetText( LocalPlayer():GetNWInt("Frogs").." chocolate frog(s)" )
	
	local materialPrev = Material(HogwartsConfig.Default)
		
	local PreviewCard = vgui.Create("DButton", FramePrincipal)
		PreviewCard:SetPos( ScrW()/2 - ( 8 * 100 + 8 * 10 ) / 2 ,0)
		PreviewCard:SetSize(ScrH()/4,ScrH()/4)
		PreviewCard:SetText("")
		PreviewCard:SetFont(HogwartsConfig.FontOne)
		PreviewCard.Paint = function(s , w , h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( materialPrev )
			surface.DrawTexturedRect( 0, 0, w, h, 0)
		end
	
	local Label1 = vgui.Create("DLabel", FramePrincipal)
		Label1:SetPos( ScrW()/2 - ( 8 * 100 + 8 * 10 ) / 2 + ScrH()/4, 30 )
		Label1:SetSize( 300,(ScrH()/4)/8 )
		Label1:SetWrap( true )
		Label1:SetTextColor(Color(255,255,255))
		Label1:SetFont(HogwartsConfig.FontOne)
		Label1:SetText( "" )
	
	local value1 = ScrW() - (ScrW()/2 - ( 8 * 100 + 8 * 10 ) / 2) - ScrH()/4  - (  ScrW()/2 - ( 8 * 100 + 8 * 10 ) / 2 + ScrH()/4 ) 
	local value2 = ((ScrH()/4)/8)*7
	local value3 = ScrW()/2 - ( 8 * 100 + 8 * 10 ) / 2 + ScrH()/4
	local value4 = (ScrH()/4)/8 + 30
	
	local Label2 = vgui.Create("DLabel", FramePrincipal)
		Label2:SetPos( value3, value4 )
		Label2:SetSize( value1,value2 )
		Label2:SetWrap( true )
		Label2:SetTextColor(Color(255,255,255))
		Label2:SetFont(HogwartsConfig.FontDescription)
		Label2:SetText( "" )
	
	local PanelCards = CreatePanel( FramePrincipal, 8 * 100 + 8 * 10 +20, (ScrH()/4)*3, ScrW()/2 - ( 8 * 100 + 8 * 10 ) / 2, ScrH()/4 , Color(0,0,0, 0), true)
	
	local lineAct = 1
	local placedOnLine = 0
	
	if not CardsTable then return end
	
	for k, v in pairs( CardsTable ) do		
		if CardsTable[k] != nil && CardsHogwards[CardsTable[k]] != nil && CardsHogwards[CardsTable[k]] then
			
			placedOnLine = placedOnLine + 1

			local CardsButton = vgui.Create("DButton", PanelCards)
				CardsButton:SetPos(10 * placedOnLine + placedOnLine*100 - 100, 20 * lineAct + lineAct * 100 - 120 )
				CardsButton:SetSize(100,100)
				CardsButton:SetText("")
				CardsButton:SetFont(HogwartsConfig.FontOne)
				local imgpng = Material(CardsHogwards[CardsTable[k]].img)
				CardsButton.Paint = function(s , w , h)
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( imgpng )
					surface.DrawTexturedRect( 0, 0, w, h, 0)
				end
				
				function CardsButton:DoClick()
					materialPrev = Material(CardsHogwards[CardsTable[k]].img)
					Label1:SetText( CardsTable[k])
					Label2:SetText( CardsHogwards[CardsTable[k]].desc )
				end
				
				if placedOnLine >= 8 then
					placedOnLine = 0
					lineAct = lineAct + 1
				end
		end
	end

	
end

net.Receive("SendPosFrogsConfig", function()
	
	local text = net.ReadString()
	
	chat.AddText(Color(255,255,0), "[Card]", Color(0,161,255), "Configuration sent in your console! Copy/paste it in configcards.lua")
	
	print(text)
	
end)

CardsNumber = {}

net.Receive("OpenCardsMenu", function()

	CardsNumber = net.ReadTable()
	
	OpenMenuCards( CardsNumber )
	
	
end)
net.Receive("GetCardsNumber", function()

	CardsNumber = net.ReadTable()
		
end)

function GetCardsAmount()
	
	local cnum = #CardsNumber or 0
	return cnum

end

hook.Add("HUDPaint", "Display Frogs", function()

	if HogwartsConfig.HideHUD then return end
	
	draw.SimpleText( "You have "..LocalPlayer():GetNWInt("Frogs").." frogs." , HogwartsConfig.FontOne, ScrW()-185, ScrH()-200, Color( 255, 255, 255, 255 ) )
	
	if not GetCardsAmount() then return end
	
	draw.SimpleText( "You have "..GetCardsAmount().." card(s)." , HogwartsConfig.FontOne, ScrW()-185, ScrH()-250, Color( 255, 255, 255, 255 ) )

end)

net.Receive("PrintCardMsg", function()

	local msg = net.ReadString()
	
	chat.AddText(Color(255,255,0), "[Card]", Color(0,161,255), msg)

end)