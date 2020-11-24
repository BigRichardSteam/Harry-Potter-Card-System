util.AddNetworkString("OpenCardsMenu")
util.AddNetworkString("BuyCard")
util.AddNetworkString("BuyFrogs")
util.AddNetworkString("PrintCardMsg")
util.AddNetworkString("SendPosFrogsConfig")
util.AddNetworkString("GetCardsNumber")
util.AddNetworkString("SendChatPrintCard")

FrogsSpawnedNumber = 0

function SpawnRandomFrog()
	if FrogsSpawnedNumber < HogwartsConfig.MaxFrogs then
		local nbspawn = #ConfigChocolateFrogPos
		local spawnpos = nil
		local nbessais = 0
		local rand
		while spawnpos == nil do
			rand = math.random(1, nbspawn)
			print(rand)
			if ConfigChocolateFrogPos[rand].IsTaken then
			else
				spawnpos = ConfigChocolateFrogPos[rand].pos
				ConfigChocolateFrogPos[rand].IsTaken = true
			end
			nbessais = nbessais +1
			if nbessais >= 100 then
				print("ERROR: Can't make a new frog.")
				break
			end
		end

		local frog = ents.Create("frog_prop")
		frog:SetPos(spawnpos)
		frog:Spawn()
		frog.posNumber = rand

		FrogsSpawnedNumber = FrogsSpawnedNumber + 1
	end
end

hook.Add("Initialize", "Initialize Mysql Frog Base and spawn frogs", function()
	MsgC(Color(0,0,255), "Initializing Frog Cards system...")
	if (sql.TableExists("frog_cards")) then
		MsgC(Color(0,0,255), "Base Frog Cards already exist")
	else
		sql.Query( "CREATE TABLE frog_cards ( steamid varchar(255), frog int(255), cards varchar(255), rewarded int(255) )" )
		if (sql.TableExists("frog_cards")) then
			MsgC(Color(0,0,255), "Base Frog Cards created")
		else
			MsgC(Color(0,0,255), "Something create a problem in the creation of the Base Frog Cards")
		end
	end
	timer.Simple(3, function()
		local i
		for i=1, HogwartsConfig.MaxFrogs do
			SpawnRandomFrog()
		end
	end)

end)


local meta = FindMetaTable( "Player" )

function meta:SendChatPrintCard( message )
	net.Start("PrintCardMsg")
		net.WriteString(message)
	net.Send(self)
end

function meta:IsInCardsDatabase()
	local steamID = self:SteamID()
	local frog = sql.Query("SELECT frog FROM frog_cards WHERE steamid = '"..steamID.."'")

	if frog then
		return true
	else
		return false
	end
end

function meta:GetFrogs()
	local steamID = self:SteamID()
	local frog = sql.Query("SELECT frog FROM frog_cards WHERE steamid = '"..steamID.."'")
	return tonumber(frog[1].frog)
end

function meta:AddCard( name )
	local steamID = self:SteamID()
	local cards = sql.Query("SELECT cards FROM frog_cards WHERE steamid = '"..steamID.."'")
	local card = cards[1].cards.."|"..name
	sql.Query( "UPDATE frog_cards SET cards = '" .. card .. "' WHERE steamid = '" .. steamID .. "'" )
	local cards = sql.Query("SELECT cards FROM frog_cards WHERE steamid = '"..steamID.."'")
end

function meta:GetCardsTable()
	local steamID = self:SteamID()
	local cards = sql.Query("SELECT cards FROM frog_cards WHERE steamid = '"..steamID.."'")
	local tableCards = string.Explode( "|", cards[1].cards )
	return tableCards
	
end

function meta:RemoveFrog( number )
	local steamID = self:SteamID()
	local frogs = self:GetFrogs() - number
	
	sql.Query( "UPDATE frog_cards SET frog = " .. frogs .. " WHERE SteamID = '" .. steamID .. "'" )
	
	self:SetNWInt("Frogs", frogs )
end

