// pushing activation record 0
// pushing activation record 0:mhash31
vec3 mhash3(float n)
{
// pushing activation record 0:mhash31:2
    return -1.0 + 2.0 * fract(sin(n + vec3(0.0, 15.2, 27.3)) * 158.3453123);

}
// popping activation record 0:mhash31:2
// local variables: 
// references:
// fract at line 9, column 17
// sin at line 9, column 23
// n at line 9, column 27
// vec3 at line 9, column 29
// popping activation record 0:mhash31
// local variables: 
// variable n, unique name 0:mhash31:n, index 179, declared at line 7, column 19
// references:
// pushing activation record 0:mhash3
float mhash(float n)
{
// pushing activation record 0:mhash3:4
    return -1.0 + 2.0 * fract(sin(n) * 158.3453123);

}
// popping activation record 0:mhash3:4
// local variables: 
// references:
// fract at line 15, column 17
// sin at line 15, column 23
// n at line 15, column 27
// popping activation record 0:mhash3
// local variables: 
// variable n, unique name 0:mhash3:n, index 181, declared at line 13, column 19
// references:
// pushing activation record 0:getColor5
vec3 getColor(vec3 p)
{
// pushing activation record 0:getColor5:6
    float jitter = mhash(p.x + 50.0 * p.y + 2500.0 * p.z + 12121.0);
    float f = p.y + 4.0 * jitter;
    vec3 col;
    if (f > 4.0) col = vec3(0.2, 0.7, 1.0);
    return col;

}
// popping activation record 0:getColor5:6
// local variables: 
// variable jitter, unique name 0:getColor5:6:jitter, index 184, declared at line 23, column 7
// variable f, unique name 0:getColor5:6:f, index 185, declared at line 25, column 7
// variable col, unique name 0:getColor5:6:col, index 186, declared at line 27, column 6
// references:
// mhash at line 23, column 16
// p at line 23, column 22
// p at line 23, column 31
// p at line 23, column 42
// p at line 25, column 11
// jitter at line 25, column 21
// f at line 29, column 5
// col at line 29, column 14
// vec3 at line 29, column 20
// col at line 34, column 8
// popping activation record 0:getColor5
// local variables: 
// variable p, unique name 0:getColor5:p, index 183, declared at line 20, column 19
// references:
// pushing activation record 0:trace_spheres7
vec4 trace_spheres(in vec3 rayo, in vec3 rayd)
{
// pushing activation record 0:trace_spheres7:8
    vec3 p = rayo;
    const vec3 voxelSize = vec3(1.0, 1.0, 1.0);
    vec3 V = floor(p);
    vec3 V0 = V;
    vec3 step = sign(rayd);
    vec3 lp = p - V;
    vec3 tmax;
    if (step.x > 0.0) tmax.x = voxelSize.x - lp.x;
    if (step.y > 0.0) tmax.y = voxelSize.y - lp.y;
    if (step.z > 0.0) tmax.z = voxelSize.z - lp.z;
    tmax /= abs(rayd);
    vec3 tdelta = abs(voxelSize / rayd);
    // pushing activation record 0:trace_spheres7:8:for9
    for (int i = 0; i < 60; i++) {
    // pushing activation record 0:trace_spheres7:8:for9:10
        if (tmax.x < tmax.y) {
        // pushing activation record 0:trace_spheres7:8:for9:10:11
            if (tmax.x < tmax.z) {
            // pushing activation record 0:trace_spheres7:8:for9:10:11:12
                V.x += step.x;
                tmax.x += tdelta.x;

            }
            // popping activation record 0:trace_spheres7:8:for9:10:11:12
            // local variables: 
            // references:
            // V at line 66, column 4
            // step at line 66, column 11
            // tmax at line 67, column 4
            // tdelta at line 67, column 14

        }
        // popping activation record 0:trace_spheres7:8:for9:10:11
        // local variables: 
        // references:
        // tmax at line 65, column 7
        // tmax at line 65, column 16
        if (V.x > -1.0 && V.x < 1.0 && V.y > -1.0 && V.y < 1.0) continue;
        vec3 c = V + voxelSize * 0.5 + 0.4 * mhash3(V.x + 50.0 * V.y + 2500.0 * V.z);
        float r = voxelSize.x * 0.10;
        float r2 = r * r;
        vec3 p_minus_c = p - c;
        float p_minus_c2 = dot(p_minus_c, p_minus_c);
        float d = dot(rayd, p_minus_c);
        float d2 = d * d;
        float root = d2 - p_minus_c2 + r2;
        float dist;
        const float divFogRange = 1.0 / 30.0;
        const vec3 fogCol = vec3(0.3, 0.3, 0.6);
        const vec3 sunDir = vec3(-0.707106, 0.707106, 0.0);
        if (root >= 0.0) {
        // pushing activation record 0:trace_spheres7:8:for9:10:13
            dist = -d - sqrt(root);
            float z = max(0.0, 2.5 * (dist - 20.0) * divFogRange);
            float fog = clamp(exp(-z * z), 0.0, 1.0);
            vec3 col = getColor(V);
            vec3 normal = normalize(p + rayd * dist - c);
            float light = 0.7 + 1.0 * clamp(dot(normal, sunDir), 0.0, 1.0);
            col = clamp(light * col, 0.0, 1.0);
            col = mix(fogCol, col, fog);
            return vec4(col, 1.0);

        }
        // popping activation record 0:trace_spheres7:8:for9:10:13
        // local variables: 
        // variable z, unique name 0:trace_spheres7:8:for9:10:13:z, index 211, declared at line 104, column 9
        // variable fog, unique name 0:trace_spheres7:8:for9:10:13:fog, index 212, declared at line 105, column 9
        // variable col, unique name 0:trace_spheres7:8:for9:10:13:col, index 213, declared at line 108, column 8
        // variable normal, unique name 0:trace_spheres7:8:for9:10:13:normal, index 214, declared at line 112, column 8
        // variable light, unique name 0:trace_spheres7:8:for9:10:13:light, index 215, declared at line 113, column 9
        // references:
        // dist at line 103, column 3
        // d at line 103, column 11
        // sqrt at line 103, column 15
        // root at line 103, column 20
        // max at line 104, column 13
        // dist at line 104, column 27
        // divFogRange at line 104, column 38
        // clamp at line 105, column 15
        // exp at line 105, column 21
        // z at line 105, column 26
        // z at line 105, column 28
        // getColor at line 108, column 14
        // V at line 108, column 23
        // normalize at line 112, column 17
        // p at line 112, column 27
        // rayd at line 112, column 31
        // dist at line 112, column 36
        // c at line 112, column 43
        // clamp at line 113, column 29
        // dot at line 113, column 35
        // normal at line 113, column 39
        // sunDir at line 113, column 47
        // col at line 115, column 3
        // clamp at line 115, column 9
        // light at line 115, column 15
        // col at line 115, column 21
        // col at line 117, column 3
        // mix at line 117, column 9
        // fogCol at line 117, column 13
        // col at line 117, column 21
        // fog at line 117, column 26
        // vec4 at line 120, column 19
        // col at line 120, column 25
        if (dot(V - V0, V - V0) > 2500.0) break;

    }
    // popping activation record 0:trace_spheres7:8:for9:10
    // local variables: 
    // variable c, unique name 0:trace_spheres7:8:for9:10:c, index 199, declared at line 86, column 7
    // variable r, unique name 0:trace_spheres7:8:for9:10:r, index 200, declared at line 88, column 8
    // variable r2, unique name 0:trace_spheres7:8:for9:10:r2, index 201, declared at line 89, column 8
    // variable p_minus_c, unique name 0:trace_spheres7:8:for9:10:p_minus_c, index 202, declared at line 91, column 7
    // variable p_minus_c2, unique name 0:trace_spheres7:8:for9:10:p_minus_c2, index 203, declared at line 92, column 8
    // variable d, unique name 0:trace_spheres7:8:for9:10:d, index 204, declared at line 93, column 8
    // variable d2, unique name 0:trace_spheres7:8:for9:10:d2, index 205, declared at line 94, column 8
    // variable root, unique name 0:trace_spheres7:8:for9:10:root, index 206, declared at line 95, column 8
    // variable dist, unique name 0:trace_spheres7:8:for9:10:dist, index 207, declared at line 96, column 8
    // variable divFogRange, unique name 0:trace_spheres7:8:for9:10:divFogRange, index 208, declared at line 98, column 14
    // variable fogCol, unique name 0:trace_spheres7:8:for9:10:fogCol, index 209, declared at line 99, column 13
    // variable sunDir, unique name 0:trace_spheres7:8:for9:10:sunDir, index 210, declared at line 100, column 13
    // references:
    // tmax at line 64, column 6
    // tmax at line 64, column 15
    // V at line 83, column 6
    // V at line 83, column 20
    // V at line 83, column 33
    // V at line 83, column 47
    // V at line 86, column 11
    // voxelSize at line 86, column 15
    // mhash3 at line 86, column 35
    // V at line 86, column 42
    // V at line 86, column 51
    // V at line 86, column 62
    // voxelSize at line 88, column 12
    // r at line 89, column 13
    // r at line 89, column 15
    // p at line 91, column 19
    // c at line 91, column 23
    // dot at line 92, column 21
    // p_minus_c at line 92, column 25
    // p_minus_c at line 92, column 36
    // dot at line 93, column 12
    // rayd at line 93, column 16
    // p_minus_c at line 93, column 22
    // d at line 94, column 13
    // d at line 94, column 15
    // d2 at line 95, column 15
    // p_minus_c2 at line 95, column 20
    // r2 at line 95, column 33
    // vec3 at line 99, column 22
    // vec3 at line 100, column 22
    // root at line 102, column 6
    // dot at line 123, column 7
    // V at line 123, column 11
    // V0 at line 123, column 13
    // V at line 123, column 16
    // V0 at line 123, column 18
    // popping activation record 0:trace_spheres7:8:for9
    // local variables: 
    // variable i, unique name 0:trace_spheres7:8:for9:i, index 198, declared at line 63, column 9
    // references:
    // i at line 63, column 14
    // i at line 63, column 20
    return vec4(0.3, 0.3, 0.6, 1.0);

}
// popping activation record 0:trace_spheres7:8
// local variables: 
// variable p, unique name 0:trace_spheres7:8:p, index 190, declared at line 40, column 7
// variable voxelSize, unique name 0:trace_spheres7:8:voxelSize, index 191, declared at line 41, column 12
// variable V, unique name 0:trace_spheres7:8:V, index 192, declared at line 45, column 6
// variable V0, unique name 0:trace_spheres7:8:V0, index 193, declared at line 46, column 6
// variable step, unique name 0:trace_spheres7:8:step, index 194, declared at line 47, column 6
// variable lp, unique name 0:trace_spheres7:8:lp, index 195, declared at line 49, column 6
// variable tmax, unique name 0:trace_spheres7:8:tmax, index 196, declared at line 51, column 6
// variable tdelta, unique name 0:trace_spheres7:8:tdelta, index 197, declared at line 59, column 6
// references:
// rayo at line 40, column 11
// vec3 at line 41, column 24
// floor at line 45, column 10
// p at line 45, column 16
// V at line 46, column 11
// sign at line 47, column 13
// rayd at line 47, column 18
// p at line 49, column 11
// V at line 49, column 15
// step at line 53, column 5
// tmax at line 53, column 19
// voxelSize at line 53, column 28
// lp at line 53, column 42
// step at line 54, column 5
// tmax at line 54, column 19
// voxelSize at line 54, column 28
// lp at line 54, column 42
// step at line 55, column 5
// tmax at line 55, column 19
// voxelSize at line 55, column 28
// lp at line 55, column 42
// tmax at line 57, column 1
// abs at line 57, column 9
// rayd at line 57, column 13
// abs at line 59, column 15
// voxelSize at line 59, column 19
// rayd at line 59, column 31
// vec4 at line 126, column 8
// popping activation record 0:trace_spheres7
// local variables: 
// variable rayo, unique name 0:trace_spheres7:rayo, index 188, declared at line 38, column 28
// variable rayd, unique name 0:trace_spheres7:rayd, index 189, declared at line 38, column 42
// references:
// pushing activation record 0:setCamera14
mat3 setCamera(in vec3 ro, in vec3 ta, float cr)
{
// pushing activation record 0:setCamera14:15
    vec3 cw = normalize(ta - ro);
    vec3 cp = vec3(sin(cr), cos(cr), 0.0);
    vec3 cu = normalize(cross(cw, cp));
    vec3 cv = normalize(cross(cu, cw));
    return mat3(cu, cv, cw);

}
// popping activation record 0:setCamera14:15
// local variables: 
// variable cw, unique name 0:setCamera14:15:cw, index 220, declared at line 131, column 6
// variable cp, unique name 0:setCamera14:15:cp, index 221, declared at line 132, column 6
// variable cu, unique name 0:setCamera14:15:cu, index 222, declared at line 133, column 6
// variable cv, unique name 0:setCamera14:15:cv, index 223, declared at line 134, column 6
// references:
// normalize at line 131, column 11
// ta at line 131, column 21
// ro at line 131, column 24
// vec3 at line 132, column 11
// sin at line 132, column 16
// cr at line 132, column 20
// cos at line 132, column 25
// cr at line 132, column 29
// normalize at line 133, column 11
// cross at line 133, column 22
// cw at line 133, column 28
// cp at line 133, column 31
// normalize at line 134, column 11
// cross at line 134, column 22
// cu at line 134, column 28
// cw at line 134, column 31
// mat3 at line 135, column 11
// cu at line 135, column 17
// cv at line 135, column 21
// cw at line 135, column 25
// popping activation record 0:setCamera14
// local variables: 
// variable ro, unique name 0:setCamera14:ro, index 217, declared at line 129, column 24
// variable ta, unique name 0:setCamera14:ta, index 218, declared at line 129, column 36
// variable cr, unique name 0:setCamera14:cr, index 219, declared at line 129, column 46
// references:
// pushing activation record 0:mainImage16
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
// pushing activation record 0:mainImage16:17
    vec2 p = (-iResolution.xy + 2.0 * fragCoord.xy) / iResolution.y;
    vec2 m = vec2(0.0, -0.5);
    vec3 ro = 4.0 * normalize(vec3(sin(3.0 * m.x), 0.4 * m.y, cos(3.0 * m.x)));
    vec3 ta = vec3(-3.0 * cos(iGlobalTime * 0.1), -1.0, 0.0);
    mat3 ca = setCamera(ro, ta, 0.0);
    vec3 rd = ca * normalize(vec3(p.xy, 2.0));
    ro.z -= iGlobalTime;
    fragColor = trace_spheres(ro + vec3(0.5, 1.5, 0.0), rd);

}
// popping activation record 0:mainImage16:17
// local variables: 
// variable p, unique name 0:mainImage16:17:p, index 227, declared at line 141, column 9
// variable m, unique name 0:mainImage16:17:m, index 228, declared at line 143, column 9
// variable ro, unique name 0:mainImage16:17:ro, index 229, declared at line 146, column 9
// variable ta, unique name 0:mainImage16:17:ta, index 230, declared at line 147, column 6
// variable ca, unique name 0:mainImage16:17:ca, index 231, declared at line 148, column 9
// variable rd, unique name 0:mainImage16:17:rd, index 232, declared at line 150, column 9
// references:
// iResolution at line 141, column 15
// fragCoord at line 141, column 36
// iResolution at line 141, column 51
// vec2 at line 143, column 13
// normalize at line 146, column 18
// vec3 at line 146, column 28
// sin at line 146, column 33
// m at line 146, column 41
// m at line 146, column 51
// cos at line 146, column 56
// m at line 146, column 64
// vec3 at line 147, column 11
// cos at line 147, column 21
// iGlobalTime at line 147, column 25
// setCamera at line 148, column 14
// ro at line 148, column 25
// ta at line 148, column 29
// ca at line 150, column 14
// normalize at line 150, column 19
// vec3 at line 150, column 30
// p at line 150, column 35
// ro at line 152, column 4
// iGlobalTime at line 152, column 12
// fragColor at line 154, column 4
// trace_spheres at line 154, column 16
// ro at line 154, column 31
// vec3 at line 154, column 36
// rd at line 154, column 57
// popping activation record 0:mainImage16
// local variables: 
// variable fragColor, unique name 0:mainImage16:fragColor, index 225, declared at line 139, column 25
// variable fragCoord, unique name 0:mainImage16:fragCoord, index 226, declared at line 139, column 44
// references:
// pushing activation record 0:mainVR18
void mainVR(out vec4 fragColor, in vec2 fragCoord, in vec3 fragRayOri, in vec3 fragRayDir)
{
// pushing activation record 0:mainVR18:19
    fragColor = trace_spheres(fragRayOri, fragRayDir);

}
// popping activation record 0:mainVR18:19
// local variables: 
// references:
// fragColor at line 159, column 4
// trace_spheres at line 159, column 16
// fragRayOri at line 159, column 31
// fragRayDir at line 159, column 43
// popping activation record 0:mainVR18
// local variables: 
// variable fragColor, unique name 0:mainVR18:fragColor, index 234, declared at line 157, column 22
// variable fragCoord, unique name 0:mainVR18:fragCoord, index 235, declared at line 157, column 41
// variable fragRayOri, unique name 0:mainVR18:fragRayOri, index 236, declared at line 157, column 60
// variable fragRayDir, unique name 0:mainVR18:fragRayDir, index 237, declared at line 157, column 80
// references:
// undefined variables 
