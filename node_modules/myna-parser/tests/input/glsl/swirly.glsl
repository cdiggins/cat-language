// http://glslsandbox.com/e#41192.0

precision mediump float;
uniform float time;
uniform vec2  mouse;
uniform vec2  resolution;

// thanks to: https://wgld.org/

// Author: https://twitter.com/c0de4

vec3 rotate(vec3 p, float angle, vec3 axis){
    vec3 a = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float r = 1.0 - c;
    mat3 m = mat3(
        a.x * a.x * r + c,
        a.y * a.x * r + a.z * s,
        a.z * a.x * r - a.y * s,
        a.x * a.y * r - a.z * s,
        a.y * a.y * r + c,
        a.z * a.y * r + a.x * s,
        a.x * a.z * r + a.y * s,
        a.y * a.z * r - a.x * s,
        a.z * a.z * r + c
    );
    return m * p;
}

float random (in vec2 st) { 
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233))) 
                * 43758.5453123);
}

// The MIT License
// Copyright © 2013 Inigo Quilez
float noise( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );
    
    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( random( i + vec2(0.0,0.0) ), 
                     random( i + vec2(1.0,0.0) ), u.x),
                mix( random( i + vec2(0.0,1.0) ), 
                     random( i + vec2(1.0,1.0) ), u.x), u.y);
}

const vec3 lightDir = vec3(-0.577, 0.577, 0.577);

float sphere(vec3 p, float size) {
	p += vec3(cos(time*.01*size+noise(vec2(time / 2.))), sin(time*size / 2.), cos(time*size / 2.));

	vec3 q = vec3(noise(vec2(time / 2.)), noise(vec2(time / 2.)), noise(vec2(time)));
	return length(mod(p, .4) - .2) - size;
}


float distanceFunc(vec3 p){
	
	p += vec3(cos(time*.01), sin(time*.01), cos(time*.01));
	p = rotate(p, radians(time)*0.3, vec3(1., 0., 0.));

	float obj1 = sphere(p, .1);
	float obj2 = max(-obj1, sphere(p*p, .2));
	float obj3 = min(obj2, sphere(p-obj1-obj2, .4));

	
	float dist = obj3;

	return dist *max(-obj1, min(obj2, obj3) );
}

vec3 getNormal(vec3 p){
    float d = 0.1;
    return normalize(vec3(
        distanceFunc(p + vec3(  d, 0.0, 0.0)) - distanceFunc(p + vec3( -d, 0.0, 0.0)),
        distanceFunc(p + vec3(0.0,   d, 0.0)) - distanceFunc(p + vec3(0.0,  -d, 0.0)),
        distanceFunc(p + vec3(0.0, 0.0,   d)) - distanceFunc(p + vec3(0.0, 0.0,  -d))
    ));
}

void main(void){
    // fragment position
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
    
    // camera
    vec3 cPos = vec3(0.0,  0.0,  2.);
    vec3 cDir = vec3(0.0,  0.0, -1.);
    vec3 cUp  = vec3(0.0,  1.0,  0.0);
    vec3 cSide = cross(cDir, cUp);
    float targetDepth = 1.;
    
    // ray
    vec3 ray = normalize(cSide * p.y - cUp * p.x + cDir * targetDepth);
    
    // marching loop
    float distance = 0.0;
    float rLen = 0.0;
    vec3  rPos = cPos;
    for(int i = 0; i < 26; i++){
        distance = distanceFunc(rPos);
        rLen += distance;
        rPos = rPos * .2 + max(-(cPos - ray * rLen * .75), (cPos + ray * rLen * .75));
    }
    
    // hit check
	vec3 normal = getNormal(length(rPos) - length(p)*.5 - rPos*1.);
        float diff = clamp(dot(lightDir * lightDir+noise(vec2(lightDir / 20.)), normal) / 3., 0.0, 1.0);
	
    diff = dot(lightDir * lightDir , normal);
	
    vec3 lightDir2 = vec3(0.877, -0.577, 0.577);	
    float diff2 = dot(lightDir2 * lightDir2, normal);

    vec3 lightDir3 = vec3(0.877, -0.877, 0.577);	
    float diff3 = dot(lightDir3 * lightDir3, normal);

    gl_FragColor = vec4(vec3(diff3*2.4, diff2 * 2., diff*3.), 1.) * 0.7;
}