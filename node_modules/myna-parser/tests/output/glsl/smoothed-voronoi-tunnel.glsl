// pushing activation record 0
// pushing activation record 0:PrCylDf1
float PrCylDf(vec3 p, float r, float h)
;
// popping activation record 0:PrCylDf1
// local variables: 
// variable p, unique name 0:PrCylDf1:p, index 179, declared at line 7, column 20
// variable r, unique name 0:PrCylDf1:r, index 180, declared at line 7, column 29
// variable h, unique name 0:PrCylDf1:h, index 181, declared at line 7, column 38
// references:
// pushing activation record 0:Hashfv22
float Hashfv2(vec2 p)
;
// popping activation record 0:Hashfv22
// local variables: 
// variable p, unique name 0:Hashfv22:p, index 183, declared at line 8, column 20
// references:
// pushing activation record 0:Hashv2v23
vec2 Hashv2v2(vec2 p)
;
// popping activation record 0:Hashv2v23
// local variables: 
// variable p, unique name 0:Hashv2v23:p, index 185, declared at line 9, column 20
// references:
// pushing activation record 0:Noisefv24
float Noisefv2(vec2 p)
;
// popping activation record 0:Noisefv24
// local variables: 
// variable p, unique name 0:Noisefv24:p, index 187, declared at line 10, column 21
// references:
// pushing activation record 0:VaryNf5
vec3 VaryNf(vec3 p, vec3 n, float f)
;
// popping activation record 0:VaryNf5
// local variables: 
// variable p, unique name 0:VaryNf5:p, index 189, declared at line 11, column 18
// variable n, unique name 0:VaryNf5:n, index 190, declared at line 11, column 26
// variable f, unique name 0:VaryNf5:f, index 191, declared at line 11, column 35
// references:
// pushing activation record 0:SmoothMin6
float SmoothMin(float a, float b, float r)
;
// popping activation record 0:SmoothMin6
// local variables: 
// variable a, unique name 0:SmoothMin6:a, index 193, declared at line 12, column 23
// variable b, unique name 0:SmoothMin6:b, index 194, declared at line 12, column 32
// variable r, unique name 0:SmoothMin6:r, index 195, declared at line 12, column 41
// references:
// pushing activation record 0:Rot2D7
vec2 Rot2D(vec2 q, float a)
;
// popping activation record 0:Rot2D7
// local variables: 
// variable q, unique name 0:Rot2D7:q, index 197, declared at line 13, column 17
// variable a, unique name 0:Rot2D7:a, index 198, declared at line 13, column 26
// references:
// pushing activation record 0:HsvToRgb8
vec3 HsvToRgb(vec3 c)
;
// popping activation record 0:HsvToRgb8
// local variables: 
// variable c, unique name 0:HsvToRgb8:c, index 200, declared at line 14, column 20
// references:
vec3 ltDir;
vec2 gVec[7], hVec[7];
float dstFar, tCur, wdTun, htTun, lmpSep;
int idObj;
const int idWal = 1, idCeil = 2, idFlr = 3, idLmp = 4;
const float pi = 3.14159;
// pushing activation record 0:TrackPath9
float TrackPath(float t)
{
// pushing activation record 0:TrackPath9:10
    return wdTun * (0.7 * sin(0.005 * 2. * pi * t) + 0.4 * cos(0.009 * 2. * pi * t));

}
// popping activation record 0:TrackPath9:10
// local variables: 
// references:
// wdTun at line 25, column 9
// sin at line 25, column 24
// pi at line 25, column 42
// t at line 25, column 47
// cos at line 25, column 58
// pi at line 25, column 76
// t at line 25, column 81
// popping activation record 0:TrackPath9
// local variables: 
// variable t, unique name 0:TrackPath9:t, index 216, declared at line 23, column 23
// references:
#define SQRT3  1.73205

