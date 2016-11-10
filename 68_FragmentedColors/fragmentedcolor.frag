// Author: 
// Title: 

#ifdef GL_ES
precision mediump float;
#endif

#define PI acos(-1.)

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random2D (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        				 43758.5453123);
}

float noise2D(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random2D(i);
    float b = random2D(i + vec2(1.0, 0.0));
    float c = random2D(i + vec2(0.0, 1.0));
    float d = random2D(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners porcentages
    return mix(a, b, u.x) + 
            (c - a)* u.y * (1.0 - u.x) + 
            (d - b) * u.x * u.y;
}

float blob( vec2 coord, float radius, float phase, float blur) {
    vec2 p = vec2(0.5) - coord;
    p.x = abs(p.x);
    
    //Polar coordinates
    float d = length(p) * 2.0;
    float steps = 50.0;
    float a =  steps * (atan(p.y, p.x) + PI) / (2.0 * PI);    
    
    float ai = floor(a);
    float af = fract(a);
    float minR = 0.1;
    
    float p1 = noise2D(vec2(ai, phase + u_time * 0.25))* 0.8 + minR;
    ai = ( ai < steps - 1.0 ) ? ai + 1.0 : 0.0; 
    float p2 = noise2D(vec2(ai, phase + u_time * 0.5)) * 0.8 + minR;    
    
    float f = mix(p1, p2, smoothstep(0.,1.,af));

    return 1.0 - smoothstep(f * radius - blur / 2.0, f * radius + blur / 2.0, d);
}



void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    
    float b1 = blob( st, 0.6, 0.0, 0.7);
    float b2 = blob( st, 0.6, 20.0, 0.7);
    float b3 = blob( st, 1.0, 100.0, 0.7);

	gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0) * b1 + vec4(0.0, 1.0, 0.0, 1.0) * b2 + vec4(0.0, 0.0, 1.0, 1.0) * b3;
}