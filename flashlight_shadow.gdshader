shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D distortionTexture;
uniform int SAMPLES: hint_range(10, 50, 1) = 32;
uniform vec2 lightPos;

varying vec2 pos;

void fragment(){ 
	float shadows = -1.0;
	
	vec2 direction = normalize(lightPos - pos);
	float lightDistance = length(lightPos - pos);
	
	float rayProgress = 0.0;
	for(int i=0; i < SAMPLES; i++) {
		float sceneDist = texture_sdf(pos + direction * rayProgress);
		
		if (sceneDist <= 0.0 && shadows == -1.0) {
			shadows = 0.0;
		}
		
		if (rayProgress > lightDistance && shadows == -1.0) {
			shadows = 1.0;
		}
		
		rayProgress = rayProgress + sceneDist;
	}
	vec3 light = shadows * vec3(0.6, 0.6, 1.0);
	
	float sceneDistance = texture_sdf(pos);
	float distanceChange = fwidth(sceneDistance) * 0.5;
	float binaryScene = smoothstep(distanceChange, -distanceChange, sceneDistance);
	vec3 geometry = binaryScene * vec3(0.0, 0.3, 0.1);
	
	vec3 col = geometry + light;
	
	vec4 screenColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 flashlightTexture = texture(TEXTURE, UV);
	vec4 mask = screenColor * flashlightTexture;
	
	vec4 invertFlashlight = texture(TEXTURE, UV);
	invertFlashlight.r = 1.0 - invertFlashlight.r;
	invertFlashlight.g = 1.0 - invertFlashlight.g;
	invertFlashlight.b = 1.0 - invertFlashlight.b;
	vec2 distortedUV = SCREEN_UV + texture(distortionTexture, UV).r * 0.005;
	vec4 distortedScreen = texture(SCREEN_TEXTURE, distortedUV);
	vec4 distortColor = distortedScreen * invertFlashlight;
	float brightness = (0.299 * distortColor.r + 0.587 * distortColor.g + 0.114 * distortColor.b) - 0.4;
	vec4 grayScale = vec4(brightness, brightness, brightness, screenColor.a);
	vec4 maskedGrayscale = invertFlashlight * grayScale;
	
	vec2 sdf = sdf_to_screen_uv(SCREEN_UV);
	
	vec4 finalColor = mask + maskedGrayscale;
	
	COLOR = vec4(geometry, 1.0);
}