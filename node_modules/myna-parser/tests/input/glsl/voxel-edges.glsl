// https://www.shadertoy.com/view/4dfGzs
// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

//
// Shading technique explained here:
//
// http://www.iquilezles.org/www/articles/voxellines/voxellines.htm
//

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);
	
	vec2 uv = (p.xy+vec2(37.0,17.0)*p.z) + f.xy;
	vec2 rg = textureLod( iChannel0, (uv+0.5)/256.0, 0.0 ).yx;
	return mix( rg.x, rg.y, f.z );
}

vec4 texcube( sampler2D sam, in vec3 p, in vec3 n )
{
    vec3 m = abs( n );
	vec4 x = texture( sam, p.yz );
	vec4 y = texture( sam, p.zx );
	vec4 z = texture( sam, p.xy );
	return x*m.x + y*m.y + z*m.z;
}

float mapTerrain( vec3 p )
{
	p *= 0.1; 
	p.xz *= 0.6;
	
	float time = 0.5 + 0.15*iGlobalTime;
	float ft = fract( time );
	float it = floor( time );
	ft = smoothstep( 0.7, 1.0, ft );
	time = it + ft;
	float spe = 1.4;
	
	float f;
    f  = 0.5000*noise( p*1.00 + vec3(0.0,1.0,0.0)*spe*time );
    f += 0.2500*noise( p*2.02 + vec3(0.0,2.0,0.0)*spe*time );
    f += 0.1250*noise( p*4.01 );
	return 25.0*f-10.0;
}

vec3 gro = vec3(0.0);

float map(in vec3 c) 
{
	vec3 p = c + 0.5;
	
	float f = mapTerrain( p ) + 0.25*p.y;

    f = mix( f, 1.0, step( length(gro-p), 5.0 ) );

	return step( f, 0.5 );
}

vec3 lig = normalize( vec3(-0.4,0.3,0.7) );

float castRay( in vec3 ro, in vec3 rd, out vec3 oVos, out vec3 oDir )
{
	vec3 pos = floor(ro);
	vec3 ri = 1.0/rd;
	vec3 rs = sign(rd);
	vec3 dis = (pos-ro + 0.5 + rs*0.5) * ri;
	
	float res = -1.0;
	vec3 mm = vec3(0.0);
	for( int i=0; i<128; i++ ) 
	{
		if( map(pos)>0.5 ) { res=1.0; break; }
		mm = step(dis.xyz, dis.yxy) * step(dis.xyz, dis.zzx);
		dis += mm * rs * ri;
        pos += mm * rs;
	}

	vec3 nor = -mm*rs;
	vec3 vos = pos;
	
    // intersect the cube	
	vec3 mini = (pos-ro + 0.5 - 0.5*vec3(rs))*ri;
	float t = max ( mini.x, max ( mini.y, mini.z ) );
	
	oDir = mm;
	oVos = vos;

	return t*res;
}

vec3 path( float t, float ya )
{
    vec2 p  = 100.0*sin( 0.02*t*vec2(1.0,1.2) + vec2(0.1,0.9) );
	     p +=  50.0*sin( 0.04*t*vec2(1.3,1.0) + vec2(1.0,4.5) );
	
	return vec3( p.x, 18.0 + ya*4.0*sin(0.05*t), p.y );
}

mat3 setCamera( in vec3 ro, in vec3 ta, float cr )
{
	vec3 cw = normalize(ta-ro);
	vec3 cp = vec3(sin(cr), cos(cr),0.0);
	vec3 cu = normalize( cross(cw,cp) );
	vec3 cv = normalize( cross(cu,cw) );
    return mat3( cu, cv, -cw );
}

float maxcomp( in vec4 v )
{
    return max( max(v.x,v.y), max(v.z,v.w) );
}

float isEdge( in vec2 uv, vec4 va, vec4 vb, vec4 vc, vec4 vd )
{
    vec2 st = 1.0 - uv;

    // edges
    vec4 wb = smoothstep( 0.85, 0.99, vec4(uv.x,
                                           st.x,
                                           uv.y,
                                           st.y) ) * ( 1.0 - va + va*vc );
    // corners
    vec4 wc = smoothstep( 0.85, 0.99, vec4(uv.x*uv.y,
                                           st.x*uv.y,
                                           st.x*st.y,
                                           uv.x*st.y) ) * ( 1.0 - vb + vd*vb );
    return maxcomp( max(wb,wc) );
}

