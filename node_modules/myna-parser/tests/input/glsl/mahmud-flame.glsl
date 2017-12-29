#ifdef GL_ES
precision mediump float;
#endif

// Yuldashev Mahmud Effect took from shaderToy mahmud9935@gmail.com

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 rot(float a){
	
	return mat2(cos(a), -sin(a), sin(a),+ cos(a));
	
}

float snoise(vec3 uv, float res)
{
	const vec3 s = vec3(2e0, 2e2, 1e3);
	
	uv *= res;
	
	vec3 uv0 = floor(mod(uv, res))*s;
	vec3 uv1 = floor(mod(uv+vec3(1), res))*s;
	
	vec3 f = fract(uv); f = f*f*(3.0-2.0*f);

	vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
		      	  uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

	vec4 r = fract(sin(v*1e-1)*1e3);
	float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	r = fract(sin((v + uv1.z - uv0.z)*1e-1)*1e3);
	float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	return mix(r0, r1, f.z)*2.-1.;
}

void main( void ) {

	vec2 p = -.5 + gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x/resolution.y;
	
	float d = length(p);
	p *= .8*rot(2.*cos(d*2. + .2*snoise(vec3(p*.9, d*.2 + sin(time*.2)), 5. )));
	
	
	float color = 3.0 - (3.*length(2.*p));
	
	vec3 coord = vec3(atan(p.x,p.y)/6.2832+.5, length(p)*.4, .5);
	
	for(int i = 2; i <= 7; i++)
	{
		
		
		
		float power = pow(2.0, float(i));
		color += (1.5 / power) * snoise(coord + vec3(0.,-time*.05, time*.01), power*16.);
	}
	gl_FragColor = vec4( pow(max(color,0.),2.)*1.4, pow(max(color,1.),1.)*0.4, pow(max(color,0.),1.)*0.4 , 1.0)*vec4(1, .6, .3, 1);;
}