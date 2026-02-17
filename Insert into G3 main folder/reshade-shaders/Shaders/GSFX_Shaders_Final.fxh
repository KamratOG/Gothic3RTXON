//===================================================================================================================
//===================================================================================================================
#define PixelSize float2 ( BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT )
#define ScreenSize float2 ( BUFFER_WIDTH, BUFFER_HEIGHT )
#define AspectRatio ( BUFFER_WIDTH * BUFFER_RCP_HEIGHT )
uniform float Timer < source = "timer"; >;
uniform float Frametime < source = "frametime"; >;
texture2D texColor : COLOR;
sampler2D SamplerColor { Texture = texColor; MinFilter = LINEAR; 
MagFilter = LINEAR; MipFilter = LINEAR; AddressU = Clamp; AddressV = Clamp; };
//===================================================================================================================
//===================================================================================================================
void PostProcessVS ( in uint id : SV_VertexID, out float4 pos : SV_Position, out float2 texcoord : TEXCOORD )
{ texcoord.x = ( id == 2 ) ? 2.0 : 0.0; texcoord.y = ( id == 1 ) ? 2.0 : 0.0;
pos = float4 ( texcoord * float2 ( 2.0, -2.0 ) + float2 ( -1.0, 1.0 ), 0.0, 1.0 ); }
//===================================================================================================================
//===================================================================================================================
float3 BlendScreen ( float3 a, float3 b ) { return 1 - ( ( 1 - a ) * ( 1 - b ) ); }
float3 BlendSoftLight ( float3 a, float3 b ) { return ( 1 - 2 * b ) * pow ( a, 2 ) + 2 * b * a; }
float3 BlendColorDodge ( float3 a, float3 b ) { return a / ( 1 - b ); }
float3 BlendColorBurn ( float3 a, float3 b ) { return 1 - ( 1 - a ) / b; }
//===================================================================================================================
//===================================================================================================================
float4 LumaChroma ( float4 col ) { float luma = dot ( col.rgb, float3 ( 0.3, 0.3, 0.3 ) ); 
return float4 ( col.rgb / luma, luma ); }
//===================================================================================================================
//===================================================================================================================