float calcOcc( in vec2 uv, vec4 va, vec4 vb, vec4 vc, vec4 vd )
{
    vec2 st = 1.0 - uv;

    // edges
    vec4 wa = vec4( uv.x, st.x, uv.y, st.y ) * vc;

    // corners
    vec4 wb = vec4(uv.x*uv.y,
                   st.x*uv.y,
                   st.x*st.y,
                   uv.x*st.y)*vd*(1.0-vc.xzyw)*(1.0-vc.zywx);
    
    return wa.x + wa.y + wa.z + wa.w +
           wb.x + wb.y + wb.z + wb.w;
}

vec3 render( in vec3 ro, in vec3 rd )
{
    vec3 col = vec3(0.0);
	
    // raymarch	
	vec3 vos, dir;
	float t = castRay( ro, rd, vos, dir );
	if( t>0.0 )
	{
        vec3 nor = -dir*sign(rd);
        vec3 pos = ro + rd*t;
        vec3 uvw = pos - vos;
		
		vec3 v1  = vos + nor + dir.yzx;
	    vec3 v2  = vos + nor - dir.yzx;
	    vec3 v3  = vos + nor + dir.zxy;
	    vec3 v4  = vos + nor - dir.zxy;
		vec3 v5  = vos + nor + dir.yzx + dir.zxy;
        vec3 v6  = vos + nor - dir.yzx + dir.zxy;
	    vec3 v7  = vos + nor - dir.yzx - dir.zxy;
	    vec3 v8  = vos + nor + dir.yzx - dir.zxy;
	    vec3 v9  = vos + dir.yzx;
	    vec3 v10 = vos - dir.yzx;
	    vec3 v11 = vos + dir.zxy;
	    vec3 v12 = vos - dir.zxy;
 	    vec3 v13 = vos + dir.yzx + dir.zxy; 
	    vec3 v14 = vos - dir.yzx + dir.zxy ;
	    vec3 v15 = vos - dir.yzx - dir.zxy;
	    vec3 v16 = vos + dir.yzx - dir.zxy;

		vec4 vc = vec4( map(v1),  map(v2),  map(v3),  map(v4)  );
	    vec4 vd = vec4( map(v5),  map(v6),  map(v7),  map(v8)  );
	    vec4 va = vec4( map(v9),  map(v10), map(v11), map(v12) );
	    vec4 vb = vec4( map(v13), map(v14), map(v15), map(v16) );
		
		vec2 uv = vec2( dot(dir.yzx, uvw), dot(dir.zxy, uvw) );
			
        // wireframe
        float www = 1.0 - isEdge( uv, va, vb, vc, vd );
        
        vec3 wir = smoothstep( 0.4, 0.5, abs(uvw-0.5) );
        float vvv = (1.0-wir.x*wir.y)*(1.0-wir.x*wir.z)*(1.0-wir.y*wir.z);

        col = 2.0*texture( iChannel1,0.01*pos.xz ).zyx; 
        col += 0.8*vec3(0.1,0.3,0.4);
        col *= 0.5 + 0.5*texcube( iChannel2, 0.5*pos, nor ).x;
        col *= 1.0 - 0.75*(1.0-vvv)*www;
		
        // lighting
        float dif = clamp( dot( nor, lig ), 0.0, 1.0 );
        float bac = clamp( dot( nor, normalize(lig*vec3(-1.0,0.0,-1.0)) ), 0.0, 1.0 );
        float sky = 0.5 + 0.5*nor.y;
        float amb = clamp(0.75 + pos.y/25.0,0.0,1.0);
        float occ = 1.0;
	
        // ambient occlusion
        occ = calcOcc( uv, va, vb, vc, vd );
        occ = 1.0 - occ/8.0;
        occ = occ*occ;
        occ = occ*occ;
        occ *= amb;

        // lighting
        vec3 lin = vec3(0.0);
        lin += 2.5*dif*vec3(1.00,0.90,0.70)*(0.5+0.5*occ);
        lin += 0.5*bac*vec3(0.15,0.10,0.10)*occ;
        lin += 2.0*sky*vec3(0.40,0.30,0.15)*occ;

        // line glow	
        float lineglow = 0.0;
        lineglow += smoothstep( 0.4, 1.0,     uv.x )*(1.0-va.x*(1.0-vc.x));
        lineglow += smoothstep( 0.4, 1.0, 1.0-uv.x )*(1.0-va.y*(1.0-vc.y));
        lineglow += smoothstep( 0.4, 1.0,     uv.y )*(1.0-va.z*(1.0-vc.z));
        lineglow += smoothstep( 0.4, 1.0, 1.0-uv.y )*(1.0-va.w*(1.0-vc.w));
        lineglow += smoothstep( 0.4, 1.0,      uv.y*      uv.x )*(1.0-vb.x*(1.0-vd.x));
        lineglow += smoothstep( 0.4, 1.0,      uv.y* (1.0-uv.x))*(1.0-vb.y*(1.0-vd.y));
        lineglow += smoothstep( 0.4, 1.0, (1.0-uv.y)*(1.0-uv.x))*(1.0-vb.z*(1.0-vd.z));
        lineglow += smoothstep( 0.4, 1.0, (1.0-uv.y)*     uv.x )*(1.0-vb.w*(1.0-vd.w));
		
        vec3 linCol = 2.0*vec3(5.0,0.6,0.0);
        linCol *= (0.5+0.5*occ)*0.5;
        lin += 3.0*lineglow*linCol;
		
        col = col*lin;
        col += 8.0*linCol*vec3(1.0,2.0,3.0)*(1.0-www);//*(0.5+1.0*sha);
        col += 0.1*lineglow*linCol;
        col *= min(0.1,exp( -0.07*t ));
	
        // blend to black & white		
        vec3 col2 = vec3(1.3)*(0.5+0.5*nor.y)*occ*www*(0.9+0.1*vvv)*exp( -0.04*t );;
        float mi = sin(-1.57+0.5*iGlobalTime);
        mi = smoothstep( 0.70, 0.75, mi );
        col = mix( col, col2, mi );
	}

	// gamma	
	col = pow( col, vec3(0.45) );

    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // inputs	
	vec2 q = fragCoord.xy / iResolution.xy;
    vec2 p = -1.0 + 2.0*q;
    p.x *= iResolution.x/ iResolution.y;
	
    vec2 mo = iMouse.xy / iResolution.xy;
    if( iMouse.w<=0.00001 ) mo=vec2(0.0);
	
	float time = 2.0*iGlobalTime + 50.0*mo.x;
    // camera
	float cr = 0.2*cos(0.1*iGlobalTime);
	vec3 ro = path( time+0.0, 1.0 );
	vec3 ta = path( time+5.0, 1.0 ) - vec3(0.0,6.0,0.0);
	gro = ro;

    mat3 cam = setCamera( ro, ta, cr );
	
	// build ray
    float r2 = p.x*p.x*0.32 + p.y*p.y;
    p *= (7.0-sqrt(37.5-11.5*r2))/(r2+1.0);
    vec3 rd = normalize( cam * vec3(p.xy,-2.5) );

    vec3 col = render( ro, rd );
    
	// vignetting	
	col *= 0.5 + 0.5*pow( 16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y), 0.1 );
	
	fragColor = vec4( col, 1.0 );
}

void mainVR( out vec4 fragColor, in vec2 fragCoord, in vec3 fragRayOri, in vec3 fragRayDir )
{
	float time = 1.0*iGlobalTime;

    float cr = 0.0;
	vec3 ro = path( time+0.0, 0.0 ) + vec3(0.0,0.7,0.0);
	vec3 ta = path( time+2.5, 0.0 ) + vec3(0.0,0.7,0.0);

    mat3 cam = setCamera( ro, ta, cr );

    vec3 col = render( ro + cam*fragRayOri, cam*fragRayDir );
    
    fragColor = vec4( col, 1.0 );
}