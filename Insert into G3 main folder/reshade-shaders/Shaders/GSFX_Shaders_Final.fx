//===================================================================================================================
//===================================================================================================================
#include "GSFX_Shaders_Final.fxh"
//===================================================================================================================
//===================================================================================================================
uniform float LIGHTING_STRENGTH <
ui_category = "LIGHTING_SETTINGS";
ui_label = "LIGHTING_STRENGTH";
ui_type = "drag";
> = 1.0;
uniform float LIGHTING_SATURATION <
ui_category = "LIGHTING_SETTINGS";
ui_label = "LIGHTING_SATURATION";
ui_type = "drag";
> = 1.0;

uniform float BLACK_LEVELS_STRENGTH <
ui_category = "LEVELS_SETTINGS";
ui_label = "BLACK_LEVELS_STRENGTH";
ui_type = "drag";
> = 1.0;
uniform float WHITE_LEVELS_STRENGTH <
ui_category = "LEVELS_SETTINGS";
ui_label = "WHITE_LEVELS_STRENGTH";
ui_type = "drag";
> = 1.0;

uniform float SHARPEN_STRENGTH <
ui_category = "BASE_SETTINGS";
ui_label = "SHARPEN_STRENGTH";
ui_type = "drag";
> = 1.0;
uniform float CONTRAST_STRENGTH <
ui_category = "BASE_SETTINGS";
ui_label = "CONTRAST_STRENGTH";
ui_type = "drag";
> = 1.0;
uniform float SATURATION_STRENGTH <
ui_category = "BASE_SETTINGS";
ui_label = "SATURATION_STRENGTH";
ui_type = "drag";
> = 1.0;
uniform float TONEMAPPING_STRENGTH <
ui_category = "BASE_SETTINGS";
ui_label = "TONEMAPPING_STRENGTH";
ui_type = "drag";
> = 1.0;

