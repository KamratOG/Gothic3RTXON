//Diffuse Glow by Ioxa for ReShade 3.0
//Version 1.0

//Settings
uniform int BlurRadius <
	ui_type = "drag";
	ui_min = 0; ui_max = 4;
	ui_tooltip = "[0|1|2|3|4] Adjusts the blur radius. Higher values increase the radius";
> = 1;

uniform int BlendMode
<
	ui_type = "combo";
	ui_items = "Screen\0WarmScreen\0";
	ui_tooltip = "Determines how the glow effect is applied to the original image.";
> = 0;

uniform int ThresholdMaskType <
	ui_type = "combo";
	ui_items = "\Max\0Average\0Min\0AvgMaxMin\0";
	ui_tooltip = "Determines what pixels are considered bright. Using the ThresholdMask option in DebugMode is helpful when selecting a mask type";
> = 3;

uniform float Threshold <
	ui_type = "drag";
	ui_min = 0.00; ui_max = 1.00;
	ui_tooltip = "Everything above this value will be considered bright light and have to full strength of the effect applied to it.";
> = 0.600;

uniform float ThresholdRange <
	ui_type = "drag";
	ui_min = 0.00; ui_max = 1.00;
	ui_tooltip = "Adjusts the cutoff for the threshold.";
> = 0.800;

uniform float GlowPower <
	ui_type = "drag";
	ui_min = 1.0; ui_max = 10.00;
	ui_tooltip = "Adjusts the power of the glow.";
> = 1.5;

uniform float GlowSaturation <
	ui_type = "drag";
	ui_min = 0.0; ui_max = 4.0;
	ui_tooltip = "Adjusts the power of the glow.";
> = 1.0;

uniform float GrainStrength <
	ui_type = "drag";
	ui_min = 0.0; ui_max = 1.00;
	ui_tooltip = "Adds grain to the effect.";
> = 0.100;

uniform float Strength <
	ui_type = "drag";
	ui_min = 0.00; ui_max = 1.00;
	ui_tooltip = "Adjusts the strength of the effect.";
> = 0.250;

uniform int DebugMode
<
	ui_type = "combo";
	ui_items = "\None\0ThresholdMask\0";
	ui_tooltip = "Helpful for adjusting settings";
> = 0;

uniform float timer < source = "timer";>;

#include "ReShade.fxh"

texture DiffuseTex { Width = BUFFER_WIDTH*0.5; Height = BUFFER_HEIGHT*0.5; Format = RGBA8; };
sampler DiffuseSampler { Texture = DiffuseTex; MinFilter = POINT;};

