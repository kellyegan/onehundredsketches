// Designed in ShaderToy
// https://www.shadertoy.com/view/lty3RK

float star( vec2 coord, vec2 center, float radius, float points, float blur, float rot) {
    vec2 p = center - coord;
    
    //Polar coordinates
    float d = length(p) * 2.0;
    float a = atan(p.y, p.x);
    
    float f = (cos(a * points + rot) + 1.0) / 4.0  + 0.5;
    return 1.0 - smoothstep(f * radius - blur / 2.0, f * radius + blur / 2.0, d);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float size = max( iResolution.x, iResolution.y ) * 0.8;
    	
    float s1 = star( fragCoord.xy, iResolution.xy / 2.0, size, 3.0, size * 2.0, iGlobalTime * 0.7 );
    float s2 = star( fragCoord.xy, iResolution.xy / 2.0, size, 9.0, size * 2.0, -iGlobalTime * 0.4 );
    float s3 = star( fragCoord.xy, iResolution.xy / 2.0, size, 6.0, size * 2.0, iGlobalTime * 0.5 );
    
    
    vec4 c1 = vec4( 0.0, 0.0, 1.0, 1.0);
    vec4 c2 = vec4( 0.0, 1.0, 1.0, 1.0);
    vec4 c3 = vec4( 1.0, 1.0, 0.0, 1.0);
    
    vec4 color = c1 * fract(s1 * 10.0) + c2 * fract(s2 * 60.0) + c3 * fract(s3 * 30.0);

    fragColor = color;
}
