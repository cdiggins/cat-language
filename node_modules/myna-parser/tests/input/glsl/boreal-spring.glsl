// https://www.shadertoy.com/view/ldXBRH

// Author: ocb
// Title: Boreal Spring

// License: Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License


// the main process is divided in several parts
// 1- find the outbound of a ray: Sky or Ground
// 2- the scenery is divided in sectors (or cells)
//    the getNextCell() return each cells crossed by ray
//    so only few object are consider for raytracing
//    this allow to maintain good perfos with thousands of trees
//    2D demo + explaination of getNextCell() here: https://www.shadertoy.com/view/XdffRN
// 3- finally raytrace fairy lights wich are not linked to a cell
//    fairy lights are raytraced twice for transparency purpose.


#define PI 3.141592653589793
#define PIdiv2 1.57079632679489
#define TwoPI 6.283185307179586
#define INFINI 1000000000.

#define maxTreeH 130.
#define maxHill 300.
#define cellH 430. 	/*treeH + maxHill*/
#define cellD 100.
#define maxCell 100
#define TREE_DENSITY (abs(fract(cell.x/10.)-.5)*abs(fract(cell.y/10.)-.5))*10.

// object name
#define GND -1
#define SKY -1000

#define REDL 1
#define MAGL 2
#define BLUL 3
#define YELL 4

#define COTTA 10
#define WALL 11
#define ROOF 12

#define TREE 20
#define CHRISTREE 21

#define SNOWMAN 40
#define BELLY 41
#define HEAD 42
#define HAT 43
#define NOZ 44

// ground parameters precalculated for perfo
#define SHIFT 0.
#define AMP 1.
#define P1 .003
#define P2 .0039999  /* P1*1.3333 */
#define P3 .0059661  /* P1*1.9887 */

#define DP2 .0039999 /*.00199995  /* AMP * P2 */
#define DP3 .0059661 /*.00298305  /* AMP * P3 */

#define NRM 4.   /* (1. + AMP + SHIFT) * 2. */


int hitObj = SKY;
float T = INFINI;

// object global
// Camera pos
vec3 camPos;
// Ambiance light direction
vec3 lightRay;
// lights
vec3 redO, magO, bluO, yelO;
float redR, magR, bluR, yelR;
// cotta
vec3 wallO, roofO;
float wallR, roofR, roofH;
vec2 cottaCell;

// snowpeople
vec3 belO, hedO, hatO, nozO;
float belR, hedR, hatH, hatR, nozH, nozR;
vec2 snowmanCell;

//tree
vec3 treeO;
float treeR, treeH;

//Christmas tree
vec3 CtreeO;
float CtreeR, CtreeH;
vec2 CtreeCell;

float rand1 (in float v) { 						    return fract(sin(v) * 437585.);}

float rand1 (in float v) { 						
    return fract(sin(v) * 437585.);
}
float rand2 (in vec2 st,in float time) { 						
    return fract(sin(dot(st.xy,vec2(12.9898,8.233))) * 43758.5453123+time);
}

// ground height
float ground(in vec2 p){
    float len = max(1.,0.0001*length(p));
    float hx = max(0., (sin(P1*(p.x+p.y)) + AMP*sin(P2*p.x+PIdiv2) + SHIFT) );
    float hy = max(0., (sin(P1*(p.y+.5*p.x)) + AMP*sin(P3*p.y+PIdiv2) + SHIFT));
    return maxHill*(hx+hy)/NRM/len;
}

// returning ground normal for a position p
// derivation of the ground function
vec3 getGndNormal(in vec2 p, in float h) {
    if(h<.001) return vec3(0.,1.,0.);
    else{
        float len = max(1.,0.0005*length(p));
        float dx = maxHill*( P1*cos(P1*(p.x+p.y)) + DP2*cos(P2*p.x+PIdiv2) )/NRM;
        float dy = maxHill*( P1*cos(P1*(p.y+.5*p.x)) + DP3*cos(P3*p.y+PIdiv2) )/NRM;
        return normalize(cross( vec3(1.,dx/len,0.), vec3(0.,dy/len,1.) ));		// divided by len: We may call that "normal fog"
    }
}

//************ Ray marching to find ground impact ********
float gndRayTrace(in vec3 p, in vec3 ray){
    float t = 0.;
    float contact = .5;
    float dh = p.y - ground(p.xz);
    if(dh<contact) return .0001;
    for(int i=0; i<100;i++){
        t += dh;			// t = dh/length(ray) but ray normalized
        p += dh*ray;
        if(p.y >= cellH && ray.y>=0.){
            t = INFINI;
            break;
        }
        dh = p.y - ground(p.xz);
        if(abs(dh)<contact)break;
    }
    return t;
}

