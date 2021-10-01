shader_type canvas_item;

uniform int pixel_amount;
uniform float cloudscale:hint_range(0.0, 5.0);
uniform float speed:hint_range(-0.5, 0.5);

uniform vec4 color1:hint_color;
uniform float threshold2:hint_range(0.0, 1.0);
uniform vec4 color2:hint_color;
uniform float threshold3:hint_range(0.0, 1.0);
uniform vec4 color3:hint_color;
uniform float threshold4:hint_range(0.0, 1.0);
uniform vec4 color4:hint_color;
uniform float threshold5:hint_range(0.0, 1.0);
uniform vec4 color5:hint_color;
uniform float threshold6:hint_range(0.0, 1.0);
uniform vec4 color6:hint_color;

const mat2 m = mat2( vec2(1.6,  1.2), vec2(-1.2,  1.6) );

vec2 hash( vec2 p ) {
	p = vec2(dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)));
	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

float noise( in vec2 p ) {
    const float K1 = 0.366025404; // (sqrt(3)-1)/2;
    const float K2 = 0.211324865; // (3-sqrt(3))/6;
	vec2 i = floor(p + (p.x+p.y)*K1);	
    vec2 a = p - i + (i.x+i.y)*K2;
    vec2 o = (a.x>a.y) ? vec2(1.0,0.0) : vec2(0.0,1.0); //vec2 of = 0.5 + 0.5*vec2(sign(a.x-a.y), sign(a.y-a.x));
    vec2 b = a - o + K2;
	vec2 c = a - 1.0 + 2.0*K2;
    vec3 h = max(0.5-vec3(dot(a,a), dot(b,b), dot(c,c) ), 0.0 );
	vec3 n = h*h*h*h*vec3( dot(a,hash(i+0.0)), dot(b,hash(i+o)), dot(c,hash(i+1.0)));
    return dot(n, vec3(70.0));	
}

float fbm(vec2 n) {
	float total = 0.0, amplitude = 0.1;
	for (int i = 0; i < 7; i++) {
		total += noise(n) * amplitude;
		n = m * n;
		amplitude *= 0.4;
	}
	return total;
}

vec4 apply_threshold(vec4 col, vec2 uv) {
	if (col.a > threshold2) {
		if (col.a > threshold3) {
			if (col.a > threshold4) {
				if (col.a > threshold5) {
					if (col.a > threshold6) {
						col = vec4(color6.rgb, 1.0);
					}
					else {
						col = vec4(color5.rgb, 1.0);
					}
				}
				else {
					col = vec4(color4.rgb, 1.0);
				}
			}
			else {
				col = vec4(color3.rgb, 1.0);
			}
		}
		else {
			col = vec4(color2.rgb, 1.0);
		}
	}
	else {
		col = vec4(color1.rgb, 1.0);
	}
	return col;
}

void fragment() {
	vec2 ps = TEXTURE_PIXEL_SIZE;
    vec2 ratio = vec2(1, ps.x / ps.y);
	vec2 pixels = vec2(float(pixel_amount)) * ratio;
	vec2 grid_uv = round(UV * pixels) * ratio / pixels;
    float time = TIME * speed;
    float q = fbm(grid_uv * cloudscale * 0.5);
    
    //ridged noise shape
	float r = 0.0;
	vec2 uv = grid_uv * cloudscale;
    uv.y -= q - time;
    float weight = 0.8;
    for (int i=0; i<8; i++){
		r += abs(weight*noise( uv ));
        uv = m*uv;
		weight *= 0.7;
    }
    
    //noise shape
	float f = 0.0;
	uv = grid_uv;
	uv *= cloudscale;
    uv.y -= q - time;
    weight = 0.7;
    for (int i=0; i<8; i++){
		f += weight*noise( uv );
        uv = m*uv;
		weight *= 0.6;
    }
    
    f *= r + f;
	
	vec4 col = 0.2 * vec4(f) + 1.0 - UV.y;
	col = apply_threshold(col, UV);
	
	COLOR = col;
}