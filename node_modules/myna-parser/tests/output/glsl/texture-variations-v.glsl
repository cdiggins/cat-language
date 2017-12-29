// pushing activation record 0
// pushing activation record 0:sum1
float sum(vec3 v)
{
// pushing activation record 0:sum1:2
    return v.x + v.y + v.z;

}
// popping activation record 0:sum1:2
// local variables: 
// references:
// v at line 19, column 29
// v at line 19, column 33
// v at line 19, column 37
// popping activation record 0:sum1
// local variables: 
// variable v, unique name 0:sum1:v, index 179, declared at line 19, column 16
// references:
// pushing activation record 0:textureNoTile3
vec3 textureNoTile(in vec2 x, float v)
{
// pushing activation record 0:textureNoTile3:4
    float k = texture(iChannel1, 0.005 * x).x;
    vec2 duvdx = dFdx(x);
    vec2 duvdy = dFdx(x);
    float l = k * 8.0;
    float i = floor(l);
    float f = fract(l);
    vec2 offa = sin(vec2(3.0, 7.0) * (i + 0.0));
    vec2 offb = sin(vec2(3.0, 7.0) * (i + 1.0));
    vec3 cola = textureGrad(iChannel0, x + v * offa, duvdx, duvdy).xxx;
    vec3 colb = textureGrad(iChannel0, x + v * offb, duvdx, duvdy).xxx;
    return mix(cola, colb, smoothstep(0.2, 0.8, f - 0.1 * sum(cola - colb)));

}
// popping activation record 0:textureNoTile3:4
// local variables: 
// variable k, unique name 0:textureNoTile3:4:k, index 183, declared at line 23, column 10
// variable duvdx, unique name 0:textureNoTile3:4:duvdx, index 184, declared at line 25, column 9
// variable duvdy, unique name 0:textureNoTile3:4:duvdy, index 185, declared at line 26, column 9
// variable l, unique name 0:textureNoTile3:4:l, index 186, declared at line 28, column 10
// variable i, unique name 0:textureNoTile3:4:i, index 187, declared at line 29, column 10
// variable f, unique name 0:textureNoTile3:4:f, index 188, declared at line 30, column 10
// variable offa, unique name 0:textureNoTile3:4:offa, index 189, declared at line 32, column 9
// variable offb, unique name 0:textureNoTile3:4:offb, index 190, declared at line 33, column 9
// variable cola, unique name 0:textureNoTile3:4:cola, index 191, declared at line 35, column 9
// variable colb, unique name 0:textureNoTile3:4:colb, index 192, declared at line 36, column 9
// references:
// texture at line 23, column 14
// iChannel1 at line 23, column 23
// x at line 23, column 40
// dFdx at line 25, column 17
// x at line 25, column 23
// dFdx at line 26, column 17
// x at line 26, column 23
// k at line 28, column 14
// floor at line 29, column 14
// l at line 29, column 21
// fract at line 30, column 14
// l at line 30, column 21
// sin at line 32, column 16
// vec2 at line 32, column 20
// i at line 32, column 35
// sin at line 33, column 16
// vec2 at line 33, column 20
// i at line 33, column 35
// textureGrad at line 35, column 16
// iChannel0 at line 35, column 29
// x at line 35, column 40
// v at line 35, column 44
// offa at line 35, column 46
// duvdx at line 35, column 52
// duvdy at line 35, column 59
// textureGrad at line 36, column 16
// iChannel0 at line 36, column 29
// x at line 36, column 40
// v at line 36, column 44
// offb at line 36, column 46
// duvdx at line 36, column 52
// duvdy at line 36, column 59
// mix at line 38, column 11
// cola at line 38, column 16
// colb at line 38, column 22
// smoothstep at line 38, column 28
// f at line 38, column 47
// sum at line 38, column 53
// cola at line 38, column 57
// colb at line 38, column 62
// popping activation record 0:textureNoTile3
// local variables: 
// variable x, unique name 0:textureNoTile3:x, index 181, declared at line 21, column 28
// variable v, unique name 0:textureNoTile3:v, index 182, declared at line 21, column 37
// references:
// pushing activation record 0:mainImage5
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage5:6
    vec2 uv = fragCoord.xy / iResolution.xx;
    float f = smoothstep(0.4, 0.6, sin(iGlobalTime));
    float s = smoothstep(0.4, 0.6, sin(iGlobalTime * 0.5));
    vec3 col = textureNoTile((4.0 + 6.0 * s) * uv, f);
    fragColor = vec4(col, 1.0);

}
// popping activation record 0:mainImage5:6
// local variables: 
// variable uv, unique name 0:mainImage5:6:uv, index 196, declared at line 43, column 6
// variable f, unique name 0:mainImage5:6:f, index 197, declared at line 45, column 7
// variable s, unique name 0:mainImage5:6:s, index 198, declared at line 46, column 10
// variable col, unique name 0:mainImage5:6:col, index 199, declared at line 48, column 6
// references:
// fragCoord at line 43, column 11
// iResolution at line 43, column 26
// smoothstep at line 45, column 11
// sin at line 45, column 33
// iGlobalTime at line 45, column 37
// smoothstep at line 46, column 14
// sin at line 46, column 36
// iGlobalTime at line 46, column 40
// textureNoTile at line 48, column 12
// s at line 48, column 38
// uv at line 48, column 41
// f at line 48, column 45
// fragColor at line 50, column 1
// vec4 at line 50, column 13
// col at line 50, column 19
// popping activation record 0:mainImage5
// local variables: 
// variable fragColor, unique name 0:mainImage5:fragColor, index 194, declared at line 41, column 25
// variable fragCoord, unique name 0:mainImage5:fragCoord, index 195, declared at line 41, column 44
// references:
// undefined variables 
