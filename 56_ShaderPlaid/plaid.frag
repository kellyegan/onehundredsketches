#define PI acos(-1.)

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
  vec2 uv = PI * fragCoord.xy / iResolution.xy;
    
  float r = 0.8 * (step( 0.1, sin( uv.x * 36.0 + iGlobalTime * 0.8 ) ) + step( 0.1, sin( uv.x * 11.0 )));
  float g = 0.5 * (step( 0.1, cos( uv.x * 24.0 - iGlobalTime * 0.5 ) ) + step( 0.1, sin( uv.x * 7.0 )));
  float b = 0.7 * (step( 0.1, sin( uv.x * 18.0 ) ) + step( 0.1, cos( uv.x * 7.0 )));
    
  r += 0.2 * (step( 0.1, sin( uv.y * 9.0 ) ) + step( 0.1, sin( uv.y * 11.0 )));
  g += 0.3 * (step( 0.1, cos( uv.y * 8.0 - iGlobalTime * 0.7 ) ) + step( 0.1, sin( uv.y * 12.0 )));
  b += 0.3 * (step( 0.1, sin( uv.y * 12.0 + iGlobalTime * 1.2  ) ) + step( 0.1, cos( uv.y * 7.0 )));
    
  fragColor = vec4(r * 0.5, g * 0.5, b * 0.5, 1.0);
}
