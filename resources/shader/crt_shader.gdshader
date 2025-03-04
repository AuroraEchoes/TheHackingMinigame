// Crt shader heavily based on https://www.shadertoy.com/view/XdyGzR
shader_type canvas_item;

uniform float fisheye_amount = 0.954;
uniform float blur_strength = 0.44;
uniform float distortion_amount = 1.0;
uniform float scanline_intensity = 1.0;
uniform float scanline_width = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 centered_uv = UV - 0.5;
	float distortion = length(centered_uv * 0.5 * centered_uv * 0.5 * distortion_amount);
	vec2 distorted_uv = centered_uv * distortion + centered_uv * fisheye_amount; // 0.9535
	vec3 color = texture(SCREEN_TEXTURE, distorted_uv + 0.5, blur_strength).rgb;
	// Scanlines
	float j = cos(distorted_uv.y / SCREEN_PIXEL_SIZE.y / scanline_width) * 0.1 * scanline_intensity;
	color -= color * j;
	// Border
	float border = max(0.0, 1.0 - 2.0 * max(abs(distorted_uv.x), abs(distorted_uv.y)));
    border = min(border * 200., 1.);
    color *= border;
	COLOR = vec4(color.r, color.g, color.b, 1.0);
}