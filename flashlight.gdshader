shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment(){ 
	vec2 UV = SCREEN_UV + texture(TEXTURE, UV).a * 0.1;
	vec4 screenColor = texture(SCREEN_TEXTURE, TEXTURE_UV);
	if (TEXTURE.r == 0.0 && TEXTURE.b == 0.0 && TEXTURE.g == 0.0) {
		vec4 grayScale = vec4(brighness, brightness, brightness, pixelColor.a);
	}
	COLOR = screenColor;
}