uniform float BORDER_STRENGTH <
ui_category = "OTHER_SETTINGS";
ui_label = "BORDER_STRENGTH";
ui_type = "drag";
> = 0.0;
//===================================================================================================================
//===================================================================================================================
float get_weight ( float progress ) { float bottom = min ( progress, 0.5 );
float top = max ( progress, 0.5 ); return 2.0 * ( bottom * bottom + top + top - top * top ) - 1.5; }
float get_2D_weight ( float2 position ) { return get_weight ( min ( length ( position ), 1.0 ) ); }
texture TexBloomH { Width = BUFFER_WIDTH * 0.25; Height = BUFFER_HEIGHT * 0.25; Format = RGBA16; };
texture TexBloomV { Width = BUFFER_WIDTH * 0.25; Height = BUFFER_HEIGHT * 0.25; Format = RGBA16; };
sampler2D SamplerBloomH { Texture = TexBloomH; MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR; AddressU = Clamp; AddressV = Clamp; };
sampler2D SamplerBloomV { Texture = TexBloomV; MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR; AddressU = Clamp; AddressV = Clamp; };
//===================================================================================================================
float4 GaussBlurF ( float2 coords : TEXCOORD ) : COLOR { float4 ret = max ( tex2D ( SamplerColor, coords ) - 0.0, 0.0 );
for ( int i=1.0; i < 12.0; i++ ) { ret += max ( tex2D ( SamplerColor, coords + float2 ( i * PixelSize.x * 10.0, 0.0 ) ) - 0.0, 0.0 );
ret += max ( tex2D ( SamplerColor, coords - float2 ( i * PixelSize.x * 10.0, 0.0 ) ) - 0.0, 0.0 ); } return ret / ( 1.0 - 0.0 ) / 23.0; }
float4 GaussBlurH ( float2 coords : TEXCOORD ) : COLOR { float4 ret = tex2D ( SamplerBloomV, coords );
for ( int i=1.0; i < 12.0; i++ ) { ret += tex2D ( SamplerBloomV, coords + float2 ( i * PixelSize.x * 10.0, 0.0 ) );
ret += tex2D ( SamplerBloomV, coords - float2 ( i * PixelSize.x * 10.0, 0.0 ) ); } return ret / 23.0; }
float4 GaussBlurV ( float2 coords : TEXCOORD ) : COLOR { float4 ret = tex2D ( SamplerBloomH, coords );
for ( int i=1.0; i < 12.0; i++ ) { ret += tex2D ( SamplerBloomH, coords + float2 ( 0.0, i * PixelSize.y * 10.0 ) ); 
ret += tex2D ( SamplerBloomH, coords - float2 ( 0.0, i * PixelSize.y * 10.0 ) ); } return ret / 23.0; }
float4 GSFX_Shaders_Bloom_1 ( float4 vpos : SV_Position, float2 texcoord : TEXCOORD ) : COLOR { return GaussBlurF ( texcoord ); }
float4 GSFX_Shaders_Bloom_3 ( float4 vpos : SV_Position, float2 texcoord : TEXCOORD ) : COLOR { return GaussBlurH ( texcoord ); }
float4 GSFX_Shaders_Bloom_2 ( float4 vpos : SV_Position, float2 texcoord : TEXCOORD ) : COLOR { return GaussBlurV ( texcoord ); }
float4 GSFX_Shaders_Bloom_4 ( float4 vpos : SV_Position, float2 texcoord : TEXCOORD ) : COLOR
{ float4 ret = tex2D ( SamplerColor, texcoord ); float4 bloom = tex2D ( SamplerBloomV, texcoord );
bloom.rgb = lerp ( dot ( bloom.rgb, float3 ( 0.3, 0.3, 0.3 ) ), bloom.rgb, LIGHTING_SATURATION ) * LIGHTING_STRENGTH * 0.1;
ret.rgb += bloom.rgb * saturate ( 1.0 - ret.rgb ); return ret; }
//===================================================================================================================
void GSFX_Shaders_Bloom_5 ( float4 vpos : SV_Position, float2 tex_coord : TEXCOORD, out float3 softened : SV_Target)
{ softened = 0.0; float total_weight = 0.0; for ( int y = 0.0; y < LIGHTING_STRENGTH; y++) for ( int x = 0.0; x < LIGHTING_STRENGTH; x++)
{ float2 current_position = float2 ( x,y ) / LIGHTING_STRENGTH; float current_weight = get_2D_weight ( 1.0 - current_position );
float2 current_offset = PixelSize * LIGHTING_STRENGTH * current_position * ( 1.0 - current_weight );
total_weight += current_weight; softened += (
tex2Dlod ( SamplerColor, float4 ( tex_coord + current_offset, 0.0, 0.0 ) ).rgb +
tex2Dlod ( SamplerColor, float4 ( tex_coord - current_offset, 0.0, 0.0 ) ).rgb +
tex2Dlod ( SamplerColor, float4 ( tex_coord + float2 ( current_offset.x, -current_offset.y ), 0.0, 0.0 ) ).rgb +
tex2Dlod ( SamplerColor, float4 ( tex_coord - float2  ( current_offset.x, -current_offset.y ), 0.0, 0.0 ) ).rgb ) *
current_weight; } softened /= total_weight * 4.0; }
//===================================================================================================================
float4 GSFX_Shaders_Sharpen ( float4 vpos : SV_Position, float2 texcoord : TEXCOORD ) : COLOR
{ float4 ret = tex2D ( SamplerColor, texcoord );
const float2 tap [ 4 ] = { float2 ( -1.0, -1.0 ), float2 ( 1.0, -1.0 ), float2 ( 1.0, 1.0 ), float2 ( -1.0, 1.0 ) };
float mask; for ( int i = 0; i < 4; i++ ) { mask += LumaChroma ( tex2D ( SamplerColor, texcoord + tap [ i ] * PixelSize * 0.1 ) ).w; }
float4 lumachroma = LumaChroma ( ret ); mask += lumachroma.w; mask /= 5; 
lumachroma.w += ( lumachroma.w - mask ) * SHARPEN_STRENGTH;
ret.rgb = lumachroma.w * lumachroma.rgb; ret.w = 1.0; return ret; }
//===================================================================================================================
float3 GSFX_Shaders_Colors ( float4 position : SV_Position, float2 texcoord : TexCoord ) : SV_Target
{ float3 color = tex2D ( SamplerColor, texcoord ).rgb; float3 coefLuma = float3 ( 0.3, 0.3, 0.3 );
float luma = dot ( coefLuma, color ); float max_color = max ( color.r, max ( color.g, color.b ) );
float min_color = min ( color.r, min ( color.g, color.b ) ); float color_saturation = max_color - min_color;
float3 coeffVibrance = float3 ( 1.0, 1.0, 1.0 ) * SATURATION_STRENGTH * 0.1; color = lerp
( luma, color, 1.0 + ( coeffVibrance * ( 1.0 - ( sign ( coeffVibrance ) * color_saturation ) ) ) ); return color; }
//===================================================================================================================
float3 GSFX_Shaders_Levels ( float4 vpos : SV_Position, float2 texcoord : TexCoord ) : SV_Target
{ float black_point_float = BLACK_LEVELS_STRENGTH / 255.0;
float white_point_float = WHITE_LEVELS_STRENGTH / 255.0 + 1.0;
float3 color = tex2D ( SamplerColor, texcoord ).rgb;
color = color * white_point_float - ( black_point_float *  white_point_float ); return color; }
//===================================================================================================================
float3 GSFX_Shaders_Tonemapping ( float4 position : SV_Position, float2 texcoord : TexCoord ) : SV_Target
{ const float4 x = tex2D ( SamplerColor, texcoord );
const float3 A = 0.65f * TONEMAPPING_STRENGTH; const float3 B = 0.17f; const float3 C = 1.83f;
const float3 D = 1.1f; const float3 E = 0.05f; const float3 F = 0.57f; const float3 W = 1.0f;
const float3 F_linearWhite = ( ( W * ( A * W + C * B ) + D * E ) / ( W * ( A * W + B ) + D * F ) ) - ( E / F );
const float3 F_linearColor = ( ( x .xyz * ( A * x.xyz + C * B ) + D * E ) / ( x.xyz * ( A * x.xyz + B ) + D * F ) ) - ( E / F );
return pow ( saturate ( F_linearColor / F_linearWhite ), 1.0 ); }
//===================================================================================================================
float4 GSFX_Shaders_Tonemapping_Contrast ( float4 vpos : SV_Position, float2 texcoord : TexCoord ) : SV_Target
{ float4 colorInput = tex2D ( SamplerColor, texcoord );
float3 lumCoeff = float3 ( 0.2, 0.2, 0.2 ); float Contrast_blend = CONTRAST_STRENGTH * 0.2;
float luma = dot ( lumCoeff, colorInput.rgb ); float3 chroma = colorInput.rgb - luma;
float3 x; x = luma; x = x * x * ( 3.0 - 2.0 * x ); x = lerp ( luma, x, Contrast_blend );
colorInput.rgb = x + chroma; return colorInput; }
//===================================================================================================================
//===================================================================================================================
float3 GSFX_Shaders_Tonemapping_BorderPass ( float4 vpos : SV_Position, float2 texcoord : TexCoord ) : SV_Target
{ float3 color = tex2D ( SamplerColor, texcoord ).rgb;
float2 border_width_variable = 0.0; if ( 0.0 == -0.0 ) 
if ( AspectRatio < 2.2 ) border_width_variable = float2 ( 0.0, ( BUFFER_HEIGHT - ( BUFFER_WIDTH / 2.2 ) ) * ( BORDER_STRENGTH * 0.5 ) );
else border_width_variable = float2 ( ( BUFFER_WIDTH - ( BUFFER_HEIGHT * 2.2 ) ) * 0.5, 0.0 );
float2 border = ( PixelSize * border_width_variable ); 
float2 within_border = saturate ( ( -texcoord * texcoord + texcoord ) - ( -border * border + border ) );
return all ( within_border ) ? color : 0.0; }
//===================================================================================================================
//===================================================================================================================
technique GSFX_Shaders_Final
{
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_1; RenderTarget = TexBloomH; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_2; RenderTarget = TexBloomV; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_3; RenderTarget = TexBloomH; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_2; RenderTarget = TexBloomV; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_4; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_5; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Sharpen; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Colors; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Levels; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Tonemapping; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Tonemapping_Contrast; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Tonemapping_BorderPass; }
}
//===================================================================================================================
//===================================================================================================================