shader_type canvas_item;

uniform float fragmentation : hint_range(0,10) = 3.0;
uniform float thickness : hint_range(0,0.5) = 0.02;
uniform float point_position : hint_range(5,50) = 6.2831;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

float voronoiDistance(in vec2 p, in vec2 f)
{
    vec2 mb;
    vec2 mr;

    float res = 8.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 b = vec2(float(i), float(j));
        vec2 r = vec2(b) + random2((p+b)*point_position*fragmentation)-f;
        float d = dot(r,r);

        if( d < res )
        {
            res = d;
            mr = r;
            mb = b;
        }
    }

    res = 8.0;
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        vec2 b = mb + vec2(float(i), float(j));
        vec2  r = vec2(b) + random2((p+b)*point_position*fragmentation) - f;
        float d = dot(0.5*(mr+r), normalize(r-mr));

        res = min( res, d );
    }

    return res;
}

float getBorder(in vec2 p, in vec2 f)
{
    float d = voronoiDistance(p, f);

    return 1.0 - smoothstep(0.0,thickness * fragmentation,d);
}

void fragment() {
    vec3 color = vec3(0.0);

	vec2 st = UV * fragmentation;

    // Tile the space
    vec2 i_st = floor(st);
    vec2 f_st = fract(st);

    // Draw the min distance (distance field)
    color += 1.0 - getBorder(i_st, f_st);

	color *= texture(TEXTURE, UV).xyz;

    COLOR = vec4(color,texture(TEXTURE, UV).a);
}