float3 DiffuseFinal(in float4 pos : SV_Position, in float2 texcoord : TEXCOORD) : COLOR
{

float3 color = tex2D(DiffuseSampler, texcoord).rgb;

if(BlurRadius == 0)	
{
	float offset[4] = { 0.0, 1.1824255238, 3.0293122308, 5.0040701377 };
	float weight[4] = { 0.39894, 0.2959599993, 0.0045656525, 0.00000149278686458842 };
	
	color *= weight[0];
	
	[loop]
	for(int i = 1; i < 4; ++i)
	{
		color += tex2D(DiffuseSampler, texcoord + float2(0.0, offset[i] * ReShade::PixelSize.y)).rgb * weight[i];
		color += tex2D(DiffuseSampler, texcoord - float2(0.0, offset[i] * ReShade::PixelSize.y)).rgb * weight[i];
	}
}	

if(BlurRadius == 1)	
{
	float offset[6] = { 0.0, 1.4584295168, 3.40398480678, 5.3518057801, 7.302940716, 9.2581597095 };
	float weight[6] = { 0.13298, 0.23227575, 0.1353261595, 0.0511557427, 0.01253922, 0.0019913644 };
	
	color *= weight[0];
	
	[loop]
	for(int i = 1; i < 6; ++i)
	{
		color += tex2D(DiffuseSampler, texcoord + float2(0.0, offset[i] * ReShade::PixelSize.y)).rgb * weight[i];
		color += tex2D(DiffuseSampler, texcoord - float2(0.0, offset[i] * ReShade::PixelSize.y)).rgb * weight[i];
	}
}	

if(BlurRadius == 2)	
{
	float offset[11] = { 0.0, 1.4895848401, 3.4757135714, 5.4618796741, 7.4481042327, 9.4344079746, 11.420811147, 13.4073334, 15.3939936778, 17.3808101174, 19.3677999584 };
	float weight[11] = { 0.06649, 0.1284697563, 0.111918249, 0.0873132676, 0.0610011113, 0.0381655709, 0.0213835661, 0.0107290241, 0.0048206869, 0.0019396469, 0.0006988718 };
	
	color *= weight[0];
	
	[loop]
	for(int i = 1; i < 11; ++i)
	{
		color += tex2D(DiffuseSampler, texcoord + float2(0.0, offset[i] * ReShade::PixelSize.y)).rgb * weight[i];
		color += tex2D(DiffuseSampler, texcoord - float2(0.0, offset[i] * ReShade::PixelSize.y)).rgb * weight[i];
	}
}	

if(BlurRadius == 3)	
{
	float offset[15] = { 0.0, 1.4953705027, 3.4891992113, 5.4830312105, 7.4768683759, 9.4707125766, 11.4645656736, 13.4584295168, 15.4523059431, 17.4461967743, 19.4401038149, 21.43402885, 23.4279736431, 25.4219399344, 27.4159294386 };
	float weight[15] = { 0.0443266667, 0.0872994708, 0.0820892038, 0.0734818355, 0.0626171681, 0.0507956191, 0.0392263968, 0.0288369812, 0.0201808877, 0.0134446557, 0.0085266392, 0.0051478359, 0.0029586248, 0.0016187257, 0.0008430913 };
	
	color *= weight[0];
	
	[loop]
	for(int i = 1; i < 15; ++i)
	{
		color += tex2D(DiffuseSampler, texcoord + float2(0.0, offset[i] * ReShade::PixelSize.y)).rgb * weight[i];
		color += tex2D(DiffuseSampler, texcoord - float2(0.0, offset[i] * ReShade::PixelSize.y)).rgb * weight[i];
	}
}

if(BlurRadius == 4)	
{
	float offset[18] = { 0.0, 1.4953705027, 3.4891992113, 5.4830312105, 7.4768683759, 9.4707125766, 11.4645656736, 13.4584295168, 15.4523059431, 17.4461967743, 19.4661974725, 21.4627427973, 23.4592916956, 25.455844494, 27.4524015179, 29.4489630909, 31.445529535, 33.4421011704 };
	float weight[18] = { 0.033245, 0.0659162217, 0.0636705814, 0.0598194658, 0.0546642566, 0.0485871646, 0.0420045997, 0.0353207015, 0.0288880982, 0.0229808311, 0.0177815511, 0.013382297, 0.0097960001, 0.0069746748, 0.0048301008, 0.0032534598, 0.0021315311, 0.0013582974 };
	
	color *= weight[0];
	
	[loop]
	for(int i = 1; i < 18; ++i)
	{
		color += tex2D(DiffuseSampler, texcoord + float2(0.0, offset[i] * ReShade::PixelSize.y)).rgb * weight[i];
		color += tex2D(DiffuseSampler, texcoord - float2(0.0, offset[i] * ReShade::PixelSize.y)).rgb * weight[i];
	}
}		

	float3 orig = tex2D(ReShade::BackBuffer, texcoord).rgb;
	
		float luma = dot(color,0.333);
		color /= luma;
		color *= 1.0 - pow(1-luma,GlowPower);
	
	color = lerp(luma,color,GlowSaturation);

	if(BlendMode == 0)
	{
		//Screen
		color = 1.0 - ((1.0-orig)*(1.0-color));
	}
	
	if(BlendMode == 1)
	{
		//WarmScreen
		color = (1.0 - (2*(1.0 - orig) * (1.0 - (color))));
	}
	
	if(BlendMode == 2)
	{
		//Softlight
		float3 B = color;
		float3 A = orig;
		//color = B/(1.0-A);
		color = (1-(1-A))/(2*B);
		//color = lerp((2*B-1)*(A-pow(A,2))+A, (2*B-1)*(pow(A,0.5)-A)+A,step(0.5,dot(B,0.333333)));
		//color = lerp(2*orig*color + orig*orig*(1.0-2*color), 2*orig*(1.0-color)+pow(orig,0.5)*(2*color-1.0), step(0.49,dot(color,0.333333)));
	}
	
	float thresholdMask = 1.0;
	
	if(Threshold != 1.000 && ThresholdRange != 0.000)
	{
	if(ThresholdMaskType == 0)
	{
		thresholdMask = max(orig.r,max(orig.g,orig.b));
	}
	
	if(ThresholdMaskType == 1)
	{
		thresholdMask = dot(orig,0.333333);
	}
	
	if(ThresholdMaskType == 2)
	{
		thresholdMask = min(orig.r,min(orig.g,orig.b));
	}
	
	if(ThresholdMaskType == 3)
	{
		thresholdMask = (min(orig.r,min(orig.g,orig.b)));
		thresholdMask += max(orig.r,max(orig.g,orig.b));
		thresholdMask *= 0.5;
	}
	
	thresholdMask = lerp(0.0,1.0,smoothstep(Threshold-(Threshold*ThresholdRange),Threshold,thresholdMask));

	}
	
	color = lerp(orig,color,thresholdMask);
	
	orig = lerp(orig, color, Strength);
	
	float dither_shift = 1.0;
	
	if(GrainStrength != 0)
	{
	float t = (timer * 0.0005) ;
	float dither_bit  = 3.0;
	float sine = sin(dot(texcoord, float2(12.9898,78.233)));
	float noise = frac(sine * 43758.5453 + texcoord.x + t);
	dither_shift = (1.0 / (pow(2,dither_bit) - 1.0));
	float dither_shift_half = (dither_shift * 0.5);
	dither_shift = dither_shift * noise - dither_shift_half;
	}
	
	orig -= (dither_shift*thresholdMask*GrainStrength);
	
	if(DebugMode == 1)
	{
		orig = thresholdMask;
	}
	
	return saturate(orig);
}

