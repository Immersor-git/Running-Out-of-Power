shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D distortionTexture;

void fragment(){ 
	vec4 screenColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 flashlightTexture = texture(TEXTURE, UV);
	vec4 mask = screenColor * flashlightTexture;
	
	vec4 invertFlashlight = texture(TEXTURE, UV);
	invertFlashlight.r = 1.0 - invertFlashlight.r;
	invertFlashlight.g = 1.0 - invertFlashlight.g;
	invertFlashlight.b = 1.0 - invertFlashlight.b;
	vec2 distortedUV = SCREEN_UV + texture(distortionTexture, UV).r * 0.05;
	vec4 distortedScreen = texture(SCREEN_TEXTURE, distortedUV);
	vec4 invertMask = distortedScreen * invertFlashlight;
	float brightness = (0.299 * screenColor.r + 0.587 * screenColor.g + 0.114 * screenColor.b) - 0.4;
	vec4 grayScale = vec4(brightness, brightness, brightness, screenColor.a);
	vec4 maskedGrayscale = invertFlashlight * grayScale;
	
	vec4 finalColor = mask + maskedGrayscale;
	
	COLOR = finalColor;
}