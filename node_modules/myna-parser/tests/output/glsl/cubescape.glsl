// pushing activation record 0
// pushing activation record 0:hash1
float hash(float n)
{
// pushing activation record 0:hash1:2
    return fract(sin(n) * 13.5453123);

}
// popping activation record 0:hash1:2
// local variables: 
// references:
// fract at line 9, column 31
// sin at line 9, column 37
// n at line 9, column 41
// popping activation record 0:hash1
// local variables: 
// variable n, unique name 0:hash1:n, index 179, declared at line 9, column 18
// references:
// pushing activation record 0:maxcomp3
float maxcomp(in vec3 v)
{
// pushing activation record 0:maxcomp3:4
    return max(max(v.x, v.y), v.z);

}
// popping activation record 0:maxcomp3:4
// local variables: 
// references:
// max at line 11, column 36
// max at line 11, column 41
// v at line 11, column 46
// v at line 11, column 51
// v at line 11, column 58
// popping activation record 0:maxcomp3
// local variables: 
// variable v, unique name 0:maxcomp3:v, index 181, declared at line 11, column 23
// references:
// pushing activation record 0:dbox5
float dbox(vec3 p, vec3 b, float r)
{
// pushing activation record 0:dbox5:6
    return length(max(abs(p) - b, 0.0)) - r;

}
// popping activation record 0:dbox5:6
// local variables: 
// references:
// length at line 15, column 11
// max at line 15, column 18
// abs at line 15, column 22
// p at line 15, column 26
// b at line 15, column 29
// r at line 15, column 37
// popping activation record 0:dbox5
// local variables: 
// variable p, unique name 0:dbox5:p, index 183, declared at line 13, column 17
// variable b, unique name 0:dbox5:b, index 184, declared at line 13, column 25
// variable r, unique name 0:dbox5:r, index 185, declared at line 13, column 34
// references:
// pushing activation record 0:texcube7
vec4 texcube(sampler2D sam, in vec3 p, in vec3 n)
{
// pushing activation record 0:texcube7:8
    vec4 x = texture(sam, p.yz);
    vec4 y = texture(sam, p.zx);
    vec4 z = texture(sam, p.yx);
    vec3 a = abs(n);
    return (x * a.x + y * a.y + z * a.z) / (a.x + a.y + a.z);

}
// popping activation record 0:texcube7:8
// local variables: 
// variable x, unique name 0:texcube7:8:x, index 190, declared at line 20, column 6
// variable y, unique name 0:texcube7:8:y, index 191, declared at line 21, column 6
// variable z, unique name 0:texcube7:8:z, index 192, declared at line 22, column 6
// variable a, unique name 0:texcube7:8:a, index 193, declared at line 23, column 9
// references:
// texture at line 20, column 10
// sam at line 20, column 19
// p at line 20, column 24
// texture at line 21, column 10
// sam at line 21, column 19
// p at line 21, column 24
// texture at line 22, column 10
// sam at line 22, column 19
// p at line 22, column 24
// abs at line 23, column 13
// n at line 23, column 17
// x at line 24, column 9
// a at line 24, column 11
// y at line 24, column 17
// a at line 24, column 19
// z at line 24, column 25
// a at line 24, column 27
// a at line 24, column 35
// a at line 24, column 41
// a at line 24, column 47
// popping activation record 0:texcube7
// local variables: 
// variable sam, unique name 0:texcube7:sam, index 187, declared at line 18, column 24
// variable p, unique name 0:texcube7:p, index 188, declared at line 18, column 37
// variable n, unique name 0:texcube7:n, index 189, declared at line 18, column 48
// references:
float freqs[4];
// pushing activation record 0:mapH9
vec3 mapH(in vec2 pos)
{
// pushing activation record 0:mapH9:10
    vec2 fpos = fract(pos);
    vec2 ipos = floor(pos);
    float f = 0.0;
    float id = hash(ipos.x + ipos.y * 57.0);
    f += freqs[0] * clamp(1.0 - abs(id - 0.20) / 0.30, 0.0, 1.0);
    f += freqs[1] * clamp(1.0 - abs(id - 0.40) / 0.30, 0.0, 1.0);
    f += freqs[2] * clamp(1.0 - abs(id - 0.60) / 0.30, 0.0, 1.0);
    f += freqs[3] * clamp(1.0 - abs(id - 0.80) / 0.30, 0.0, 1.0);
    f = pow(clamp(f, 0.0, 1.0), 2.0);
    float h = 2.5 * f;
    return vec3(h, id, f);

}
// popping activation record 0:mapH9:10
// local variables: 
// variable fpos, unique name 0:mapH9:10:fpos, index 197, declared at line 33, column 6
// variable ipos, unique name 0:mapH9:10:ipos, index 198, declared at line 34, column 6
// variable f, unique name 0:mapH9:10:f, index 199, declared at line 36, column 10
// variable id, unique name 0:mapH9:10:id, index 200, declared at line 37, column 7
// variable h, unique name 0:mapH9:10:h, index 201, declared at line 44, column 10
// references:
// fract at line 33, column 13
// pos at line 33, column 20
// floor at line 34, column 13
// pos at line 34, column 20
// hash at line 37, column 12
// ipos at line 37, column 18
// ipos at line 37, column 27
// f at line 38, column 1
// freqs at line 38, column 6
// clamp at line 38, column 17
// abs at line 38, column 29
// id at line 38, column 33
// f at line 39, column 1
// freqs at line 39, column 6
// clamp at line 39, column 17
// abs at line 39, column 29
// id at line 39, column 33
// f at line 40, column 1
// freqs at line 40, column 6
// clamp at line 40, column 17
// abs at line 40, column 29
// id at line 40, column 33
// f at line 41, column 1
// freqs at line 41, column 6
// clamp at line 41, column 17
// abs at line 41, column 29
// id at line 41, column 33
// f at line 43, column 4
// pow at line 43, column 8
// clamp at line 43, column 13
// f at line 43, column 20
// f at line 44, column 18
// vec3 at line 46, column 11
// h at line 46, column 17
// id at line 46, column 20
// f at line 46, column 24
// popping activation record 0:mapH9
// local variables: 
// variable pos, unique name 0:mapH9:pos, index 196, declared at line 31, column 19
// references:
// pushing activation record 0:map11
vec3 map(in vec3 pos)
{
// pushing activation record 0:map11:12
    vec2 p = fract(pos.xz);
    vec3 m = mapH(pos.xz);
    float d = dbox(vec3(p.x - 0.5, pos.y - 0.5 * m.x, p.y - 0.5), vec3(0.3, m.x * 0.5, 0.3), 0.1);
    return vec3(d, m.yz);

}
// popping activation record 0:map11:12
// local variables: 
// variable p, unique name 0:map11:12:p, index 204, declared at line 51, column 7
// variable m, unique name 0:map11:12:m, index 205, declared at line 52, column 10
// variable d, unique name 0:map11:12:d, index 206, declared at line 53, column 7
// references:
// fract at line 51, column 11
// pos at line 51, column 18
// mapH at line 52, column 14
// pos at line 52, column 20
// dbox at line 53, column 11
// vec3 at line 53, column 17
// p at line 53, column 22
// pos at line 53, column 30
// m at line 53, column 40
// p at line 53, column 44
// vec3 at line 53, column 54
// m at line 53, column 63
// vec3 at line 54, column 11
// d at line 54, column 17
// m at line 54, column 20
// popping activation record 0:map11
// local variables: 
// variable pos, unique name 0:map11:pos, index 203, declared at line 49, column 18
// references:
const float surface = 0.001;
// pushing activation record 0:trace13
vec3 trace(vec3 ro, in vec3 rd, in float tmin, in float tmax)
{
// pushing activation record 0:trace13:14
    ro += tmin * rd;
    vec2 pos = floor(ro.xz);
    vec3 rdi = 1.0 / rd;
    vec3 rda = abs(rdi);
    vec2 rds = sign(rd.xz);
    vec2 dis = (pos - ro.xz + 0.5 + rds * 0.5) * rdi.xz;
    vec3 res = vec3(-1.0);
    vec2 mm = vec2(0.0);
    // pushing activation record 0:trace13:14:for15
    for (int i = 0; i < 28; i++) {
    // pushing activation record 0:trace13:14:for15:16
        vec3 cub = mapH(pos);
        #if 1
            
vec2 pr = pos + 0.5 - ro.xz;
        vec2 mini = (pr - 0.5 * rds) * rdi.xz;
        float s = max(mini.x, mini.y);
        if ((tmin + s) > tmax) break;
        #endif
        
        
        // intersect box
		
vec3 ce = vec3(pos.x + 0.5, 0.5 * cub.x, pos.y + 0.5);
        vec3 rb = vec3(0.3, cub.x * 0.5, 0.3);
        vec3 ra = rb + 0.12;
        vec3 rc = ro - ce;
        float tN = maxcomp(-rdi * rc - rda * ra);
        float tF = maxcomp(-rdi * rc + rda * ra);
        if (tN < tF) {
        // pushing activation record 0:trace13:14:for15:16:17
            float s = tN;
            float h = 1.0;
            // pushing activation record 0:trace13:14:for15:16:17:for18
            for (int j = 0; j < 24; j++) {
            // pushing activation record 0:trace13:14:for15:16:17:for18:19
                h = dbox(rc + s * rd, rb, 0.1);
                s += h;
                if (s > tF) break;

            }
            // popping activation record 0:trace13:14:for15:16:17:for18:19
            // local variables: 
            // references:
            // h at line 99, column 16
            // dbox at line 99, column 20
            // rc at line 99, column 26
            // s at line 99, column 29
            // rd at line 99, column 31
            // rb at line 99, column 35
            // s at line 100, column 16
            // h at line 100, column 21
            // s at line 101, column 20
            // tF at line 101, column 22
            // popping activation record 0:trace13:14:for15:16:17:for18
            // local variables: 
            // variable j, unique name 0:trace13:14:for15:16:17:for18:j, index 233, declared at line 97, column 21
            // references:
            // j at line 97, column 26
            // j at line 97, column 32
            if (h < (surface * s * 2.0)) {
            // pushing activation record 0:trace13:14:for15:16:17:20
                res = vec3(s, cub.yz);
                break;

            }
            // popping activation record 0:trace13:14:for15:16:17:20
            // local variables: 
            // references:
            // res at line 106, column 16
            // vec3 at line 106, column 22
            // s at line 106, column 28
            // cub at line 106, column 31

        }
        // popping activation record 0:trace13:14:for15:16:17
        // local variables: 
        // variable s, unique name 0:trace13:14:for15:16:17:s, index 231, declared at line 95, column 18
        // variable h, unique name 0:trace13:14:for15:16:17:h, index 232, declared at line 96, column 18
        // references:
        // tN at line 95, column 22
        // h at line 104, column 16
        // surface at line 104, column 21
        // s at line 104, column 29
        mm = step(dis.xy, dis.yx);
        dis += mm * rda.xz;
        pos += mm * rds;

    }
    // popping activation record 0:trace13:14:for15:16
    // local variables: 
    // variable cub, unique name 0:trace13:14:for15:16:cub, index 221, declared at line 75, column 13
    // variable pr, unique name 0:trace13:14:for15:16:pr, index 222, declared at line 78, column 17
    // variable mini, unique name 0:trace13:14:for15:16:mini, index 223, declared at line 79, column 8
    // variable s, unique name 0:trace13:14:for15:16:s, index 224, declared at line 80, column 15
    // variable ce, unique name 0:trace13:14:for15:16:ce, index 225, declared at line 86, column 8
    // variable rb, unique name 0:trace13:14:for15:16:rb, index 226, declared at line 87, column 14
    // variable ra, unique name 0:trace13:14:for15:16:ra, index 227, declared at line 88, column 14
    // variable rc, unique name 0:trace13:14:for15:16:rc, index 228, declared at line 89, column 8
    // variable tN, unique name 0:trace13:14:for15:16:tN, index 229, declared at line 90, column 14
    // variable tF, unique name 0:trace13:14:for15:16:tF, index 230, declared at line 91, column 14
    // references:
    // mapH at line 75, column 19
    // pos at line 75, column 25
    // pos at line 78, column 22
    // ro at line 78, column 30
    // pr at line 79, column 16
    // rds at line 79, column 23
    // rdi at line 79, column 28
    // max at line 80, column 19
    // mini at line 80, column 24
    // mini at line 80, column 32
    // tmin at line 81, column 17
    // s at line 81, column 22
    // tmax at line 81, column 25
    // vec3 at line 86, column 13
    // pos at line 86, column 19
    // cub at line 86, column 34
    // pos at line 86, column 41
    // vec3 at line 87, column 19
    // cub at line 87, column 28
    // rb at line 88, column 19
    // ro at line 89, column 13
    // ce at line 89, column 18
    // maxcomp at line 90, column 19
    // rdi at line 90, column 29
    // rc at line 90, column 33
    // rda at line 90, column 38
    // ra at line 90, column 42
    // maxcomp at line 91, column 19
    // rdi at line 91, column 29
    // rc at line 91, column 33
    // rda at line 91, column 38
    // ra at line 91, column 42
    // tN at line 92, column 12
    // tF at line 92, column 17
    // mm at line 113, column 2
    // step at line 113, column 7
    // dis at line 113, column 13
    // dis at line 113, column 21
    // dis at line 114, column 2
    // mm at line 114, column 9
    // rda at line 114, column 12
    // pos at line 115, column 8
    // mm at line 115, column 15
    // rds at line 115, column 18
    // popping activation record 0:trace13:14:for15
    // local variables: 
    // variable i, unique name 0:trace13:14:for15:i, index 220, declared at line 73, column 10
    // references:
    // i at line 73, column 15
    // i at line 73, column 21
    res.x += tmin;
    return res;

}
// popping activation record 0:trace13:14
// local variables: 
// variable pos, unique name 0:trace13:14:pos, index 213, declared at line 63, column 6
// variable rdi, unique name 0:trace13:14:rdi, index 214, declared at line 64, column 9
// variable rda, unique name 0:trace13:14:rda, index 215, declared at line 65, column 9
// variable rds, unique name 0:trace13:14:rds, index 216, declared at line 66, column 6
// variable dis, unique name 0:trace13:14:dis, index 217, declared at line 67, column 6
// variable res, unique name 0:trace13:14:res, index 218, declared at line 69, column 6
// variable mm, unique name 0:trace13:14:mm, index 219, declared at line 72, column 6
// references:
// ro at line 61, column 4
// tmin at line 61, column 10
// rd at line 61, column 15
// floor at line 63, column 12
// ro at line 63, column 18
// rd at line 64, column 19
// abs at line 65, column 15
// rdi at line 65, column 19
// sign at line 66, column 12
// rd at line 66, column 17
// pos at line 67, column 13
// ro at line 67, column 17
// rds at line 67, column 30
// rdi at line 67, column 41
// vec3 at line 69, column 12
// vec2 at line 72, column 11
// res at line 118, column 4
// tmin at line 118, column 13
// res at line 120, column 8
// popping activation record 0:trace13
// local variables: 
// variable ro, unique name 0:trace13:ro, index 209, declared at line 59, column 17
// variable rd, unique name 0:trace13:rd, index 210, declared at line 59, column 29
// variable tmin, unique name 0:trace13:tmin, index 211, declared at line 59, column 42
// variable tmax, unique name 0:trace13:tmax, index 212, declared at line 59, column 57
// references:
// pushing activation record 0:softshadow21
float softshadow(in vec3 ro, in vec3 rd, in float mint, in float maxt, in float k)
{
// pushing activation record 0:softshadow21:22
    float res = 1.0;
    float t = mint;
    // pushing activation record 0:softshadow21:22:for23
    for (int i = 0; i < 50; i++) {
    // pushing activation record 0:softshadow21:22:for23:24
        float h = map(ro + rd * t).x;
        res = min(res, k * h / t);
        t += clamp(h, 0.05, 0.2);
        if (res < 0.001 || t > maxt) break;

    }
    // popping activation record 0:softshadow21:22:for23:24
    // local variables: 
    // variable h, unique name 0:softshadow21:22:for23:24:h, index 243, declared at line 130, column 14
    // references:
    // map at line 130, column 18
    // ro at line 130, column 23
    // rd at line 130, column 28
    // t at line 130, column 31
    // res at line 131, column 8
    // min at line 131, column 14
    // res at line 131, column 19
    // k at line 131, column 24
    // h at line 131, column 26
    // t at line 131, column 28
    // t at line 132, column 8
    // clamp at line 132, column 13
    // h at line 132, column 20
    // res at line 133, column 12
    // t at line 133, column 25
    // maxt at line 133, column 27
    // popping activation record 0:softshadow21:22:for23
    // local variables: 
    // variable i, unique name 0:softshadow21:22:for23:i, index 242, declared at line 128, column 13
    // references:
    // i at line 128, column 18
    // i at line 128, column 24
    return clamp(res, 0.0, 1.0);

}
// popping activation record 0:softshadow21:22
// local variables: 
// variable res, unique name 0:softshadow21:22:res, index 240, declared at line 126, column 10
// variable t, unique name 0:softshadow21:22:t, index 241, declared at line 127, column 10
// references:
// mint at line 127, column 14
// clamp at line 135, column 11
// res at line 135, column 18
// popping activation record 0:softshadow21
// local variables: 
// variable ro, unique name 0:softshadow21:ro, index 235, declared at line 124, column 26
// variable rd, unique name 0:softshadow21:rd, index 236, declared at line 124, column 38
// variable mint, unique name 0:softshadow21:mint, index 237, declared at line 124, column 51
// variable maxt, unique name 0:softshadow21:maxt, index 238, declared at line 124, column 66
// variable k, unique name 0:softshadow21:k, index 239, declared at line 124, column 81
// references:
// pushing activation record 0:calcNormal25
vec3 calcNormal(in vec3 pos, in float t)
{
// pushing activation record 0:calcNormal25:26
    vec2 e = vec2(1.0, -1.0) * surface * t;
    return normalize(e.xyy * map(pos + e.xyy).x + e.yyx * map(pos + e.yyx).x + e.yxy * map(pos + e.yxy).x + e.xxx * map(pos + e.xxx).x);

}
// popping activation record 0:calcNormal25:26
// local variables: 
// variable e, unique name 0:calcNormal25:26:e, index 247, declared at line 140, column 9
// references:
// vec2 at line 140, column 13
// surface at line 140, column 28
// t at line 140, column 36
// normalize at line 141, column 11
// e at line 141, column 22
// map at line 141, column 28
// pos at line 141, column 33
// e at line 141, column 39
// e at line 142, column 7
// map at line 142, column 13
// pos at line 142, column 18
// e at line 142, column 24
// e at line 143, column 7
// map at line 143, column 13
// pos at line 143, column 18
// e at line 143, column 24
// e at line 144, column 7
// map at line 144, column 13
// pos at line 144, column 18
// e at line 144, column 24
// popping activation record 0:calcNormal25
// local variables: 
// variable pos, unique name 0:calcNormal25:pos, index 245, declared at line 138, column 25
// variable t, unique name 0:calcNormal25:t, index 246, declared at line 138, column 39
// references:
const vec3 light1 = vec3(0.70, 0.52, -0.45);
const vec3 light2 = vec3(-0.71, 0.000, 0.71);
const vec3 lpos = vec3(0.0) + 6.0 * light1;
// pushing activation record 0:boundingVlume27
vec2 boundingVlume(vec2 tminmax, in vec3 ro, in vec3 rd)
{
// pushing activation record 0:boundingVlume27:28
    float bp = 2.7;
    float tp = (bp - ro.y) / rd.y;
    if (tp > 0.0) {
    // pushing activation record 0:boundingVlume27:28:29
        if (ro.y > bp) tminmax.x = max(tminmax.x, tp);

    }
    // popping activation record 0:boundingVlume27:28:29
    // local variables: 
    // references:
    // ro at line 157, column 12
    // bp at line 157, column 17
    // tminmax at line 157, column 22
    // max at line 157, column 34
    // tminmax at line 157, column 39
    // tp at line 157, column 50
    bp = 0.0;
    tp = (bp - ro.y) / rd.y;
    if (tp > 0.0) {
    // pushing activation record 0:boundingVlume27:28:30
        if (ro.y > bp) tminmax.y = min(tminmax.y, tp);

    }
    // popping activation record 0:boundingVlume27:28:30
    // local variables: 
    // references:
    // ro at line 164, column 12
    // bp at line 164, column 17
    // tminmax at line 164, column 22
    // min at line 164, column 34
    // tminmax at line 164, column 39
    // tp at line 164, column 50
    return tminmax;

}
// popping activation record 0:boundingVlume27:28
// local variables: 
// variable bp, unique name 0:boundingVlume27:28:bp, index 255, declared at line 153, column 10
// variable tp, unique name 0:boundingVlume27:28:tp, index 256, declared at line 154, column 10
// references:
// bp at line 154, column 16
// ro at line 154, column 19
// rd at line 154, column 25
// tp at line 155, column 8
// bp at line 160, column 4
// tp at line 161, column 4
// bp at line 161, column 10
// ro at line 161, column 13
// rd at line 161, column 19
// tp at line 162, column 8
// tminmax at line 166, column 11
// popping activation record 0:boundingVlume27
// local variables: 
// variable tminmax, unique name 0:boundingVlume27:tminmax, index 252, declared at line 151, column 25
// variable ro, unique name 0:boundingVlume27:ro, index 253, declared at line 151, column 42
// variable rd, unique name 0:boundingVlume27:rd, index 254, declared at line 151, column 54
// references:
// pushing activation record 0:doLighting31
vec3 doLighting(in vec3 col, in float ks, in vec3 pos, in vec3 nor, in vec3 rd)
{
// pushing activation record 0:doLighting31:32
    vec3 ldif = pos - lpos;
    float llen = length(ldif);
    ldif /= llen;
    float con = dot(-light1, ldif);
    float occ = mix(clamp(pos.y / 4.0, 0.0, 1.0), 1.0, max(0.0, nor.y));
    vec2 sminmax = vec2(0.01, 5.0);
    float sha = softshadow(pos, -ldif, sminmax.x, sminmax.y, 32.0);
    float bb = smoothstep(0.5, 0.8, con);
    float lkey = clamp(dot(nor, -ldif), 0.0, 1.0);
    vec3 lkat = vec3(1.0);
    lkat *= vec3(bb * bb * 0.6 + 0.4 * bb, bb * 0.5 + 0.5 * bb * bb, bb).zyx;
    lkat /= 1.0 + 0.25 * llen * llen;
    lkat *= 25.0;
    lkat *= sha;
    float lbac = clamp(0.1 + 0.9 * dot(light2, nor), 0.0, 1.0);
    lbac *= smoothstep(0.0, 0.8, con);
    lbac /= 1.0 + 0.2 * llen * llen;
    lbac *= 4.0;
    float lamb = 1.0 - 0.5 * nor.y;
    lamb *= 1.0 - smoothstep(10.0, 25.0, length(pos.xz));
    lamb *= 0.25 + 0.75 * smoothstep(0.0, 0.8, con);
    lamb *= 0.25;
    vec3 lin = 1.0 * vec3(0.20, 0.05, 0.02) * lamb * occ;
    lin += 1.0 * vec3(1.60, 0.70, 0.30) * lkey * lkat * (0.5 + 0.5 * occ);
    lin += 1.0 * vec3(0.70, 0.20, 0.08) * lbac * occ;
    lin *= vec3(1.3, 1.1, 1.0);
    col = col * lin;
    vec3 spe = vec3(1.0) * occ * lkat * pow(clamp(dot(reflect(rd, nor), -ldif), 0.0, 1.0), 4.0);
    col += (0.5 + 0.5 * ks) * 0.5 * spe * vec3(1.0, 0.9, 0.7);
    return col;

}
// popping activation record 0:doLighting31:32
// local variables: 
// variable ldif, unique name 0:doLighting31:32:ldif, index 263, declared at line 172, column 10
// variable llen, unique name 0:doLighting31:32:llen, index 264, declared at line 173, column 10
// variable con, unique name 0:doLighting31:32:con, index 265, declared at line 175, column 7
// variable occ, unique name 0:doLighting31:32:occ, index 266, declared at line 176, column 7
// variable sminmax, unique name 0:doLighting31:32:sminmax, index 267, declared at line 177, column 9
// variable sha, unique name 0:doLighting31:32:sha, index 268, declared at line 179, column 10
// variable bb, unique name 0:doLighting31:32:bb, index 269, declared at line 181, column 10
// variable lkey, unique name 0:doLighting31:32:lkey, index 270, declared at line 182, column 10
// variable lkat, unique name 0:doLighting31:32:lkat, index 271, declared at line 183, column 7
// variable lbac, unique name 0:doLighting31:32:lbac, index 272, declared at line 188, column 10
// variable lamb, unique name 0:doLighting31:32:lamb, index 273, declared at line 192, column 7
// variable lin, unique name 0:doLighting31:32:lin, index 274, declared at line 197, column 9
// variable spe, unique name 0:doLighting31:32:spe, index 275, declared at line 204, column 9
// references:
// pos at line 172, column 17
// lpos at line 172, column 23
// length at line 173, column 17
// ldif at line 173, column 25
// ldif at line 174, column 4
// llen at line 174, column 12
// dot at line 175, column 13
// light1 at line 175, column 18
// ldif at line 175, column 25
// mix at line 176, column 13
// clamp at line 176, column 18
// pos at line 176, column 25
// max at line 176, column 53
// nor at line 176, column 61
// vec2 at line 177, column 19
// softshadow at line 179, column 16
// pos at line 179, column 28
// ldif at line 179, column 34
// sminmax at line 179, column 40
// sminmax at line 179, column 51
// smoothstep at line 181, column 15
// con at line 181, column 37
// clamp at line 182, column 17
// dot at line 182, column 24
// nor at line 182, column 28
// ldif at line 182, column 33
// vec3 at line 183, column 14
// lkat at line 184, column 10
// vec3 at line 184, column 18
// bb at line 184, column 23
// bb at line 184, column 26
// bb at line 184, column 37
// bb at line 184, column 40
// bb at line 184, column 51
// bb at line 184, column 54
// bb at line 184, column 57
// lkat at line 185, column 10
// llen at line 185, column 27
// llen at line 185, column 32
// lkat at line 186, column 4
// lkat at line 187, column 10
// sha at line 187, column 18
// clamp at line 188, column 17
// dot at line 188, column 34
// light2 at line 188, column 39
// nor at line 188, column 47
// lbac at line 189, column 10
// smoothstep at line 189, column 18
// con at line 189, column 40
// lbac at line 190, column 4
// llen at line 190, column 20
// llen at line 190, column 25
// lbac at line 191, column 4
// nor at line 192, column 24
// lamb at line 193, column 10
// smoothstep at line 193, column 22
// length at line 193, column 46
// pos at line 193, column 53
// lamb at line 194, column 4
// smoothstep at line 194, column 24
// con at line 194, column 46
// lamb at line 195, column 4
// vec3 at line 197, column 20
// lamb at line 197, column 41
// occ at line 197, column 46
// lin at line 198, column 9
// vec3 at line 198, column 20
// lkey at line 198, column 41
// lkat at line 198, column 46
// occ at line 198, column 60
// lin at line 199, column 9
// vec3 at line 199, column 20
// lbac at line 199, column 41
// occ at line 199, column 46
// lin at line 200, column 9
// vec3 at line 200, column 16
// col at line 202, column 4
// col at line 202, column 10
// lin at line 202, column 14
// vec3 at line 204, column 15
// occ at line 204, column 25
// lkat at line 204, column 29
// pow at line 204, column 34
// clamp at line 204, column 39
// dot at line 204, column 45
// reflect at line 204, column 50
// rd at line 204, column 58
// nor at line 204, column 61
// ldif at line 204, column 68
// col at line 205, column 1
// ks at line 205, column 17
// spe at line 205, column 25
// vec3 at line 205, column 29
// col at line 207, column 11
// popping activation record 0:doLighting31
// local variables: 
// variable col, unique name 0:doLighting31:col, index 258, declared at line 169, column 25
// variable ks, unique name 0:doLighting31:ks, index 259, declared at line 169, column 39
// variable pos, unique name 0:doLighting31:pos, index 260, declared at line 170, column 25
// variable nor, unique name 0:doLighting31:nor, index 261, declared at line 170, column 38
// variable rd, unique name 0:doLighting31:rd, index 262, declared at line 170, column 51
// references:
// pushing activation record 0:setLookAt33
mat3 setLookAt(in vec3 ro, in vec3 ta, float cr)
{
// pushing activation record 0:setLookAt33:34
    vec3 cw = normalize(ta - ro);
    vec3 cp = vec3(sin(cr), cos(cr), 0.0);
    vec3 cu = normalize(cross(cw, cp));
    vec3 cv = normalize(cross(cu, cw));
    return mat3(cu, cv, cw);

}
// popping activation record 0:setLookAt33:34
// local variables: 
// variable cw, unique name 0:setLookAt33:34:cw, index 280, declared at line 212, column 7
// variable cp, unique name 0:setLookAt33:34:cp, index 281, declared at line 213, column 7
// variable cu, unique name 0:setLookAt33:34:cu, index 282, declared at line 214, column 7
// variable cv, unique name 0:setLookAt33:34:cv, index 283, declared at line 215, column 7
// references:
// normalize at line 212, column 12
// ta at line 212, column 22
// ro at line 212, column 25
// vec3 at line 213, column 12
// sin at line 213, column 17
// cr at line 213, column 21
// cos at line 213, column 26
// cr at line 213, column 30
// normalize at line 214, column 12
// cross at line 214, column 23
// cw at line 214, column 29
// cp at line 214, column 32
// normalize at line 215, column 12
// cross at line 215, column 23
// cu at line 215, column 29
// cw at line 215, column 32
// mat3 at line 216, column 11
// cu at line 216, column 17
// cv at line 216, column 21
// cw at line 216, column 25
// popping activation record 0:setLookAt33
// local variables: 
// variable ro, unique name 0:setLookAt33:ro, index 277, declared at line 210, column 24
// variable ta, unique name 0:setLookAt33:ta, index 278, declared at line 210, column 36
// variable cr, unique name 0:setLookAt33:cr, index 279, declared at line 210, column 46
// references:
// pushing activation record 0:render35
vec3 render(in vec3 ro, in vec3 rd)
{
// pushing activation record 0:render35:36
    vec3 col = vec3(0.0);
    vec2 tminmax = vec2(0.0, 40.0);
    tminmax = boundingVlume(tminmax, ro, rd);
    vec3 res = trace(ro, rd, tminmax.x, tminmax.y);
    if (res.y > -0.5) {
    // pushing activation record 0:render35:36:37
        float t = res.x;
        vec3 pos = ro + t * rd;
        vec3 nor = calcNormal(pos, t);
        col = 0.5 + 0.5 * cos(6.2831 * res.y + vec3(0.0, 0.4, 0.8));
        vec3 ff = texcube(iChannel1, 0.1 * vec3(pos.x, 4.0 * res.z - pos.y, pos.z), nor).xyz;
        col *= ff.x;
        col = doLighting(col, ff.x, pos, nor, rd);
        col *= 1.0 - smoothstep(20.0, 40.0, t);

    }
    // popping activation record 0:render35:36:37
    // local variables: 
    // variable t, unique name 0:render35:36:37:t, index 290, declared at line 231, column 14
    // variable pos, unique name 0:render35:36:37:pos, index 291, declared at line 232, column 13
    // variable nor, unique name 0:render35:36:37:nor, index 292, declared at line 233, column 13
    // variable ff, unique name 0:render35:36:37:ff, index 293, declared at line 237, column 13
    // references:
    // res at line 231, column 18
    // ro at line 232, column 19
    // t at line 232, column 24
    // rd at line 232, column 26
    // calcNormal at line 233, column 19
    // pos at line 233, column 31
    // t at line 233, column 36
    // col at line 236, column 8
    // cos at line 236, column 24
    // res at line 236, column 36
    // vec3 at line 236, column 44
    // texcube at line 237, column 18
    // iChannel1 at line 237, column 27
    // vec3 at line 237, column 42
    // pos at line 237, column 47
    // res at line 237, column 57
    // pos at line 237, column 63
    // pos at line 237, column 69
    // nor at line 237, column 77
    // col at line 238, column 8
    // ff at line 238, column 15
    // col at line 241, column 8
    // doLighting at line 241, column 14
    // col at line 241, column 26
    // ff at line 241, column 31
    // pos at line 241, column 37
    // nor at line 241, column 42
    // rd at line 241, column 47
    // col at line 242, column 8
    // smoothstep at line 242, column 21
    // t at line 242, column 45
    return col;

}
// popping activation record 0:render35:36
// local variables: 
// variable col, unique name 0:render35:36:col, index 287, declared at line 221, column 9
// variable tminmax, unique name 0:render35:36:tminmax, index 288, declared at line 223, column 9
// variable res, unique name 0:render35:36:res, index 289, declared at line 228, column 9
// references:
// vec3 at line 221, column 15
// vec2 at line 223, column 19
// tminmax at line 225, column 4
// boundingVlume at line 225, column 14
// tminmax at line 225, column 29
// ro at line 225, column 38
// rd at line 225, column 42
// trace at line 228, column 15
// ro at line 228, column 22
// rd at line 228, column 26
// tminmax at line 228, column 30
// tminmax at line 228, column 41
// res at line 229, column 8
// col at line 244, column 11
// popping activation record 0:render35
// local variables: 
// variable ro, unique name 0:render35:ro, index 285, declared at line 219, column 21
// variable rd, unique name 0:render35:rd, index 286, declared at line 219, column 33
// references:
// pushing activation record 0:mainImage38
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage38:39
    freqs[0] = texture(iChannel0, vec2(0.01, 0.25)).x;
    freqs[1] = texture(iChannel0, vec2(0.07, 0.25)).x;
    freqs[2] = texture(iChannel0, vec2(0.15, 0.25)).x;
    freqs[3] = texture(iChannel0, vec2(0.30, 0.25)).x;
    float time = 5.0 + 0.2 * iGlobalTime + 20.0 * iMouse.x / iResolution.x;
    vec3 tot = vec3(0.0);
    #ifdef ANTIALIAS
    
