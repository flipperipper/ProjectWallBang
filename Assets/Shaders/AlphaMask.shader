﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/AlphaMask"
{
Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _AlphaTex ("Alpha mask (R)", 2D) = "white" {}
    _Color ("Main Color", COLOR) = (1,1,1,1)

}

SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    LOD 100
   
    ZWrite Off
    Blend SrcAlpha OneMinusSrcAlpha
   
    Pass {  
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

            struct Input {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                half2 texcoord : TEXCOORD0;
            };

            sampler2D _MainTex;
            sampler2D _AlphaTex;
            float4 _Color;
           
            float4 _MainTex_ST;
           
            v2f vert (Input v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }
           
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.texcoord);
                fixed4 col2 = tex2D(_AlphaTex, i.texcoord);
               
                return _Color * fixed4(col.r, col.g, col.b, col2.r);
            }
        ENDCG
    }
}

}