//********** raytracing for simple primitives *********
float sfcImpact(in vec3 p, in vec3 ray, float h){
    float t = (h-p.y)/ray.y;
    if (t <= 0.001) t = INFINI;
    return t;
}

float sphereImpact(in vec3 pos, in vec3 sphO, in float sphR, in vec3 ray){
    float t = INFINI;
    vec3 d = sphO - pos;
    float dmin = 0.;
    float b = dot(d, ray);
    
    if (b >= 0.){	// check if object in frontside first (not behind screen)
        float a = dot(ray,ray);
        float c = dot(d,d) - sphR*sphR;
    	float disc = b*b - c;
    	if (disc >= 0.){
        	float sqdisc = sqrt(disc);
            float t1= (b + sqdisc)/a;
            float t2= (b - sqdisc)/a;
        	t = min(t1,t2) ;
        	if (t <= 0.001){
                t = max(t1,t2);
                if (t <= 0.001) t = INFINI;
            } 
        }
    }
    return t;
}

float coneImpact(in vec3 pos, in vec3 coneO, in float coneH, in float coneR, in vec3 ray){
    float t = INFINI, dmin=0.;
    vec3 d = coneO - pos;
    float Dy = coneH + d.y;
    float r2 = coneR*coneR/(coneH*coneH);
    float b = dot(d.xz, ray.xz);
    
    if (b >= 0.){	// check if object in frontside first (not behind screen)
    	float a = dot(ray.xz,ray.xz);
    	float c = dot(d.xz,d.xz) - r2*Dy*Dy;
    	float c1 = -b + r2*Dy*ray.y;
    	float disc = c1*c1 - (a - r2*ray.y*ray.y) * c;
    	if (disc >= 0.){
    	    float sqdis = sqrt(disc);
        	float t1 = (-c1 + sqdis)/(a - r2*ray.y*ray.y);
        	float t2 = (-c1 - sqdis)/(a - r2*ray.y*ray.y);
        	
        	float ofc = -ray.y*t1 + Dy;
    		t1 *= step(0.,ofc)*(1.-step(coneH,ofc));
        	if (t1 <= 0.001) t1 = INFINI;
        	
        	ofc = -ray.y*t2 + Dy;
        	t2 *= step(0.,ofc)*(1.-step(coneH,ofc));
        	if (t2 <= 0.001) t2 = INFINI;
        	
        	t = min(t1,t2);
    	}
    }
	return t;
}


//******* TEXTURES AND COLORS *********

vec3 skyGlow(in vec3 ray){
    if(ray.y>=0.)return vec3(.5*max(ray.x+.7,0.)*(.8-max(0.,ray.y)), .35,.4)*(1.-ray.y)*(ray.x+1.5)*.4;
    else return vec3(0.);
}

vec3 snowColor(in vec3 pos){
    vec3 col = vec3(.7,.7,.75)+vec3(.05,.05,.05)*rand2(floor(pos.xz*10.), 0.);
    col += vec3(1.,.7,.8)*step(.997,rand2 (floor(pos.xz*20.), 0.));
    return col;
}


// Ctree light on ground 
vec3 CtreeColor(in vec3 pos){
    return .5*vec3(.5,.5,1.)*min(1.,30./length(pos-CtreeO-vec3(0.,CtreeH/2.,0.)));
}

// fairylight on ground
vec3 lightColor(in vec3 pos){
    vec3 color = vec3(0.);
    color.r += min(1.,5./length(pos-redO));
    color.rb += min(1.,5./length(pos-magO));
    color.b += min(1.,10./length(pos-bluO));
    color.rg += min(1.,3./length(pos-yelO));
    return color;
}

// cotta window
vec3 window(in float angl, in vec3 pos){
    float dh = pos.y-wallO.y-.25*wallR;
    float an = fract(3.*angl/PI)-.5;
    return vec3(1.,.5,.0)*(smoothstep(-.9,-.8,-abs(abs(dh)-1.))*( smoothstep(-.04,-.03,-abs(abs(an)-.04)))+.2*(1.-smoothstep(.0,.4,abs(an))));
    
}

// window light on ground
vec3 winLitcolor(vec3 pos){
    float r = length(pos.xz-wallO.xz)*.01;
    if (r<2.5){
    	float a= fract(3.*atan(pos.z- wallO.z,pos.x - wallO.x)/PI)-.5;
    	return vec3(1.,.5,.0)*.3*smoothstep(-2.,-.0,-r)*smoothstep(.1,.8,r)*smoothstep(-.5,-.0,-abs(a))*smoothstep(-60.,.0,-pos.y+wallO.y);
    }
    else return vec3(0.);
}