// pushing activation record 0:mainImage38:39:for40
    for (int i = 0; i < 4; i++) {
    // pushing activation record 0:mainImage38:39:for40:41
        vec2 off = vec2(mod(float(i), 2.0), mod(float(i / 2), 2.0)) / 2.0;
        #else
        
vec2 off = vec2(0.0);
        #endif        
        
vec2 xy = (-iResolution.xy + 2.0 * (fragCoord.xy + off)) / iResolution.y;
        vec3 ro = vec3(8.5 * cos(0.2 + .33 * time), 5.0 + 2.0 * cos(0.1 * time), 8.5 * sin(0.1 + 0.37 * time));
        vec3 ta = vec3(-2.5 + 3.0 * cos(1.2 + .41 * time), 0.0, 2.0 + 3.0 * sin(2.0 + 0.38 * time));
        float roll = 0.2 * sin(0.1 * time);
        mat3 ca = setLookAt(ro, ta, roll);
        vec3 rd = normalize(ca * vec3(xy.xy, 1.75));
        vec3 col = render(ro, rd);
        tot += pow(col, vec3(0.4545));
        #ifdef ANTIALIAS
    
    }
    // popping activation record 0:mainImage38:39:for40:41
    // local variables: 
    // variable off, unique name 0:mainImage38:39:for40:41:off, index 300, declared at line 262, column 13
    // variable off, unique name 0:mainImage38:39:for40:41:off, index 301, declared at line 264, column 13
    // variable xy, unique name 0:mainImage38:39:for40:41:xy, index 301, declared at line 266, column 13
    // variable ro, unique name 0:mainImage38:39:for40:41:ro, index 302, declared at line 269, column 13
    // variable ta, unique name 0:mainImage38:39:for40:41:ta, index 303, declared at line 270, column 13
    // variable roll, unique name 0:mainImage38:39:for40:41:roll, index 304, declared at line 271, column 14
    // variable ca, unique name 0:mainImage38:39:for40:41:ca, index 305, declared at line 274, column 13
    // variable rd, unique name 0:mainImage38:39:for40:41:rd, index 306, declared at line 275, column 13
    // variable col, unique name 0:mainImage38:39:for40:41:col, index 307, declared at line 277, column 13
    // references:
    // vec2 at line 262, column 19
    // mod at line 262, column 25
    // float at line 262, column 29
    // i at line 262, column 35
    // mod at line 262, column 44
    // float at line 262, column 48
    // i at line 262, column 54
    // vec2 at line 264, column 19
    // iResolution at line 266, column 20
    // fragCoord at line 266, column 40
    // off at line 266, column 53
    // iResolution at line 266, column 61
    // vec3 at line 269, column 18
    // cos at line 269, column 28
    // time at line 269, column 40
    // cos at line 269, column 55
    // time at line 269, column 63
    // sin at line 269, column 74
    // time at line 269, column 87
    // vec3 at line 270, column 18
    // cos at line 270, column 33
    // time at line 270, column 45
    // sin at line 270, column 65
    // time at line 270, column 78
    // sin at line 271, column 25
    // time at line 271, column 33
    // setLookAt at line 274, column 18
    // ro at line 274, column 29
    // ta at line 274, column 33
    // roll at line 274, column 37
    // normalize at line 275, column 18
    // ca at line 275, column 29
    // vec3 at line 275, column 34
    // xy at line 275, column 39
    // render at line 277, column 19
    // ro at line 277, column 27
    // rd at line 277, column 31
    // tot at line 279, column 8
    // pow at line 279, column 15
    // col at line 279, column 20
    // vec3 at line 279, column 25
    // popping activation record 0:mainImage38:39:for40
    // local variables: 
    // variable i, unique name 0:mainImage38:39:for40:i, index 299, declared at line 260, column 13
    // references:
    // i at line 260, column 18
    // i at line 260, column 23
    tot /= 4.0;
    #endif    
    
    // vigneting
	
