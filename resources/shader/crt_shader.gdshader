// Crt shader heavily based on https://www.shadertoy.com/view/XdyGzR
shader_type canvas_item;

uniform float fisheye_amount = 0.954;
uniform float blur_strength = 0.44;
uniform float distortion_amount = 1.0;
uniform float scanline_intensity = 1.0;
uniform float scanline_width = 1.0;
uniform float noise_darkness: hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float pixel_ratio = 1.5;
uniform float shutdown_amount: hint_range(0.0, 1.0, 0.01) = 0.2;
uniform float noise_amount: hint_range(0.0, 1.0, 0.01) = 0.2;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// https://forum.godotengine.org/t/godot-3-0-3-1-how-to-make-a-random-number-in-shader/24107
float rand(vec2 pos) {
	return fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 centered_uv = UV - 0.5;
	float distortion = length(centered_uv * 0.5 * centered_uv * 0.5 * distortion_amount);
	vec2 distorted_uv = centered_uv * distortion + centered_uv * fisheye_amount; // 0.9535
	vec3 color = texture(SCREEN_TEXTURE, distorted_uv + 0.5, blur_strength).rgb;
	// Noise
	vec2 pixel_size = pixel_ratio * SCREEN_PIXEL_SIZE;
	float time_offset = floor(TIME * 10.0) / 100.0;
	vec2 uv_pixel = floor(distorted_uv / pixel_size);
	float noise = rand(uv_pixel + time_offset);
	color = mix(color, vec3(noise), noise_amount);
	// Scanlines
	float j = cos(distorted_uv.y / SCREEN_PIXEL_SIZE.y / scanline_width) * 0.1 * scanline_intensity;
	color -= color * j;
	// Border
	float border = max(0.0, 1.0 - 2.0 * max(abs(distorted_uv.x), abs(distorted_uv.y)));
    border = min(border * 200., 1.);
    color *= border;
	vec3 noise_rgb = vec3(noise) * (1.0 - noise_darkness);
	color = max(color, noise_rgb * shutdown_amount);
	color *= step(abs(distorted_uv.y * 2.0), 1.0 - shutdown_amount);
	COLOR = vec4(color.r, color.g, color.b, 1.0);
}