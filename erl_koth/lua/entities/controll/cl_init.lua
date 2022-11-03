AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

hook.Add("PostDrawTranslucentRenderables", 'AOUUUUGH', function()

    render.SetColorMaterial()
    net.Receive("Broadcastcappoint", function()
    
        position_point = net.ReadVector()

    end)

    render.DrawSphere( position_point, cap_radius, 30, 30, Color( 0, 175, 175, 100 ) )
end)

local w = ScrW()
local x = 0
local y = 0
local x1 = 0
local y1 = 0
local x2 = 0
local y2 = 0
local cap = 0 
local x3 = 0
local y4 = 0 
local x4 = 0
local y5 = -100
local x5 = -100
local bottom = 0 
local cap_read = 0
local bottom_text_x = -100
local bottom_text_y = -100
local bottom_inner = 0
local changecolor = Color(86, 87, 86)
cap_radius = 0
position_point = Vector(0, 0,0)

hook.Add("HUDPaint", "dfsfdsfsd", function()
    draw.RoundedBox(10, w/2 - 550, 25, x2, y2, Color(41, 40, 40))
    draw.RoundedBox(2, w/2 - 502, 98, x4, y4, Color(41, 40, 40))
    draw.RoundedBox(2, w/2 - 500, 100, x3, y, Color(86, 87, 86))
    draw.RoundedBox(2, w/2 - 500, 100, x, y, Color(66, 145, 255))
    draw.RoundedBox(0, w/2 - 500, 100, x1, y1, Color(255, 0, 0))
    surface.SetFont( "DisplayFont" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( x5, y5 ) 
	surface.DrawText( "You are on top of the hill" )
    fw, fh = surface.GetTextSize("You are on top of the hill")
    draw.RoundedBox(3, w/2 - 29, ScrH()-64, bottom, 58, Color(41, 40, 40))
    draw.RoundedBox(3, w/2 - 25, ScrH()-60, bottom_inner, 50, changecolor)
    surface.SetFont( "DisplayFont" )
	surface.SetTextPos( bottom_text_x, bottom_text_y )
    if cap_read > 0 then  surface.DrawText( "+"..cap_read) else	surface.DrawText( cap_read ) end
    if cap_read > 0 then  fw1, fh1 = surface.GetTextSize("+"..cap_read) else fw1, fh1 = surface.GetTextSize(cap_read) end
end)

net.Receive("HudDraw1", function()
    net.Receive("Getcap", function()
        cap = net.ReadInt(16)
    end)
    x2 = 1100
    y2 = 75
    x3 = 1000
    y = 20
    y4 = 24
    x4 = 1004
    x5 = w/2 - fw /2
    y5 = 40
    if cap > 0 then 
        x = 1000 * (cap / 1000)
        y = 20
    end
    if cap < 0 then 
        x = 0
        x1 = 1000 * (math.abs(cap) / 1000)
        y1 = 20
    end
    bottom_text_x = w/2 - fw1/2
    if cap > 0 then changecolor = Color(66, 145, 255) elseif cap < 0 then changecolor = Color(255, 0, 0) else changecolor = Color(86, 87, 86) end
end)

net.Receive("HudNoDraw1", function()
    x = 0
    y = 0
    x1 = 0
    x2 = 0
    y4 = 0
    x4 = 0
    y5 = -100
    x5 = -100
    bottom_text_x = w/2 - fw1/2
    if cap > 0 then changecolor = Color(66, 145, 255)  elseif cap < 0 then changecolor = Color(255, 0, 0) else changecolor = Color(86, 87, 86) end
end)


net.Receive("Entity Spawned", function()
    bottom = 58
    bottom_text_x = w/2 - fw1/2
    bottom_text_y = ScrH() - 57
    bottom_inner = 50
    cap_radius = 300
end)

function ENT:OnRemove()
    x = 0
    y = 0
    x1 = 0
    x2 = 0
    y4 = 0
    x4 = 0
    y5 = -100
    x5 = -100
    bottom = 0
    bottom_text_x = -100
    bottom_inner = 0
    cap_radius = 0
end

net.Receive("cap_bottom", function()
    cap_read = net.ReadInt(16)
end)

net.Receive("sendrad", function()
    cap_radius = net.ReadInt(16)
end)

surface.CreateFont("DisplayFont", {
    font = "Bahnschrift",
	extended = false,
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("BottomFont", {
    font = "Bahnschrift",
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})