AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel( "models/cf/cf.mdl" )
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
    
        phys:Wake()
        
    end
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
end

local NextTouch = 0

function ENT:Touch( ent )

	if ent:IsPlayer() && NextTouch <= CurTime() then
		
		self:Remove()
		ent:AddFrog()
		ent:SendChatPrintCard("You find a frog! Now you have "..ent:GetFrogs().." frogs!")
		NextTouch = CurTime() + 2
		--ent:addXP( HogwartsConfig.XPPerFrog )
		ConfigChocolateFrogPos[self.posNumber].IsTaken = false
		FrogsSpawnedNumber = FrogsSpawnedNumber - 1
		timer.Simple(HogwartsConfig.FrogsTimeRespawn, SpawnRandomFrog )
		
	end
	
end