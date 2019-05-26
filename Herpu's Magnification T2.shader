Shader "Herpu/Mag T2"
{
    Properties
    {
	[Header(Herpus less scuffed zoom)]
	[Header(make bounding box small af)]
        _Magnification("Magnification", Range(0,5)) = 0
        _mult("Magnification Multiplier", Float) = 1
        Alpha("Transparency", Range(0,1)) = 1
	
	[Header(RGB Modification)]	
		[HDR]_ZColor("Zoom Color", Color) = (1,1,1,1)
		invert("Invert", Range(0,2)) = 0
		_hue("Hue", Range(0,1)) = 0
		_sat("Saturation", Range(-5,5)) = 0
		_exp("Exposure", Range(-1,1)) = 0
		val("Desaturation", Range(-1,1)) = 0
		HDR1("High Dynamic Range", Range(-15,15)) = 0
		HDR1SHIFT("HDR Shift", Range(-10,10)) = 0
		
	[Header(UV Settings)]	
   [Enum(ScreenUV,0,posWorld,1)] vtype("UV Type", Int) = 1
		_val1("wave strength", Range(-0.5,0.5)) = 0
		_val2("wave length", Range(1,150)) = 0
		_val3("Shake Speed", Float) = 0
		_val4("Strength Mult", Float) = 1
		[Enum(Off,0,On,1)] WAVETOG("Wave Toggle", Int) = 0
		p1("wavelength", Float) = 0
		p3("wave move", Float) = 1

		
		
	[Header(Fog Settings)]	
		[HDR]FogCol("Fog Color", Color) = (1,1,1,1)
		FDist("Fog Distance", Float) = 10	
	
	[Enum(Additive,0,Multiply,1)1] FogT("Fog Type", Int) = 1

		


	[Header(Shake Settings)]	
		_xoff("X Offset", Range(-1,1)) = 0
		_yoff("Y Offset", Range(-1,1)) = 0
		_xyoffm("Offset Multiplier", Range(0,5)) = 1
		[Enum(Manual,1,Automatic,0,Mixed,2)] _xyauto("Shake Mode", Int) = 0
		_Ashake("Auto Shake Strength", Range(0,5)) = 0
		_Ashake2("Strength Mult", Range(0,5)) = 1
		_AshakeS("Auto Shake Speed", Range(0,4)) = 2
		
	[Header(Distance Settings)]	
        _mindist("Minimum Distance", Float) = 5
        _maxdist("Maximum Distance", Float) = 10
		
		[Header(Advanced)]
       [Enum(UnityEngine.Rendering.CullMode)] _Culling ("Cull Mode", Int) = 1
	   [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 8
	   [Enum(Off,0,On,1)] _ZWrite("ZWrite", Int) = 1
    }

    SubShader
    {
        Tags{ "Queue" = "Overlay+2" "PreviewType" = "Plane" "RenderType"="Transparent"}
        LOD 100

        GrabPass{"_GrabTexture_zome"}
        Pass
            {
                ZTest [_ZTest]
                ZWrite [_ZWrite]
                Cull [_Culling]
               Blend SrcAlpha OneMinusSrcAlpha
                Lighting Off
                Fog{ Mode Off }
				
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float4 screenUV: TEXCOORD3;
				float4 posWorld : TEXCOORD2;
				float4 projPos : TEXCOORD4;
            };

            sampler2D _GrabTexture_zome;
			sampler2D _CameraDepthTexture;
            half _Magnification;
            float _mult;
            float _mindist;
            float _maxdist;
            float Alpha;
            float _xoff;
            float _yoff;
            float _xyoffm;
            float _xyauto;
            float _Ashake;
            float _Ashake2;
            float _AshakeS;
            float _tType;
            float _depthmod;
            float invert;
            float _hue;
            float _sat;
            float _exp;
            float val;
            float _val1;
            float _val2;
            float _val3;
            float _val4;
            float FogC;
            float FogT;
            float FDist;
            float4 _ZColor;
            float4 FogCol;
            float vtype;
            float HDR1;
            float HDR1SHIFT;
            float WAVETOG;
			float p1; float p2; float p3;
            v2f vert(appdata v)
            {
                v2f o;
				
				float3 _tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
				float3 _normalDir = UnityObjectToWorldNormal(-v.normal);
				float3 _bitangentDir = normalize(cross(_normalDir, _tangentDir) * v.tangent.w);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				float3x3 tangentTransform = float3x3( _tangentDir, _bitangentDir, _normalDir);
				 float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - (mul(unity_ObjectToWorld, v.vertex)));
                o.vertex = UnityObjectToClipPos(v.vertex);
                float4 uv_center = ComputeGrabScreenPos(UnityObjectToClipPos(float4(0, 0, 0, 1)));    
                float4 uv_diff = ComputeGrabScreenPos(o.vertex) - uv_center;
				float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
				float dista = (_maxdist*0.5)-(_mindist*0.5);
                float mind = (_mindist*0.5);
                float maxd = (_maxdist*0.5);
				float DMULT = ((1.0 - saturate((clamp((distance(_WorldSpaceCameraPos,objPos.rgb)-mind),0.0,maxd)/dista))));
                uv_diff /= 1+(_Magnification*_mult*DMULT);
				float4 ouv2 = uv_center + uv_diff;
				float _autoU = cos(_Time*437.783330273*2)*sin(_Time*342.851780603*_AshakeS)*((_Ashake*_Ashake2)/(_Magnification+1))/2;
				float _autoV = cos(_Time*404.449819582*2)*sin(_Time*281.145791157*_AshakeS)*((_Ashake*_Ashake2)/(_Magnification+1));
				float2 _autoUV = float2(_autoU, _autoV)*DMULT;
                float2 _UVxx1 = (float2(_xoff,_yoff)*_xyoffm*DMULT*_xyauto)+((1-_xyauto)*_autoUV);
                o.projPos = ComputeScreenPos (o.vertex);
				float2 sceneUVs = (o.projPos.xy / o.projPos.w);
				float2 lul =_UVxx1+(_val4*sin(sceneUVs*_val2+(_Time*_val3))*_val1);
				if(vtype==1){
				lul =_UVxx1+(_val4*sin(o.posWorld*_val2+(_Time*_val3))*_val1);
				}
				float luld2 = lul.y;
				if(WAVETOG==1){
				float luld2 = tan(lul.y+(tan(sceneUVs.y*p1+p3))*0.05);
				}
				float V1 = _UVxx1.x;
				float U1 = luld2;
				float2 _UVxx =float2(U1,V1);
				o.uv = float4(ouv2.r+_UVxx.r,ouv2.g+_UVxx.g,ouv2.b,ouv2.a);
				return o;
            }

            fixed4 frag(v2f i) : COLOR
            {
				float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
				float dista = (_maxdist*0.5)-(_mindist*0.5);
                float mind = (_mindist*0.5);
                float maxd = (_maxdist*0.5);
				float DMULT = ((1.0 - saturate((clamp((distance(_WorldSpaceCameraPos,objPos.rgb)-mind),0.0,maxd)/dista))));			
				float3 Colorend = ((_ZColor.rgb*DMULT)+(1-DMULT));
                float4 nigger = tex2Dproj(_GrabTexture_zome, UNITY_PROJ_COORD(i.uv));
				float3 n1 = abs(nigger.rgb-invert);
				float4 _k = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
                float4 _p = lerp(float4(float4(n1.rgb,0.0).zy, _k.wz), float4(float4(n1.rgb,0.0).yz, _k.xy), step(float4(n1.rgb,0.0).z, float4(n1.rgb,0.0).y));
                float4 _q = lerp(float4(_p.xyw, float4(n1.rgb,0.0).x), float4(float4(n1.rgb,0.0).x, _p.yzx), step(_p.x, float4(n1.rgb,0.0).x));
                float _d = _q.x - min(_q.w, _q.y);
                float _e = 1.0e-10;
                float3 _kpqde = float3(abs(_q.z + (_q.w - _q.y) / (6.0 * _d + _e)), _d / (_q.x + _e), _q.x);
                float3 n2 = (lerp(float3(1,1,1),saturate(3.0*abs(1.0-2.0*frac((_kpqde.r+_hue)+float3(0.0,-1.0/3.0,1.0/3.0)))-1),(_kpqde.g+_sat))*(_kpqde.b+_exp));
				float3 endcol = (n2*(1-val))+(val*dot(n2,nigger.rgb));
				float2 screenuv = i.uv.xy / _ScreenParams.xy;
                float depth = DecodeFloatRG(tex2Dproj(_CameraDepthTexture, i.uv));
                depth = Linear01Depth(depth);
				//if (depth == 1)discard;
				float diff = depth - Linear01Depth(i.uv.z);
				float intersect = clamp(1 - smoothstep(0, _ProjectionParams.w * FDist, diff),0,1);			
				float3 uwu = endcol+((1-intersect)*FogCol.rgb*FogCol.a);
				if(FogT==1){
				uwu = (endcol*(1-FogCol.a))+(((endcol*intersect)+(1-intersect)*FogCol.rgb)*FogCol.a);
				}
				float3 hdruwu= uwu *(1+(uwu*HDR1)+(-HDR1*0.5*uwu)+HDR1SHIFT);
				return fixed4(hdruwu*Colorend,Alpha*_ZColor.a*DMULT);
            }
            ENDCG
        }
    }
}