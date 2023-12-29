shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 screenColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	float brightness = (0.299 * screenColor.r + 0.587 * screenColor.g + 0.114 * screenColor.b) - 0.4;
	
	vec4 grayScale = vec4(brightness, brightness, brightness, screenColor.a);
	
	COLOR = grayScale;
}
