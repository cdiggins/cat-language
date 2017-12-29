// pushing activation record 0
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
// pushing activation record 0:snow1
float snow(vec2 uv, float scale)
{
// pushing activation record 0:snow1:2
    float w = smoothstep(1., 0., -uv.y * (scale / 10.));
    if (w < .1) return 0.;
    uv += time / scale;
    uv.y += time * 2. / scale;
    uv.x += sin(uv.y + time * .5) / scale;
    uv *= scale;
    vec2 s = floor(uv), f = fract(uv), p;
    float k = 3., d;
    p = .5 + .35 * sin(11. * fract(sin((s + p + scale) * mat2(7, 3, 6, 5)) * 2.)) - f;
    d = length(p);
    k = min(d, k);
    k = smoothstep(0., k, sin(f.x + f.y) * 0.02);
    return k * w;

}
// popping activation record 0:snow1:2
// local variables: 
// variable w, unique name 0:snow1:2:w, index 184, declared at line 11, column 7
// variable s, unique name 0:snow1:2:s, index 185, declared at line 14, column 16
// variable f, unique name 0:snow1:2:f, index 186, declared at line 14, column 28
// variable p, unique name 0:snow1:2:p, index 187, declared at line 14, column 40
// variable k, unique name 0:snow1:2:k, index 188, declared at line 14, column 48
// variable d, unique name 0:snow1:2:d, index 189, declared at line 14, column 53
// references:
// smoothstep at line 11, column 9
// uv at line 11, column 27
// scale at line 11, column 33
// w at line 12, column 7
// uv at line 13, column 1
// time at line 13, column 5
// scale at line 13, column 10
// uv at line 13, column 16
// time at line 13, column 22
// scale at line 13, column 30
// uv at line 13, column 36
// sin at line 13, column 42
// uv at line 13, column 46
// time at line 13, column 51
// scale at line 13, column 60
// uv at line 14, column 1
// scale at line 14, column 5
// floor at line 14, column 18
// uv at line 14, column 24
// fract at line 14, column 30
// uv at line 14, column 36
// p at line 15, column 1
// sin at line 15, column 10
// fract at line 15, column 18
// sin at line 15, column 24
// s at line 15, column 29
// p at line 15, column 31
// scale at line 15, column 33
// mat2 at line 15, column 40
// f at line 15, column 60
// d at line 15, column 62
// length at line 15, column 64
// p at line 15, column 71
// k at line 15, column 74
// min at line 15, column 76
// d at line 15, column 80
// k at line 15, column 82
// k at line 16, column 1
// smoothstep at line 16, column 3
// k at line 16, column 17
// sin at line 16, column 19
// f at line 16, column 23
// f at line 16, column 27
// k at line 17, column 12
// w at line 17, column 14
// popping activation record 0:snow1
// local variables: 
// variable uv, unique name 0:snow1:uv, index 182, declared at line 9, column 16
// variable scale, unique name 0:snow1:scale, index 183, declared at line 9, column 25
// references:
// pushing activation record 0:main3
void main()
{
// pushing activation record 0:main3:4
    vec2 uv = (gl_FragCoord.xy * 1. - resolution.xy) / min(resolution.x, -resolution.y);
    vec3 finalColor = vec3(0);
    float c = smoothstep(1., 0.3, clamp(uv.y * .3 + 0.7, 0., 2.75));
    c += snow(uv, 30.) * .0;
    c += snow(uv, 20.) * .0;
    c += snow(uv, 15.) * .0;
    c += snow(uv, 10.);
    c += snow(uv, 8.);
    c += snow(uv, 6.);
    c += snow(uv, 5.);
    finalColor = (vec3(c));
    finalColor *= vec3(.7, 0.1, 0.);
    gl_FragColor = vec4(finalColor, 1);

}
// popping activation record 0:main3:4
// local variables: 
// variable uv, unique name 0:main3:4:uv, index 191, declared at line 22, column 6
// variable finalColor, unique name 0:main3:4:finalColor, index 192, declared at line 23, column 6
// variable c, unique name 0:main3:4:c, index 193, declared at line 24, column 7
// references:
// gl_FragCoord at line 22, column 10
// resolution at line 22, column 29
// min at line 22, column 44
// resolution at line 22, column 48
// resolution at line 22, column 62
// vec3 at line 23, column 17
// smoothstep at line 24, column 9
// clamp at line 24, column 27
// uv at line 24, column 33
// c at line 25, column 1
// snow at line 25, column 4
// uv at line 25, column 9
// c at line 26, column 1
// snow at line 26, column 4
// uv at line 26, column 9
// c at line 27, column 1
// snow at line 27, column 4
// uv at line 27, column 9
// c at line 28, column 1
// snow at line 28, column 4
// uv at line 28, column 9
// c at line 29, column 1
// snow at line 29, column 4
// uv at line 29, column 9
// c at line 30, column 1
// snow at line 30, column 4
// uv at line 30, column 9
// c at line 31, column 1
// snow at line 31, column 4
// uv at line 31, column 9
// finalColor at line 32, column 1
// vec3 at line 32, column 13
// c at line 32, column 18
// finalColor at line 33, column 1
// vec3 at line 33, column 15
// gl_FragColor at line 34, column 1
// vec4 at line 34, column 16
// finalColor at line 34, column 21
// popping activation record 0:main3
// local variables: 
// references:
// undefined variables 
