// Made in ShaderToy
// https://www.shadertoy.com/view/ltVGzG

float band( float loc, float wid, float blur,  float val ) {
    float start = loc - wid / 2.0;
    float end = loc + wid / 2.0;
    
    return smoothstep( start - blur, start, val )
        - smoothstep( end, end + blur, val );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    
    float p1 = sin(iGlobalTime / 7.0) / 2.0 + 0.5;
    float p2 = cos(iGlobalTime / 13.0) / 2.0 + 0.5;
    float p3 = sin(iGlobalTime / 17.0) / 2.0 + 0.5;
    float p4 = sin(3.145 * 0.33 + iGlobalTime / 23.0) / 2.0 + 0.5;
    float p5 = cos(iGlobalTime / 29.0) / 2.0 + 0.5;
    float p6 = clamp(p1 - p3, 0.0, 1.0);
    float p7 = clamp(p1 - p4, 0.0, 1.0);
    float p8 = clamp(p2 - p3, 0.0, 1.0);
    float p9 = clamp(p2 - p5, 0.0, 1.0);
    
    vec4 c1 = vec4(1.0, 0.2, 0.0, 1.0) * band( p1 * 0.85 + 0.15, p4 * 0.1, p7 * 0.1 + 0.06, uv.y);
    vec4 c2 = vec4(0.2, 1.0, 0.5, 1.0) * band( p2 * 0.85 + 0.15, p5 * 0.2, p8 * 0.2 + 0.06, uv.y);
    vec4 c3 = vec4(0.0, 0.1, 0.8, 1.0) * band( p3 * 0.85 + 0.15, p7 * 0.3, p9 * 0.3 + 0.06, uv.y);
    vec4 c4 = vec4(0.9, 0.9, 0.1, 1.0) * band( p4 * 0.85 + 0.15, p6 * 0.3, p5 * 0.3 + 0.06, uv.y);
    vec4 c5 = vec4(0.0, 0.9, 0.9, 1.0) * band( p8 * 0.85 + 0.15, p5 * 0.3, p2 * 0.3 + 0.06, uv.y);
    vec4 c6 = vec4(0.8, 0.0, 0.8, 1.0) * band( p7 * 0.85 + 0.15, p1 * 0.3, p3 * 0.3 + 0.06, uv.y);
    
    
    fragColor = (c1 + c2 + c3 + c4 + c5 + c6) * band(0.5, 0.8, 0.15, uv.x) * band(0.5, 0.8, 0.15, uv.y);

}




