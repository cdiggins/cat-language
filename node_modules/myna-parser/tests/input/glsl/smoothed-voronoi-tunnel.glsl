// https://www.shadertoy.com/view/4slfWl

// "Smoothed Voronoi Tunnel" by dr2 - 2017
// License: Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License

// Smoothed hexagonal-lattice-based Voronoi partitioning.

float PrCylDf (vec3 p, float r, float h);
float Hashfv2 (vec2 p);
vec2 Hashv2v2 (vec2 p);
float Noisefv2 (vec2 p);
vec3 VaryNf (vec3 p, vec3 n, float f);
float SmoothMin (float a, float b, float r);
vec2 Rot2D (vec2 q, float a);
vec3 HsvToRgb (vec3 c);

vec3 ltDir;
vec2 gVec[7], hVec[7];
float dstFar, tCur, wdTun, htTun, lmpSep;
int idObj;
const int idWal = 1, idCeil = 2, idFlr = 3, idLmp = 4;
const float pi = 3.14159;

float TrackPath (float t)
{
  return wdTun * (0.7 * sin (0.005 * 2. * pi * t) + 0.4 * cos (0.009 * 2. * pi * t));
}

#define SQRT3 1.73205

vec2 PixToHex (vec2 p)
{
  vec3 c, r, dr;
  c.xz = vec2 ((1./SQRT3) * p.x - (1./3.) * p.y, (2./3.) * p.y);
  c.y = - c.x - c.z;
  r = floor (c + 0.5);
  dr = abs (r - c);
  r -= step (dr.yzx, dr) * step (dr.zxy, dr) * dot (r, vec3 (1.));
  return r.xz;
}

vec2 HexToPix (vec2 h)
{
  return vec2 (SQRT3 * (h.x + 0.5 * h.y), (3./2.) * h.y);
}

void HexVorInit ()
{
  vec3 e = vec3 (1., 0., -1.);
  gVec[0] = e.yy;
  gVec[1] = e.xy;
  gVec[2] = e.yx;
  gVec[3] = e.xz;
  gVec[4] = e.zy;
  gVec[5] = e.yz;
  gVec[6] = e.zx;
  for (int k = 0; k < 7; k ++) hVec[k] = HexToPix (gVec[k]);
}

vec4 HexVor (vec2 p)
{
  vec4 sd, udm;
  vec2 ip, fp, d, u;
  float amp, a;
  amp = 0.7;
  ip = PixToHex (p);
  fp = p - HexToPix (ip);
  sd = vec4 (4.);
  udm = vec4 (4.);
  for (int k = 0; k < 7; k ++) {
    u = Hashv2v2 (ip + gVec[k]);
    a = 2. * pi * (u.y - 0.5);
    d = hVec[k] + amp * (0.4 + 0.6 * u.x) * vec2 (cos (a), sin (a)) - fp;
    sd.w = dot (d, d);
    if (sd.w < sd.x) {
      sd = sd.wxyw;
      udm = vec4 (d, u);
    } else sd = (sd.w < sd.y) ? sd.xwyw : ((sd.w < sd.z) ? sd.xyww : sd);
  }
  sd.xyz = sqrt (sd.xyz);
  return vec4 (SmoothMin (sd.y, sd.z, 0.3) - sd.x, udm.xy, Hashfv2 (udm.zw));
}

