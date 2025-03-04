shader_type canvas_item;
uniform float a = 320.0;
uniform float b = 1440.0;
uniform float progress = 1000.0;

void fragment() {
	COLOR.rgb = vec3(1. - smoothstep(320., 1440., 1. / SCREEN_PIXEL_SIZE.y) + 1.);
}