vec3 stars(in float a,in vec3 ray){
    vec2 star = vec2(a,ray.y*.7)*30.;
    vec2 p = floor(star);
    if(rand2(p,0.)>.97){
        vec2 f = fract(star)-.5;
    	return  vec3(.7*smoothstep(0.,.3,abs(fract(iGlobalTime*.3+3.*a)-.5))*ray.y * (smoothstep(-.01,-.0,-abs(f.x*f.y))+max(0.,.1/length(f)-.2)));
    }
	else return vec3(0.);
}

// northern light
vec3 boreal(in float a,in vec3 ray){
    vec3 col = vec3(0.);
    float b = .03*(asin(clamp(6.*a+12.,-1.,1.))+PIdiv2);
    float c = .2*(asin(clamp(-.2*a*abs(a)-1.67222,-1.,1.))+2.042);
    float d = .05*(a+1.)*(asin(clamp(a-1.,-1.,1.))+PIdiv2);
    float rebord = smoothstep(1.83333,1.9,-a);
    float rebord2 = smoothstep(-2.,-1.9,-a);
    float var1 = (sin(1./(a+2.2)+a*30. + iGlobalTime)+1.)/4.+.5;
    float var2 = (sin(a*10. - iGlobalTime)+1.)/4.+.5;
    float var3 = (sin(1./(a+.04)+a*10. + iGlobalTime)+1.)/4.+.5;
    col += 2.5*vec3(0.292,ray.y,0.1)*var1*smoothstep(b,b+.5*ray.y,ray.y)*smoothstep(-b-.9*ray.y,-b,-ray.y)*rebord;
    col += 1.*vec3(.6-ray.y,.5*ray.y,0.15)*var2*smoothstep(c,c+.07,ray.y)*smoothstep(-c-.5,-c,-ray.y)*rebord;
    col += 2.5*vec3(0.292,ray.y,0.1)*var3*smoothstep(d,d+.5*ray.y,ray.y)*smoothstep(-d-.9*ray.y,-d,-ray.y)*rebord2;
	return col;
}

vec3 skyColor(in vec3 ray){
    float a = atan(ray.z,ray.x);
    vec3 color = skyGlow(ray);
    color += stars(a,ray);
    color += boreal(a, ray);
    return color;
}

vec3 groundColor(in vec3 pos, in vec3 ray, in vec3 norm){
    float len = length(camPos.xz-pos.xz);
    float dir = max(0.,dot(-lightRay,norm));
    vec3 color = snowColor(pos*.5)*(.9*dir+.1);
    color *= .5+.5*pos.y/maxHill;
    ray = reflect(ray, norm);
    ray.y = max(0.,ray.y);
    color = mix(.9*skyGlow(ray),color,.7);
    color *= 1.-atan(len/10000.)/PIdiv2;
    color += vec3(.4*max(ray.x+.7,0.), .35,.4)*(ray.x+1.5)*.4*atan(len/20000.)/PIdiv2;
    color += .8*lightColor(pos);
    color += winLitcolor(pos);
    color += CtreeColor(pos);
	return color;
}

//************* COTTA FUNCTIONS ************
vec3 roofColor(in vec3 p, in vec3 ray, in vec3 norm){
    float an = atan((p.z - roofO.z),(p.x - roofO.x));
    float lim = 4.*(.2*sin(6.*an)+1.1);
    vec3 tile = (smoothstep(.0,.9, abs(fract(p.y)-.5))+smoothstep(0.,.7,abs(fract(20.*an+step(1., mod(p.y,2.0)) * 0.5)-.5)))*vec3(0.380,0.370,0.207);
    vec3 color = step(-p.y+roofO.y,-lim)*snowColor(p*5.) + step(p.y-roofO.y,lim)*tile;
    float h = ground(p.xz);
    vec3 gndNorm = getGndNormal(p.xz, h);
    color *= (dot(gndNorm, -lightRay)+.7)/1.;
    color *= ((dot(lightRay,norm)+1.)*.3 + .05);
    color += .8*lightColor(p);
    return color;
}

vec3 wallColor(in vec3 p, in vec3 ray, in vec3 norm){
    float angl = atan((p.z - wallO.z),(p.x - wallO.x));
    float lim =  1.3*(sin(2.*angl)+1.5);
    vec3 tile = (smoothstep(0.,.5,abs(fract(p.y)-.5))+smoothstep(0.,.1,abs(fract(2.*angl)-.5)))*vec3(0.320,0.296,0.225);
    vec3 color = step(p.y,lim)*snowColor(p*5.) + step(-p.y,-lim)*tile;
    ray = reflect(ray, norm);
    if(ray.y >0.) color = mix(color,skyGlow(ray),.3);
    else color = mix(color,skyGlow(ray*vec3(1.,-1.,1.)),.3);
    color *= ((dot(lightRay,norm)+1.)*.2 + .2);
    color += window(angl, p);
    color += .8*lightColor(p);
    return color;
}

