shader_type canvas_item;

uniform vec4 outline_color : hint_color = vec4(1);
uniform float outline_thickness : hint_range(0, 10) = 1.0;


float detectBorderN8(sampler2D tex, vec2 uv, vec2 size) {
	float outline = texture(tex, uv + vec2(-size.x, 0)).a;
	outline += texture(tex, uv + vec2(0, size.y)).a;
	outline += texture(tex, uv + vec2(size.x, 0)).a;
	outline += texture(tex, uv + vec2(0, -size.y)).a;
	outline += texture(tex, uv + vec2(-size.x, size.y)).a;
	outline += texture(tex, uv + vec2(size.x, size.y)).a;
	outline += texture(tex, uv + vec2(-size.x, -size.y)).a;
	outline += texture(tex, uv + vec2(size.x, -size.y)).a;
	return min(outline, 1.0);
}


void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec2 size = TEXTURE_PIXEL_SIZE * outline_thickness;
	float outline = detectBorderN8(TEXTURE, UV, size);
	COLOR = mix(color, outline_color, outline - color.a);
}
