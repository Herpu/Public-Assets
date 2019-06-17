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
	[Enum(Off,0,On,1)] ClampEdge("Clamp Edges", Int) = 0
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
			float ClampEdge;

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
                float3 UV3 = mul( UNITY_MATRIX_V, float4((i.posWorld.rgb-_WorldSpaceCameraPos),0) ).xyz;
                float2 UV2 = (UV3.rgb.rg/UV3.rgb.b).rg;
				float2 offset = float2(_offX,_offY);
                float2 SCUV = lerp( (1.0 - ((float2((UV2.r*(_ScreenParams.a/_ScreenParams.b)),(UV2.g*2.0))*_zoom*_zoom_copy)+0.5)), i.uv0, _overlayoruv ).rg + offset;
				if(ClampEdge==1){
				if(SCUV.r>1)discard;
				if(SCUV.r<0)discard;
				if(SCUV.g>1)discard;
				if(SCUV.g<0)discard;
						}			
				float _time2 = _time;
				float _U = ((SCUV.r*(1/_Utile))+(floor((_time2*(_Utile*_Vtile)))/_Utile));
				float _V = ((SCUV.g*(1/_Vtile))-(floor((_time2*_Vtile))/_Vtile))-(1/_Vtile);
                float2 UVs = float2(_U,_V)-float2(floor(_U),floor(_V));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(UVs, _MainTex));
                float3 emissive = _MainTex_var.rgb*_Color.rgb;
                float3 finalColor = emissive;
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
