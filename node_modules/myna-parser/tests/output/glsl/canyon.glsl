// pushing activation record 0
#define LOWDETAIL 

// pushing activation record 0:noise11
float noise1(in vec3 x)
{
// pushing activation record 0:noise11:2
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    #ifndef HIGH_QUALITY_NOISE
	
vec2 uv = (p.xy + vec2(37.0, 17.0) * p.z) + f.xy;
    vec2 rg = textureLod(iChannel2, (uv + 0.5) / 256.0, 0.0).yx;
    #else
	
vec2 uv = (p.xy + vec2(37.0, 17.0) * p.z);
    vec2 rg1 = textureLod(iChannel2, (uv + vec2(0.5, 0.5)) / 256.0, 0.0).yx;
    vec2 rg2 = textureLod(iChannel2, (uv + vec2(1.5, 0.5)) / 256.0, 0.0).yx;
    vec2 rg3 = textureLod(iChannel2, (uv + vec2(0.5, 1.5)) / 256.0, 0.0).yx;
    vec2 rg4 = textureLod(iChannel2, (uv + vec2(1.5, 1.5)) / 256.0, 0.0).yx;
    vec2 rg = mix(mix(rg1, rg2, f.x), mix(rg3, rg4, f.x), f.y);
    #endif	
	
return mix(rg.x, rg.y, f.z);

}
// popping activation record 0:noise11:2
// local variables: 
// variable p, unique name 0:noise11:2:p, index 180, declared at line 12, column 9
// variable f, unique name 0:noise11:2:f, index 181, declared at line 13, column 9
// variable uv, unique name 0:noise11:2:uv, index 182, declared at line 16, column 6
// variable rg, unique name 0:noise11:2:rg, index 183, declared at line 17, column 6
// variable uv, unique name 0:noise11:2:uv, index 184, declared at line 19, column 6
// variable rg1, unique name 0:noise11:2:rg1, index 184, declared at line 20, column 6
// variable rg2, unique name 0:noise11:2:rg2, index 185, declared at line 21, column 6
// variable rg3, unique name 0:noise11:2:rg3, index 186, declared at line 22, column 6
// variable rg4, unique name 0:noise11:2:rg4, index 187, declared at line 23, column 6
// variable rg, unique name 0:noise11:2:rg, index 188, declared at line 24, column 6
// references:
// floor at line 12, column 13
// x at line 12, column 19
// fract at line 13, column 13
// x at line 13, column 19
// f at line 14, column 1
// f at line 14, column 5
// f at line 14, column 7
// f at line 14, column 18
// p at line 16, column 12
// vec2 at line 16, column 17
// p at line 16, column 33
// f at line 16, column 40
// textureLod at line 17, column 11
// iChannel2 at line 17, column 23
// uv at line 17, column 35
// p at line 19, column 12
// vec2 at line 19, column 17
// p at line 19, column 33
// textureLod at line 20, column 12
// iChannel2 at line 20, column 24
// uv at line 20, column 36
// vec2 at line 20, column 40
// textureLod at line 21, column 12
// iChannel2 at line 21, column 24
// uv at line 21, column 36
// vec2 at line 21, column 40
// textureLod at line 22, column 12
// iChannel2 at line 22, column 24
// uv at line 22, column 36
// vec2 at line 22, column 40
// textureLod at line 23, column 12
// iChannel2 at line 23, column 24
// uv at line 23, column 36
// vec2 at line 23, column 40
// mix at line 24, column 11
// mix at line 24, column 16
// rg1 at line 24, column 20
// rg2 at line 24, column 24
// f at line 24, column 28
// mix at line 24, column 34
// rg3 at line 24, column 38
// rg4 at line 24, column 42
// f at line 24, column 46
// f at line 24, column 52
// mix at line 26, column 8
// rg at line 26, column 13
// rg at line 26, column 19
// f at line 26, column 25
// popping activation record 0:noise11
// local variables: 
// variable x, unique name 0:noise11:x, index 179, declared at line 10, column 22
// references:
const mat3 m = mat3(0.00, 0.80, 0.60, -0.80, 0.36, -0.48, -0.60, -0.48, 0.64);
// pushing activation record 0:displacement3
float displacement(vec3 p)
{
// pushing activation record 0:displacement3:4
    float f;
    f = 0.5000 * noise1(p);
    p = m * p * 2.02;
    f += 0.2500 * noise1(p);
    p = m * p * 2.03;
    f += 0.1250 * noise1(p);
    p = m * p * 2.01;
    #ifndef LOWDETAIL
    
f += 0.0625 * noise1(p);
    #endif
    
return f;

}
// popping activation record 0:displacement3:4
// local variables: 
// variable f, unique name 0:displacement3:4:f, index 191, declared at line 36, column 10
// references:
// f at line 37, column 4
// noise1 at line 37, column 16
// p at line 37, column 24
// p at line 37, column 29
// m at line 37, column 33
// p at line 37, column 35
// f at line 38, column 4
// noise1 at line 38, column 16
// p at line 38, column 24
// p at line 38, column 29
// m at line 38, column 33
// p at line 38, column 35
// f at line 39, column 4
// noise1 at line 39, column 16
// p at line 39, column 24
// p at line 39, column 29
// m at line 39, column 33
// p at line 39, column 35
// f at line 41, column 4
// noise1 at line 41, column 16
// p at line 41, column 24
// f at line 43, column 11
// popping activation record 0:displacement3
// local variables: 
// variable p, unique name 0:displacement3:p, index 190, declared at line 34, column 25
// references:
// pushing activation record 0:texcube5
vec4 texcube(sampler2D sam, in vec3 p, in vec3 n)
{
// pushing activation record 0:texcube5:6
    vec4 x = texture(sam, p.yz);
    vec4 y = texture(sam, p.zx);
    vec4 z = texture(sam, p.xy);
    return (x * abs(n.x) + y * abs(n.y) + z * abs(n.z)) / (abs(n.x) + abs(n.y) + abs(n.z));

}
// popping activation record 0:texcube5:6
// local variables: 
// variable x, unique name 0:texcube5:6:x, index 196, declared at line 48, column 6
// variable y, unique name 0:texcube5:6:y, index 197, declared at line 49, column 6
// variable z, unique name 0:texcube5:6:z, index 198, declared at line 50, column 6
// references:
// texture at line 48, column 10
// sam at line 48, column 19
// p at line 48, column 24
// texture at line 49, column 10
// sam at line 49, column 19
// p at line 49, column 24
// texture at line 50, column 10
// sam at line 50, column 19
// p at line 50, column 24
// x at line 51, column 9
// abs at line 51, column 11
// n at line 51, column 15
// y at line 51, column 22
// abs at line 51, column 24
// n at line 51, column 28
// z at line 51, column 35
// abs at line 51, column 37
// n at line 51, column 41
// abs at line 51, column 48
// n at line 51, column 52
// abs at line 51, column 57
// n at line 51, column 61
// abs at line 51, column 66
// n at line 51, column 70
// popping activation record 0:texcube5
// local variables: 
// variable sam, unique name 0:texcube5:sam, index 193, declared at line 46, column 24
// variable p, unique name 0:texcube5:p, index 194, declared at line 46, column 37
// variable n, unique name 0:texcube5:n, index 195, declared at line 46, column 48
// references:
// pushing activation record 0:textureGood7
vec4 textureGood(sampler2D sam, vec2 uv, float lo)
{
// pushing activation record 0:textureGood7:8
    uv = uv * 1024.0 - 0.5;
    vec2 iuv = floor(uv);
    vec2 f = fract(uv);
    vec4 rg1 = textureLod(sam, (iuv + vec2(0.5, 0.5)) / 1024.0, lo);
    vec4 rg2 = textureLod(sam, (iuv + vec2(1.5, 0.5)) / 1024.0, lo);
    vec4 rg3 = textureLod(sam, (iuv + vec2(0.5, 1.5)) / 1024.0, lo);
    vec4 rg4 = textureLod(sam, (iuv + vec2(1.5, 1.5)) / 1024.0, lo);
    return mix(mix(rg1, rg2, f.x), mix(rg3, rg4, f.x), f.y);

}
// popping activation record 0:textureGood7:8
// local variables: 
// variable iuv, unique name 0:textureGood7:8:iuv, index 203, declared at line 58, column 9
// variable f, unique name 0:textureGood7:8:f, index 204, declared at line 59, column 9
// variable rg1, unique name 0:textureGood7:8:rg1, index 205, declared at line 60, column 6
// variable rg2, unique name 0:textureGood7:8:rg2, index 206, declared at line 61, column 6
// variable rg3, unique name 0:textureGood7:8:rg3, index 207, declared at line 62, column 6
// variable rg4, unique name 0:textureGood7:8:rg4, index 208, declared at line 63, column 6
// references:
// uv at line 57, column 4
// uv at line 57, column 9
// floor at line 58, column 15
// uv at line 58, column 21
// fract at line 59, column 13
// uv at line 59, column 19
// textureLod at line 60, column 12
// sam at line 60, column 24
// iuv at line 60, column 30
// vec2 at line 60, column 35
// lo at line 60, column 58
// textureLod at line 61, column 12
// sam at line 61, column 24
// iuv at line 61, column 30
// vec2 at line 61, column 35
// lo at line 61, column 58
// textureLod at line 62, column 12
// sam at line 62, column 24
// iuv at line 62, column 30
// vec2 at line 62, column 35
// lo at line 62, column 58
// textureLod at line 63, column 12
// sam at line 63, column 24
// iuv at line 63, column 30
// vec2 at line 63, column 35
// lo at line 63, column 58
// mix at line 64, column 8
// mix at line 64, column 13
// rg1 at line 64, column 17
// rg2 at line 64, column 21
// f at line 64, column 25
// mix at line 64, column 31
// rg3 at line 64, column 35
// rg4 at line 64, column 39
// f at line 64, column 43
// f at line 64, column 49
// popping activation record 0:textureGood7
// local variables: 
// variable sam, unique name 0:textureGood7:sam, index 200, declared at line 55, column 28
// variable uv, unique name 0:textureGood7:uv, index 201, declared at line 55, column 38
// variable lo, unique name 0:textureGood7:lo, index 202, declared at line 55, column 48
// references:
// pushing activation record 0:terrain9
float terrain(in vec2 q)
{
// pushing activation record 0:terrain9:10
    float th = smoothstep(0.0, 0.7, textureLod(iChannel0, 0.001 * q, 0.0).x);
    float rr = smoothstep(0.1, 0.5, textureLod(iChannel1, 2.0 * 0.03 * q, 0.0).y);
    float h = 1.9;
    #ifndef LOWDETAIL
	
h += -0.15 + (1.0 - 0.6 * rr) * (1.5 - 1.0 * th) * 0.3 * (1.0 - textureLod(iChannel0, 0.04 * q * vec2(1.2, 0.5), 0.0).x);
    #endif
	
h += th * 7.0;
    h += 0.3 * rr;
    return -h;

}
// popping activation record 0:terrain9:10
// local variables: 
// variable th, unique name 0:terrain9:10:th, index 211, declared at line 70, column 7
// variable rr, unique name 0:terrain9:10:rr, index 212, declared at line 71, column 10
// variable h, unique name 0:terrain9:10:h, index 213, declared at line 72, column 7
// references:
// smoothstep at line 70, column 12
// textureLod at line 70, column 34
// iChannel0 at line 70, column 46
// q at line 70, column 63
// smoothstep at line 71, column 15
// textureLod at line 71, column 37
// iChannel1 at line 71, column 49
// q at line 71, column 69
// h at line 74, column 1
// rr at line 74, column 23
// th at line 74, column 36
// textureLod at line 74, column 51
// iChannel0 at line 74, column 63
// q at line 74, column 79
// vec2 at line 74, column 81
// h at line 76, column 1
// th at line 76, column 6
// h at line 77, column 4
// rr at line 77, column 13
// h at line 78, column 12
// popping activation record 0:terrain9
// local variables: 
// variable q, unique name 0:terrain9:q, index 210, declared at line 68, column 23
// references:
// pushing activation record 0:terrain211
float terrain2(in vec2 q)
{
// pushing activation record 0:terrain211:12
    float th = smoothstep(0.0, 0.7, textureGood(iChannel0, 0.001 * q, 0.0).x);
    float rr = smoothstep(0.1, 0.5, textureGood(iChannel1, 2.0 * 0.03 * q, 0.0).y);
    float h = 1.9;
    h += th * 7.0;
    return -h;

}
// popping activation record 0:terrain211:12
// local variables: 
// variable th, unique name 0:terrain211:12:th, index 216, declared at line 83, column 7
// variable rr, unique name 0:terrain211:12:rr, index 217, declared at line 84, column 10
// variable h, unique name 0:terrain211:12:h, index 218, declared at line 85, column 7
// references:
// smoothstep at line 83, column 12
// textureGood at line 83, column 34
// iChannel0 at line 83, column 47
// q at line 83, column 64
// smoothstep at line 84, column 15
// textureGood at line 84, column 37
// iChannel1 at line 84, column 50
// q at line 84, column 70
// h at line 86, column 1
// th at line 86, column 6
// h at line 87, column 12
// popping activation record 0:terrain211
// local variables: 
// variable q, unique name 0:terrain211:q, index 215, declared at line 81, column 24
// references:
// pushing activation record 0:map13
vec4 map(in vec3 p)
{
// pushing activation record 0:map13:14
    float h = terrain(p.xz);
    float dis = displacement(0.25 * p * vec3(1.0, 4.0, 1.0));
    dis *= 3.0;
    return vec4((dis + p.y - h) * 0.25, p.x, h, 0.0);

}
// popping activation record 0:map13:14
// local variables: 
// variable h, unique name 0:map13:14:h, index 221, declared at line 93, column 7
// variable dis, unique name 0:map13:14:dis, index 222, declared at line 94, column 7
// references:
// terrain at line 93, column 11
// p at line 93, column 20
// displacement at line 94, column 13
// p at line 94, column 32
// vec3 at line 94, column 34
// dis at line 95, column 1
// vec4 at line 96, column 8
// dis at line 96, column 15
// p at line 96, column 21
// h at line 96, column 25
// p at line 96, column 34
// h at line 96, column 39
// popping activation record 0:map13
// local variables: 
// variable p, unique name 0:map13:p, index 220, declared at line 91, column 18
// references:
// pushing activation record 0:intersect15
vec4 intersect(in vec3 ro, in vec3 rd, in float tmax)
{
// pushing activation record 0:intersect15:16
    float t = 0.1;
    vec3 res = vec3(0.0);
    // pushing activation record 0:intersect15:16:for17
    for (int i = 0; i < 256; i++) {
    // pushing activation record 0:intersect15:16:for17:18
        vec4 tmp = map(ro + rd * t);
        res = tmp.ywz;
        t += tmp.x;
        if (tmp.x < (0.001 * t) || t > tmax) break;

    }
    // popping activation record 0:intersect15:16:for17:18
    // local variables: 
    // variable tmp, unique name 0:intersect15:16:for17:18:tmp, index 230, declared at line 105, column 10
    // references:
    // map at line 105, column 16
    // ro at line 105, column 21
    // rd at line 105, column 24
    // t at line 105, column 27
    // res at line 106, column 8
    // tmp at line 106, column 14
    // t at line 107, column 8
    // tmp at line 107, column 13
    // tmp at line 108, column 12
    // t at line 108, column 25
    // t at line 108, column 31
    // tmax at line 108, column 33
    // popping activation record 0:intersect15:16:for17
    // local variables: 
    // variable i, unique name 0:intersect15:16:for17:i, index 229, declared at line 103, column 13
    // references:
    // i at line 103, column 18
    // i at line 103, column 25
    return vec4(t, res);

}
// popping activation record 0:intersect15:16
// local variables: 
// variable t, unique name 0:intersect15:16:t, index 227, declared at line 101, column 10
// variable res, unique name 0:intersect15:16:res, index 228, declared at line 102, column 9
// references:
// vec3 at line 102, column 15
// vec4 at line 111, column 11
// t at line 111, column 17
// res at line 111, column 20
// popping activation record 0:intersect15
// local variables: 
// variable ro, unique name 0:intersect15:ro, index 224, declared at line 99, column 24
// variable rd, unique name 0:intersect15:rd, index 225, declared at line 99, column 36
// variable tmax, unique name 0:intersect15:tmax, index 226, declared at line 99, column 49
// references:
// pushing activation record 0:calcNormal19
vec3 calcNormal(in vec3 pos, in float t)
{
// pushing activation record 0:calcNormal19:20
    vec2 eps = vec2(0.005 * t, 0.0);
    return normalize(vec3(map(pos + eps.xyy).x - map(pos - eps.xyy).x, map(pos + eps.yxy).x - map(pos - eps.yxy).x, map(pos + eps.yyx).x - map(pos - eps.yyx).x));

}
// popping activation record 0:calcNormal19:20
// local variables: 
// variable eps, unique name 0:calcNormal19:20:eps, index 234, declared at line 116, column 9
// references:
// vec2 at line 116, column 15
// t at line 116, column 27
// normalize at line 117, column 8
// vec3 at line 117, column 19
// map at line 118, column 11
// pos at line 118, column 15
// eps at line 118, column 19
// map at line 118, column 32
// pos at line 118, column 36
// eps at line 118, column 40
// map at line 119, column 11
// pos at line 119, column 15
// eps at line 119, column 19
// map at line 119, column 32
// pos at line 119, column 36
// eps at line 119, column 40
// map at line 120, column 11
// pos at line 120, column 15
// eps at line 120, column 19
// map at line 120, column 32
// pos at line 120, column 36
// eps at line 120, column 40
// popping activation record 0:calcNormal19
// local variables: 
// variable pos, unique name 0:calcNormal19:pos, index 232, declared at line 114, column 25
// variable t, unique name 0:calcNormal19:t, index 233, declared at line 114, column 39
// references:
// pushing activation record 0:softshadow21
float softshadow(in vec3 ro, in vec3 rd, float mint, float k)
{
// pushing activation record 0:softshadow21:22
    float res = 1.0;
    float t = mint;
    // pushing activation record 0:softshadow21:22:for23
    for (int i = 0; i < 50; i++) {
    // pushing activation record 0:softshadow21:22:for23:24
        float h = map(ro + rd * t).x;
        res = min(res, k * h / t);
        t += clamp(h, 0.5, 1.0);
        if (h < 0.001) break;

    }
    // popping activation record 0:softshadow21:22:for23:24
    // local variables: 
    // variable h, unique name 0:softshadow21:22:for23:24:h, index 243, declared at line 129, column 14
    // references:
    // map at line 129, column 18
    // ro at line 129, column 22
    // rd at line 129, column 27
    // t at line 129, column 30
    // res at line 130, column 8
    // min at line 130, column 14
    // res at line 130, column 19
    // k at line 130, column 24
    // h at line 130, column 26
    // t at line 130, column 28
    // t at line 131, column 2
    // clamp at line 131, column 7
    // h at line 131, column 14
    // h at line 132, column 6
    // popping activation record 0:softshadow21:22:for23
    // local variables: 
    // variable i, unique name 0:softshadow21:22:for23:i, index 242, declared at line 127, column 13
    // references:
    // i at line 127, column 18
    // i at line 127, column 24
    return clamp(res, 0.0, 1.0);

}
// popping activation record 0:softshadow21:22
// local variables: 
// variable res, unique name 0:softshadow21:22:res, index 240, declared at line 125, column 10
// variable t, unique name 0:softshadow21:22:t, index 241, declared at line 126, column 10
// references:
// mint at line 126, column 14
// clamp at line 134, column 11
// res at line 134, column 17
// popping activation record 0:softshadow21
// local variables: 
// variable ro, unique name 0:softshadow21:ro, index 236, declared at line 123, column 26
// variable rd, unique name 0:softshadow21:rd, index 237, declared at line 123, column 38
// variable mint, unique name 0:softshadow21:mint, index 238, declared at line 123, column 48
// variable k, unique name 0:softshadow21:k, index 239, declared at line 123, column 60
// references:
// pushing activation record 0:Diffuse25
float Diffuse(in vec3 l, in vec3 n, in vec3 v, float r)
{
// pushing activation record 0:Diffuse25:26
    float r2 = r * r;
    float a = 1.0 - 0.5 * (r2 / (r2 + 0.57));
    float b = 0.45 * (r2 / (r2 + 0.09));
    float nl = dot(n, l);
    float nv = dot(n, v);
    float ga = dot(v - n * nv, n - n * nl);
    return max(0.0, nl) * (a + b * max(0.0, ga) * sqrt((1.0 - nv * nv) * (1.0 - nl * nl)) / max(nl, nv));

}
// popping activation record 0:Diffuse25:26
// local variables: 
// variable r2, unique name 0:Diffuse25:26:r2, index 249, declared at line 141, column 10
// variable a, unique name 0:Diffuse25:26:a, index 250, declared at line 142, column 10
// variable b, unique name 0:Diffuse25:26:b, index 251, declared at line 143, column 10
// variable nl, unique name 0:Diffuse25:26:nl, index 252, declared at line 145, column 10
// variable nv, unique name 0:Diffuse25:26:nv, index 253, declared at line 146, column 10
// variable ga, unique name 0:Diffuse25:26:ga, index 254, declared at line 148, column 10
// references:
// r at line 141, column 15
// r at line 141, column 17
// r2 at line 142, column 25
// r2 at line 142, column 29
// r2 at line 143, column 20
// r2 at line 143, column 24
// dot at line 145, column 15
// n at line 145, column 19
// l at line 145, column 22
// dot at line 146, column 15
// n at line 146, column 19
// v at line 146, column 22
// dot at line 148, column 15
// v at line 148, column 19
// n at line 148, column 21
// nv at line 148, column 23
// n at line 148, column 26
// n at line 148, column 28
// nl at line 148, column 30
// max at line 150, column 8
// nl at line 150, column 16
// a at line 150, column 23
// b at line 150, column 27
// max at line 150, column 29
// ga at line 150, column 37
// sqrt at line 150, column 43
// nv at line 150, column 53
// nv at line 150, column 56
// nl at line 150, column 65
// nl at line 150, column 68
// max at line 150, column 75
// nl at line 150, column 79
// nv at line 150, column 83
// popping activation record 0:Diffuse25
// local variables: 
// variable l, unique name 0:Diffuse25:l, index 245, declared at line 138, column 23
// variable n, unique name 0:Diffuse25:n, index 246, declared at line 138, column 34
// variable v, unique name 0:Diffuse25:v, index 247, declared at line 138, column 45
// variable r, unique name 0:Diffuse25:r, index 248, declared at line 138, column 54
// references:
// pushing activation record 0:cpath27
vec3 cpath(float t)
{
// pushing activation record 0:cpath27:28
    vec3 pos = vec3(0.0, 0.0, 95.0 + t);
    float a = smoothstep(5.0, 20.0, t);
    pos.xz += a * 150.0 * cos(vec2(5.0, 6.0) + 1.0 * 0.01 * t);
    pos.xz -= a * 150.0 * cos(vec2(5.0, 6.0));
    pos.xz += a * 50.0 * cos(vec2(0.0, 3.5) + 6.0 * 0.01 * t);
    pos.xz -= a * 50.0 * cos(vec2(0.0, 3.5));
    return pos;

}
// popping activation record 0:cpath27:28
// local variables: 
// variable pos, unique name 0:cpath27:28:pos, index 257, declared at line 155, column 6
// variable a, unique name 0:cpath27:28:a, index 258, declared at line 157, column 7
// references:
// vec3 at line 155, column 12
// t at line 155, column 35
// smoothstep at line 157, column 11
// t at line 157, column 31
// pos at line 158, column 1
// a at line 158, column 11
// cos at line 158, column 21
// vec2 at line 158, column 26
// t at line 158, column 51
// pos at line 159, column 1
// a at line 159, column 11
// cos at line 159, column 21
// vec2 at line 159, column 26
// pos at line 160, column 1
// a at line 160, column 11
// cos at line 160, column 21
// vec2 at line 160, column 26
// t at line 160, column 51
// pos at line 161, column 1
// a at line 161, column 11
// cos at line 161, column 21
// vec2 at line 161, column 26
// pos at line 163, column 8
// popping activation record 0:cpath27
// local variables: 
// variable t, unique name 0:cpath27:t, index 256, declared at line 153, column 18
// references:
// pushing activation record 0:setCamera29
mat3 setCamera(in vec3 ro, in vec3 ta, float cr)
{
// pushing activation record 0:setCamera29:30
    vec3 cw = normalize(ta - ro);
    vec3 cp = vec3(sin(cr), cos(cr), 0.0);
    vec3 cu = normalize(cross(cw, cp));
    vec3 cv = normalize(cross(cu, cw));
    return mat3(cu, cv, cw);

}
// popping activation record 0:setCamera29:30
// local variables: 
// variable cw, unique name 0:setCamera29:30:cw, index 263, declared at line 168, column 6
// variable cp, unique name 0:setCamera29:30:cp, index 264, declared at line 169, column 6
// variable cu, unique name 0:setCamera29:30:cu, index 265, declared at line 170, column 6
// variable cv, unique name 0:setCamera29:30:cv, index 266, declared at line 171, column 6
// references:
// normalize at line 168, column 11
// ta at line 168, column 21
// ro at line 168, column 24
// vec3 at line 169, column 11
// sin at line 169, column 16
// cr at line 169, column 20
// cos at line 169, column 25
// cr at line 169, column 29
// normalize at line 170, column 11
// cross at line 170, column 22
// cw at line 170, column 28
// cp at line 170, column 31
// normalize at line 171, column 11
// cross at line 171, column 22
// cu at line 171, column 28
// cw at line 171, column 31
// mat3 at line 172, column 11
// cu at line 172, column 17
// cv at line 172, column 21
// cw at line 172, column 25
// popping activation record 0:setCamera29
// local variables: 
// variable ro, unique name 0:setCamera29:ro, index 260, declared at line 166, column 24
// variable ta, unique name 0:setCamera29:ta, index 261, declared at line 166, column 36
// variable cr, unique name 0:setCamera29:cr, index 262, declared at line 166, column 46
// references:
// pushing activation record 0:mainImage31
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage31:32
    vec2 q = fragCoord.xy / iResolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= iResolution.x / iResolution.y;
    vec2 m = vec2(0.0);
    if (iMouse.z > 0.0) m = iMouse.xy / iResolution.xy;
    float an = 0.5 * (iGlobalTime - 5.0);
    vec3 ro = cpath(an + 0.0);
    vec3 ta = cpath(an + 10.0 * 1.0);
    ta = mix(ro + vec3(0.0, 0.0, 1.0), ta, smoothstep(5.0, 25.0, an));
    ro.y = terrain2(ro.xz) - 0.5;
    ta.y = ro.y - 0.1;
    ta.xy += step(0.01, m.x) * (m.xy - 0.5) * 4.0 * vec2(-1.0, 1.0);
    float rl = -0.1 * cos(0.05 * 6.2831 * an);
    mat3 cam = setCamera(ro, ta, rl);
    vec3 rd = normalize(cam * vec3(p.xy, 2.0));
    vec3 klig = normalize(vec3(-1.0, 0.19, 0.4));
    float sun = clamp(dot(klig, rd), 0.0, 1.0);
    vec3 hor = mix(1.2 * vec3(0.70, 1.0, 1.0), vec3(1.5, 0.5, 0.05), 0.25 + 0.75 * sun);
    vec3 col = mix(vec3(0.2, 0.6, .9), hor, exp(-(4.0 + 2.0 * (1.0 - sun)) * max(0.0, rd.y - 0.1)));
    col *= 0.5;
    col += 0.8 * vec3(1.0, 0.8, 0.7) * pow(sun, 512.0);
    col += 0.2 * vec3(1.0, 0.4, 0.2) * pow(sun, 32.0);
    col += 0.1 * vec3(1.0, 0.4, 0.2) * pow(sun, 4.0);
    vec3 bcol = col;
    float pt = (1000.0 - ro.y) / rd.y;
    if (pt > 0.0) {
    // pushing activation record 0:mainImage31:32:33
        vec3 spos = ro + pt * rd;
        float clo = texture(iChannel0, 0.00006 * spos.xz).x;
        vec3 cloCol = mix(vec3(0.4, 0.5, 0.6), vec3(1.3, 0.6, 0.4), pow(sun, 2.0)) * (0.5 + 0.5 * clo);
        col = mix(col, cloCol, 0.5 * smoothstep(0.4, 1.0, clo));

    }
    // popping activation record 0:mainImage31:32:33
    // local variables: 
    // variable spos, unique name 0:mainImage31:32:33:spos, index 285, declared at line 224, column 13
    // variable clo, unique name 0:mainImage31:32:33:clo, index 286, declared at line 225, column 14
    // variable cloCol, unique name 0:mainImage31:32:33:cloCol, index 287, declared at line 226, column 13
    // references:
    // ro at line 224, column 20
    // pt at line 224, column 25
    // rd at line 224, column 28
    // texture at line 225, column 20
    // iChannel0 at line 225, column 29
    // spos at line 225, column 48
    // mix at line 226, column 22
    // vec3 at line 226, column 27
    // vec3 at line 226, column 46
    // pow at line 226, column 65
    // sun at line 226, column 69
    // clo at line 226, column 88
    // col at line 227, column 8
    // mix at line 227, column 14
    // col at line 227, column 19
    // cloCol at line 227, column 24
    // smoothstep at line 227, column 36
    // clo at line 227, column 58
    float tmax = 120.0;
    float bt = (0.0 - ro.y) / rd.y;
    if (bt > 0.0) tmax = min(tmax, bt);
    vec4 tmat = intersect(ro, rd, tmax);
    if (tmat.x < tmax) {
    // pushing activation record 0:mainImage31:32:34
        vec3 pos = ro + tmat.x * rd;
        vec3 nor = calcNormal(pos, tmat.x);
        vec3 ref = reflect(rd, nor);
        float occ = smoothstep(0.0, 1.5, pos.y + 11.5) * (1.0 - displacement(0.25 * pos * vec3(1.0, 4.0, 1.0)));
        vec4 mate = vec4(0.5, 0.5, 0.5, 0.0);
        {
        // pushing activation record 0:mainImage31:32:34:35
            vec3 uvw = 1.0 * pos;
            vec3 bnor;
            float be = 1.0 / 1024.0;
            float bf = 0.4;
            bnor.x = texcube(iChannel0, bf * uvw + vec3(be, 0.0, 0.0), nor).x - texcube(iChannel0, bf * uvw - vec3(be, 0.0, 0.0), nor).x;
            bnor.y = texcube(iChannel0, bf * uvw + vec3(0.0, be, 0.0), nor).x - texcube(iChannel0, bf * uvw - vec3(0.0, be, 0.0), nor).x;
            bnor.z = texcube(iChannel0, bf * uvw + vec3(0.0, 0.0, be), nor).x - texcube(iChannel0, bf * uvw - vec3(0.0, 0.0, be), nor).x;
            bnor = normalize(bnor);
            float amo = 0.2 + 0.25 * (1.0 - smoothstep(0.6, 0.7, nor.y));
            nor = normalize(nor + amo * (bnor - nor * dot(bnor, nor)));
            vec3 te = texcube(iChannel0, 0.15 * uvw, nor).xyz;
            te = 0.05 + te;
            mate.xyz = 0.6 * te;
            mate.w = 1.5 * (0.5 + 0.5 * te.x);
            float th = smoothstep(0.1, 0.4, texcube(iChannel0, 0.002 * uvw, nor).x);
            vec3 dcol = mix(vec3(0.2, 0.3, 0.0), 0.4 * vec3(0.65, 0.4, 0.2), 0.2 + 0.8 * th);
            mate.xyz = mix(mate.xyz, 2.0 * dcol, th * smoothstep(0.0, 1.0, nor.y));
            mate.xyz *= 0.5;
            float rr = smoothstep(0.2, 0.4, texcube(iChannel1, 2.0 * 0.02 * uvw, nor).y);
            mate.xyz *= mix(vec3(1.0), 1.5 * vec3(0.25, 0.24, 0.22) * 1.5, rr);
            mate.xyz *= 1.5 * pow(texcube(iChannel3, 8.0 * uvw, nor).xyz, vec3(0.5));
            mate = mix(mate, vec4(0.7, 0.7, 0.7, .0), smoothstep(0.8, 0.9, nor.y + nor.x * 0.6 * te.x * te.x));
            mate.xyz *= 1.5;

        }
        // popping activation record 0:mainImage31:32:34:35
        // local variables: 
        // variable uvw, unique name 0:mainImage31:32:34:35:uvw, index 296, declared at line 253, column 8
        // variable bnor, unique name 0:mainImage31:32:34:35:bnor, index 297, declared at line 255, column 8
        // variable be, unique name 0:mainImage31:32:34:35:be, index 298, declared at line 256, column 9
        // variable bf, unique name 0:mainImage31:32:34:35:bf, index 299, declared at line 257, column 9
        // variable amo, unique name 0:mainImage31:32:34:35:amo, index 300, declared at line 262, column 9
        // variable te, unique name 0:mainImage31:32:34:35:te, index 301, declared at line 265, column 8
        // variable th, unique name 0:mainImage31:32:34:35:th, index 302, declared at line 269, column 9
        // variable dcol, unique name 0:mainImage31:32:34:35:dcol, index 303, declared at line 270, column 8
        // variable rr, unique name 0:mainImage31:32:34:35:rr, index 304, declared at line 273, column 9
        // references:
        // pos at line 253, column 18
        // bnor at line 258, column 3
        // texcube at line 258, column 12
        // iChannel0 at line 258, column 21
        // bf at line 258, column 32
        // uvw at line 258, column 35
        // vec3 at line 258, column 39
        // be at line 258, column 44
        // nor at line 258, column 57
        // texcube at line 258, column 67
        // iChannel0 at line 258, column 76
        // bf at line 258, column 87
        // uvw at line 258, column 90
        // vec3 at line 258, column 94
        // be at line 258, column 99
        // nor at line 258, column 112
        // bnor at line 259, column 3
        // texcube at line 259, column 12
        // iChannel0 at line 259, column 21
        // bf at line 259, column 32
        // uvw at line 259, column 35
        // vec3 at line 259, column 39
        // be at line 259, column 48
        // nor at line 259, column 57
        // texcube at line 259, column 67
        // iChannel0 at line 259, column 76
        // bf at line 259, column 87
        // uvw at line 259, column 90
        // vec3 at line 259, column 94
        // be at line 259, column 103
        // nor at line 259, column 112
        // bnor at line 260, column 3
        // texcube at line 260, column 12
        // iChannel0 at line 260, column 21
        // bf at line 260, column 32
        // uvw at line 260, column 35
        // vec3 at line 260, column 39
        // be at line 260, column 52
        // nor at line 260, column 57
        // texcube at line 260, column 67
        // iChannel0 at line 260, column 76
        // bf at line 260, column 87
        // uvw at line 260, column 90
        // vec3 at line 260, column 94
        // be at line 260, column 107
        // nor at line 260, column 112
        // bnor at line 261, column 3
        // normalize at line 261, column 10
        // bnor at line 261, column 20
        // smoothstep at line 262, column 32
        // nor at line 262, column 51
        // nor at line 263, column 3
        // normalize at line 263, column 9
        // nor at line 263, column 20
        // amo at line 263, column 26
        // bnor at line 263, column 31
        // nor at line 263, column 36
        // dot at line 263, column 40
        // bnor at line 263, column 44
        // nor at line 263, column 49
        // texcube at line 265, column 13
        // iChannel0 at line 265, column 22
        // uvw at line 265, column 38
        // nor at line 265, column 43
        // te at line 266, column 3
        // te at line 266, column 15
        // mate at line 267, column 3
        // te at line 267, column 18
        // mate at line 268, column 3
        // te at line 268, column 25
        // smoothstep at line 269, column 14
        // texcube at line 269, column 36
        // iChannel0 at line 269, column 45
        // uvw at line 269, column 62
        // nor at line 269, column 67
        // mix at line 270, column 15
        // vec3 at line 270, column 20
        // vec3 at line 270, column 45
        // th at line 270, column 75
        // mate at line 271, column 3
        // mix at line 271, column 14
        // mate at line 271, column 19
        // dcol at line 271, column 33
        // th at line 271, column 39
        // smoothstep at line 271, column 42
        // nor at line 271, column 64
        // mate at line 272, column 3
        // smoothstep at line 273, column 14
        // texcube at line 273, column 36
        // iChannel1 at line 273, column 45
        // uvw at line 273, column 65
        // nor at line 273, column 70
        // mate at line 274, column 3
        // mix at line 274, column 15
        // vec3 at line 274, column 20
        // vec3 at line 274, column 35
        // rr at line 274, column 61
        // mate at line 275, column 3
        // pow at line 275, column 19
        // texcube at line 275, column 23
        // iChannel3 at line 275, column 32
        // uvw at line 275, column 47
        // nor at line 275, column 52
        // vec3 at line 275, column 62
        // mate at line 276, column 12
        // mix at line 276, column 19
        // mate at line 276, column 24
        // vec4 at line 276, column 30
        // smoothstep at line 276, column 52
        // nor at line 276, column 71
        // nor at line 276, column 79
        // te at line 276, column 89
        // te at line 276, column 94
        // mate at line 279, column 3
        vec3 blig = normalize(vec3(-klig.x, 0.0, -klig.z));
        vec3 slig = vec3(0.0, 1.0, 0.0);
        float sky = 0.0;
        sky += 0.2 * Diffuse(normalize(vec3(0.0, 1.0, 0.0)), nor, -rd, 1.0);
        sky += 0.2 * Diffuse(normalize(vec3(3.0, 1.0, 0.0)), nor, -rd, 1.0);
        sky += 0.2 * Diffuse(normalize(vec3(-3.0, 1.0, 0.0)), nor, -rd, 1.0);
        sky += 0.2 * Diffuse(normalize(vec3(0.0, 1.0, 3.0)), nor, -rd, 1.0);
        sky += 0.2 * Diffuse(normalize(vec3(0.0, 1.0, -3.0)), nor, -rd, 1.0);
        float dif = Diffuse(klig, nor, -rd, 1.0);
        float bac = Diffuse(blig, nor, -rd, 1.0);
        float sha = 0.0;
        if (dif > 0.001) sha = softshadow(pos + 0.01 * nor, klig, 0.005, 64.0);
        float spe = mate.w * pow(clamp(dot(reflect(rd, nor), klig), 0.0, 1.0), 2.0) * clamp(dot(nor, klig), 0.0, 1.0);
        vec3 lin = vec3(0.0);
        lin += 7.0 * dif * vec3(1.20, 0.50, 0.25) * vec3(sha, sha * 0.5 + 0.5 * sha * sha, sha * sha);
        lin += 1.0 * sky * vec3(0.10, 0.50, 0.70) * occ;
        lin += 2.0 * bac * vec3(0.30, 0.15, 0.15) * occ;
        lin += 0.5 * vec3(spe) * sha * occ;
        col = mate.xyz * lin;
        bcol = 0.7 * mix(vec3(0.2, 0.5, 1.0) * 0.82, bcol, 0.15 + 0.8 * sun);
        col = mix(col, bcol, 1.0 - exp(-0.02 * tmat.x));

    }
    // popping activation record 0:mainImage31:32:34
    // local variables: 
    // variable pos, unique name 0:mainImage31:32:34:pos, index 291, declared at line 242, column 13
    // variable nor, unique name 0:mainImage31:32:34:nor, index 292, declared at line 243, column 13
    // variable ref, unique name 0:mainImage31:32:34:ref, index 293, declared at line 244, column 7
    // variable occ, unique name 0:mainImage31:32:34:occ, index 294, declared at line 246, column 8
    // variable mate, unique name 0:mainImage31:32:34:mate, index 295, declared at line 249, column 7
    // variable blig, unique name 0:mainImage31:32:34:blig, index 305, declared at line 282, column 7
    // variable slig, unique name 0:mainImage31:32:34:slig, index 306, declared at line 283, column 7
    // variable sky, unique name 0:mainImage31:32:34:sky, index 307, declared at line 286, column 14
    // variable dif, unique name 0:mainImage31:32:34:dif, index 308, declared at line 292, column 8
    // variable bac, unique name 0:mainImage31:32:34:bac, index 309, declared at line 293, column 8
    // variable sha, unique name 0:mainImage31:32:34:sha, index 310, declared at line 296, column 8
    // variable spe, unique name 0:mainImage31:32:34:spe, index 311, declared at line 297, column 14
    // variable lin, unique name 0:mainImage31:32:34:lin, index 312, declared at line 300, column 7
    // references:
    // ro at line 242, column 19
    // tmat at line 242, column 24
    // rd at line 242, column 31
    // calcNormal at line 243, column 19
    // pos at line 243, column 31
    // tmat at line 243, column 36
    // reflect at line 244, column 13
    // rd at line 244, column 22
    // nor at line 244, column 26
    // smoothstep at line 246, column 14
    // pos at line 246, column 36
    // displacement at line 246, column 60
    // pos at line 246, column 79
    // vec3 at line 246, column 83
    // vec4 at line 249, column 14
    // normalize at line 282, column 14
    // vec3 at line 282, column 24
    // klig at line 282, column 30
    // klig at line 282, column 42
    // vec3 at line 283, column 14
    // sky at line 287, column 8
    // Diffuse at line 287, column 19
    // normalize at line 287, column 28
    // vec3 at line 287, column 38
    // nor at line 287, column 62
    // rd at line 287, column 68
    // sky at line 288, column 8
    // Diffuse at line 288, column 19
    // normalize at line 288, column 28
    // vec3 at line 288, column 38
    // nor at line 288, column 62
    // rd at line 288, column 68
    // sky at line 289, column 8
    // Diffuse at line 289, column 19
    // normalize at line 289, column 28
    // vec3 at line 289, column 38
    // nor at line 289, column 62
    // rd at line 289, column 68
    // sky at line 290, column 8
    // Diffuse at line 290, column 19
    // normalize at line 290, column 28
    // vec3 at line 290, column 38
    // nor at line 290, column 62
    // rd at line 290, column 68
    // sky at line 291, column 8
    // Diffuse at line 291, column 19
    // normalize at line 291, column 28
    // vec3 at line 291, column 38
    // nor at line 291, column 62
    // rd at line 291, column 68
    // Diffuse at line 292, column 14
    // klig at line 292, column 23
    // nor at line 292, column 29
    // rd at line 292, column 35
    // Diffuse at line 293, column 14
    // blig at line 293, column 23
    // nor at line 293, column 29
    // rd at line 293, column 35
    // dif at line 296, column 23
    // sha at line 296, column 35
    // softshadow at line 296, column 39
    // pos at line 296, column 51
    // nor at line 296, column 60
    // klig at line 296, column 65
    // mate at line 297, column 20
    // pow at line 297, column 27
    // clamp at line 297, column 32
    // dot at line 297, column 38
    // reflect at line 297, column 42
    // rd at line 297, column 50
    // nor at line 297, column 53
    // klig at line 297, column 58
    // clamp at line 297, column 78
    // dot at line 297, column 84
    // nor at line 297, column 88
    // klig at line 297, column 92
    // vec3 at line 300, column 13
    // lin at line 301, column 2
    // dif at line 301, column 13
    // vec3 at line 301, column 17
    // vec3 at line 301, column 38
    // sha at line 301, column 43
    // sha at line 301, column 47
    // sha at line 301, column 59
    // sha at line 301, column 63
    // sha at line 301, column 68
    // sha at line 301, column 72
    // lin at line 302, column 2
    // sky at line 302, column 13
    // vec3 at line 302, column 17
    // occ at line 302, column 38
    // lin at line 303, column 2
    // bac at line 303, column 13
    // vec3 at line 303, column 17
    // occ at line 303, column 38
    // lin at line 304, column 5
    // vec3 at line 304, column 16
    // spe at line 304, column 21
    // sha at line 304, column 26
    // occ at line 304, column 30
    // col at line 307, column 2
    // mate at line 307, column 8
    // lin at line 307, column 19
    // bcol at line 310, column 8
    // mix at line 310, column 19
    // vec3 at line 310, column 24
    // bcol at line 310, column 48
    // sun at line 310, column 63
    // col at line 310, column 70
    // mix at line 310, column 76
    // col at line 310, column 81
    // bcol at line 310, column 86
    // exp at line 310, column 96
    // tmat at line 310, column 106
    col += 0.15 * vec3(1.0, 0.9, 0.6) * pow(sun, 6.0);
    col *= 1.0 - 0.25 * pow(1.0 - clamp(dot(cam[2], klig), 0.0, 1.0), 3.0);
    col = pow(clamp(col, 0.0, 1.0), vec3(0.45));
    col *= vec3(1.1, 1.0, 1.0);
    col = col * col * (3.0 - 2.0 * col);
    col = pow(col, vec3(0.9, 1.0, 1.0));
    col = mix(col, vec3(dot(col, vec3(0.333))), 0.4);
    col = col * 0.5 + 0.5 * col * col * (3.0 - 2.0 * col);
    col *= 0.3 + 0.7 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.1);
    col *= smoothstep(0.0, 2.5, iGlobalTime);
    fragColor = vec4(col, 1.0);

}
// popping activation record 0:mainImage31:32
// local variables: 
// variable q, unique name 0:mainImage31:32:q, index 270, declared at line 177, column 6
// variable p, unique name 0:mainImage31:32:p, index 271, declared at line 178, column 9
// variable m, unique name 0:mainImage31:32:m, index 272, declared at line 180, column 9
// variable an, unique name 0:mainImage31:32:an, index 273, declared at line 188, column 7
// variable ro, unique name 0:mainImage31:32:ro, index 274, declared at line 189, column 6
// variable ta, unique name 0:mainImage31:32:ta, index 275, declared at line 190, column 6
// variable rl, unique name 0:mainImage31:32:rl, index 276, declared at line 195, column 7
// variable cam, unique name 0:mainImage31:32:cam, index 277, declared at line 197, column 9
// variable rd, unique name 0:mainImage31:32:rd, index 278, declared at line 200, column 6
// variable klig, unique name 0:mainImage31:32:klig, index 279, declared at line 206, column 6
// variable sun, unique name 0:mainImage31:32:sun, index 280, declared at line 208, column 7
// variable hor, unique name 0:mainImage31:32:hor, index 281, declared at line 210, column 6
// variable col, unique name 0:mainImage31:32:col, index 282, declared at line 212, column 9
// variable bcol, unique name 0:mainImage31:32:bcol, index 283, declared at line 218, column 6
// variable pt, unique name 0:mainImage31:32:pt, index 284, declared at line 221, column 7
// variable tmax, unique name 0:mainImage31:32:tmax, index 288, declared at line 232, column 10
// variable bt, unique name 0:mainImage31:32:bt, index 289, declared at line 235, column 10
// variable tmat, unique name 0:mainImage31:32:tmat, index 290, declared at line 238, column 9
// references:
// fragCoord at line 177, column 10
// iResolution at line 177, column 25
// q at line 178, column 26
// p at line 179, column 4
// iResolution at line 179, column 11
// iResolution at line 179, column 25
// vec2 at line 180, column 13
// iMouse at line 181, column 5
// m at line 181, column 20
// iMouse at line 181, column 24
// iResolution at line 181, column 34
// iGlobalTime at line 188, column 17
// cpath at line 189, column 11
// an at line 189, column 18
// cpath at line 190, column 11
// an at line 190, column 18
// ta at line 191, column 1
// mix at line 191, column 6
// ro at line 191, column 11
// vec3 at line 191, column 16
// ta at line 191, column 35
// smoothstep at line 191, column 39
// an at line 191, column 59
// ro at line 192, column 4
// terrain2 at line 192, column 11
// ro at line 192, column 21
// ta at line 193, column 1
// ro at line 193, column 8
// ta at line 194, column 1
// step at line 194, column 10
// m at line 194, column 20
// m at line 194, column 26
// vec2 at line 194, column 40
// cos at line 195, column 17
// an at line 195, column 33
// setCamera at line 197, column 15
// ro at line 197, column 26
// ta at line 197, column 30
// rl at line 197, column 34
// normalize at line 200, column 11
// cam at line 200, column 22
// vec3 at line 200, column 28
// p at line 200, column 33
// normalize at line 206, column 13
// vec3 at line 206, column 23
// clamp at line 208, column 13
// dot at line 208, column 19
// klig at line 208, column 23
// rd at line 208, column 28
// mix at line 210, column 12
// vec3 at line 210, column 21
// vec3 at line 210, column 41
// sun at line 210, column 71
// mix at line 212, column 15
// vec3 at line 212, column 20
// hor at line 212, column 38
// exp at line 212, column 43
// sun at line 212, column 62
// max at line 212, column 68
// rd at line 212, column 76
// col at line 213, column 4
// col at line 214, column 1
// vec3 at line 214, column 12
// pow at line 214, column 30
// sun at line 214, column 34
// col at line 215, column 1
// vec3 at line 215, column 12
// pow at line 215, column 30
// sun at line 215, column 34
// col at line 216, column 1
// vec3 at line 216, column 12
// pow at line 216, column 30
// sun at line 216, column 34
// col at line 218, column 13
// ro at line 221, column 20
// rd at line 221, column 26
// pt at line 222, column 5
// ro at line 235, column 20
// rd at line 235, column 26
// bt at line 236, column 5
// tmax at line 236, column 14
// min at line 236, column 21
// tmax at line 236, column 26
// bt at line 236, column 32
// intersect at line 238, column 16
// ro at line 238, column 27
// rd at line 238, column 31
// tmax at line 238, column 35
// tmat at line 239, column 8
// tmax at line 239, column 15
// col at line 314, column 1
// vec3 at line 314, column 13
// pow at line 314, column 31
// sun at line 314, column 36
// col at line 319, column 4
// pow at line 319, column 22
// clamp at line 319, column 30
// dot at line 319, column 36
// cam at line 319, column 40
// klig at line 319, column 47
// col at line 321, column 1
// pow at line 321, column 7
// clamp at line 321, column 12
// col at line 321, column 18
// vec3 at line 321, column 32
// col at line 323, column 1
// vec3 at line 323, column 8
// col at line 324, column 1
// col at line 324, column 7
// col at line 324, column 11
// col at line 324, column 24
// col at line 325, column 1
// pow at line 325, column 7
// col at line 325, column 12
// vec3 at line 325, column 17
// col at line 327, column 1
// mix at line 327, column 7
// col at line 327, column 12
// vec3 at line 327, column 17
// dot at line 327, column 22
// col at line 327, column 26
// vec3 at line 327, column 30
// col at line 328, column 1
// col at line 328, column 7
// col at line 328, column 19
// col at line 328, column 23
// col at line 328, column 36
// col at line 330, column 1
// pow at line 330, column 18
// q at line 330, column 28
// q at line 330, column 32
// q at line 330, column 41
// q at line 330, column 51
// col at line 332, column 4
// smoothstep at line 332, column 11
// iGlobalTime at line 332, column 30
// fragColor at line 334, column 1
// vec4 at line 334, column 13
// col at line 334, column 19
// popping activation record 0:mainImage31
// local variables: 
// variable fragColor, unique name 0:mainImage31:fragColor, index 268, declared at line 175, column 25
// variable fragCoord, unique name 0:mainImage31:fragCoord, index 269, declared at line 175, column 44
// references:
// undefined variables 