float ObjDf (vec3 p)
{
  vec4 vc;
  vec3 q;
  float dMin, d, db;
  dMin = dstFar;
  p.x -= TrackPath (p.z);
  q = p;
  q.y -= htTun;
  d = wdTun - abs (q.x);
  if (d < dMin) { dMin = d;  idObj = idWal; }
  vc = HexVor (q.zx);
  d = q.y + htTun - 0.05 * smoothstep (0.05 + 0.03 * vc.w, 0.14 + 0.03 * vc.w, vc.x);
  if (d < dMin) { dMin = d;  idObj = idFlr; }
  q.y -= htTun;
  d = max (wdTun - length (q.xy), - q.y);
  if (d < dMin) { dMin = d;  idObj = idCeil; }
  q.z = mod (q.z + lmpSep, 2. * lmpSep) - lmpSep;
  q.y -= 0.5 * wdTun;
  d = PrCylDf (q.xzy, 0.1 * wdTun, 0.01 * wdTun);
  q.y -= 0.25 * wdTun;
  d = min (d, PrCylDf (q.xzy, 0.005 * wdTun, 0.25 * wdTun));
  q.y -= 0.25 * wdTun;
  d = min (d, PrCylDf (q.xzy, 0.05 * wdTun, 0.02 * wdTun));
  q.y -= - wdTun - htTun;
  if (d < dMin) { dMin = d;  idObj = idLmp; }
  return 0.8 * dMin;
}

float ObjRay (vec3 ro, vec3 rd)
{
  float dHit, d;
  dHit = 0.;
  for (int j = 0; j < 250; j ++) {
    d = ObjDf (ro + dHit * rd);
    dHit += d;
    if (d < 0.0005 || dHit > dstFar) break;
  }
  return dHit;
}

vec3 ObjNf (vec3 p)
{
  vec4 v;
  const vec3 e = vec3 (0.001, -0.001, 0.);
  v = vec4 (ObjDf (p + e.xxx), ObjDf (p + e.xyy),
     ObjDf (p + e.yxy), ObjDf (p + e.yyx));
  return normalize (vec3 (v.x - v.y - v.z - v.w) + 2. * v.yzw);
}

vec3 ShowScene (vec3 ro, vec3 rd)
{
  vec4 vc;
  vec3 vn, col, q;
  float dstObj, bh, s, spec, att;
  HexVorInit ();
  dstObj = ObjRay (ro, rd);
  if (dstObj < dstFar) {
    ro += rd * dstObj;
    q = ro;
    q.x -= TrackPath (q.z);
    vn = ObjNf (ro);
    spec = 0.1;
    if (idObj == idWal) {
      vc = HexVor (5. * q.zy);
      col = HsvToRgb (vec3 (0.6 + 0.1 * vc.w, 1., 1.)) * (0.3 + 0.7 *
         smoothstep (0.05, 0.06 + 0.03 * vc.w, vc.x));
    } else if (idObj == idCeil) {
      q.x = wdTun * atan (q.x, q.y - 2. * htTun);
      vc = HexVor (2. * q.zx);
      col = HsvToRgb (vec3 (0.4 + 0.1 * vc.w, 1., 1.)) * (0.3 + 0.7 *
         smoothstep (0.05, 0.06 + 0.03 * vc.w, vc.x));
      spec = 0.05;
    } else if (idObj == idFlr) {
      vc = HexVor (q.zx);
      col = mix (vec3 (0.2), HsvToRgb (vec3 (vc.w, 1., 1.)),
         step (0.06 + 0.03 * vc.w, vc.x)) * (1. - 0.1 * Noisefv2 (150. * q.xz));
      q.z = mod (q.z + lmpSep, 2. * lmpSep) - lmpSep;
      col *= 1. - 0.3 * smoothstep (0.4, 0.85, length (q.xz) / wdTun);
      spec = 0.3;
      vn = VaryNf (100. * q, vn, 1.);
    } else if (idObj == idLmp) {
      if (q.y < htTun + wdTun) {
        col = vec3 (1., 1., 0.7) * 0.5 * (1. - vn.y);
        spec = -1.;
      } else col = vec3 (0.6, 0.4, 0.1);
    }
    if (spec >= 0.) col = col * (0.2 + 0.8 * max (dot (vn, ltDir), 0.) +
       spec * pow (max (dot (normalize (ltDir - rd), vn), 0.), 64.));
    att = min (600. / pow (dstObj, 1.5), 1.);
    col *= att;
  } else col = vec3 (0.01, 0.01, 0.05);
  return pow (clamp (col, 0., 1.), vec3 (0.7));
}