function meta:AddFrog()
	local steamID = self:SteamID()
	local frog = self:GetFrogs()
	sql.Query( "UPDATE frog_cards SET frog = " .. frog + 1 .. " WHERE steamid = '" .. steamID .. "'" )
	
	self:SetNWInt("Frogs", frog + 1)
end

function meta:AddToCardsDatabase()
	local steamID = self:SteamID()
	sql.Query( "INSERT INTO frog_cards (`steamid`,`frog`,`cards`,`rewarded`)VALUES ('"..steamID.."', '0', '', '0')" )
end

function meta:IsRewarded()
	local steamID = self:SteamID()
	local rewarded = sql.Query("SELECT rewarded FROM frog_cards WHERE steamid = '"..steamID.."'")
	if rewarded[1].rewarded == "0" then
		return  false
	else
		return true
	end
	
end

function meta:Reward()
	local steamID = self:SteamID()
	sql.Query( "UPDATE frog_cards SET rewarded = '1' WHERE steamid = '" .. steamID .. "'" )
end

function meta:HaveAllCard()
	local CardsTable = self:GetCardsTable()
	
	local haveAllCards = true
	
	for k, v in pairs( CardsHogwards ) do
		if not table.HasValue(CardsTable, k ) then
			haveAllCards = false
		end
	end
	
	return haveAllCards
	
end

hook.Add("PlayerInitialSpawn", "Add new players to frogcards database", function( ply )
	
	timer.Simple(0.1, function()
		if ply:IsInCardsDatabase() then
		
			print("Already in the database.")
			
			timer.Simple( 0.1, function()
				ply:SetNWInt("Frogs", ply:GetFrogs())
			end) 
			
			net.Start("GetCardsNumber")
				net.WriteTable(ply:GetCardsTable())
			net.Send(ply) 
			
			return
			
		end
		
		ply:AddToCardsDatabase()
		
		if ply:IsInCardsDatabase() then
			MsgC(Color( 0, 255, 0), "Player added to the database")
		else
			MsgC(Color(255, 0, 0), "Player isn't added to the database, there is a problem! "..sql.LastError())
		end
		
		timer.Simple( 0.1, function()
			ply:SetNWInt("Frogs", ply:GetFrogs())
		end)  
	end)
	
end)

hook.Add("PlayerSay", "Player say !cards", function( ply, text )

	if string.lower(text) == "!cards" then
		
		net.Start("OpenCardsMenu")
			net.WriteTable(ply:GetCardsTable())
		net.Send(ply)
		
	end

	if string.lower(text) == "!getfrogspos" && ply:IsSuperAdmin() then
		
		local frogsFinded = 0
		local configText = ""		
		
		for k , ent in pairs(ents.GetAll()) do
			
			if ent:GetClass() == "frog_prop" then
				
				frogsFinded = frogsFinded + 1
				configText = configText.."ConfigChocolateFrogPos["..frogsFinded.."] = { pos = Vector("..ent:GetPos().x..","..ent:GetPos().y..","..ent:GetPos().z..") }\n"
			
			end			
		
		end
		
		net.Start("SendPosFrogsConfig")
			net.WriteString(configText)
		net.Send(ply)
		
	end

end)

