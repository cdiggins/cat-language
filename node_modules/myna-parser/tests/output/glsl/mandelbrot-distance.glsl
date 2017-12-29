// pushing activation record 0
// pushing activation record 0:mainImage1
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage1:2
    vec2 p = -1.0 + 2.0 * fragCoord.xy / iResolution.xy;
    p.x *= iResolution.x / iResolution.y;
    float tz = 0.5 - 0.5 * cos(0.225 * iGlobalTime);
    float zoo = pow(0.5, 13.0 * tz);
    vec2 c = vec2(-0.05, .6805) + p * zoo;
    float di = 1.0;
    vec2 z = vec2(0.0);
    float m2 = 0.0;
    vec2 dz = vec2(0.0);
    // pushing activation record 0:mainImage1:2:for3
    for (int i = 0; i < 300; i++) {
    // pushing activation record 0:mainImage1:2:for3:4
        if (m2 > 1024.0) {
        // pushing activation record 0:mainImage1:2:for3:4:5
            di = 0.0;
            break;

        }
        // popping activation record 0:mainImage1:2:for3:4:5
        // local variables: 
        // references:
        // di at line 37, column 26
        dz = 2.0 * vec2(z.x * dz.x - z.y * dz.y, z.x * dz.y + z.y * dz.x) + vec2(1.0, 0.0);
        z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
        m2 = dot(z, z);

    }
    // popping activation record 0:mainImage1:2:for3:4
    // local variables: 
    // references:
    // m2 at line 37, column 12
    // dz at line 40, column 8
    // vec2 at line 40, column 17
    // z at line 40, column 22
    // dz at line 40, column 26
    // z at line 40, column 31
    // dz at line 40, column 35
    // z at line 40, column 41
    // dz at line 40, column 45
    // z at line 40, column 52
    // dz at line 40, column 56
    // vec2 at line 40, column 64
    // z at line 43, column 8
    // vec2 at line 43, column 12
    // z at line 43, column 18
    // z at line 43, column 22
    // z at line 43, column 28
    // z at line 43, column 32
    // z at line 43, column 41
    // z at line 43, column 45
    // c at line 43, column 53
    // m2 at line 45, column 8
    // dot at line 45, column 13
    // z at line 45, column 17
    // z at line 45, column 19
    // popping activation record 0:mainImage1:2:for3
    // local variables: 
    // variable i, unique name 0:mainImage1:2:for3:i, index 189, declared at line 35, column 13
    // references:
    // i at line 35, column 18
    // i at line 35, column 25
    float d = 0.5 * sqrt(dot(z, z) / dot(dz, dz)) * log(dot(z, z));
    if (di > 0.5) d = 0.0;
    d = clamp(pow(4.0 * d / zoo, 0.2), 0.0, 1.0);
    vec3 col = vec3(d);
    fragColor = vec4(col, 1.0);

}
// popping activation record 0:mainImage1:2
// local variables: 
// variable p, unique name 0:mainImage1:2:p, index 181, declared at line 22, column 9
// variable tz, unique name 0:mainImage1:2:tz, index 182, declared at line 26, column 7
// variable zoo, unique name 0:mainImage1:2:zoo, index 183, declared at line 27, column 10
// variable c, unique name 0:mainImage1:2:c, index 184, declared at line 28, column 6
// variable di, unique name 0:mainImage1:2:di, index 185, declared at line 31, column 10
// variable z, unique name 0:mainImage1:2:z, index 186, declared at line 32, column 9
// variable m2, unique name 0:mainImage1:2:m2, index 187, declared at line 33, column 10
// variable dz, unique name 0:mainImage1:2:dz, index 188, declared at line 34, column 9
// variable d, unique name 0:mainImage1:2:d, index 190, declared at line 50, column 7
// variable col, unique name 0:mainImage1:2:col, index 191, declared at line 56, column 9
// references:
// fragCoord at line 22, column 26
// iResolution at line 22, column 41
// p at line 23, column 4
// iResolution at line 23, column 11
// iResolution at line 23, column 25
// cos at line 26, column 22
// iGlobalTime at line 26, column 32
// pow at line 27, column 16
// tz at line 27, column 31
// vec2 at line 28, column 10
// p at line 28, column 30
// zoo at line 28, column 32
// vec2 at line 32, column 14
// vec2 at line 34, column 14
// sqrt at line 50, column 15
// dot at line 50, column 20
// z at line 50, column 24
// z at line 50, column 26
// dot at line 50, column 29
// dz at line 50, column 33
// dz at line 50, column 36
// log at line 50, column 41
// dot at line 50, column 45
// z at line 50, column 49
// z at line 50, column 51
// di at line 51, column 8
// d at line 51, column 17
// d at line 54, column 1
// clamp at line 54, column 5
// pow at line 54, column 12
// d at line 54, column 20
// zoo at line 54, column 22
// vec3 at line 56, column 15
// d at line 56, column 21
// fragColor at line 58, column 4
// vec4 at line 58, column 16
// col at line 58, column 22
// popping activation record 0:mainImage1
// local variables: 
// variable fragColor, unique name 0:mainImage1:fragColor, index 179, declared at line 20, column 25
// variable fragCoord, unique name 0:mainImage1:fragCoord, index 180, declared at line 20, column 44
// references:
// undefined variables 