// pushing activation record 0:PixToHex11
vec2 PixToHex(vec2 p)
{
// pushing activation record 0:PixToHex11:12
    vec3 c, r, dr;
    c.xz = vec2((1. / SQRT3) * p.x - (1. / 3.) * p.y, (2. / 3.) * p.y);
    c.y = -c.x - c.z;
    r = floor(c + 0.5);
    dr = abs(r - c);
    r -= step(dr.yzx, dr) * step(dr.zxy, dr) * dot(r, vec3(1.));
    return r.xz;

}
// popping activation record 0:PixToHex11:12
// local variables: 
// variable c, unique name 0:PixToHex11:12:c, index 220, declared at line 32, column 7
// variable r, unique name 0:PixToHex11:12:r, index 221, declared at line 32, column 10
// variable dr, unique name 0:PixToHex11:12:dr, index 222, declared at line 32, column 13
// references:
// c at line 33, column 2
// vec2 at line 33, column 9
// SQRT3 at line 33, column 19
// p at line 33, column 28
// p at line 33, column 44
// p at line 33, column 59
// c at line 34, column 2
// c at line 34, column 10
// c at line 34, column 16
// r at line 35, column 2
// floor at line 35, column 6
// c at line 35, column 13
// dr at line 36, column 2
// abs at line 36, column 7
// r at line 36, column 12
// c at line 36, column 16
// r at line 37, column 2
// step at line 37, column 7
// dr at line 37, column 13
// dr at line 37, column 21
// step at line 37, column 27
// dr at line 37, column 33
// dr at line 37, column 41
// dot at line 37, column 47
// r at line 37, column 52
// vec3 at line 37, column 55
// r at line 38, column 9
// popping activation record 0:PixToHex11
// local variables: 
// variable p, unique name 0:PixToHex11:p, index 219, declared at line 30, column 20
// references:
// pushing activation record 0:HexToPix13
vec2 HexToPix(vec2 h)
{
// pushing activation record 0:HexToPix13:14
    return vec2(SQRT3 * (h.x + 0.5 * h.y), (3. / 2.) * h.y);

}
// popping activation record 0:HexToPix13:14
// local variables: 
// references:
// vec2 at line 43, column 9
// SQRT3 at line 43, column 15
// h at line 43, column 24
// h at line 43, column 36
// h at line 43, column 52
// popping activation record 0:HexToPix13
// local variables: 
// variable h, unique name 0:HexToPix13:h, index 224, declared at line 41, column 20
// references:
// pushing activation record 0:HexVorInit15
void HexVorInit()
{
// pushing activation record 0:HexVorInit15:16
    vec3 e = vec3(1., 0., -1.);
    gVec[0] = e.yy;
    gVec[1] = e.xy;
    gVec[2] = e.yx;
    gVec[3] = e.xz;
    gVec[4] = e.zy;
    gVec[5] = e.yz;
    gVec[6] = e.zx;
    // pushing activation record 0:HexVorInit15:16:for17
    for (int k = 0; k < 7; k++) hVec[k] = HexToPix(gVec[k]);
    // popping activation record 0:HexVorInit15:16:for17
    // local variables: 
    // variable k, unique name 0:HexVorInit15:16:for17:k, index 227, declared at line 56, column 11
    // references:
    // k at line 56, column 18
    // k at line 56, column 25
    // hVec at line 56, column 31
    // k at line 56, column 36
    // HexToPix at line 56, column 41
    // gVec at line 56, column 51
    // k at line 56, column 56

}
// popping activation record 0:HexVorInit15:16
// local variables: 
// variable e, unique name 0:HexVorInit15:16:e, index 226, declared at line 48, column 7
// references:
// vec3 at line 48, column 11
// gVec at line 49, column 2
// e at line 49, column 12
// gVec at line 50, column 2
// e at line 50, column 12
// gVec at line 51, column 2
// e at line 51, column 12
// gVec at line 52, column 2
// e at line 52, column 12
// gVec at line 53, column 2
// e at line 53, column 12
// gVec at line 54, column 2
// e at line 54, column 12
// gVec at line 55, column 2
// e at line 55, column 12
// popping activation record 0:HexVorInit15
// local variables: 
// references:
// pushing activation record 0:HexVor18
vec4 HexVor(vec2 p)
{
// pushing activation record 0:HexVor18:19
    vec4 sd, udm;
    vec2 ip, fp, d, u;
    float amp, a;
    amp = 0.7;
    ip = PixToHex(p);
    fp = p - HexToPix(ip);
    sd = vec4(4.);
    udm = vec4(4.);
    // pushing activation record 0:HexVor18:19:for20
    for (int k = 0; k < 7; k++) {
    // pushing activation record 0:HexVor18:19:for20:21
        u = Hashv2v2(ip + gVec[k]);
        a = 2. * pi * (u.y - 0.5);
        d = hVec[k] + amp * (0.4 + 0.6 * u.x) * vec2(cos(a), sin(a)) - fp;
        sd.w = dot(d, d);
        if (sd.w < sd.x) {
        // pushing activation record 0:HexVor18:19:for20:21:22
            sd = sd.wxyw;
            udm = vec4(d, u);

        }
        // popping activation record 0:HexVor18:19:for20:21:22
        // local variables: 
        // references:
        // sd at line 75, column 6
        // sd at line 75, column 11
        // udm at line 76, column 6
        // vec4 at line 76, column 12
        // d at line 76, column 18
        // u at line 76, column 21

    }
    // popping activation record 0:HexVor18:19:for20:21
    // local variables: 
    // references:
    // u at line 70, column 4
    // Hashv2v2 at line 70, column 8
    // ip at line 70, column 18
    // gVec at line 70, column 23
    // k at line 70, column 28
    // a at line 71, column 4
    // pi at line 71, column 13
    // u at line 71, column 19
    // d at line 72, column 4
    // hVec at line 72, column 8
    // k at line 72, column 13
    // amp at line 72, column 18
    // u at line 72, column 37
    // vec2 at line 72, column 44
    // cos at line 72, column 50
    // a at line 72, column 55
    // sin at line 72, column 59
    // a at line 72, column 64
    // fp at line 72, column 70
    // sd at line 73, column 4
    // dot at line 73, column 11
    // d at line 73, column 16
    // d at line 73, column 19
    // sd at line 74, column 8
    // sd at line 74, column 15
    // popping activation record 0:HexVor18:19:for20
    // local variables: 
    // variable k, unique name 0:HexVor18:19:for20:k, index 238, declared at line 69, column 11
    // references:
    // k at line 69, column 18
    // k at line 69, column 25
    sd.xyz = sqrt(sd.xyz);
    return vec4(SmoothMin(sd.y, sd.z, 0.3) - sd.x, udm.xy, Hashfv2(udm.zw));

}
// popping activation record 0:HexVor18:19
// local variables: 
// variable sd, unique name 0:HexVor18:19:sd, index 230, declared at line 61, column 7
// variable udm, unique name 0:HexVor18:19:udm, index 231, declared at line 61, column 11
// variable ip, unique name 0:HexVor18:19:ip, index 232, declared at line 62, column 7
// variable fp, unique name 0:HexVor18:19:fp, index 233, declared at line 62, column 11
// variable d, unique name 0:HexVor18:19:d, index 234, declared at line 62, column 15
// variable u, unique name 0:HexVor18:19:u, index 235, declared at line 62, column 18
// variable amp, unique name 0:HexVor18:19:amp, index 236, declared at line 63, column 8
// variable a, unique name 0:HexVor18:19:a, index 237, declared at line 63, column 13
// references:
// amp at line 64, column 2
// ip at line 65, column 2
// PixToHex at line 65, column 7
// p at line 65, column 17
// fp at line 66, column 2
// p at line 66, column 7
// HexToPix at line 66, column 11
// ip at line 66, column 21
// sd at line 67, column 2
// vec4 at line 67, column 7
// udm at line 68, column 2
// vec4 at line 68, column 8
// sd at line 79, column 2
// sqrt at line 79, column 11
// sd at line 79, column 17
// vec4 at line 80, column 9
// SmoothMin at line 80, column 15
// sd at line 80, column 26
// sd at line 80, column 32
// sd at line 80, column 45
// udm at line 80, column 51
// Hashfv2 at line 80, column 59
// udm at line 80, column 68
// popping activation record 0:HexVor18
// local variables: 
// variable p, unique name 0:HexVor18:p, index 229, declared at line 59, column 18
// references:
// pushing activation record 0:ObjDf23
float ObjDf(vec3 p)
{
// pushing activation record 0:ObjDf23:24
    vec4 vc;
    vec3 q;
    float dMin, d, db;
    dMin = dstFar;
    p.x -= TrackPath(p.z);
    q = p;
    q.y -= htTun;
    d = wdTun - abs(q.x);
    if (d < dMin) {
    // pushing activation record 0:ObjDf23:24:25
        dMin = d;
        idObj = idWal;

    }
    // popping activation record 0:ObjDf23:24:25
    // local variables: 
    // references:
    // dMin at line 93, column 18
    // d at line 93, column 25
    // idObj at line 93, column 29
    // idWal at line 93, column 37
    vc = HexVor(q.zx);
    d = q.y + htTun - 0.05 * smoothstep(0.05 + 0.03 * vc.w, 0.14 + 0.03 * vc.w, vc.x);
    if (d < dMin) {
    // pushing activation record 0:ObjDf23:24:26
        dMin = d;
        idObj = idFlr;

    }
    // popping activation record 0:ObjDf23:24:26
    // local variables: 
    // references:
    // dMin at line 96, column 18
    // d at line 96, column 25
    // idObj at line 96, column 29
    // idFlr at line 96, column 37
    q.y -= htTun;
    d = max(wdTun - length(q.xy), -q.y);
    if (d < dMin) {
    // pushing activation record 0:ObjDf23:24:27
        dMin = d;
        idObj = idCeil;

    }
    // popping activation record 0:ObjDf23:24:27
    // local variables: 
    // references:
    // dMin at line 99, column 18
    // d at line 99, column 25
    // idObj at line 99, column 29
    // idCeil at line 99, column 37
    q.z = mod(q.z + lmpSep, 2. * lmpSep) - lmpSep;
    q.y -= 0.5 * wdTun;
    d = PrCylDf(q.xzy, 0.1 * wdTun, 0.01 * wdTun);
    q.y -= 0.25 * wdTun;
    d = min(d, PrCylDf(q.xzy, 0.005 * wdTun, 0.25 * wdTun));
    q.y -= 0.25 * wdTun;
    d = min(d, PrCylDf(q.xzy, 0.05 * wdTun, 0.02 * wdTun));
    q.y -= -wdTun - htTun;
    if (d < dMin) {
    // pushing activation record 0:ObjDf23:24:28
        dMin = d;
        idObj = idLmp;

    }
    // popping activation record 0:ObjDf23:24:28
    // local variables: 
    // references:
    // dMin at line 108, column 18
    // d at line 108, column 25
    // idObj at line 108, column 29
    // idLmp at line 108, column 37
    return 0.8 * dMin;

}
// popping activation record 0:ObjDf23:24
// local variables: 
// variable vc, unique name 0:ObjDf23:24:vc, index 241, declared at line 85, column 7
// variable q, unique name 0:ObjDf23:24:q, index 242, declared at line 86, column 7
// variable dMin, unique name 0:ObjDf23:24:dMin, index 243, declared at line 87, column 8
// variable d, unique name 0:ObjDf23:24:d, index 244, declared at line 87, column 14
// variable db, unique name 0:ObjDf23:24:db, index 245, declared at line 87, column 17
// references:
// dMin at line 88, column 2
// dstFar at line 88, column 9
// p at line 89, column 2
// TrackPath at line 89, column 9
// p at line 89, column 20
// q at line 90, column 2
// p at line 90, column 6
// q at line 91, column 2
// htTun at line 91, column 9
// d at line 92, column 2
// wdTun at line 92, column 6
// abs at line 92, column 14
// q at line 92, column 19
// d at line 93, column 6
// dMin at line 93, column 10
// vc at line 94, column 2
// HexVor at line 94, column 7
// q at line 94, column 15
// d at line 95, column 2
// q at line 95, column 6
// htTun at line 95, column 12
// smoothstep at line 95, column 27
// vc at line 95, column 53
// vc at line 95, column 73
// vc at line 95, column 79
// d at line 96, column 6
// dMin at line 96, column 10
// q at line 97, column 2
// htTun at line 97, column 9
// d at line 98, column 2
// max at line 98, column 6
// wdTun at line 98, column 11
// length at line 98, column 19
// q at line 98, column 27
// q at line 98, column 36
// d at line 99, column 6
// dMin at line 99, column 10
// q at line 100, column 2
// mod at line 100, column 8
// q at line 100, column 13
// lmpSep at line 100, column 19
// lmpSep at line 100, column 32
// lmpSep at line 100, column 42
// q at line 101, column 2
// wdTun at line 101, column 15
// d at line 102, column 2
// PrCylDf at line 102, column 6
// q at line 102, column 15
// wdTun at line 102, column 28
// wdTun at line 102, column 42
// q at line 103, column 2
// wdTun at line 103, column 16
// d at line 104, column 2
// min at line 104, column 6
// d at line 104, column 11
// PrCylDf at line 104, column 14
// q at line 104, column 23
// wdTun at line 104, column 38
// wdTun at line 104, column 52
// q at line 105, column 2
// wdTun at line 105, column 16
// d at line 106, column 2
// min at line 106, column 6
// d at line 106, column 11
// PrCylDf at line 106, column 14
// q at line 106, column 23
// wdTun at line 106, column 37
// wdTun at line 106, column 51
// q at line 107, column 2
// wdTun at line 107, column 11
// htTun at line 107, column 19
// d at line 108, column 6
// dMin at line 108, column 10
// dMin at line 109, column 15
// popping activation record 0:ObjDf23
// local variables: 
// variable p, unique name 0:ObjDf23:p, index 240, declared at line 83, column 18
// references:
// pushing activation record 0:ObjRay29
float ObjRay(vec3 ro, vec3 rd)
{
// pushing activation record 0:ObjRay29:30
    float dHit, d;
    dHit = 0.;
    // pushing activation record 0:ObjRay29:30:for31
    for (int j = 0; j < 250; j++) {
    // pushing activation record 0:ObjRay29:30:for31:32
        d = ObjDf(ro + dHit * rd);
        dHit += d;
        if (d < 0.0005 || dHit > dstFar) break;

    }
    // popping activation record 0:ObjRay29:30:for31:32
    // local variables: 
    // references:
    // d at line 117, column 4
    // ObjDf at line 117, column 8
    // ro at line 117, column 15
    // dHit at line 117, column 20
    // rd at line 117, column 27
    // dHit at line 118, column 4
    // d at line 118, column 12
    // d at line 119, column 8
    // dHit at line 119, column 22
    // dstFar at line 119, column 29
    // popping activation record 0:ObjRay29:30:for31
    // local variables: 
    // variable j, unique name 0:ObjRay29:30:for31:j, index 251, declared at line 116, column 11
    // references:
    // j at line 116, column 18
    // j at line 116, column 27
    return dHit;

}
// popping activation record 0:ObjRay29:30
// local variables: 
// variable dHit, unique name 0:ObjRay29:30:dHit, index 249, declared at line 114, column 8
// variable d, unique name 0:ObjRay29:30:d, index 250, declared at line 114, column 14
// references:
// dHit at line 115, column 2
// dHit at line 121, column 9
// popping activation record 0:ObjRay29
// local variables: 
// variable ro, unique name 0:ObjRay29:ro, index 247, declared at line 112, column 19
// variable rd, unique name 0:ObjRay29:rd, index 248, declared at line 112, column 28
// references:
// pushing activation record 0:ObjNf33
vec3 ObjNf(vec3 p)
{
// pushing activation record 0:ObjNf33:34
    vec4 v;
    const vec3 e = vec3(0.001, -0.001, 0.);
    v = vec4(ObjDf(p + e.xxx), ObjDf(p + e.xyy), ObjDf(p + e.yxy), ObjDf(p + e.yyx));
    return normalize(vec3(v.x - v.y - v.z - v.w) + 2. * v.yzw);

}
// popping activation record 0:ObjNf33:34
// local variables: 
// variable v, unique name 0:ObjNf33:34:v, index 254, declared at line 126, column 7
// variable e, unique name 0:ObjNf33:34:e, index 255, declared at line 127, column 13
// references:
// vec3 at line 127, column 17
// v at line 128, column 2
// vec4 at line 128, column 6
// ObjDf at line 128, column 12
// p at line 128, column 19
// e at line 128, column 23
// ObjDf at line 128, column 31
// p at line 128, column 38
// e at line 128, column 42
// ObjDf at line 129, column 5
// p at line 129, column 12
// e at line 129, column 16
// ObjDf at line 129, column 24
// p at line 129, column 31
// e at line 129, column 35
// normalize at line 130, column 9
// vec3 at line 130, column 20
// v at line 130, column 26
// v at line 130, column 32
// v at line 130, column 38
// v at line 130, column 44
// v at line 130, column 56
// popping activation record 0:ObjNf33
// local variables: 
// variable p, unique name 0:ObjNf33:p, index 253, declared at line 124, column 17
// references:
// pushing activation record 0:ShowScene35
vec3 ShowScene(vec3 ro, vec3 rd)
{
// pushing activation record 0:ShowScene35:36
    vec4 vc;
    vec3 vn, col, q;
    float dstObj, bh, s, spec, att;
    HexVorInit();
    dstObj = ObjRay(ro, rd);
    if (dstObj < dstFar) {
    // pushing activation record 0:ShowScene35:36:37
        ro += rd * dstObj;
        q = ro;
        q.x -= TrackPath(q.z);
        vn = ObjNf(ro);
        spec = 0.1;
        if (idObj == idWal) {
        // pushing activation record 0:ShowScene35:36:37:38
            vc = HexVor(5. * q.zy);
            col = HsvToRgb(vec3(0.6 + 0.1 * vc.w, 1., 1.)) * (0.3 + 0.7 * smoothstep(0.05, 0.06 + 0.03 * vc.w, vc.x));

        }
        // popping activation record 0:ShowScene35:36:37:38
        // local variables: 
        // references:
        // vc at line 147, column 6
        // HexVor at line 147, column 11
        // q at line 147, column 24
        // col at line 148, column 6
        // HsvToRgb at line 148, column 12
        // vec3 at line 148, column 22
        // vc at line 148, column 40
        // smoothstep at line 149, column 9
        // vc at line 149, column 41
        // vc at line 149, column 47
        if (spec >= 0.) col = col * (0.2 + 0.8 * max(dot(vn, ltDir), 0.) + spec * pow(max(dot(normalize(ltDir - rd), vn), 0.), 64.));
        att = min(600. / pow(dstObj, 1.5), 1.);
        col *= att;

    }
    // popping activation record 0:ShowScene35:36:37
    // local variables: 
    // references:
    // ro at line 141, column 4
    // rd at line 141, column 10
    // dstObj at line 141, column 15
    // q at line 142, column 4
    // ro at line 142, column 8
    // q at line 143, column 4
    // TrackPath at line 143, column 11
    // q at line 143, column 22
    // vn at line 144, column 4
    // ObjNf at line 144, column 9
    // ro at line 144, column 16
    // spec at line 145, column 4
    // idObj at line 146, column 8
    // idWal at line 146, column 17
    // spec at line 170, column 8
    // col at line 170, column 20
    // col at line 170, column 26
    // max at line 170, column 45
    // dot at line 170, column 50
    // vn at line 170, column 55
    // ltDir at line 170, column 59
    // spec at line 171, column 7
    // pow at line 171, column 14
    // max at line 171, column 19
    // dot at line 171, column 24
    // normalize at line 171, column 29
    // ltDir at line 171, column 40
    // rd at line 171, column 48
    // vn at line 171, column 53
    // att at line 172, column 4
    // min at line 172, column 10
    // pow at line 172, column 22
    // dstObj at line 172, column 27
    // col at line 173, column 4
    // att at line 173, column 11
    return pow(clamp(col, 0., 1.), vec3(0.7));

}
// popping activation record 0:ShowScene35:36
// local variables: 
// variable vc, unique name 0:ShowScene35:36:vc, index 259, declared at line 135, column 7
// variable vn, unique name 0:ShowScene35:36:vn, index 260, declared at line 136, column 7
// variable col, unique name 0:ShowScene35:36:col, index 261, declared at line 136, column 11
// variable q, unique name 0:ShowScene35:36:q, index 262, declared at line 136, column 16
// variable dstObj, unique name 0:ShowScene35:36:dstObj, index 263, declared at line 137, column 8
// variable bh, unique name 0:ShowScene35:36:bh, index 264, declared at line 137, column 16
// variable s, unique name 0:ShowScene35:36:s, index 265, declared at line 137, column 20
// variable spec, unique name 0:ShowScene35:36:spec, index 266, declared at line 137, column 23
// variable att, unique name 0:ShowScene35:36:att, index 267, declared at line 137, column 29
// references:
// HexVorInit at line 138, column 2
// dstObj at line 139, column 2
// ObjRay at line 139, column 11
// ro at line 139, column 19
// rd at line 139, column 23
// dstObj at line 140, column 6
// dstFar at line 140, column 15
// pow at line 175, column 9
// clamp at line 175, column 14
// col at line 175, column 21
// vec3 at line 175, column 35
// popping activation record 0:ShowScene35
// local variables: 
// variable ro, unique name 0:ShowScene35:ro, index 257, declared at line 133, column 21
// variable rd, unique name 0:ShowScene35:rd, index 258, declared at line 133, column 30
// references:
// pushing activation record 0:mainImage39
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage39:40
    mat3 vuMat;
    vec4 mPtr;
    vec3 ro, rd;
    vec2 canvas, uv, ori, ca, sa;
    float el, az;
    canvas = iResolution.xy;
    uv = 2. * fragCoord.xy / canvas - 1.;
    uv.x *= canvas.x / canvas.y;
    tCur = iGlobalTime;
    mPtr = iMouse;
    mPtr.xy = mPtr.xy / canvas - 0.5;
    wdTun = 8.;
    htTun = 4.;
    lmpSep = 10.;
    az = 0.;
    el = 0.;
    if (mPtr.z > 0.) {
    // pushing activation record 0:mainImage39:40:41
        el = clamp(el + pi * mPtr.y, -0.4 * pi, 0.4 * pi);
        az = az + 2.5 * pi * mPtr.x;

    }
    // popping activation record 0:mainImage39:40:41
    // local variables: 
    // references:
    // el at line 197, column 4
    // clamp at line 197, column 9
    // el at line 197, column 16
    // pi at line 197, column 21
    // mPtr at line 197, column 26
    // pi at line 197, column 41
    // pi at line 197, column 51
    // az at line 198, column 4
    // az at line 198, column 9
    // pi at line 198, column 20
    // mPtr at line 198, column 25
    dstFar = 300.;
    ori = vec2(el, az);
    ca = cos(ori);
    sa = sin(ori);
    vuMat = mat3(ca.y, 0., -sa.y, 0., 1., 0., sa.y, 0., ca.y) * mat3(1., 0., 0., 0., ca.x, -sa.x, 0., sa.x, ca.x);
    rd = vuMat * normalize(vec3(uv, 3.));
    ro.z = 10. * tCur;
    ro.x = TrackPath(ro.z);
    rd.zx = Rot2D(rd.zx, 0.1 * atan(ro.x));
    ro.y = 1.5 * htTun;
    ltDir = vuMat * normalize(vec3(0., 0.2, -1.));
    fragColor = vec4(ShowScene(ro, rd), 1.);

}
// popping activation record 0:mainImage39:40
// local variables: 
// variable vuMat, unique name 0:mainImage39:40:vuMat, index 271, declared at line 180, column 7
// variable mPtr, unique name 0:mainImage39:40:mPtr, index 272, declared at line 181, column 7
// variable ro, unique name 0:mainImage39:40:ro, index 273, declared at line 182, column 7
// variable rd, unique name 0:mainImage39:40:rd, index 274, declared at line 182, column 11
// variable canvas, unique name 0:mainImage39:40:canvas, index 275, declared at line 183, column 7
// variable uv, unique name 0:mainImage39:40:uv, index 276, declared at line 183, column 15
// variable ori, unique name 0:mainImage39:40:ori, index 277, declared at line 183, column 19
// variable ca, unique name 0:mainImage39:40:ca, index 278, declared at line 183, column 24
// variable sa, unique name 0:mainImage39:40:sa, index 279, declared at line 183, column 28
// variable el, unique name 0:mainImage39:40:el, index 280, declared at line 184, column 8
// variable az, unique name 0:mainImage39:40:az, index 281, declared at line 184, column 12
// references:
// canvas at line 185, column 2
// iResolution at line 185, column 11
// uv at line 186, column 2
// fragCoord at line 186, column 12
// canvas at line 186, column 27
// uv at line 187, column 2
// canvas at line 187, column 10
// canvas at line 187, column 21
// tCur at line 188, column 2
// iGlobalTime at line 188, column 9
// mPtr at line 189, column 2
// iMouse at line 189, column 9
// mPtr at line 190, column 2
// mPtr at line 190, column 12
// canvas at line 190, column 22
// wdTun at line 191, column 2
// htTun at line 192, column 2
// lmpSep at line 193, column 2
// az at line 194, column 2
// el at line 195, column 2
// mPtr at line 196, column 6
// dstFar at line 200, column 2
// ori at line 201, column 2
// vec2 at line 201, column 8
// el at line 201, column 14
// az at line 201, column 18
// ca at line 202, column 2
// cos at line 202, column 7
// ori at line 202, column 12
// sa at line 203, column 2
// sin at line 203, column 7
// ori at line 203, column 12
// vuMat at line 204, column 2
// mat3 at line 204, column 10
// ca at line 204, column 16
// sa at line 204, column 28
// sa at line 204, column 46
// ca at line 204, column 56
// mat3 at line 205, column 10
// ca at line 205, column 32
// sa at line 205, column 40
// sa at line 205, column 50
// ca at line 205, column 56
// rd at line 206, column 2
// vuMat at line 206, column 7
// normalize at line 206, column 15
// vec3 at line 206, column 26
// uv at line 206, column 32
// ro at line 207, column 2
// tCur at line 207, column 15
// ro at line 208, column 2
// TrackPath at line 208, column 9
// ro at line 208, column 20
// rd at line 209, column 2
// Rot2D at line 209, column 10
// rd at line 209, column 17
// atan at line 209, column 30
// ro at line 209, column 36
// ro at line 210, column 2
// htTun at line 210, column 15
// ltDir at line 211, column 2
// vuMat at line 211, column 10
// normalize at line 211, column 18
// vec3 at line 211, column 29
// fragColor at line 212, column 2
// vec4 at line 212, column 14
// ShowScene at line 212, column 20
// ro at line 212, column 31
// rd at line 212, column 35
// popping activation record 0:mainImage39
// local variables: 
// variable fragColor, unique name 0:mainImage39:fragColor, index 269, declared at line 178, column 25
// variable fragCoord, unique name 0:mainImage39:fragCoord, index 270, declared at line 178, column 44
// references:
// pushing activation record 0:PrCylDf42
float PrCylDf(vec3 p, float r, float h)
{
// pushing activation record 0:PrCylDf42:43
    return max(length(p.xy) - r, abs(p.z) - h);

}
// popping activation record 0:PrCylDf42:43
// local variables: 
// references:
// max at line 217, column 9
// length at line 217, column 14
// p at line 217, column 22
// r at line 217, column 30
// abs at line 217, column 33
// p at line 217, column 38
// h at line 217, column 45
// popping activation record 0:PrCylDf42
// local variables: 
// variable p, unique name 0:PrCylDf42:p, index 282, declared at line 215, column 20
// variable r, unique name 0:PrCylDf42:r, index 283, declared at line 215, column 29
// variable h, unique name 0:PrCylDf42:h, index 284, declared at line 215, column 38
// references:
// pushing activation record 0:SmoothMin44
float SmoothMin(float a, float b, float r)
{
// pushing activation record 0:SmoothMin44:45
    float h;
    h = clamp(0.5 + 0.5 * (b - a) / r, 0., 1.);
    return mix(b, a, h) - r * h * (1. - h);

}
// popping activation record 0:SmoothMin44:45
// local variables: 
// variable h, unique name 0:SmoothMin44:45:h, index 288, declared at line 222, column 8
// references:
// h at line 223, column 2
// clamp at line 223, column 6
// b at line 223, column 26
// a at line 223, column 30
// r at line 223, column 35
// mix at line 224, column 9
// b at line 224, column 14
// a at line 224, column 17
// h at line 224, column 20
// r at line 224, column 25
// h at line 224, column 29
// h at line 224, column 39
// popping activation record 0:SmoothMin44
// local variables: 
// variable a, unique name 0:SmoothMin44:a, index 285, declared at line 220, column 23
// variable b, unique name 0:SmoothMin44:b, index 286, declared at line 220, column 32
// variable r, unique name 0:SmoothMin44:r, index 287, declared at line 220, column 41
// references:
// pushing activation record 0:Rot2D46
vec2 Rot2D(vec2 q, float a)
{
// pushing activation record 0:Rot2D46:47
    return q * cos(a) + q.yx * sin(a) * vec2(-1., 1.);

}
// popping activation record 0:Rot2D46:47
// local variables: 
// references:
// q at line 229, column 9
// cos at line 229, column 13
// a at line 229, column 18
// q at line 229, column 23
// sin at line 229, column 30
// a at line 229, column 35
// vec2 at line 229, column 40
// popping activation record 0:Rot2D46
// local variables: 
// variable q, unique name 0:Rot2D46:q, index 289, declared at line 227, column 17
// variable a, unique name 0:Rot2D46:a, index 290, declared at line 227, column 26
// references:
const vec4 cHashA4 = vec4(0., 1., 57., 58.);
const vec3 cHashA3 = vec3(1., 57., 113.);
const float cHashM = 43758.54;
// pushing activation record 0:Hashfv248
float Hashfv2(vec2 p)
{
// pushing activation record 0:Hashfv248:49
    return fract(sin(dot(p, cHashA3.xy)) * cHashM);

}
// popping activation record 0:Hashfv248:49
// local variables: 
// references:
// fract at line 238, column 9
// sin at line 238, column 16
// dot at line 238, column 21
// p at line 238, column 26
// cHashA3 at line 238, column 29
// cHashM at line 238, column 44
// popping activation record 0:Hashfv248
// local variables: 
// variable p, unique name 0:Hashfv248:p, index 294, declared at line 236, column 20
// references:
// pushing activation record 0:Hashv2v250
vec2 Hashv2v2(vec2 p)
{
// pushing activation record 0:Hashv2v250:51
    const vec2 cHashVA2 = vec2(37.1, 61.7);
    const vec2 e = vec2(1., 0.);
    return fract(sin(vec2(dot(p + e.yy, cHashVA2), dot(p + e.xy, cHashVA2))) * cHashM);

}
// popping activation record 0:Hashv2v250:51
// local variables: 
// variable cHashVA2, unique name 0:Hashv2v250:51:cHashVA2, index 296, declared at line 243, column 13
// variable e, unique name 0:Hashv2v250:51:e, index 297, declared at line 244, column 13
// references:
// vec2 at line 243, column 24
// vec2 at line 244, column 17
// fract at line 245, column 9
// sin at line 245, column 16
// vec2 at line 245, column 21
// dot at line 245, column 27
// p at line 245, column 32
// e at line 245, column 36
// cHashVA2 at line 245, column 42
// dot at line 246, column 5
// p at line 246, column 10
// e at line 246, column 14
// cHashVA2 at line 246, column 20
// cHashM at line 246, column 34
// popping activation record 0:Hashv2v250
// local variables: 
// variable p, unique name 0:Hashv2v250:p, index 295, declared at line 241, column 20
// references:
// pushing activation record 0:Hashv4f52
vec4 Hashv4f(float p)
{
// pushing activation record 0:Hashv4f52:53
    return fract(sin(p + cHashA4) * cHashM);

}
// popping activation record 0:Hashv4f52:53
// local variables: 
// references:
// fract at line 251, column 9
// sin at line 251, column 16
// p at line 251, column 21
// cHashA4 at line 251, column 25
// cHashM at line 251, column 36
// popping activation record 0:Hashv4f52
// local variables: 
// variable p, unique name 0:Hashv4f52:p, index 299, declared at line 249, column 20
// references:
// pushing activation record 0:Noisefv254
float Noisefv2(vec2 p)
{
// pushing activation record 0:Noisefv254:55
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3. - 2. * f);
    vec4 t = Hashv4f(dot(i, cHashA3.xy));
    return mix(mix(t.x, t.y, f.x), mix(t.z, t.w, f.x), f.y);

}
// popping activation record 0:Noisefv254:55
// local variables: 
// variable i, unique name 0:Noisefv254:55:i, index 301, declared at line 256, column 7
// variable f, unique name 0:Noisefv254:55:f, index 302, declared at line 257, column 7
// variable t, unique name 0:Noisefv254:55:t, index 303, declared at line 259, column 7
// references:
// floor at line 256, column 11
// p at line 256, column 18
// fract at line 257, column 11
// p at line 257, column 18
// f at line 258, column 2
// f at line 258, column 6
// f at line 258, column 10
// f at line 258, column 25
// Hashv4f at line 259, column 11
// dot at line 259, column 20
// i at line 259, column 25
// cHashA3 at line 259, column 28
// mix at line 260, column 9
// mix at line 260, column 14
// t at line 260, column 19
// t at line 260, column 24
// f at line 260, column 29
// mix at line 260, column 35
// t at line 260, column 40
// t at line 260, column 45
// f at line 260, column 50
// f at line 260, column 56
// popping activation record 0:Noisefv254
// local variables: 
// variable p, unique name 0:Noisefv254:p, index 300, declared at line 254, column 21
// references:
// pushing activation record 0:Fbmn56
float Fbmn(vec3 p, vec3 n)
{
// pushing activation record 0:Fbmn56:57
    vec3 s;
    float a;
    s = vec3(0.);
    a = 1.;
    // pushing activation record 0:Fbmn56:57:for58
    for (int i = 0; i < 5; i++) {
    // pushing activation record 0:Fbmn56:57:for58:59
        s += a * vec3(Noisefv2(p.yz), Noisefv2(p.zx), Noisefv2(p.xy));
        a *= 0.5;
        p *= 2.;

    }
    // popping activation record 0:Fbmn56:57:for58:59
    // local variables: 
    // references:
    // s at line 270, column 4
    // a at line 270, column 9
    // vec3 at line 270, column 13
    // Noisefv2 at line 270, column 19
    // p at line 270, column 29
    // Noisefv2 at line 270, column 36
    // p at line 270, column 46
    // Noisefv2 at line 270, column 53
    // p at line 270, column 63
    // a at line 271, column 4
    // p at line 272, column 4
    // popping activation record 0:Fbmn56:57:for58
    // local variables: 
    // variable i, unique name 0:Fbmn56:57:for58:i, index 309, declared at line 269, column 11
    // references:
    // i at line 269, column 18
    // i at line 269, column 25
    return dot(s, abs(n)) * (1. / 1.9375);

}
// popping activation record 0:Fbmn56:57
// local variables: 
// variable s, unique name 0:Fbmn56:57:s, index 307, declared at line 265, column 7
// variable a, unique name 0:Fbmn56:57:a, index 308, declared at line 266, column 8
// references:
// s at line 267, column 2
// vec3 at line 267, column 6
// a at line 268, column 2
// dot at line 274, column 9
// s at line 274, column 14
// abs at line 274, column 17
// n at line 274, column 22
// popping activation record 0:Fbmn56
// local variables: 
// variable p, unique name 0:Fbmn56:p, index 305, declared at line 263, column 17
// variable n, unique name 0:Fbmn56:n, index 306, declared at line 263, column 25
// references:
// pushing activation record 0:VaryNf60
vec3 VaryNf(vec3 p, vec3 n, float f)
{
// pushing activation record 0:VaryNf60:61
    vec3 g;
    float s;
    const vec3 e = vec3(0.1, 0., 0.);
    s = Fbmn(p, n);
    g = vec3(Fbmn(p + e.xyy, n) - s, Fbmn(p + e.yxy, n) - s, Fbmn(p + e.yyx, n) - s);
    return normalize(n + f * (g - n * dot(n, g)));

}
// popping activation record 0:VaryNf60:61
// local variables: 
// variable g, unique name 0:VaryNf60:61:g, index 313, declared at line 279, column 7
// variable s, unique name 0:VaryNf60:61:s, index 314, declared at line 280, column 8
// variable e, unique name 0:VaryNf60:61:e, index 315, declared at line 281, column 13
// references:
// vec3 at line 281, column 17
// s at line 282, column 2
// Fbmn at line 282, column 6
// p at line 282, column 12
// n at line 282, column 15
// g at line 283, column 2
// vec3 at line 283, column 6
// Fbmn at line 283, column 12
// p at line 283, column 18
// e at line 283, column 22
// n at line 283, column 29
// s at line 283, column 34
// Fbmn at line 283, column 37
// p at line 283, column 43
// e at line 283, column 47
// n at line 283, column 54
// s at line 283, column 59
// Fbmn at line 284, column 5
// p at line 284, column 11
// e at line 284, column 15
// n at line 284, column 22
// s at line 284, column 27
// normalize at line 285, column 9
// n at line 285, column 20
// f at line 285, column 24
// g at line 285, column 29
// n at line 285, column 33
// dot at line 285, column 37
// n at line 285, column 42
// g at line 285, column 45
// popping activation record 0:VaryNf60
// local variables: 
// variable p, unique name 0:VaryNf60:p, index 310, declared at line 277, column 18
// variable n, unique name 0:VaryNf60:n, index 311, declared at line 277, column 26
// variable f, unique name 0:VaryNf60:f, index 312, declared at line 277, column 35
// references:
// pushing activation record 0:HsvToRgb62
vec3 HsvToRgb(vec3 c)
{
// pushing activation record 0:HsvToRgb62:63
    vec3 p;
    p = abs(fract(c.xxx + vec3(1., 2. / 3., 1. / 3.)) * 6. - 3.);
    return c.z * mix(vec3(1.), clamp(p - 1., 0., 1.), c.y);

}
// popping activation record 0:HsvToRgb62:63
// local variables: 
// variable p, unique name 0:HsvToRgb62:63:p, index 317, declared at line 290, column 7
// references:
// p at line 291, column 2
// abs at line 291, column 6
// fract at line 291, column 11
// c at line 291, column 18
// vec3 at line 291, column 26
// c at line 292, column 9
// mix at line 292, column 15
// vec3 at line 292, column 20
// clamp at line 292, column 31
// p at line 292, column 38
// c at line 292, column 55
// popping activation record 0:HsvToRgb62
// local variables: 
// variable c, unique name 0:HsvToRgb62:c, index 316, declared at line 288, column 20
// references:
// undefined variables 
