// pushing activation record 0
// pushing activation record 0:noise1
float noise(vec3 p)
{
// pushing activation record 0:noise1:2
    vec3 i = floor(p);
    vec4 a = dot(i, vec3(1., 57., 21.)) + vec4(0., 57., 21., 78.);
    vec3 f = cos((p - i) * acos(-1.)) * (-.5) + .5;
    a = mix(sin(cos(a) * a), sin(cos(1. + a) * (1. + a)), f.x);
    a.xy = mix(a.xz, a.yw, f.y);
    return mix(a.x, a.y, f.z);

}
// popping activation record 0:noise1:2
// local variables: 
// variable i, unique name 0:noise1:2:i, index 180, declared at line 4, column 6
// variable a, unique name 0:noise1:2:a, index 181, declared at line 5, column 6
// variable f, unique name 0:noise1:2:f, index 182, declared at line 6, column 6
// references:
// floor at line 4, column 10
// p at line 4, column 16
// dot at line 5, column 10
// i at line 5, column 14
// vec3 at line 5, column 17
// vec4 at line 5, column 39
// cos at line 6, column 10
// p at line 6, column 15
// i at line 6, column 17
// acos at line 6, column 20
// a at line 7, column 1
// mix at line 7, column 5
// sin at line 7, column 9
// cos at line 7, column 13
// a at line 7, column 17
// a at line 7, column 20
// sin at line 7, column 23
// cos at line 7, column 27
// a at line 7, column 34
// a at line 7, column 41
// f at line 7, column 46
// a at line 8, column 1
// mix at line 8, column 8
// a at line 8, column 12
// a at line 8, column 18
// f at line 8, column 24
// mix at line 9, column 8
// a at line 9, column 12
// a at line 9, column 17
// f at line 9, column 22
// popping activation record 0:noise1
// local variables: 
// variable p, unique name 0:noise1:p, index 179, declared at line 2, column 17
// references:
// pushing activation record 0:sphere3
float sphere(vec3 p, vec4 spr)
{
// pushing activation record 0:sphere3:4
    return length(spr.xyz - p) - spr.w;

}
// popping activation record 0:sphere3:4
// local variables: 
// references:
// length at line 14, column 8
// spr at line 14, column 15
// p at line 14, column 23
// spr at line 14, column 28
// popping activation record 0:sphere3
// local variables: 
// variable p, unique name 0:sphere3:p, index 184, declared at line 12, column 18
// variable spr, unique name 0:sphere3:spr, index 185, declared at line 12, column 26
// references:
// pushing activation record 0:flame5
float flame(vec3 p)
{
// pushing activation record 0:flame5:6
    float d = sphere(p * vec3(1., .5, 1.), vec4(.0, -1., .0, 1.));
    return d + (noise(p + vec3(.0, iGlobalTime * 2., .0)) + noise(p * 3.) * .5) * .25 * (p.y);

}
// popping activation record 0:flame5:6
// local variables: 
// variable d, unique name 0:flame5:6:d, index 188, declared at line 19, column 7
// references:
// sphere at line 19, column 11
// p at line 19, column 18
// vec3 at line 19, column 20
// vec4 at line 19, column 36
// d at line 20, column 8
// noise at line 20, column 13
// p at line 20, column 19
// vec3 at line 20, column 21
// iGlobalTime at line 20, column 29
// noise at line 20, column 51
// p at line 20, column 57
// p at line 20, column 72
// popping activation record 0:flame5
// local variables: 
// variable p, unique name 0:flame5:p, index 187, declared at line 17, column 17
// references:
// pushing activation record 0:scene7
float scene(vec3 p)
{
// pushing activation record 0:scene7:8
    return min(100. - length(p), abs(flame(p)));

}
// popping activation record 0:scene7:8
// local variables: 
// references:
// min at line 25, column 8
// length at line 25, column 17
// p at line 25, column 24
// abs at line 25, column 29
// flame at line 25, column 33
// p at line 25, column 39
// popping activation record 0:scene7
// local variables: 
// variable p, unique name 0:scene7:p, index 190, declared at line 23, column 17
// references:
// pushing activation record 0:raymarch9
vec4 raymarch(vec3 org, vec3 dir)
{
// pushing activation record 0:raymarch9:10
    float d = 0.0, glow = 0.0, eps = 0.02;
    vec3 p = org;
    bool glowed = false;
    // pushing activation record 0:raymarch9:10:for11
    for (int i = 0; i < 64; i++) {
    // pushing activation record 0:raymarch9:10:for11:12
        d = scene(p) + eps;
        p += d * dir;
        if (d > eps) {
        // pushing activation record 0:raymarch9:10:for11:12:13
            if (flame(p) < .0) glowed = true;
            if (glowed) glow = float(i) / 64.;

        }
        // popping activation record 0:raymarch9:10:for11:12:13
        // local variables: 
        // references:
        // flame at line 40, column 6
        // p at line 40, column 12
        // glowed at line 41, column 4
        // glowed at line 42, column 6
        // glow at line 43, column 10
        // float at line 43, column 17
        // i at line 43, column 23

    }
    // popping activation record 0:raymarch9:10:for11:12
    // local variables: 
    // references:
    // d at line 36, column 2
    // scene at line 36, column 6
    // p at line 36, column 12
    // eps at line 36, column 17
    // p at line 37, column 2
    // d at line 37, column 7
    // dir at line 37, column 11
    // d at line 38, column 6
    // eps at line 38, column 8
    // popping activation record 0:raymarch9:10:for11
    // local variables: 
    // variable i, unique name 0:raymarch9:10:for11:i, index 199, declared at line 34, column 9
    // references:
    // i at line 34, column 14
    // i at line 34, column 20
    return vec4(p, glow);

}
// popping activation record 0:raymarch9:10
// local variables: 
// variable d, unique name 0:raymarch9:10:d, index 194, declared at line 30, column 7
// variable glow, unique name 0:raymarch9:10:glow, index 195, declared at line 30, column 16
// variable eps, unique name 0:raymarch9:10:eps, index 196, declared at line 30, column 28
// variable p, unique name 0:raymarch9:10:p, index 197, declared at line 31, column 7
// variable glowed, unique name 0:raymarch9:10:glowed, index 198, declared at line 32, column 6
// references:
// org at line 31, column 11
// vec4 at line 46, column 8
// p at line 46, column 13
// glow at line 46, column 15
// popping activation record 0:raymarch9
// local variables: 
// variable org, unique name 0:raymarch9:org, index 192, declared at line 28, column 19
// variable dir, unique name 0:raymarch9:dir, index 193, declared at line 28, column 29
// references:
// pushing activation record 0:mainImage14
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage14:15
    vec2 v = -1.0 + 2.0 * fragCoord.xy / iResolution.xy;
    v.x *= iResolution.x / iResolution.y;
    vec3 org = vec3(0., -2., 4.);
    vec3 dir = normalize(vec3(v.x * 1.6, -v.y, -1.5));
    vec4 p = raymarch(org, dir);
    float glow = p.w;
    vec4 col = mix(vec4(1., .5, .1, 1.), vec4(0.1, .5, 1., 1.), p.y * .02 + .4);
    fragColor = mix(vec4(0.), col, pow(glow * 2., 4.));

}
// popping activation record 0:mainImage14:15
// local variables: 
// variable v, unique name 0:mainImage14:15:v, index 203, declared at line 51, column 6
// variable org, unique name 0:mainImage14:15:org, index 204, declared at line 54, column 6
// variable dir, unique name 0:mainImage14:15:dir, index 205, declared at line 55, column 6
// variable p, unique name 0:mainImage14:15:p, index 206, declared at line 57, column 6
// variable glow, unique name 0:mainImage14:15:glow, index 207, declared at line 58, column 7
// variable col, unique name 0:mainImage14:15:col, index 208, declared at line 60, column 6
// references:
// fragCoord at line 51, column 23
// iResolution at line 51, column 38
// v at line 52, column 1
// iResolution at line 52, column 8
// iResolution at line 52, column 22
// vec3 at line 54, column 12
// normalize at line 55, column 12
// vec3 at line 55, column 22
// v at line 55, column 27
// v at line 55, column 37
// raymarch at line 57, column 10
// org at line 57, column 19
// dir at line 57, column 24
// p at line 58, column 14
// mix at line 60, column 12
// vec4 at line 60, column 16
// vec4 at line 60, column 35
// p at line 60, column 55
// fragColor at line 62, column 1
// mix at line 62, column 13
// vec4 at line 62, column 17
// col at line 62, column 27
// pow at line 62, column 32
// glow at line 62, column 36
// popping activation record 0:mainImage14
// local variables: 
// variable fragColor, unique name 0:mainImage14:fragColor, index 201, declared at line 49, column 25
// variable fragCoord, unique name 0:mainImage14:fragCoord, index 202, declared at line 49, column 44
// references:
// undefined variables 