bool cottaImpact(in vec3 p, in vec3 ray, inout vec3 color){
    bool impact = false;
    float tr = coneImpact(p, roofO, roofH, roofR, ray);
    float tw = sphereImpact(p, wallO, wallR, ray);
    float t = min(tr,tw);
    if(t<T){
        T=t;
        p += t*ray;
        impact = true;
        if(t == tr){
            hitObj = ROOF; 
            vec3 norm = normalize(vec3(p.x - roofO.x,roofR*roofR/(roofH*roofH)*(roofH + roofO.y - p.y),p.z-roofO.z));
            color += roofColor(p, ray, norm);
        }
        else{
            hitObj = WALL;
            vec3 norm = normalize(p-wallO);
            color += wallColor(p, ray, norm);
        }
    }
    
    // twinkeling garland 
    float R = roofR+.5, H = 1.;
    for(int i = 0; i<47; i++){
        float fi = float(i);
        float v = fi/50.;
        float dh = H*(1.+sin(6.*v*TwoPI));        
        vec3 bulb = vec3(roofO.x + R*sin(v*TwoPI), roofO.y+dh-.5 ,roofO.z + R*cos(v*TwoPI));
		float d = length(cross((bulb-p), ray));		// no bulbs impact. Distance ray to point for halo effect
        if (!(impact && dot(bulb-p,ray)>=0.)){		// No bulbs behind object
            color.rgb += max(0.,.15/d-.005)*(sin(2.*iGlobalTime-fi)+1.000)/2.;
            color.r += max(0.,.15/d-.005)*(sin(2.*iGlobalTime+fi)+1.)/2.;
        }
    }
    return impact;
}

//***************** SNOWMAN FUNTIONS *******************
vec3 bellyColor(in vec3 p, in vec3 ray, in vec3 norm, in vec3 belly){
    vec3 color = snowColor(norm*30.);
    color -= vec3(0.016,0.515,0.525)*step(.1,abs(p.z-belO.z));
    color -= vec3(0.016,0.515,0.525)*step(-.1,-abs(p.z-belO.z))*step(-belO.x,-p.x);
    ray = reflect(ray, norm);
    if(ray.y >0.) color = mix(color,skyGlow(ray),.3);
    else color = mix(color,skyGlow(ray*vec3(1.,-1.,1.)),.3);
    color *= ((dot(lightRay,norm)+1.)*.2 + .2);
    color *= (1.-step(-.5,-abs(p.z-belly.z))*step(0.,p.x-belly.x)* step(.9, fract((p.y-belly.y)*.4)));
    color += lightColor(p);
    return color;
}

vec3 headColor(in vec3 p, in vec3 ray, in vec3 norm, in vec3 head){
    vec3 color = snowColor(norm*30.);
    color -= vec3(0.016,0.515,0.525)*step(-hedO.y+.4*exp(p.x-hedO.x-2.),-p.y);
    color -= (1.-step(.3,length(head.yz+vec2(1.5,1.5)-p.yz)))*step(hedO.x,p.x);
    color -= (1.-step(.3,length(head.yz+vec2(1.5,-1.5)-p.yz)))*step(hedO.x,p.x);
    ray = reflect(ray, norm);
    if(ray.y >0.) color = mix(color,skyGlow(ray),.3);
    else color = mix(color,skyGlow(ray*vec3(1.,-1.,1.)),.3);
    color *= ((dot(lightRay,norm)+1.)*.2 + .2);
    color += lightColor(p);
    return color;
}

vec3 hatColor(in vec3 p, in vec3 ray, in vec3 norm){
    vec3 color = snowColor(p*5.);
    color -= step(.5,fract(p.y*.4))*vec3(0.016,0.515,0.525);
    color *= ((dot(lightRay,norm)+1.)*.2 + .2);
    color += lightColor(p);
    return color;
}

vec3 nozColor(in vec3 p, in vec3 ray, in vec3 norm){
    vec3 color = vec3(0.475,0.250,0.002);
    color *= ((dot(vec3(0.,1.,0.),norm)+1.)*.4 + .2);
    color += lightColor(p);
    return color;
}


