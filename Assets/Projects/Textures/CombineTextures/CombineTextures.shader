﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// The Shader takes two textures and blends them together using the _BlendValue
Shader "Ellioman/CombineTextures"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_BlendValue ("Blend Value", Range(0, 1)) = 0.5
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SecondTex ("Base (RGB)", 2D) = "white" {} 
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM
				// Pragmas
				#pragma vertex vertexShader
				#pragma fragment fragmentShader
				
				// Helper functions
				#include "UnityCG.cginc"
				
				// User Defined Variables
				uniform sampler2D _MainTex; 
				uniform sampler2D _SecondTex;
				uniform float _BlendValue;
				
				// These are created by Unity when we use the TRANSFORM_TEX Macro in the
				// vertex shader. XY values controls the texture tiling and ZW the offset
				float4 _MainTex_ST;
				float4 _SecondTex_ST;
				
	 			// Base Input Structs
				struct vertexInput
				{
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
				};
				
				struct vertexOutput
				{
					float4 position : SV_POSITION;
					float2 mainTexUV : TEXCOORD0;
					float2 secondTexUV : TEXCOORD1;
				};
				
				// The Vertex Shader 
				vertexOutput vertexShader(vertexInput IN)
				{
					vertexOutput OUT;
					OUT.position = UnityObjectToClipPos(IN.vertex);
					
					// We use Unity's TRANSFORM_TEX macro to scale and offset the texture
					// coordinates using the tiling and offset from the Unity editor.
					OUT.mainTexUV = TRANSFORM_TEX(IN.texcoord, _MainTex);
					OUT.secondTexUV = TRANSFORM_TEX(IN.texcoord, _SecondTex);
					return OUT;
				}
				
				// The Fragment Shader
				fixed4 fragmentShader(vertexOutput IN) : COLOR
				{
					// Get the color value from the textures
					float4 a = tex2D(_MainTex, IN.mainTexUV);
					float4 b = tex2D(_SecondTex, IN.secondTexUV);
					
					// Blend the two color values
					return lerp(a, b, _BlendValue);
				}
			ENDCG
		}
	}
	Fallback "VertexLit"
}