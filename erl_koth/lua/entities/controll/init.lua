AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/props_gameplay/cap_point_base.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

util.AddNetworkString("HudDraw1")
util.AddNetworkString("HudNoDraw1")
util.AddNetworkString("Getcap")
util.AddNetworkString("Entity Spawned")
util.AddNetworkString("cap_bottom")
util.AddNetworkString("sendrad")
util.AddNetworkString("Broadcastcappoint")

local playerlist = {}
local tred = {}
local tblue = {}
local nnet = 0
local n = 0
local cap = 0 
local entity_spawned = 0
local cap_radius = 300
local position_ofpoint = Vector(0,0,0)

function ENT:OnRemove()
    cap = 0 
    entity_spawned = 0
end


function Checkifonpoint(ply)
    if x:Distance(ply:GetPos()) < cap_radius then
        ply:ChatPrint("You cant change your teams while on the point")
        return 0
    end
    return 1
end

hook.Add("PlayerSay", "textcheck2", function(ply, text)
    if text == "!setteam red" then 
        if Checkifonpoint(ply) == 1 then
            playerlist[ply] = "red"
            ply:Kill()
            ply:Spawn()
        end
    elseif text == "!setteam blue" then 
        if Checkifonpoint(ply) == 1 then
            playerlist[ply] = "blue"
            ply:Kill()
            ply:Spawn()
        end
    end
end)

function ENT:SpawnFunction(ply,tr,ClassName) 
    classname_entity = ClassName
    if entity_spawned == 0 then
        local SpawnPos = tr.HitPos + tr.HitNormal * 10
        local SpawnAng = ply:EyeAngles()

        local ent = ents.Create( ClassName )
        ent:SetPos( SpawnPos )
        ent:SetAngles( SpawnAng )
        ent:Spawn()
        ent:Activate()

        net.Start("Entity Spawned")
        net.Broadcast()
        entity_spawned = 1
    else
        ply:ChatPrint("You can only have 1 Controll point at a time")
    end
end


local time = CurTime()

function ENT:Think()
    x = self:GetPos()
    if time + n < CurTime()
    then
        for k, v in pairs(ents.GetAll()) do
            if v:IsPlayer() 
            then 
                if x:Distance(v:GetPos()) < cap_radius
                then
                    net.Start("HudDraw1")
                    net.Send(v)
                    if notInside(tred, v) 
                    then
                        if notInside(tblue, v)
                        then
                            if playerlist[v] == "red" then
                                tred[#tred + 1] = v
                            elseif playerlist[v] == "blue" then
                                tblue[#tblue + 1] = v
                            end
                        end
                    end
                end
                if x:Distance(v:GetPos()) > cap_radius
                then
                    net.Start("HudNoDraw1")
                        net.Send(v)
                    if playerlist[v] == "red" then
                        table.remove(tred, #tred)
                    elseif playerlist[v] == "blue" then
                        table.remove(tblue, #tblue)
                    end
                end
            end
        end
        cap = cap + ( #tblue - #tred )
        if cap > 1000 then cap = 1000 end
        if cap < -1000 then cap = -1000 end
        net.Start("Getcap")
            net.WriteInt(cap, 16)
        net.Broadcast()
        net.Start("cap_bottom")
            net.WriteInt( #tblue - #tred, 16)
        net.Broadcast()
        n = n + 0.1
    end
    net.Start("Broadcastcappoint")
        net.WriteVector(self:GetPos())
    net.Broadcast()
end

function notInside(t1, x)
    for k, v in pairs(t1) do 
        if t1[k] == x then return false end
    end
    return true
end

concommand.Add("remove_point", function()
    ents.FindByClass(classname_entity)[1]:Remove()
end)

concommand.Add("set_capradios", function(use,le,ss, rad)
    cap_radius = tonumber(rad)
    net.Start("sendrad")
        net.WriteInt(cap_radius, 16)
    net.Broadcast()
end)