bool caracterImpact(in vec3 p, in vec3 ray,inout vec3 color){
    bool impact = false;
    float tbel = sphereImpact(p, belO, belR, ray);
    float thed = sphereImpact(p, hedO, hedR, ray);
    float that = coneImpact(p, hatO, hatH, hatR, ray);
    float tnoz = coneImpact(vec3(-p.y,p.x,p.z), vec3(-nozO.y,nozO.x,nozO.z), nozH, nozR, vec3(-ray.y,ray.x,ray.z));
    float t = min(min(min(tbel,thed),that),tnoz);
    if(t<T){
        T=t;
        p += t*ray;
        impact = true;
        hitObj = SNOWMAN;
        if(t == tbel){
            vec3 norm = normalize(p - belO);
            color += bellyColor(p, ray, norm, belO);
        }
        else if(t == thed){
            vec3 norm = normalize(p - hedO);
            color += headColor(p, ray, norm, hedO);
        }
        else if(t == that){
            vec3 norm;
            norm.xz = p.xz - hatO.xz;	// simplified norm for hat. (perfo)
            norm.y = 0.;
            norm = normalize(norm);
            color += hatColor(p, ray, norm);
        }
        else{
            vec3 norm;
            norm.yz = p.yz - nozO.yz;
            norm.x = 0.;
            norm = normalize(norm);
            color += nozColor(p, ray, norm);
        }
    }
    return impact;
}


//**************** TREE FUNCTIONS *********************
vec3 treeColor(in vec3 p, in vec3 ray, in vec3 norm){
    float lim = 40.*(.05*sin(.6*p.x)+.5);
    vec3 color = step(-p.y+treeO.y,-lim)*snowColor(fract(p*5.)) + step(p.y-treeO.y,lim)*vec3(0.000,0.320,0.317);
    color *= ((dot(lightRay,norm)+1.)*.3 + .05);
    vec3 r = reflect(ray,norm);
    r.y = abs(r.y);
    color += step(-p.y+treeO.y,-lim)*.7*skyGlow(r)*(treeO.y+10.)/maxHill;
    color *= .6+.4*p.y/maxHill;
    color += .8*lightColor(p);
    color += 1.9*winLitcolor(p)*max(0.,dot(-normalize(p-wallO),norm));
    color *= 1.-atan(length(camPos-p)/5000.)/PI*2.;
	return color;
}

// create tree, if there is one (treeDensity)
bool getTree(in vec2 cell,inout vec3 treeO, inout float treeH, inout float treeR){
    bool treeOk = bool(step(TREE_DENSITY,rand2(cell*1.331,1.)));			// check if object, depending cell coords
        if (treeOk){ 
            treeH = (.5*rand2(cell*3.86,0.)+.5)*maxTreeH;
            treeR = .15*treeH;
            float lim = (1.-2.*treeR/cellD);
            treeO = vec3(lim*(rand2(cell*2.23,0.) - 0.5) + cell.x, 0., lim*(rand2(cell*1.41,0.) -0.5)  + cell.y) *cellD;
            treeO.y += ground(treeO.xz)-10.;
        }
    return treeOk;
}

bool treeImpact(in vec2 cell, in vec3 p, in vec3 ray, inout vec3 color){
    bool impact = false;
    bool tree = getTree(cell,treeO, treeH, treeR);
    if(tree){
        float t = coneImpact(p, treeO, treeH, treeR, ray);
        if(t<T){
            T=t;
            hitObj = TREE;
            impact = true;
            p += t*ray;
            vec3 norm = normalize(vec3(p.x - treeO.x,treeR*treeR/(treeH*treeH)*(treeH + treeO.y - p.y),p.z-treeO.z));
            color += treeColor(p, ray, norm);
        }
    }
    
    return impact;
}

//************** Christmas tree *******************
bool CtreeImpact(in vec3 p, in vec3 ray, inout vec3 color){
    bool impact = false;
    
    float t = coneImpact(p, CtreeO, CtreeH, CtreeR, ray);
        if(t<T){
            T=t;
            hitObj = CHRISTREE;
            impact = true;
            p += t*ray;
            vec3 norm = normalize(vec3(p.x - CtreeO.x,CtreeR*CtreeR/(CtreeH*CtreeH)*(CtreeH + CtreeO.y - p.y),p.z-CtreeO.z));
            treeO.y = CtreeO.y;
            color += treeColor(p, ray, norm);
        }
    
    // twinkeling garland
    float R = CtreeR+1., H = CtreeH+5.;
    for(int i = 0; i<47; i++){
        float fi = float(i);
        float v = rand1(fi*1.87);
        float dh = H*fract(fi*.02);
        float r = R*(H-dh)/H;
        vec3 bulb = vec3(CtreeO.x + r*sin(fi*v), CtreeO.y+dh+5. ,CtreeO.z + r*cos(fi*v));
		float d = length(cross((bulb-p), ray));			// no bulbs impact. Distance ray to point for halo effect
        if (!(impact && dot(bulb-p,ray)>=0.)){			// hidden face
            color.rgb += max(0.,.15/d-.005)*(sin(2.*iGlobalTime-fi)+1.)/2.;
            color.b += max(0.,.15/d-.005)*(sin(2.*iGlobalTime+fi)+1.)/2.;
            
        }
        if(impact){
            float c = .05/length(p-bulb);
            color += vec3(c,c,4.*c);
        }
    }

    return impact;
}


