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

function ENT:Use( ply )
	
	ply:ChatPrint("pos = Vector("..self:GetPos().x..","..self:GetPos().y..","..self:GetPos().z..")")
	
end