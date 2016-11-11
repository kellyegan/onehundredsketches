#define TAU 2. * acos(-1.)

float annulus( vec2 p, float r1, float r2 ) {
    return max(length(p) - r1, r2 - length(p));
}

float rect( vec2 pos, vec2 dim ) {
    return length(max(abs(pos)-dim,0.0));
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st = fragCoord.xy / iResolution.xy;
    
    
    if(iResolution.y>iResolution.x){
        //Vertical
        st.y*=iResolution.y/iResolution.x;
        st.y-=(iResolution.y*.5-iResolution.x*.5)/iResolution.x;
    }else{
        //Horizontal
        st.x*=iResolution.x/iResolution.y;
        st.x-=(iResolution.x*.5-iResolution.y*.5)/iResolution.y;
    }  
    
    float cells = 20.;
    
    st = floor(st*cells)/cells;
    
    float w = iGlobalTime * sin(st.y * TAU * 4.);
    float v = (sin(2. * iGlobalTime + st.x * TAU * 8. + w) + 1.0) / 2.0;
    

    float f = 0.;
    if( mod(st.x,2.0) < 1.0 ) {
        f = mod(st.y,2.0) < 1.0 ? 0. : 1. ;
    } else {
        f = mod(st.y,2.0) < 1.0 ? 1. : 0. ;
    }
    
    st = fract(st);
    
    vec3 c = vec3( step(0.5, v ));
    
    fragColor = vec4(c, 1.0);
}