//********************** FAIRY LIGHTS FUNCTIONS ******************
vec3 fairyReflect(in vec3 ray,in vec3 norm){
    vec3 r = reflect(ray,norm);
    r.y = abs(r.y);
    return skyGlow(r);
}

// set fairy lights colors
vec3 fairyLight(in vec3 ray,in vec3 pos,in int hitObj){
    float cs;
    vec3 norm;
    vec3 refl;
    vec3 col=vec3(0.);
    if (hitObj == REDL){
        col.r += .05;
        norm = normalize(redO-pos);
        col += .5*fairyReflect(ray,norm);
		cs = dot(ray,norm);
        col.r += .2*smoothstep(-1.,0.,-cs);
    	col.r += exp(30.*(cs-1.));
    }
    else if (hitObj == MAGL){
        col.rb += .05;
        norm = normalize(magO-pos);
        col += .5*fairyReflect(ray,norm);
        cs = dot(ray,norm);
        col.rb += .2*smoothstep(-1.,0.,-cs);
    	col.rb += exp(30.*(cs-1.));
    }
    else if (hitObj == BLUL){
        col += .05*vec3(0.,.3,1.);
        norm = normalize(bluO-pos);
        col += .5*fairyReflect(ray,norm);
        cs = dot(ray,norm);
        col += vec3(0.,.3,1.)*.3*smoothstep(-1.,0.,-cs);
    	col += vec3(0.,.3,1.)*exp(30.*(cs-1.));
    }
	else if (hitObj == YELL){
        col.rg += .05;
        norm = normalize(yelO-pos);
        col += .5*fairyReflect(ray,norm);
        cs = dot(ray,norm);
        col.rg += .2*smoothstep(-1.,0.,-cs);
    	col.rg += exp(30.*(cs-1.));
    }
    return col;
}

// Ray-trace fairy lights taking into account transparency
float lightTrace(in vec3 pos, in vec3 ray,inout int hitLit, in int trans){
    float t = INFINI, tp; 	
    
    if(trans != REDL){
    		tp = sphereImpact(pos, redO, redR, ray);
    		if(tp<t){
            	t = tp;
            	hitLit = REDL;
    		}
        }
    if(trans != MAGL){
    		tp = sphereImpact(pos, magO, magR, ray);
    		if(tp<t){
            	t = tp;
            	hitLit = MAGL;
    		}
        }
    if(trans != BLUL){
    		tp = sphereImpact(pos, bluO, bluR, ray);
    		if(tp<t){
            	t = tp;
            	hitLit = BLUL;
    		}
        }
    if(trans != YELL){
    		tp = sphereImpact(pos, yelO, yelR, ray);
    		if(tp<t){
            	t = tp;
            	hitLit = YELL;
    		}
        }

    return t;
}

//**************************** KEY FUNCTION!! find the next cells crossed by the ray ******************
vec2 getNextCell(in vec2 p, in vec2 v, in vec2 cell){
    vec2 d = sign(v);
	vec2 dt = ((cell+d*.5)*cellD-p)/v;
    d *= vec2( step(dt.x-0.02,dt.y) , step(dt.y-0.02,dt.x) );		// -0.020 to avoid cell change for epsilon inside
    return cell+d;
}

//*************** cal the set of functions depending on particular cell *************
bool checkCell(in vec2 cell, in vec3 p, in vec3 ray, inout vec3 color){
    bool impact = false;
    if(cell == cottaCell) impact = cottaImpact(p, ray, color);   
    else if(cell == snowmanCell) impact = caracterImpact(p, ray, color);
    else if(cell == CtreeCell) impact = CtreeImpact(p, ray, color);
    else impact = treeImpact(cell, p, ray, color);
    return impact;
}

//*************** Lights path and camera tracking *******************************
vec3 circle(in float ti, in vec3 obj){
    return vec3(80.*cos(ti*TwoPI) + obj.x, 0., 80.*sin(ti*TwoPI) + obj.z);
}

vec3 freetrack(in float time){
    return vec3(1500.*cos(time*.05), 0., 1600.*sin(time*.15));
}

vec3 transfer(in vec3 tr1, in vec3 tr2, in float dti){
    return tr1*(1.+cos(dti*.25*PI))/2. + tr2*(1.+cos(dti*.25*PI+PI))/2.;
}

vec3 getTrac(in float time){
    float ti = 23.*fract(time*.01);
    vec3 track;
    
    if(ti<1.) track = circle(ti,wallO);
    else if(ti<5.) track = transfer(circle(ti,wallO), freetrack(time), ti-1.);
    else if(ti<10.) track = freetrack(time);
    else if(ti<14.) track = transfer(freetrack(time), circle(ti,hedO), ti-10.);
    else if(ti<15.) track = circle(ti,hedO);
    else if(ti<19.) track = transfer(circle(ti,hedO), circle(ti,CtreeO), ti-15.);
    else track = transfer(circle(ti,CtreeO), circle(ti,wallO), ti-19.);
    
    return track;
}

