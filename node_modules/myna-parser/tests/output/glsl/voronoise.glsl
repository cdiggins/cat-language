// pushing activation record 0
// pushing activation record 0:hash31
vec3 hash3(vec2 p)
{
// pushing activation record 0:hash31:2
    vec3 q = vec3(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)), dot(p, vec2(419.2, 371.9)));
    return fract(sin(q) * 43758.5453);

}
// popping activation record 0:hash31:2
// local variables: 
// variable q, unique name 0:hash31:2:q, index 180, declared at line 39, column 9
// references:
// vec3 at line 39, column 13
// dot at line 39, column 19
// p at line 39, column 23
// vec2 at line 39, column 25
// dot at line 40, column 7
// p at line 40, column 11
// vec2 at line 40, column 13
// dot at line 41, column 7
// p at line 41, column 11
// vec2 at line 41, column 13
// fract at line 42, column 8
// sin at line 42, column 14
// q at line 42, column 18
// popping activation record 0:hash31
// local variables: 
// variable p, unique name 0:hash31:p, index 179, declared at line 37, column 17
// references:
// pushing activation record 0:iqnoise3
float iqnoise(in vec2 x, float u, float v)
{
// pushing activation record 0:iqnoise3:4
    vec2 p = floor(x);
    vec2 f = fract(x);
    float k = 1.0 + 63.0 * pow(1.0 - v, 4.0);
    float va = 0.0;
    float wt = 0.0;
    // pushing activation record 0:iqnoise3:4:for5
    for (int j = -2; j <= 2; j++) // pushing activation record 0:iqnoise3:4:for5:for6
    for (int i = -2; i <= 2; i++) {
    // pushing activation record 0:iqnoise3:4:for5:for6:7
        vec2 g = vec2(float(i), float(j));
        vec3 o = hash3(p + g) * vec3(u, u, 1.0);
        vec2 r = g - f + o.xy;
        float d = dot(r, r);
        float ww = pow(1.0 - smoothstep(0.0, 1.414, sqrt(d)), k);
        va += o.z * ww;
        wt += ww;

    }
    // popping activation record 0:iqnoise3:4:for5:for6:7
    // local variables: 
    // variable g, unique name 0:iqnoise3:4:for5:for6:7:g, index 192, declared at line 57, column 13
    // variable o, unique name 0:iqnoise3:4:for5:for6:7:o, index 193, declared at line 58, column 7
    // variable r, unique name 0:iqnoise3:4:for5:for6:7:r, index 194, declared at line 59, column 7
    // variable d, unique name 0:iqnoise3:4:for5:for6:7:d, index 195, declared at line 60, column 8
    // variable ww, unique name 0:iqnoise3:4:for5:for6:7:ww, index 196, declared at line 61, column 8
    // references:
    // vec2 at line 57, column 17
    // float at line 57, column 23
    // i at line 57, column 29
    // float at line 57, column 32
    // j at line 57, column 38
    // hash3 at line 58, column 11
    // p at line 58, column 18
    // g at line 58, column 22
    // vec3 at line 58, column 26
    // u at line 58, column 31
    // u at line 58, column 33
    // g at line 59, column 11
    // f at line 59, column 15
    // o at line 59, column 19
    // dot at line 60, column 12
    // r at line 60, column 16
    // r at line 60, column 18
    // pow at line 61, column 13
    // smoothstep at line 61, column 22
    // sqrt at line 61, column 43
    // d at line 61, column 48
    // k at line 61, column 53
    // va at line 62, column 2
    // o at line 62, column 8
    // ww at line 62, column 12
    // wt at line 63, column 2
    // ww at line 63, column 8
    // popping activation record 0:iqnoise3:4:for5:for6
    // local variables: 
    // variable i, unique name 0:iqnoise3:4:for5:for6:i, index 191, declared at line 55, column 13
    // references:
    // i at line 55, column 19
    // i at line 55, column 25
    // popping activation record 0:iqnoise3:4:for5
    // local variables: 
    // variable j, unique name 0:iqnoise3:4:for5:j, index 190, declared at line 54, column 13
    // references:
    // j at line 54, column 19
    // j at line 54, column 25
    return va / wt;

}
// popping activation record 0:iqnoise3:4
// local variables: 
// variable p, unique name 0:iqnoise3:4:p, index 185, declared at line 47, column 9
// variable f, unique name 0:iqnoise3:4:f, index 186, declared at line 48, column 9
// variable k, unique name 0:iqnoise3:4:k, index 187, declared at line 50, column 7
// variable va, unique name 0:iqnoise3:4:va, index 188, declared at line 52, column 7
// variable wt, unique name 0:iqnoise3:4:wt, index 189, declared at line 53, column 7
// references:
// floor at line 47, column 13
// x at line 47, column 19
// fract at line 48, column 13
// x at line 48, column 19
// pow at line 50, column 20
// v at line 50, column 28
// va at line 66, column 11
// wt at line 66, column 14
// popping activation record 0:iqnoise3
// local variables: 
// variable x, unique name 0:iqnoise3:x, index 182, declared at line 45, column 23
// variable u, unique name 0:iqnoise3:u, index 183, declared at line 45, column 32
// variable v, unique name 0:iqnoise3:v, index 184, declared at line 45, column 41
// references:
// pushing activation record 0:mainImage8
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage8:9
    vec2 uv = fragCoord.xy / iResolution.xx;
    vec2 p = 0.5 - 0.5 * sin(iGlobalTime * vec2(1.01, 1.71));
    if (iMouse.w > 0.001) p = vec2(0.0, 1.0) + vec2(1.0, -1.0) * iMouse.xy / iResolution.xy;
    p = p * p * (3.0 - 2.0 * p);
    p = p * p * (3.0 - 2.0 * p);
    p = p * p * (3.0 - 2.0 * p);
    float f = iqnoise(24.0 * uv, p.x, p.y);
    fragColor = vec4(f, f, f, 1.0);

}
// popping activation record 0:mainImage8:9
// local variables: 
// variable uv, unique name 0:mainImage8:9:uv, index 200, declared at line 71, column 6
// variable p, unique name 0:mainImage8:9:p, index 201, declared at line 73, column 9
// variable f, unique name 0:mainImage8:9:f, index 202, declared at line 81, column 7
// references:
// fragCoord at line 71, column 11
// iResolution at line 71, column 26
// sin at line 73, column 23
// iGlobalTime at line 73, column 28
// vec2 at line 73, column 40
// iMouse at line 75, column 5
// p at line 75, column 22
// vec2 at line 75, column 26
// vec2 at line 75, column 42
// iMouse at line 75, column 57
// iResolution at line 75, column 67
// p at line 77, column 1
// p at line 77, column 5
// p at line 77, column 7
// p at line 77, column 18
// p at line 78, column 1
// p at line 78, column 5
// p at line 78, column 7
// p at line 78, column 18
// p at line 79, column 1
// p at line 79, column 5
// p at line 79, column 7
// p at line 79, column 18
// iqnoise at line 81, column 11
// uv at line 81, column 25
// p at line 81, column 29
// p at line 81, column 34
// fragColor at line 83, column 1
// vec4 at line 83, column 13
// f at line 83, column 19
// f at line 83, column 22
// f at line 83, column 25
// popping activation record 0:mainImage8
// local variables: 
// variable fragColor, unique name 0:mainImage8:fragColor, index 198, declared at line 69, column 25
// variable fragCoord, unique name 0:mainImage8:fragCoord, index 199, declared at line 69, column 44
// references:
// undefined variables 
