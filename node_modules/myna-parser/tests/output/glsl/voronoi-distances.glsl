// pushing activation record 0
#define ANIMATE 

// pushing activation record 0:hash21
vec2 hash2(vec2 p)
{
// pushing activation record 0:hash21:2
    return textureLod(iChannel0, (p + 0.5) / 256.0, 0.0).xy;

}
// popping activation record 0:hash21:2
// local variables: 
// references:
// textureLod at line 18, column 8
// iChannel0 at line 18, column 20
// p at line 18, column 32
// popping activation record 0:hash21
// local variables: 
// variable p, unique name 0:hash21:p, index 180, declared at line 15, column 17
// references:
// pushing activation record 0:voronoi3
vec3 voronoi(in vec2 x)
{
// pushing activation record 0:voronoi3:4
    vec2 n = floor(x);
    vec2 f = fract(x);
    vec2 mg, mr;
    float md = 8.0;
    // pushing activation record 0:voronoi3:4:for5
    for (int j = -1; j <= 1; j++) // pushing activation record 0:voronoi3:4:for5:for6
    for (int i = -1; i <= 1; i++) {
    // pushing activation record 0:voronoi3:4:for5:for6:7
        vec2 g = vec2(float(i), float(j));
        vec2 o = hash2(n + g);
        #ifdef ANIMATE
        
o = 0.5 + 0.5 * sin(iGlobalTime + 6.2831 * o);
        #endif	
        
vec2 r = g + o - f;
        float d = dot(r, r);
        if (d < md) {
        // pushing activation record 0:voronoi3:4:for5:for6:7:8
            md = d;
            mr = r;
            mg = g;

        }
        // popping activation record 0:voronoi3:4:for5:for6:7:8
        // local variables: 
        // references:
        // md at line 48, column 12
        // d at line 48, column 17
        // mr at line 49, column 12
        // r at line 49, column 17
        // mg at line 50, column 12
        // g at line 50, column 17

    }
    // popping activation record 0:voronoi3:4:for5:for6:7
    // local variables: 
    // variable g, unique name 0:voronoi3:4:for5:for6:7:g, index 190, declared at line 38, column 13
    // variable o, unique name 0:voronoi3:4:for5:for6:7:o, index 191, declared at line 39, column 7
    // variable r, unique name 0:voronoi3:4:for5:for6:7:r, index 192, declared at line 43, column 13
    // variable d, unique name 0:voronoi3:4:for5:for6:7:d, index 193, declared at line 44, column 14
    // references:
    // vec2 at line 38, column 17
    // float at line 38, column 22
    // i at line 38, column 28
    // float at line 38, column 31
    // j at line 38, column 37
    // hash2 at line 39, column 11
    // n at line 39, column 18
    // g at line 39, column 22
    // o at line 41, column 8
    // sin at line 41, column 22
    // iGlobalTime at line 41, column 27
    // o at line 41, column 48
    // g at line 43, column 17
    // o at line 43, column 21
    // f at line 43, column 25
    // dot at line 44, column 18
    // r at line 44, column 22
    // r at line 44, column 24
    // d at line 46, column 12
    // md at line 46, column 14
    // popping activation record 0:voronoi3:4:for5:for6
    // local variables: 
    // variable i, unique name 0:voronoi3:4:for5:for6:i, index 189, declared at line 36, column 13
    // references:
    // i at line 36, column 19
    // i at line 36, column 25
    // popping activation record 0:voronoi3:4:for5
    // local variables: 
    // variable j, unique name 0:voronoi3:4:for5:j, index 188, declared at line 35, column 13
    // references:
    // j at line 35, column 19
    // j at line 35, column 25
    md = 8.0;
    // pushing activation record 0:voronoi3:4:for9
    for (int j = -2; j <= 2; j++) // pushing activation record 0:voronoi3:4:for9:for10
    for (int i = -2; i <= 2; i++) {
    // pushing activation record 0:voronoi3:4:for9:for10:11
        vec2 g = mg + vec2(float(i), float(j));
        vec2 o = hash2(n + g);
        #ifdef ANIMATE
        
o = 0.5 + 0.5 * sin(iGlobalTime + 6.2831 * o);
        #endif	
        
vec2 r = g + o - f;
        if (dot(mr - r, mr - r) > 0.00001) md = min(md, dot(0.5 * (mr + r), normalize(r - mr)));

    }
    // popping activation record 0:voronoi3:4:for9:for10:11
    // local variables: 
    // variable g, unique name 0:voronoi3:4:for9:for10:11:g, index 196, declared at line 61, column 13
    // variable o, unique name 0:voronoi3:4:for9:for10:11:o, index 197, declared at line 62, column 7
    // variable r, unique name 0:voronoi3:4:for9:for10:11:r, index 198, declared at line 66, column 13
    // references:
    // mg at line 61, column 17
    // vec2 at line 61, column 22
    // float at line 61, column 27
    // i at line 61, column 33
    // float at line 61, column 36
    // j at line 61, column 42
    // hash2 at line 62, column 11
    // n at line 62, column 18
    // g at line 62, column 22
    // o at line 64, column 8
    // sin at line 64, column 22
    // iGlobalTime at line 64, column 27
    // o at line 64, column 48
    // g at line 66, column 17
    // o at line 66, column 21
    // f at line 66, column 25
    // dot at line 68, column 12
    // mr at line 68, column 16
    // r at line 68, column 19
    // mr at line 68, column 21
    // r at line 68, column 24
    // md at line 69, column 8
    // min at line 69, column 13
    // md at line 69, column 18
    // dot at line 69, column 22
    // mr at line 69, column 32
    // r at line 69, column 35
    // normalize at line 69, column 39
    // r at line 69, column 49
    // mr at line 69, column 51
    // popping activation record 0:voronoi3:4:for9:for10
    // local variables: 
    // variable i, unique name 0:voronoi3:4:for9:for10:i, index 195, declared at line 59, column 13
    // references:
    // i at line 59, column 19
    // i at line 59, column 25
    // popping activation record 0:voronoi3:4:for9
    // local variables: 
    // variable j, unique name 0:voronoi3:4:for9:j, index 194, declared at line 58, column 13
    // references:
    // j at line 58, column 19
    // j at line 58, column 25
    return vec3(md, mr);

}
// popping activation record 0:voronoi3:4
// local variables: 
// variable n, unique name 0:voronoi3:4:n, index 183, declared at line 26, column 9
// variable f, unique name 0:voronoi3:4:f, index 184, declared at line 27, column 9
// variable mg, unique name 0:voronoi3:4:mg, index 185, declared at line 32, column 6
// variable mr, unique name 0:voronoi3:4:mr, index 186, declared at line 32, column 10
// variable md, unique name 0:voronoi3:4:md, index 187, declared at line 34, column 10
// references:
// floor at line 26, column 13
// x at line 26, column 19
// fract at line 27, column 13
// x at line 27, column 19
// md at line 57, column 4
// vec3 at line 72, column 11
// md at line 72, column 17
// mr at line 72, column 21
// popping activation record 0:voronoi3
// local variables: 
// variable x, unique name 0:voronoi3:x, index 182, declared at line 24, column 22
// references:
// pushing activation record 0:mainImage12
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage12:13
    vec2 p = fragCoord.xy / iResolution.xx;
    vec3 c = voronoi(8.0 * p);
    vec3 col = c.x * (0.5 + 0.5 * sin(64.0 * c.x)) * vec3(1.0);
    col = mix(vec3(1.0, 0.6, 0.0), col, smoothstep(0.04, 0.07, c.x));
    float dd = length(c.yz);
    col = mix(vec3(1.0, 0.6, 0.1), col, smoothstep(0.0, 0.12, dd));
    col += vec3(1.0, 0.6, 0.1) * (1.0 - smoothstep(0.0, 0.04, dd));
    fragColor = vec4(col, 1.0);

}
// popping activation record 0:mainImage12:13
// local variables: 
// variable p, unique name 0:mainImage12:13:p, index 202, declared at line 77, column 9
// variable c, unique name 0:mainImage12:13:c, index 203, declared at line 79, column 9
// variable col, unique name 0:mainImage12:13:col, index 204, declared at line 82, column 9
// variable dd, unique name 0:mainImage12:13:dd, index 205, declared at line 86, column 7
// references:
// fragCoord at line 77, column 13
// iResolution at line 77, column 26
// voronoi at line 79, column 13
// p at line 79, column 26
// c at line 82, column 15
// sin at line 82, column 30
// c at line 82, column 39
// vec3 at line 82, column 45
// col at line 84, column 4
// mix at line 84, column 10
// vec3 at line 84, column 15
// col at line 84, column 34
// smoothstep at line 84, column 39
// c at line 84, column 63
// length at line 86, column 12
// c at line 86, column 20
// col at line 87, column 1
// mix at line 87, column 7
// vec3 at line 87, column 12
// col at line 87, column 31
// smoothstep at line 87, column 36
// dd at line 87, column 59
// col at line 88, column 1
// vec3 at line 88, column 8
// smoothstep at line 88, column 31
// dd at line 88, column 54
// fragColor at line 90, column 1
// vec4 at line 90, column 13
// col at line 90, column 18
// popping activation record 0:mainImage12
// local variables: 
// variable fragColor, unique name 0:mainImage12:fragColor, index 200, declared at line 75, column 25
// variable fragCoord, unique name 0:mainImage12:fragCoord, index 201, declared at line 75, column 44
// references:
// undefined variables 
