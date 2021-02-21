shader_type canvas_item;

uniform vec3 color = vec3(0.1543, 0.4253, 0.9352);
uniform float seed = 789.1645;

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(12.9898, 78.233)) * 438.5453) * seed);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);

	// 4 corners of a rectangle surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

void fragment() {
	float random = sin(rand(UV) * TIME * 10.0);
	vec3 col = color;
	
	vec3 varying_color = (sin(vec3(TIME * 10.1156 * col)) + 1.0) / 2.0;
	if (random < 0.9999) {
		varying_color = vec3(0.0, 0.0, 0.0);
	}
	
	COLOR = vec4(varying_color, 1.0);
}