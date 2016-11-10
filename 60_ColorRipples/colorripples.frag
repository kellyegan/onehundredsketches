// Designed in ShaderToy
// https://www.shadertoy.com/view/ltG3RV

#define PI acos(-1.)


float ripple( vec2 coord, vec2 position, float phase ) {
    float dist = distance(coord, position) / length(iResolution.xy);
    float f = sin( (phase +  PI / (dist * 2.0)) * 20.0 ) / (dist);
	return f;
}



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    
    
    vec2 center = iResolution.xy / 2.0;
    vec2 ll = vec2(0.0);
    
    
    float r1 = ripple(fragCoord.xy, vec2(iResolution.x + 100.0, iResolution.y + 100.), iGlobalTime * 0.1 + PI  * 0.5);
    float r2 = ripple(fragCoord.xy, vec2(-100.0, -100.0), iGlobalTime * 0.1 + PI * 0.333);
    float r3 = ripple(fragCoord.xy, vec2(iResolution.x + 100., -100.), iGlobalTime * 0.1 + PI * 0.7);
    float r4 = ripple(fragCoord.xy, vec2(-200, iResolution.y + 100.), iGlobalTime * 0.02);
    float r5 = ripple(fragCoord.xy, vec2(iResolution.x + 100., iResolution.y + 100.), iGlobalTime * 0.2);

    
    vec4 c1 = vec4(0.9, 0.2, 0.8, 1.0);
    vec4 c2 = vec4(0.2, 0.2, 0.9, 1.0);
    vec4 c3 = vec4(0.3, 0.9, 0.5, 1.0);
    vec4 c4 = vec4(0.7, 0.5, 0.3, 1.0);
    
	fragColor = abs(c1 * r1 + c2 * r2 + c3 * r3 + c4 * r4);
}
