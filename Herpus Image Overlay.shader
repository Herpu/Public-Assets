Shader "Herpu/.Image Overlay" {
    Properties {
	 [Header(Herpus Overlay)]
	 [Header(VR ready)]
	[Header(Texture Settings)]
        _MainTex ("Texture", 2D) = "white" {}
		[HDR]_Color ("Color", Color) = (1,1,1,1)
		_opacity ("opacity", Range(0, 1)) = 1
        [MaterialToggle] _removealpha ("Subtract Alpha", Float ) = 0 
		[HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	[Header(Spritesheet Options)]
        _Utile ("U tile", Float ) = 1
        _Vtile ("V tile", Float ) = 1
        _time ("time", Range(0, 1)) = 0
	[Header(Offset Options)]
		_offX ("X Offset", Range(-1, 1)) = 0
		_offY ("Y Offset", Range(-1, 1)) = 0
        _zoom ("zoom", Range(0, 1)) = 0.5
        
        _zoom_copy ("zoom mult", Range(0, 5)) = 1
	[Header(Mesh Offset Options)]
        [MaterialToggle] _overlayoruv ("overlay or uv", Float ) = 0
        [MaterialToggle] _movetoview ("move to view", Float ) = 0    
   
	[Header(Distance Settings)]
_mindist("Minimum Distance", Float) = 5
_maxdist("Maximum Distance", Float) = 10
	[Header(Blend Mode)]
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend mode Source", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend mode Destination", Int) = 10

    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Overlay+5"
            "RenderType"="Transparent"
        }
		
			GrabPass {
			Tags {}
			"_Grabassye"
			}
			
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend [_BlendSrc] [_BlendDst]
            Cull Front
            ZWrite Off
			ZTest Always
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			sampler2D _Grabassye;
            uniform float _Utile;
            uniform float _Vtile;
            uniform float _time;
            uniform float _zoom;
            uniform float _opacity;
            uniform float _zoom_copy;
            uniform fixed _overlayoruv;
            uniform fixed _movetoview;
            uniform fixed4 _Color;
            uniform fixed _removealpha;
			float _mindist;
			float _maxdist;
			float _offX;
			float _offY;
			
			
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;

            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 recipObjScale = float3( length(unity_WorldToObject[0].xyz), length(unity_WorldToObject[1].xyz), length(unity_WorldToObject[2].xyz) );
                v.vertex.xyz += lerp( float3(0,0,0), ((_WorldSpaceCameraPos-objPos.rgb)*recipObjScale), _movetoview );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
				

                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 recipObjScale = float3( length(unity_WorldToObject[0].xyz), length(unity_WorldToObject[1].xyz), length(unity_WorldToObject[2].xyz) );

                float3 node_2096 = mul( UNITY_MATRIX_V, float4((i.posWorld.rgb-_WorldSpaceCameraPos),0) ).xyz;
                float2 node_7310 = (node_2096.rgb.rg/node_2096.rgb.b).rg;
                float2 node_9733 = lerp( (1.0 - ((float2((node_7310.r*(_ScreenParams.a/_ScreenParams.b)),(node_7310.g*2.0))*_zoom*_zoom_copy)+0.5)), i.uv0, _overlayoruv ).rg;
                float node_6042 = 1.0;
            
                float node_4846 = (floor((_time*(_Utile*_Vtile)))/_Utile);
				float _U = ((node_9733.r*(node_6042/_Utile))+(floor((_time*(_Utile*_Vtile)))/_Utile));
				float _V = ((node_9733.g*(node_6042/_Vtile))-(floor((_time*_Vtile))/_Vtile));
				
                float2 UVs = float2(_U,_V);
				float2 UVs2 = float2(UVs.r+(_offX/_Utile),UVs.g+(_offY/_Vtile));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(UVs2, _MainTex));
			//	float4 _ClampTex= tex2D(_MainTex_var,TRANSFORM_TEX(
                float3 emissive = _MainTex_var.rgb*_Color.rgb;
                float3 finalColor = emissive;

			//	float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
float dista = (_maxdist*0.5)-(_mindist*0.5);
float mind = (_mindist*0.5);
float maxd = (_maxdist*0.5);
float DMULT = ((1.0 - saturate((clamp((distance(_WorldSpaceCameraPos,objPos.rgb)-mind),0.0,maxd)/dista))));	
				
				
				float alpha_ = _MainTex_var.a*_Color.a*(_opacity*DMULT);
				float minusalpha = (alpha_*_removealpha)+(1-_removealpha);
				
                return fixed4(finalColor*minusalpha,alpha_);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"

}