net.Receive("BuyCard", function( len, caller ) 

	local type = net.ReadInt( 32 )
	local availablecards = {}
	local playercards = caller:GetCardsTable()
	local availableCardsNumber = 0
	local path = HogwartsConfig.SoundBuy

	if type == 1 then
		if caller:GetFrogs() >= HogwartsConfig.PriceBronze then
			for k , v in pairs(CardsHogwards) do
				if v.type == 1 then
					if not table.HasValue(playercards, k) then
						availableCardsNumber = availableCardsNumber + 1
						availablecards[availableCardsNumber]=k
					end
				end
			end
			if availableCardsNumber > 0 then
				local card = math.random(1, availableCardsNumber)
				caller:AddCard(availablecards[card])
				caller:RemoveFrog( HogwartsConfig.PriceBronze )
				caller:SendChatPrintCard("Congratulations! You got the card "..availablecards[card])
				caller:SendLua("surface.PlaySound('"..path.."')")
			else
				caller:SendChatPrintCard(HogwartsConfig.AlreadyHave)
			end
		else
			caller:SendChatPrintCard(HogwartsConfig.MsgEnoughFrog)
		end
	end

	if type == 2 then
		if caller:GetFrogs() >= HogwartsConfig.PriceSilver then
			for k , v in pairs(CardsHogwards) do
				if v.type == 2 then
					if not table.HasValue(playercards, k) then
						availableCardsNumber = availableCardsNumber + 1
						availablecards[availableCardsNumber]=k
					end
				end
			end
			if availableCardsNumber > 0 then
				local card = math.random(1, availableCardsNumber)
				caller:AddCard(availablecards[card])
				caller:RemoveFrog( HogwartsConfig.PriceSilver )
				caller:SendChatPrintCard("Congratulations! You got the card "..availablecards[card])
				caller:SendLua("surface.PlaySound('"..path.."')")
			else
				caller:SendChatPrintCard(HogwartsConfig.AlreadyHave)
			end
		else
			caller:SendChatPrintCard(HogwartsConfig.MsgEnoughFrog)
		end
	end

	if type == 3 then
		if caller:GetFrogs() >= HogwartsConfig.PriceGold then
			for k , v in pairs(CardsHogwards) do
				if v.type == 3 then
					if not table.HasValue(playercards, k) then
						availableCardsNumber = availableCardsNumber + 1
						availablecards[availableCardsNumber]=k
					end
				end
			end
			if availableCardsNumber > 0 then
				local card = math.random(1, availableCardsNumber)
				caller:AddCard(availablecards[card])
				caller:RemoveFrog( HogwartsConfig.PriceGold )
				caller:SendChatPrintCard("Congratulations! You got the card "..availablecards[card])
				caller:SendLua("surface.PlaySound('"..path.."')")
			else
				caller:SendChatPrintCard(HogwartsConfig.AlreadyHave)
			end
		else
			caller:SendChatPrintCard(HogwartsConfig.MsgEnoughFrog)
		end
	end
	
	if caller:HaveAllCard() and not caller:IsRewarded() then
		-- caller:addXP(HogwartsConfig.XPAllCards)
		caller:addMoney(HogwartsConfig.MoneyAllCards)
		caller:SendChatPrintCard("Congratulations! You have all cards!")
		caller:Reward()
	end
	
end)

net.Receive("BuyFrogs", function( len, caller ) 

	local type = net.ReadInt( 32 )
	local path = HogwartsConfig.SoundBuy

	if type == 1 then
		if caller:getDarkRPVar("money") >= HogwartsConfig.Price10Frogs then
			caller:addMoney( -HogwartsConfig.Price10Frogs )
			local i
			for i=1, 10 do
				caller:AddFrog()
			end
			caller:SendChatPrintCard("Congratulations! You got 10 frogs!")
			caller:SendLua("surface.PlaySound('"..path.."')")
		else
			caller:SendChatPrintCard(HogwartsConfig.MsgEnoughMoney)
		end
	end

	if type == 2 then
		if caller:getDarkRPVar("money") >= HogwartsConfig.Price20Frogs then
			caller:addMoney( -HogwartsConfig.Price20Frogs )
			local i
			for i=1, 20 do
				caller:AddFrog()
			end
			caller:SendChatPrintCard("Congratulations! You got 20 frogs!")
			caller:SendLua("surface.PlaySound('"..path.."')")
		else
			caller:SendChatPrintCard(HogwartsConfig.MsgEnoughMoney)
		end
	end

	if type == 3 then
		if caller:getDarkRPVar("money") >= HogwartsConfig.Price30Frogs then
			caller:addMoney( -HogwartsConfig.Price30Frogs )
			local i
			for i=1, 30 do
				caller:AddFrog()
			end
			caller:SendChatPrintCard("Congratulations! You got 30 frogs!")
			caller:SendLua("surface.PlaySound('"..path.."')")
		else
			caller:SendChatPrintCard(HogwartsConfig.MsgEnoughMoney)
		end
	end

end)