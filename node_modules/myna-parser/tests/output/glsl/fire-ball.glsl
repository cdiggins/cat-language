// pushing activation record 0
#define saturate (oo)clamp(oo, 0.0, 1.0)

#define MarchSteps  8

#define ExpPosition  vec3(0.0)

#define Radius  2.0

#define Background  vec4(0.1, 0.0, 0.0, 1.0)

#define NoiseSteps  1

#define NoiseAmplitude  0.06

#define NoiseFrequency  4.0

#define Animation  vec3(0.0, -3.0, 0.5)

#define Color1  vec4(1.0, 1.0, 1.0, 1.0)

#define Color2  vec4(1.0, 0.8, 0.2, 1.0)

#define Color3  vec4(1.0, 0.03, 0.0, 1.0)

#define Color4  vec4(0.05, 0.02, 0.02, 1.0)

// pushing activation record 0:mod2891
vec3 mod289(vec3 x)
{
// pushing activation record 0:mod2891:2
    return x - floor(x * (1.0 / 289.0)) * 289.0;

}
// popping activation record 0:mod2891:2
// local variables: 
// references:
// x at line 36, column 29
// floor at line 36, column 33
// x at line 36, column 39
// popping activation record 0:mod2891
// local variables: 
// variable x, unique name 0:mod2891:x, index 192, declared at line 36, column 17
// references:
// pushing activation record 0:mod2893
vec4 mod289(vec4 x)
{
// pushing activation record 0:mod2893:4
    return x - floor(x * (1.0 / 289.0)) * 289.0;

}
// popping activation record 0:mod2893:4
// local variables: 
// references:
// x at line 37, column 29
// floor at line 37, column 33
// x at line 37, column 39
// popping activation record 0:mod2893
// local variables: 
// variable x, unique name 0:mod2893:x, index 193, declared at line 37, column 17
// references:
// pushing activation record 0:permute5
vec4 permute(vec4 x)
{
// pushing activation record 0:permute5:6
    return mod289(((x * 34.0) + 1.0) * x);

}
// popping activation record 0:permute5:6
// local variables: 
// references:
// mod289 at line 38, column 30
// x at line 38, column 39
// x at line 38, column 52
// popping activation record 0:permute5
// local variables: 
// variable x, unique name 0:permute5:x, index 195, declared at line 38, column 18
// references:
// pushing activation record 0:taylorInvSqrt7
vec4 taylorInvSqrt(vec4 r)
{
// pushing activation record 0:taylorInvSqrt7:8
    return 1.79284291400159 - 0.85373472095314 * r;

}
// popping activation record 0:taylorInvSqrt7:8
// local variables: 
// references:
// r at line 39, column 73
// popping activation record 0:taylorInvSqrt7
// local variables: 
// variable r, unique name 0:taylorInvSqrt7:r, index 197, declared at line 39, column 24
// references:
// pushing activation record 0:snoise9
float snoise(vec3 v)
{
// pushing activation record 0:snoise9:10
    const vec2 C = vec2(1.0 / 6.0, 1.0 / 3.0);
    const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);
    vec3 i = floor(v + dot(v, C.yyy));
    vec3 x0 = v - i + dot(i, C.xxx);
    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min(g.xyz, l.zxy);
    vec3 i2 = max(g.xyz, l.zxy);
    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy;
    vec3 x3 = x0 - D.yyy;
    i = mod289(i);
    vec4 p = permute(permute(permute(i.z + vec4(0.0, i1.z, i2.z, 1.0)) + i.y + vec4(0.0, i1.y, i2.y, 1.0)) + i.x + vec4(0.0, i1.x, i2.x, 1.0));
    float n_ = 0.142857142857;
    vec3 ns = n_ * D.wyz - D.xzx;
    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);
    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_);
    vec4 x = x_ * ns.x + ns.yyyy;
    vec4 y = y_ * ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);
    vec4 b0 = vec4(x.xy, y.xy);
    vec4 b1 = vec4(x.zw, y.zw);
    vec4 s0 = floor(b0) * 2.0 + 1.0;
    vec4 s1 = floor(b1) * 2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));
    vec4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    vec4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
    vec3 p0 = vec3(a0.xy, h.x);
    vec3 p1 = vec3(a0.zw, h.y);
    vec3 p2 = vec3(a1.xy, h.z);
    vec3 p3 = vec3(a1.zw, h.w);
    vec4 norm = taylorInvSqrt(vec4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;
    vec4 m = max(0.6 - vec4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
    m = m * m;
    return 42.0 * dot(m * m, vec4(dot(p0, x0), dot(p1, x1), dot(p2, x2), dot(p3, x3)));

}
// popping activation record 0:snoise9:10
// local variables: 
// variable C, unique name 0:snoise9:10:C, index 200, declared at line 43, column 13
// variable D, unique name 0:snoise9:10:D, index 201, declared at line 44, column 13
// variable i, unique name 0:snoise9:10:i, index 202, declared at line 46, column 6
// variable x0, unique name 0:snoise9:10:x0, index 203, declared at line 47, column 6
// variable g, unique name 0:snoise9:10:g, index 204, declared at line 49, column 6
// variable l, unique name 0:snoise9:10:l, index 205, declared at line 50, column 6
// variable i1, unique name 0:snoise9:10:i1, index 206, declared at line 51, column 6
// variable i2, unique name 0:snoise9:10:i2, index 207, declared at line 52, column 6
// variable x1, unique name 0:snoise9:10:x1, index 208, declared at line 53, column 6
// variable x2, unique name 0:snoise9:10:x2, index 209, declared at line 54, column 6
// variable x3, unique name 0:snoise9:10:x3, index 210, declared at line 55, column 6
// variable p, unique name 0:snoise9:10:p, index 211, declared at line 58, column 6
// variable n_, unique name 0:snoise9:10:n_, index 212, declared at line 61, column 7
// variable ns, unique name 0:snoise9:10:ns, index 213, declared at line 62, column 7
// variable j, unique name 0:snoise9:10:j, index 214, declared at line 63, column 6
// variable x_, unique name 0:snoise9:10:x_, index 215, declared at line 64, column 6
// variable y_, unique name 0:snoise9:10:y_, index 216, declared at line 65, column 6
// variable x, unique name 0:snoise9:10:x, index 217, declared at line 66, column 6
// variable y, unique name 0:snoise9:10:y, index 218, declared at line 67, column 6
// variable h, unique name 0:snoise9:10:h, index 219, declared at line 68, column 6
// variable b0, unique name 0:snoise9:10:b0, index 220, declared at line 69, column 6
// variable b1, unique name 0:snoise9:10:b1, index 221, declared at line 70, column 6
// variable s0, unique name 0:snoise9:10:s0, index 222, declared at line 71, column 6
// variable s1, unique name 0:snoise9:10:s1, index 223, declared at line 72, column 6
// variable sh, unique name 0:snoise9:10:sh, index 224, declared at line 73, column 6
// variable a0, unique name 0:snoise9:10:a0, index 225, declared at line 74, column 6
// variable a1, unique name 0:snoise9:10:a1, index 226, declared at line 75, column 6
// variable p0, unique name 0:snoise9:10:p0, index 227, declared at line 76, column 6
// variable p1, unique name 0:snoise9:10:p1, index 228, declared at line 77, column 6
// variable p2, unique name 0:snoise9:10:p2, index 229, declared at line 78, column 6
// variable p3, unique name 0:snoise9:10:p3, index 230, declared at line 79, column 6
// variable norm, unique name 0:snoise9:10:norm, index 231, declared at line 81, column 6
// variable m, unique name 0:snoise9:10:m, index 232, declared at line 87, column 6
// references:
// vec2 at line 43, column 17
// vec4 at line 44, column 17
// floor at line 46, column 11
// v at line 46, column 17
// dot at line 46, column 21
// v at line 46, column 25
// C at line 46, column 28
// v at line 47, column 11
// i at line 47, column 15
// dot at line 47, column 19
// i at line 47, column 23
// C at line 47, column 26
// step at line 49, column 10
// x0 at line 49, column 15
// x0 at line 49, column 23
// g at line 50, column 16
// min at line 51, column 11
// g at line 51, column 15
// l at line 51, column 22
// max at line 52, column 11
// g at line 52, column 15
// l at line 52, column 22
// x0 at line 53, column 11
// i1 at line 53, column 16
// C at line 53, column 21
// x0 at line 54, column 11
// i2 at line 54, column 16
// C at line 54, column 21
// x0 at line 55, column 11
// D at line 55, column 16
// i at line 57, column 1
// mod289 at line 57, column 5
// i at line 57, column 12
// permute at line 58, column 10
// permute at line 58, column 19
// permute at line 58, column 28
// i at line 58, column 37
// vec4 at line 58, column 43
// i1 at line 58, column 53
// i2 at line 58, column 59
// i at line 58, column 73
// vec4 at line 58, column 79
// i1 at line 58, column 89
// i2 at line 58, column 95
// i at line 58, column 110
// vec4 at line 58, column 116
// i1 at line 58, column 126
// i2 at line 58, column 132
// n_ at line 62, column 12
// D at line 62, column 17
// D at line 62, column 25
// p at line 63, column 10
// floor at line 63, column 21
// p at line 63, column 27
// ns at line 63, column 31
// ns at line 63, column 38
// floor at line 64, column 11
// j at line 64, column 17
// ns at line 64, column 21
// floor at line 65, column 11
// j at line 65, column 17
// x_ at line 65, column 27
// x_ at line 66, column 10
// ns at line 66, column 14
// ns at line 66, column 21
// y_ at line 67, column 10
// ns at line 67, column 14
// ns at line 67, column 21
// abs at line 68, column 16
// x at line 68, column 20
// abs at line 68, column 25
// y at line 68, column 29
// vec4 at line 69, column 11
// x at line 69, column 16
// y at line 69, column 22
// vec4 at line 70, column 11
// x at line 70, column 16
// y at line 70, column 22
// floor at line 71, column 11
// b0 at line 71, column 17
// floor at line 72, column 11
// b1 at line 72, column 17
// step at line 73, column 12
// h at line 73, column 17
// vec4 at line 73, column 20
// b0 at line 74, column 11
// s0 at line 74, column 21
// sh at line 74, column 31
// b1 at line 75, column 11
// s1 at line 75, column 21
// sh at line 75, column 31
// vec3 at line 76, column 11
// a0 at line 76, column 16
// h at line 76, column 23
// vec3 at line 77, column 11
// a0 at line 77, column 16
// h at line 77, column 23
// vec3 at line 78, column 11
// a1 at line 78, column 16
// h at line 78, column 23
// vec3 at line 79, column 11
// a1 at line 79, column 16
// h at line 79, column 23
// taylorInvSqrt at line 81, column 13
// vec4 at line 81, column 27
// dot at line 81, column 32
// p0 at line 81, column 36
// p0 at line 81, column 39
// dot at line 81, column 44
// p1 at line 81, column 48
// p1 at line 81, column 51
// dot at line 81, column 56
// p2 at line 81, column 60
// p2 at line 81, column 64
// dot at line 81, column 69
// p3 at line 81, column 73
// p3 at line 81, column 76
// p0 at line 82, column 1
// norm at line 82, column 7
// p1 at line 83, column 1
// norm at line 83, column 7
// p2 at line 84, column 1
// norm at line 84, column 7
// p3 at line 85, column 1
// norm at line 85, column 7
// max at line 87, column 10
// vec4 at line 87, column 20
// dot at line 87, column 25
// x0 at line 87, column 29
// x0 at line 87, column 32
// dot at line 87, column 37
// x1 at line 87, column 41
// x1 at line 87, column 44
// dot at line 87, column 49
// x2 at line 87, column 53
// x2 at line 87, column 56
// dot at line 87, column 61
// x3 at line 87, column 65
// x3 at line 87, column 68
// m at line 88, column 1
// m at line 88, column 5
// m at line 88, column 9
// dot at line 89, column 15
// m at line 89, column 20
// m at line 89, column 22
// vec4 at line 89, column 25
// dot at line 89, column 31
// p0 at line 89, column 35
// x0 at line 89, column 38
// dot at line 89, column 43
// p1 at line 89, column 47
// x1 at line 89, column 50
// dot at line 89, column 55
// p2 at line 89, column 59
// x2 at line 89, column 62
// dot at line 89, column 67
// p3 at line 89, column 71
// x3 at line 89, column 74
// popping activation record 0:snoise9
// local variables: 
// variable v, unique name 0:snoise9:v, index 199, declared at line 41, column 18
// references:
// pushing activation record 0:Turbulence11
float Turbulence(vec3 position, float minFreq, float maxFreq, float qWidth)
{
// pushing activation record 0:Turbulence11:12
    float value = 0.0;
    float cutoff = clamp(0.5 / qWidth, 0.0, maxFreq);
    float fade;
    float fOut = minFreq;
    // pushing activation record 0:Turbulence11:12:for13
    for (int i = NoiseSteps; i >= 0; i--) {
    // pushing activation record 0:Turbulence11:12:for13:14
        if (fOut >= 0.5 * cutoff) break;
        fOut *= 2.0;
        value += abs(snoise(position * fOut)) / fOut;

    }
    // popping activation record 0:Turbulence11:12:for13:14
    // local variables: 
    // references:
    // fOut at line 100, column 5
    // cutoff at line 100, column 19
    // fOut at line 101, column 2
    // value at line 102, column 2
    // abs at line 102, column 11
    // snoise at line 102, column 15
    // position at line 102, column 22
    // fOut at line 102, column 33
    // fOut at line 102, column 40
    // popping activation record 0:Turbulence11:12:for13
    // local variables: 
    // variable i, unique name 0:Turbulence11:12:for13:i, index 242, declared at line 98, column 9
    // references:
    // NoiseSteps at line 98, column 11
    // i at line 98, column 24
    // i at line 98, column 31
    fade = clamp(2.0 * (cutoff - fOut) / cutoff, 0.0, 1.0);
    value += fade * abs(snoise(position * fOut)) / fOut;
    return 1.0 - value;

}
// popping activation record 0:Turbulence11:12
// local variables: 
// variable value, unique name 0:Turbulence11:12:value, index 238, declared at line 94, column 7
// variable cutoff, unique name 0:Turbulence11:12:cutoff, index 239, declared at line 95, column 7
// variable fade, unique name 0:Turbulence11:12:fade, index 240, declared at line 96, column 7
// variable fOut, unique name 0:Turbulence11:12:fOut, index 241, declared at line 97, column 7
// references:
// clamp at line 95, column 16
// qWidth at line 95, column 26
// maxFreq at line 95, column 39
// minFreq at line 97, column 14
// fade at line 104, column 1
// clamp at line 104, column 8
// cutoff at line 104, column 21
// fOut at line 104, column 28
// cutoff at line 104, column 34
// value at line 105, column 1
// fade at line 105, column 10
// abs at line 105, column 17
// snoise at line 105, column 21
// position at line 105, column 28
// fOut at line 105, column 39
// fOut at line 105, column 46
// value at line 106, column 12
// popping activation record 0:Turbulence11
// local variables: 
// variable position, unique name 0:Turbulence11:position, index 234, declared at line 92, column 22
// variable minFreq, unique name 0:Turbulence11:minFreq, index 235, declared at line 92, column 38
// variable maxFreq, unique name 0:Turbulence11:maxFreq, index 236, declared at line 92, column 53
// variable qWidth, unique name 0:Turbulence11:qWidth, index 237, declared at line 92, column 68
// references:
// pushing activation record 0:SphereDist15
float SphereDist(vec3 position)
{
// pushing activation record 0:SphereDist15:16
    return length(position - ExpPosition) - Radius;

}
// popping activation record 0:SphereDist15:16
// local variables: 
// references:
// length at line 111, column 8
// position at line 111, column 15
// ExpPosition at line 111, column 26
// Radius at line 111, column 41
// popping activation record 0:SphereDist15
// local variables: 
// variable position, unique name 0:SphereDist15:position, index 244, declared at line 109, column 22
// references:
// pushing activation record 0:Shade17
vec4 Shade(float distance)
{
// pushing activation record 0:Shade17:18
    float c1 = saturate(distance * 5.0 + 0.5);
    float c2 = saturate(distance * 5.0);
    float c3 = saturate(distance * 3.4 - 0.5);
    vec4 a = mix(Color1, Color2, c1);
    vec4 b = mix(a, Color3, c2);
    return mix(b, Color4, c3);

}
// popping activation record 0:Shade17:18
// local variables: 
// variable c1, unique name 0:Shade17:18:c1, index 247, declared at line 116, column 7
// variable c2, unique name 0:Shade17:18:c2, index 248, declared at line 117, column 7
// variable c3, unique name 0:Shade17:18:c3, index 249, declared at line 118, column 7
// variable a, unique name 0:Shade17:18:a, index 250, declared at line 119, column 6
// variable b, unique name 0:Shade17:18:b, index 251, declared at line 120, column 6
// references:
// saturate at line 116, column 12
// distance at line 116, column 21
// saturate at line 117, column 12
// distance at line 117, column 21
// saturate at line 118, column 12
// distance at line 118, column 21
// mix at line 119, column 10
// Color1 at line 119, column 14
// Color2 at line 119, column 21
// c1 at line 119, column 29
// mix at line 120, column 10
// a at line 120, column 14
// Color3 at line 120, column 21
// c2 at line 120, column 29
// mix at line 121, column 10
// b at line 121, column 14
// Color4 at line 121, column 21
// c3 at line 121, column 29
// popping activation record 0:Shade17
// local variables: 
// variable distance, unique name 0:Shade17:distance, index 246, declared at line 114, column 17
// references:
// pushing activation record 0:RenderScene19
float RenderScene(vec3 position, out float distance)
{
// pushing activation record 0:RenderScene19:20
    float noise = Turbulence(position * NoiseFrequency + Animation * iGlobalTime, 0.1, 1.5, 0.03) * NoiseAmplitude;
    noise = saturate(abs(noise));
    distance = SphereDist(position) - noise;
    return noise;

}
// popping activation record 0:RenderScene19:20
// local variables: 
// variable noise, unique name 0:RenderScene19:20:noise, index 255, declared at line 127, column 7
// references:
// Turbulence at line 127, column 15
// position at line 127, column 26
// NoiseFrequency at line 127, column 37
// Animation at line 127, column 54
// iGlobalTime at line 127, column 64
// NoiseAmplitude at line 127, column 95
// noise at line 128, column 1
// saturate at line 128, column 9
// abs at line 128, column 18
// noise at line 128, column 22
// distance at line 129, column 1
// SphereDist at line 129, column 12
// position at line 129, column 23
// noise at line 129, column 35
// noise at line 130, column 8
// popping activation record 0:RenderScene19
// local variables: 
// variable position, unique name 0:RenderScene19:position, index 253, declared at line 125, column 23
// variable distance, unique name 0:RenderScene19:distance, index 254, declared at line 125, column 43
// references:
// pushing activation record 0:March21
vec4 March(vec3 rayOrigin, vec3 rayStep)
{
// pushing activation record 0:March21:22
    vec3 position = rayOrigin;
    float distance;
    float displacement;
    // pushing activation record 0:March21:22:for23
    for (int step = MarchSteps; step >= 0; --step) {
    // pushing activation record 0:March21:22:for23:24
        displacement = RenderScene(position, distance);
        if (distance < 0.05) break;
        position += rayStep * distance;

    }
    // popping activation record 0:March21:22:for23:24
    // local variables: 
    // references:
    // displacement at line 141, column 2
    // RenderScene at line 141, column 17
    // position at line 141, column 29
    // distance at line 141, column 39
    // distance at line 142, column 5
    // position at line 143, column 2
    // rayStep at line 143, column 14
    // distance at line 143, column 24
    // popping activation record 0:March21:22:for23
    // local variables: 
    // variable step, unique name 0:March21:22:for23:step, index 262, declared at line 139, column 9
    // references:
    // MarchSteps at line 139, column 16
    // step at line 139, column 28
    // step at line 139, column 42
    return mix(Shade(displacement), Background, float(distance >= 0.5));

}
// popping activation record 0:March21:22
// local variables: 
// variable position, unique name 0:March21:22:position, index 259, declared at line 136, column 6
// variable distance, unique name 0:March21:22:distance, index 260, declared at line 137, column 7
// variable displacement, unique name 0:March21:22:displacement, index 261, declared at line 138, column 7
// references:
// rayOrigin at line 136, column 17
// mix at line 145, column 8
// Shade at line 145, column 12
// displacement at line 145, column 18
// Background at line 145, column 33
// float at line 145, column 45
// distance at line 145, column 51
// popping activation record 0:March21
// local variables: 
// variable rayOrigin, unique name 0:March21:rayOrigin, index 257, declared at line 134, column 16
// variable rayStep, unique name 0:March21:rayStep, index 258, declared at line 134, column 32
// references:
// pushing activation record 0:IntersectSphere25
bool IntersectSphere(vec3 ro, vec3 rd, vec3 pos, float radius, out vec3 intersectPoint)
{
// pushing activation record 0:IntersectSphere25:26
    vec3 relDistance = (ro - pos);
    float b = dot(relDistance, rd);
    float c = dot(relDistance, relDistance) - radius * radius;
    float d = b * b - c;
    intersectPoint = ro + rd * (-b - sqrt(d));
    return d >= 0.0;

}
// popping activation record 0:IntersectSphere25:26
// local variables: 
// variable relDistance, unique name 0:IntersectSphere25:26:relDistance, index 269, declared at line 150, column 6
// variable b, unique name 0:IntersectSphere25:26:b, index 270, declared at line 151, column 7
// variable c, unique name 0:IntersectSphere25:26:c, index 271, declared at line 152, column 7
// variable d, unique name 0:IntersectSphere25:26:d, index 272, declared at line 153, column 7
// references:
// ro at line 150, column 21
// pos at line 150, column 26
// dot at line 151, column 11
// relDistance at line 151, column 15
// rd at line 151, column 28
// dot at line 152, column 11
// relDistance at line 152, column 15
// relDistance at line 152, column 28
// radius at line 152, column 43
// radius at line 152, column 50
// b at line 153, column 11
// b at line 153, column 13
// c at line 153, column 17
// intersectPoint at line 154, column 1
// ro at line 154, column 18
// rd at line 154, column 23
// b at line 154, column 28
// sqrt at line 154, column 32
// d at line 154, column 37
// d at line 155, column 8
// popping activation record 0:IntersectSphere25
// local variables: 
// variable ro, unique name 0:IntersectSphere25:ro, index 264, declared at line 148, column 26
// variable rd, unique name 0:IntersectSphere25:rd, index 265, declared at line 148, column 35
// variable pos, unique name 0:IntersectSphere25:pos, index 266, declared at line 148, column 44
// variable radius, unique name 0:IntersectSphere25:radius, index 267, declared at line 148, column 55
// variable intersectPoint, unique name 0:IntersectSphere25:intersectPoint, index 268, declared at line 148, column 72
// references:
// pushing activation record 0:mainImage27
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage27:28
    vec2 p = (gl_FragCoord.xy / iResolution.xy) * 2.0 - 1.0;
    p.x *= iResolution.x / iResolution.y;
    float rotx = iMouse.y * 0.01;
    float roty = -iMouse.x * 0.01;
    float zoom = 5.0;
    vec3 ro = zoom * normalize(vec3(cos(roty), cos(rotx), sin(roty)));
    vec3 ww = normalize(vec3(0.0, 0.0, 0.0) - ro);
    vec3 uu = normalize(cross(vec3(0.0, 1.0, 0.0), ww));
    vec3 vv = normalize(cross(ww, uu));
    vec3 rd = normalize(p.x * uu + p.y * vv + 1.5 * ww);
    vec4 col = Background;
    vec3 origin;
    if (IntersectSphere(ro, rd, ExpPosition, Radius + NoiseAmplitude * 6.0, origin)) {
    // pushing activation record 0:mainImage27:28:29
        col = March(origin, rd);

    }
    // popping activation record 0:mainImage27:28:29
    // local variables: 
    // references:
    // col at line 175, column 2
    // March at line 175, column 8
    // origin at line 175, column 14
    // rd at line 175, column 22
    fragColor = col;

}
// popping activation record 0:mainImage27:28
// local variables: 
// variable p, unique name 0:mainImage27:28:p, index 276, declared at line 160, column 6
// variable rotx, unique name 0:mainImage27:28:rotx, index 277, declared at line 162, column 7
// variable roty, unique name 0:mainImage27:28:roty, index 278, declared at line 163, column 7
// variable zoom, unique name 0:mainImage27:28:zoom, index 279, declared at line 164, column 7
// variable ro, unique name 0:mainImage27:28:ro, index 280, declared at line 166, column 6
// variable ww, unique name 0:mainImage27:28:ww, index 281, declared at line 167, column 6
// variable uu, unique name 0:mainImage27:28:uu, index 282, declared at line 168, column 6
// variable vv, unique name 0:mainImage27:28:vv, index 283, declared at line 169, column 6
// variable rd, unique name 0:mainImage27:28:rd, index 284, declared at line 170, column 6
// variable col, unique name 0:mainImage27:28:col, index 285, declared at line 171, column 6
// variable origin, unique name 0:mainImage27:28:origin, index 286, declared at line 172, column 6
// references:
// gl_FragCoord at line 160, column 11
// iResolution at line 160, column 29
// p at line 161, column 1
// iResolution at line 161, column 8
// iResolution at line 161, column 22
// iMouse at line 162, column 14
// iMouse at line 163, column 15
// zoom at line 166, column 11
// normalize at line 166, column 18
// vec3 at line 166, column 28
// cos at line 166, column 33
// roty at line 166, column 37
// cos at line 166, column 44
// rotx at line 166, column 48
// sin at line 166, column 55
// roty at line 166, column 59
// normalize at line 167, column 11
// vec3 at line 167, column 21
// ro at line 167, column 43
// normalize at line 168, column 11
// cross at line 168, column 21
// vec3 at line 168, column 28
// ww at line 168, column 49
// normalize at line 169, column 11
// cross at line 169, column 21
// ww at line 169, column 27
// uu at line 169, column 31
// normalize at line 170, column 11
// p at line 170, column 21
// uu at line 170, column 25
// p at line 170, column 30
// vv at line 170, column 34
// ww at line 170, column 43
// Background at line 171, column 12
// IntersectSphere at line 173, column 4
// ro at line 173, column 20
// rd at line 173, column 24
// ExpPosition at line 173, column 28
// Radius at line 173, column 41
// NoiseAmplitude at line 173, column 50
// origin at line 173, column 70
// fragColor at line 177, column 1
// col at line 177, column 13
// popping activation record 0:mainImage27
// local variables: 
// variable fragColor, unique name 0:mainImage27:fragColor, index 274, declared at line 158, column 25
// variable fragCoord, unique name 0:mainImage27:fragCoord, index 275, declared at line 158, column 44
// references:
// undefined variables 