vec3 getCam(in float time, in vec3 track){
    float ti = 23.*fract(time*.01);
    vec3 cam;
    
    if(ti<1.) cam = wallO;
    else if(ti<5.) cam = transfer(wallO, track, ti-1.);
    else if(ti<10.) cam = track;
    else if(ti<14.) cam = transfer(track, hedO, ti-10.);
    else if(ti<15.) cam = hedO;
    else if(ti<19.) cam = transfer(hedO, CtreeO, ti-15.);
    else cam = transfer(CtreeO, wallO, ti-19.);
    
    return cam;
}


//**********************************************************************************
void mainImage( out vec4 fragColor, in vec2 fragCoord ){
    
    vec2 st = fragCoord.xy/iResolution.xy-.5;
    st.x *= iResolution.x/iResolution.y;
    
    // object def
    
    //cotta
    wallO = vec3(400.,4.,-600.);
    wallO.y += ground(wallO.xz);
    wallR = 20.;
    roofO = wallO+vec3(0.,8.,0.);
    roofH = 42.;
    roofR = 22.;
    cottaCell = vec2(4.,-6.);   //floor(wallO.xz/cellD + .5);
    
    //SnowMan
    belO = vec3(200.,4.,100.);
    belR = 10.;
    belO.y = ground(belO.xz);
    hedO = belO+vec3(0.,13.,0.);
    hedR = 5.;
    hatO = belO+vec3(0.,16.,0.);
    hatH = 15.;
    hatR = 3.8;
    nozO = belO+vec3(4.,13.,0.);
    nozH = 4.;
    nozR = .8;
    snowmanCell = vec2(2.,1.);		//floor(belO.xz/cellD + .5);
    
    //Christmas tree
	CtreeO.xz = vec2(1200.,-600.);
	CtreeO.y = ground(CtreeO.xz)-5.;
    CtreeH = 100.;
    CtreeR = 15.;
	CtreeCell = vec2(12.,-6.);
    
    //light
    vec3 trac = getTrac(iGlobalTime);
    trac.y += ground(trac.xz)+15.;
    vec3 tracb = getTrac(iGlobalTime-.5);
    tracb.y = ground(tracb.xz)+1.;
    redO = trac + vec3(20.*sin(iGlobalTime*2.),5.*sin(iGlobalTime*3.),10.*cos(iGlobalTime*2.));
    redR = 3.;
    magO = trac +vec3(10.*sin(1.+iGlobalTime*2.),4.*sin(1.6+iGlobalTime*3.),15.*cos(1.+iGlobalTime*2.));
    magR = 3.;
    bluO = trac +vec3(10.*sin(5.+iGlobalTime*3.),2.*sin(3.+iGlobalTime*2.),10.*cos(5.+iGlobalTime*3.));
    bluR = 3.;
    yelO = tracb +vec3(30.*sin(iGlobalTime*3.),abs(15.*sin(iGlobalTime*4.)+4.),20.*cos(iGlobalTime*3.));
    yelR = 1.;
    
    //vec3 camTarget = trac;
    //vec3 camTarget = tracb;
    //vec3 camTarget = wallO*(1.+sin(u_time*.2))/2. + trac*(1.+sin(u_time*.2+PI))/2.;
    //vec3 camTarget = redO;
    //vec3 camTarget = bluO;
    //vec3 camTarget = yelO;
    //vec3 camTarget = (trac+wallO)/2.;
    //vec3 camTarget = wallO;
    //vec3 camTarget = roofO;
    //vec3 camTarget = hedO;
    //vec3 camTarget = CtreeO+vec3(0.,50.,0.);
    vec3 camTarget = getCam(iGlobalTime, trac);
    
    // camera def
    float 	focal = 1.;
    float 	rau = 500.*(sin(iGlobalTime/7.)+1.) + 40.,
    		alpha = iMouse.x/iResolution.x*4.*PI/*-u_time/5.*/,
    		theta = iMouse.y/iResolution.y*PI/2.-.00001;//(sin(u_time/7.)/2.+0.5)*(PI/2.-.1)+0.05;	
    
    camPos = rau*vec3(-cos(theta)*sin(alpha),sin(theta),cos(theta)*cos(alpha)) + camTarget;
	camPos.y = max(ground(camPos.xz)+15.,camPos.y);		//anti-collision
    
    vec3 pos = camPos;
    
    vec3 ww = normalize( camTarget - pos );
    vec3 uu = normalize( cross(ww,vec3(0.0,1.0,0.0)) ) ;
    vec3 vv = cross(uu,ww);
	// create view ray
	vec3 N_ray = normalize( st.x*uu + st.y*vv + focal*ww );
    
	lightRay = vec3(1.,0.,0.);	// global var
	vec3 GNDnorm = vec3(0.);
    
    vec3 color = vec3(.0);
        
    vec2 cell, outCell;
    vec3 p = pos;
    
    // first step getting boundarry of interesting areas
    // find exit cell
    T = gndRayTrace(pos, N_ray);
    if(T<INFINI){
        hitObj = GND;
        vec3 tp = pos+T*N_ray;
        cell = floor(tp.xz/cellD + .5);
        outCell = getNextCell(pos.xz,N_ray.xz,cell);
    }
    else if(pos.y<cellH){
        T = sfcImpact(pos, N_ray, cellH);
        if(T<INFINI){									// hitObj = SKY already default value
            vec3 tp = pos+T*N_ray;
            cell = floor(tp.xz/cellD + .5);
            outCell = getNextCell(pos.xz,N_ray.xz,cell);
            T = INFINI;									// T consistant with SKY
        }
    }
    else outCell = floor(pos.xz/cellD + .5);
	
    //if cam above ceiling, find entry cell
    if(pos.y>=cellH){
        float t = sfcImpact(pos, N_ray, cellH);
        if(t<INFINI) p = pos+t*N_ray;
    }
    
    
    // follow the ray across cells (and if object in cell, raytrace only the current cell)
    // until:
    // ray has reached the outCell (i.e. cell where the ray hit ground or ceiling)
    // or ray has impact object
    // or ray has reach the maxCell (calculation must end)
    bool objImpact = false;
    cell = floor(p.xz/cellD + .5);
    if(cell != outCell){
        for(int i=0; i<maxCell;i++){
            objImpact = checkCell(cell, pos, N_ray, color);
            if(objImpact) break;
            cell = getNextCell(pos.xz,N_ray.xz,cell);
            if(cell == outCell) break;
        } 
 	}
    
    vec3 finalPos = pos + T*N_ray;
    
    // if impact, hitObj is TREE, CHRSTREE, COTTA OR SNOWMAN, color already set
    // finally, if no impact, closing the scenery: SKY or GND
    
    if(hitObj == SKY) color += skyColor(N_ray);
    else if(hitObj == GND){
        GNDnorm = getGndNormal(finalPos.xz,finalPos.y);
        color += 1.3*groundColor(finalPos, N_ray, GNDnorm);
    }
    
    
	// particles flying around snowman.
    // done in global because halo light propagates on multiple cells
    // first line: check if ray enter a radius around snowman vertical axis
    // to do calulation only in the environement of particules (here radius = 50.)
    if( (abs(N_ray.z*(belO.x-pos.x) - N_ray.x*(belO.z-pos.z)) <50.) && (dot(belO-pos, N_ray)>=0.) ){
    	float len_fp_p = length(T*N_ray);
        if(len_fp_p > length(belO-pos)-cellD){
            float H = 200., R = 15.;
            for(int i = 0; i<47; i++){
                float fi = float(i);
                float ti = -iGlobalTime+fi;
                float dh = H*pow(fract(ti*.02),4.);
                float r = R*(H-dh)/H;		// for cone figure
                float v = rand1(fi);
                vec3 bulb = vec3(belO.x + r*sin(ti*v), belO.y+dh ,belO.z + r*cos(ti*v));
                vec3 b_p = bulb-pos;
                vec3 b_fp = bulb-finalPos;
                float d;
                if(len_fp_p<length(b_p)) d = length(b_fp);
    			else d = length(cross((b_p), N_ray));
                if (!(hitObj == SNOWMAN && dot(b_fp,N_ray)>=0.)){
                    color += max(0.,.15/d-.003)*rand1(fi);
                }
            }
        }
    }
    
    // Finally dealing with fairy lights, totally independant of cells. Done in global
    int lightNbr;
    float tlit;
    // intercept lights
    tlit = lightTrace(pos,N_ray,lightNbr,0);		// 0 means no transparency requested
    
    if(tlit<T){
        hitObj = lightNbr;
        vec3 trpos = pos + tlit*N_ray; 
        // adding fairy lights
    	color += fairyLight(N_ray, trpos, hitObj);
        
        tlit = lightTrace(pos,N_ray,lightNbr,hitObj);		// hitObj means transparency requested for this obj
        if(tlit<INFINI){									// to make visible the fairy light behind
            trpos = pos + tlit*N_ray;
        	color += fairyLight(N_ray, trpos, lightNbr);
        }
    }
    
    fragColor = vec4(color,1.0);
}