float3 Diffuse1(in float4 pos : SV_Position, in float2 texcoord : TEXCOORD) : COLOR
{

float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;

if(BlurRadius == 0)	
{
	float offset[4] = { 0.0, 1.1824255238, 3.0293122308, 5.0040701377 };
	float weight[4] = { 0.39894, 0.2959599993, 0.0045656525, 0.00000149278686458842 };
	
	color *= weight[0];
	
	[loop]
	for(int i = 1; i < 4; ++i)
	{
		color += tex2D(ReShade::BackBuffer, texcoord + float2(offset[i] * ReShade::PixelSize.x, 0.0)).rgb * weight[i];
		color += tex2D(ReShade::BackBuffer, texcoord - float2(offset[i] * ReShade::PixelSize.x, 0.0)).rgb * weight[i];
	}
}	

if(BlurRadius == 1)	
{
	float offset[6] = { 0.0, 1.4584295168, 3.40398480678, 5.3518057801, 7.302940716, 9.2581597095 };
	float weight[6] = { 0.13298, 0.23227575, 0.1353261595, 0.0511557427, 0.01253922, 0.0019913644 };
	
	color *= weight[0];
	
	[loop]
	for(int i = 1; i < 6; ++i)
	{
		color += tex2D(ReShade::BackBuffer, texcoord + float2(offset[i] * ReShade::PixelSize.x, 0.0)).rgb * weight[i];
		color += tex2D(ReShade::BackBuffer, texcoord - float2(offset[i] * ReShade::PixelSize.x, 0.0)).rgb * weight[i];
	}
}	

if(BlurRadius == 2)	
{
	float offset[11] = { 0.0, 1.4895848401, 3.4757135714, 5.4618796741, 7.4481042327, 9.4344079746, 11.420811147, 13.4073334, 15.3939936778, 17.3808101174, 19.3677999584 };
	float weight[11] = { 0.06649, 0.1284697563, 0.111918249, 0.0873132676, 0.0610011113, 0.0381655709, 0.0213835661, 0.0107290241, 0.0048206869, 0.0019396469, 0.0006988718 };
	
	color *= weight[0];
	
	[loop]
	for(int i = 1; i < 11; ++i)
	{
		color += tex2D(ReShade::BackBuffer, texcoord + float2(offset[i] * ReShade::PixelSize.x, 0.0)).rgb * weight[i];
		color += tex2D(ReShade::BackBuffer, texcoord - float2(offset[i] * ReShade::PixelSize.x, 0.0)).rgb * weight[i];
	}
}	

if(BlurRadius == 3)	
{
	float offset[15] = { 0.0, 1.4953705027, 3.4891992113, 5.4830312105, 7.4768683759, 9.4707125766, 11.4645656736, 13.4584295168, 15.4523059431, 17.4461967743, 19.4401038149, 21.43402885, 23.4279736431, 25.4219399344, 27.4159294386 };
	float weight[15] = { 0.0443266667, 0.0872994708, 0.0820892038, 0.0734818355, 0.0626171681, 0.0507956191, 0.0392263968, 0.0288369812, 0.0201808877, 0.0134446557, 0.0085266392, 0.0051478359, 0.0029586248, 0.0016187257, 0.0008430913 };
	
	color *= weight[0];
	
	[loop]
	for(int i = 1; i < 15; ++i)
	{
		color += tex2D(ReShade::BackBuffer, texcoord + float2(offset[i] * ReShade::PixelSize.x, 0.0)).rgb * weight[i];
		color += tex2D(ReShade::BackBuffer, texcoord - float2(offset[i] * ReShade::PixelSize.x, 0.0)).rgb * weight[i];
	}
}	

if(BlurRadius == 4)	
{
	float offset[18]
 = { 0.0, 1.4953705027, 3.4891992113, 5.4830312105, 7.4768683759, 9.4707125766, 11.4645656736, 13.4584295168, 15.4523059431, 17.4461967743, 19.4661974725, 21.4627427973, 23.4592916956, 25.455844494, 27.4524015179, 29.4489630909, 31.445529535, 33.4421011704 };
	float weight[18] = { 0.033245, 0.0659162217, 0.0636705814, 0.0598194658, 0.0546642566, 0.0485871646, 0.0420045997, 0.0353207015, 0.0288880982, 0.0229808311, 0.0177815511, 0.013382297, 0.0097960001, 0.0069746748, 0.0048301008, 0.0032534598, 0.0021315311, 0.0013582974 };
	
	color *= weight[0];
	
	[loop]
	for(int i = 1; i < 18; ++i)
	{
		color += tex2D(ReShade::BackBuffer, texcoord + float2(offset[i] * ReShade::PixelSize.x, 0.0)).rgb * weight[i];
		color += tex2D(ReShade::BackBuffer, texcoord - float2(offset[i] * ReShade::PixelSize.x, 0.0)).rgb * weight[i];
	}
}	
	return saturate(color);
}

technique DiffuseGlow
{
	pass Blur1
	{
		VertexShader = PostProcessVS;
		PixelShader = Diffuse1;
		RenderTarget = DiffuseTex;
	}
	pass BlurFinal
	{
		VertexShader = PostProcessVS;
		PixelShader = DiffuseFinal;
	}
}