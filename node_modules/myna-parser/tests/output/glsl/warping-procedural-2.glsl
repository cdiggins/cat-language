// pushing activation record 0
const mat2 m = mat2(0.80, 0.60, -0.60, 0.80);
// pushing activation record 0:noise1
float noise(in vec2 x)
{
// pushing activation record 0:noise1:2
    return sin(1.5 * x.x) * sin(1.5 * x.y);

}
// popping activation record 0:noise1:2
// local variables: 
// references:
// sin at line 11, column 8
// x at line 11, column 16
// sin at line 11, column 21
// x at line 11, column 29
// popping activation record 0:noise1
// local variables: 
// variable x, unique name 0:noise1:x, index 180, declared at line 9, column 21
// references:
// pushing activation record 0:fbm43
float fbm4(vec2 p)
{
// pushing activation record 0:fbm43:4
    float f = 0.0;
    f += 0.5000 * noise(p);
    p = m * p * 2.02;
    f += 0.2500 * noise(p);
    p = m * p * 2.03;
    f += 0.1250 * noise(p);
    p = m * p * 2.01;
    f += 0.0625 * noise(p);
    return f / 0.9375;

}
// popping activation record 0:fbm43:4
// local variables: 
// variable f, unique name 0:fbm43:4:f, index 183, declared at line 16, column 10
// references:
// f at line 17, column 4
// noise at line 17, column 16
// p at line 17, column 23
// p at line 17, column 28
// m at line 17, column 32
// p at line 17, column 34
// f at line 18, column 4
// noise at line 18, column 16
// p at line 18, column 23
// p at line 18, column 28
// m at line 18, column 32
// p at line 18, column 34
// f at line 19, column 4
// noise at line 19, column 16
// p at line 19, column 23
// p at line 19, column 28
// m at line 19, column 32
// p at line 19, column 34
// f at line 20, column 4
// noise at line 20, column 16
// p at line 20, column 23
// f at line 21, column 11
// popping activation record 0:fbm43
// local variables: 
// variable p, unique name 0:fbm43:p, index 182, declared at line 14, column 17
// references:
// pushing activation record 0:fbm65
float fbm6(vec2 p)
{
// pushing activation record 0:fbm65:6
    float f = 0.0;
    f += 0.500000 * (0.5 + 0.5 * noise(p));
    p = m * p * 2.02;
    f += 0.250000 * (0.5 + 0.5 * noise(p));
    p = m * p * 2.03;
    f += 0.125000 * (0.5 + 0.5 * noise(p));
    p = m * p * 2.01;
    f += 0.062500 * (0.5 + 0.5 * noise(p));
    p = m * p * 2.04;
    f += 0.031250 * (0.5 + 0.5 * noise(p));
    p = m * p * 2.01;
    f += 0.015625 * (0.5 + 0.5 * noise(p));
    return f / 0.96875;

}
// popping activation record 0:fbm65:6
// local variables: 
// variable f, unique name 0:fbm65:6:f, index 186, declared at line 26, column 10
// references:
// f at line 27, column 4
// noise at line 27, column 27
// p at line 27, column 34
// p at line 27, column 40
// m at line 27, column 44
// p at line 27, column 46
// f at line 28, column 4
// noise at line 28, column 27
// p at line 28, column 34
// p at line 28, column 40
// m at line 28, column 44
// p at line 28, column 46
// f at line 29, column 4
// noise at line 29, column 27
// p at line 29, column 34
// p at line 29, column 40
// m at line 29, column 44
// p at line 29, column 46
// f at line 30, column 4
// noise at line 30, column 27
// p at line 30, column 34
// p at line 30, column 40
// m at line 30, column 44
// p at line 30, column 46
// f at line 31, column 4
// noise at line 31, column 27
// p at line 31, column 34
// p at line 31, column 40
// m at line 31, column 44
// p at line 31, column 46
// f at line 32, column 4
// noise at line 32, column 27
// p at line 32, column 34
// f at line 33, column 11
// popping activation record 0:fbm65
// local variables: 
// variable p, unique name 0:fbm65:p, index 185, declared at line 24, column 17
// references:
// pushing activation record 0:func7
float func(vec2 q, out vec4 ron)
{
// pushing activation record 0:func7:8
    float ql = length(q);
    q.x += 0.05 * sin(0.27 * iGlobalTime + ql * 4.1);
    q.y += 0.05 * sin(0.23 * iGlobalTime + ql * 4.3);
    q *= 0.5;
    vec2 o = vec2(0.0);
    o.x = 0.5 + 0.5 * fbm4(vec2(2.0 * q));
    o.y = 0.5 + 0.5 * fbm4(vec2(2.0 * q + vec2(5.2)));
    float ol = length(o);
    o.x += 0.02 * sin(0.12 * iGlobalTime + ol) / ol;
    o.y += 0.02 * sin(0.14 * iGlobalTime + ol) / ol;
    vec2 n;
    n.x = fbm6(vec2(4.0 * o + vec2(9.2)));
    n.y = fbm6(vec2(4.0 * o + vec2(5.7)));
    vec2 p = 4.0 * q + 4.0 * n;
    float f = 0.5 + 0.5 * fbm4(p);
    f = mix(f, f * f * f * 3.5, f * abs(n.x));
    float g = 0.5 + 0.5 * sin(4.0 * p.x) * sin(4.0 * p.y);
    f *= 1.0 - 0.5 * pow(g, 8.0);
    ron = vec4(o, n);
    return f;

}
// popping activation record 0:func7:8
// local variables: 
// variable ql, unique name 0:func7:8:ql, index 190, declared at line 39, column 10
// variable o, unique name 0:func7:8:o, index 191, declared at line 44, column 6
// variable ol, unique name 0:func7:8:ol, index 192, declared at line 48, column 7
// variable n, unique name 0:func7:8:n, index 193, declared at line 52, column 9
// variable p, unique name 0:func7:8:p, index 194, declared at line 56, column 9
// variable f, unique name 0:func7:8:f, index 195, declared at line 58, column 10
// variable g, unique name 0:func7:8:g, index 196, declared at line 62, column 10
// references:
// length at line 39, column 15
// q at line 39, column 23
// q at line 40, column 4
// sin at line 40, column 16
// iGlobalTime at line 40, column 25
// ql at line 40, column 37
// q at line 41, column 4
// sin at line 41, column 16
// iGlobalTime at line 41, column 25
// ql at line 41, column 37
// q at line 42, column 4
// vec2 at line 44, column 10
// o at line 45, column 4
// fbm4 at line 45, column 20
// vec2 at line 45, column 26
// q at line 45, column 35
// o at line 46, column 4
// fbm4 at line 46, column 20
// vec2 at line 46, column 26
// q at line 46, column 35
// vec2 at line 46, column 37
// length at line 48, column 12
// o at line 48, column 20
// o at line 49, column 4
// sin at line 49, column 16
// iGlobalTime at line 49, column 25
// ol at line 49, column 37
// ol at line 49, column 41
// o at line 50, column 4
// sin at line 50, column 16
// iGlobalTime at line 50, column 25
// ol at line 50, column 37
// ol at line 50, column 41
// n at line 53, column 4
// fbm6 at line 53, column 10
// vec2 at line 53, column 16
// o at line 53, column 25
// vec2 at line 53, column 27
// n at line 54, column 4
// fbm6 at line 54, column 10
// vec2 at line 54, column 16
// o at line 54, column 25
// vec2 at line 54, column 27
// q at line 56, column 17
// n at line 56, column 25
// fbm4 at line 58, column 24
// p at line 58, column 30
// f at line 60, column 4
// mix at line 60, column 8
// f at line 60, column 13
// f at line 60, column 16
// f at line 60, column 18
// f at line 60, column 20
// f at line 60, column 27
// abs at line 60, column 29
// n at line 60, column 33
// sin at line 62, column 24
// p at line 62, column 32
// sin at line 62, column 37
// p at line 62, column 45
// f at line 63, column 4
// pow at line 63, column 17
// g at line 63, column 22
// ron at line 65, column 1
// vec4 at line 65, column 7
// o at line 65, column 13
// n at line 65, column 16
// f at line 67, column 11
// popping activation record 0:func7
// local variables: 
// variable q, unique name 0:func7:q, index 188, declared at line 37, column 17
// variable ron, unique name 0:func7:ron, index 189, declared at line 37, column 29
// references:
// pushing activation record 0:doMagic9
vec3 doMagic(vec2 p)
{
// pushing activation record 0:doMagic9:10
    vec2 q = p * 0.6;
    vec4 on = vec4(0.0);
    float f = func(q, on);
    vec3 col = vec3(0.0);
    col = mix(vec3(0.2, 0.1, 0.4), vec3(0.3, 0.05, 0.05), f);
    col = mix(col, vec3(0.9, 0.9, 0.9), dot(on.zw, on.zw));
    col = mix(col, vec3(0.4, 0.3, 0.3), 0.5 * on.y * on.y);
    col = mix(col, vec3(0.0, 0.2, 0.4), 0.5 * smoothstep(1.2, 1.3, abs(on.z) + abs(on.w)));
    col = clamp(col * f * 2.0, 0.0, 1.0);
    vec3 nor = normalize(vec3(dFdx(f) * iResolution.x, 6.0, dFdy(f) * iResolution.y));
    vec3 lig = normalize(vec3(0.9, -0.2, -0.4));
    float dif = clamp(0.3 + 0.7 * dot(nor, lig), 0.0, 1.0);
    vec3 bdrf;
    bdrf = vec3(0.70, 0.90, 0.95) * (nor.y * 0.5 + 0.5);
    bdrf += vec3(0.15, 0.10, 0.05) * dif;
    col *= 1.2 * bdrf;
    col = 1.0 - col;
    return 1.1 * col * col;

}
// popping activation record 0:doMagic9:10
// local variables: 
// variable q, unique name 0:doMagic9:10:q, index 199, declared at line 74, column 6
// variable on, unique name 0:doMagic9:10:on, index 200, declared at line 76, column 9
// variable f, unique name 0:doMagic9:10:f, index 201, declared at line 77, column 10
// variable col, unique name 0:doMagic9:10:col, index 202, declared at line 79, column 6
// variable nor, unique name 0:doMagic9:10:nor, index 203, declared at line 86, column 6
// variable lig, unique name 0:doMagic9:10:lig, index 204, declared at line 88, column 9
// variable dif, unique name 0:doMagic9:10:dif, index 205, declared at line 89, column 10
// variable bdrf, unique name 0:doMagic9:10:bdrf, index 206, declared at line 90, column 9
// references:
// p at line 74, column 10
// vec4 at line 76, column 14
// func at line 77, column 14
// q at line 77, column 19
// on at line 77, column 22
// vec3 at line 79, column 12
// col at line 80, column 4
// mix at line 80, column 10
// vec3 at line 80, column 15
// vec3 at line 80, column 34
// f at line 80, column 55
// col at line 81, column 4
// mix at line 81, column 10
// col at line 81, column 15
// vec3 at line 81, column 20
// dot at line 81, column 39
// on at line 81, column 43
// on at line 81, column 49
// col at line 82, column 4
// mix at line 82, column 10
// col at line 82, column 15
// vec3 at line 82, column 20
// on at line 82, column 43
// on at line 82, column 48
// col at line 83, column 4
// mix at line 83, column 10
// col at line 83, column 15
// vec3 at line 83, column 20
// smoothstep at line 83, column 43
// abs at line 83, column 62
// on at line 83, column 66
// abs at line 83, column 72
// on at line 83, column 76
// col at line 84, column 4
// clamp at line 84, column 10
// col at line 84, column 17
// f at line 84, column 21
// normalize at line 86, column 12
// vec3 at line 86, column 23
// dFdx at line 86, column 29
// f at line 86, column 34
// iResolution at line 86, column 37
// dFdy at line 86, column 57
// f at line 86, column 62
// iResolution at line 86, column 65
// normalize at line 88, column 15
// vec3 at line 88, column 26
// clamp at line 89, column 16
// dot at line 89, column 31
// nor at line 89, column 36
// lig at line 89, column 41
// bdrf at line 91, column 4
// vec3 at line 91, column 12
// nor at line 91, column 34
// bdrf at line 92, column 4
// vec3 at line 92, column 12
// dif at line 92, column 33
// col at line 93, column 4
// bdrf at line 93, column 15
// col at line 94, column 1
// col at line 94, column 11
// col at line 95, column 12
// col at line 95, column 16
// popping activation record 0:doMagic9
// local variables: 
// variable p, unique name 0:doMagic9:p, index 198, declared at line 72, column 18
// references:
// pushing activation record 0:mainImage11
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage11:12
    vec2 q = fragCoord.xy / iResolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= iResolution.x / iResolution.y;
    fragColor = vec4(doMagic(p), 1.0);

}
// popping activation record 0:mainImage11:12
// local variables: 
// variable q, unique name 0:mainImage11:12:q, index 210, declared at line 99, column 9
// variable p, unique name 0:mainImage11:12:p, index 211, declared at line 100, column 9
// references:
// fragCoord at line 99, column 13
// iResolution at line 99, column 28
// q at line 100, column 26
// p at line 101, column 4
// iResolution at line 101, column 11
// iResolution at line 101, column 25
// fragColor at line 103, column 4
// vec4 at line 103, column 16
// doMagic at line 103, column 22
// p at line 103, column 31
// popping activation record 0:mainImage11
// local variables: 
// variable fragColor, unique name 0:mainImage11:fragColor, index 208, declared at line 97, column 25
// variable fragCoord, unique name 0:mainImage11:fragCoord, index 209, declared at line 97, column 44
// references:
// undefined variables 
