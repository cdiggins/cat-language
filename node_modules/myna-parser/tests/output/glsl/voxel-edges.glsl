// pushing activation record 0
// pushing activation record 0:noise1
float noise(in vec3 x)
{
// pushing activation record 0:noise1:2
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    vec2 uv = (p.xy + vec2(37.0, 17.0) * p.z) + f.xy;
    vec2 rg = textureLod(iChannel0, (uv + 0.5) / 256.0, 0.0).yx;
    return mix(rg.x, rg.y, f.z);

}
// popping activation record 0:noise1:2
// local variables: 
// variable p, unique name 0:noise1:2:p, index 180, declared at line 12, column 9
// variable f, unique name 0:noise1:2:f, index 181, declared at line 13, column 9
// variable uv, unique name 0:noise1:2:uv, index 182, declared at line 16, column 6
// variable rg, unique name 0:noise1:2:rg, index 183, declared at line 17, column 6
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
// iChannel0 at line 17, column 23
// uv at line 17, column 35
// mix at line 18, column 8
// rg at line 18, column 13
// rg at line 18, column 19
// f at line 18, column 25
// popping activation record 0:noise1
// local variables: 
// variable x, unique name 0:noise1:x, index 179, declared at line 10, column 21
// references:
// pushing activation record 0:texcube3
vec4 texcube(sampler2D sam, in vec3 p, in vec3 n)
{
// pushing activation record 0:texcube3:4
    vec3 m = abs(n);
    vec4 x = texture(sam, p.yz);
    vec4 y = texture(sam, p.zx);
    vec4 z = texture(sam, p.xy);
    return x * m.x + y * m.y + z * m.z;

}
// popping activation record 0:texcube3:4
// local variables: 
// variable m, unique name 0:texcube3:4:m, index 188, declared at line 23, column 9
// variable x, unique name 0:texcube3:4:x, index 189, declared at line 24, column 6
// variable y, unique name 0:texcube3:4:y, index 190, declared at line 25, column 6
// variable z, unique name 0:texcube3:4:z, index 191, declared at line 26, column 6
// references:
// abs at line 23, column 13
// n at line 23, column 18
// texture at line 24, column 10
// sam at line 24, column 19
// p at line 24, column 24
// texture at line 25, column 10
// sam at line 25, column 19
// p at line 25, column 24
// texture at line 26, column 10
// sam at line 26, column 19
// p at line 26, column 24
// x at line 27, column 8
// m at line 27, column 10
// y at line 27, column 16
// m at line 27, column 18
// z at line 27, column 24
// m at line 27, column 26
// popping activation record 0:texcube3
// local variables: 
// variable sam, unique name 0:texcube3:sam, index 185, declared at line 21, column 24
// variable p, unique name 0:texcube3:p, index 186, declared at line 21, column 37
// variable n, unique name 0:texcube3:n, index 187, declared at line 21, column 48
// references:
// pushing activation record 0:mapTerrain5
float mapTerrain(vec3 p)
{
// pushing activation record 0:mapTerrain5:6
    p *= 0.1;
    p.xz *= 0.6;
    float time = 0.5 + 0.15 * iGlobalTime;
    float ft = fract(time);
    float it = floor(time);
    ft = smoothstep(0.7, 1.0, ft);
    time = it + ft;
    float spe = 1.4;
    float f;
    f = 0.5000 * noise(p * 1.00 + vec3(0.0, 1.0, 0.0) * spe * time);
    f += 0.2500 * noise(p * 2.02 + vec3(0.0, 2.0, 0.0) * spe * time);
    f += 0.1250 * noise(p * 4.01);
    return 25.0 * f - 10.0;

}
// popping activation record 0:mapTerrain5:6
// local variables: 
// variable time, unique name 0:mapTerrain5:6:time, index 194, declared at line 35, column 7
// variable ft, unique name 0:mapTerrain5:6:ft, index 195, declared at line 36, column 7
// variable it, unique name 0:mapTerrain5:6:it, index 196, declared at line 37, column 7
// variable spe, unique name 0:mapTerrain5:6:spe, index 197, declared at line 40, column 7
// variable f, unique name 0:mapTerrain5:6:f, index 198, declared at line 42, column 7
// references:
// p at line 32, column 1
// p at line 33, column 1
// iGlobalTime at line 35, column 25
// fract at line 36, column 12
// time at line 36, column 19
// floor at line 37, column 12
// time at line 37, column 19
// ft at line 38, column 1
// smoothstep at line 38, column 6
// ft at line 38, column 28
// time at line 39, column 1
// it at line 39, column 8
// ft at line 39, column 13
// f at line 43, column 4
// noise at line 43, column 16
// p at line 43, column 23
// vec3 at line 43, column 32
// spe at line 43, column 50
// time at line 43, column 54
// f at line 44, column 4
// noise at line 44, column 16
// p at line 44, column 23
// vec3 at line 44, column 32
// spe at line 44, column 50
// time at line 44, column 54
// f at line 45, column 4
// noise at line 45, column 16
// p at line 45, column 23
// f at line 46, column 13
// popping activation record 0:mapTerrain5
// local variables: 
// variable p, unique name 0:mapTerrain5:p, index 193, declared at line 30, column 23
// references:
vec3 gro = vec3(0.0);
// pushing activation record 0:map7
float map(in vec3 c)
{
// pushing activation record 0:map7:8
    vec3 p = c + 0.5;
    float f = mapTerrain(p) + 0.25 * p.y;
    f = mix(f, 1.0, step(length(gro - p), 5.0));
    return step(f, 0.5);

}
// popping activation record 0:map7:8
// local variables: 
// variable p, unique name 0:map7:8:p, index 202, declared at line 53, column 6
// variable f, unique name 0:map7:8:f, index 203, declared at line 55, column 7
// references:
// c at line 53, column 10
// mapTerrain at line 55, column 11
// p at line 55, column 23
// p at line 55, column 34
// f at line 57, column 4
// mix at line 57, column 8
// f at line 57, column 13
// step at line 57, column 21
// length at line 57, column 27
// gro at line 57, column 34
// p at line 57, column 38
// step at line 59, column 8
// f at line 59, column 14
// popping activation record 0:map7
// local variables: 
// variable c, unique name 0:map7:c, index 201, declared at line 51, column 18
// references:
vec3 lig = normalize(vec3(-0.4, 0.3, 0.7));
// pushing activation record 0:castRay9
float castRay(in vec3 ro, in vec3 rd, out vec3 oVos, out vec3 oDir)
{
// pushing activation record 0:castRay9:10
    vec3 pos = floor(ro);
    vec3 ri = 1.0 / rd;
    vec3 rs = sign(rd);
    vec3 dis = (pos - ro + 0.5 + rs * 0.5) * ri;
    float res = -1.0;
    vec3 mm = vec3(0.0);
    // pushing activation record 0:castRay9:10:for11
    for (int i = 0; i < 128; i++) {
    // pushing activation record 0:castRay9:10:for11:12
        if (map(pos) > 0.5) {
        // pushing activation record 0:castRay9:10:for11:12:13
            res = 1.0;
            break;

        }
        // popping activation record 0:castRay9:10:for11:12:13
        // local variables: 
        // references:
        // res at line 75, column 23
        mm = step(dis.xyz, dis.yxy) * step(dis.xyz, dis.zzx);
        dis += mm * rs * ri;
        pos += mm * rs;

    }
    // popping activation record 0:castRay9:10:for11:12
    // local variables: 
    // references:
    // map at line 75, column 6
    // pos at line 75, column 10
    // mm at line 76, column 2
    // step at line 76, column 7
    // dis at line 76, column 12
    // dis at line 76, column 21
    // step at line 76, column 32
    // dis at line 76, column 37
    // dis at line 76, column 46
    // dis at line 77, column 2
    // mm at line 77, column 9
    // rs at line 77, column 14
    // ri at line 77, column 19
    // pos at line 78, column 8
    // mm at line 78, column 15
    // rs at line 78, column 20
    // popping activation record 0:castRay9:10:for11
    // local variables: 
    // variable i, unique name 0:castRay9:10:for11:i, index 216, declared at line 73, column 10
    // references:
    // i at line 73, column 15
    // i at line 73, column 22
    vec3 nor = -mm * rs;
    vec3 vos = pos;
    vec3 mini = (pos - ro + 0.5 - 0.5 * vec3(rs)) * ri;
    float t = max(mini.x, max(mini.y, mini.z));
    oDir = mm;
    oVos = vos;
    return t * res;

}
// popping activation record 0:castRay9:10
// local variables: 
// variable pos, unique name 0:castRay9:10:pos, index 210, declared at line 66, column 6
// variable ri, unique name 0:castRay9:10:ri, index 211, declared at line 67, column 6
// variable rs, unique name 0:castRay9:10:rs, index 212, declared at line 68, column 6
// variable dis, unique name 0:castRay9:10:dis, index 213, declared at line 69, column 6
// variable res, unique name 0:castRay9:10:res, index 214, declared at line 71, column 7
// variable mm, unique name 0:castRay9:10:mm, index 215, declared at line 72, column 6
// variable nor, unique name 0:castRay9:10:nor, index 217, declared at line 81, column 6
// variable vos, unique name 0:castRay9:10:vos, index 218, declared at line 82, column 6
// variable mini, unique name 0:castRay9:10:mini, index 219, declared at line 85, column 6
// variable t, unique name 0:castRay9:10:t, index 220, declared at line 86, column 7
// references:
// floor at line 66, column 12
// ro at line 66, column 18
// rd at line 67, column 15
// sign at line 68, column 11
// rd at line 68, column 16
// pos at line 69, column 13
// ro at line 69, column 17
// rs at line 69, column 28
// ri at line 69, column 38
// vec3 at line 72, column 11
// mm at line 81, column 13
// rs at line 81, column 16
// pos at line 82, column 12
// pos at line 85, column 14
// ro at line 85, column 18
// vec3 at line 85, column 33
// rs at line 85, column 38
// ri at line 85, column 43
// max at line 86, column 11
// mini at line 86, column 17
// max at line 86, column 25
// mini at line 86, column 31
// mini at line 86, column 39
// oDir at line 88, column 1
// mm at line 88, column 8
// oVos at line 89, column 1
// vos at line 89, column 8
// t at line 91, column 8
// res at line 91, column 10
// popping activation record 0:castRay9
// local variables: 
// variable ro, unique name 0:castRay9:ro, index 206, declared at line 64, column 23
// variable rd, unique name 0:castRay9:rd, index 207, declared at line 64, column 35
// variable oVos, unique name 0:castRay9:oVos, index 208, declared at line 64, column 48
// variable oDir, unique name 0:castRay9:oDir, index 209, declared at line 64, column 63
// references:
// pushing activation record 0:path14
vec3 path(float t, float ya)
{
// pushing activation record 0:path14:15
    vec2 p = 100.0 * sin(0.02 * t * vec2(1.0, 1.2) + vec2(0.1, 0.9));
    p += 50.0 * sin(0.04 * t * vec2(1.3, 1.0) + vec2(1.0, 4.5));
    return vec3(p.x, 18.0 + ya * 4.0 * sin(0.05 * t), p.y);

}
// popping activation record 0:path14:15
// local variables: 
// variable p, unique name 0:path14:15:p, index 224, declared at line 96, column 9
// references:
// sin at line 96, column 20
// t at line 96, column 30
// vec2 at line 96, column 32
// vec2 at line 96, column 48
// p at line 97, column 6
// sin at line 97, column 17
// t at line 97, column 27
// vec2 at line 97, column 29
// vec2 at line 97, column 45
// vec3 at line 99, column 8
// p at line 99, column 14
// ya at line 99, column 26
// sin at line 99, column 33
// t at line 99, column 42
// p at line 99, column 46
// popping activation record 0:path14
// local variables: 
// variable t, unique name 0:path14:t, index 222, declared at line 94, column 17
// variable ya, unique name 0:path14:ya, index 223, declared at line 94, column 26
// references:
// pushing activation record 0:setCamera16
mat3 setCamera(in vec3 ro, in vec3 ta, float cr)
{
// pushing activation record 0:setCamera16:17
    vec3 cw = normalize(ta - ro);
    vec3 cp = vec3(sin(cr), cos(cr), 0.0);
    vec3 cu = normalize(cross(cw, cp));
    vec3 cv = normalize(cross(cu, cw));
    return mat3(cu, cv, -cw);

}
// popping activation record 0:setCamera16:17
// local variables: 
// variable cw, unique name 0:setCamera16:17:cw, index 229, declared at line 104, column 6
// variable cp, unique name 0:setCamera16:17:cp, index 230, declared at line 105, column 6
// variable cu, unique name 0:setCamera16:17:cu, index 231, declared at line 106, column 6
// variable cv, unique name 0:setCamera16:17:cv, index 232, declared at line 107, column 6
// references:
// normalize at line 104, column 11
// ta at line 104, column 21
// ro at line 104, column 24
// vec3 at line 105, column 11
// sin at line 105, column 16
// cr at line 105, column 20
// cos at line 105, column 25
// cr at line 105, column 29
// normalize at line 106, column 11
// cross at line 106, column 22
// cw at line 106, column 28
// cp at line 106, column 31
// normalize at line 107, column 11
// cross at line 107, column 22
// cu at line 107, column 28
// cw at line 107, column 31
// mat3 at line 108, column 11
// cu at line 108, column 17
// cv at line 108, column 21
// cw at line 108, column 26
// popping activation record 0:setCamera16
// local variables: 
// variable ro, unique name 0:setCamera16:ro, index 226, declared at line 102, column 24
// variable ta, unique name 0:setCamera16:ta, index 227, declared at line 102, column 36
// variable cr, unique name 0:setCamera16:cr, index 228, declared at line 102, column 46
// references:
// pushing activation record 0:maxcomp18
float maxcomp(in vec4 v)
{
// pushing activation record 0:maxcomp18:19
    return max(max(v.x, v.y), max(v.z, v.w));

}
// popping activation record 0:maxcomp18:19
// local variables: 
// references:
// max at line 113, column 11
// max at line 113, column 16
// v at line 113, column 20
// v at line 113, column 24
// max at line 113, column 30
// v at line 113, column 34
// v at line 113, column 38
// popping activation record 0:maxcomp18
// local variables: 
// variable v, unique name 0:maxcomp18:v, index 234, declared at line 111, column 23
// references:
// pushing activation record 0:isEdge20
float isEdge(in vec2 uv, vec4 va, vec4 vb, vec4 vc, vec4 vd)
{
// pushing activation record 0:isEdge20:21
    vec2 st = 1.0 - uv;
    vec4 wb = smoothstep(0.85, 0.99, vec4(uv.x, st.x, uv.y, st.y)) * (1.0 - va + va * vc);
    vec4 wc = smoothstep(0.85, 0.99, vec4(uv.x * uv.y, st.x * uv.y, st.x * st.y, uv.x * st.y)) * (1.0 - vb + vd * vb);
    return maxcomp(max(wb, wc));

}
// popping activation record 0:isEdge20:21
// local variables: 
// variable st, unique name 0:isEdge20:21:st, index 241, declared at line 118, column 9
// variable wb, unique name 0:isEdge20:21:wb, index 242, declared at line 121, column 9
// variable wc, unique name 0:isEdge20:21:wc, index 243, declared at line 126, column 9
// references:
// uv at line 118, column 20
// smoothstep at line 121, column 14
// vec4 at line 121, column 38
// uv at line 121, column 43
// st at line 122, column 43
// uv at line 123, column 43
// st at line 124, column 43
// va at line 124, column 61
// va at line 124, column 66
// vc at line 124, column 69
// smoothstep at line 126, column 14
// vec4 at line 126, column 38
// uv at line 126, column 43
// uv at line 126, column 48
// st at line 127, column 43
// uv at line 127, column 48
// st at line 128, column 43
// st at line 128, column 48
// uv at line 129, column 43
// st at line 129, column 48
// vb at line 129, column 66
// vd at line 129, column 71
// vb at line 129, column 74
// maxcomp at line 130, column 11
// max at line 130, column 20
// wb at line 130, column 24
// wc at line 130, column 27
// popping activation record 0:isEdge20
// local variables: 
// variable uv, unique name 0:isEdge20:uv, index 236, declared at line 116, column 22
// variable va, unique name 0:isEdge20:va, index 237, declared at line 116, column 31
// variable vb, unique name 0:isEdge20:vb, index 238, declared at line 116, column 40
// variable vc, unique name 0:isEdge20:vc, index 239, declared at line 116, column 49
// variable vd, unique name 0:isEdge20:vd, index 240, declared at line 116, column 58
// references:
// pushing activation record 0:calcOcc22
float calcOcc(in vec2 uv, vec4 va, vec4 vb, vec4 vc, vec4 vd)
{
// pushing activation record 0:calcOcc22:23
    vec2 st = 1.0 - uv;
    vec4 wa = vec4(uv.x, st.x, uv.y, st.y) * vc;
    vec4 wb = vec4(uv.x * uv.y, st.x * uv.y, st.x * st.y, uv.x * st.y) * vd * (1.0 - vc.xzyw) * (1.0 - vc.zywx);
    return wa.x + wa.y + wa.z + wa.w + wb.x + wb.y + wb.z + wb.w;

}
// popping activation record 0:calcOcc22:23
// local variables: 
// variable st, unique name 0:calcOcc22:23:st, index 250, declared at line 135, column 9
// variable wa, unique name 0:calcOcc22:23:wa, index 251, declared at line 138, column 9
// variable wb, unique name 0:calcOcc22:23:wb, index 252, declared at line 141, column 9
// references:
// uv at line 135, column 20
// vec4 at line 138, column 14
// uv at line 138, column 20
// st at line 138, column 26
// uv at line 138, column 32
// st at line 138, column 38
// vc at line 138, column 47
// vec4 at line 141, column 14
// uv at line 141, column 19
// uv at line 141, column 24
// st at line 142, column 19
// uv at line 142, column 24
// st at line 143, column 19
// st at line 143, column 24
// uv at line 144, column 19
// st at line 144, column 24
// vd at line 144, column 30
// vc at line 144, column 38
// vc at line 144, column 52
// wa at line 146, column 11
// wa at line 146, column 18
// wa at line 146, column 25
// wa at line 146, column 32
// wb at line 147, column 11
// wb at line 147, column 18
// wb at line 147, column 25
// wb at line 147, column 32
// popping activation record 0:calcOcc22
// local variables: 
// variable uv, unique name 0:calcOcc22:uv, index 245, declared at line 133, column 23
// variable va, unique name 0:calcOcc22:va, index 246, declared at line 133, column 32
// variable vb, unique name 0:calcOcc22:vb, index 247, declared at line 133, column 41
// variable vc, unique name 0:calcOcc22:vc, index 248, declared at line 133, column 50
// variable vd, unique name 0:calcOcc22:vd, index 249, declared at line 133, column 59
// references:
// pushing activation record 0:render24
vec3 render(in vec3 ro, in vec3 rd)
{
// pushing activation record 0:render24:25
    vec3 col = vec3(0.0);
    vec3 vos, dir;
    float t = castRay(ro, rd, vos, dir);
    if (t > 0.0) {
    // pushing activation record 0:render24:25:26
        vec3 nor = -dir * sign(rd);
        vec3 pos = ro + rd * t;
        vec3 uvw = pos - vos;
        vec3 v1 = vos + nor + dir.yzx;
        vec3 v2 = vos + nor - dir.yzx;
        vec3 v3 = vos + nor + dir.zxy;
        vec3 v4 = vos + nor - dir.zxy;
        vec3 v5 = vos + nor + dir.yzx + dir.zxy;
        vec3 v6 = vos + nor - dir.yzx + dir.zxy;
        vec3 v7 = vos + nor - dir.yzx - dir.zxy;
        vec3 v8 = vos + nor + dir.yzx - dir.zxy;
        vec3 v9 = vos + dir.yzx;
        vec3 v10 = vos - dir.yzx;
        vec3 v11 = vos + dir.zxy;
        vec3 v12 = vos - dir.zxy;
        vec3 v13 = vos + dir.yzx + dir.zxy;
        vec3 v14 = vos - dir.yzx + dir.zxy;
        vec3 v15 = vos - dir.yzx - dir.zxy;
        vec3 v16 = vos + dir.yzx - dir.zxy;
        vec4 vc = vec4(map(v1), map(v2), map(v3), map(v4));
        vec4 vd = vec4(map(v5), map(v6), map(v7), map(v8));
        vec4 va = vec4(map(v9), map(v10), map(v11), map(v12));
        vec4 vb = vec4(map(v13), map(v14), map(v15), map(v16));
        vec2 uv = vec2(dot(dir.yzx, uvw), dot(dir.zxy, uvw));
        float www = 1.0 - isEdge(uv, va, vb, vc, vd);
        vec3 wir = smoothstep(0.4, 0.5, abs(uvw - 0.5));
        float vvv = (1.0 - wir.x * wir.y) * (1.0 - wir.x * wir.z) * (1.0 - wir.y * wir.z);
        col = 2.0 * texture(iChannel1, 0.01 * pos.xz).zyx;
        col += 0.8 * vec3(0.1, 0.3, 0.4);
        col *= 0.5 + 0.5 * texcube(iChannel2, 0.5 * pos, nor).x;
        col *= 1.0 - 0.75 * (1.0 - vvv) * www;
        float dif = clamp(dot(nor, lig), 0.0, 1.0);
        float bac = clamp(dot(nor, normalize(lig * vec3(-1.0, 0.0, -1.0))), 0.0, 1.0);
        float sky = 0.5 + 0.5 * nor.y;
        float amb = clamp(0.75 + pos.y / 25.0, 0.0, 1.0);
        float occ = 1.0;
        occ = calcOcc(uv, va, vb, vc, vd);
        occ = 1.0 - occ / 8.0;
        occ = occ * occ;
        occ = occ * occ;
        occ *= amb;
        vec3 lin = vec3(0.0);
        lin += 2.5 * dif * vec3(1.00, 0.90, 0.70) * (0.5 + 0.5 * occ);
        lin += 0.5 * bac * vec3(0.15, 0.10, 0.10) * occ;
        lin += 2.0 * sky * vec3(0.40, 0.30, 0.15) * occ;
        float lineglow = 0.0;
        lineglow += smoothstep(0.4, 1.0, uv.x) * (1.0 - va.x * (1.0 - vc.x));
        lineglow += smoothstep(0.4, 1.0, 1.0 - uv.x) * (1.0 - va.y * (1.0 - vc.y));
        lineglow += smoothstep(0.4, 1.0, uv.y) * (1.0 - va.z * (1.0 - vc.z));
        lineglow += smoothstep(0.4, 1.0, 1.0 - uv.y) * (1.0 - va.w * (1.0 - vc.w));
        lineglow += smoothstep(0.4, 1.0, uv.y * uv.x) * (1.0 - vb.x * (1.0 - vd.x));
        lineglow += smoothstep(0.4, 1.0, uv.y * (1.0 - uv.x)) * (1.0 - vb.y * (1.0 - vd.y));
        lineglow += smoothstep(0.4, 1.0, (1.0 - uv.y) * (1.0 - uv.x)) * (1.0 - vb.z * (1.0 - vd.z));
        lineglow += smoothstep(0.4, 1.0, (1.0 - uv.y) * uv.x) * (1.0 - vb.w * (1.0 - vd.w));
        vec3 linCol = 2.0 * vec3(5.0, 0.6, 0.0);
        linCol *= (0.5 + 0.5 * occ) * 0.5;
        lin += 3.0 * lineglow * linCol;
        col = col * lin;
        col += 8.0 * linCol * vec3(1.0, 2.0, 3.0) * (1.0 - www);
        col += 0.1 * lineglow * linCol;
        col *= min(0.1, exp(-0.07 * t));
        vec3 col2 = vec3(1.3) * (0.5 + 0.5 * nor.y) * occ * www * (0.9 + 0.1 * vvv) * exp(-0.04 * t);
        float mi = sin(-1.57 + 0.5 * iGlobalTime);
        mi = smoothstep(0.70, 0.75, mi);
        col = mix(col, col2, mi);

    }
    // popping activation record 0:render24:25:26
    // local variables: 
    // variable nor, unique name 0:render24:25:26:nor, index 260, declared at line 159, column 13
    // variable pos, unique name 0:render24:25:26:pos, index 261, declared at line 160, column 13
    // variable uvw, unique name 0:render24:25:26:uvw, index 262, declared at line 161, column 13
    // variable v1, unique name 0:render24:25:26:v1, index 263, declared at line 163, column 7
    // variable v2, unique name 0:render24:25:26:v2, index 264, declared at line 164, column 10
    // variable v3, unique name 0:render24:25:26:v3, index 265, declared at line 165, column 10
    // variable v4, unique name 0:render24:25:26:v4, index 266, declared at line 166, column 10
    // variable v5, unique name 0:render24:25:26:v5, index 267, declared at line 167, column 7
    // variable v6, unique name 0:render24:25:26:v6, index 268, declared at line 168, column 13
    // variable v7, unique name 0:render24:25:26:v7, index 269, declared at line 169, column 10
    // variable v8, unique name 0:render24:25:26:v8, index 270, declared at line 170, column 10
    // variable v9, unique name 0:render24:25:26:v9, index 271, declared at line 171, column 10
    // variable v10, unique name 0:render24:25:26:v10, index 272, declared at line 172, column 10
    // variable v11, unique name 0:render24:25:26:v11, index 273, declared at line 173, column 10
    // variable v12, unique name 0:render24:25:26:v12, index 274, declared at line 174, column 10
    // variable v13, unique name 0:render24:25:26:v13, index 275, declared at line 175, column 11
    // variable v14, unique name 0:render24:25:26:v14, index 276, declared at line 176, column 10
    // variable v15, unique name 0:render24:25:26:v15, index 277, declared at line 177, column 10
    // variable v16, unique name 0:render24:25:26:v16, index 278, declared at line 178, column 10
    // variable vc, unique name 0:render24:25:26:vc, index 279, declared at line 180, column 7
    // variable vd, unique name 0:render24:25:26:vd, index 280, declared at line 181, column 10
    // variable va, unique name 0:render24:25:26:va, index 281, declared at line 182, column 10
    // variable vb, unique name 0:render24:25:26:vb, index 282, declared at line 183, column 10
    // variable uv, unique name 0:render24:25:26:uv, index 283, declared at line 185, column 7
    // variable www, unique name 0:render24:25:26:www, index 284, declared at line 188, column 14
    // variable wir, unique name 0:render24:25:26:wir, index 285, declared at line 190, column 13
    // variable vvv, unique name 0:render24:25:26:vvv, index 286, declared at line 191, column 14
    // variable dif, unique name 0:render24:25:26:dif, index 287, declared at line 199, column 14
    // variable bac, unique name 0:render24:25:26:bac, index 288, declared at line 200, column 14
    // variable sky, unique name 0:render24:25:26:sky, index 289, declared at line 201, column 14
    // variable amb, unique name 0:render24:25:26:amb, index 290, declared at line 202, column 14
    // variable occ, unique name 0:render24:25:26:occ, index 291, declared at line 203, column 14
    // variable lin, unique name 0:render24:25:26:lin, index 292, declared at line 213, column 13
    // variable lineglow, unique name 0:render24:25:26:lineglow, index 293, declared at line 219, column 14
    // variable linCol, unique name 0:render24:25:26:linCol, index 294, declared at line 229, column 13
    // variable col2, unique name 0:render24:25:26:col2, index 295, declared at line 239, column 13
    // variable mi, unique name 0:render24:25:26:mi, index 296, declared at line 240, column 14
    // references:
    // dir at line 159, column 20
    // sign at line 159, column 24
    // rd at line 159, column 29
    // ro at line 160, column 19
    // rd at line 160, column 24
    // t at line 160, column 27
    // pos at line 161, column 19
    // vos at line 161, column 25
    // vos at line 163, column 13
    // nor at line 163, column 19
    // dir at line 163, column 25
    // vos at line 164, column 16
    // nor at line 164, column 22
    // dir at line 164, column 28
    // vos at line 165, column 16
    // nor at line 165, column 22
    // dir at line 165, column 28
    // vos at line 166, column 16
    // nor at line 166, column 22
    // dir at line 166, column 28
    // vos at line 167, column 13
    // nor at line 167, column 19
    // dir at line 167, column 25
    // dir at line 167, column 35
    // vos at line 168, column 19
    // nor at line 168, column 25
    // dir at line 168, column 31
    // dir at line 168, column 41
    // vos at line 169, column 16
    // nor at line 169, column 22
    // dir at line 169, column 28
    // dir at line 169, column 38
    // vos at line 170, column 16
    // nor at line 170, column 22
    // dir at line 170, column 28
    // dir at line 170, column 38
    // vos at line 171, column 16
    // dir at line 171, column 22
    // vos at line 172, column 16
    // dir at line 172, column 22
    // vos at line 173, column 16
    // dir at line 173, column 22
    // vos at line 174, column 16
    // dir at line 174, column 22
    // vos at line 175, column 17
    // dir at line 175, column 23
    // dir at line 175, column 33
    // vos at line 176, column 16
    // dir at line 176, column 22
    // dir at line 176, column 32
    // vos at line 177, column 16
    // dir at line 177, column 22
    // dir at line 177, column 32
    // vos at line 178, column 16
    // dir at line 178, column 22
    // dir at line 178, column 32
    // vec4 at line 180, column 12
    // map at line 180, column 18
    // v1 at line 180, column 22
    // map at line 180, column 28
    // v2 at line 180, column 32
    // map at line 180, column 38
    // v3 at line 180, column 42
    // map at line 180, column 48
    // v4 at line 180, column 52
    // vec4 at line 181, column 15
    // map at line 181, column 21
    // v5 at line 181, column 25
    // map at line 181, column 31
    // v6 at line 181, column 35
    // map at line 181, column 41
    // v7 at line 181, column 45
    // map at line 181, column 51
    // v8 at line 181, column 55
    // vec4 at line 182, column 15
    // map at line 182, column 21
    // v9 at line 182, column 25
    // map at line 182, column 31
    // v10 at line 182, column 35
    // map at line 182, column 41
    // v11 at line 182, column 45
    // map at line 182, column 51
    // v12 at line 182, column 55
    // vec4 at line 183, column 15
    // map at line 183, column 21
    // v13 at line 183, column 25
    // map at line 183, column 31
    // v14 at line 183, column 35
    // map at line 183, column 41
    // v15 at line 183, column 45
    // map at line 183, column 51
    // v16 at line 183, column 55
    // vec2 at line 185, column 12
    // dot at line 185, column 18
    // dir at line 185, column 22
    // uvw at line 185, column 31
    // dot at line 185, column 37
    // dir at line 185, column 41
    // uvw at line 185, column 50
    // isEdge at line 188, column 26
    // uv at line 188, column 34
    // va at line 188, column 38
    // vb at line 188, column 42
    // vc at line 188, column 46
    // vd at line 188, column 50
    // smoothstep at line 190, column 19
    // abs at line 190, column 41
    // uvw at line 190, column 45
    // wir at line 191, column 25
    // wir at line 191, column 31
    // wir at line 191, column 43
    // wir at line 191, column 49
    // wir at line 191, column 61
    // wir at line 191, column 67
    // col at line 193, column 8
    // texture at line 193, column 18
    // iChannel1 at line 193, column 27
    // pos at line 193, column 42
    // col at line 194, column 8
    // vec3 at line 194, column 19
    // col at line 195, column 8
    // texcube at line 195, column 25
    // iChannel2 at line 195, column 34
    // pos at line 195, column 49
    // nor at line 195, column 54
    // col at line 196, column 8
    // vvv at line 196, column 31
    // www at line 196, column 36
    // clamp at line 199, column 20
    // dot at line 199, column 27
    // nor at line 199, column 32
    // lig at line 199, column 37
    // clamp at line 200, column 20
    // dot at line 200, column 27
    // nor at line 200, column 32
    // normalize at line 200, column 37
    // lig at line 200, column 47
    // vec3 at line 200, column 51
    // nor at line 201, column 30
    // clamp at line 202, column 20
    // pos at line 202, column 33
    // occ at line 206, column 8
    // calcOcc at line 206, column 14
    // uv at line 206, column 23
    // va at line 206, column 27
    // vb at line 206, column 31
    // vc at line 206, column 35
    // vd at line 206, column 39
    // occ at line 207, column 8
    // occ at line 207, column 20
    // occ at line 208, column 8
    // occ at line 208, column 14
    // occ at line 208, column 18
    // occ at line 209, column 8
    // occ at line 209, column 14
    // occ at line 209, column 18
    // occ at line 210, column 8
    // amb at line 210, column 15
    // vec3 at line 213, column 19
    // lin at line 214, column 8
    // dif at line 214, column 19
    // vec3 at line 214, column 23
    // occ at line 214, column 53
    // lin at line 215, column 8
    // bac at line 215, column 19
    // vec3 at line 215, column 23
    // occ at line 215, column 44
    // lin at line 216, column 8
    // sky at line 216, column 19
    // vec3 at line 216, column 23
    // occ at line 216, column 44
    // lineglow at line 220, column 8
    // smoothstep at line 220, column 20
    // uv at line 220, column 46
    // va at line 220, column 58
    // vc at line 220, column 68
    // lineglow at line 221, column 8
    // smoothstep at line 221, column 20
    // uv at line 221, column 46
    // va at line 221, column 58
    // vc at line 221, column 68
    // lineglow at line 222, column 8
    // smoothstep at line 222, column 20
    // uv at line 222, column 46
    // va at line 222, column 58
    // vc at line 222, column 68
    // lineglow at line 223, column 8
    // smoothstep at line 223, column 20
    // uv at line 223, column 46
    // va at line 223, column 58
    // vc at line 223, column 68
    // lineglow at line 224, column 8
    // smoothstep at line 224, column 20
    // uv at line 224, column 47
    // uv at line 224, column 58
    // vb at line 224, column 70
    // vd at line 224, column 80
    // lineglow at line 225, column 8
    // smoothstep at line 225, column 20
    // uv at line 225, column 47
    // uv at line 225, column 58
    // vb at line 225, column 70
    // vd at line 225, column 80
    // lineglow at line 226, column 8
    // smoothstep at line 226, column 20
    // uv at line 226, column 47
    // uv at line 226, column 58
    // vb at line 226, column 70
    // vd at line 226, column 80
    // lineglow at line 227, column 8
    // smoothstep at line 227, column 20
    // uv at line 227, column 47
    // uv at line 227, column 58
    // vb at line 227, column 70
    // vd at line 227, column 80
    // vec3 at line 229, column 26
    // linCol at line 230, column 8
    // occ at line 230, column 27
    // lin at line 231, column 8
    // lineglow at line 231, column 19
    // linCol at line 231, column 28
    // col at line 233, column 8
    // col at line 233, column 14
    // lin at line 233, column 18
    // col at line 234, column 8
    // linCol at line 234, column 19
    // vec3 at line 234, column 26
    // www at line 234, column 49
    // col at line 235, column 8
    // lineglow at line 235, column 19
    // linCol at line 235, column 28
    // col at line 236, column 8
    // min at line 236, column 15
    // exp at line 236, column 23
    // t at line 236, column 34
    // vec3 at line 239, column 20
    // nor at line 239, column 39
    // occ at line 239, column 46
    // www at line 239, column 50
    // vvv at line 239, column 63
    // exp at line 239, column 68
    // t at line 239, column 79
    // sin at line 240, column 19
    // iGlobalTime at line 240, column 33
    // mi at line 241, column 8
    // smoothstep at line 241, column 13
    // mi at line 241, column 37
    // col at line 242, column 8
    // mix at line 242, column 14
    // col at line 242, column 19
    // col2 at line 242, column 24
    // mi at line 242, column 30
    col = pow(col, vec3(0.45));
    return col;

}
// popping activation record 0:render24:25
// local variables: 
// variable col, unique name 0:render24:25:col, index 256, declared at line 152, column 9
// variable vos, unique name 0:render24:25:vos, index 257, declared at line 155, column 6
// variable dir, unique name 0:render24:25:dir, index 258, declared at line 155, column 11
// variable t, unique name 0:render24:25:t, index 259, declared at line 156, column 7
// references:
// vec3 at line 152, column 15
// castRay at line 156, column 11
// ro at line 156, column 20
// rd at line 156, column 24
// vos at line 156, column 28
// dir at line 156, column 33
// t at line 157, column 5
// col at line 246, column 1
// pow at line 246, column 7
// col at line 246, column 12
// vec3 at line 246, column 17
// col at line 248, column 11
// popping activation record 0:render24
// local variables: 
// variable ro, unique name 0:render24:ro, index 254, declared at line 150, column 21
// variable rd, unique name 0:render24:rd, index 255, declared at line 150, column 33
// references:
// pushing activation record 0:mainImage27
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage27:28
    vec2 q = fragCoord.xy / iResolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= iResolution.x / iResolution.y;
    vec2 mo = iMouse.xy / iResolution.xy;
    if (iMouse.w <= 0.00001) mo = vec2(0.0);
    float time = 2.0 * iGlobalTime + 50.0 * mo.x;
    float cr = 0.2 * cos(0.1 * iGlobalTime);
    vec3 ro = path(time + 0.0, 1.0);
    vec3 ta = path(time + 5.0, 1.0) - vec3(0.0, 6.0, 0.0);
    gro = ro;
    mat3 cam = setCamera(ro, ta, cr);
    float r2 = p.x * p.x * 0.32 + p.y * p.y;
    p *= (7.0 - sqrt(37.5 - 11.5 * r2)) / (r2 + 1.0);
    vec3 rd = normalize(cam * vec3(p.xy, -2.5));
    vec3 col = render(ro, rd);
    col *= 0.5 + 0.5 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.1);
    fragColor = vec4(col, 1.0);

}
// popping activation record 0:mainImage27:28
// local variables: 
// variable q, unique name 0:mainImage27:28:q, index 300, declared at line 254, column 6
// variable p, unique name 0:mainImage27:28:p, index 301, declared at line 255, column 9
// variable mo, unique name 0:mainImage27:28:mo, index 302, declared at line 258, column 9
// variable time, unique name 0:mainImage27:28:time, index 303, declared at line 261, column 7
// variable cr, unique name 0:mainImage27:28:cr, index 304, declared at line 263, column 7
// variable ro, unique name 0:mainImage27:28:ro, index 305, declared at line 264, column 6
// variable ta, unique name 0:mainImage27:28:ta, index 306, declared at line 265, column 6
// variable cam, unique name 0:mainImage27:28:cam, index 307, declared at line 268, column 9
// variable r2, unique name 0:mainImage27:28:r2, index 308, declared at line 271, column 10
// variable rd, unique name 0:mainImage27:28:rd, index 309, declared at line 273, column 9
// variable col, unique name 0:mainImage27:28:col, index 310, declared at line 275, column 9
// references:
// fragCoord at line 254, column 10
// iResolution at line 254, column 25
// q at line 255, column 24
// p at line 256, column 4
// iResolution at line 256, column 11
// iResolution at line 256, column 26
// iMouse at line 258, column 14
// iResolution at line 258, column 26
// iMouse at line 259, column 8
// mo at line 259, column 28
// vec2 at line 259, column 31
// iGlobalTime at line 261, column 18
// mo at line 261, column 37
// cos at line 263, column 16
// iGlobalTime at line 263, column 24
// path at line 264, column 11
// time at line 264, column 17
// path at line 265, column 11
// time at line 265, column 17
// vec3 at line 265, column 35
// gro at line 266, column 1
// ro at line 266, column 7
// setCamera at line 268, column 15
// ro at line 268, column 26
// ta at line 268, column 30
// cr at line 268, column 34
// p at line 271, column 15
// p at line 271, column 19
// p at line 271, column 30
// p at line 271, column 34
// p at line 272, column 4
// sqrt at line 272, column 14
// r2 at line 272, column 29
// r2 at line 272, column 35
// normalize at line 273, column 14
// cam at line 273, column 25
// vec3 at line 273, column 31
// p at line 273, column 36
// render at line 275, column 15
// ro at line 275, column 23
// rd at line 275, column 27
// col at line 278, column 1
// pow at line 278, column 18
// q at line 278, column 28
// q at line 278, column 32
// q at line 278, column 41
// q at line 278, column 51
// fragColor at line 280, column 1
// vec4 at line 280, column 13
// col at line 280, column 19
// popping activation record 0:mainImage27
// local variables: 
// variable fragColor, unique name 0:mainImage27:fragColor, index 298, declared at line 251, column 25
// variable fragCoord, unique name 0:mainImage27:fragCoord, index 299, declared at line 251, column 44
// references:
// pushing activation record 0:mainVR29
void mainVR(out vec4 fragColor, in vec2 fragCoord, in vec3 fragRayOri, in vec3 fragRayDir)
{
// pushing activation record 0:mainVR29:30
    float time = 1.0 * iGlobalTime;
    float cr = 0.0;
    vec3 ro = path(time + 0.0, 0.0) + vec3(0.0, 0.7, 0.0);
    vec3 ta = path(time + 2.5, 0.0) + vec3(0.0, 0.7, 0.0);
    mat3 cam = setCamera(ro, ta, cr);
    vec3 col = render(ro + cam * fragRayOri, cam * fragRayDir);
    fragColor = vec4(col, 1.0);

}
// popping activation record 0:mainVR29:30
// local variables: 
// variable time, unique name 0:mainVR29:30:time, index 316, declared at line 285, column 7
// variable cr, unique name 0:mainVR29:30:cr, index 317, declared at line 287, column 10
// variable ro, unique name 0:mainVR29:30:ro, index 318, declared at line 288, column 6
// variable ta, unique name 0:mainVR29:30:ta, index 319, declared at line 289, column 6
// variable cam, unique name 0:mainVR29:30:cam, index 320, declared at line 291, column 9
// variable col, unique name 0:mainVR29:30:col, index 321, declared at line 293, column 9
// references:
// iGlobalTime at line 285, column 18
// path at line 288, column 11
// time at line 288, column 17
// vec3 at line 288, column 35
// path at line 289, column 11
// time at line 289, column 17
// vec3 at line 289, column 35
// setCamera at line 291, column 15
// ro at line 291, column 26
// ta at line 291, column 30
// cr at line 291, column 34
// render at line 293, column 15
// ro at line 293, column 23
// cam at line 293, column 28
// fragRayOri at line 293, column 32
// cam at line 293, column 44
// fragRayDir at line 293, column 48
// fragColor at line 295, column 4
// vec4 at line 295, column 16
// col at line 295, column 22
// popping activation record 0:mainVR29
// local variables: 
// variable fragColor, unique name 0:mainVR29:fragColor, index 312, declared at line 283, column 22
// variable fragCoord, unique name 0:mainVR29:fragCoord, index 313, declared at line 283, column 41
// variable fragRayOri, unique name 0:mainVR29:fragRayOri, index 314, declared at line 283, column 60
// variable fragRayDir, unique name 0:mainVR29:fragRayDir, index 315, declared at line 283, column 80
// references:
// undefined variables 
