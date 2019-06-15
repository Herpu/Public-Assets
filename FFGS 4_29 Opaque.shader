Shader "Herpu/.FFGS/Opaque 4.29"
{
    Properties
    {
        [Header(Full Feature Geometry Shader By Herpu)]
        [Header(v4.28)]
        [Header(One Zero Opaque)]
        [Header(Main Texture)]
        [HDR]_Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _ColorEnhance ("Color Enhance", Range(-2, 2)) = 0
        
        [Header(Cutout)]
        _Cutoff ("Alpha cutoff", Range(0, 1.01)) = 0.5
        [MaterialToggle] _clip ("clip", Float) = 1
        [HideInInspector]_TextureTransparency ("Alpha to Opaque", Range(0, 1)) = 1
        [HideInInspector]_subtractalpha ("Minus Transparency", Range(0, 1)) = 0
        
		[Header(Dissolve Cutout)]
		_CutoutDissolve ("Dissolve Cutout Tex", 2D) = "white" { }
		_CutoutDissolveMap ("Dissolve Cutout Map", 2D) = "white" { }
        _CutoffDS ("Dissolve Red Channel", Range(0, 2)) = 0
		_UCS ("Dissolve Scroll X", Float ) = 0
		_VCS ("Dissolve Scroll Y", Float ) = 0
		[MaterialToggle] _clipDIS ("Enable Dissolve", Float) = 0
		
		[Header(Distance Dissolve)]
		[Enum(ON,1,OFF,0)] DDisvTOG("Distance Disolve Toggle", Int) = 0
		[Enum(Mesh UVs,0,Screen UVs,1)] DBDUVS("Texture Alignment", Int) = 0
		_DistanceDisolve ("Disolve Tex", 2D) = "white" { }
        _dbdisolve ("Dissolve Minimum", Range(0, 1)) = 0
		_UCSDB ("Dissolve Scroll X", Float ) = 0
		_VCSDB ("Dissolve Scroll Y", Float ) = 0
		_mindist ("Min Dist", Float ) = 10
		_maxdist ("Max Dist", Float ) = 20
		
		
        [Header(Normalmapping)]
        _BumpMap ("Normalmap", 2D) = "bump" { }
		_NS ("Strength", Float ) = 1
        [Header(Emission)]
        [HDR]_EmissionColor ("Emission Color", Color) = (1, 1, 1, 0)
        _Emissionmap ("Emission Map", 2D) = "white" { }
        _Emission ("Emission", 2D) = "white" { }
		
		_EmissionMultb ("Emission Mult", Float ) = 1
		_UscrE ("Emission Scroll X", Float ) = 0
		_VscrE ("Emission Scroll Y", Float ) = 0
        
        [Header(Cubemap)]
        [HDR]_CubemapColor ("Cubemap Color", Color) = (1, 1, 1, 0)
        _CubemapMap ("Reflection Map", 2D) = "white" { }
        [NoScaleOffset]_Cubemap ("Cubemap", Cube) = "_Skybox" { }
        
        
        [Header(Matcap)]
        [HDR]_MatcapColor ("Matcap Color", Color) = (1, 1, 1, 1)
        _MatcapMap ("Matcap Map", 2D) = "white" { }
        _Matcap ("Matcap", 2D) = "black" { }
        [MaterialToggle] _MCmul ("Multiply", Float) = 0
		_matcapmod ("Matcap zoom", Range(0, 1)) = 0.5
		
        [Header(Poiyomis Matcap)]
        [HDR]_PMatcapColor ("pMatcap Color", Color) = (1, 1, 1, 1)
        _PMatcapMap ("pMatcap Map", 2D) = "white" { }
        _PMatcap ("pMatcap", 2D) = "black" { }
        [MaterialToggle] _PMCmul ("pMultiply", Float) = 0
		_Pmatcapmod ("pMatcap zoom", Range(0, 1)) = 0.5
        
        [Header(Custom Toon)]
        [HDR]_ToonColor ("Toon Color", Color) = (1, 1, 1, 1)
        _ToonMap ("Toon Map", 2D) = "white" { }
        _Toontx ("Toon", 2D) = "white" { }
		_toonmod ("Toon zoom", Range(0, 1)) = 0.5

        
        [Header(Lighting)]
        [Header(Directional Light Shadow)]
		_ramptex ("ramp", 2D) = "white" { }
		[MaterialToggle] uvvertical ("use vertical texture", Float) = 0
		LitMul ("Ramp effect percent", Range(0, 1)) = 0.5
		shiftlightedge ("Shift Ramp (light)", Range(-5, 5)) = 2
		edgesmooth ("smooth ramp", Range(0, 1)) = 1
		lightDirectionFAKE ("Fake Light Direction", Vector) = (0.1, 0.3, -0.1, 0)
		_controlshadowinfluence ("World Directional Light Influence", Range(0, 1)) = 0.7
		Brightness ("Brightness", Range(0, 1.5)) = 1

		[Header(haha CUBE)]
		_round ("become cube", Range(0,1)) = 0
		_rscale ("cube size", Float) = 1
	


        [Header(Leave the rest default unless you know what you are doing)]
        [Header(Advanced)]
        [Enum(UnityEngine.Rendering.CullMode)] _Culling ("Cull Mode", Int) = 2
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
        
        [Header(Stenciling)]
        _Stencil ("Stencil ID [0-255]", Float) = 0
        _ReadMask ("ReadMask [0-255]", Int) = 255
        _WriteMask ("WriteMask [0-255]", Int) = 255
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Int) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilOp ("Stencil Operation", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Stencil Fail", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("Stencil ZFail", Int) = 0
    }
    SubShader
    {
        Tags { "IgnoreProjector" = "True" "Queue" = "Geometry+1" "RenderType" = "Opaque" }
	
        Pass
        {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardBase" }
			Blend One Zero
            
            Ztest [_ZTest]
            Cull [_Culling]
            
            Stencil
            {
                Ref [_Stencil]
                ReadMask [_ReadMask]
                WriteMask [_WriteMask]
                Comp [_StencilComp]
                Pass [_StencilOp]
                Fail [_StencilFail]
                ZFail [_StencilZFail]
            }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles
            #pragma target 2.0
            uniform float4 _LightColor0;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
           

            uniform sampler2D _CutoutDissolve; uniform float4 _CutoutDissolve_ST;
            uniform sampler2D _CutoutDissolveMap; uniform float4 _CutoutDissolveMap_ST;
            uniform fixed _clip;
            uniform fixed _clipDIS;
            uniform fixed _CutoffDS;
			
			
            uniform sampler2D _DistanceDisolve; uniform float4 _DistanceDisolve_ST;
			uniform fixed _dbdisolve;
			uniform fixed _UCSDB;
			uniform fixed _VCSDB;
			uniform fixed _mindist;
			uniform fixed _maxdist;
			uniform fixed DDisvTOG;
			uniform fixed DBDUVS;
			
            uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
            uniform float4 _ToonSettings;
            uniform fixed _toon;
            uniform float _controlshadowinfluence;

            uniform float _ColorEnhance;
            uniform sampler2D _Emission; uniform float4 _Emission_ST;
            uniform sampler2D _Emissionmap; uniform float4 _Emissionmap_ST;

            uniform float4 _EmissionColor;
            uniform samplerCUBE _Cubemap;
            uniform float4 _CubemapColor;
            uniform fixed _TextureTransparency;
            uniform sampler2D _Matcap; uniform float4 _Matcap_ST;
            uniform sampler2D _PMatcap; uniform float4 _PMatcap_ST;
            uniform sampler2D _Toontx; uniform float4 _Toontx_ST;
            uniform sampler2D _MatcapMap; uniform float4 _MatcapMap_ST;
            uniform sampler2D _PMatcapMap; uniform float4 _PMatcapMap_ST;
            uniform sampler2D _ToonMap; uniform float4 _ToonMap_ST;
            uniform float4 _MatcapColor;
            uniform float4 _PMatcapColor;
            uniform float4 _ToonColor;
            uniform fixed _Cutoff;
            uniform fixed _MCmul;
            uniform fixed _PMCmul;
            uniform fixed _subtractalpha;
            uniform fixed _matcapmod;
            uniform fixed _toonmod;
            uniform fixed _Pmatcapmod;
       
            uniform fixed _UscrE;
            uniform fixed _UCS;

            uniform fixed _VscrE;
            uniform fixed _VCS;
            uniform fixed _NS;
            uniform fixed _EmissionMultb;
            uniform fixed LitMul;
            uniform fixed LitMulFR;
            uniform fixed shiftlightedge;
            uniform fixed edgesmooth;
            uniform fixed shiftedgedarken;
            uniform fixed uvvertical;
            uniform fixed Brightness;
            uniform fixed4 lightDirectionFAKE;
			float _round;
			float _rscale;
			

            uniform sampler2D _ramptex; uniform float4 _ramptex_ST;
            uniform sampler2D _LightTextureB0; //uniform float4 _LightTextureB0;
            
            uniform sampler2D _CubemapMap; uniform float4 _CubemapMap_ST;
            
            struct VertexInput
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 tangent: TANGENT;
                float2 texcoord0: TEXCOORD0;
            };
            struct VertexOutput
            {
                float4 pos: SV_POSITION;
                float2 uv0: TEXCOORD0;
                float4 posWorld: TEXCOORD1;
                float3 normalDir: TEXCOORD2;
                float3 tangentDir: TEXCOORD3;
                float3 bitangentDir: TEXCOORD4;
                float3 cameraToVert: TEXCOORD5;
				float4 projPos : TEXCOORD6;
				
            };

            float3 getCameraPosition()
            {
                #ifdef USING_STEREO_MATRICES
                    return lerp(unity_StereoWorldSpaceCameraPos[0], unity_StereoWorldSpaceCameraPos[1], 0.5);
                #endif
                return _WorldSpaceCameraPos;
            }

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				
				v.vertex.xyz = lerp(v.vertex.xyz,(((ceil(v.vertex.xyz*_rscale)/_rscale))-(0.5/_rscale)),_round);
				
                o.pos = UnityObjectToClipPos(v.vertex);
                o.cameraToVert = normalize(getCameraPosition() - mul(unity_ObjectToWorld, v.vertex));
				o.projPos = ComputeScreenPos (o.pos);
                return o;
            }
            float4 frag(VertexOutput i): COLOR
            {
				
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _BumpMap_var = UnpackNormal(tex2D(_BumpMap, TRANSFORM_TEX(i.uv0, _BumpMap)));
                float3 normalLocal = float3(_BumpMap_var.r*_NS,_BumpMap_var.g*_NS,_BumpMap_var.b);
                float3 normalDirection = normalize(mul(normalLocal, tangentTransform)); // Perturbed normals
                float3 viewReflectDirection = reflect(-viewDirection, normalDirection);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                
                float4 _MainTex_var = tex2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
				float _CU = i.uv0.r+(_Time*_UCS);
				float _CV = i.uv0.g+(_Time*_VCS);
				float2 UVDISSOLVE = float2(_CU,_CV);
                float4 _CutoutDissolve_var = tex2D(_CutoutDissolve, TRANSFORM_TEX(UVDISSOLVE, _CutoutDissolve));
                float4 _CutoutDissolveMap_var = tex2D(_CutoutDissolveMap, TRANSFORM_TEX(i.uv0, _CutoutDissolveMap));
                clip(lerp(1.0, _MainTex_var.a, _clip) - _Cutoff);
                
              
                float3 lightColor = _LightColor0.rgb;
				
				
				
				
				
				
				float ESU = (i.uv0.r + (_Time * _UscrE));
				float ESV = (i.uv0.g + (_Time * _VscrE));
				
                float2 ESUV = float2(ESU,ESV);
                
                float4 _Emission_var = tex2D(_Emission, TRANSFORM_TEX(ESUV, _Emission));
                float4 _Emissionmap_var = tex2D(_Emissionmap, TRANSFORM_TEX(i.uv0, _Emissionmap));
				float3 _Emissionend = _Emission_var.rgb*_Emissionmap_var.rgb;
				

               
                float _RAMPSHITUV = pow(dot((shiftlightedge+normalDirection), lightDirectionFAKE),edgesmooth);
				float2 _RAMPUV = float2((_RAMPSHITUV*(1-uvvertical)),(_RAMPSHITUV*(uvvertical)));
				float4 _ramptex_var = tex2D(_ramptex, TRANSFORM_TEX(_RAMPUV, _ramptex));
                float3 _RAMPSHADOWFINAL = (_ramptex_var.rgb*LitMul)+(1-LitMul);
             
            
				
				
                float3 reflectedDir = reflect(i.cameraToVert, normalDirection);
                reflectedDir.y *= -1;
           
                float2 PMatcapuv = reflectedDir.rg * _Pmatcapmod + 0.5;
				float2 Toonuv = (mul( UNITY_MATRIX_V, float4(normalDirection,0) ).xyz.rgb.rg*_toonmod+0.5);
				float2 Matcapuv = (mul( UNITY_MATRIX_V, float4(normalDirection,0) ).xyz.rgb.rg*_matcapmod+0.5);

                float4 _Matcap_var = tex2D(_Matcap, TRANSFORM_TEX(Matcapuv, _Matcap));
                float4 _PMatcap_var = tex2D(_PMatcap, TRANSFORM_TEX(PMatcapuv, _PMatcap));
                float4 _Toontx_var = tex2D(_Toontx, TRANSFORM_TEX(Toonuv, _Toontx));
                float4 _MatcapMap_var = tex2D(_MatcapMap, TRANSFORM_TEX(i.uv0, _MatcapMap));
                float4 _PMatcapMap_var = tex2D(_PMatcapMap, TRANSFORM_TEX(i.uv0, _PMatcapMap));
                float4 _ToonMap_var = tex2D(_ToonMap, TRANSFORM_TEX(i.uv0, _ToonMap));
                float4 _CubemapMap_var = tex2D(_CubemapMap, TRANSFORM_TEX(i.uv0, _CubemapMap));
                
                float button1 = (1.0 - _MCmul);
                float Pbutton1 = (1.0 - _PMCmul);
                float3 Toonshit2 = ((_Toontx_var.rgb * _ToonColor.a * _ToonColor.rgb * _ToonMap_var.rgb) + (1 - _ToonMap_var.rgb) * _ToonColor.a) + (1 - _ToonColor.a);
                
                float3 MatcapMult = ((((_Matcap_var.rgb * _MatcapColor.a * _MatcapColor.rgb * _MatcapMap_var.rgb) + (1 - _MatcapMap_var.rgb) * _MatcapColor.a) + (1 - _MatcapColor.a)) * _MCmul) + button1;
                float3 PMatcapMult = ((((_PMatcap_var.rgb * _PMatcapColor.a * _PMatcapColor.rgb * _PMatcapMap_var.rgb) + (1 - _PMatcapMap_var.rgb) * _PMatcapColor.a) + (1 - _PMatcapColor.a)) * _PMCmul) + Pbutton1;
               
                float3 main = ((((pow(_MainTex_var.rgb, (_ColorEnhance * 0.6 + 1.0)) * _Color.rgb * _Color.a)) * _RAMPSHADOWFINAL) + (button1 * _Matcap_var.rgb * _MatcapColor.a * _MatcapColor.rgb * _MatcapMap_var.rgb) + (Pbutton1 * _PMatcap_var.rgb * _PMatcapColor.a * _PMatcapColor.rgb * _PMatcapMap_var.rgb));
               
				float3 cmap = (texCUBE(_Cubemap, viewReflectDirection).rgb * _CubemapColor.rgb * _CubemapColor.a * _CubemapMap_var.rgb);

				
				float3 lst = (_LightColor0.rgb*_controlshadowinfluence)+(1.0 - _controlshadowinfluence);
				float3 emission = (_Emissionend * _EmissionColor.rgb * _EmissionColor.a * _EmissionMultb);
				float3 RGBOUT = (main*MatcapMult*PMatcapMult*Toonshit2*lst)+emission+cmap*Brightness;
				
               
				clip(lerp(1.0, ((_CutoutDissolve_var.r*0.99)+(1-_CutoutDissolveMap_var.r)), _clipDIS) - _CutoffDS);
				float TRANSPARENCY = clamp((lerp(_MainTex_var.a, 1, _TextureTransparency))-_subtractalpha,0,1);
				
					if(DDisvTOG==1){
				float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
				float dista = (_maxdist*0.5)-(_mindist*0.5);
				float mind = (_mindist*0.5);
				float maxd = (_maxdist*0.5);
				float DMULT = ((1.0 - saturate((clamp((distance(_WorldSpaceCameraPos,objPos.rgb)-mind),0.0,maxd)/dista))));
				float _CUDB = i.uv0.r+(_Time*_UCSDB);
				float _CVDB = i.uv0.g+(_Time*_VCSDB);
				if(DBDUVS==1){
					float3 uv3 = mul( UNITY_MATRIX_V, float4((i.posWorld.rgb-_WorldSpaceCameraPos),0) ).xyz;
					float2 uv2 = (uv3.rgb.rg/uv3.rgb.b).rg;
					float2 UVS= (1.0 - ((float2((uv2.r*(_ScreenParams.a/_ScreenParams.b)),(uv2.g*2.0)))+0.5));
						_CUDB = UVS.r+(_Time*_UCSDB/2);
						_CVDB = UVS.g+(_Time*_VCSDB);
							}
					
				float2 UVDISSOLVEDB = float2(_CUDB,_CVDB);
                float4 _DistanceDisolve_var = tex2D(_DistanceDisolve, TRANSFORM_TEX(UVDISSOLVEDB, _DistanceDisolve));
				float yeahaeg = (_DistanceDisolve_var.r-1)+DMULT;
					if(yeahaeg<_dbdisolve)discard;
									}
				
				
				
				
				
				
				
				
				
				
               return fixed4(RGBOUT, TRANSPARENCY);
			
				
            }
            ENDCG
            
        }
		Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _CutoutDissolve; uniform float4 _CutoutDissolve_ST;
			uniform sampler2D _CutoutDissolveMap; uniform float4 _CutoutDissolveMap_ST;
            uniform fixed _clip;
            uniform fixed _clipDIS;
            uniform fixed _CutoffDS;
            uniform fixed _TextureTransparency;			
            uniform fixed _UCS;			
            uniform fixed _VCS;			
			uniform fixed _Cutoff;
			float _round;
			float _rscale;
			float _rtype;
			uniform sampler2D _DistanceDisolve; uniform float4 _DistanceDisolve_ST;
			uniform fixed _dbdisolve;
			uniform fixed _UCSDB;
			uniform fixed _VCSDB;
			uniform fixed _mindist;
			uniform fixed _maxdist;
			uniform fixed DDisvTOG;
			
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
				
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
				v.vertex.xyz = lerp(v.vertex.xyz,(((ceil(v.vertex.xyz*_rscale)/_rscale))-(0.5/_rscale)),_round);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
				
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
				
				float4 _MainTex_var = tex2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
				float _CU = i.uv0.r+(_Time*_UCS);
				float _CV = i.uv0.g+(_Time*_VCS);
				float2 UVDISSOLVE = float2(_CU,_CV);
                float4 _CutoutDissolve_var = tex2D(_CutoutDissolve, TRANSFORM_TEX(UVDISSOLVE, _CutoutDissolve));
                float4 _CutoutDissolveMap_var = tex2D(_CutoutDissolveMap, TRANSFORM_TEX(i.uv0, _CutoutDissolveMap));

                clip(lerp(1.0, _MainTex_var.a, _clip) - _Cutoff);
				clip(lerp(1.0, ((_CutoutDissolve_var.r*0.99)+(1-_CutoutDissolveMap_var.r)), _clipDIS) - _CutoffDS);
					if(DDisvTOG+=1){
				float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
				float dista = (_maxdist*0.5)-(_mindist*0.5);
				float mind = (_mindist*0.5);
				float maxd = (_maxdist*0.5);
				float DMULT = ((1.0 - saturate((clamp((distance(_WorldSpaceCameraPos,objPos.rgb)-mind),0.0,maxd)/dista))));
				float _CUDB = i.uv0.r+(_Time*_UCSDB);
				float _CVDB = i.uv0.g+(_Time*_VCSDB);
				float2 UVDISSOLVEDB = float2(_CUDB,_CVDB);
                float4 _DistanceDisolve_var = tex2D(_DistanceDisolve, TRANSFORM_TEX(UVDISSOLVEDB, _DistanceDisolve));
				float yeahaeg = (_DistanceDisolve_var.r-1)+DMULT;
					if(yeahaeg<_dbdisolve)discard;
									}
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
