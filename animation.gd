extends Sprite2D

@export var SPEED = 15

func _process(delta):
	#var light_pos = ((material as ShaderMaterial).get_shader_parameter("lightPos"))
	#light_pos = position;
	var fast_noise = ((material as ShaderMaterial).get_shader_parameter("distortionTexture") as NoiseTexture2D).noise as FastNoiseLite
	fast_noise.offset.x += SPEED * delta
	pass
