// pushing activation record 0
mediump float uniform vec2 resolution;
uniform vec4 mouse;
uniform float time;
const float pi = 3.141592653589793;
#define eps  0.0001

#define EYEPATHLENGTH  8

#define SAMPLES  2

#define LIGHTCOLOR  vec3(16.86, 10.76, 8.2)*4.3

#define WHITECOLOR  vec3(.7295, .7355, .729)*0.7

#define GREENCOLOR  vec3(.117, .4125, .115)*0.7

#define REDCOLOR  vec3(1.0, .0555, .062)*0.7

float seed = 0.0;
// pushing activation record 0:hash11
float hash1()
{
// pushing activation record 0:hash11:2
    return 1.0;

}
// popping activation record 0:hash11:2
// local variables: 
// references:
// popping activation record 0:hash11
// local variables: 
// references:
// pushing activation record 0:hash23
vec2 hash2()
{
// pushing activation record 0:hash23:4
    return vec2(1);

}
// popping activation record 0:hash23:4
// local variables: 
// references:
// vec2 at line 26, column 11
// popping activation record 0:hash23
// local variables: 
// references:
// pushing activation record 0:hash35
vec3 hash3()
{
// pushing activation record 0:hash35:6
    return vec3(1);

}
// popping activation record 0:hash35:6
// local variables: 
// references:
// vec3 at line 30, column 11
// popping activation record 0:hash35
// local variables: 
// references:
// pushing activation record 0:nSphere7
vec3 nSphere(in vec3 pos, in vec4 sph)
{
// pushing activation record 0:nSphere7:8
    return (pos - sph.xyz) / sph.w;

}
// popping activation record 0:nSphere7:8
// local variables: 
// references:
// pos at line 38, column 12
// sph at line 38, column 16
// sph at line 38, column 25
// popping activation record 0:nSphere7
// local variables: 
// variable pos, unique name 0:nSphere7:pos, index 194, declared at line 37, column 22
// variable sph, unique name 0:nSphere7:sph, index 195, declared at line 37, column 35
// references:
// pushing activation record 0:iSphere9
float iSphere(in vec3 ro, in vec3 rd, in vec4 sph)
{
// pushing activation record 0:iSphere9:10
    vec3 oc = ro - sph.xyz;
    float b = dot(oc, rd);
    float c = dot(oc, oc) - sph.w * sph.w;
    float h = b * b - c;
    if (h < 0.0) return -1.0;
    return -b - sqrt(h);

}
// popping activation record 0:iSphere9:10
// local variables: 
// variable oc, unique name 0:iSphere9:10:oc, index 200, declared at line 42, column 6
// variable b, unique name 0:iSphere9:10:b, index 201, declared at line 43, column 7
// variable c, unique name 0:iSphere9:10:c, index 202, declared at line 44, column 7
// variable h, unique name 0:iSphere9:10:h, index 203, declared at line 45, column 7
// references:
// ro at line 42, column 11
// sph at line 42, column 16
// dot at line 43, column 11
// oc at line 43, column 16
// rd at line 43, column 20
// dot at line 44, column 11
// oc at line 44, column 16
// oc at line 44, column 20
// sph at line 44, column 27
// sph at line 44, column 33
// b at line 45, column 11
// b at line 45, column 13
// c at line 45, column 17
// h at line 46, column 5
// b at line 47, column 9
// sqrt at line 47, column 13
// h at line 47, column 19
// popping activation record 0:iSphere9
// local variables: 
// variable ro, unique name 0:iSphere9:ro, index 197, declared at line 41, column 23
// variable rd, unique name 0:iSphere9:rd, index 198, declared at line 41, column 35
// variable sph, unique name 0:iSphere9:sph, index 199, declared at line 41, column 47
// references:
// pushing activation record 0:nPlane11
vec3 nPlane(in vec3 ro, in vec4 obj)
{
// pushing activation record 0:nPlane11:12
    return obj.xyz;

}
// popping activation record 0:nPlane11:12
// local variables: 
// references:
// obj at line 51, column 11
// popping activation record 0:nPlane11
// local variables: 
// variable ro, unique name 0:nPlane11:ro, index 205, declared at line 50, column 21
// variable obj, unique name 0:nPlane11:obj, index 206, declared at line 50, column 33
// references:
// pushing activation record 0:iPlane13
float iPlane(in vec3 ro, in vec3 rd, in vec4 pla)
{
// pushing activation record 0:iPlane13:14
    return (-pla.w - dot(pla.xyz, ro)) / dot(pla.xyz, rd);

}
// popping activation record 0:iPlane13:14
// local variables: 
// references:
// pla at line 55, column 13
// dot at line 55, column 21
// pla at line 55, column 25
// ro at line 55, column 33
// dot at line 55, column 40
// pla at line 55, column 45
// rd at line 55, column 54
// popping activation record 0:iPlane13
// local variables: 
// variable ro, unique name 0:iPlane13:ro, index 208, declared at line 54, column 22
// variable rd, unique name 0:iPlane13:rd, index 209, declared at line 54, column 34
// variable pla, unique name 0:iPlane13:pla, index 210, declared at line 54, column 46
// references:
// pushing activation record 0:cosWeightedRandomHemisphereDirection15
vec3 cosWeightedRandomHemisphereDirection(const vec3 n)
{
// pushing activation record 0:cosWeightedRandomHemisphereDirection15:16
    vec2 r = hash2();
    vec3 uu = normalize(cross(n, vec3(0.0, 1.0, 1.0)));
    vec3 vv = cross(uu, n);
    float ra = sqrt(r.y);
    float rx = ra * cos(6.2831 * r.x);
    float ry = ra * sin(6.2831 * r.x);
    float rz = sqrt(1.0 - r.y);
    vec3 rr = vec3(rx * uu + ry * vv + rz * n);
    return normalize(rr);

}
// popping activation record 0:cosWeightedRandomHemisphereDirection15:16
// local variables: 
// variable r, unique name 0:cosWeightedRandomHemisphereDirection15:16:r, index 213, declared at line 63, column 8
// variable uu, unique name 0:cosWeightedRandomHemisphereDirection15:16:uu, index 214, declared at line 65, column 7
// variable vv, unique name 0:cosWeightedRandomHemisphereDirection15:16:vv, index 215, declared at line 66, column 7
// variable ra, unique name 0:cosWeightedRandomHemisphereDirection15:16:ra, index 216, declared at line 68, column 7
// variable rx, unique name 0:cosWeightedRandomHemisphereDirection15:16:rx, index 217, declared at line 69, column 7
// variable ry, unique name 0:cosWeightedRandomHemisphereDirection15:16:ry, index 218, declared at line 70, column 7
// variable rz, unique name 0:cosWeightedRandomHemisphereDirection15:16:rz, index 219, declared at line 71, column 7
// variable rr, unique name 0:cosWeightedRandomHemisphereDirection15:16:rr, index 220, declared at line 72, column 7
// references:
// hash2 at line 63, column 12
// normalize at line 65, column 12
// cross at line 65, column 23
// n at line 65, column 30
// vec3 at line 65, column 33
// cross at line 66, column 12
// uu at line 66, column 19
// n at line 66, column 23
// sqrt at line 68, column 12
// r at line 68, column 17
// ra at line 69, column 12
// cos at line 69, column 15
// r at line 69, column 26
// ra at line 70, column 12
// sin at line 70, column 15
// r at line 70, column 26
// sqrt at line 71, column 12
// r at line 71, column 22
// vec3 at line 72, column 12
// rx at line 72, column 18
// uu at line 72, column 21
// ry at line 72, column 26
// vv at line 72, column 29
// rz at line 72, column 34
// n at line 72, column 37
// normalize at line 74, column 11
// rr at line 74, column 22
// popping activation record 0:cosWeightedRandomHemisphereDirection15
// local variables: 
// variable n, unique name 0:cosWeightedRandomHemisphereDirection15:n, index 212, declared at line 62, column 54
// references:
// pushing activation record 0:randomSphereDirection17
vec3 randomSphereDirection()
{
// pushing activation record 0:randomSphereDirection17:18
    vec2 r = hash2() * 6.2831;
    vec3 dr = vec3(0, 0, 0);
    return dr;

}
// popping activation record 0:randomSphereDirection17:18
// local variables: 
// variable r, unique name 0:randomSphereDirection17:18:r, index 222, declared at line 78, column 9
// variable dr, unique name 0:randomSphereDirection17:18:dr, index 223, declared at line 80, column 6
// references:
// hash2 at line 78, column 13
// vec3 at line 80, column 9
// dr at line 81, column 8
// popping activation record 0:randomSphereDirection17
// local variables: 
// references:
// pushing activation record 0:randomHemisphereDirection19
vec3 randomHemisphereDirection(const vec3 n)
{
// pushing activation record 0:randomHemisphereDirection19:20
    vec3 dr = randomSphereDirection();
    return dot(dr, n) * dr;

}
// popping activation record 0:randomHemisphereDirection19:20
// local variables: 
// variable dr, unique name 0:randomHemisphereDirection19:20:dr, index 226, declared at line 85, column 6
// references:
// randomSphereDirection at line 85, column 11
// dot at line 86, column 8
// dr at line 86, column 12
// n at line 86, column 15
// dr at line 86, column 20
// popping activation record 0:randomHemisphereDirection19
// local variables: 
// variable n, unique name 0:randomHemisphereDirection19:n, index 225, declared at line 84, column 43
// references:
vec4 lightSphere;
// pushing activation record 0:initLightSphere21
void initLightSphere(float time)
{
// pushing activation record 0:initLightSphere21:22
    lightSphere = vec4(3.0 + 2. * sin(time), 2.8 + 2. * sin(time * 0.9), 3.0 + 4. * cos(time * 0.7), .5);

}
// popping activation record 0:initLightSphere21:22
// local variables: 
// references:
// lightSphere at line 96, column 1
// vec4 at line 96, column 15
// sin at line 96, column 28
// time at line 96, column 32
// sin at line 96, column 45
// time at line 96, column 49
// cos at line 96, column 66
// time at line 96, column 70
// popping activation record 0:initLightSphere21
// local variables: 
// variable time, unique name 0:initLightSphere21:time, index 229, declared at line 95, column 28
// references:
// pushing activation record 0:sampleLight23
vec3 sampleLight(const in vec3 ro)
{
// pushing activation record 0:sampleLight23:24
    vec3 n = randomSphereDirection() * lightSphere.w;
    return lightSphere.xyz + n;

}
// popping activation record 0:sampleLight23:24
// local variables: 
// variable n, unique name 0:sampleLight23:24:n, index 232, declared at line 100, column 9
// references:
// randomSphereDirection at line 100, column 13
// lightSphere at line 100, column 39
// lightSphere at line 101, column 11
// n at line 101, column 29
// popping activation record 0:sampleLight23
// local variables: 
// variable ro, unique name 0:sampleLight23:ro, index 231, declared at line 99, column 32
// references:
// pushing activation record 0:intersect25
vec2 intersect(in vec3 ro, in vec3 rd, inout vec3 normal)
{
// pushing activation record 0:intersect25:26
    vec2 res = vec2(1e20, -1.0);
    float t;
    t = iPlane(ro, rd, vec4(0.0, 1.0, 0.0, 0.0));
    if (t > eps && t < res.x) {
    // pushing activation record 0:intersect25:26:27
        res = vec2(t, 1.);
        normal = vec3(0., 1., 0.);

    }
    // popping activation record 0:intersect25:26:27
    // local variables: 
    // references:
    // res at line 112, column 75
    // vec2 at line 112, column 81
    // t at line 112, column 87
    // normal at line 112, column 96
    // vec3 at line 112, column 105
    t = iPlane(ro, rd, vec4(0.0, 0.0, -1.0, 8.0));
    if (t > eps && t < res.x) {
    // pushing activation record 0:intersect25:26:28
        res = vec2(t, 1.);
        normal = vec3(0., 0., -1.);

    }
    // popping activation record 0:intersect25:26:28
    // local variables: 
    // references:
    // res at line 113, column 75
    // vec2 at line 113, column 81
    // t at line 113, column 87
    // normal at line 113, column 96
    // vec3 at line 113, column 105
    t = iPlane(ro, rd, vec4(1.0, 0.0, 0.0, 0.0));
    if (t > eps && t < res.x) {
    // pushing activation record 0:intersect25:26:29
        res = vec2(t, 2.);
        normal = vec3(1., 0., 0.);

    }
    // popping activation record 0:intersect25:26:29
    // local variables: 
    // references:
    // res at line 114, column 78
    // vec2 at line 114, column 84
    // t at line 114, column 90
    // normal at line 114, column 99
    // vec3 at line 114, column 108
    t = iPlane(ro, rd, vec4(0.0, -1.0, 0.0, 5.49));
    if (t > eps && t < res.x) {
    // pushing activation record 0:intersect25:26:30
        res = vec2(t, 1.);
        normal = vec3(0., -1., 0.);

    }
    // popping activation record 0:intersect25:26:30
    // local variables: 
    // references:
    // res at line 116, column 78
    // vec2 at line 116, column 84
    // t at line 116, column 90
    // normal at line 116, column 99
    // vec3 at line 116, column 108
    t = iPlane(ro, rd, vec4(-1.0, 0.0, 0.0, 5.59));
    if (t > eps && t < res.x) {
    // pushing activation record 0:intersect25:26:31
        res = vec2(t, 3.);
        normal = vec3(-1., 0., 0.);

    }
    // popping activation record 0:intersect25:26:31
    // local variables: 
    // references:
    // res at line 117, column 78
    // vec2 at line 117, column 84
    // t at line 117, column 90
    // normal at line 117, column 99
    // vec3 at line 117, column 108
    t = iSphere(ro, rd, vec4(1.5, 1.0, 2.7, 1.0));
    if (t > eps && t < res.x) {
    // pushing activation record 0:intersect25:26:32
        res = vec2(t, 1.);
        normal = nSphere(ro + t * rd, vec4(1.5, 1.0, 2.7, 1.0));

    }
    // popping activation record 0:intersect25:26:32
    // local variables: 
    // references:
    // res at line 119, column 75
    // vec2 at line 119, column 81
    // t at line 119, column 87
    // normal at line 119, column 96
    // nSphere at line 119, column 105
    // ro at line 119, column 114
    // t at line 119, column 117
    // rd at line 119, column 119
    // vec4 at line 119, column 123
    t = iSphere(ro, rd, vec4(4.0, 1.0, 4.0, 1.0));
    if (t > eps && t < res.x) {
    // pushing activation record 0:intersect25:26:33
        res = vec2(t, 6.);
        normal = nSphere(ro + t * rd, vec4(4.0, 1.0, 4.0, 1.0));

    }
    // popping activation record 0:intersect25:26:33
    // local variables: 
    // references:
    // res at line 120, column 78
    // vec2 at line 120, column 84
    // t at line 120, column 90
    // normal at line 120, column 99
    // nSphere at line 120, column 108
    // ro at line 120, column 117
    // t at line 120, column 120
    // rd at line 120, column 122
    // vec4 at line 120, column 126
    t = iSphere(ro, rd, lightSphere);
    if (t > eps && t < res.x) {
    // pushing activation record 0:intersect25:26:34
        res = vec2(t, 0.0);
        normal = nSphere(ro + t * rd, lightSphere);

    }
    // popping activation record 0:intersect25:26:34
    // local variables: 
    // references:
    // res at line 121, column 65
    // vec2 at line 121, column 71
    // t at line 121, column 77
    // normal at line 121, column 88
    // nSphere at line 121, column 97
    // ro at line 121, column 106
    // t at line 121, column 109
    // rd at line 121, column 111
    // lightSphere at line 121, column 115
    return res;

}
// popping activation record 0:intersect25:26
// local variables: 
// variable res, unique name 0:intersect25:26:res, index 237, declared at line 109, column 6
// variable t, unique name 0:intersect25:26:t, index 238, declared at line 110, column 10
// references:
// vec2 at line 109, column 12
// t at line 112, column 1
// iPlane at line 112, column 5
// ro at line 112, column 13
// rd at line 112, column 17
// vec4 at line 112, column 21
// t at line 112, column 54
// eps at line 112, column 56
// t at line 112, column 63
// res at line 112, column 65
// t at line 113, column 1
// iPlane at line 113, column 5
// ro at line 113, column 13
// rd at line 113, column 17
// vec4 at line 113, column 21
// t at line 113, column 54
// eps at line 113, column 56
// t at line 113, column 63
// res at line 113, column 65
// t at line 114, column 4
// iPlane at line 114, column 8
// ro at line 114, column 16
// rd at line 114, column 20
// vec4 at line 114, column 24
// t at line 114, column 57
// eps at line 114, column 59
// t at line 114, column 66
// res at line 114, column 68
// t at line 116, column 4
// iPlane at line 116, column 8
// ro at line 116, column 16
// rd at line 116, column 20
// vec4 at line 116, column 24
// t at line 116, column 57
// eps at line 116, column 59
// t at line 116, column 66
// res at line 116, column 68
// t at line 117, column 4
// iPlane at line 117, column 8
// ro at line 117, column 16
// rd at line 117, column 20
// vec4 at line 117, column 24
// t at line 117, column 57
// eps at line 117, column 59
// t at line 117, column 66
// res at line 117, column 68
// t at line 119, column 1
// iSphere at line 119, column 5
// ro at line 119, column 14
// rd at line 119, column 18
// vec4 at line 119, column 22
// t at line 119, column 54
// eps at line 119, column 56
// t at line 119, column 63
// res at line 119, column 65
// t at line 120, column 4
// iSphere at line 120, column 8
// ro at line 120, column 17
// rd at line 120, column 21
// vec4 at line 120, column 25
// t at line 120, column 57
// eps at line 120, column 59
// t at line 120, column 66
// res at line 120, column 68
// t at line 121, column 4
// iSphere at line 121, column 8
// ro at line 121, column 17
// rd at line 121, column 21
// lightSphere at line 121, column 25
// t at line 121, column 44
// eps at line 121, column 46
// t at line 121, column 53
// res at line 121, column 55
// res at line 123, column 11
// popping activation record 0:intersect25
// local variables: 
// variable ro, unique name 0:intersect25:ro, index 234, declared at line 108, column 24
// variable rd, unique name 0:intersect25:rd, index 235, declared at line 108, column 36
// variable normal, unique name 0:intersect25:normal, index 236, declared at line 108, column 51
// references:
// pushing activation record 0:intersectShadow35
bool intersectShadow(in vec3 ro, in vec3 rd, in float dist)
{
// pushing activation record 0:intersectShadow35:36
    float t;
    t = iSphere(ro, rd, vec4(1.5, 1.0, 2.7, 1.0));
    if (t > eps && t < dist) {
    // pushing activation record 0:intersectShadow35:36:37
        return true;

    }
    // popping activation record 0:intersectShadow35:36:37
    // local variables: 
    // references:
    t = iSphere(ro, rd, vec4(4.0, 1.0, 4.0, 1.0));
    if (t > eps && t < dist) {
    // pushing activation record 0:intersectShadow35:36:38
        return true;

    }
    // popping activation record 0:intersectShadow35:36:38
    // local variables: 
    // references:
    return false;

}
// popping activation record 0:intersectShadow35:36
// local variables: 
// variable t, unique name 0:intersectShadow35:36:t, index 243, declared at line 127, column 10
// references:
// t at line 129, column 1
// iSphere at line 129, column 5
// ro at line 129, column 14
// rd at line 129, column 18
// vec4 at line 129, column 22
// t at line 129, column 54
// eps at line 129, column 56
// t at line 129, column 63
// dist at line 129, column 65
// t at line 130, column 4
// iSphere at line 130, column 8
// ro at line 130, column 17
// rd at line 130, column 21
// vec4 at line 130, column 25
// t at line 130, column 57
// eps at line 130, column 59
// t at line 130, column 66
// dist at line 130, column 68
// popping activation record 0:intersectShadow35
// local variables: 
// variable ro, unique name 0:intersectShadow35:ro, index 240, declared at line 126, column 30
// variable rd, unique name 0:intersectShadow35:rd, index 241, declared at line 126, column 42
// variable dist, unique name 0:intersectShadow35:dist, index 242, declared at line 126, column 55
// references:
// pushing activation record 0:matColor39
vec3 matColor(const in float mat)
{
// pushing activation record 0:matColor39:40
    vec3 nor = vec3(0., 0.95, 0.);
    if (mat < 3.5) nor = REDCOLOR;
    if (mat < 2.5) nor = GREENCOLOR;
    if (mat < 1.5) nor = WHITECOLOR;
    if (mat < 0.5) nor = LIGHTCOLOR;
    return nor;

}
// popping activation record 0:matColor39:40
// local variables: 
// variable nor, unique name 0:matColor39:40:nor, index 246, declared at line 140, column 6
// references:
// vec3 at line 140, column 12
// mat at line 142, column 5
// nor at line 142, column 15
// REDCOLOR at line 142, column 21
// mat at line 143, column 8
// nor at line 143, column 18
// GREENCOLOR at line 143, column 24
// mat at line 144, column 5
// nor at line 144, column 15
// WHITECOLOR at line 144, column 21
// mat at line 145, column 5
// nor at line 145, column 15
// LIGHTCOLOR at line 145, column 21
// nor at line 147, column 11
// popping activation record 0:matColor39
// local variables: 
// variable mat, unique name 0:matColor39:mat, index 245, declared at line 139, column 30
// references:
// pushing activation record 0:matIsSpecular41
bool matIsSpecular(const in float mat)
{
// pushing activation record 0:matIsSpecular41:42
    return mat > 4.5;

}
// popping activation record 0:matIsSpecular41:42
// local variables: 
// references:
// mat at line 151, column 11
// popping activation record 0:matIsSpecular41
// local variables: 
// variable mat, unique name 0:matIsSpecular41:mat, index 248, declared at line 150, column 35
// references:
// pushing activation record 0:matIsLight43
bool matIsLight(const in float mat)
{
// pushing activation record 0:matIsLight43:44
    return mat < 0.5;

}
// popping activation record 0:matIsLight43:44
// local variables: 
// references:
// mat at line 155, column 11
// popping activation record 0:matIsLight43
// local variables: 
// variable mat, unique name 0:matIsLight43:mat, index 250, declared at line 154, column 32
// references:
// pushing activation record 0:getBRDFRay45
vec3 getBRDFRay(const in vec3 n, const in vec3 rd, const in float m, inout bool specularBounce)
{
// pushing activation record 0:getBRDFRay45:46
    specularBounce = false;
    vec3 r = cosWeightedRandomHemisphereDirection(n);
    if (!matIsSpecular(m)) {
    // pushing activation record 0:getBRDFRay45:46:47
        return r;

    }
    // popping activation record 0:getBRDFRay45:46:47
    // local variables: 
    // references:
    // r at line 167, column 15

}
// popping activation record 0:getBRDFRay45:46
// local variables: 
// variable r, unique name 0:getBRDFRay45:46:r, index 256, declared at line 165, column 9
// references:
// specularBounce at line 163, column 4
// cosWeightedRandomHemisphereDirection at line 165, column 13
// n at line 165, column 51
// matIsSpecular at line 166, column 10
// m at line 166, column 25
// popping activation record 0:getBRDFRay45
// local variables: 
// variable n, unique name 0:getBRDFRay45:n, index 252, declared at line 162, column 31
// variable rd, unique name 0:getBRDFRay45:rd, index 253, declared at line 162, column 48
// variable m, unique name 0:getBRDFRay45:m, index 254, declared at line 162, column 67
// variable specularBounce, unique name 0:getBRDFRay45:specularBounce, index 255, declared at line 162, column 81
// references:
// pushing activation record 0:traceEyePath48
vec3 traceEyePath(in vec3 ro, in vec3 rd, const in bool directLightSampling)
{
// pushing activation record 0:traceEyePath48:49
    vec3 tcol = vec3(0.);
    vec3 fcol = vec3(1.);
    bool specularBounce = true;
    // pushing activation record 0:traceEyePath48:49:for50
    for (int j = 0; j < EYEPATHLENGTH; ++j) {
    // pushing activation record 0:traceEyePath48:49:for50:51
        vec3 normal;
        vec2 res = intersect(ro, rd, normal);
        if (res.y < -0.5) {
        // pushing activation record 0:traceEyePath48:49:for50:51:52
            return tcol;

        }
        // popping activation record 0:traceEyePath48:49:for50:51:52
        // local variables: 
        // references:
        // tcol at line 209, column 19
        if (matIsLight(res.y)) {
        // pushing activation record 0:traceEyePath48:49:for50:51:53
            if (directLightSampling) {
            // pushing activation record 0:traceEyePath48:49:for50:51:53:54
                if (specularBounce) tcol += fcol * LIGHTCOLOR;

            }
            // popping activation record 0:traceEyePath48:49:for50:51:53:54
            // local variables: 
            // references:
            // specularBounce at line 214, column 17
            // tcol at line 214, column 34
            // fcol at line 214, column 42
            // LIGHTCOLOR at line 214, column 47
            return tcol;

        }
        // popping activation record 0:traceEyePath48:49:for50:51:53
        // local variables: 
        // references:
        // directLightSampling at line 213, column 16
        // tcol at line 219, column 19
        ro = ro + res.x * rd;
        rd = getBRDFRay(normal, rd, res.y, specularBounce);
        fcol *= matColor(res.y);
        vec3 ld = sampleLight(ro) - ro;
        if (directLightSampling) {
        // pushing activation record 0:traceEyePath48:49:for50:51:55
            vec3 nld = normalize(ld);
            if (!specularBounce && j < EYEPATHLENGTH - 1 && !intersectShadow(ro, nld, length(ld))) {
            // pushing activation record 0:traceEyePath48:49:for50:51:55:56
                float cos_a_max = sqrt(1. - clamp(lightSphere.w * lightSphere.w / dot(lightSphere.xyz - ro, lightSphere.xyz - ro), 0., 1.));
                float weight = 2. * (1. - cos_a_max);
                tcol += (fcol * LIGHTCOLOR) * (weight * clamp(dot(nld, normal), 0., 1.));

            }
            // popping activation record 0:traceEyePath48:49:for50:51:55:56
            // local variables: 
            // variable cos_a_max, unique name 0:traceEyePath48:49:for50:51:55:56:cos_a_max, index 269, declared at line 233, column 22
            // variable weight, unique name 0:traceEyePath48:49:for50:51:55:56:weight, index 270, declared at line 234, column 22
            // references:
            // sqrt at line 233, column 34
            // clamp at line 233, column 44
            // lightSphere at line 233, column 50
            // lightSphere at line 233, column 66
            // dot at line 233, column 82
            // lightSphere at line 233, column 86
            // ro at line 233, column 102
            // lightSphere at line 233, column 106
            // ro at line 233, column 122
            // cos_a_max at line 234, column 42
            // tcol at line 236, column 16
            // fcol at line 236, column 25
            // LIGHTCOLOR at line 236, column 32
            // weight at line 236, column 47
            // clamp at line 236, column 56
            // dot at line 236, column 62
            // nld at line 236, column 67
            // normal at line 236, column 72

        }
        // popping activation record 0:traceEyePath48:49:for50:51:55
        // local variables: 
        // variable nld, unique name 0:traceEyePath48:49:for50:51:55:nld, index 268, declared at line 230, column 8
        // references:
        // normalize at line 230, column 14
        // ld at line 230, column 24
        // specularBounce at line 231, column 17
        // j at line 231, column 35
        // EYEPATHLENGTH at line 231, column 39
        // intersectShadow at line 231, column 59
        // ro at line 231, column 76
        // nld at line 231, column 80
        // length at line 231, column 85
        // ld at line 231, column 92

    }
    // popping activation record 0:traceEyePath48:49:for50:51
    // local variables: 
    // variable normal, unique name 0:traceEyePath48:49:for50:51:normal, index 265, declared at line 205, column 13
    // variable res, unique name 0:traceEyePath48:49:for50:51:res, index 266, declared at line 207, column 13
    // variable ld, unique name 0:traceEyePath48:49:for50:51:ld, index 267, declared at line 227, column 13
    // references:
    // intersect at line 207, column 19
    // ro at line 207, column 30
    // rd at line 207, column 34
    // normal at line 207, column 38
    // res at line 208, column 12
    // matIsLight at line 212, column 12
    // res at line 212, column 24
    // ro at line 222, column 8
    // ro at line 222, column 13
    // res at line 222, column 18
    // rd at line 222, column 26
    // rd at line 223, column 8
    // getBRDFRay at line 223, column 13
    // normal at line 223, column 25
    // rd at line 223, column 33
    // res at line 223, column 37
    // specularBounce at line 223, column 44
    // fcol at line 225, column 8
    // matColor at line 225, column 16
    // res at line 225, column 26
    // sampleLight at line 227, column 18
    // ro at line 227, column 31
    // ro at line 227, column 38
    // directLightSampling at line 229, column 12
    // popping activation record 0:traceEyePath48:49:for50
    // local variables: 
    // variable j, unique name 0:traceEyePath48:49:for50:j, index 264, declared at line 204, column 13
    // references:
    // j at line 204, column 18
    // EYEPATHLENGTH at line 204, column 20
    // j at line 204, column 37
    return tcol;

}
// popping activation record 0:traceEyePath48:49
// local variables: 
// variable tcol, unique name 0:traceEyePath48:49:tcol, index 261, declared at line 199, column 9
// variable fcol, unique name 0:traceEyePath48:49:fcol, index 262, declared at line 200, column 9
// variable specularBounce, unique name 0:traceEyePath48:49:specularBounce, index 263, declared at line 202, column 9
// references:
// vec3 at line 199, column 16
// vec3 at line 200, column 17
// tcol at line 240, column 11
// popping activation record 0:traceEyePath48
// local variables: 
// variable ro, unique name 0:traceEyePath48:ro, index 258, declared at line 198, column 27
// variable rd, unique name 0:traceEyePath48:rd, index 259, declared at line 198, column 39
// variable directLightSampling, unique name 0:traceEyePath48:directLightSampling, index 260, declared at line 198, column 57
// references:
// pushing activation record 0:main57
void main()
{
// pushing activation record 0:main57:58
    vec2 q = gl_FragCoord.xy / resolution.xy;
    bool directLightSampling = true;
    vec2 p = -1.0 + 2.0 * (gl_FragCoord.xy) / resolution.xy;
    p.x *= resolution.x / resolution.y;
    seed = p.x + p.y * 3.43121412313 + fract(1.12345314312 * time);
    vec3 ro = vec3(2.78, 2.73, -8.00);
    vec3 ta = vec3(2.78, 2.73, 0.00);
    vec3 ww = normalize(ta - ro);
    vec3 uu = normalize(cross(ww, vec3(0.0, 1.0, 0.0)));
    vec3 vv = normalize(cross(uu, ww));
    vec3 col = vec3(0.0);
    vec3 tot = vec3(0.0);
    vec3 uvw = vec3(0.0);
    // pushing activation record 0:main57:58:for59
    for (int a = 0; a < SAMPLES; a++) {
    // pushing activation record 0:main57:58:for59:60
        vec2 rpof = 4. * (hash2() - vec2(0.5)) / resolution.xy;
        vec3 rd = normalize((p.x + rpof.x) * uu + (p.y + rpof.y) * vv + 3.0 * ww);
        vec3 rof = ro;
        initLightSphere(time);
        col = traceEyePath(rof, rd, directLightSampling);
        tot += col;

    }
    // popping activation record 0:main57:58:for59:60
    // local variables: 
    // variable rpof, unique name 0:main57:58:for59:60:rpof, index 284, declared at line 276, column 13
    // variable rd, unique name 0:main57:58:for59:60:rd, index 285, declared at line 277, column 10
    // variable rof, unique name 0:main57:58:for59:60:rof, index 286, declared at line 279, column 13
    // references:
    // hash2 at line 276, column 24
    // vec2 at line 276, column 32
    // resolution at line 276, column 45
    // normalize at line 277, column 15
    // p at line 277, column 27
    // rpof at line 277, column 31
    // uu at line 277, column 39
    // p at line 277, column 45
    // rpof at line 277, column 49
    // vv at line 277, column 57
    // ww at line 277, column 66
    // ro at line 279, column 19
    // initLightSphere at line 280, column 8
    // time at line 280, column 25
    // col at line 282, column 8
    // traceEyePath at line 282, column 14
    // rof at line 282, column 28
    // rd at line 282, column 33
    // directLightSampling at line 282, column 37
    // tot at line 284, column 8
    // col at line 284, column 15
    // popping activation record 0:main57:58:for59
    // local variables: 
    // variable a, unique name 0:main57:58:for59:a, index 283, declared at line 274, column 13
    // references:
    // a at line 274, column 18
    // SAMPLES at line 274, column 20
    // a at line 274, column 29
    tot /= float(SAMPLES);
    tot = pow(tot, vec3(0.45));
    gl_FragColor = vec4(tot / (tot + 2.0), 1.0);

}
// popping activation record 0:main57:58
// local variables: 
// variable q, unique name 0:main57:58:q, index 272, declared at line 248, column 6
// variable directLightSampling, unique name 0:main57:58:directLightSampling, index 273, declared at line 250, column 6
// variable p, unique name 0:main57:58:p, index 274, declared at line 255, column 9
// variable ro, unique name 0:main57:58:ro, index 275, declared at line 260, column 9
// variable ta, unique name 0:main57:58:ta, index 276, declared at line 261, column 9
// variable ww, unique name 0:main57:58:ww, index 277, declared at line 262, column 9
// variable uu, unique name 0:main57:58:uu, index 278, declared at line 263, column 9
// variable vv, unique name 0:main57:58:vv, index 279, declared at line 264, column 9
// variable col, unique name 0:main57:58:col, index 280, declared at line 270, column 9
// variable tot, unique name 0:main57:58:tot, index 281, declared at line 271, column 9
// variable uvw, unique name 0:main57:58:uvw, index 282, declared at line 272, column 9
// references:
// gl_FragCoord at line 248, column 10
// resolution at line 248, column 28
// gl_FragCoord at line 255, column 27
// resolution at line 255, column 46
// p at line 256, column 4
// resolution at line 256, column 11
// resolution at line 256, column 24
// seed at line 258, column 4
// p at line 258, column 11
// p at line 258, column 17
// fract at line 258, column 39
// time at line 258, column 59
// vec3 at line 260, column 14
// vec3 at line 261, column 14
// normalize at line 262, column 14
// ta at line 262, column 25
// ro at line 262, column 30
// normalize at line 263, column 14
// cross at line 263, column 25
// ww at line 263, column 31
// vec3 at line 263, column 34
// normalize at line 264, column 14
// cross at line 264, column 25
// uu at line 264, column 31
// ww at line 264, column 34
// vec3 at line 270, column 15
// vec3 at line 271, column 15
// vec3 at line 272, column 15
// tot at line 287, column 4
// float at line 287, column 11
// SAMPLES at line 287, column 17
// tot at line 290, column 1
// pow at line 290, column 7
// tot at line 290, column 12
// vec3 at line 290, column 17
// gl_FragColor at line 292, column 4
// vec4 at line 292, column 19
// tot at line 292, column 25
// tot at line 292, column 32
// popping activation record 0:main57
// local variables: 
// references:
// undefined variables 
