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

    
    fragColor  = vec4((floor(st*10.0)/10.),0.5+0.5*sin(iGlobalTime),1.0);
    
    float cells = 10.0;
    
    st = floor(st*cells)/cells;
    
    float w = 3. * ( sin(st.y * TAU * 2.) ) + st.y * 30.0;
    float v = (cos(st.x * TAU * 2. + w) + 1.0) / 2.0;
    
	st = st * cells;
    
    float f = 0.;
    
    if( mod(st.x,2.0) < 1.0 ) {
        f = mod(st.y,2.0) < 1.0 ? 0.2 : 1. ;
    } else {
        f = mod(st.y,2.0) < 1.0 ? 1. : 0.2 ;       
    }
    
    vec3 c = vec3( step(0.5, v ), f, 1.-f*v );
    vec3 t = vec3( sin(iGlobalTime* 0.11), sin(iGlobalTime * 0.07), sin(iGlobalTime * 0.17));
       

    //st = fract(st);
    
    if( f == 1.0 ) {
        c = 1. - c;
    }
        
    
    fragColor = vec4(c + t, 1.0);
}


