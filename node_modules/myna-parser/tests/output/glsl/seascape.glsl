// pushing activation record 0
const int NUM_STEPS = 8;
const float PI = 3.141592;
const float EPSILON = 1e-3;
#define EPSILON_NRM  (0.1 / iResolution.x)

const int ITER_GEOMETRY = 3;
const int ITER_FRAGMENT = 5;
const float SEA_HEIGHT = 0.6;
const float SEA_CHOPPY = 4.0;
const float SEA_SPEED = 0.8;
const float SEA_FREQ = 0.16;
const vec3 SEA_BASE = vec3(0.1, 0.19, 0.22);
const vec3 SEA_WATER_COLOR = vec3(0.8, 0.9, 0.6);
#define SEA_TIME  (1.0 + iGlobalTime * SEA_SPEED)

const mat2 octave_m = mat2(1.6, 1.2, -1.2, 1.6);
// pushing activation record 0:fromEuler1
mat3 fromEuler(vec3 ang)
{
// pushing activation record 0:fromEuler1:2
    vec2 a1 = vec2(sin(ang.x), cos(ang.x));
    vec2 a2 = vec2(sin(ang.y), cos(ang.y));
    vec2 a3 = vec2(sin(ang.z), cos(ang.z));
    mat3 m;
    m[0] = vec3(a1.y * a3.y + a1.x * a2.x * a3.x, a1.y * a2.x * a3.x + a3.y * a1.x, -a2.y * a3.x);
    m[1] = vec3(-a2.y * a1.x, a1.y * a2.y, a2.x);
    m[2] = vec3(a3.y * a1.x * a2.x + a1.y * a3.x, a1.x * a3.x - a1.y * a3.y * a2.x, a2.y * a3.y);
    return m;

}
// popping activation record 0:fromEuler1:2
// local variables: 
// variable a1, unique name 0:fromEuler1:2:a1, index 194, declared at line 25, column 6
// variable a2, unique name 0:fromEuler1:2:a2, index 195, declared at line 26, column 9
// variable a3, unique name 0:fromEuler1:2:a3, index 196, declared at line 27, column 9
// variable m, unique name 0:fromEuler1:2:m, index 197, declared at line 28, column 9
// references:
// vec2 at line 25, column 11
// sin at line 25, column 16
// ang at line 25, column 20
// cos at line 25, column 27
// ang at line 25, column 31
// vec2 at line 26, column 14
// sin at line 26, column 19
// ang at line 26, column 23
// cos at line 26, column 30
// ang at line 26, column 34
// vec2 at line 27, column 14
// sin at line 27, column 19
// ang at line 27, column 23
// cos at line 27, column 30
// ang at line 27, column 34
// m at line 29, column 4
// vec3 at line 29, column 11
// a1 at line 29, column 16
// a3 at line 29, column 21
// a1 at line 29, column 26
// a2 at line 29, column 31
// a3 at line 29, column 36
// a1 at line 29, column 41
// a2 at line 29, column 46
// a3 at line 29, column 51
// a3 at line 29, column 56
// a1 at line 29, column 61
// a2 at line 29, column 67
// a3 at line 29, column 72
// m at line 30, column 1
// vec3 at line 30, column 8
// a2 at line 30, column 14
// a1 at line 30, column 19
// a1 at line 30, column 24
// a2 at line 30, column 29
// a2 at line 30, column 34
// m at line 31, column 1
// vec3 at line 31, column 8
// a3 at line 31, column 13
// a1 at line 31, column 18
// a2 at line 31, column 23
// a1 at line 31, column 28
// a3 at line 31, column 33
// a1 at line 31, column 38
// a3 at line 31, column 43
// a1 at line 31, column 48
// a3 at line 31, column 53
// a2 at line 31, column 58
// a2 at line 31, column 63
// a3 at line 31, column 68
// m at line 32, column 8
// popping activation record 0:fromEuler1
// local variables: 
// variable ang, unique name 0:fromEuler1:ang, index 193, declared at line 24, column 20
// references:
// pushing activation record 0:hash3
float hash(vec2 p)
{
// pushing activation record 0:hash3:4
    float h = dot(p, vec2(127.1, 311.7));
    return fract(sin(h) * 43758.5453123);

}
// popping activation record 0:hash3:4
// local variables: 
// variable h, unique name 0:hash3:4:h, index 200, declared at line 35, column 7
// references:
// dot at line 35, column 11
// p at line 35, column 15
// vec2 at line 35, column 17
// fract at line 36, column 11
// sin at line 36, column 17
// h at line 36, column 21
// popping activation record 0:hash3
// local variables: 
// variable p, unique name 0:hash3:p, index 199, declared at line 34, column 17
// references:
// pushing activation record 0:noise5
float noise(in vec2 p)
{
// pushing activation record 0:noise5:6
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return -1.0 + 2.0 * mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x), mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);

}
// popping activation record 0:noise5:6
// local variables: 
// variable i, unique name 0:noise5:6:i, index 203, declared at line 39, column 9
// variable f, unique name 0:noise5:6:f, index 204, declared at line 40, column 9
// variable u, unique name 0:noise5:6:u, index 205, declared at line 41, column 6
// references:
// floor at line 39, column 13
// p at line 39, column 20
// fract at line 40, column 13
// p at line 40, column 20
// f at line 41, column 10
// f at line 41, column 12
// f at line 41, column 23
// mix at line 42, column 20
// mix at line 42, column 25
// hash at line 42, column 30
// i at line 42, column 36
// vec2 at line 42, column 40
// hash at line 43, column 21
// i at line 43, column 27
// vec2 at line 43, column 31
// u at line 43, column 48
// mix at line 44, column 16
// hash at line 44, column 21
// i at line 44, column 27
// vec2 at line 44, column 31
// hash at line 45, column 21
// i at line 45, column 27
// vec2 at line 45, column 31
// u at line 45, column 48
// u at line 45, column 54
// popping activation record 0:noise5
// local variables: 
// variable p, unique name 0:noise5:p, index 202, declared at line 38, column 21
// references:
// pushing activation record 0:diffuse7
float diffuse(vec3 n, vec3 l, float p)
{
// pushing activation record 0:diffuse7:8
    return pow(dot(n, l) * 0.4 + 0.6, p);

}
// popping activation record 0:diffuse7:8
// local variables: 
// references:
// pow at line 50, column 11
// dot at line 50, column 15
// n at line 50, column 19
// l at line 50, column 21
// p at line 50, column 36
// popping activation record 0:diffuse7
// local variables: 
// variable n, unique name 0:diffuse7:n, index 207, declared at line 49, column 19
// variable l, unique name 0:diffuse7:l, index 208, declared at line 49, column 26
// variable p, unique name 0:diffuse7:p, index 209, declared at line 49, column 34
// references:
// pushing activation record 0:specular9
float specular(vec3 n, vec3 l, vec3 e, float s)
{
// pushing activation record 0:specular9:10
    float nrm = (s + 8.0) / (PI * 8.0);
    return pow(max(dot(reflect(e, n), l), 0.0), s) * nrm;

}
// popping activation record 0:specular9:10
// local variables: 
// variable nrm, unique name 0:specular9:10:nrm, index 215, declared at line 53, column 10
// references:
// s at line 53, column 17
// PI at line 53, column 29
// pow at line 54, column 11
// max at line 54, column 15
// dot at line 54, column 19
// reflect at line 54, column 23
// e at line 54, column 31
// n at line 54, column 33
// l at line 54, column 36
// s at line 54, column 44
// nrm at line 54, column 49
// popping activation record 0:specular9
// local variables: 
// variable n, unique name 0:specular9:n, index 211, declared at line 52, column 20
// variable l, unique name 0:specular9:l, index 212, declared at line 52, column 27
// variable e, unique name 0:specular9:e, index 213, declared at line 52, column 34
// variable s, unique name 0:specular9:s, index 214, declared at line 52, column 42
// references:
// pushing activation record 0:getSkyColor11
vec3 getSkyColor(vec3 e)
{
// pushing activation record 0:getSkyColor11:12
    e.y = max(e.y, 0.0);
    return vec3(pow(1.0 - e.y, 2.0), 1.0 - e.y, 0.6 + (1.0 - e.y) * 0.4);

}
// popping activation record 0:getSkyColor11:12
// local variables: 
// references:
// e at line 59, column 4
// max at line 59, column 10
// e at line 59, column 14
// vec3 at line 60, column 11
// pow at line 60, column 16
// e at line 60, column 24
// e at line 60, column 38
// e at line 60, column 52
// popping activation record 0:getSkyColor11
// local variables: 
// variable e, unique name 0:getSkyColor11:e, index 217, declared at line 58, column 22
// references:
// pushing activation record 0:sea_octave13
float sea_octave(vec2 uv, float choppy)
{
// pushing activation record 0:sea_octave13:14
    uv += noise(uv);
    vec2 wv = 1.0 - abs(sin(uv));
    vec2 swv = abs(cos(uv));
    wv = mix(wv, swv, wv);
    return pow(1.0 - pow(wv.x * wv.y, 0.65), choppy);

}
// popping activation record 0:sea_octave13:14
// local variables: 
// variable wv, unique name 0:sea_octave13:14:wv, index 221, declared at line 66, column 9
// variable swv, unique name 0:sea_octave13:14:swv, index 222, declared at line 67, column 9
// references:
// uv at line 65, column 4
// noise at line 65, column 10
// uv at line 65, column 16
// abs at line 66, column 18
// sin at line 66, column 22
// uv at line 66, column 26
// abs at line 67, column 15
// cos at line 67, column 19
// uv at line 67, column 23
// wv at line 68, column 4
// mix at line 68, column 9
// wv at line 68, column 13
// swv at line 68, column 16
// wv at line 68, column 20
// pow at line 69, column 11
// pow at line 69, column 19
// wv at line 69, column 23
// wv at line 69, column 30
// choppy at line 69, column 41
// popping activation record 0:sea_octave13
// local variables: 
// variable uv, unique name 0:sea_octave13:uv, index 219, declared at line 64, column 22
// variable choppy, unique name 0:sea_octave13:choppy, index 220, declared at line 64, column 32
// references:
// pushing activation record 0:map15
float map(vec3 p)
{
// pushing activation record 0:map15:16
    float freq = SEA_FREQ;
    float amp = SEA_HEIGHT;
    float choppy = SEA_CHOPPY;
    vec2 uv = p.xz;
    uv.x *= 0.75;
    float d, h = 0.0;
    // pushing activation record 0:map15:16:for17
    for (int i = 0; i < ITER_GEOMETRY; i++) {
    // pushing activation record 0:map15:16:for17:18
        d = sea_octave((uv + SEA_TIME) * freq, choppy);
        d += sea_octave((uv - SEA_TIME) * freq, choppy);
        h += d * amp;
        uv *= octave_m;
        freq *= 1.9;
        amp *= 0.22;
        choppy = mix(choppy, 1.0, 0.2);

    }
    // popping activation record 0:map15:16:for17:18
    // local variables: 
    // references:
    // d at line 80, column 5
    // sea_octave at line 80, column 9
    // uv at line 80, column 21
    // SEA_TIME at line 80, column 24
    // freq at line 80, column 34
    // choppy at line 80, column 39
    // d at line 81, column 5
    // sea_octave at line 81, column 10
    // uv at line 81, column 22
    // SEA_TIME at line 81, column 25
    // freq at line 81, column 35
    // choppy at line 81, column 40
    // h at line 82, column 8
    // d at line 82, column 13
    // amp at line 82, column 17
    // uv at line 83, column 5
    // octave_m at line 83, column 11
    // freq at line 83, column 21
    // amp at line 83, column 34
    // choppy at line 84, column 8
    // mix at line 84, column 17
    // choppy at line 84, column 21
    // popping activation record 0:map15:16:for17
    // local variables: 
    // variable i, unique name 0:map15:16:for17:i, index 231, declared at line 79, column 12
    // references:
    // i at line 79, column 19
    // ITER_GEOMETRY at line 79, column 23
    // i at line 79, column 38
    return p.y - h;

}
// popping activation record 0:map15:16
// local variables: 
// variable freq, unique name 0:map15:16:freq, index 225, declared at line 73, column 10
// variable amp, unique name 0:map15:16:amp, index 226, declared at line 74, column 10
// variable choppy, unique name 0:map15:16:choppy, index 227, declared at line 75, column 10
// variable uv, unique name 0:map15:16:uv, index 228, declared at line 76, column 9
// variable d, unique name 0:map15:16:d, index 229, declared at line 78, column 10
// variable h, unique name 0:map15:16:h, index 230, declared at line 78, column 13
// references:
// SEA_FREQ at line 73, column 17
// SEA_HEIGHT at line 74, column 16
// SEA_CHOPPY at line 75, column 19
// p at line 76, column 14
// uv at line 76, column 20
// p at line 86, column 11
// h at line 86, column 17
// popping activation record 0:map15
// local variables: 
// variable p, unique name 0:map15:p, index 224, declared at line 72, column 15
// references:
// pushing activation record 0:map_detailed19
float map_detailed(vec3 p)
{
// pushing activation record 0:map_detailed19:20
    float freq = SEA_FREQ;
    float amp = SEA_HEIGHT;
    float choppy = SEA_CHOPPY;
    vec2 uv = p.xz;
    uv.x *= 0.75;
    float d, h = 0.0;
    // pushing activation record 0:map_detailed19:20:for21
    for (int i = 0; i < ITER_FRAGMENT; i++) {
    // pushing activation record 0:map_detailed19:20:for21:22
        d = sea_octave((uv + SEA_TIME) * freq, choppy);
        d += sea_octave((uv - SEA_TIME) * freq, choppy);
        h += d * amp;
        uv *= octave_m;
        freq *= 1.9;
        amp *= 0.22;
        choppy = mix(choppy, 1.0, 0.2);

    }
    // popping activation record 0:map_detailed19:20:for21:22
    // local variables: 
    // references:
    // d at line 97, column 5
    // sea_octave at line 97, column 9
    // uv at line 97, column 21
    // SEA_TIME at line 97, column 24
    // freq at line 97, column 34
    // choppy at line 97, column 39
    // d at line 98, column 5
    // sea_octave at line 98, column 10
    // uv at line 98, column 22
    // SEA_TIME at line 98, column 25
    // freq at line 98, column 35
    // choppy at line 98, column 40
    // h at line 99, column 8
    // d at line 99, column 13
    // amp at line 99, column 17
    // uv at line 100, column 5
    // octave_m at line 100, column 11
    // freq at line 100, column 21
    // amp at line 100, column 34
    // choppy at line 101, column 8
    // mix at line 101, column 17
    // choppy at line 101, column 21
    // popping activation record 0:map_detailed19:20:for21
    // local variables: 
    // variable i, unique name 0:map_detailed19:20:for21:i, index 240, declared at line 96, column 12
    // references:
    // i at line 96, column 19
    // ITER_FRAGMENT at line 96, column 23
    // i at line 96, column 38
    return p.y - h;

}
// popping activation record 0:map_detailed19:20
// local variables: 
// variable freq, unique name 0:map_detailed19:20:freq, index 234, declared at line 90, column 10
// variable amp, unique name 0:map_detailed19:20:amp, index 235, declared at line 91, column 10
// variable choppy, unique name 0:map_detailed19:20:choppy, index 236, declared at line 92, column 10
// variable uv, unique name 0:map_detailed19:20:uv, index 237, declared at line 93, column 9
// variable d, unique name 0:map_detailed19:20:d, index 238, declared at line 95, column 10
// variable h, unique name 0:map_detailed19:20:h, index 239, declared at line 95, column 13
// references:
// SEA_FREQ at line 90, column 17
// SEA_HEIGHT at line 91, column 16
// SEA_CHOPPY at line 92, column 19
// p at line 93, column 14
// uv at line 93, column 20
// p at line 103, column 11
// h at line 103, column 17
// popping activation record 0:map_detailed19
// local variables: 
// variable p, unique name 0:map_detailed19:p, index 233, declared at line 89, column 24
// references:
// pushing activation record 0:getSeaColor23
vec3 getSeaColor(vec3 p, vec3 n, vec3 l, vec3 eye, vec3 dist)
{
// pushing activation record 0:getSeaColor23:24
    float fresnel = clamp(1.0 - dot(n, -eye), 0.0, 1.0);
    fresnel = pow(fresnel, 3.0) * 0.65;
    vec3 reflected = getSkyColor(reflect(eye, n));
    vec3 refracted = SEA_BASE + diffuse(n, l, 80.0) * SEA_WATER_COLOR * 0.12;
    vec3 color = mix(refracted, reflected, fresnel);
    float atten = max(1.0 - dot(dist, dist) * 0.001, 0.0);
    color += SEA_WATER_COLOR * (p.y - SEA_HEIGHT) * 0.18 * atten;
    color += vec3(specular(n, l, eye, 60.0));
    return color;

}
// popping activation record 0:getSeaColor23:24
// local variables: 
// variable fresnel, unique name 0:getSeaColor23:24:fresnel, index 247, declared at line 107, column 10
// variable reflected, unique name 0:getSeaColor23:24:reflected, index 248, declared at line 110, column 9
// variable refracted, unique name 0:getSeaColor23:24:refracted, index 249, declared at line 111, column 9
// variable color, unique name 0:getSeaColor23:24:color, index 250, declared at line 113, column 9
// variable atten, unique name 0:getSeaColor23:24:atten, index 251, declared at line 115, column 10
// references:
// clamp at line 107, column 20
// dot at line 107, column 32
// n at line 107, column 36
// eye at line 107, column 39
// fresnel at line 108, column 4
// pow at line 108, column 14
// fresnel at line 108, column 18
// getSkyColor at line 110, column 21
// reflect at line 110, column 33
// eye at line 110, column 41
// n at line 110, column 45
// SEA_BASE at line 111, column 21
// diffuse at line 111, column 32
// n at line 111, column 40
// l at line 111, column 42
// SEA_WATER_COLOR at line 111, column 52
// mix at line 113, column 17
// refracted at line 113, column 21
// reflected at line 113, column 31
// fresnel at line 113, column 41
// max at line 115, column 18
// dot at line 115, column 28
// dist at line 115, column 32
// dist at line 115, column 37
// color at line 116, column 4
// SEA_WATER_COLOR at line 116, column 13
// p at line 116, column 32
// SEA_HEIGHT at line 116, column 38
// atten at line 116, column 59
// color at line 118, column 4
// vec3 at line 118, column 13
// specular at line 118, column 18
// n at line 118, column 27
// l at line 118, column 29
// eye at line 118, column 31
// color at line 120, column 11
// popping activation record 0:getSeaColor23
// local variables: 
// variable p, unique name 0:getSeaColor23:p, index 242, declared at line 106, column 22
// variable n, unique name 0:getSeaColor23:n, index 243, declared at line 106, column 30
// variable l, unique name 0:getSeaColor23:l, index 244, declared at line 106, column 38
// variable eye, unique name 0:getSeaColor23:eye, index 245, declared at line 106, column 46
// variable dist, unique name 0:getSeaColor23:dist, index 246, declared at line 106, column 56
// references:
// pushing activation record 0:getNormal25
vec3 getNormal(vec3 p, float eps)
{
// pushing activation record 0:getNormal25:26
    vec3 n;
    n.y = map_detailed(p);
    n.x = map_detailed(vec3(p.x + eps, p.y, p.z)) - n.y;
    n.z = map_detailed(vec3(p.x, p.y, p.z + eps)) - n.y;
    n.y = eps;
    return normalize(n);

}
// popping activation record 0:getNormal25:26
// local variables: 
// variable n, unique name 0:getNormal25:26:n, index 255, declared at line 125, column 9
// references:
// n at line 126, column 4
// map_detailed at line 126, column 10
// p at line 126, column 23
// n at line 127, column 4
// map_detailed at line 127, column 10
// vec3 at line 127, column 23
// p at line 127, column 28
// eps at line 127, column 32
// p at line 127, column 36
// p at line 127, column 40
// n at line 127, column 48
// n at line 128, column 4
// map_detailed at line 128, column 10
// vec3 at line 128, column 23
// p at line 128, column 28
// p at line 128, column 32
// p at line 128, column 36
// eps at line 128, column 40
// n at line 128, column 48
// n at line 129, column 4
// eps at line 129, column 10
// normalize at line 130, column 11
// n at line 130, column 21
// popping activation record 0:getNormal25
// local variables: 
// variable p, unique name 0:getNormal25:p, index 253, declared at line 124, column 20
// variable eps, unique name 0:getNormal25:eps, index 254, declared at line 124, column 29
// references:
// pushing activation record 0:heightMapTracing27
float heightMapTracing(vec3 ori, vec3 dir, out vec3 p)
{
// pushing activation record 0:heightMapTracing27:28
    float tm = 0.0;
    float tx = 1000.0;
    float hx = map(ori + dir * tx);
    if (hx > 0.0) return tx;
    float hm = map(ori + dir * tm);
    float tmid = 0.0;
    // pushing activation record 0:heightMapTracing27:28:for29
    for (int i = 0; i < NUM_STEPS; i++) {
    // pushing activation record 0:heightMapTracing27:28:for29:30
        tmid = mix(tm, tx, hm / (hm - hx));
        p = ori + dir * tmid;
        float hmid = map(p);
        if (hmid < 0.0) {
        // pushing activation record 0:heightMapTracing27:28:for29:30:31
            tx = tmid;
            hx = hmid;

        }
        // popping activation record 0:heightMapTracing27:28:for29:30:31
        // local variables: 
        // references:
        // tx at line 145, column 9
        // tmid at line 145, column 14
        // hx at line 146, column 12
        // hmid at line 146, column 17

    }
    // popping activation record 0:heightMapTracing27:28:for29:30
    // local variables: 
    // variable hmid, unique name 0:heightMapTracing27:28:for29:30:hmid, index 266, declared at line 143, column 11
    // references:
    // tmid at line 141, column 8
    // mix at line 141, column 15
    // tm at line 141, column 19
    // tx at line 141, column 22
    // hm at line 141, column 26
    // hm at line 141, column 30
    // hx at line 141, column 33
    // p at line 142, column 8
    // ori at line 142, column 12
    // dir at line 142, column 18
    // tmid at line 142, column 24
    // map at line 143, column 18
    // p at line 143, column 22
    // hmid at line 144, column 5
    // popping activation record 0:heightMapTracing27:28:for29
    // local variables: 
    // variable i, unique name 0:heightMapTracing27:28:for29:i, index 265, declared at line 140, column 12
    // references:
    // i at line 140, column 19
    // NUM_STEPS at line 140, column 23
    // i at line 140, column 34
    return tmid;

}
// popping activation record 0:heightMapTracing27:28
// local variables: 
// variable tm, unique name 0:heightMapTracing27:28:tm, index 260, declared at line 134, column 10
// variable tx, unique name 0:heightMapTracing27:28:tx, index 261, declared at line 135, column 10
// variable hx, unique name 0:heightMapTracing27:28:hx, index 262, declared at line 136, column 10
// variable hm, unique name 0:heightMapTracing27:28:hm, index 263, declared at line 138, column 10
// variable tmid, unique name 0:heightMapTracing27:28:tmid, index 264, declared at line 139, column 10
// references:
// map at line 136, column 15
// ori at line 136, column 19
// dir at line 136, column 25
// tx at line 136, column 31
// hx at line 137, column 7
// tx at line 137, column 24
// map at line 138, column 15
// ori at line 138, column 19
// dir at line 138, column 25
// tm at line 138, column 31
// tmid at line 152, column 11
// popping activation record 0:heightMapTracing27
// local variables: 
// variable ori, unique name 0:heightMapTracing27:ori, index 257, declared at line 133, column 28
// variable dir, unique name 0:heightMapTracing27:dir, index 258, declared at line 133, column 38
// variable p, unique name 0:heightMapTracing27:p, index 259, declared at line 133, column 52
// references:
// pushing activation record 0:mainImage32
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage32:33
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv = uv * 2.0 - 1.0;
    uv.x *= iResolution.x / iResolution.y;
    float time = iGlobalTime * 0.3 + iMouse.x * 0.01;
    vec3 ang = vec3(sin(time * 3.0) * 0.1, sin(time) * 0.2 + 0.3, time);
    vec3 ori = vec3(0.0, 3.5, time * 5.0);
    vec3 dir = normalize(vec3(uv.xy, -2.0));
    dir.z += length(uv) * 0.15;
    dir = normalize(dir) * fromEuler(ang);
    vec3 p;
    heightMapTracing(ori, dir, p);
    vec3 dist = p - ori;
    vec3 n = getNormal(p, dot(dist, dist) * EPSILON_NRM);
    vec3 light = normalize(vec3(0.0, 1.0, 0.8));
    vec3 color = mix(getSkyColor(dir), getSeaColor(p, n, light, dir, dist), pow(smoothstep(0.0, -0.05, dir.y), 0.3));
    fragColor = vec4(pow(color, vec3(0.75)), 1.0);

}
// popping activation record 0:mainImage32:33
// local variables: 
// variable uv, unique name 0:mainImage32:33:uv, index 270, declared at line 157, column 6
// variable time, unique name 0:mainImage32:33:time, index 271, declared at line 160, column 10
// variable ang, unique name 0:mainImage32:33:ang, index 272, declared at line 163, column 9
// variable ori, unique name 0:mainImage32:33:ori, index 273, declared at line 164, column 9
// variable dir, unique name 0:mainImage32:33:dir, index 274, declared at line 165, column 9
// variable p, unique name 0:mainImage32:33:p, index 275, declared at line 169, column 9
// variable dist, unique name 0:mainImage32:33:dist, index 276, declared at line 171, column 9
// variable n, unique name 0:mainImage32:33:n, index 277, declared at line 172, column 9
// variable light, unique name 0:mainImage32:33:light, index 278, declared at line 173, column 9
// variable color, unique name 0:mainImage32:33:color, index 279, declared at line 176, column 9
// references:
// fragCoord at line 157, column 11
// iResolution at line 157, column 26
// uv at line 158, column 4
// uv at line 158, column 9
// uv at line 159, column 4
// iResolution at line 159, column 12
// iResolution at line 159, column 28
// iGlobalTime at line 160, column 17
// iMouse at line 160, column 37
// vec3 at line 163, column 15
// sin at line 163, column 20
// time at line 163, column 24
// sin at line 163, column 38
// time at line 163, column 42
// time at line 163, column 56
// vec3 at line 164, column 15
// time at line 164, column 28
// normalize at line 165, column 15
// vec3 at line 165, column 25
// uv at line 165, column 30
// dir at line 165, column 44
// length at line 165, column 53
// uv at line 165, column 60
// dir at line 166, column 4
// normalize at line 166, column 10
// dir at line 166, column 20
// fromEuler at line 166, column 27
// ang at line 166, column 37
// heightMapTracing at line 170, column 4
// ori at line 170, column 21
// dir at line 170, column 25
// p at line 170, column 29
// p at line 171, column 16
// ori at line 171, column 20
// getNormal at line 172, column 13
// p at line 172, column 23
// dot at line 172, column 26
// dist at line 172, column 30
// dist at line 172, column 35
// EPSILON_NRM at line 172, column 43
// normalize at line 173, column 17
// vec3 at line 173, column 27
// mix at line 176, column 17
// getSkyColor at line 177, column 8
// dir at line 177, column 20
// getSeaColor at line 178, column 8
// p at line 178, column 20
// n at line 178, column 22
// light at line 178, column 24
// dir at line 178, column 30
// dist at line 178, column 34
// pow at line 179, column 5
// smoothstep at line 179, column 9
// dir at line 179, column 30
// fragColor at line 182, column 1
// vec4 at line 182, column 13
// pow at line 182, column 18
// color at line 182, column 22
// vec3 at line 182, column 28
// popping activation record 0:mainImage32
// local variables: 
// variable fragColor, unique name 0:mainImage32:fragColor, index 268, declared at line 156, column 25
// variable fragCoord, unique name 0:mainImage32:fragCoord, index 269, declared at line 156, column 44
// references:
// undefined variables 