void mainImage (out vec4 fragColor, in vec2 fragCoord)
{
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
    el = clamp (el + pi * mPtr.y, -0.4 * pi, 0.4 * pi);
    az = az + 2.5 * pi * mPtr.x;
  }
  dstFar = 300.;
  ori = vec2 (el, az);
  ca = cos (ori);
  sa = sin (ori);
  vuMat = mat3 (ca.y, 0., - sa.y, 0., 1., 0., sa.y, 0., ca.y) *
          mat3 (1., 0., 0., 0., ca.x, - sa.x, 0., sa.x, ca.x);
  rd = vuMat * normalize (vec3 (uv, 3.));
  ro.z = 10. * tCur;
  ro.x = TrackPath (ro.z);
  rd.zx = Rot2D (rd.zx, 0.1 * atan (ro.x));
  ro.y = 1.5 * htTun;
  ltDir = vuMat * normalize (vec3 (0., 0.2, -1.));
  fragColor = vec4 (ShowScene (ro, rd), 1.);
}

float PrCylDf (vec3 p, float r, float h)
{
  return max (length (p.xy) - r, abs (p.z) - h);
}

float SmoothMin (float a, float b, float r)
{
  float h;
  h = clamp (0.5 + 0.5 * (b - a) / r, 0., 1.);
  return mix (b, a, h) - r * h * (1. - h);
}

vec2 Rot2D (vec2 q, float a)
{
  return q * cos (a) + q.yx * sin (a) * vec2 (-1., 1.);
}

const vec4 cHashA4 = vec4 (0., 1., 57., 58.);
const vec3 cHashA3 = vec3 (1., 57., 113.);
const float cHashM = 43758.54;

float Hashfv2 (vec2 p)
{
  return fract (sin (dot (p, cHashA3.xy)) * cHashM);
}

vec2 Hashv2v2 (vec2 p)
{
  const vec2 cHashVA2 = vec2 (37.1, 61.7);
  const vec2 e = vec2 (1., 0.);
  return fract (sin (vec2 (dot (p + e.yy, cHashVA2),
     dot (p + e.xy, cHashVA2))) * cHashM);
}

vec4 Hashv4f (float p)
{
  return fract (sin (p + cHashA4) * cHashM);
}

float Noisefv2 (vec2 p)
{
  vec2 i = floor (p);
  vec2 f = fract (p);
  f = f * f * (3. - 2. * f);
  vec4 t = Hashv4f (dot (i, cHashA3.xy));
  return mix (mix (t.x, t.y, f.x), mix (t.z, t.w, f.x), f.y);
}

float Fbmn (vec3 p, vec3 n)
{
  vec3 s;
  float a;
  s = vec3 (0.);
  a = 1.;
  for (int i = 0; i < 5; i ++) {
    s += a * vec3 (Noisefv2 (p.yz), Noisefv2 (p.zx), Noisefv2 (p.xy));
    a *= 0.5;
    p *= 2.;
  }
  return dot (s, abs (n)) * (1. / 1.9375);
}

vec3 VaryNf (vec3 p, vec3 n, float f)
{
  vec3 g;
  float s;
  const vec3 e = vec3 (0.1, 0., 0.);
  s = Fbmn (p, n);
  g = vec3 (Fbmn (p + e.xyy, n) - s, Fbmn (p + e.yxy, n) - s,
     Fbmn (p + e.yyx, n) - s);
  return normalize (n + f * (g - n * dot (n, g)));
}

vec3 HsvToRgb (vec3 c)
{
  vec3 p;
  p = abs (fract (c.xxx + vec3 (1., 2./3., 1./3.)) * 6. - 3.);
  return c.z * mix (vec3 (1.), clamp (p - 1., 0., 1.), c.y);
}
