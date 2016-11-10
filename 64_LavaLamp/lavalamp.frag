// Author: 
// Title: 

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI acos(-1.)

float lavalamp( vec2 st, float phase) {
    float a = sin(0.5 * phase + st.x * PI * 23.0) + cos( phase + st.y * PI * 17.0);
    a = (a + 2.0) * 0.25;
    return smoothstep( a - 0.02, a + 0.02, st.y ) ;    
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;

    st += vec2(.0);
    
    vec3 color = vec3(1.);
    color = vec3(st.x,st.y,abs(sin(u_time)));
    
    float f = 1.0 - lavalamp( st, -u_time);
    float g = lavalamp( st, u_time);
    float h = lavalamp( vec2(st.y, st.x), u_time);
    float i = 1.0 - lavalamp( vec2(st.y, st.x), -u_time);
    
    vec4 c1 =  vec4(vec3(0.1), 1.0);
    vec4 c2 =  vec4(vec3(0.885,0.820,0.361), 1.0);
    vec4 c3 =  vec4(vec3(0.085,0.516,0.885), 1.0);
    vec4 c4 =  vec4(vec3(0.710,0.000,0.235), 1.0);
    
	gl_FragColor = vec4(0.0);
    gl_FragColor += f * c1 + g * c2 + h * c3 + i * c4;
}