vec2 q = fragCoord.xy / iResolution.xy;
    tot *= 0.2 + 0.8 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.1);
    fragColor = vec4(tot, 1.0);

}
// popping activation record 0:mainImage38:39
// local variables: 
// variable time, unique name 0:mainImage38:39:time, index 297, declared at line 256, column 10
// variable tot, unique name 0:mainImage38:39:tot, index 298, declared at line 258, column 9
// variable q, unique name 0:mainImage38:39:q, index 308, declared at line 286, column 6
// references:
// freqs at line 250, column 1
// texture at line 250, column 12
// iChannel0 at line 250, column 21
// vec2 at line 250, column 32
// freqs at line 251, column 1
// texture at line 251, column 12
// iChannel0 at line 251, column 21
// vec2 at line 251, column 32
// freqs at line 252, column 1
// texture at line 252, column 12
// iChannel0 at line 252, column 21
// vec2 at line 252, column 32
// freqs at line 253, column 1
// texture at line 253, column 12
// iChannel0 at line 253, column 21
// vec2 at line 253, column 32
// iGlobalTime at line 256, column 27
// iMouse at line 256, column 46
// iResolution at line 256, column 55
// vec3 at line 258, column 15
// tot at line 282, column 1
// fragCoord at line 286, column 10
// iResolution at line 286, column 23
// tot at line 287, column 4
// pow at line 287, column 21
// q at line 287, column 31
// q at line 287, column 35
// q at line 287, column 44
// q at line 287, column 54
// fragColor at line 289, column 4
// vec4 at line 289, column 14
// tot at line 289, column 20
// popping activation record 0:mainImage38
// local variables: 
// variable fragColor, unique name 0:mainImage38:fragColor, index 295, declared at line 248, column 25
// variable fragCoord, unique name 0:mainImage38:fragCoord, index 296, declared at line 248, column 44
// references:
// pushing activation record 0:mainVR42
void mainVR(out vec4 fragColor, in vec2 fragCoord, in vec3 fragRayOri, in vec3 fragRayDir)
{
// pushing activation record 0:mainVR42:43
    freqs[0] = texture(iChannel0, vec2(0.01, 0.25)).x;
    freqs[1] = texture(iChannel0, vec2(0.07, 0.25)).x;
    freqs[2] = texture(iChannel0, vec2(0.15, 0.25)).x;
    freqs[3] = texture(iChannel0, vec2(0.30, 0.25)).x;
    vec3 col = render(fragRayOri + vec3(0.0, 4.0, 0.0), fragRayDir);
    col += pow(col, vec3(0.4545));
    fragColor = vec4(col, 1.0);

}
// popping activation record 0:mainVR42:43
// local variables: 
// variable col, unique name 0:mainVR42:43:col, index 314, declared at line 300, column 9
// references:
// freqs at line 295, column 1
// texture at line 295, column 12
// iChannel0 at line 295, column 21
// vec2 at line 295, column 32
// freqs at line 296, column 1
// texture at line 296, column 12
// iChannel0 at line 296, column 21
// vec2 at line 296, column 32
// freqs at line 297, column 1
// texture at line 297, column 12
// iChannel0 at line 297, column 21
// vec2 at line 297, column 32
// freqs at line 298, column 1
// texture at line 298, column 12
// iChannel0 at line 298, column 21
// vec2 at line 298, column 32
// render at line 300, column 15
// fragRayOri at line 300, column 23
// vec3 at line 300, column 36
// fragRayDir at line 300, column 55
// col at line 302, column 4
// pow at line 302, column 11
// col at line 302, column 16
// vec3 at line 302, column 21
// fragColor at line 304, column 4
// vec4 at line 304, column 16
// col at line 304, column 22
// popping activation record 0:mainVR42
// local variables: 
// variable fragColor, unique name 0:mainVR42:fragColor, index 310, declared at line 293, column 22
// variable fragCoord, unique name 0:mainVR42:fragCoord, index 311, declared at line 293, column 41
// variable fragRayOri, unique name 0:mainVR42:fragRayOri, index 312, declared at line 293, column 60
// variable fragRayDir, unique name 0:mainVR42:fragRayDir, index 313, declared at line 293, column 80
// references:
// undefined variables 
