//Designed on Shadertoy 10/2016


#define PI acos(-1.)

float star( vec2 coord, vec2 center, float radius, float points, float blur, float rot) {
    vec2 p = center - coord;
    
    //Polar coordinates
    float d = length(p) * 2.0;
    float a = atan(p.y, p.x);
    
    float f = (cos(a * points + rot) + 1.0) / 8.0  + 0.75;

    return 1.0 - smoothstep(f * radius - blur / 2.0, f * radius + blur / 2.0, d);
}

float circle( vec2 coord, vec2 center, float radius, float blur ) {
    vec2 dist = coord - center;
	return 1.0 - smoothstep(pow(radius - blur, 2.0), pow(radius + blur, 2.0), dot(dist,dist));
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / min(iResolution.x, iResolution.y);
    
    uv *= 9.0;
    float oddR = step(1.0,mod(uv.y,2.0));
    float oddC = step(1.0,mod(uv.x,2.0));
    
    uv = fract(uv);
    
    float t = iGlobalTime * 10.0;
    
    float index = 0.0;
    
    if( oddR == 0.0) {
        t = -t + PI;
    } else {
        index += 1.0;
    }
    
    if( oddC == 0.0) {
        t = -t - PI;
    } else {
        index += 2.0;
    }
    
    float st = star( uv, vec2(0.5), 1.0, 8.0, 0.1, t);
    vec4 c;
    
    if( index == 0.0 ) {
    	c = vec4(255.0, 53.0, 83.0, 255.0) / 255.0;
    } else if(index == 1.0) {
        c = vec4(8.0, 180.0, 150.0, 255.0) / 255.0;
    } else if(index == 2.0) {
        c = vec4(255.0, 170.0, 20.0, 255.0) / 255.0;
    } else {
        c = vec4(102.0, 95.0, 87.0, 255.0) / 255.0;
    }
    
	fragColor = mix( c, vec4(194.0, 206.0, 217.0, 255.0) / 255.0, 1.0 - st);
}
