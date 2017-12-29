// https://www.shadertoy.com/view/Xtl3zf

// The MIT License
// Copyright © 2017 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// One way to avoid texture tile repetition one using one small texture to cover a huge area.
// Basically, it creates 8 different offsets for the texture and picks two to interpolate
// between.
//
// Unlike previous methods that tile space (https://www.shadertoy.com/view/lt2GDd or
// https://www.shadertoy.com/view/4tsGzf), this one uses a random low frequency texture
// (cache friendly) to pick the actual texture's offset.
//
// Also, this one mipmaps to something (ugly, but that's better than not having mipmaps
// at all like in previous methods)
//
// More info here: http://www.iquilezles.org/www/articles/texturerepetition/texturerepetition.htm

float sum( vec3 v ) { return v.x+v.y+v.z; }

vec3 textureNoTile( in vec2 x, float v )
{
    float k = texture( iChannel1, 0.005*x ).x; // cheap (cache friendly) lookup
    
    vec2 duvdx = dFdx( x );
    vec2 duvdy = dFdx( x );
    
    float l = k*8.0;
    float i = floor( l );
    float f = fract( l );
    
    vec2 offa = sin(vec2(3.0,7.0)*(i+0.0)); // can replace with any other hash
    vec2 offb = sin(vec2(3.0,7.0)*(i+1.0)); // can replace with any other hash

    vec3 cola = textureGrad( iChannel0, x + v*offa, duvdx, duvdy ).xxx;
    vec3 colb = textureGrad( iChannel0, x + v*offb, duvdx, duvdy ).xxx;
    
    return mix( cola, colb, smoothstep(0.2,0.8,f-0.1*sum(cola-colb)) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xx;
	
	float f = smoothstep( 0.4, 0.6, sin(iGlobalTime    ) );
    float s = smoothstep( 0.4, 0.6, sin(iGlobalTime*0.5) );
        
	vec3 col = textureNoTile( (4.0 + 6.0*s)*uv, f );
	
	fragColor = vec4( col, 1.0 );
}