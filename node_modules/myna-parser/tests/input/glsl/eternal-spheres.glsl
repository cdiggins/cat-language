// https://www.shadertoy.com/view/Xs3Gzf

// eternal spheres
// by Peder Norrby / Trapcode in 2015
// camera code by iq
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0

vec3 mhash3( float n )
{
	return -1.0+2.0*fract(sin(n+vec3(0.0,15.2,27.3))*158.3453123);
}


float mhash( float n )
{
	return -1.0+2.0*fract(sin(n)*158.3453123);
}



vec3 getColor(vec3 p)
{
	//float3 col = mhash3(V.x+50*V.y+2500*V.z+12121);
	float jitter = mhash(p.x+50.0*p.y+2500.0*p.z+12121.0);

	float f = p.y + 4.0*jitter;

	vec3 col;
		
	if (f > 4.0) col = vec3(0.2, 0.7, 1.0);
	else if (f > 0.0) col = vec3(0.2, 0.9, 1.0);
	else if (f > -4.0) col = vec3(1.0, 0.2, 1.0); 
	else col = vec3(0.6, 0.0, 1.0);

	return col;
}


vec4 trace_spheres( in vec3 rayo, in vec3 rayd )
{
 	vec3 p = rayo;// + rayd;
	const vec3 voxelSize = vec3(1.0,1.0,1.0);

	// find current voxel

	vec3 V = floor(p);
	vec3 V0 = V;
	vec3 step = sign(rayd); // step length for each dimension +1 or -1 (what about zero?? - zero is fine)

	vec3 lp = p - V; // local coords inside voxel

	vec3 tmax;// = abs((voxelSize - lp) / rayd);

	if (step.x > 0.0) tmax.x = voxelSize.x - lp.x; else tmax.x = lp.x;
	if (step.y > 0.0) tmax.y = voxelSize.y - lp.y; else tmax.y = lp.y;
	if (step.z > 0.0) tmax.z = voxelSize.z - lp.z; else tmax.z = lp.z;

	tmax /= abs(rayd);

	vec3 tdelta = abs(voxelSize / rayd);
    
    // voxel traversal algorithm by Andrew Woo (http://www.cse.chalmers.se/edu/year/2010/course/TDA361/grid.pdf)

	for(int i=0; i<60; i++) {
		if (tmax.x < tmax.y) {
			if (tmax.x < tmax.z) {
				V.x += step.x;
				tmax.x += tdelta.x;
			} else {
				V.z += step.z;
				tmax.z += tdelta.z;
			}
		} else {
			if (tmax.y < tmax.z) {
				V.y += step.y;
				tmax.y += tdelta.y;
			} else {
				V.z += step.z;
				tmax.z += tdelta.z;
			}
		}

		//if (dot(V-V0,V-V0) < 8.0) continue; // cull sphere around viewer
		if (V.x > -1.0 && V.x < 1.0 && V.y > -1.0 && V.y < 1.0) continue; // cull a pillar (box-shaped) along the z-axis

		// now we have the voxel, check for intersections with sphere
		vec3 c = V + voxelSize*0.5 + 0.4*mhash3(V.x+50.0*V.y+2500.0*V.z); // sphere at center of voxel + rnd displacement

		float r = voxelSize.x*0.10; // sphere is 20% of voxel size
		float r2 = r*r;

		vec3 p_minus_c = p - c;
		float p_minus_c2 = dot(p_minus_c, p_minus_c);
		float d = dot(rayd, p_minus_c);
		float d2 = d*d;
		float root = d2 - p_minus_c2 + r2;
		float dist;

		const float divFogRange = 1.0/30.0; // 50-20
		const vec3 fogCol = vec3(0.3, 0.3, 0.6);
		const vec3 sunDir = vec3(-0.707106, 0.707106, 0.0);

		if (root >= 0.0) {
			dist = -d - sqrt(root);
			float z = max(0.0, 2.5*(dist-20.0)*divFogRange);
			float fog = clamp(exp(-z*z), 0.0, 1.0);

			//float3 col = mhash3(V.x+50*V.y+2500*V.z+12121);
			vec3 col = getColor(V);

			//float3 col = float3(dist/50.0, -dist, dist*dist/(50*50));

			vec3 normal = normalize(p + rayd*dist - c);
			float light = 0.7 + 1.0 * clamp(dot(normal, sunDir), 0.0, 1.0);

			col = clamp(light*col, 0.0, 1.0);

			col = mix(fogCol, col, fog);

	
            return vec4( col, 1.0);
		}

		if ( dot(V-V0,V-V0) > 2500.0) break; // outside voxel grid
	}

	return vec4(0.3, 0.3, 0.6, 1.0);
} 

mat3 setCamera( in vec3 ro, in vec3 ta, float cr ) // by iq
{
	vec3 cw = normalize(ta-ro);
	vec3 cp = vec3(sin(cr), cos(cr),0.0);
	vec3 cu = normalize( cross(cw,cp) );
	vec3 cv = normalize( cross(cu,cw) );
    return mat3( cu, cv, cw );
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (-iResolution.xy + 2.0*fragCoord.xy)/ iResolution.y;

    vec2 m = vec2(0.0, -0.5);// iMouse.xy/iResolution.xy;
    
    // camera
    vec3 ro = 4.0*normalize(vec3(sin(3.0*m.x), 0.4*m.y, cos(3.0*m.x)));
	vec3 ta = vec3(-3.0*cos(iGlobalTime*0.1), -1.0, 0.0);
    mat3 ca = setCamera( ro, ta, 0.0 );
    // ray
    vec3 rd = ca * normalize( vec3(p.xy,2.0));
    
    ro.z -= iGlobalTime;
    
    fragColor = trace_spheres( ro + vec3(0.5, 1.5, 0.0), rd );
}

void mainVR( out vec4 fragColor, in vec2 fragCoord, in vec3 fragRayOri, in vec3 fragRayDir )
{
    fragColor = trace_spheres( fragRayOri, fragRayDir );
}