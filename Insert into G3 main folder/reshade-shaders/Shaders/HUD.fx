/*
	Original code by Marty McFly
	Concept by TrophiHunter 
*/

#include "ReShade.fxh"

texture HudTex	< string source = "CFX_hud.png"; > {Width = 2560; Height = 1440; Format = RGBA8;};
sampler	HudColor 	{ Texture = HudTex; };

float4 PS_Hud(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	float4 hud = tex2D(HudColor, texcoord);
	return lerp(tex2D(ReShade::BackBuffer, texcoord),hud,hud.a);
}

technique Hud_Tech
{
	pass HudPass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_Hud;
	}
}