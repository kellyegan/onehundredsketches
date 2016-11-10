#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Reference to
// http://thndl.com/square-shaped-shaders.html

float polygon( in vec2 st, in float sides, float radius, float blur ) {
    st = st *2.-1.;
    float a = atan(st.x,st.y)+PI;
  	float r = TWO_PI/float(sides);
    float d = cos(floor(.5+a/r)*r-a)*length(st);
    
    return 1.0-smoothstep(radius - blur,radius + blur,d);
}

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

void main(){
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    st.x *= u_resolution.x / u_resolution.y;
    
    st = st * 8.0;
	
    float oddC = step(1.0,mod(st.x,2.0));
    float oddR = step(1.0,mod(st.y,2.0));    

    st = fract(st);

    if( oddR == 1.0) {
        st.y = 1.0 - st.y;        
    }
    if( oddC == 1.0 ){
        st.x = 1.0 - st.x;
    }
    
    float n1 = ceil(sin(u_time * 0.5) * 5.0) + 5.0;
    
    float s1 = polygon(st + vec2(0.5, 0.5), n1, 1.5, 0.01) - polygon( st + vec2(0.5, 0.5), n1, 1.3, 0.01);
    
    st += vec2(0.5, 0.5);    
    float s2 = polygon( st, n1, 1.0, 0.01 ) - polygon( st, n1, 0.8, 0.01 );
    float s3 = polygon( st, n1, 0.6, 0.01 ) - polygon( st, n1, 0.4, 0.01 );
    
    st -= vec2(1., 1.);
    float s4 = polygon( st, n1, 1.0, 0.01 ) - polygon( st, n1, 0.8, 0.01 );  
    float s5 = polygon(st, n1, 0.6, 0.01) - polygon(st, n1, 0.4, 0.01);
  
    vec3 c1 = vec3(0.885,0.677,0.245);
    vec3 c2 = vec3(0.223,0.076,0.520);
    vec3 c3 = vec3(0.272,0.705,0.486);
    vec3 c4 = vec3(0.680,0.194,0.155);
    vec3 c5 = vec3(0.321,0.850,0.809);
    
    
    gl_FragColor = s1 * vec4(c1,1.0) + s2 * vec4(c2,1.0) + s3 * vec4(c3,1.0) + + s4 * vec4(c4, 1.0) + s5 * vec4(c5, 1.0); 
}