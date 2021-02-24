shader_type canvas_item;

// Gonkee's fog shader for Godot 3 - full tutorial https://youtu.be/QEaTsz_0o44
// If you use this shader, I would prefer it if you gave credit to me and my channel

uniform vec3 color = vec3(0.1543, 0.4253, 0.9354);
uniform int OCTAVES = 4;
uniform float seed = 565.2315;

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(12.9898, 78.233)) * 437.5453) * seed);
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

float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;

	for(int i = 0; i < OCTAVES; i++){
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}

void fragment() {
	vec2 coord = vec2(UV.x * 4.5, UV.y * 8.0);

	vec2 motion = vec2(fbm(coord + vec2(TIME * -0.5, TIME * 0.5)));

	float final = fbm(coord + motion);
	
	vec3 varying_color = sin(vec3(TIME * color));

	COLOR = vec4(varying_color, final * 0.5);
}