// pushing activation record 0
#define PI  3.141592653589793

#define PIdiv2  1.57079632679489

#define TwoPI  6.283185307179586

#define INFINI  1000000000.

#define maxTreeH  130.

#define maxHill  300.

#define cellH  430. 	/*treeH + maxHill*/

#define cellD  100.

#define maxCell  100

#define TREE_DENSITY  (abs(fract(cell.x/10.)-.5)*abs(fract(cell.y/10.)-.5))*10.

#define GND  -1

#define SKY  -1000

#define REDL  1

#define MAGL  2

#define BLUL  3

#define YELL  4

#define COTTA  10

#define WALL  11

#define ROOF  12

#define TREE  20

#define CHRISTREE  21

#define SNOWMAN  40

#define BELLY  41

#define HEAD  42

#define HAT  43

#define NOZ  44

#define SHIFT  0.

#define AMP  1.

#define P1  .003

#define P2  .0039999  /* P1*1.3333 */

#define P3  .0059661  /* P1*1.9887 */

#define DP2  .0039999 /*.00199995  /* AMP * P2 */

#define DP3  .0059661 /*.00298305  /* AMP * P3 */

#define NRM  4.   /* (1. + AMP + SHIFT) * 2. */

int hitObj = SKY;
float T = INFINI;
vec3 camPos;
vec3 lightRay;
vec3 redO, magO, bluO, yelO;
float redR, magR, bluR, yelR;
vec3 wallO, roofO;
float wallR, roofR, roofH;
vec2 cottaCell;
vec3 belO, hedO, hatO, nozO;
float belR, hedR, hatH, hatR, nozH, nozR;
vec2 snowmanCell;
vec3 treeO;
float treeR, treeH;
vec3 CtreeO;
float CtreeR, CtreeH;
vec2 CtreeCell;
// pushing activation record 0:rand11
float rand1(in float v)
{
// pushing activation record 0:rand11:2
    return fract(sin(v) * 437585.);

}
// popping activation record 0:rand11:2
// local variables: 
// references:
// fract at line 96, column 44
// sin at line 96, column 50
// v at line 96, column 54
// popping activation record 0:rand11
// local variables: 
// variable v, unique name 0:rand11:v, index 249, declared at line 96, column 22
// references:
// pushing activation record 0:rand13
float rand1(in float v)
{
// pushing activation record 0:rand13:4
    return fract(sin(v) * 437585.);

}
// popping activation record 0:rand13:4
// local variables: 
// references:
// fract at line 99, column 11
// sin at line 99, column 17
// v at line 99, column 21
// popping activation record 0:rand13
// local variables: 
// variable v, unique name 0:rand13:v, index 250, declared at line 98, column 22
// references:
// pushing activation record 0:rand25
float rand2(in vec2 st, in float time)
{
// pushing activation record 0:rand25:6
    return fract(sin(dot(st.xy, vec2(12.9898, 8.233))) * 43758.5453123 + time);

}
// popping activation record 0:rand25:6
// local variables: 
// references:
// fract at line 102, column 11
// sin at line 102, column 17
// dot at line 102, column 21
// st at line 102, column 25
// vec2 at line 102, column 31
// time at line 102, column 69
// popping activation record 0:rand25
// local variables: 
// variable st, unique name 0:rand25:st, index 252, declared at line 101, column 21
// variable time, unique name 0:rand25:time, index 253, declared at line 101, column 33
// references:
// pushing activation record 0:ground7
float ground(in vec2 p)
{
// pushing activation record 0:ground7:8
    float len = max(1., 0.0001 * length(p));
    float hx = max(0., (sin(P1 * (p.x + p.y)) + AMP * sin(P2 * p.x + PIdiv2) + SHIFT));
    float hy = max(0., (sin(P1 * (p.y + .5 * p.x)) + AMP * sin(P3 * p.y + PIdiv2) + SHIFT));
    return maxHill * (hx + hy) / NRM / len;

}
// popping activation record 0:ground7:8
// local variables: 
// variable len, unique name 0:ground7:8:len, index 256, declared at line 107, column 10
// variable hx, unique name 0:ground7:8:hx, index 257, declared at line 108, column 10
// variable hy, unique name 0:ground7:8:hy, index 258, declared at line 109, column 10
// references:
// max at line 107, column 16
// length at line 107, column 30
// p at line 107, column 37
// max at line 108, column 15
// sin at line 108, column 24
// P1 at line 108, column 28
// p at line 108, column 32
// p at line 108, column 36
// AMP at line 108, column 44
// sin at line 108, column 48
// P2 at line 108, column 52
// p at line 108, column 55
// PIdiv2 at line 108, column 59
// SHIFT at line 108, column 69
// max at line 109, column 15
// sin at line 109, column 24
// P1 at line 109, column 28
// p at line 109, column 32
// p at line 109, column 39
// AMP at line 109, column 47
// sin at line 109, column 51
// P3 at line 109, column 55
// p at line 109, column 58
// PIdiv2 at line 109, column 62
// SHIFT at line 109, column 72
// maxHill at line 110, column 11
// hx at line 110, column 20
// hy at line 110, column 23
// NRM at line 110, column 27
// len at line 110, column 31
// popping activation record 0:ground7
// local variables: 
// variable p, unique name 0:ground7:p, index 255, declared at line 106, column 21
// references:
// pushing activation record 0:getGndNormal9
vec3 getGndNormal(in vec2 p, in float h)
{
// pushing activation record 0:getGndNormal9:10
    if (h < .001) return vec3(0., 1., 0.);

}
// popping activation record 0:getGndNormal9:10
// local variables: 
// references:
// h at line 116, column 7
// vec3 at line 116, column 22
// popping activation record 0:getGndNormal9
// local variables: 
// variable p, unique name 0:getGndNormal9:p, index 260, declared at line 115, column 26
// variable h, unique name 0:getGndNormal9:h, index 261, declared at line 115, column 38
// references:
// pushing activation record 0:gndRayTrace11
float gndRayTrace(in vec3 p, in vec3 ray)
{
// pushing activation record 0:gndRayTrace11:12
    float t = 0.;
    float contact = .5;
    float dh = p.y - ground(p.xz);
    if (dh < contact) return .0001;
    // pushing activation record 0:gndRayTrace11:12:for13
    for (int i = 0; i < 100; i++) {
    // pushing activation record 0:gndRayTrace11:12:for13:14
        t += dh;
        p += dh * ray;
        if (p.y >= cellH && ray.y >= 0.) {
        // pushing activation record 0:gndRayTrace11:12:for13:14:15
            t = INFINI;
            break;

        }
        // popping activation record 0:gndRayTrace11:12:for13:14:15
        // local variables: 
        // references:
        // t at line 135, column 12
        // INFINI at line 135, column 16
        dh = p.y - ground(p.xz);
        if (abs(dh) < contact) break;

    }
    // popping activation record 0:gndRayTrace11:12:for13:14
    // local variables: 
    // references:
    // t at line 132, column 8
    // dh at line 132, column 13
    // p at line 133, column 8
    // dh at line 133, column 13
    // ray at line 133, column 16
    // p at line 134, column 11
    // cellH at line 134, column 18
    // ray at line 134, column 27
    // dh at line 138, column 8
    // p at line 138, column 13
    // ground at line 138, column 19
    // p at line 138, column 26
    // abs at line 139, column 11
    // dh at line 139, column 15
    // contact at line 139, column 19
    // popping activation record 0:gndRayTrace11:12:for13
    // local variables: 
    // variable i, unique name 0:gndRayTrace11:12:for13:i, index 268, declared at line 131, column 12
    // references:
    // i at line 131, column 17
    // i at line 131, column 23
    return t;

}
// popping activation record 0:gndRayTrace11:12
// local variables: 
// variable t, unique name 0:gndRayTrace11:12:t, index 265, declared at line 127, column 10
// variable contact, unique name 0:gndRayTrace11:12:contact, index 266, declared at line 128, column 10
// variable dh, unique name 0:gndRayTrace11:12:dh, index 267, declared at line 129, column 10
// references:
// p at line 129, column 15
// ground at line 129, column 21
// p at line 129, column 28
// dh at line 130, column 7
// contact at line 130, column 10
// t at line 141, column 11
// popping activation record 0:gndRayTrace11
// local variables: 
// variable p, unique name 0:gndRayTrace11:p, index 263, declared at line 126, column 26
// variable ray, unique name 0:gndRayTrace11:ray, index 264, declared at line 126, column 37
// references:
// pushing activation record 0:sfcImpact16
float sfcImpact(in vec3 p, in vec3 ray, float h)
{
// pushing activation record 0:sfcImpact16:17
    float t = (h - p.y) / ray.y;
    if (t <= 0.001) t = INFINI;
    return t;

}
// popping activation record 0:sfcImpact16:17
// local variables: 
// variable t, unique name 0:sfcImpact16:17:t, index 273, declared at line 146, column 10
// references:
// h at line 146, column 15
// p at line 146, column 17
// ray at line 146, column 22
// t at line 147, column 8
// t at line 147, column 20
// INFINI at line 147, column 24
// t at line 148, column 11
// popping activation record 0:sfcImpact16
// local variables: 
// variable p, unique name 0:sfcImpact16:p, index 270, declared at line 145, column 24
// variable ray, unique name 0:sfcImpact16:ray, index 271, declared at line 145, column 35
// variable h, unique name 0:sfcImpact16:h, index 272, declared at line 145, column 46
// references:
// pushing activation record 0:sphereImpact18
float sphereImpact(in vec3 pos, in vec3 sphO, in float sphR, in vec3 ray)
{
// pushing activation record 0:sphereImpact18:19
    float t = INFINI;
    vec3 d = sphO - pos;
    float dmin = 0.;
    float b = dot(d, ray);
    if (b >= 0.) {
    // pushing activation record 0:sphereImpact18:19:20
        float a = dot(ray, ray);
        float c = dot(d, d) - sphR * sphR;
        float disc = b * b - c;
        if (disc >= 0.) {
        // pushing activation record 0:sphereImpact18:19:20:21
            float sqdisc = sqrt(disc);
            float t1 = (b + sqdisc) / a;
            float t2 = (b - sqdisc) / a;
            t = min(t1, t2);
            if (t <= 0.001) {
            // pushing activation record 0:sphereImpact18:19:20:21:22
                t = max(t1, t2);
                if (t <= 0.001) t = INFINI;

            }
            // popping activation record 0:sphereImpact18:19:20:21:22
            // local variables: 
            // references:
            // t at line 167, column 16
            // max at line 167, column 20
            // t1 at line 167, column 24
            // t2 at line 167, column 27
            // t at line 168, column 20
            // t at line 168, column 32
            // INFINI at line 168, column 36

        }
        // popping activation record 0:sphereImpact18:19:20:21
        // local variables: 
        // variable sqdisc, unique name 0:sphereImpact18:19:20:21:sqdisc, index 286, declared at line 162, column 15
        // variable t1, unique name 0:sphereImpact18:19:20:21:t1, index 287, declared at line 163, column 18
        // variable t2, unique name 0:sphereImpact18:19:20:21:t2, index 288, declared at line 164, column 18
        // references:
        // sqrt at line 162, column 24
        // disc at line 162, column 29
        // b at line 163, column 23
        // sqdisc at line 163, column 27
        // a at line 163, column 35
        // b at line 164, column 23
        // sqdisc at line 164, column 27
        // a at line 164, column 35
        // t at line 165, column 9
        // min at line 165, column 13
        // t1 at line 165, column 17
        // t2 at line 165, column 20
        // t at line 166, column 13

    }
    // popping activation record 0:sphereImpact18:19:20
    // local variables: 
    // variable a, unique name 0:sphereImpact18:19:20:a, index 283, declared at line 158, column 14
    // variable c, unique name 0:sphereImpact18:19:20:c, index 284, declared at line 159, column 14
    // variable disc, unique name 0:sphereImpact18:19:20:disc, index 285, declared at line 160, column 11
    // references:
    // dot at line 158, column 18
    // ray at line 158, column 22
    // ray at line 158, column 26
    // dot at line 159, column 18
    // d at line 159, column 22
    // d at line 159, column 24
    // sphR at line 159, column 29
    // sphR at line 159, column 34
    // b at line 160, column 18
    // b at line 160, column 20
    // c at line 160, column 24
    // disc at line 161, column 9
    return t;

}
// popping activation record 0:sphereImpact18:19
// local variables: 
// variable t, unique name 0:sphereImpact18:19:t, index 279, declared at line 152, column 10
// variable d, unique name 0:sphereImpact18:19:d, index 280, declared at line 153, column 9
// variable dmin, unique name 0:sphereImpact18:19:dmin, index 281, declared at line 154, column 10
// variable b, unique name 0:sphereImpact18:19:b, index 282, declared at line 155, column 10
// references:
// INFINI at line 152, column 14
// sphO at line 153, column 13
// pos at line 153, column 20
// dot at line 155, column 14
// d at line 155, column 18
// ray at line 155, column 21
// b at line 157, column 8
// t at line 172, column 11
// popping activation record 0:sphereImpact18
// local variables: 
// variable pos, unique name 0:sphereImpact18:pos, index 275, declared at line 151, column 27
// variable sphO, unique name 0:sphereImpact18:sphO, index 276, declared at line 151, column 40
// variable sphR, unique name 0:sphereImpact18:sphR, index 277, declared at line 151, column 55
// variable ray, unique name 0:sphereImpact18:ray, index 278, declared at line 151, column 69
// references:
// pushing activation record 0:coneImpact23
float coneImpact(in vec3 pos, in vec3 coneO, in float coneH, in float coneR, in vec3 ray)
{
// pushing activation record 0:coneImpact23:24
    float t = INFINI, dmin = 0.;
    vec3 d = coneO - pos;
    float Dy = coneH + d.y;
    float r2 = coneR * coneR / (coneH * coneH);
    float b = dot(d.xz, ray.xz);
    if (b >= 0.) {
    // pushing activation record 0:coneImpact23:24:25
        float a = dot(ray.xz, ray.xz);
        float c = dot(d.xz, d.xz) - r2 * Dy * Dy;
        float c1 = -b + r2 * Dy * ray.y;
        float disc = c1 * c1 - (a - r2 * ray.y * ray.y) * c;
        if (disc >= 0.) {
        // pushing activation record 0:coneImpact23:24:25:26
            float sqdis = sqrt(disc);
            float t1 = (-c1 + sqdis) / (a - r2 * ray.y * ray.y);
            float t2 = (-c1 - sqdis) / (a - r2 * ray.y * ray.y);
            float ofc = -ray.y * t1 + Dy;
            t1 *= step(0., ofc) * (1. - step(coneH, ofc));
            if (t1 <= 0.001) t1 = INFINI;
            ofc = -ray.y * t2 + Dy;
            t2 *= step(0., ofc) * (1. - step(coneH, ofc));
            if (t2 <= 0.001) t2 = INFINI;
            t = min(t1, t2);

        }
        // popping activation record 0:coneImpact23:24:25:26
        // local variables: 
        // variable sqdis, unique name 0:coneImpact23:24:25:26:sqdis, index 305, declared at line 188, column 15
        // variable t1, unique name 0:coneImpact23:24:25:26:t1, index 306, declared at line 189, column 15
        // variable t2, unique name 0:coneImpact23:24:25:26:t2, index 307, declared at line 190, column 15
        // variable ofc, unique name 0:coneImpact23:24:25:26:ofc, index 308, declared at line 192, column 15
        // references:
        // sqrt at line 188, column 23
        // disc at line 188, column 28
        // c1 at line 189, column 22
        // sqdis at line 189, column 27
        // a at line 189, column 35
        // r2 at line 189, column 39
        // ray at line 189, column 42
        // ray at line 189, column 48
        // c1 at line 190, column 22
        // sqdis at line 190, column 27
        // a at line 190, column 35
        // r2 at line 190, column 39
        // ray at line 190, column 42
        // ray at line 190, column 48
        // ray at line 192, column 22
        // t1 at line 192, column 28
        // Dy at line 192, column 33
        // t1 at line 193, column 6
        // step at line 193, column 12
        // ofc at line 193, column 20
        // step at line 193, column 29
        // coneH at line 193, column 34
        // ofc at line 193, column 40
        // t1 at line 194, column 13
        // t1 at line 194, column 26
        // INFINI at line 194, column 31
        // ofc at line 196, column 9
        // ray at line 196, column 16
        // t2 at line 196, column 22
        // Dy at line 196, column 27
        // t2 at line 197, column 9
        // step at line 197, column 15
        // ofc at line 197, column 23
        // step at line 197, column 32
        // coneH at line 197, column 37
        // ofc at line 197, column 43
        // t2 at line 198, column 13
        // t2 at line 198, column 26
        // INFINI at line 198, column 31
        // t at line 200, column 9
        // min at line 200, column 13
        // t1 at line 200, column 17
        // t2 at line 200, column 20

    }
    // popping activation record 0:coneImpact23:24:25
    // local variables: 
    // variable a, unique name 0:coneImpact23:24:25:a, index 301, declared at line 183, column 11
    // variable c, unique name 0:coneImpact23:24:25:c, index 302, declared at line 184, column 11
    // variable c1, unique name 0:coneImpact23:24:25:c1, index 303, declared at line 185, column 11
    // variable disc, unique name 0:coneImpact23:24:25:disc, index 304, declared at line 186, column 11
    // references:
    // dot at line 183, column 15
    // ray at line 183, column 19
    // ray at line 183, column 26
    // dot at line 184, column 15
    // d at line 184, column 19
    // d at line 184, column 24
    // r2 at line 184, column 32
    // Dy at line 184, column 35
    // Dy at line 184, column 38
    // b at line 185, column 17
    // r2 at line 185, column 21
    // Dy at line 185, column 24
    // ray at line 185, column 27
    // c1 at line 186, column 18
    // c1 at line 186, column 21
    // a at line 186, column 27
    // r2 at line 186, column 31
    // ray at line 186, column 34
    // ray at line 186, column 40
    // c at line 186, column 49
    // disc at line 187, column 9
    return t;

}
// popping activation record 0:coneImpact23:24
// local variables: 
// variable t, unique name 0:coneImpact23:24:t, index 295, declared at line 176, column 10
// variable dmin, unique name 0:coneImpact23:24:dmin, index 296, declared at line 176, column 22
// variable d, unique name 0:coneImpact23:24:d, index 297, declared at line 177, column 9
// variable Dy, unique name 0:coneImpact23:24:Dy, index 298, declared at line 178, column 10
// variable r2, unique name 0:coneImpact23:24:r2, index 299, declared at line 179, column 10
// variable b, unique name 0:coneImpact23:24:b, index 300, declared at line 180, column 10
// references:
// INFINI at line 176, column 14
// coneO at line 177, column 13
// pos at line 177, column 21
// coneH at line 178, column 15
// d at line 178, column 23
// coneR at line 179, column 15
// coneR at line 179, column 21
// coneH at line 179, column 28
// coneH at line 179, column 34
// dot at line 180, column 14
// d at line 180, column 18
// ray at line 180, column 24
// b at line 182, column 8
// t at line 203, column 8
// popping activation record 0:coneImpact23
// local variables: 
// variable pos, unique name 0:coneImpact23:pos, index 290, declared at line 175, column 25
// variable coneO, unique name 0:coneImpact23:coneO, index 291, declared at line 175, column 38
// variable coneH, unique name 0:coneImpact23:coneH, index 292, declared at line 175, column 54
// variable coneR, unique name 0:coneImpact23:coneR, index 293, declared at line 175, column 70
// variable ray, unique name 0:coneImpact23:ray, index 294, declared at line 175, column 85
// references:
// pushing activation record 0:skyGlow27
vec3 skyGlow(in vec3 ray)
{
// pushing activation record 0:skyGlow27:28
    if (ray.y >= 0.) return vec3(.5 * max(ray.x + .7, 0.) * (.8 - max(0., ray.y)), .35, .4) * (1. - ray.y) * (ray.x + 1.5) * .4;

}
// popping activation record 0:skyGlow27:28
// local variables: 
// references:
// ray at line 210, column 7
// vec3 at line 210, column 24
// max at line 210, column 32
// ray at line 210, column 36
// max at line 210, column 53
// ray at line 210, column 60
// ray at line 210, column 81
// ray at line 210, column 89
// popping activation record 0:skyGlow27
// local variables: 
// variable ray, unique name 0:skyGlow27:ray, index 310, declared at line 209, column 21
// references:
// pushing activation record 0:snowColor29
vec3 snowColor(in vec3 pos)
{
// pushing activation record 0:snowColor29:30
    vec3 col = vec3(.7, .7, .75) + vec3(.05, .05, .05) * rand2(floor(pos.xz * 10.), 0.);
    col += vec3(1., .7, .8) * step(.997, rand2(floor(pos.xz * 20.), 0.));
    return col;

}
// popping activation record 0:snowColor29:30
// local variables: 
// variable col, unique name 0:snowColor29:30:col, index 313, declared at line 215, column 9
// references:
// vec3 at line 215, column 15
// vec3 at line 215, column 31
// rand2 at line 215, column 49
// floor at line 215, column 55
// pos at line 215, column 61
// col at line 216, column 4
// vec3 at line 216, column 11
// step at line 216, column 26
// rand2 at line 216, column 36
// floor at line 216, column 43
// pos at line 216, column 49
// col at line 217, column 11
// popping activation record 0:snowColor29
// local variables: 
// variable pos, unique name 0:snowColor29:pos, index 312, declared at line 214, column 23
// references:
// pushing activation record 0:CtreeColor31
vec3 CtreeColor(in vec3 pos)
{
// pushing activation record 0:CtreeColor31:32
    return .5 * vec3(.5, .5, 1.) * min(1., 30. / length(pos - CtreeO - vec3(0., CtreeH / 2., 0.)));

}
// popping activation record 0:CtreeColor31:32
// local variables: 
// references:
// vec3 at line 223, column 14
// min at line 223, column 29
// length at line 223, column 40
// pos at line 223, column 47
// CtreeO at line 223, column 51
// vec3 at line 223, column 58
// CtreeH at line 223, column 66
// popping activation record 0:CtreeColor31
// local variables: 
// variable pos, unique name 0:CtreeColor31:pos, index 315, declared at line 222, column 24
// references:
// pushing activation record 0:lightColor33
vec3 lightColor(in vec3 pos)
{
// pushing activation record 0:lightColor33:34
    vec3 color = vec3(0.);
    color.r += min(1., 5. / length(pos - redO));
    color.rb += min(1., 5. / length(pos - magO));
    color.b += min(1., 10. / length(pos - bluO));
    color.rg += min(1., 3. / length(pos - yelO));
    return color;

}
// popping activation record 0:lightColor33:34
// local variables: 
// variable color, unique name 0:lightColor33:34:color, index 318, declared at line 228, column 9
// references:
// vec3 at line 228, column 17
// color at line 229, column 4
// min at line 229, column 15
// length at line 229, column 25
// pos at line 229, column 32
// redO at line 229, column 36
// color at line 230, column 4
// min at line 230, column 16
// length at line 230, column 26
// pos at line 230, column 33
// magO at line 230, column 37
// color at line 231, column 4
// min at line 231, column 15
// length at line 231, column 26
// pos at line 231, column 33
// bluO at line 231, column 37
// color at line 232, column 4
// min at line 232, column 16
// length at line 232, column 26
// pos at line 232, column 33
// yelO at line 232, column 37
// color at line 233, column 11
// popping activation record 0:lightColor33
// local variables: 
// variable pos, unique name 0:lightColor33:pos, index 317, declared at line 227, column 24
// references:
// pushing activation record 0:window35
vec3 window(in float angl, in vec3 pos)
{
// pushing activation record 0:window35:36
    float dh = pos.y - wallO.y - .25 * wallR;
    float an = fract(3. * angl / PI) - .5;
    return vec3(1., .5, .0) * (smoothstep(-.9, -.8, -abs(abs(dh) - 1.)) * (smoothstep(-.04, -.03, -abs(abs(an) - .04))) + .2 * (1. - smoothstep(.0, .4, abs(an))));

}
// popping activation record 0:window35:36
// local variables: 
// variable dh, unique name 0:window35:36:dh, index 322, declared at line 238, column 10
// variable an, unique name 0:window35:36:an, index 323, declared at line 239, column 10
// references:
// pos at line 238, column 15
// wallO at line 238, column 21
// wallR at line 238, column 33
// fract at line 239, column 15
// angl at line 239, column 24
// PI at line 239, column 29
// vec3 at line 240, column 11
// smoothstep at line 240, column 27
// abs at line 240, column 47
// abs at line 240, column 51
// dh at line 240, column 55
// smoothstep at line 240, column 66
// abs at line 240, column 88
// abs at line 240, column 92
// an at line 240, column 96
// smoothstep at line 240, column 114
// abs at line 240, column 131
// an at line 240, column 135
// popping activation record 0:window35
// local variables: 
// variable angl, unique name 0:window35:angl, index 320, declared at line 237, column 21
// variable pos, unique name 0:window35:pos, index 321, declared at line 237, column 35
// references:
// pushing activation record 0:winLitcolor37
vec3 winLitcolor(vec3 pos)
{
// pushing activation record 0:winLitcolor37:38
    float r = length(pos.xz - wallO.xz) * .01;
    if (r < 2.5) {
    // pushing activation record 0:winLitcolor37:38:39
        float a = fract(3. * atan(pos.z - wallO.z, pos.x - wallO.x) / PI) - .5;
        return vec3(1., .5, .0) * .3 * smoothstep(-2., -.0, -r) * smoothstep(.1, .8, r) * smoothstep(-.5, -.0, -abs(a)) * smoothstep(-60., .0, -pos.y + wallO.y);

    }
    // popping activation record 0:winLitcolor37:38:39
    // local variables: 
    // variable a, unique name 0:winLitcolor37:38:39:a, index 327, declared at line 248, column 11
    // references:
    // fract at line 248, column 14
    // atan at line 248, column 23
    // pos at line 248, column 28
    // wallO at line 248, column 35
    // pos at line 248, column 43
    // wallO at line 248, column 51
    // PI at line 248, column 60
    // vec3 at line 249, column 12
    // smoothstep at line 249, column 30
    // r at line 249, column 50
    // smoothstep at line 249, column 53
    // r at line 249, column 70
    // smoothstep at line 249, column 73
    // abs at line 249, column 93
    // a at line 249, column 97
    // smoothstep at line 249, column 101
    // pos at line 249, column 121
    // wallO at line 249, column 127

}
// popping activation record 0:winLitcolor37:38
// local variables: 
// variable r, unique name 0:winLitcolor37:38:r, index 326, declared at line 246, column 10
// references:
// length at line 246, column 14
// pos at line 246, column 21
// wallO at line 246, column 28
// r at line 247, column 8
// popping activation record 0:winLitcolor37
// local variables: 
// variable pos, unique name 0:winLitcolor37:pos, index 325, declared at line 245, column 22
// references:
// pushing activation record 0:stars40
vec3 stars(in float a, in vec3 ray)
{
// pushing activation record 0:stars40:41
    vec2 star = vec2(a, ray.y * .7) * 30.;
    vec2 p = floor(star);
    if (rand2(p, 0.) > .97) {
    // pushing activation record 0:stars40:41:42
        vec2 f = fract(star) - .5;
        return vec3(.7 * smoothstep(0., .3, abs(fract(iGlobalTime * .3 + 3. * a) - .5)) * ray.y * (smoothstep(-.01, -.0, -abs(f.x * f.y)) + max(0., .1 / length(f) - .2)));

    }
    // popping activation record 0:stars40:41:42
    // local variables: 
    // variable f, unique name 0:stars40:41:42:f, index 333, declared at line 258, column 13
    // references:
    // fract at line 258, column 17
    // star at line 258, column 23
    // vec3 at line 259, column 13
    // smoothstep at line 259, column 21
    // abs at line 259, column 38
    // fract at line 259, column 42
    // iGlobalTime at line 259, column 48
    // a at line 259, column 66
    // ray at line 259, column 74
    // smoothstep at line 259, column 83
    // abs at line 259, column 104
    // f at line 259, column 108
    // f at line 259, column 112
    // max at line 259, column 118
    // length at line 259, column 128
    // f at line 259, column 135

}
// popping activation record 0:stars40:41
// local variables: 
// variable star, unique name 0:stars40:41:star, index 331, declared at line 255, column 9
// variable p, unique name 0:stars40:41:p, index 332, declared at line 256, column 9
// references:
// vec2 at line 255, column 16
// a at line 255, column 21
// ray at line 255, column 23
// floor at line 256, column 13
// star at line 256, column 19
// rand2 at line 257, column 7
// p at line 257, column 13
// popping activation record 0:stars40
// local variables: 
// variable a, unique name 0:stars40:a, index 329, declared at line 254, column 20
// variable ray, unique name 0:stars40:ray, index 330, declared at line 254, column 30
// references:
// pushing activation record 0:boreal43
vec3 boreal(in float a, in vec3 ray)
{
// pushing activation record 0:boreal43:44
    vec3 col = vec3(0.);
    float b = .03 * (asin(clamp(6. * a + 12., -1., 1.)) + PIdiv2);
    float c = .2 * (asin(clamp(-.2 * a * abs(a) - 1.67222, -1., 1.)) + 2.042);
    float d = .05 * (a + 1.) * (asin(clamp(a - 1., -1., 1.)) + PIdiv2);
    float rebord = smoothstep(1.83333, 1.9, -a);
    float rebord2 = smoothstep(-2., -1.9, -a);
    float var1 = (sin(1. / (a + 2.2) + a * 30. + iGlobalTime) + 1.) / 4. + .5;
    float var2 = (sin(a * 10. - iGlobalTime) + 1.) / 4. + .5;
    float var3 = (sin(1. / (a + .04) + a * 10. + iGlobalTime) + 1.) / 4. + .5;
    col += 2.5 * vec3(0.292, ray.y, 0.1) * var1 * smoothstep(b, b + .5 * ray.y, ray.y) * smoothstep(-b - .9 * ray.y, -b, -ray.y) * rebord;
    col += 1. * vec3(.6 - ray.y, .5 * ray.y, 0.15) * var2 * smoothstep(c, c + .07, ray.y) * smoothstep(-c - .5, -c, -ray.y) * rebord;
    col += 2.5 * vec3(0.292, ray.y, 0.1) * var3 * smoothstep(d, d + .5 * ray.y, ray.y) * smoothstep(-d - .9 * ray.y, -d, -ray.y) * rebord2;
    return col;

}
// popping activation record 0:boreal43:44
// local variables: 
// variable col, unique name 0:boreal43:44:col, index 337, declared at line 266, column 9
// variable b, unique name 0:boreal43:44:b, index 338, declared at line 267, column 10
// variable c, unique name 0:boreal43:44:c, index 339, declared at line 268, column 10
// variable d, unique name 0:boreal43:44:d, index 340, declared at line 269, column 10
// variable rebord, unique name 0:boreal43:44:rebord, index 341, declared at line 270, column 10
// variable rebord2, unique name 0:boreal43:44:rebord2, index 342, declared at line 271, column 10
// variable var1, unique name 0:boreal43:44:var1, index 343, declared at line 272, column 10
// variable var2, unique name 0:boreal43:44:var2, index 344, declared at line 273, column 10
// variable var3, unique name 0:boreal43:44:var3, index 345, declared at line 274, column 10
// references:
// vec3 at line 266, column 15
// asin at line 267, column 19
// clamp at line 267, column 24
// a at line 267, column 33
// PIdiv2 at line 267, column 48
// asin at line 268, column 18
// clamp at line 268, column 23
// a at line 268, column 33
// abs at line 268, column 35
// a at line 268, column 39
// a at line 269, column 19
// asin at line 269, column 26
// clamp at line 269, column 31
// a at line 269, column 37
// PIdiv2 at line 269, column 51
// smoothstep at line 270, column 19
// a at line 270, column 43
// smoothstep at line 271, column 20
// a at line 271, column 41
// sin at line 272, column 18
// a at line 272, column 26
// a at line 272, column 33
// iGlobalTime at line 272, column 41
// sin at line 273, column 18
// a at line 273, column 22
// iGlobalTime at line 273, column 30
// sin at line 274, column 18
// a at line 274, column 26
// a at line 274, column 33
// iGlobalTime at line 274, column 41
// col at line 275, column 4
// vec3 at line 275, column 15
// ray at line 275, column 26
// var1 at line 275, column 37
// smoothstep at line 275, column 42
// b at line 275, column 53
// b at line 275, column 55
// ray at line 275, column 60
// ray at line 275, column 66
// smoothstep at line 275, column 73
// b at line 275, column 85
// ray at line 275, column 90
// b at line 275, column 97
// ray at line 275, column 100
// rebord at line 275, column 107
// col at line 276, column 4
// vec3 at line 276, column 14
// ray at line 276, column 22
// ray at line 276, column 31
// var2 at line 276, column 43
// smoothstep at line 276, column 48
// c at line 276, column 59
// c at line 276, column 61
// ray at line 276, column 67
// smoothstep at line 276, column 74
// c at line 276, column 86
// c at line 276, column 92
// ray at line 276, column 95
// rebord at line 276, column 102
// col at line 277, column 4
// vec3 at line 277, column 15
// ray at line 277, column 26
// var3 at line 277, column 37
// smoothstep at line 277, column 42
// d at line 277, column 53
// d at line 277, column 55
// ray at line 277, column 60
// ray at line 277, column 66
// smoothstep at line 277, column 73
// d at line 277, column 85
// ray at line 277, column 90
// d at line 277, column 97
// ray at line 277, column 100
// rebord2 at line 277, column 107
// col at line 278, column 8
// popping activation record 0:boreal43
// local variables: 
// variable a, unique name 0:boreal43:a, index 335, declared at line 265, column 21
// variable ray, unique name 0:boreal43:ray, index 336, declared at line 265, column 31
// references:
// pushing activation record 0:skyColor45
vec3 skyColor(in vec3 ray)
{
// pushing activation record 0:skyColor45:46
    float a = atan(ray.z, ray.x);
    vec3 color = skyGlow(ray);
    color += stars(a, ray);
    color += boreal(a, ray);
    return color;

}
// popping activation record 0:skyColor45:46
// local variables: 
// variable a, unique name 0:skyColor45:46:a, index 348, declared at line 282, column 10
// variable color, unique name 0:skyColor45:46:color, index 349, declared at line 283, column 9
// references:
// atan at line 282, column 14
// ray at line 282, column 19
// ray at line 282, column 25
// skyGlow at line 283, column 17
// ray at line 283, column 25
// color at line 284, column 4
// stars at line 284, column 13
// a at line 284, column 19
// ray at line 284, column 21
// color at line 285, column 4
// boreal at line 285, column 13
// a at line 285, column 20
// ray at line 285, column 23
// color at line 286, column 11
// popping activation record 0:skyColor45
// local variables: 
// variable ray, unique name 0:skyColor45:ray, index 347, declared at line 281, column 22
// references:
// pushing activation record 0:groundColor47
vec3 groundColor(in vec3 pos, in vec3 ray, in vec3 norm)
{
// pushing activation record 0:groundColor47:48
    float len = length(camPos.xz - pos.xz);
    float dir = max(0., dot(-lightRay, norm));
    vec3 color = snowColor(pos * .5) * (.9 * dir + .1);
    color *= .5 + .5 * pos.y / maxHill;
    ray = reflect(ray, norm);
    ray.y = max(0., ray.y);
    color = mix(.9 * skyGlow(ray), color, .7);
    color *= 1. - atan(len / 10000.) / PIdiv2;
    color += vec3(.4 * max(ray.x + .7, 0.), .35, .4) * (ray.x + 1.5) * .4 * atan(len / 20000.) / PIdiv2;
    color += .8 * lightColor(pos);
    color += winLitcolor(pos);
    color += CtreeColor(pos);
    return color;

}
// popping activation record 0:groundColor47:48
// local variables: 
// variable len, unique name 0:groundColor47:48:len, index 354, declared at line 290, column 10
// variable dir, unique name 0:groundColor47:48:dir, index 355, declared at line 291, column 10
// variable color, unique name 0:groundColor47:48:color, index 356, declared at line 292, column 9
// references:
// length at line 290, column 16
// camPos at line 290, column 23
// pos at line 290, column 33
// max at line 291, column 16
// dot at line 291, column 23
// lightRay at line 291, column 28
// norm at line 291, column 37
// snowColor at line 292, column 17
// pos at line 292, column 27
// dir at line 292, column 39
// color at line 293, column 4
// pos at line 293, column 19
// maxHill at line 293, column 25
// ray at line 294, column 4
// reflect at line 294, column 10
// ray at line 294, column 18
// norm at line 294, column 23
// ray at line 295, column 4
// max at line 295, column 12
// ray at line 295, column 19
// color at line 296, column 4
// mix at line 296, column 12
// skyGlow at line 296, column 19
// ray at line 296, column 27
// color at line 296, column 32
// color at line 297, column 4
// atan at line 297, column 16
// len at line 297, column 21
// PIdiv2 at line 297, column 33
// color at line 298, column 4
// vec3 at line 298, column 13
// max at line 298, column 21
// ray at line 298, column 25
// ray at line 298, column 48
// atan at line 298, column 62
// len at line 298, column 67
// PIdiv2 at line 298, column 79
// color at line 299, column 4
// lightColor at line 299, column 16
// pos at line 299, column 27
// color at line 300, column 4
// winLitcolor at line 300, column 13
// pos at line 300, column 25
// color at line 301, column 4
// CtreeColor at line 301, column 13
// pos at line 301, column 24
// color at line 302, column 8
// popping activation record 0:groundColor47
// local variables: 
// variable pos, unique name 0:groundColor47:pos, index 351, declared at line 289, column 25
// variable ray, unique name 0:groundColor47:ray, index 352, declared at line 289, column 38
// variable norm, unique name 0:groundColor47:norm, index 353, declared at line 289, column 51
// references:
// pushing activation record 0:roofColor49
vec3 roofColor(in vec3 p, in vec3 ray, in vec3 norm)
{
// pushing activation record 0:roofColor49:50
    float an = atan((p.z - roofO.z), (p.x - roofO.x));
    float lim = 4. * (.2 * sin(6. * an) + 1.1);
    vec3 tile = (smoothstep(.0, .9, abs(fract(p.y) - .5)) + smoothstep(0., .7, abs(fract(20. * an + step(1., mod(p.y, 2.0)) * 0.5) - .5))) * vec3(0.380, 0.370, 0.207);
    vec3 color = step(-p.y + roofO.y, -lim) * snowColor(p * 5.) + step(p.y - roofO.y, lim) * tile;
    float h = ground(p.xz);
    vec3 gndNorm = getGndNormal(p.xz, h);
    color *= (dot(gndNorm, -lightRay) + .7) / 1.;
    color *= ((dot(lightRay, norm) + 1.) * .3 + .05);
    color += .8 * lightColor(p);
    return color;

}
// popping activation record 0:roofColor49:50
// local variables: 
// variable an, unique name 0:roofColor49:50:an, index 361, declared at line 307, column 10
// variable lim, unique name 0:roofColor49:50:lim, index 362, declared at line 308, column 10
// variable tile, unique name 0:roofColor49:50:tile, index 363, declared at line 309, column 9
// variable color, unique name 0:roofColor49:50:color, index 364, declared at line 310, column 9
// variable h, unique name 0:roofColor49:50:h, index 365, declared at line 311, column 10
// variable gndNorm, unique name 0:roofColor49:50:gndNorm, index 366, declared at line 312, column 9
// references:
// atan at line 307, column 15
// p at line 307, column 21
// roofO at line 307, column 27
// p at line 307, column 37
// roofO at line 307, column 43
// sin at line 308, column 23
// an at line 308, column 30
// smoothstep at line 309, column 17
// abs at line 309, column 35
// fract at line 309, column 39
// p at line 309, column 45
// smoothstep at line 309, column 55
// abs at line 309, column 72
// fract at line 309, column 76
// an at line 309, column 86
// step at line 309, column 89
// mod at line 309, column 98
// p at line 309, column 102
// vec3 at line 309, column 125
// step at line 310, column 17
// p at line 310, column 23
// roofO at line 310, column 27
// lim at line 310, column 36
// snowColor at line 310, column 41
// p at line 310, column 51
// step at line 310, column 59
// p at line 310, column 64
// roofO at line 310, column 68
// lim at line 310, column 76
// tile at line 310, column 81
// ground at line 311, column 14
// p at line 311, column 21
// getGndNormal at line 312, column 19
// p at line 312, column 32
// h at line 312, column 38
// color at line 313, column 4
// dot at line 313, column 14
// gndNorm at line 313, column 18
// lightRay at line 313, column 28
// color at line 314, column 4
// dot at line 314, column 15
// lightRay at line 314, column 19
// norm at line 314, column 28
// color at line 315, column 4
// lightColor at line 315, column 16
// p at line 315, column 27
// color at line 316, column 11
// popping activation record 0:roofColor49
// local variables: 
// variable p, unique name 0:roofColor49:p, index 358, declared at line 306, column 23
// variable ray, unique name 0:roofColor49:ray, index 359, declared at line 306, column 34
// variable norm, unique name 0:roofColor49:norm, index 360, declared at line 306, column 47
// references:
// pushing activation record 0:wallColor51
vec3 wallColor(in vec3 p, in vec3 ray, in vec3 norm)
{
// pushing activation record 0:wallColor51:52
    float angl = atan((p.z - wallO.z), (p.x - wallO.x));
    float lim = 1.3 * (sin(2. * angl) + 1.5);
    vec3 tile = (smoothstep(0., .5, abs(fract(p.y) - .5)) + smoothstep(0., .1, abs(fract(2. * angl) - .5))) * vec3(0.320, 0.296, 0.225);
    vec3 color = step(p.y, lim) * snowColor(p * 5.) + step(-p.y, -lim) * tile;
    ray = reflect(ray, norm);
    if (ray.y > 0.) color = mix(color, skyGlow(ray), .3);
    color *= ((dot(lightRay, norm) + 1.) * .2 + .2);
    color += window(angl, p);
    color += .8 * lightColor(p);
    return color;

}
// popping activation record 0:wallColor51:52
// local variables: 
// variable angl, unique name 0:wallColor51:52:angl, index 371, declared at line 320, column 10
// variable lim, unique name 0:wallColor51:52:lim, index 372, declared at line 321, column 10
// variable tile, unique name 0:wallColor51:52:tile, index 373, declared at line 322, column 9
// variable color, unique name 0:wallColor51:52:color, index 374, declared at line 323, column 9
// references:
// atan at line 320, column 17
// p at line 320, column 23
// wallO at line 320, column 29
// p at line 320, column 39
// wallO at line 320, column 45
// sin at line 321, column 22
// angl at line 321, column 29
// smoothstep at line 322, column 17
// abs at line 322, column 34
// fract at line 322, column 38
// p at line 322, column 44
// smoothstep at line 322, column 54
// abs at line 322, column 71
// fract at line 322, column 75
// angl at line 322, column 84
// vec3 at line 322, column 96
// step at line 323, column 17
// p at line 323, column 22
// lim at line 323, column 26
// snowColor at line 323, column 31
// p at line 323, column 41
// step at line 323, column 49
// p at line 323, column 55
// lim at line 323, column 60
// tile at line 323, column 65
// ray at line 324, column 4
// reflect at line 324, column 10
// ray at line 324, column 18
// norm at line 324, column 23
// ray at line 325, column 7
// color at line 325, column 18
// mix at line 325, column 26
// color at line 325, column 30
// skyGlow at line 325, column 36
// ray at line 325, column 44
// color at line 327, column 4
// dot at line 327, column 15
// lightRay at line 327, column 19
// norm at line 327, column 28
// color at line 328, column 4
// window at line 328, column 13
// angl at line 328, column 20
// p at line 328, column 26
// color at line 329, column 4
// lightColor at line 329, column 16
// p at line 329, column 27
// color at line 330, column 11
// popping activation record 0:wallColor51
// local variables: 
// variable p, unique name 0:wallColor51:p, index 368, declared at line 319, column 23
// variable ray, unique name 0:wallColor51:ray, index 369, declared at line 319, column 34
// variable norm, unique name 0:wallColor51:norm, index 370, declared at line 319, column 47
// references:
// pushing activation record 0:cottaImpact53
bool cottaImpact(in vec3 p, in vec3 ray, inout vec3 color)
{
// pushing activation record 0:cottaImpact53:54
    bool impact = false;
    float tr = coneImpact(p, roofO, roofH, roofR, ray);
    float tw = sphereImpact(p, wallO, wallR, ray);
    float t = min(tr, tw);
    if (t < T) {
    // pushing activation record 0:cottaImpact53:54:55
        T = t;
        p += t * ray;
        impact = true;
        if (t == tr) {
        // pushing activation record 0:cottaImpact53:54:55:56
            hitObj = ROOF;
            vec3 norm = normalize(vec3(p.x - roofO.x, roofR * roofR / (roofH * roofH) * (roofH + roofO.y - p.y), p.z - roofO.z));
            color += roofColor(p, ray, norm);

        }
        // popping activation record 0:cottaImpact53:54:55:56
        // local variables: 
        // variable norm, unique name 0:cottaImpact53:54:55:56:norm, index 383, declared at line 344, column 17
        // references:
        // hitObj at line 343, column 12
        // ROOF at line 343, column 21
        // normalize at line 344, column 24
        // vec3 at line 344, column 34
        // p at line 344, column 39
        // roofO at line 344, column 45
        // roofR at line 344, column 53
        // roofR at line 344, column 59
        // roofH at line 344, column 66
        // roofH at line 344, column 72
        // roofH at line 344, column 80
        // roofO at line 344, column 88
        // p at line 344, column 98
        // p at line 344, column 103
        // roofO at line 344, column 107
        // color at line 345, column 12
        // roofColor at line 345, column 21
        // p at line 345, column 31
        // ray at line 345, column 34
        // norm at line 345, column 39

    }
    // popping activation record 0:cottaImpact53:54:55
    // local variables: 
    // references:
    // T at line 339, column 8
    // t at line 339, column 10
    // p at line 340, column 8
    // t at line 340, column 13
    // ray at line 340, column 15
    // impact at line 341, column 8
    // t at line 342, column 11
    // tr at line 342, column 16
    float R = roofR + .5, H = 1.;
    // pushing activation record 0:cottaImpact53:54:for57
    for (int i = 0; i < 47; i++) {
    // pushing activation record 0:cottaImpact53:54:for57:58
        float fi = float(i);
        float v = fi / 50.;
        float dh = H * (1. + sin(6. * v * TwoPI));
        vec3 bulb = vec3(roofO.x + R * sin(v * TwoPI), roofO.y + dh - .5, roofO.z + R * cos(v * TwoPI));
        float d = length(cross((bulb - p), ray));
        if (!(impact && dot(bulb - p, ray) >= 0.)) {
        // pushing activation record 0:cottaImpact53:54:for57:58:59
            color.rgb += max(0., .15 / d - .005) * (sin(2. * iGlobalTime - fi) + 1.000) / 2.;
            color.r += max(0., .15 / d - .005) * (sin(2. * iGlobalTime + fi) + 1.) / 2.;

        }
        // popping activation record 0:cottaImpact53:54:for57:58:59
        // local variables: 
        // references:
        // color at line 363, column 12
        // max at line 363, column 25
        // d at line 363, column 36
        // sin at line 363, column 45
        // iGlobalTime at line 363, column 52
        // fi at line 363, column 64
        // color at line 364, column 12
        // max at line 364, column 23
        // d at line 364, column 34
        // sin at line 364, column 43
        // iGlobalTime at line 364, column 50
        // fi at line 364, column 62

    }
    // popping activation record 0:cottaImpact53:54:for57:58
    // local variables: 
    // variable fi, unique name 0:cottaImpact53:54:for57:58:fi, index 387, declared at line 357, column 14
    // variable v, unique name 0:cottaImpact53:54:for57:58:v, index 388, declared at line 358, column 14
    // variable dh, unique name 0:cottaImpact53:54:for57:58:dh, index 389, declared at line 359, column 14
    // variable bulb, unique name 0:cottaImpact53:54:for57:58:bulb, index 390, declared at line 360, column 13
    // variable d, unique name 0:cottaImpact53:54:for57:58:d, index 391, declared at line 361, column 8
    // references:
    // float at line 357, column 19
    // i at line 357, column 25
    // fi at line 358, column 18
    // H at line 359, column 19
    // sin at line 359, column 25
    // v at line 359, column 32
    // TwoPI at line 359, column 34
    // vec3 at line 360, column 20
    // roofO at line 360, column 25
    // R at line 360, column 35
    // sin at line 360, column 37
    // v at line 360, column 41
    // TwoPI at line 360, column 43
    // roofO at line 360, column 51
    // dh at line 360, column 59
    // roofO at line 360, column 66
    // R at line 360, column 76
    // cos at line 360, column 78
    // v at line 360, column 82
    // TwoPI at line 360, column 84
    // length at line 361, column 12
    // cross at line 361, column 19
    // bulb at line 361, column 26
    // p at line 361, column 31
    // ray at line 361, column 35
    // impact at line 362, column 14
    // dot at line 362, column 24
    // bulb at line 362, column 28
    // p at line 362, column 33
    // ray at line 362, column 35
    // popping activation record 0:cottaImpact53:54:for57
    // local variables: 
    // variable i, unique name 0:cottaImpact53:54:for57:i, index 386, declared at line 356, column 12
    // references:
    // i at line 356, column 19
    // i at line 356, column 25
    return impact;

}
// popping activation record 0:cottaImpact53:54
// local variables: 
// variable impact, unique name 0:cottaImpact53:54:impact, index 379, declared at line 334, column 9
// variable tr, unique name 0:cottaImpact53:54:tr, index 380, declared at line 335, column 10
// variable tw, unique name 0:cottaImpact53:54:tw, index 381, declared at line 336, column 10
// variable t, unique name 0:cottaImpact53:54:t, index 382, declared at line 337, column 10
// variable R, unique name 0:cottaImpact53:54:R, index 384, declared at line 355, column 10
// variable H, unique name 0:cottaImpact53:54:H, index 385, declared at line 355, column 24
// references:
// coneImpact at line 335, column 15
// p at line 335, column 26
// roofO at line 335, column 29
// roofH at line 335, column 36
// roofR at line 335, column 43
// ray at line 335, column 50
// sphereImpact at line 336, column 15
// p at line 336, column 28
// wallO at line 336, column 31
// wallR at line 336, column 38
// ray at line 336, column 45
// min at line 337, column 14
// tr at line 337, column 18
// tw at line 337, column 21
// t at line 338, column 7
// T at line 338, column 9
// roofR at line 355, column 14
// impact at line 367, column 11
// popping activation record 0:cottaImpact53
// local variables: 
// variable p, unique name 0:cottaImpact53:p, index 376, declared at line 333, column 25
// variable ray, unique name 0:cottaImpact53:ray, index 377, declared at line 333, column 36
// variable color, unique name 0:cottaImpact53:color, index 378, declared at line 333, column 52
// references:
// pushing activation record 0:bellyColor60
vec3 bellyColor(in vec3 p, in vec3 ray, in vec3 norm, in vec3 belly)
{
// pushing activation record 0:bellyColor60:61
    vec3 color = snowColor(norm * 30.);
    color -= vec3(0.016, 0.515, 0.525) * step(.1, abs(p.z - belO.z));
    color -= vec3(0.016, 0.515, 0.525) * step(-.1, -abs(p.z - belO.z)) * step(-belO.x, -p.x);
    ray = reflect(ray, norm);
    if (ray.y > 0.) color = mix(color, skyGlow(ray), .3);
    color *= ((dot(lightRay, norm) + 1.) * .2 + .2);
    color *= (1. - step(-.5, -abs(p.z - belly.z)) * step(0., p.x - belly.x) * step(.9, fract((p.y - belly.y) * .4)));
    color += lightColor(p);
    return color;

}
// popping activation record 0:bellyColor60:61
// local variables: 
// variable color, unique name 0:bellyColor60:61:color, index 397, declared at line 372, column 9
// references:
// snowColor at line 372, column 17
// norm at line 372, column 27
// color at line 373, column 4
// vec3 at line 373, column 13
// step at line 373, column 37
// abs at line 373, column 45
// p at line 373, column 49
// belO at line 373, column 53
// color at line 374, column 4
// vec3 at line 374, column 13
// step at line 374, column 37
// abs at line 374, column 47
// p at line 374, column 51
// belO at line 374, column 55
// step at line 374, column 64
// belO at line 374, column 70
// p at line 374, column 78
// ray at line 375, column 4
// reflect at line 375, column 10
// ray at line 375, column 18
// norm at line 375, column 23
// ray at line 376, column 7
// color at line 376, column 18
// mix at line 376, column 26
// color at line 376, column 30
// skyGlow at line 376, column 36
// ray at line 376, column 44
// color at line 378, column 4
// dot at line 378, column 15
// lightRay at line 378, column 19
// norm at line 378, column 28
// color at line 379, column 4
// step at line 379, column 17
// abs at line 379, column 27
// p at line 379, column 31
// belly at line 379, column 35
// step at line 379, column 45
// p at line 379, column 53
// belly at line 379, column 57
// step at line 379, column 67
// fract at line 379, column 76
// p at line 379, column 83
// belly at line 379, column 87
// color at line 380, column 4
// lightColor at line 380, column 13
// p at line 380, column 24
// color at line 381, column 11
// popping activation record 0:bellyColor60
// local variables: 
// variable p, unique name 0:bellyColor60:p, index 393, declared at line 371, column 24
// variable ray, unique name 0:bellyColor60:ray, index 394, declared at line 371, column 35
// variable norm, unique name 0:bellyColor60:norm, index 395, declared at line 371, column 48
// variable belly, unique name 0:bellyColor60:belly, index 396, declared at line 371, column 62
// references:
// pushing activation record 0:headColor62
vec3 headColor(in vec3 p, in vec3 ray, in vec3 norm, in vec3 head)
{
// pushing activation record 0:headColor62:63
    vec3 color = snowColor(norm * 30.);
    color -= vec3(0.016, 0.515, 0.525) * step(-hedO.y + .4 * exp(p.x - hedO.x - 2.), -p.y);
    color -= (1. - step(.3, length(head.yz + vec2(1.5, 1.5) - p.yz))) * step(hedO.x, p.x);
    color -= (1. - step(.3, length(head.yz + vec2(1.5, -1.5) - p.yz))) * step(hedO.x, p.x);
    ray = reflect(ray, norm);
    if (ray.y > 0.) color = mix(color, skyGlow(ray), .3);
    color *= ((dot(lightRay, norm) + 1.) * .2 + .2);
    color += lightColor(p);
    return color;

}
// popping activation record 0:headColor62:63
// local variables: 
// variable color, unique name 0:headColor62:63:color, index 403, declared at line 385, column 9
// references:
// snowColor at line 385, column 17
// norm at line 385, column 27
// color at line 386, column 4
// vec3 at line 386, column 13
// step at line 386, column 37
// hedO at line 386, column 43
// exp at line 386, column 53
// p at line 386, column 57
// hedO at line 386, column 61
// p at line 386, column 73
// color at line 387, column 4
// step at line 387, column 17
// length at line 387, column 25
// head at line 387, column 32
// vec2 at line 387, column 40
// p at line 387, column 54
// step at line 387, column 62
// hedO at line 387, column 67
// p at line 387, column 74
// color at line 388, column 4
// step at line 388, column 17
// length at line 388, column 25
// head at line 388, column 32
// vec2 at line 388, column 40
// p at line 388, column 55
// step at line 388, column 63
// hedO at line 388, column 68
// p at line 388, column 75
// ray at line 389, column 4
// reflect at line 389, column 10
// ray at line 389, column 18
// norm at line 389, column 23
// ray at line 390, column 7
// color at line 390, column 18
// mix at line 390, column 26
// color at line 390, column 30
// skyGlow at line 390, column 36
// ray at line 390, column 44
// color at line 392, column 4
// dot at line 392, column 15
// lightRay at line 392, column 19
// norm at line 392, column 28
// color at line 393, column 4
// lightColor at line 393, column 13
// p at line 393, column 24
// color at line 394, column 11
// popping activation record 0:headColor62
// local variables: 
// variable p, unique name 0:headColor62:p, index 399, declared at line 384, column 23
// variable ray, unique name 0:headColor62:ray, index 400, declared at line 384, column 34
// variable norm, unique name 0:headColor62:norm, index 401, declared at line 384, column 47
// variable head, unique name 0:headColor62:head, index 402, declared at line 384, column 61
// references:
// pushing activation record 0:hatColor64
vec3 hatColor(in vec3 p, in vec3 ray, in vec3 norm)
{
// pushing activation record 0:hatColor64:65
    vec3 color = snowColor(p * 5.);
    color -= step(.5, fract(p.y * .4)) * vec3(0.016, 0.515, 0.525);
    color *= ((dot(lightRay, norm) + 1.) * .2 + .2);
    color += lightColor(p);
    return color;

}
// popping activation record 0:hatColor64:65
// local variables: 
// variable color, unique name 0:hatColor64:65:color, index 408, declared at line 398, column 9
// references:
// snowColor at line 398, column 17
// p at line 398, column 27
// color at line 399, column 4
// step at line 399, column 13
// fract at line 399, column 21
// p at line 399, column 27
// vec3 at line 399, column 36
// color at line 400, column 4
// dot at line 400, column 15
// lightRay at line 400, column 19
// norm at line 400, column 28
// color at line 401, column 4
// lightColor at line 401, column 13
// p at line 401, column 24
// color at line 402, column 11
// popping activation record 0:hatColor64
// local variables: 
// variable p, unique name 0:hatColor64:p, index 405, declared at line 397, column 22
// variable ray, unique name 0:hatColor64:ray, index 406, declared at line 397, column 33
// variable norm, unique name 0:hatColor64:norm, index 407, declared at line 397, column 46
// references:
// pushing activation record 0:nozColor66
vec3 nozColor(in vec3 p, in vec3 ray, in vec3 norm)
{
// pushing activation record 0:nozColor66:67
    vec3 color = vec3(0.475, 0.250, 0.002);
    color *= ((dot(vec3(0., 1., 0.), norm) + 1.) * .4 + .2);
    color += lightColor(p);
    return color;

}
// popping activation record 0:nozColor66:67
// local variables: 
// variable color, unique name 0:nozColor66:67:color, index 413, declared at line 406, column 9
// references:
// vec3 at line 406, column 17
// color at line 407, column 4
// dot at line 407, column 15
// vec3 at line 407, column 19
// norm at line 407, column 34
// color at line 408, column 4
// lightColor at line 408, column 13
// p at line 408, column 24
// color at line 409, column 11
// popping activation record 0:nozColor66
// local variables: 
// variable p, unique name 0:nozColor66:p, index 410, declared at line 405, column 22
// variable ray, unique name 0:nozColor66:ray, index 411, declared at line 405, column 33
// variable norm, unique name 0:nozColor66:norm, index 412, declared at line 405, column 46
// references:
// pushing activation record 0:caracterImpact68
bool caracterImpact(in vec3 p, in vec3 ray, inout vec3 color)
{
// pushing activation record 0:caracterImpact68:69
    bool impact = false;
    float tbel = sphereImpact(p, belO, belR, ray);
    float thed = sphereImpact(p, hedO, hedR, ray);
    float that = coneImpact(p, hatO, hatH, hatR, ray);
    float tnoz = coneImpact(vec3(-p.y, p.x, p.z), vec3(-nozO.y, nozO.x, nozO.z), nozH, nozR, vec3(-ray.y, ray.x, ray.z));
    float t = min(min(min(tbel, thed), that), tnoz);
    if (t < T) {
    // pushing activation record 0:caracterImpact68:69:70
        T = t;
        p += t * ray;
        impact = true;
        hitObj = SNOWMAN;
        if (t == tbel) {
        // pushing activation record 0:caracterImpact68:69:70:71
            vec3 norm = normalize(p - belO);
            color += bellyColor(p, ray, norm, belO);

        }
        // popping activation record 0:caracterImpact68:69:70:71
        // local variables: 
        // variable norm, unique name 0:caracterImpact68:69:70:71:norm, index 424, declared at line 426, column 17
        // references:
        // normalize at line 426, column 24
        // p at line 426, column 34
        // belO at line 426, column 38
        // color at line 427, column 12
        // bellyColor at line 427, column 21
        // p at line 427, column 32
        // ray at line 427, column 35
        // norm at line 427, column 40
        // belO at line 427, column 46

    }
    // popping activation record 0:caracterImpact68:69:70
    // local variables: 
    // references:
    // T at line 421, column 8
    // t at line 421, column 10
    // p at line 422, column 8
    // t at line 422, column 13
    // ray at line 422, column 15
    // impact at line 423, column 8
    // hitObj at line 424, column 8
    // SNOWMAN at line 424, column 17
    // t at line 425, column 11
    // tbel at line 425, column 16
    return impact;

}
// popping activation record 0:caracterImpact68:69
// local variables: 
// variable impact, unique name 0:caracterImpact68:69:impact, index 418, declared at line 414, column 9
// variable tbel, unique name 0:caracterImpact68:69:tbel, index 419, declared at line 415, column 10
// variable thed, unique name 0:caracterImpact68:69:thed, index 420, declared at line 416, column 10
// variable that, unique name 0:caracterImpact68:69:that, index 421, declared at line 417, column 10
// variable tnoz, unique name 0:caracterImpact68:69:tnoz, index 422, declared at line 418, column 10
// variable t, unique name 0:caracterImpact68:69:t, index 423, declared at line 419, column 10
// references:
// sphereImpact at line 415, column 17
// p at line 415, column 30
// belO at line 415, column 33
// belR at line 415, column 39
// ray at line 415, column 45
// sphereImpact at line 416, column 17
// p at line 416, column 30
// hedO at line 416, column 33
// hedR at line 416, column 39
// ray at line 416, column 45
// coneImpact at line 417, column 17
// p at line 417, column 28
// hatO at line 417, column 31
// hatH at line 417, column 37
// hatR at line 417, column 43
// ray at line 417, column 49
// coneImpact at line 418, column 17
// vec3 at line 418, column 28
// p at line 418, column 34
// p at line 418, column 38
// p at line 418, column 42
// vec3 at line 418, column 48
// nozO at line 418, column 54
// nozO at line 418, column 61
// nozO at line 418, column 68
// nozH at line 418, column 77
// nozR at line 418, column 83
// vec3 at line 418, column 89
// ray at line 418, column 95
// ray at line 418, column 101
// ray at line 418, column 107
// min at line 419, column 14
// min at line 419, column 18
// min at line 419, column 22
// tbel at line 419, column 26
// thed at line 419, column 31
// that at line 419, column 37
// tnoz at line 419, column 43
// t at line 420, column 7
// T at line 420, column 9
// impact at line 448, column 11
// popping activation record 0:caracterImpact68
// local variables: 
// variable p, unique name 0:caracterImpact68:p, index 415, declared at line 413, column 28
// variable ray, unique name 0:caracterImpact68:ray, index 416, declared at line 413, column 39
// variable color, unique name 0:caracterImpact68:color, index 417, declared at line 413, column 54
// references:
// pushing activation record 0:treeColor72
vec3 treeColor(in vec3 p, in vec3 ray, in vec3 norm)
{
// pushing activation record 0:treeColor72:73
    float lim = 40. * (.05 * sin(.6 * p.x) + .5);
    vec3 color = step(-p.y + treeO.y, -lim) * snowColor(fract(p * 5.)) + step(p.y - treeO.y, lim) * vec3(0.000, 0.320, 0.317);
    color *= ((dot(lightRay, norm) + 1.) * .3 + .05);
    vec3 r = reflect(ray, norm);
    r.y = abs(r.y);
    color += step(-p.y + treeO.y, -lim) * .7 * skyGlow(r) * (treeO.y + 10.) / maxHill;
    color *= .6 + .4 * p.y / maxHill;
    color += .8 * lightColor(p);
    color += 1.9 * winLitcolor(p) * max(0., dot(-normalize(p - wallO), norm));
    color *= 1. - atan(length(camPos - p) / 5000.) / PI * 2.;
    return color;

}
// popping activation record 0:treeColor72:73
// local variables: 
// variable lim, unique name 0:treeColor72:73:lim, index 429, declared at line 454, column 10
// variable color, unique name 0:treeColor72:73:color, index 430, declared at line 455, column 9
// variable r, unique name 0:treeColor72:73:r, index 431, declared at line 457, column 9
// references:
// sin at line 454, column 25
// p at line 454, column 32
// step at line 455, column 17
// p at line 455, column 23
// treeO at line 455, column 27
// lim at line 455, column 36
// snowColor at line 455, column 41
// fract at line 455, column 51
// p at line 455, column 57
// step at line 455, column 66
// p at line 455, column 71
// treeO at line 455, column 75
// lim at line 455, column 83
// vec3 at line 455, column 88
// color at line 456, column 4
// dot at line 456, column 15
// lightRay at line 456, column 19
// norm at line 456, column 28
// reflect at line 457, column 13
// ray at line 457, column 21
// norm at line 457, column 25
// r at line 458, column 4
// abs at line 458, column 10
// r at line 458, column 14
// color at line 459, column 4
// step at line 459, column 13
// p at line 459, column 19
// treeO at line 459, column 23
// lim at line 459, column 32
// skyGlow at line 459, column 40
// r at line 459, column 48
// treeO at line 459, column 52
// maxHill at line 459, column 65
// color at line 460, column 4
// p at line 460, column 19
// maxHill at line 460, column 23
// color at line 461, column 4
// lightColor at line 461, column 16
// p at line 461, column 27
// color at line 462, column 4
// winLitcolor at line 462, column 17
// p at line 462, column 29
// max at line 462, column 32
// dot at line 462, column 39
// normalize at line 462, column 44
// p at line 462, column 54
// wallO at line 462, column 56
// norm at line 462, column 63
// color at line 463, column 4
// atan at line 463, column 16
// length at line 463, column 21
// camPos at line 463, column 28
// p at line 463, column 35
// PI at line 463, column 45
// color at line 464, column 8
// popping activation record 0:treeColor72
// local variables: 
// variable p, unique name 0:treeColor72:p, index 426, declared at line 453, column 23
// variable ray, unique name 0:treeColor72:ray, index 427, declared at line 453, column 34
// variable norm, unique name 0:treeColor72:norm, index 428, declared at line 453, column 47
// references:
// pushing activation record 0:getTree74
bool getTree(in vec2 cell, inout vec3 treeO, inout float treeH, inout float treeR)
{
// pushing activation record 0:getTree74:75
    bool treeOk = bool(step(TREE_DENSITY, rand2(cell * 1.331, 1.)));
    if (treeOk) {
    // pushing activation record 0:getTree74:75:76
        treeH = (.5 * rand2(cell * 3.86, 0.) + .5) * maxTreeH;
        treeR = .15 * treeH;
        float lim = (1. - 2. * treeR / cellD);
        treeO = vec3(lim * (rand2(cell * 2.23, 0.) - 0.5) + cell.x, 0., lim * (rand2(cell * 1.41, 0.) - 0.5) + cell.y) * cellD;
        treeO.y += ground(treeO.xz) - 10.;

    }
    // popping activation record 0:getTree74:75:76
    // local variables: 
    // variable lim, unique name 0:getTree74:75:76:lim, index 438, declared at line 473, column 18
    // references:
    // treeH at line 471, column 12
    // rand2 at line 471, column 24
    // cell at line 471, column 30
    // maxTreeH at line 471, column 48
    // treeR at line 472, column 12
    // treeH at line 472, column 24
    // treeR at line 473, column 31
    // cellD at line 473, column 37
    // treeO at line 474, column 12
    // vec3 at line 474, column 20
    // lim at line 474, column 25
    // rand2 at line 474, column 30
    // cell at line 474, column 36
    // cell at line 474, column 59
    // lim at line 474, column 71
    // rand2 at line 474, column 76
    // cell at line 474, column 82
    // cell at line 474, column 105
    // cellD at line 474, column 114
    // treeO at line 475, column 12
    // ground at line 475, column 23
    // treeO at line 475, column 30
    return treeOk;

}
// popping activation record 0:getTree74:75
// local variables: 
// variable treeOk, unique name 0:getTree74:75:treeOk, index 437, declared at line 469, column 9
// references:
// bool at line 469, column 18
// step at line 469, column 23
// TREE_DENSITY at line 469, column 28
// rand2 at line 469, column 41
// cell at line 469, column 47
// treeOk at line 470, column 12
// treeOk at line 477, column 11
// popping activation record 0:getTree74
// local variables: 
// variable cell, unique name 0:getTree74:cell, index 433, declared at line 468, column 21
// variable treeO, unique name 0:getTree74:treeO, index 434, declared at line 468, column 37
// variable treeH, unique name 0:getTree74:treeH, index 435, declared at line 468, column 56
// variable treeR, unique name 0:getTree74:treeR, index 436, declared at line 468, column 75
// references:
// pushing activation record 0:treeImpact77
bool treeImpact(in vec2 cell, in vec3 p, in vec3 ray, inout vec3 color)
{
// pushing activation record 0:treeImpact77:78
    bool impact = false;
    bool tree = getTree(cell, treeO, treeH, treeR);
    if (tree) {
    // pushing activation record 0:treeImpact77:78:79
        float t = coneImpact(p, treeO, treeH, treeR, ray);
        if (t < T) {
        // pushing activation record 0:treeImpact77:78:79:80
            T = t;
            hitObj = TREE;
            impact = true;
            p += t * ray;
            vec3 norm = normalize(vec3(p.x - treeO.x, treeR * treeR / (treeH * treeH) * (treeH + treeO.y - p.y), p.z - treeO.z));
            color += treeColor(p, ray, norm);

        }
        // popping activation record 0:treeImpact77:78:79:80
        // local variables: 
        // variable norm, unique name 0:treeImpact77:78:79:80:norm, index 447, declared at line 490, column 17
        // references:
        // T at line 486, column 12
        // t at line 486, column 14
        // hitObj at line 487, column 12
        // TREE at line 487, column 21
        // impact at line 488, column 12
        // p at line 489, column 12
        // t at line 489, column 17
        // ray at line 489, column 19
        // normalize at line 490, column 24
        // vec3 at line 490, column 34
        // p at line 490, column 39
        // treeO at line 490, column 45
        // treeR at line 490, column 53
        // treeR at line 490, column 59
        // treeH at line 490, column 66
        // treeH at line 490, column 72
        // treeH at line 490, column 80
        // treeO at line 490, column 88
        // p at line 490, column 98
        // p at line 490, column 103
        // treeO at line 490, column 107
        // color at line 491, column 12
        // treeColor at line 491, column 21
        // p at line 491, column 31
        // ray at line 491, column 34
        // norm at line 491, column 39

    }
    // popping activation record 0:treeImpact77:78:79
    // local variables: 
    // variable t, unique name 0:treeImpact77:78:79:t, index 446, declared at line 484, column 14
    // references:
    // coneImpact at line 484, column 18
    // p at line 484, column 29
    // treeO at line 484, column 32
    // treeH at line 484, column 39
    // treeR at line 484, column 46
    // ray at line 484, column 53
    // t at line 485, column 11
    // T at line 485, column 13
    return impact;

}
// popping activation record 0:treeImpact77:78
// local variables: 
// variable impact, unique name 0:treeImpact77:78:impact, index 444, declared at line 481, column 9
// variable tree, unique name 0:treeImpact77:78:tree, index 445, declared at line 482, column 9
// references:
// getTree at line 482, column 16
// cell at line 482, column 24
// treeO at line 482, column 29
// treeH at line 482, column 36
// treeR at line 482, column 43
// tree at line 483, column 7
// impact at line 495, column 11
// popping activation record 0:treeImpact77
// local variables: 
// variable cell, unique name 0:treeImpact77:cell, index 440, declared at line 480, column 24
// variable p, unique name 0:treeImpact77:p, index 441, declared at line 480, column 38
// variable ray, unique name 0:treeImpact77:ray, index 442, declared at line 480, column 49
// variable color, unique name 0:treeImpact77:color, index 443, declared at line 480, column 65
// references:
// pushing activation record 0:CtreeImpact81
bool CtreeImpact(in vec3 p, in vec3 ray, inout vec3 color)
{
// pushing activation record 0:CtreeImpact81:82
    bool impact = false;
    float t = coneImpact(p, CtreeO, CtreeH, CtreeR, ray);
    if (t < T) {
    // pushing activation record 0:CtreeImpact81:82:83
        T = t;
        hitObj = CHRISTREE;
        impact = true;
        p += t * ray;
        vec3 norm = normalize(vec3(p.x - CtreeO.x, CtreeR * CtreeR / (CtreeH * CtreeH) * (CtreeH + CtreeO.y - p.y), p.z - CtreeO.z));
        treeO.y = CtreeO.y;
        color += treeColor(p, ray, norm);

    }
    // popping activation record 0:CtreeImpact81:82:83
    // local variables: 
    // variable norm, unique name 0:CtreeImpact81:82:83:norm, index 454, declared at line 508, column 17
    // references:
    // T at line 504, column 12
    // t at line 504, column 14
    // hitObj at line 505, column 12
    // CHRISTREE at line 505, column 21
    // impact at line 506, column 12
    // p at line 507, column 12
    // t at line 507, column 17
    // ray at line 507, column 19
    // normalize at line 508, column 24
    // vec3 at line 508, column 34
    // p at line 508, column 39
    // CtreeO at line 508, column 45
    // CtreeR at line 508, column 54
    // CtreeR at line 508, column 61
    // CtreeH at line 508, column 69
    // CtreeH at line 508, column 76
    // CtreeH at line 508, column 85
    // CtreeO at line 508, column 94
    // p at line 508, column 105
    // p at line 508, column 110
    // CtreeO at line 508, column 114
    // treeO at line 509, column 12
    // CtreeO at line 509, column 22
    // color at line 510, column 12
    // treeColor at line 510, column 21
    // p at line 510, column 31
    // ray at line 510, column 34
    // norm at line 510, column 39
    float R = CtreeR + 1., H = CtreeH + 5.;
    // pushing activation record 0:CtreeImpact81:82:for84
    for (int i = 0; i < 47; i++) {
    // pushing activation record 0:CtreeImpact81:82:for84:85
        float fi = float(i);
        float v = rand1(fi * 1.87);
        float dh = H * fract(fi * .02);
        float r = R * (H - dh) / H;
        vec3 bulb = vec3(CtreeO.x + r * sin(fi * v), CtreeO.y + dh + 5., CtreeO.z + r * cos(fi * v));
        float d = length(cross((bulb - p), ray));
        if (!(impact && dot(bulb - p, ray) >= 0.)) {
        // pushing activation record 0:CtreeImpact81:82:for84:85:86
            color.rgb += max(0., .15 / d - .005) * (sin(2. * iGlobalTime - fi) + 1.) / 2.;
            color.b += max(0., .15 / d - .005) * (sin(2. * iGlobalTime + fi) + 1.) / 2.;

        }
        // popping activation record 0:CtreeImpact81:82:for84:85:86
        // local variables: 
        // references:
        // color at line 523, column 12
        // max at line 523, column 25
        // d at line 523, column 36
        // sin at line 523, column 45
        // iGlobalTime at line 523, column 52
        // fi at line 523, column 64
        // color at line 524, column 12
        // max at line 524, column 23
        // d at line 524, column 34
        // sin at line 524, column 43
        // iGlobalTime at line 524, column 50
        // fi at line 524, column 62
        if (impact) {
        // pushing activation record 0:CtreeImpact81:82:for84:85:87
            float c = .05 / length(p - bulb);
            color += vec3(c, c, 4. * c);

        }
        // popping activation record 0:CtreeImpact81:82:for84:85:87
        // local variables: 
        // variable c, unique name 0:CtreeImpact81:82:for84:85:87:c, index 464, declared at line 528, column 18
        // references:
        // length at line 528, column 26
        // p at line 528, column 33
        // bulb at line 528, column 35
        // color at line 529, column 12
        // vec3 at line 529, column 21
        // c at line 529, column 26
        // c at line 529, column 28
        // c at line 529, column 33

    }
    // popping activation record 0:CtreeImpact81:82:for84:85
    // local variables: 
    // variable fi, unique name 0:CtreeImpact81:82:for84:85:fi, index 458, declared at line 516, column 14
    // variable v, unique name 0:CtreeImpact81:82:for84:85:v, index 459, declared at line 517, column 14
    // variable dh, unique name 0:CtreeImpact81:82:for84:85:dh, index 460, declared at line 518, column 14
    // variable r, unique name 0:CtreeImpact81:82:for84:85:r, index 461, declared at line 519, column 14
    // variable bulb, unique name 0:CtreeImpact81:82:for84:85:bulb, index 462, declared at line 520, column 13
    // variable d, unique name 0:CtreeImpact81:82:for84:85:d, index 463, declared at line 521, column 8
    // references:
    // float at line 516, column 19
    // i at line 516, column 25
    // rand1 at line 517, column 18
    // fi at line 517, column 24
    // H at line 518, column 19
    // fract at line 518, column 21
    // fi at line 518, column 27
    // R at line 519, column 18
    // H at line 519, column 21
    // dh at line 519, column 23
    // H at line 519, column 27
    // vec3 at line 520, column 20
    // CtreeO at line 520, column 25
    // r at line 520, column 36
    // sin at line 520, column 38
    // fi at line 520, column 42
    // v at line 520, column 45
    // CtreeO at line 520, column 49
    // dh at line 520, column 58
    // CtreeO at line 520, column 65
    // r at line 520, column 76
    // cos at line 520, column 78
    // fi at line 520, column 82
    // v at line 520, column 85
    // length at line 521, column 12
    // cross at line 521, column 19
    // bulb at line 521, column 26
    // p at line 521, column 31
    // ray at line 521, column 35
    // impact at line 522, column 14
    // dot at line 522, column 24
    // bulb at line 522, column 28
    // p at line 522, column 33
    // ray at line 522, column 35
    // impact at line 527, column 11
    // popping activation record 0:CtreeImpact81:82:for84
    // local variables: 
    // variable i, unique name 0:CtreeImpact81:82:for84:i, index 457, declared at line 515, column 12
    // references:
    // i at line 515, column 19
    // i at line 515, column 25
    return impact;

}
// popping activation record 0:CtreeImpact81:82
// local variables: 
// variable impact, unique name 0:CtreeImpact81:82:impact, index 452, declared at line 500, column 9
// variable t, unique name 0:CtreeImpact81:82:t, index 453, declared at line 502, column 10
// variable R, unique name 0:CtreeImpact81:82:R, index 455, declared at line 514, column 10
// variable H, unique name 0:CtreeImpact81:82:H, index 456, declared at line 514, column 25
// references:
// coneImpact at line 502, column 14
// p at line 502, column 25
// CtreeO at line 502, column 28
// CtreeH at line 502, column 36
// CtreeR at line 502, column 44
// ray at line 502, column 52
// t at line 503, column 11
// T at line 503, column 13
// CtreeR at line 514, column 14
// CtreeH at line 514, column 29
// impact at line 533, column 11
// popping activation record 0:CtreeImpact81
// local variables: 
// variable p, unique name 0:CtreeImpact81:p, index 449, declared at line 499, column 25
// variable ray, unique name 0:CtreeImpact81:ray, index 450, declared at line 499, column 36
// variable color, unique name 0:CtreeImpact81:color, index 451, declared at line 499, column 52
// references:
// pushing activation record 0:fairyReflect88
vec3 fairyReflect(in vec3 ray, in vec3 norm)
{
// pushing activation record 0:fairyReflect88:89
    vec3 r = reflect(ray, norm);
    r.y = abs(r.y);
    return skyGlow(r);

}
// popping activation record 0:fairyReflect88:89
// local variables: 
// variable r, unique name 0:fairyReflect88:89:r, index 468, declared at line 539, column 9
// references:
// reflect at line 539, column 13
// ray at line 539, column 21
// norm at line 539, column 25
// r at line 540, column 4
// abs at line 540, column 10
// r at line 540, column 14
// skyGlow at line 541, column 11
// r at line 541, column 19
// popping activation record 0:fairyReflect88
// local variables: 
// variable ray, unique name 0:fairyReflect88:ray, index 466, declared at line 538, column 26
// variable norm, unique name 0:fairyReflect88:norm, index 467, declared at line 538, column 38
// references:
// pushing activation record 0:fairyLight90
vec3 fairyLight(in vec3 ray, in vec3 pos, in int hitObj)
{
// pushing activation record 0:fairyLight90:91
    float cs;
    vec3 norm;
    vec3 refl;
    vec3 col = vec3(0.);
    if (hitObj == REDL) {
    // pushing activation record 0:fairyLight90:91:92
        col.r += .05;
        norm = normalize(redO - pos);
        col += .5 * fairyReflect(ray, norm);
        cs = dot(ray, norm);
        col.r += .2 * smoothstep(-1., 0., -cs);
        col.r += exp(30. * (cs - 1.));

    }
    // popping activation record 0:fairyLight90:91:92
    // local variables: 
    // references:
    // col at line 551, column 8
    // norm at line 552, column 8
    // normalize at line 552, column 15
    // redO at line 552, column 25
    // pos at line 552, column 30
    // col at line 553, column 8
    // fairyReflect at line 553, column 18
    // ray at line 553, column 31
    // norm at line 553, column 35
    // cs at line 554, column 2
    // dot at line 554, column 7
    // ray at line 554, column 11
    // norm at line 554, column 15
    // col at line 555, column 8
    // smoothstep at line 555, column 20
    // cs at line 555, column 39
    // col at line 556, column 5
    // exp at line 556, column 14
    // cs at line 556, column 23
    return col;

}
// popping activation record 0:fairyLight90:91
// local variables: 
// variable cs, unique name 0:fairyLight90:91:cs, index 473, declared at line 546, column 10
// variable norm, unique name 0:fairyLight90:91:norm, index 474, declared at line 547, column 9
// variable refl, unique name 0:fairyLight90:91:refl, index 475, declared at line 548, column 9
// variable col, unique name 0:fairyLight90:91:col, index 476, declared at line 549, column 9
// references:
// vec3 at line 549, column 13
// hitObj at line 550, column 8
// REDL at line 550, column 18
// col at line 582, column 11
// popping activation record 0:fairyLight90
// local variables: 
// variable ray, unique name 0:fairyLight90:ray, index 470, declared at line 545, column 24
// variable pos, unique name 0:fairyLight90:pos, index 471, declared at line 545, column 36
// variable hitObj, unique name 0:fairyLight90:hitObj, index 472, declared at line 545, column 47
// references:
// pushing activation record 0:lightTrace93
float lightTrace(in vec3 pos, in vec3 ray, inout int hitLit, in int trans)
{
// pushing activation record 0:lightTrace93:94
    float t = INFINI, tp;
    if (trans != REDL) {
    // pushing activation record 0:lightTrace93:94:95
        tp = sphereImpact(pos, redO, redR, ray);
        if (tp < t) {
        // pushing activation record 0:lightTrace93:94:95:96
            t = tp;
            hitLit = REDL;

        }
        // popping activation record 0:lightTrace93:94:95:96
        // local variables: 
        // references:
        // t at line 592, column 13
        // tp at line 592, column 17
        // hitLit at line 593, column 13
        // REDL at line 593, column 22

    }
    // popping activation record 0:lightTrace93:94:95
    // local variables: 
    // references:
    // tp at line 590, column 6
    // sphereImpact at line 590, column 11
    // pos at line 590, column 24
    // redO at line 590, column 29
    // redR at line 590, column 35
    // ray at line 590, column 41
    // tp at line 591, column 9
    // t at line 591, column 12
    if (trans != MAGL) {
    // pushing activation record 0:lightTrace93:94:97
        tp = sphereImpact(pos, magO, magR, ray);
        if (tp < t) {
        // pushing activation record 0:lightTrace93:94:97:98
            t = tp;
            hitLit = MAGL;

        }
        // popping activation record 0:lightTrace93:94:97:98
        // local variables: 
        // references:
        // t at line 599, column 13
        // tp at line 599, column 17
        // hitLit at line 600, column 13
        // MAGL at line 600, column 22

    }
    // popping activation record 0:lightTrace93:94:97
    // local variables: 
    // references:
    // tp at line 597, column 6
    // sphereImpact at line 597, column 11
    // pos at line 597, column 24
    // magO at line 597, column 29
    // magR at line 597, column 35
    // ray at line 597, column 41
    // tp at line 598, column 9
    // t at line 598, column 12
    if (trans != BLUL) {
    // pushing activation record 0:lightTrace93:94:99
        tp = sphereImpact(pos, bluO, bluR, ray);
        if (tp < t) {
        // pushing activation record 0:lightTrace93:94:99:100
            t = tp;
            hitLit = BLUL;

        }
        // popping activation record 0:lightTrace93:94:99:100
        // local variables: 
        // references:
        // t at line 606, column 13
        // tp at line 606, column 17
        // hitLit at line 607, column 13
        // BLUL at line 607, column 22

    }
    // popping activation record 0:lightTrace93:94:99
    // local variables: 
    // references:
    // tp at line 604, column 6
    // sphereImpact at line 604, column 11
    // pos at line 604, column 24
    // bluO at line 604, column 29
    // bluR at line 604, column 35
    // ray at line 604, column 41
    // tp at line 605, column 9
    // t at line 605, column 12
    if (trans != YELL) {
    // pushing activation record 0:lightTrace93:94:101
        tp = sphereImpact(pos, yelO, yelR, ray);
        if (tp < t) {
        // pushing activation record 0:lightTrace93:94:101:102
            t = tp;
            hitLit = YELL;

        }
        // popping activation record 0:lightTrace93:94:101:102
        // local variables: 
        // references:
        // t at line 613, column 13
        // tp at line 613, column 17
        // hitLit at line 614, column 13
        // YELL at line 614, column 22

    }
    // popping activation record 0:lightTrace93:94:101
    // local variables: 
    // references:
    // tp at line 611, column 6
    // sphereImpact at line 611, column 11
    // pos at line 611, column 24
    // yelO at line 611, column 29
    // yelR at line 611, column 35
    // ray at line 611, column 41
    // tp at line 612, column 9
    // t at line 612, column 12
    return t;

}
// popping activation record 0:lightTrace93:94
// local variables: 
// variable t, unique name 0:lightTrace93:94:t, index 482, declared at line 587, column 10
// variable tp, unique name 0:lightTrace93:94:tp, index 483, declared at line 587, column 22
// references:
// INFINI at line 587, column 14
// trans at line 589, column 7
// REDL at line 589, column 16
// trans at line 596, column 7
// MAGL at line 596, column 16
// trans at line 603, column 7
// BLUL at line 603, column 16
// trans at line 610, column 7
// YELL at line 610, column 16
// t at line 618, column 11
// popping activation record 0:lightTrace93
// local variables: 
// variable pos, unique name 0:lightTrace93:pos, index 478, declared at line 586, column 25
// variable ray, unique name 0:lightTrace93:ray, index 479, declared at line 586, column 38
// variable hitLit, unique name 0:lightTrace93:hitLit, index 480, declared at line 586, column 52
// variable trans, unique name 0:lightTrace93:trans, index 481, declared at line 586, column 67
// references:
// pushing activation record 0:getNextCell103
vec2 getNextCell(in vec2 p, in vec2 v, in vec2 cell)
{
// pushing activation record 0:getNextCell103:104
    vec2 d = sign(v);
    vec2 dt = ((cell + d * .5) * cellD - p) / v;
    d *= vec2(step(dt.x - 0.02, dt.y), step(dt.y - 0.02, dt.x));
    return cell + d;

}
// popping activation record 0:getNextCell103:104
// local variables: 
// variable d, unique name 0:getNextCell103:104:d, index 488, declared at line 623, column 9
// variable dt, unique name 0:getNextCell103:104:dt, index 489, declared at line 624, column 6
// references:
// sign at line 623, column 13
// v at line 623, column 18
// cell at line 624, column 13
// d at line 624, column 18
// cellD at line 624, column 24
// p at line 624, column 30
// v at line 624, column 33
// d at line 625, column 4
// vec2 at line 625, column 9
// step at line 625, column 15
// dt at line 625, column 20
// dt at line 625, column 30
// step at line 625, column 38
// dt at line 625, column 43
// dt at line 625, column 53
// cell at line 626, column 11
// d at line 626, column 16
// popping activation record 0:getNextCell103
// local variables: 
// variable p, unique name 0:getNextCell103:p, index 485, declared at line 622, column 25
// variable v, unique name 0:getNextCell103:v, index 486, declared at line 622, column 36
// variable cell, unique name 0:getNextCell103:cell, index 487, declared at line 622, column 47
// references:
// pushing activation record 0:checkCell105
bool checkCell(in vec2 cell, in vec3 p, in vec3 ray, inout vec3 color)
{
// pushing activation record 0:checkCell105:106
    bool impact = false;
    if (cell == cottaCell) impact = cottaImpact(p, ray, color);
    return impact;

}
// popping activation record 0:checkCell105:106
// local variables: 
// variable impact, unique name 0:checkCell105:106:impact, index 495, declared at line 631, column 9
// references:
// cell at line 632, column 7
// cottaCell at line 632, column 15
// impact at line 632, column 26
// cottaImpact at line 632, column 35
// p at line 632, column 47
// ray at line 632, column 50
// color at line 632, column 55
// impact at line 636, column 11
// popping activation record 0:checkCell105
// local variables: 
// variable cell, unique name 0:checkCell105:cell, index 491, declared at line 630, column 23
// variable p, unique name 0:checkCell105:p, index 492, declared at line 630, column 37
// variable ray, unique name 0:checkCell105:ray, index 493, declared at line 630, column 48
// variable color, unique name 0:checkCell105:color, index 494, declared at line 630, column 64
// references:
// pushing activation record 0:circle107
vec3 circle(in float ti, in vec3 obj)
{
// pushing activation record 0:circle107:108
    return vec3(80. * cos(ti * TwoPI) + obj.x, 0., 80. * sin(ti * TwoPI) + obj.z);

}
// popping activation record 0:circle107:108
// local variables: 
// references:
// vec3 at line 641, column 11
// cos at line 641, column 20
// ti at line 641, column 24
// TwoPI at line 641, column 27
// obj at line 641, column 36
// sin at line 641, column 51
// ti at line 641, column 55
// TwoPI at line 641, column 58
// obj at line 641, column 67
// popping activation record 0:circle107
// local variables: 
// variable ti, unique name 0:circle107:ti, index 497, declared at line 640, column 21
// variable obj, unique name 0:circle107:obj, index 498, declared at line 640, column 33
// references:
// pushing activation record 0:freetrack109
vec3 freetrack(in float time)
{
// pushing activation record 0:freetrack109:110
    return vec3(1500. * cos(time * .05), 0., 1600. * sin(time * .15));

}
// popping activation record 0:freetrack109:110
// local variables: 
// references:
// vec3 at line 645, column 11
// cos at line 645, column 22
// time at line 645, column 26
// sin at line 645, column 47
// time at line 645, column 51
// popping activation record 0:freetrack109
// local variables: 
// variable time, unique name 0:freetrack109:time, index 500, declared at line 644, column 24
// references:
// pushing activation record 0:transfer111
vec3 transfer(in vec3 tr1, in vec3 tr2, in float dti)
{
// pushing activation record 0:transfer111:112
    return tr1 * (1. + cos(dti * .25 * PI)) / 2. + tr2 * (1. + cos(dti * .25 * PI + PI)) / 2.;

}
// popping activation record 0:transfer111:112
// local variables: 
// references:
// tr1 at line 649, column 11
// cos at line 649, column 19
// dti at line 649, column 23
// PI at line 649, column 31
// tr2 at line 649, column 41
// cos at line 649, column 49
// dti at line 649, column 53
// PI at line 649, column 61
// PI at line 649, column 64
// popping activation record 0:transfer111
// local variables: 
// variable tr1, unique name 0:transfer111:tr1, index 502, declared at line 648, column 22
// variable tr2, unique name 0:transfer111:tr2, index 503, declared at line 648, column 35
// variable dti, unique name 0:transfer111:dti, index 504, declared at line 648, column 49
// references:
// pushing activation record 0:getTrac113
vec3 getTrac(in float time)
{
// pushing activation record 0:getTrac113:114
    float ti = 23. * fract(time * .01);
    vec3 track;
    if (ti < 1.) track = circle(ti, wallO);
    return track;

}
// popping activation record 0:getTrac113:114
// local variables: 
// variable ti, unique name 0:getTrac113:114:ti, index 507, declared at line 653, column 10
// variable track, unique name 0:getTrac113:114:track, index 508, declared at line 654, column 9
// references:
// fract at line 653, column 19
// time at line 653, column 25
// ti at line 656, column 7
// track at line 656, column 14
// circle at line 656, column 22
// ti at line 656, column 29
// wallO at line 656, column 32
// track at line 664, column 11
// popping activation record 0:getTrac113
// local variables: 
// variable time, unique name 0:getTrac113:time, index 506, declared at line 652, column 22
// references:
// pushing activation record 0:getCam115
vec3 getCam(in float time, in vec3 track)
{
// pushing activation record 0:getCam115:116
    float ti = 23. * fract(time * .01);
    vec3 cam;
    if (ti < 1.) cam = wallO;
    return cam;

}
// popping activation record 0:getCam115:116
// local variables: 
// variable ti, unique name 0:getCam115:116:ti, index 512, declared at line 668, column 10
// variable cam, unique name 0:getCam115:116:cam, index 513, declared at line 669, column 9
// references:
// fract at line 668, column 19
// time at line 668, column 25
// ti at line 671, column 7
// cam at line 671, column 14
// wallO at line 671, column 20
// cam at line 679, column 11
// popping activation record 0:getCam115
// local variables: 
// variable time, unique name 0:getCam115:time, index 510, declared at line 667, column 21
// variable track, unique name 0:getCam115:track, index 511, declared at line 667, column 35
// references:
// pushing activation record 0:mainImage117
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage117:118
    vec2 st = fragCoord.xy / iResolution.xy - .5;
    st.x *= iResolution.x / iResolution.y;
    wallO = vec3(400., 4., -600.);
    wallO.y += ground(wallO.xz);
    wallR = 20.;
    roofO = wallO + vec3(0., 8., 0.);
    roofH = 42.;
    roofR = 22.;
    cottaCell = vec2(4., -6.);
    belO = vec3(200., 4., 100.);
    belR = 10.;
    belO.y = ground(belO.xz);
    hedO = belO + vec3(0., 13., 0.);
    hedR = 5.;
    hatO = belO + vec3(0., 16., 0.);
    hatH = 15.;
    hatR = 3.8;
    nozO = belO + vec3(4., 13., 0.);
    nozH = 4.;
    nozR = .8;
    snowmanCell = vec2(2., 1.);
    CtreeO.xz = vec2(1200., -600.);
    CtreeO.y = ground(CtreeO.xz) - 5.;
    CtreeH = 100.;
    CtreeR = 15.;
    CtreeCell = vec2(12., -6.);
    vec3 trac = getTrac(iGlobalTime);
    trac.y += ground(trac.xz) + 15.;
    vec3 tracb = getTrac(iGlobalTime - .5);
    tracb.y = ground(tracb.xz) + 1.;
    redO = trac + vec3(20. * sin(iGlobalTime * 2.), 5. * sin(iGlobalTime * 3.), 10. * cos(iGlobalTime * 2.));
    redR = 3.;
    magO = trac + vec3(10. * sin(1. + iGlobalTime * 2.), 4. * sin(1.6 + iGlobalTime * 3.), 15. * cos(1. + iGlobalTime * 2.));
    magR = 3.;
    bluO = trac + vec3(10. * sin(5. + iGlobalTime * 3.), 2. * sin(3. + iGlobalTime * 2.), 10. * cos(5. + iGlobalTime * 3.));
    bluR = 3.;
    yelO = tracb + vec3(30. * sin(iGlobalTime * 3.), abs(15. * sin(iGlobalTime * 4.) + 4.), 20. * cos(iGlobalTime * 3.));
    yelR = 1.;
    vec3 camTarget = getCam(iGlobalTime, trac);
    float focal = 1.;
    float rau = 500. * (sin(iGlobalTime / 7.) + 1.) + 40., alpha = iMouse.x / iResolution.x * 4. * PI, theta = iMouse.y / iResolution.y * PI / 2. - .00001;
    camPos = rau * vec3(-cos(theta) * sin(alpha), sin(theta), cos(theta) * cos(alpha)) + camTarget;
    camPos.y = max(ground(camPos.xz) + 15., camPos.y);
    vec3 pos = camPos;
    vec3 ww = normalize(camTarget - pos);
    vec3 uu = normalize(cross(ww, vec3(0.0, 1.0, 0.0)));
    vec3 vv = cross(uu, ww);
    vec3 N_ray = normalize(st.x * uu + st.y * vv + focal * ww);
    lightRay = vec3(1., 0., 0.);
    vec3 GNDnorm = vec3(0.);
    vec3 color = vec3(.0);
    vec2 cell, outCell;
    vec3 p = pos;
    T = gndRayTrace(pos, N_ray);
    if (T < INFINI) {
    // pushing activation record 0:mainImage117:118:119
        hitObj = GND;
        vec3 tp = pos + T * N_ray;
        cell = floor(tp.xz / cellD + .5);
        outCell = getNextCell(pos.xz, N_ray.xz, cell);

    }
    // popping activation record 0:mainImage117:118:119
    // local variables: 
    // variable tp, unique name 0:mainImage117:118:119:tp, index 535, declared at line 778, column 13
    // references:
    // hitObj at line 777, column 8
    // GND at line 777, column 17
    // pos at line 778, column 18
    // T at line 778, column 22
    // N_ray at line 778, column 24
    // cell at line 779, column 8
    // floor at line 779, column 15
    // tp at line 779, column 21
    // cellD at line 779, column 27
    // outCell at line 780, column 8
    // getNextCell at line 780, column 18
    // pos at line 780, column 30
    // N_ray at line 780, column 37
    // cell at line 780, column 46
    if (pos.y >= cellH) {
    // pushing activation record 0:mainImage117:118:120
        float t = sfcImpact(pos, N_ray, cellH);
        if (t < INFINI) p = pos + t * N_ray;

    }
    // popping activation record 0:mainImage117:118:120
    // local variables: 
    // variable t, unique name 0:mainImage117:118:120:t, index 536, declared at line 795, column 14
    // references:
    // sfcImpact at line 795, column 18
    // pos at line 795, column 28
    // N_ray at line 795, column 33
    // cellH at line 795, column 40
    // t at line 796, column 11
    // INFINI at line 796, column 13
    // p at line 796, column 21
    // pos at line 796, column 25
    // t at line 796, column 29
    // N_ray at line 796, column 31
    bool objImpact = false;
    cell = floor(p.xz / cellD + .5);
    if (cell != outCell) {
    // pushing activation record 0:mainImage117:118:121
        // pushing activation record 0:mainImage117:118:121:for122
        for (int i = 0; i < maxCell; i++) {
        // pushing activation record 0:mainImage117:118:121:for122:123
            objImpact = checkCell(cell, pos, N_ray, color);
            if (objImpact) break;
            cell = getNextCell(pos.xz, N_ray.xz, cell);
            if (cell == outCell) break;

        }
        // popping activation record 0:mainImage117:118:121:for122:123
        // local variables: 
        // references:
        // objImpact at line 809, column 12
        // checkCell at line 809, column 24
        // cell at line 809, column 34
        // pos at line 809, column 40
        // N_ray at line 809, column 45
        // color at line 809, column 52
        // objImpact at line 810, column 15
        // cell at line 811, column 12
        // getNextCell at line 811, column 19
        // pos at line 811, column 31
        // N_ray at line 811, column 38
        // cell at line 811, column 47
        // cell at line 812, column 15
        // outCell at line 812, column 23
        // popping activation record 0:mainImage117:118:121:for122
        // local variables: 
        // variable i, unique name 0:mainImage117:118:121:for122:i, index 538, declared at line 808, column 16
        // references:
        // i at line 808, column 21
        // maxCell at line 808, column 23
        // i at line 808, column 31

    }
    // popping activation record 0:mainImage117:118:121
    // local variables: 
    // references:
    vec3 finalPos = pos + T * N_ray;
    if (hitObj == SKY) color += skyColor(N_ray);
    if ((abs(N_ray.z * (belO.x - pos.x) - N_ray.x * (belO.z - pos.z)) < 50.) && (dot(belO - pos, N_ray) >= 0.)) {
    // pushing activation record 0:mainImage117:118:124
        float len_fp_p = length(T * N_ray);
        if (len_fp_p > length(belO - pos) - cellD) {
        // pushing activation record 0:mainImage117:118:124:125
            float H = 200., R = 15.;
            // pushing activation record 0:mainImage117:118:124:125:for126
            for (int i = 0; i < 47; i++) {
            // pushing activation record 0:mainImage117:118:124:125:for126:127
                float fi = float(i);
                float ti = -iGlobalTime + fi;
                float dh = H * pow(fract(ti * .02), 4.);
                float r = R * (H - dh) / H;
                float v = rand1(fi);
                vec3 bulb = vec3(belO.x + r * sin(ti * v), belO.y + dh, belO.z + r * cos(ti * v));
                vec3 b_p = bulb - pos;
                vec3 b_fp = bulb - finalPos;
                float d;
                if (len_fp_p < length(b_p)) d = length(b_fp);
                if (!(hitObj == SNOWMAN && dot(b_fp, N_ray) >= 0.)) {
                // pushing activation record 0:mainImage117:118:124:125:for126:127:128
                    color += max(0., .15 / d - .003) * rand1(fi);

                }
                // popping activation record 0:mainImage117:118:124:125:for126:127:128
                // local variables: 
                // references:
                // color at line 849, column 20
                // max at line 849, column 29
                // d at line 849, column 40
                // rand1 at line 849, column 48
                // fi at line 849, column 54

            }
            // popping activation record 0:mainImage117:118:124:125:for126:127
            // local variables: 
            // variable fi, unique name 0:mainImage117:118:124:125:for126:127:fi, index 544, declared at line 837, column 22
            // variable ti, unique name 0:mainImage117:118:124:125:for126:127:ti, index 545, declared at line 838, column 22
            // variable dh, unique name 0:mainImage117:118:124:125:for126:127:dh, index 546, declared at line 839, column 22
            // variable r, unique name 0:mainImage117:118:124:125:for126:127:r, index 547, declared at line 840, column 22
            // variable v, unique name 0:mainImage117:118:124:125:for126:127:v, index 548, declared at line 841, column 22
            // variable bulb, unique name 0:mainImage117:118:124:125:for126:127:bulb, index 549, declared at line 842, column 21
            // variable b_p, unique name 0:mainImage117:118:124:125:for126:127:b_p, index 550, declared at line 843, column 21
            // variable b_fp, unique name 0:mainImage117:118:124:125:for126:127:b_fp, index 551, declared at line 844, column 21
            // variable d, unique name 0:mainImage117:118:124:125:for126:127:d, index 552, declared at line 845, column 22
            // references:
            // float at line 837, column 27
            // i at line 837, column 33
            // iGlobalTime at line 838, column 28
            // fi at line 838, column 40
            // H at line 839, column 27
            // pow at line 839, column 29
            // fract at line 839, column 33
            // ti at line 839, column 39
            // R at line 840, column 26
            // H at line 840, column 29
            // dh at line 840, column 31
            // H at line 840, column 35
            // rand1 at line 841, column 26
            // fi at line 841, column 32
            // vec3 at line 842, column 28
            // belO at line 842, column 33
            // r at line 842, column 42
            // sin at line 842, column 44
            // ti at line 842, column 48
            // v at line 842, column 51
            // belO at line 842, column 55
            // dh at line 842, column 62
            // belO at line 842, column 66
            // r at line 842, column 75
            // cos at line 842, column 77
            // ti at line 842, column 81
            // v at line 842, column 84
            // bulb at line 843, column 27
            // pos at line 843, column 32
            // bulb at line 844, column 28
            // finalPos at line 844, column 33
            // len_fp_p at line 846, column 19
            // length at line 846, column 28
            // b_p at line 846, column 35
            // d at line 846, column 41
            // length at line 846, column 45
            // b_fp at line 846, column 52
            // hitObj at line 848, column 22
            // SNOWMAN at line 848, column 32
            // dot at line 848, column 43
            // b_fp at line 848, column 47
            // N_ray at line 848, column 52
            // popping activation record 0:mainImage117:118:124:125:for126
            // local variables: 
            // variable i, unique name 0:mainImage117:118:124:125:for126:i, index 543, declared at line 836, column 20
            // references:
            // i at line 836, column 27
            // i at line 836, column 33

        }
        // popping activation record 0:mainImage117:118:124:125
        // local variables: 
        // variable H, unique name 0:mainImage117:118:124:125:H, index 541, declared at line 835, column 18
        // variable R, unique name 0:mainImage117:118:124:125:R, index 542, declared at line 835, column 28
        // references:

    }
    // popping activation record 0:mainImage117:118:124
    // local variables: 
    // variable len_fp_p, unique name 0:mainImage117:118:124:len_fp_p, index 540, declared at line 833, column 11
    // references:
    // length at line 833, column 22
    // T at line 833, column 29
    // N_ray at line 833, column 31
    // len_fp_p at line 834, column 11
    // length at line 834, column 22
    // belO at line 834, column 29
    // pos at line 834, column 34
    // cellD at line 834, column 39
    int lightNbr;
    float tlit;
    tlit = lightTrace(pos, N_ray, lightNbr, 0);
    if (tlit < T) {
    // pushing activation record 0:mainImage117:118:129
        hitObj = lightNbr;
        vec3 trpos = pos + tlit * N_ray;
        color += fairyLight(N_ray, trpos, hitObj);
        tlit = lightTrace(pos, N_ray, lightNbr, hitObj);
        if (tlit < INFINI) {
        // pushing activation record 0:mainImage117:118:129:130
            trpos = pos + tlit * N_ray;
            color += fairyLight(N_ray, trpos, lightNbr);

        }
        // popping activation record 0:mainImage117:118:129:130
        // local variables: 
        // references:
        // trpos at line 869, column 12
        // pos at line 869, column 20
        // tlit at line 869, column 26
        // N_ray at line 869, column 31
        // color at line 870, column 9
        // fairyLight at line 870, column 18
        // N_ray at line 870, column 29
        // trpos at line 870, column 36
        // lightNbr at line 870, column 43

    }
    // popping activation record 0:mainImage117:118:129
    // local variables: 
    // variable trpos, unique name 0:mainImage117:118:129:trpos, index 555, declared at line 863, column 13
    // references:
    // hitObj at line 862, column 8
    // lightNbr at line 862, column 17
    // pos at line 863, column 21
    // tlit at line 863, column 27
    // N_ray at line 863, column 32
    // color at line 865, column 5
    // fairyLight at line 865, column 14
    // N_ray at line 865, column 25
    // trpos at line 865, column 32
    // hitObj at line 865, column 39
    // tlit at line 867, column 8
    // lightTrace at line 867, column 15
    // pos at line 867, column 26
    // N_ray at line 867, column 30
    // lightNbr at line 867, column 36
    // hitObj at line 867, column 45
    // tlit at line 868, column 11
    // INFINI at line 868, column 16
    fragColor = vec4(color, 1.0);

}
// popping activation record 0:mainImage117:118
// local variables: 
// variable st, unique name 0:mainImage117:118:st, index 517, declared at line 686, column 9
// variable trac, unique name 0:mainImage117:118:trac, index 518, declared at line 722, column 9
// variable tracb, unique name 0:mainImage117:118:tracb, index 519, declared at line 724, column 9
// variable camTarget, unique name 0:mainImage117:118:camTarget, index 520, declared at line 746, column 9
// variable focal, unique name 0:mainImage117:118:focal, index 521, declared at line 749, column 11
// variable rau, unique name 0:mainImage117:118:rau, index 522, declared at line 750, column 11
// variable alpha, unique name 0:mainImage117:118:alpha, index 523, declared at line 751, column 6
// variable theta, unique name 0:mainImage117:118:theta, index 524, declared at line 752, column 6
// variable pos, unique name 0:mainImage117:118:pos, index 525, declared at line 757, column 9
// variable ww, unique name 0:mainImage117:118:ww, index 526, declared at line 759, column 9
// variable uu, unique name 0:mainImage117:118:uu, index 527, declared at line 760, column 9
// variable vv, unique name 0:mainImage117:118:vv, index 528, declared at line 761, column 9
// variable N_ray, unique name 0:mainImage117:118:N_ray, index 529, declared at line 763, column 6
// variable GNDnorm, unique name 0:mainImage117:118:GNDnorm, index 530, declared at line 766, column 6
// variable color, unique name 0:mainImage117:118:color, index 531, declared at line 768, column 9
// variable cell, unique name 0:mainImage117:118:cell, index 532, declared at line 770, column 9
// variable outCell, unique name 0:mainImage117:118:outCell, index 533, declared at line 770, column 15
// variable p, unique name 0:mainImage117:118:p, index 534, declared at line 771, column 9
// variable objImpact, unique name 0:mainImage117:118:objImpact, index 537, declared at line 805, column 9
// variable finalPos, unique name 0:mainImage117:118:finalPos, index 539, declared at line 816, column 9
// variable lightNbr, unique name 0:mainImage117:118:lightNbr, index 553, declared at line 856, column 8
// variable tlit, unique name 0:mainImage117:118:tlit, index 554, declared at line 857, column 10
// references:
// fragCoord at line 686, column 14
// iResolution at line 686, column 27
// st at line 687, column 4
// iResolution at line 687, column 12
// iResolution at line 687, column 26
// wallO at line 692, column 4
// vec3 at line 692, column 12
// wallO at line 693, column 4
// ground at line 693, column 15
// wallO at line 693, column 22
// wallR at line 694, column 4
// roofO at line 695, column 4
// wallO at line 695, column 12
// vec3 at line 695, column 18
// roofH at line 696, column 4
// roofR at line 697, column 4
// cottaCell at line 698, column 4
// vec2 at line 698, column 16
// belO at line 701, column 4
// vec3 at line 701, column 11
// belR at line 702, column 4
// belO at line 703, column 4
// ground at line 703, column 13
// belO at line 703, column 20
// hedO at line 704, column 4
// belO at line 704, column 11
// vec3 at line 704, column 16
// hedR at line 705, column 4
// hatO at line 706, column 4
// belO at line 706, column 11
// vec3 at line 706, column 16
// hatH at line 707, column 4
// hatR at line 708, column 4
// nozO at line 709, column 4
// belO at line 709, column 11
// vec3 at line 709, column 16
// nozH at line 710, column 4
// nozR at line 711, column 4
// snowmanCell at line 712, column 4
// vec2 at line 712, column 18
// CtreeO at line 715, column 1
// vec2 at line 715, column 13
// CtreeO at line 716, column 1
// ground at line 716, column 12
// CtreeO at line 716, column 19
// CtreeH at line 717, column 4
// CtreeR at line 718, column 4
// CtreeCell at line 719, column 1
// vec2 at line 719, column 13
// getTrac at line 722, column 16
// iGlobalTime at line 722, column 24
// trac at line 723, column 4
// ground at line 723, column 14
// trac at line 723, column 21
// getTrac at line 724, column 17
// iGlobalTime at line 724, column 25
// tracb at line 725, column 4
// ground at line 725, column 14
// tracb at line 725, column 21
// redO at line 726, column 4
// trac at line 726, column 11
// vec3 at line 726, column 18
// sin at line 726, column 27
// iGlobalTime at line 726, column 31
// sin at line 726, column 50
// iGlobalTime at line 726, column 54
// cos at line 726, column 74
// iGlobalTime at line 726, column 78
// redR at line 727, column 4
// magO at line 728, column 4
// trac at line 728, column 11
// vec3 at line 728, column 17
// sin at line 728, column 26
// iGlobalTime at line 728, column 33
// sin at line 728, column 52
// iGlobalTime at line 728, column 60
// cos at line 728, column 80
// iGlobalTime at line 728, column 87
// magR at line 729, column 4
// bluO at line 730, column 4
// trac at line 730, column 11
// vec3 at line 730, column 17
// sin at line 730, column 26
// iGlobalTime at line 730, column 33
// sin at line 730, column 52
// iGlobalTime at line 730, column 59
// cos at line 730, column 79
// iGlobalTime at line 730, column 86
// bluR at line 731, column 4
// yelO at line 732, column 4
// tracb at line 732, column 11
// vec3 at line 732, column 18
// sin at line 732, column 27
// iGlobalTime at line 732, column 31
// abs at line 732, column 47
// sin at line 732, column 55
// iGlobalTime at line 732, column 59
// cos at line 732, column 83
// iGlobalTime at line 732, column 87
// yelR at line 733, column 4
// getCam at line 746, column 21
// iGlobalTime at line 746, column 28
// trac at line 746, column 41
// sin at line 750, column 23
// iGlobalTime at line 750, column 27
// iMouse at line 751, column 14
// iResolution at line 751, column 23
// PI at line 751, column 40
// iMouse at line 752, column 14
// iResolution at line 752, column 23
// PI at line 752, column 37
// camPos at line 754, column 4
// rau at line 754, column 13
// vec3 at line 754, column 17
// cos at line 754, column 23
// theta at line 754, column 27
// sin at line 754, column 34
// alpha at line 754, column 38
// sin at line 754, column 45
// theta at line 754, column 49
// cos at line 754, column 56
// theta at line 754, column 60
// cos at line 754, column 67
// alpha at line 754, column 71
// camTarget at line 754, column 81
// camPos at line 755, column 1
// max at line 755, column 12
// ground at line 755, column 16
// camPos at line 755, column 23
// camPos at line 755, column 38
// camPos at line 757, column 15
// normalize at line 759, column 14
// camTarget at line 759, column 25
// pos at line 759, column 37
// normalize at line 760, column 14
// cross at line 760, column 25
// ww at line 760, column 31
// vec3 at line 760, column 34
// cross at line 761, column 14
// uu at line 761, column 20
// ww at line 761, column 23
// normalize at line 763, column 14
// st at line 763, column 25
// uu at line 763, column 30
// st at line 763, column 35
// vv at line 763, column 40
// focal at line 763, column 45
// ww at line 763, column 51
// lightRay at line 765, column 1
// vec3 at line 765, column 12
// vec3 at line 766, column 16
// vec3 at line 768, column 17
// pos at line 771, column 13
// T at line 775, column 4
// gndRayTrace at line 775, column 8
// pos at line 775, column 20
// N_ray at line 775, column 25
// T at line 776, column 7
// INFINI at line 776, column 9
// pos at line 794, column 7
// cellH at line 794, column 14
// cell at line 806, column 4
// floor at line 806, column 11
// p at line 806, column 17
// cellD at line 806, column 22
// cell at line 807, column 7
// outCell at line 807, column 15
// pos at line 816, column 20
// T at line 816, column 26
// N_ray at line 816, column 28
// hitObj at line 821, column 7
// SKY at line 821, column 17
// color at line 821, column 22
// skyColor at line 821, column 31
// N_ray at line 821, column 40
// abs at line 832, column 9
// N_ray at line 832, column 13
// belO at line 832, column 22
// pos at line 832, column 29
// N_ray at line 832, column 38
// belO at line 832, column 47
// pos at line 832, column 54
// dot at line 832, column 72
// belO at line 832, column 76
// pos at line 832, column 81
// N_ray at line 832, column 86
// tlit at line 859, column 4
// lightTrace at line 859, column 11
// pos at line 859, column 22
// N_ray at line 859, column 26
// lightNbr at line 859, column 32
// tlit at line 861, column 7
// T at line 861, column 12
// fragColor at line 874, column 4
// vec4 at line 874, column 16
// color at line 874, column 21
// popping activation record 0:mainImage117
// local variables: 
// variable fragColor, unique name 0:mainImage117:fragColor, index 515, declared at line 684, column 25
// variable fragCoord, unique name 0:mainImage117:fragCoord, index 516, declared at line 684, column 44
// references:
// undefined variables 
