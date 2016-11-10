// Author: 
// Title: 

#ifdef GL_ES
precision mediump float;
#endif

#define TWOPI 2.0 * acos(-1.)

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random(float x) {
    return fract(sin(x) * 100000.0);
}

float random2D (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        				 43758.5453123);
}

float blob( vec2 coord, vec2 center, float radius, float points, float blur, float rot) {
    vec2 p = center - coord;
    p = abs(p);
    //Polar coordinates
    float d = length(p) * 2.0;
    float a = atan(p.y, p.x) + u_time * 0.05;
    
    //float f = (cos(a * points + rot) + 1.0) / 8.0  + 0.75;
    float ai = floor(a * 7.0);
    float af = fract(a * 7.0);
    float minR = 0.5;
    float f = mix(random(ai) * 0.5 + minR, random(ai + 1.0) * 0.5 + minR, smoothstep(0.,1.,af));
    //float y = mix(rand(i), rand(i + 1.0), f);

    return 1.0 - smoothstep(f * radius - blur / 2.0, f * radius + blur / 2.0, d);
}



void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    
    vec2 ipos = floor(st);
    vec2 fpos = fract(st);

    st += vec2(.0);
    vec3 color = vec3(1.);
    color = vec3(st.x,st.y,abs(sin(u_time)));
    
    float b = blob( st, vec2(0.5), 0.8, 6.0, .5, 0.0);
    vec2 delta = vec2(0.5, 0.5) - st;
    float dist = dot(delta, delta);
    
    //gl_FragColor = vec4(1.0);
	gl_FragColor = vec4(dist * 15.0, dist * 7.5, 0.0, 0.0) * b;
    //gl_FragColor = vec4(random(ipos));
}