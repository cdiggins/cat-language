// pushing activation record 0
// pushing activation record 0:hash1
vec2 hash(vec2 p)
{
// pushing activation record 0:hash1:2
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);

}
// popping activation record 0:hash1:2
// local variables: 
// references:
// p at line 11, column 1
// vec2 at line 11, column 5
// dot at line 11, column 11
// p at line 11, column 15
// vec2 at line 11, column 17
// dot at line 12, column 5
// p at line 12, column 9
// vec2 at line 12, column 11
// fract at line 14, column 19
// sin at line 14, column 25
// p at line 14, column 29
// popping activation record 0:hash1
// local variables: 
// variable p, unique name 0:hash1:p, index 179, declared at line 9, column 16
// references:
// pushing activation record 0:noise3
float noise(in vec2 p)
{
// pushing activation record 0:noise3:4
    const float K1 = 0.366025404;
    const float K2 = 0.211324865;
    vec2 i = floor(p + (p.x + p.y) * K1);
    vec2 a = p - i + (i.x + i.y) * K2;
    vec2 o = step(a.yx, a.xy);
    vec2 b = a - o + K2;
    vec2 c = a - 1.0 + 2.0 * K2;
    vec3 h = max(0.5 - vec3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
    vec3 n = h * h * h * h * vec3(dot(a, hash(i + 0.0)), dot(b, hash(i + o)), dot(c, hash(i + 1.0)));
    return dot(n, vec3(70.0));

}
// popping activation record 0:noise3:4
// local variables: 
// variable K1, unique name 0:noise3:4:K1, index 182, declared at line 19, column 16
// variable K2, unique name 0:noise3:4:K2, index 183, declared at line 20, column 16
// variable i, unique name 0:noise3:4:i, index 184, declared at line 22, column 6
// variable a, unique name 0:noise3:4:a, index 185, declared at line 24, column 9
// variable o, unique name 0:noise3:4:o, index 186, declared at line 25, column 9
// variable b, unique name 0:noise3:4:b, index 187, declared at line 26, column 9
// variable c, unique name 0:noise3:4:c, index 188, declared at line 27, column 6
// variable h, unique name 0:noise3:4:h, index 189, declared at line 29, column 9
// variable n, unique name 0:noise3:4:n, index 190, declared at line 31, column 6
// references:
// floor at line 22, column 10
// p at line 22, column 17
// p at line 22, column 22
// p at line 22, column 26
// K1 at line 22, column 31
// p at line 24, column 13
// i at line 24, column 17
// i at line 24, column 22
// i at line 24, column 26
// K2 at line 24, column 31
// step at line 25, column 13
// a at line 25, column 18
// a at line 25, column 23
// a at line 26, column 13
// o at line 26, column 17
// K2 at line 26, column 21
// a at line 27, column 10
// K2 at line 27, column 24
// max at line 29, column 13
// vec3 at line 29, column 22
// dot at line 29, column 27
// a at line 29, column 31
// a at line 29, column 33
// dot at line 29, column 37
// b at line 29, column 41
// b at line 29, column 43
// dot at line 29, column 47
// c at line 29, column 51
// c at line 29, column 53
// h at line 31, column 10
// h at line 31, column 12
// h at line 31, column 14
// h at line 31, column 16
// vec3 at line 31, column 18
// dot at line 31, column 24
// a at line 31, column 28
// hash at line 31, column 30
// i at line 31, column 35
// dot at line 31, column 44
// b at line 31, column 48
// hash at line 31, column 50
// i at line 31, column 55
// o at line 31, column 57
// dot at line 31, column 62
// c at line 31, column 66
// hash at line 31, column 68
// i at line 31, column 73
// dot at line 33, column 11
// n at line 33, column 16
// vec3 at line 33, column 19
// popping activation record 0:noise3
// local variables: 
// variable p, unique name 0:noise3:p, index 181, declared at line 17, column 21
// references:
// pushing activation record 0:reset5
bool reset()
{
// pushing activation record 0:reset5:6
    return texture(iChannel3, vec2(32.5 / 256.0, 0.5)).x > 0.5;

}
// popping activation record 0:reset5:6
// local variables: 
// references:
// texture at line 40, column 11
// iChannel3 at line 40, column 19
// vec2 at line 40, column 30
// popping activation record 0:reset5
// local variables: 
// references:
// pushing activation record 0:normz7
vec2 normz(vec2 x)
{
// pushing activation record 0:normz7:8
    return x == vec2(0.0, 0.0) ? vec2(0.0, 0.0) : normalize(x);

}
// popping activation record 0:normz7:8
// local variables: 
// references:
// x at line 44, column 8
// vec2 at line 44, column 13
// vec2 at line 44, column 30
// normalize at line 44, column 47
// x at line 44, column 57
// popping activation record 0:normz7
// local variables: 
// variable x, unique name 0:normz7:x, index 193, declared at line 43, column 16
// references:
// pushing activation record 0:advect9
vec3 advect(vec2 ab, vec2 vUv, vec2 step, float sc)
{
// pushing activation record 0:advect9:10
    vec2 aUv = vUv - ab * sc * step;
    const float _G0 = 0.25;
    const float _G1 = 0.125;
    const float _G2 = 0.0625;
    float step_x = step.x;
    float step_y = step.y;
    vec2 n = vec2(0.0, step_y);
    vec2 ne = vec2(step_x, step_y);
    vec2 e = vec2(step_x, 0.0);
    vec2 se = vec2(step_x, -step_y);
    vec2 s = vec2(0.0, -step_y);
    vec2 sw = vec2(-step_x, -step_y);
    vec2 w = vec2(-step_x, 0.0);
    vec2 nw = vec2(-step_x, step_y);
    vec3 uv = texture(iChannel0, fract(aUv)).xyz;
    vec3 uv_n = texture(iChannel0, fract(aUv + n)).xyz;
    vec3 uv_e = texture(iChannel0, fract(aUv + e)).xyz;
    vec3 uv_s = texture(iChannel0, fract(aUv + s)).xyz;
    vec3 uv_w = texture(iChannel0, fract(aUv + w)).xyz;
    vec3 uv_nw = texture(iChannel0, fract(aUv + nw)).xyz;
    vec3 uv_sw = texture(iChannel0, fract(aUv + sw)).xyz;
    vec3 uv_ne = texture(iChannel0, fract(aUv + ne)).xyz;
    vec3 uv_se = texture(iChannel0, fract(aUv + se)).xyz;
    return _G0 * uv + _G1 * (uv_n + uv_e + uv_w + uv_s) + _G2 * (uv_nw + uv_sw + uv_ne + uv_se);

}
// popping activation record 0:advect9:10
// local variables: 
// variable aUv, unique name 0:advect9:10:aUv, index 199, declared at line 50, column 9
// variable _G0, unique name 0:advect9:10:_G0, index 200, declared at line 52, column 16
// variable _G1, unique name 0:advect9:10:_G1, index 201, declared at line 53, column 16
// variable _G2, unique name 0:advect9:10:_G2, index 202, declared at line 54, column 16
// variable step_x, unique name 0:advect9:10:step_x, index 203, declared at line 57, column 10
// variable step_y, unique name 0:advect9:10:step_y, index 204, declared at line 58, column 10
// variable n, unique name 0:advect9:10:n, index 205, declared at line 59, column 9
// variable ne, unique name 0:advect9:10:ne, index 206, declared at line 60, column 9
// variable e, unique name 0:advect9:10:e, index 207, declared at line 61, column 9
// variable se, unique name 0:advect9:10:se, index 208, declared at line 62, column 9
// variable s, unique name 0:advect9:10:s, index 209, declared at line 63, column 9
// variable sw, unique name 0:advect9:10:sw, index 210, declared at line 64, column 9
// variable w, unique name 0:advect9:10:w, index 211, declared at line 65, column 9
// variable nw, unique name 0:advect9:10:nw, index 212, declared at line 66, column 9
// variable uv, unique name 0:advect9:10:uv, index 213, declared at line 68, column 9
// variable uv_n, unique name 0:advect9:10:uv_n, index 214, declared at line 69, column 9
// variable uv_e, unique name 0:advect9:10:uv_e, index 215, declared at line 70, column 9
// variable uv_s, unique name 0:advect9:10:uv_s, index 216, declared at line 71, column 9
// variable uv_w, unique name 0:advect9:10:uv_w, index 217, declared at line 72, column 9
// variable uv_nw, unique name 0:advect9:10:uv_nw, index 218, declared at line 73, column 9
// variable uv_sw, unique name 0:advect9:10:uv_sw, index 219, declared at line 74, column 9
// variable uv_ne, unique name 0:advect9:10:uv_ne, index 220, declared at line 75, column 9
// variable uv_se, unique name 0:advect9:10:uv_se, index 221, declared at line 76, column 9
// references:
// vUv at line 50, column 15
// ab at line 50, column 21
// sc at line 50, column 26
// step at line 50, column 31
// step at line 57, column 19
// step at line 58, column 19
// vec2 at line 59, column 14
// step_y at line 59, column 24
// vec2 at line 60, column 14
// step_x at line 60, column 19
// step_y at line 60, column 27
// vec2 at line 61, column 14
// step_x at line 61, column 19
// vec2 at line 62, column 14
// step_x at line 62, column 19
// step_y at line 62, column 28
// vec2 at line 63, column 14
// step_y at line 63, column 25
// vec2 at line 64, column 14
// step_x at line 64, column 20
// step_y at line 64, column 29
// vec2 at line 65, column 14
// step_x at line 65, column 20
// vec2 at line 66, column 14
// step_x at line 66, column 20
// step_y at line 66, column 28
// texture at line 68, column 17
// iChannel0 at line 68, column 25
// fract at line 68, column 36
// aUv at line 68, column 42
// texture at line 69, column 17
// iChannel0 at line 69, column 25
// fract at line 69, column 36
// aUv at line 69, column 42
// n at line 69, column 46
// texture at line 70, column 17
// iChannel0 at line 70, column 25
// fract at line 70, column 36
// aUv at line 70, column 42
// e at line 70, column 46
// texture at line 71, column 17
// iChannel0 at line 71, column 25
// fract at line 71, column 36
// aUv at line 71, column 42
// s at line 71, column 46
// texture at line 72, column 17
// iChannel0 at line 72, column 25
// fract at line 72, column 36
// aUv at line 72, column 42
// w at line 72, column 46
// texture at line 73, column 17
// iChannel0 at line 73, column 25
// fract at line 73, column 36
// aUv at line 73, column 42
// nw at line 73, column 46
// texture at line 74, column 17
// iChannel0 at line 74, column 25
// fract at line 74, column 36
// aUv at line 74, column 42
// sw at line 74, column 46
// texture at line 75, column 17
// iChannel0 at line 75, column 25
// fract at line 75, column 36
// aUv at line 75, column 42
// ne at line 75, column 46
// texture at line 76, column 17
// iChannel0 at line 76, column 25
// fract at line 76, column 36
// aUv at line 76, column 42
// se at line 76, column 46
// _G0 at line 78, column 11
// uv at line 78, column 15
// _G1 at line 78, column 20
// uv_n at line 78, column 25
// uv_e at line 78, column 32
// uv_w at line 78, column 39
// uv_s at line 78, column 46
// _G2 at line 78, column 54
// uv_nw at line 78, column 59
// uv_sw at line 78, column 67
// uv_ne at line 78, column 75
// uv_se at line 78, column 83
// popping activation record 0:advect9
// local variables: 
// variable ab, unique name 0:advect9:ab, index 195, declared at line 48, column 17
// variable vUv, unique name 0:advect9:vUv, index 196, declared at line 48, column 26
// variable step, unique name 0:advect9:step, index 197, declared at line 48, column 36
// variable sc, unique name 0:advect9:sc, index 198, declared at line 48, column 48
// references:
// pushing activation record 0:mainImage11
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage11:12
    const float _K0 = -20.0 / 6.0;
    const float _K1 = 4.0 / 6.0;
    const float _K2 = 1.0 / 6.0;
    const float cs = -0.6;
    const float ls = 0.05;
    const float ps = -0.8;
    const float ds = -0.05;
    const float dp = -0.04;
    const float pl = 0.3;
    const float ad = 6.0;
    const float pwr = 1.0;
    const float amp = 1.0;
    const float upd = 0.8;
    const float sq2 = 0.6;
    vec2 vUv = fragCoord.xy / iResolution.xy;
    vec2 texel = 1. / iResolution.xy;
    float step_x = texel.x;
    float step_y = texel.y;
    vec2 n = vec2(0.0, step_y);
    vec2 ne = vec2(step_x, step_y);
    vec2 e = vec2(step_x, 0.0);
    vec2 se = vec2(step_x, -step_y);
    vec2 s = vec2(0.0, -step_y);
    vec2 sw = vec2(-step_x, -step_y);
    vec2 w = vec2(-step_x, 0.0);
    vec2 nw = vec2(-step_x, step_y);
    vec3 uv = texture(iChannel0, fract(vUv)).xyz;
    vec3 uv_n = texture(iChannel0, fract(vUv + n)).xyz;
    vec3 uv_e = texture(iChannel0, fract(vUv + e)).xyz;
    vec3 uv_s = texture(iChannel0, fract(vUv + s)).xyz;
    vec3 uv_w = texture(iChannel0, fract(vUv + w)).xyz;
    vec3 uv_nw = texture(iChannel0, fract(vUv + nw)).xyz;
    vec3 uv_sw = texture(iChannel0, fract(vUv + sw)).xyz;
    vec3 uv_ne = texture(iChannel0, fract(vUv + ne)).xyz;
    vec3 uv_se = texture(iChannel0, fract(vUv + se)).xyz;
    vec3 lapl = _K0 * uv + _K1 * (uv_n + uv_e + uv_w + uv_s) + _K2 * (uv_nw + uv_sw + uv_ne + uv_se);
    float sp = ps * lapl.z;
    float curl = uv_n.x - uv_s.x - uv_e.y + uv_w.y + sq2 * (uv_nw.x + uv_nw.y + uv_ne.x - uv_ne.y + uv_sw.y - uv_sw.x - uv_se.y - uv_se.x);
    float sc = cs * sign(curl) * pow(abs(curl), pwr);
    float div = uv_s.y - uv_n.y - uv_e.x + uv_w.x + sq2 * (uv_nw.x - uv_nw.y - uv_ne.x - uv_ne.y + uv_sw.x + uv_sw.y + uv_se.y - uv_se.x);
    float sd = uv.z + dp * div + pl * lapl.z;
    vec2 norm = normz(uv.xy);
    vec3 ab = advect(vec2(uv.x, uv.y), vUv, texel, ad);
    float ta = amp * ab.x + ls * lapl.x + norm.x * sp + uv.x * ds * sd;
    float tb = amp * ab.y + ls * lapl.y + norm.y * sp + uv.y * ds * sd;
    float a = ta * cos(sc) - tb * sin(sc);
    float b = ta * sin(sc) + tb * cos(sc);
    vec3 abd = upd * uv + (1.0 - upd) * vec3(a, b, sd);
    if (iMouse.z > 0.0) {
    // pushing activation record 0:mainImage11:12:13
        vec2 d = fragCoord.xy - iMouse.xy;
        float m = exp(-length(d) / 10.0);
        abd.xy += m * normz(d);

    }
    // popping activation record 0:mainImage11:12:13
    // local variables: 
    // variable d, unique name 0:mainImage11:12:13:d, index 273, declared at line 156, column 10
    // variable m, unique name 0:mainImage11:12:13:m, index 274, declared at line 157, column 14
    // references:
    // fragCoord at line 156, column 14
    // iMouse at line 156, column 29
    // exp at line 157, column 18
    // length at line 157, column 23
    // d at line 157, column 30
    // abd at line 158, column 8
    // m at line 158, column 18
    // normz at line 158, column 22
    // d at line 158, column 28
    if (iFrame < 10 || reset()) {
    // pushing activation record 0:mainImage11:12:14
        vec3 rnd = vec3(noise(16.0 * vUv + 1.1), noise(16.0 * vUv + 2.2), noise(16.0 * vUv + 3.3));
        fragColor = vec4(rnd, 0);

    }
    // popping activation record 0:mainImage11:12:14
    // local variables: 
    // variable rnd, unique name 0:mainImage11:12:14:rnd, index 275, declared at line 163, column 13
    // references:
    // vec3 at line 163, column 19
    // noise at line 163, column 24
    // vUv at line 163, column 37
    // noise at line 163, column 49
    // vUv at line 163, column 62
    // noise at line 163, column 74
    // vUv at line 163, column 87
    // fragColor at line 164, column 8
    // vec4 at line 164, column 20
    // rnd at line 164, column 25

}
// popping activation record 0:mainImage11:12
// local variables: 
// variable _K0, unique name 0:mainImage11:12:_K0, index 225, declared at line 83, column 16
// variable _K1, unique name 0:mainImage11:12:_K1, index 226, declared at line 84, column 16
// variable _K2, unique name 0:mainImage11:12:_K2, index 227, declared at line 85, column 16
// variable cs, unique name 0:mainImage11:12:cs, index 228, declared at line 86, column 16
// variable ls, unique name 0:mainImage11:12:ls, index 229, declared at line 87, column 16
// variable ps, unique name 0:mainImage11:12:ps, index 230, declared at line 88, column 16
// variable ds, unique name 0:mainImage11:12:ds, index 231, declared at line 89, column 16
// variable dp, unique name 0:mainImage11:12:dp, index 232, declared at line 90, column 16
// variable pl, unique name 0:mainImage11:12:pl, index 233, declared at line 91, column 16
// variable ad, unique name 0:mainImage11:12:ad, index 234, declared at line 92, column 16
// variable pwr, unique name 0:mainImage11:12:pwr, index 235, declared at line 93, column 16
// variable amp, unique name 0:mainImage11:12:amp, index 236, declared at line 94, column 16
// variable upd, unique name 0:mainImage11:12:upd, index 237, declared at line 95, column 16
// variable sq2, unique name 0:mainImage11:12:sq2, index 238, declared at line 96, column 16
// variable vUv, unique name 0:mainImage11:12:vUv, index 239, declared at line 98, column 9
// variable texel, unique name 0:mainImage11:12:texel, index 240, declared at line 99, column 9
// variable step_x, unique name 0:mainImage11:12:step_x, index 241, declared at line 102, column 10
// variable step_y, unique name 0:mainImage11:12:step_y, index 242, declared at line 103, column 10
// variable n, unique name 0:mainImage11:12:n, index 243, declared at line 104, column 9
// variable ne, unique name 0:mainImage11:12:ne, index 244, declared at line 105, column 9
// variable e, unique name 0:mainImage11:12:e, index 245, declared at line 106, column 9
// variable se, unique name 0:mainImage11:12:se, index 246, declared at line 107, column 9
// variable s, unique name 0:mainImage11:12:s, index 247, declared at line 108, column 9
// variable sw, unique name 0:mainImage11:12:sw, index 248, declared at line 109, column 9
// variable w, unique name 0:mainImage11:12:w, index 249, declared at line 110, column 9
// variable nw, unique name 0:mainImage11:12:nw, index 250, declared at line 111, column 9
// variable uv, unique name 0:mainImage11:12:uv, index 251, declared at line 113, column 9
// variable uv_n, unique name 0:mainImage11:12:uv_n, index 252, declared at line 114, column 9
// variable uv_e, unique name 0:mainImage11:12:uv_e, index 253, declared at line 115, column 9
// variable uv_s, unique name 0:mainImage11:12:uv_s, index 254, declared at line 116, column 9
// variable uv_w, unique name 0:mainImage11:12:uv_w, index 255, declared at line 117, column 9
// variable uv_nw, unique name 0:mainImage11:12:uv_nw, index 256, declared at line 118, column 9
// variable uv_sw, unique name 0:mainImage11:12:uv_sw, index 257, declared at line 119, column 9
// variable uv_ne, unique name 0:mainImage11:12:uv_ne, index 258, declared at line 120, column 9
// variable uv_se, unique name 0:mainImage11:12:uv_se, index 259, declared at line 121, column 9
// variable lapl, unique name 0:mainImage11:12:lapl, index 260, declared at line 126, column 9
// variable sp, unique name 0:mainImage11:12:sp, index 261, declared at line 127, column 10
// variable curl, unique name 0:mainImage11:12:curl, index 262, declared at line 131, column 10
// variable sc, unique name 0:mainImage11:12:sc, index 263, declared at line 134, column 10
// variable div, unique name 0:mainImage11:12:div, index 264, declared at line 138, column 10
// variable sd, unique name 0:mainImage11:12:sd, index 265, declared at line 139, column 10
// variable norm, unique name 0:mainImage11:12:norm, index 266, declared at line 141, column 9
// variable ab, unique name 0:mainImage11:12:ab, index 267, declared at line 143, column 9
// variable ta, unique name 0:mainImage11:12:ta, index 268, declared at line 146, column 10
// variable tb, unique name 0:mainImage11:12:tb, index 269, declared at line 147, column 10
// variable a, unique name 0:mainImage11:12:a, index 270, declared at line 150, column 10
// variable b, unique name 0:mainImage11:12:b, index 271, declared at line 151, column 10
// variable abd, unique name 0:mainImage11:12:abd, index 272, declared at line 153, column 9
// references:
// fragCoord at line 98, column 15
// iResolution at line 98, column 30
// iResolution at line 99, column 22
// texel at line 102, column 19
// texel at line 103, column 19
// vec2 at line 104, column 14
// step_y at line 104, column 24
// vec2 at line 105, column 14
// step_x at line 105, column 19
// step_y at line 105, column 27
// vec2 at line 106, column 14
// step_x at line 106, column 19
// vec2 at line 107, column 14
// step_x at line 107, column 19
// step_y at line 107, column 28
// vec2 at line 108, column 14
// step_y at line 108, column 25
// vec2 at line 109, column 14
// step_x at line 109, column 20
// step_y at line 109, column 29
// vec2 at line 110, column 14
// step_x at line 110, column 20
// vec2 at line 111, column 14
// step_x at line 111, column 20
// step_y at line 111, column 28
// texture at line 113, column 17
// iChannel0 at line 113, column 25
// fract at line 113, column 36
// vUv at line 113, column 42
// texture at line 114, column 17
// iChannel0 at line 114, column 25
// fract at line 114, column 36
// vUv at line 114, column 42
// n at line 114, column 46
// texture at line 115, column 17
// iChannel0 at line 115, column 25
// fract at line 115, column 36
// vUv at line 115, column 42
// e at line 115, column 46
// texture at line 116, column 17
// iChannel0 at line 116, column 25
// fract at line 116, column 36
// vUv at line 116, column 42
// s at line 116, column 46
// texture at line 117, column 17
// iChannel0 at line 117, column 25
// fract at line 117, column 36
// vUv at line 117, column 42
// w at line 117, column 46
// texture at line 118, column 17
// iChannel0 at line 118, column 25
// fract at line 118, column 36
// vUv at line 118, column 42
// nw at line 118, column 46
// texture at line 119, column 17
// iChannel0 at line 119, column 25
// fract at line 119, column 36
// vUv at line 119, column 42
// sw at line 119, column 46
// texture at line 120, column 17
// iChannel0 at line 120, column 25
// fract at line 120, column 36
// vUv at line 120, column 42
// ne at line 120, column 46
// texture at line 121, column 17
// iChannel0 at line 121, column 25
// fract at line 121, column 36
// vUv at line 121, column 42
// se at line 121, column 46
// _K0 at line 126, column 17
// uv at line 126, column 21
// _K1 at line 126, column 26
// uv_n at line 126, column 31
// uv_e at line 126, column 38
// uv_w at line 126, column 45
// uv_s at line 126, column 52
// _K2 at line 126, column 60
// uv_nw at line 126, column 65
// uv_sw at line 126, column 73
// uv_ne at line 126, column 81
// uv_se at line 126, column 89
// ps at line 127, column 15
// lapl at line 127, column 20
// uv_n at line 131, column 17
// uv_s at line 131, column 26
// uv_e at line 131, column 35
// uv_w at line 131, column 44
// sq2 at line 131, column 53
// uv_nw at line 131, column 60
// uv_nw at line 131, column 70
// uv_ne at line 131, column 80
// uv_ne at line 131, column 90
// uv_sw at line 131, column 100
// uv_sw at line 131, column 110
// uv_se at line 131, column 120
// uv_se at line 131, column 130
// cs at line 134, column 15
// sign at line 134, column 20
// curl at line 134, column 25
// pow at line 134, column 33
// abs at line 134, column 37
// curl at line 134, column 41
// pwr at line 134, column 48
// uv_s at line 138, column 17
// uv_n at line 138, column 26
// uv_e at line 138, column 35
// uv_w at line 138, column 44
// sq2 at line 138, column 53
// uv_nw at line 138, column 60
// uv_nw at line 138, column 70
// uv_ne at line 138, column 80
// uv_ne at line 138, column 90
// uv_sw at line 138, column 100
// uv_sw at line 138, column 110
// uv_se at line 138, column 120
// uv_se at line 138, column 130
// uv at line 139, column 15
// dp at line 139, column 22
// div at line 139, column 27
// pl at line 139, column 33
// lapl at line 139, column 38
// normz at line 141, column 16
// uv at line 141, column 22
// advect at line 143, column 14
// vec2 at line 143, column 21
// uv at line 143, column 26
// uv at line 143, column 32
// vUv at line 143, column 39
// texel at line 143, column 44
// ad at line 143, column 51
// amp at line 146, column 15
// ab at line 146, column 21
// ls at line 146, column 28
// lapl at line 146, column 33
// norm at line 146, column 42
// sp at line 146, column 51
// uv at line 146, column 56
// ds at line 146, column 63
// sd at line 146, column 68
// amp at line 147, column 15
// ab at line 147, column 21
// ls at line 147, column 28
// lapl at line 147, column 33
// norm at line 147, column 42
// sp at line 147, column 51
// uv at line 147, column 56
// ds at line 147, column 63
// sd at line 147, column 68
// ta at line 150, column 14
// cos at line 150, column 19
// sc at line 150, column 23
// tb at line 150, column 29
// sin at line 150, column 34
// sc at line 150, column 38
// ta at line 151, column 14
// sin at line 151, column 19
// sc at line 151, column 23
// tb at line 151, column 29
// cos at line 151, column 34
// sc at line 151, column 38
// upd at line 153, column 15
// uv at line 153, column 21
// upd at line 153, column 33
// vec3 at line 153, column 40
// a at line 153, column 45
// b at line 153, column 47
// sd at line 153, column 49
// iMouse at line 155, column 8
// iFrame at line 162, column 7
// reset at line 162, column 20
// popping activation record 0:mainImage11
// local variables: 
// variable fragColor, unique name 0:mainImage11:fragColor, index 223, declared at line 81, column 25
// variable fragCoord, unique name 0:mainImage11:fragCoord, index 224, declared at line 81, column 44
// references:
// pushing activation record 0:mainImage15
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage15:16
    vec2 texel = 1. / iResolution.xy;
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec3 c = texture(iChannel0, uv).xyz;
    vec3 norm = normalize(c);
    vec3 div = vec3(0.1) * norm.z;
    vec3 rbcol = 0.5 + 0.6 * cross(norm.xyz, vec3(0.5, -0.4, 0.5));
    fragColor = vec4(rbcol + div, 0.0);

}
// popping activation record 0:mainImage15:16
// local variables: 
// variable texel, unique name 0:mainImage15:16:texel, index 278, declared at line 180, column 9
// variable uv, unique name 0:mainImage15:16:uv, index 279, declared at line 181, column 9
// variable c, unique name 0:mainImage15:16:c, index 280, declared at line 182, column 9
// variable norm, unique name 0:mainImage15:16:norm, index 281, declared at line 183, column 9
// variable div, unique name 0:mainImage15:16:div, index 282, declared at line 185, column 9
// variable rbcol, unique name 0:mainImage15:16:rbcol, index 283, declared at line 186, column 9
// references:
// iResolution at line 180, column 22
// fragCoord at line 181, column 14
// iResolution at line 181, column 29
// texture at line 182, column 13
// iChannel0 at line 182, column 21
// uv at line 182, column 32
// normalize at line 183, column 16
// c at line 183, column 26
// vec3 at line 185, column 15
// norm at line 185, column 27
// cross at line 186, column 29
// norm at line 186, column 35
// vec3 at line 186, column 45
// fragColor at line 188, column 4
// vec4 at line 188, column 16
// rbcol at line 188, column 21
// div at line 188, column 29
// popping activation record 0:mainImage15
// local variables: 
// variable fragColor, unique name 0:mainImage15:fragColor, index 276, declared at line 178, column 25
// variable fragCoord, unique name 0:mainImage15:fragCoord, index 277, declared at line 178, column 44
// references:
// undefined variables 
