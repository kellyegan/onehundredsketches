// Designed in ShaderToy 10/2016
// https://www.shadertoy.com/view/4lVGzK


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    
    float time = iGlobalTime * 0.01;
    
    vec4 color1 = vec4(0.79, .37, 0.21, 1.0);
    vec4 color2 = vec4(0.88, 0.87, 0.78, 1.0);
    vec4 color3 = vec4(0.54, 0.62, 0.77, 1.0);
    
    float power1 = max(0.5 - time * 0.4, 0.0);
    float power2 = max(1.1- time * 0.1, 0.0);

    vec4 color;
    color = mix( color1, color2, 2.0 * pow( abs(uv.y - 0.333), power1) );
    color = mix( color,  color3, time * 0.1 + 2.0 * pow(abs( uv.y - 0.333), power2) );
    fragColor = color - (time * 0.4);
}    
    
