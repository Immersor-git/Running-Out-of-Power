shader_type canvas_item;
uniform vec4 modulate : source_color = vec4(1.0);

void fragment()
{
	vec4 color = texture(TEXTURE,UV);

	float brightness = (color.r + color.g + color.b) / 3.0;
	vec4 grayScale = vec4(brightness, brightness, brightness, color.a);
	COLOR = grayScale;
}