// pushing activation record 0
const float uvScale = 1.0;
const float colorUvScale = 0.1;
const float furDepth = 0.2;
const int furLayers = 64;
const float rayStep = furDepth * 2.0 / float(furLayers);
const float furThreshold = 0.4;
const float shininess = 50.0;
// pushing activation record 0:intersectSphere1
bool intersectSphere(vec3 ro, vec3 rd, float r, out float t)
{
// pushing activation record 0:intersectSphere1:2
    float b = dot(-ro, rd);
    float det = b * b - dot(ro, ro) + r * r;
    if (det < 0.0) return false;
    det = sqrt(det);
    t = b - det;
    return t > 0.0;

}
// popping activation record 0:intersectSphere1:2
// local variables: 
// variable b, unique name 0:intersectSphere1:2:b, index 190, declared at line 17, column 7
// variable det, unique name 0:intersectSphere1:2:det, index 191, declared at line 18, column 7
// references:
// dot at line 17, column 11
// ro at line 17, column 16
// rd at line 17, column 20
// b at line 18, column 13
// b at line 18, column 15
// dot at line 18, column 19
// ro at line 18, column 23
// ro at line 18, column 27
// r at line 18, column 33
// r at line 18, column 35
// det at line 19, column 5
// det at line 20, column 1
// sqrt at line 20, column 7
// det at line 20, column 12
// t at line 21, column 1
// b at line 21, column 5
// det at line 21, column 9
// t at line 22, column 8
// popping activation record 0:intersectSphere1
// local variables: 
// variable ro, unique name 0:intersectSphere1:ro, index 186, declared at line 15, column 26
// variable rd, unique name 0:intersectSphere1:rd, index 187, declared at line 15, column 35
// variable r, unique name 0:intersectSphere1:r, index 188, declared at line 15, column 45
// variable t, unique name 0:intersectSphere1:t, index 189, declared at line 15, column 58
// references:
// pushing activation record 0:rotateX3
vec3 rotateX(vec3 p, float a)
{
// pushing activation record 0:rotateX3:4
    float sa = sin(a);
    float ca = cos(a);
    return vec3(p.x, ca * p.y - sa * p.z, sa * p.y + ca * p.z);

}
// popping activation record 0:rotateX3:4
// local variables: 
// variable sa, unique name 0:rotateX3:4:sa, index 195, declared at line 27, column 10
// variable ca, unique name 0:rotateX3:4:ca, index 196, declared at line 28, column 10
// references:
// sin at line 27, column 15
// a at line 27, column 19
// cos at line 28, column 15
// a at line 28, column 19
// vec3 at line 29, column 11
// p at line 29, column 16
// ca at line 29, column 21
// p at line 29, column 24
// sa at line 29, column 30
// p at line 29, column 33
// sa at line 29, column 38
// p at line 29, column 41
// ca at line 29, column 47
// p at line 29, column 50
// popping activation record 0:rotateX3
// local variables: 
// variable p, unique name 0:rotateX3:p, index 193, declared at line 25, column 18
// variable a, unique name 0:rotateX3:a, index 194, declared at line 25, column 27
// references:
// pushing activation record 0:rotateY5
vec3 rotateY(vec3 p, float a)
{
// pushing activation record 0:rotateY5:6
    float sa = sin(a);
    float ca = cos(a);
    return vec3(ca * p.x + sa * p.z, p.y, -sa * p.x + ca * p.z);

}
// popping activation record 0:rotateY5:6
// local variables: 
// variable sa, unique name 0:rotateY5:6:sa, index 200, declared at line 34, column 10
// variable ca, unique name 0:rotateY5:6:ca, index 201, declared at line 35, column 10
// references:
// sin at line 34, column 15
// a at line 34, column 19
// cos at line 35, column 15
// a at line 35, column 19
// vec3 at line 36, column 11
// ca at line 36, column 16
// p at line 36, column 19
// sa at line 36, column 25
// p at line 36, column 28
// p at line 36, column 33
// sa at line 36, column 39
// p at line 36, column 42
// ca at line 36, column 48
// p at line 36, column 51
// popping activation record 0:rotateY5
// local variables: 
// variable p, unique name 0:rotateY5:p, index 198, declared at line 32, column 18
// variable a, unique name 0:rotateY5:a, index 199, declared at line 32, column 27
// references:
// pushing activation record 0:cartesianToSpherical7
vec2 cartesianToSpherical(vec3 p)
{
// pushing activation record 0:cartesianToSpherical7:8
    float r = length(p);
    float t = (r - (1.0 - furDepth)) / furDepth;
    p = rotateX(p.zyx, -cos(iGlobalTime * 1.5) * t * t * 0.4).zyx;
    p /= r;
    vec2 uv = vec2(atan(p.y, p.x), acos(p.z));
    uv.y -= t * t * 0.1;
    return uv;

}
// popping activation record 0:cartesianToSpherical7:8
// local variables: 
// variable r, unique name 0:cartesianToSpherical7:8:r, index 204, declared at line 41, column 7
// variable t, unique name 0:cartesianToSpherical7:8:t, index 205, declared at line 43, column 7
// variable uv, unique name 0:cartesianToSpherical7:8:uv, index 206, declared at line 47, column 6
// references:
// length at line 41, column 11
// p at line 41, column 18
// r at line 43, column 12
// furDepth at line 43, column 23
// furDepth at line 43, column 36
// p at line 44, column 1
// rotateX at line 44, column 5
// p at line 44, column 13
// cos at line 44, column 21
// iGlobalTime at line 44, column 25
// t at line 44, column 42
// t at line 44, column 44
// p at line 46, column 1
// r at line 46, column 6
// vec2 at line 47, column 11
// atan at line 47, column 16
// p at line 47, column 21
// p at line 47, column 26
// acos at line 47, column 32
// p at line 47, column 37
// uv at line 51, column 1
// t at line 51, column 9
// t at line 51, column 11
// uv at line 52, column 8
// popping activation record 0:cartesianToSpherical7
// local variables: 
// variable p, unique name 0:cartesianToSpherical7:p, index 203, declared at line 39, column 31
// references:
// pushing activation record 0:furDensity9
float furDensity(vec3 pos, out vec2 uv)
{
// pushing activation record 0:furDensity9:10
    uv = cartesianToSpherical(pos.xzy);
    vec4 tex = textureLod(iChannel0, uv * uvScale, 0.0);
    float density = smoothstep(furThreshold, 1.0, tex.x);
    float r = length(pos);
    float t = (r - (1.0 - furDepth)) / furDepth;
    float len = tex.y;
    density *= smoothstep(len, len - 0.2, t);
    return density;

}
// popping activation record 0:furDensity9:10
// local variables: 
// variable tex, unique name 0:furDensity9:10:tex, index 210, declared at line 59, column 6
// variable density, unique name 0:furDensity9:10:density, index 211, declared at line 62, column 7
// variable r, unique name 0:furDensity9:10:r, index 212, declared at line 64, column 7
// variable t, unique name 0:furDensity9:10:t, index 213, declared at line 65, column 7
// variable len, unique name 0:furDensity9:10:len, index 214, declared at line 68, column 7
// references:
// uv at line 58, column 1
// cartesianToSpherical at line 58, column 6
// pos at line 58, column 27
// textureLod at line 59, column 12
// iChannel0 at line 59, column 23
// uv at line 59, column 34
// uvScale at line 59, column 37
// smoothstep at line 62, column 17
// furThreshold at line 62, column 28
// tex at line 62, column 47
// length at line 64, column 11
// pos at line 64, column 18
// r at line 65, column 12
// furDepth at line 65, column 23
// furDepth at line 65, column 36
// tex at line 68, column 13
// density at line 69, column 1
// smoothstep at line 69, column 12
// len at line 69, column 23
// len at line 69, column 28
// t at line 69, column 37
// density at line 71, column 8
// popping activation record 0:furDensity9
// local variables: 
// variable pos, unique name 0:furDensity9:pos, index 208, declared at line 56, column 22
// variable uv, unique name 0:furDensity9:uv, index 209, declared at line 56, column 36
// references:
// pushing activation record 0:furNormal11
vec3 furNormal(vec3 pos, float density)
{
// pushing activation record 0:furNormal11:12
    float eps = 0.01;
    vec3 n;
    vec2 uv;
    n.x = furDensity(vec3(pos.x + eps, pos.y, pos.z), uv) - density;
    n.y = furDensity(vec3(pos.x, pos.y + eps, pos.z), uv) - density;
    n.z = furDensity(vec3(pos.x, pos.y, pos.z + eps), uv) - density;
    return normalize(n);

}
// popping activation record 0:furNormal11:12
// local variables: 
// variable eps, unique name 0:furNormal11:12:eps, index 218, declared at line 77, column 10
// variable n, unique name 0:furNormal11:12:n, index 219, declared at line 78, column 9
// variable uv, unique name 0:furNormal11:12:uv, index 220, declared at line 79, column 6
// references:
// n at line 80, column 4
// furDensity at line 80, column 10
// vec3 at line 80, column 22
// pos at line 80, column 27
// eps at line 80, column 33
// pos at line 80, column 38
// pos at line 80, column 45
// uv at line 80, column 53
// density at line 80, column 60
// n at line 81, column 4
// furDensity at line 81, column 10
// vec3 at line 81, column 22
// pos at line 81, column 27
// pos at line 81, column 34
// eps at line 81, column 40
// pos at line 81, column 45
// uv at line 81, column 53
// density at line 81, column 60
// n at line 82, column 4
// furDensity at line 82, column 10
// vec3 at line 82, column 22
// pos at line 82, column 27
// pos at line 82, column 34
// pos at line 82, column 41
// eps at line 82, column 47
// uv at line 82, column 53
// density at line 82, column 60
// normalize at line 83, column 11
// n at line 83, column 21
// popping activation record 0:furNormal11
// local variables: 
// variable pos, unique name 0:furNormal11:pos, index 216, declared at line 75, column 20
// variable density, unique name 0:furNormal11:density, index 217, declared at line 75, column 31
// references:
// pushing activation record 0:furShade13
vec3 furShade(vec3 pos, vec2 uv, vec3 ro, float density)
{
// pushing activation record 0:furShade13:14
    const vec3 L = vec3(0, 1, 0);
    vec3 V = normalize(ro - pos);
    vec3 H = normalize(V + L);
    vec3 N = -furNormal(pos, density);
    float diff = max(0.0, dot(N, L) * 0.5 + 0.5);
    float spec = pow(max(0.0, dot(N, H)), shininess);
    vec3 color = textureLod(iChannel1, uv * colorUvScale, 0.0).xyz;
    float r = length(pos);
    float t = (r - (1.0 - furDepth)) / furDepth;
    t = clamp(t, 0.0, 1.0);
    float i = t * 0.5 + 0.5;
    return color * diff * i + vec3(spec * i);

}
// popping activation record 0:furShade13:14
// local variables: 
// variable L, unique name 0:furShade13:14:L, index 226, declared at line 89, column 12
// variable V, unique name 0:furShade13:14:V, index 227, declared at line 90, column 6
// variable H, unique name 0:furShade13:14:H, index 228, declared at line 91, column 6
// variable N, unique name 0:furShade13:14:N, index 229, declared at line 93, column 6
// variable diff, unique name 0:furShade13:14:diff, index 230, declared at line 95, column 7
// variable spec, unique name 0:furShade13:14:spec, index 231, declared at line 96, column 7
// variable color, unique name 0:furShade13:14:color, index 232, declared at line 99, column 6
// variable r, unique name 0:furShade13:14:r, index 233, declared at line 102, column 7
// variable t, unique name 0:furShade13:14:t, index 234, declared at line 103, column 7
// variable i, unique name 0:furShade13:14:i, index 235, declared at line 105, column 7
// references:
// vec3 at line 89, column 16
// normalize at line 90, column 10
// ro at line 90, column 20
// pos at line 90, column 25
// normalize at line 91, column 10
// V at line 91, column 20
// L at line 91, column 24
// furNormal at line 93, column 11
// pos at line 93, column 21
// density at line 93, column 26
// max at line 95, column 14
// dot at line 95, column 23
// N at line 95, column 27
// L at line 95, column 30
// pow at line 96, column 14
// max at line 96, column 18
// dot at line 96, column 27
// N at line 96, column 31
// H at line 96, column 34
// shininess at line 96, column 39
// textureLod at line 99, column 14
// iChannel1 at line 99, column 25
// uv at line 99, column 36
// colorUvScale at line 99, column 39
// length at line 102, column 11
// pos at line 102, column 18
// r at line 103, column 12
// furDepth at line 103, column 23
// furDepth at line 103, column 36
// t at line 104, column 1
// clamp at line 104, column 5
// t at line 104, column 11
// t at line 105, column 11
// color at line 107, column 8
// diff at line 107, column 14
// i at line 107, column 19
// vec3 at line 107, column 23
// spec at line 107, column 28
// i at line 107, column 33
// popping activation record 0:furShade13
// local variables: 
// variable pos, unique name 0:furShade13:pos, index 222, declared at line 86, column 19
// variable uv, unique name 0:furShade13:uv, index 223, declared at line 86, column 29
// variable ro, unique name 0:furShade13:ro, index 224, declared at line 86, column 38
// variable density, unique name 0:furShade13:density, index 225, declared at line 86, column 48
// references:
// pushing activation record 0:scene15
vec4 scene(vec3 ro, vec3 rd)
{
// pushing activation record 0:scene15:16
    vec3 p = vec3(0.0);
    const float r = 1.0;
    float t;
    bool hit = intersectSphere(ro - p, rd, r, t);
    vec4 c = vec4(0.0);
    if (hit) {
    // pushing activation record 0:scene15:16:17
        vec3 pos = ro + rd * t;
        // pushing activation record 0:scene15:16:17:for18
        for (int i = 0; i < furLayers; i++) {
        // pushing activation record 0:scene15:16:17:for18:19
            vec4 sampleCol;
            vec2 uv;
            sampleCol.a = furDensity(pos, uv);
            if (sampleCol.a > 0.0) {
            // pushing activation record 0:scene15:16:17:for18:19:20
                sampleCol.rgb = furShade(pos, uv, ro, sampleCol.a);
                sampleCol.rgb *= sampleCol.a;
                c = c + sampleCol * (1.0 - c.a);
                if (c.a > 0.95) break;

            }
            // popping activation record 0:scene15:16:17:for18:19:20
            // local variables: 
            // references:
            // sampleCol at line 127, column 4
            // furShade at line 127, column 20
            // pos at line 127, column 29
            // uv at line 127, column 34
            // ro at line 127, column 38
            // sampleCol at line 127, column 42
            // sampleCol at line 130, column 4
            // sampleCol at line 130, column 21
            // c at line 131, column 4
            // c at line 131, column 8
            // sampleCol at line 131, column 12
            // c at line 131, column 29
            // c at line 132, column 8
            pos += rd * rayStep;

        }
        // popping activation record 0:scene15:16:17:for18:19
        // local variables: 
        // variable sampleCol, unique name 0:scene15:16:17:for18:19:sampleCol, index 246, declared at line 123, column 8
        // variable uv, unique name 0:scene15:16:17:for18:19:uv, index 247, declared at line 124, column 8
        // references:
        // sampleCol at line 125, column 3
        // furDensity at line 125, column 17
        // pos at line 125, column 28
        // uv at line 125, column 33
        // sampleCol at line 126, column 7
        // pos at line 135, column 3
        // rd at line 135, column 10
        // rayStep at line 135, column 13
        // popping activation record 0:scene15:16:17:for18
        // local variables: 
        // variable i, unique name 0:scene15:16:17:for18:i, index 245, declared at line 122, column 10
        // references:
        // i at line 122, column 15
        // furLayers at line 122, column 17
        // i at line 122, column 28

    }
    // popping activation record 0:scene15:16:17
    // local variables: 
    // variable pos, unique name 0:scene15:16:17:pos, index 244, declared at line 119, column 7
    // references:
    // ro at line 119, column 13
    // rd at line 119, column 18
    // t at line 119, column 21
    return c;

}
// popping activation record 0:scene15:16
// local variables: 
// variable p, unique name 0:scene15:16:p, index 239, declared at line 112, column 6
// variable r, unique name 0:scene15:16:r, index 240, declared at line 113, column 13
// variable t, unique name 0:scene15:16:t, index 241, declared at line 114, column 7
// variable hit, unique name 0:scene15:16:hit, index 242, declared at line 115, column 6
// variable c, unique name 0:scene15:16:c, index 243, declared at line 117, column 6
// references:
// vec3 at line 112, column 10
// intersectSphere at line 115, column 12
// ro at line 115, column 28
// p at line 115, column 33
// rd at line 115, column 36
// r at line 115, column 40
// t at line 115, column 43
// vec4 at line 117, column 10
// hit at line 118, column 5
// c at line 139, column 8
// popping activation record 0:scene15
// local variables: 
// variable ro, unique name 0:scene15:ro, index 237, declared at line 110, column 16
// variable rd, unique name 0:scene15:rd, index 238, declared at line 110, column 24
// references:
// pushing activation record 0:mainImage21
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage21:22
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv = uv * 2.0 - 1.0;
    uv.x *= iResolution.x / iResolution.y;
    vec3 ro = vec3(0.0, 0.0, 2.5);
    vec3 rd = normalize(vec3(uv, -2.0));
    vec2 mouse = iMouse.xy / iResolution.xy;
    float roty = 0.0;
    float rotx = 0.0;
    if (iMouse.z > 0.0) {
    // pushing activation record 0:mainImage21:22:23
        rotx = (mouse.y - 0.5) * 3.0;
        roty = -(mouse.x - 0.5) * 6.0;

    }
    // popping activation record 0:mainImage21:22:23
    // local variables: 
    // references:
    // rotx at line 155, column 2
    // mouse at line 155, column 10
    // roty at line 156, column 2
    // mouse at line 156, column 11
    ro = rotateX(ro, rotx);
    ro = rotateY(ro, roty);
    rd = rotateX(rd, rotx);
    rd = rotateY(rd, roty);
    fragColor = scene(ro, rd);

}
// popping activation record 0:mainImage21:22
// local variables: 
// variable uv, unique name 0:mainImage21:22:uv, index 251, declared at line 144, column 6
// variable ro, unique name 0:mainImage21:22:ro, index 252, declared at line 148, column 6
// variable rd, unique name 0:mainImage21:22:rd, index 253, declared at line 149, column 6
// variable mouse, unique name 0:mainImage21:22:mouse, index 254, declared at line 151, column 6
// variable roty, unique name 0:mainImage21:22:roty, index 255, declared at line 152, column 7
// variable rotx, unique name 0:mainImage21:22:rotx, index 256, declared at line 153, column 7
// references:
// fragCoord at line 144, column 11
// iResolution at line 144, column 26
// uv at line 145, column 1
// uv at line 145, column 6
// uv at line 146, column 1
// iResolution at line 146, column 9
// iResolution at line 146, column 25
// vec3 at line 148, column 11
// normalize at line 149, column 11
// vec3 at line 149, column 21
// uv at line 149, column 26
// iMouse at line 151, column 14
// iResolution at line 151, column 26
// iMouse at line 154, column 5
// ro at line 161, column 4
// rotateX at line 161, column 9
// ro at line 161, column 17
// rotx at line 161, column 21
// ro at line 162, column 4
// rotateY at line 162, column 9
// ro at line 162, column 17
// roty at line 162, column 21
// rd at line 163, column 4
// rotateX at line 163, column 9
// rd at line 163, column 17
// rotx at line 163, column 21
// rd at line 164, column 4
// rotateY at line 164, column 9
// rd at line 164, column 17
// roty at line 164, column 21
// fragColor at line 166, column 1
// scene at line 166, column 13
// ro at line 166, column 19
// rd at line 166, column 23
// popping activation record 0:mainImage21
// local variables: 
// variable fragColor, unique name 0:mainImage21:fragColor, index 249, declared at line 142, column 25
// variable fragCoord, unique name 0:mainImage21:fragCoord, index 250, declared at line 142, column 44
// references:
// undefined variables 
