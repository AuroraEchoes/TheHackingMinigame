shader_type canvas_item;
uniform float darkness: hint_range(0.0, 1.0, 0.1) = 0.2;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// https://forum.godotengine.org/t/godot-3-0-3-1-how-to-make-a-random-number-in-shader/24107
float rand(vec2 pos) {
	return fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 pixel_size = 1.5 * SCREEN_PIXEL_SIZE;
	float time_offset = floor(TIME * 10.0) / 100.0;
	vec2 uv_pixel = floor(UV / pixel_size);
	float noise = rand(uv_pixel + time_offset);
	vec3 rgb = vec3(noise);
	COLOR.rgb = rgb * (1.0 - darkness);
}