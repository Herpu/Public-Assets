// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader ".Herpu/NSPHSV Particle ADD 2" {
Properties {
		[Header(Texture)]
	[HDR]_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	_MainTex ("Particle Texture", 2D) = "white" {}
		[Header(Scrolling)]
	[Enum(Alpha Channel,2,Manual Shift,1,Time Based,0)] ScrTy("Scroll Type", Int) = 0
	xscrollspeed ("X Scroll", Float) = 0
	yscrollspeed ("Y Scroll", Float) = 0
		[Header(RGB Modification)]
	_hue ("Hue Shift", Float ) = 0
	_sat ("Saturation", Float ) = 0
	_exp ("Exposure", Float ) = 0
		[Header(Advanced)]
	[Enum(UnityEngine.Rendering.CullMode)] _Culling ("Cull Mode", Int) = 2
    [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
	[Enum(On,1,Off,0)] _z("ZWrite", Int) = 0
		[Header(Blending)]
	[Enum(UnityEngine.Rendering.BlendMode)] _Blend ("Blend mode Destination", Int) = 1
//	[Enum(Additive,0,Blended,1)] Blendmode("A", Int) = 0
}

Category {
	Tags { "Queue"="Transparent+2" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
	Blend SrcAlpha [_Blend]
	ColorMask RGB
	Cull [_Culling] Lighting Off ZWrite [_z] ZTest [_ZTest]

	SubShader {
		Pass {

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_particles
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			sampler2D _MainTex;

			fixed4 _TintColor;

			float xscrollspeed;
			float yscrollspeed;
			float ScrTy;
			float _hue;
			float _sat;
			float _exp;
			float Blendmode;
			float _Blend;


			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)

				UNITY_VERTEX_OUTPUT_STEREO
			};

			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}


			
			fixed4 frag (v2f i) : SV_Target
			{

				
				float u = i.texcoord.x+(_Time*xscrollspeed);
				float v = i.texcoord.y+(_Time*yscrollspeed);
				if(ScrTy==1){
				u=i.texcoord.x+xscrollspeed;
				v=i.texcoord.y+yscrollspeed;
				}
				if(ScrTy==2){
				u = i.texcoord.x+(i.color.a*xscrollspeed);
				v = i.texcoord.y+(i.color.a*yscrollspeed);
				}
				float2 uvscroll = float2(u,v);
				


				fixed4 col1 = tex2D(_MainTex, uvscroll);
				
				float4 n1 = col1;
                float4 _k = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
                float4 _p = lerp(float4(float4(n1.rgb,0.0).zy, _k.wz), float4(float4(n1.rgb,0.0).yz, _k.xy), step(float4(n1.rgb,0.0).z, float4(n1.rgb,0.0).y));
                float4 _q = lerp(float4(_p.xyw, float4(n1.rgb,0.0).x), float4(float4(n1.rgb,0.0).x, _p.yzx), step(_p.x, float4(n1.rgb,0.0).x));
                float _d = _q.x - min(_q.w, _q.y);
                float _e = 1.0e-10;
                float3 _kpqde = float3(abs(_q.z + (_q.w - _q.y) / (6.0 * _d + _e)), _d / (_q.x + _e), _q.x);;
                float3 OUTPUT = (lerp(float3(1,1,1),saturate(3.0*abs(1.0-2.0*frac((_kpqde.r+_hue)+float3(0.0,-1.0/3.0,1.0/3.0)))-1),(_kpqde.g+_sat))*(_kpqde.b+_exp));
				
				fixed3 col = 2.0f * i.color.rgb * _TintColor.rgb * OUTPUT.rgb * col1.a * i.color.a * _TintColor.a;
				
				
				float4 nigga = float4(col,1);
				if(_Blend==10){
				col = 2.0f * i.color.rgb * _TintColor.rgb * OUTPUT.rgb;
				nigga = float4(col,col1.a * i.color.a * _TintColor.a);
				}
				return nigga;
			}
			ENDCG
		}
	}
}
}
