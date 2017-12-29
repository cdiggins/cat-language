# Heron Notes

1. I need to generate a shader web-page.
1. I need to generate very basic procedural objects.
1. How to compose those little guys together. 
1. Draw the thing. 

## Shader Inputs

```
uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform int       iFrame;                // shader playback frame
uniform float     iChannelTime[4];       // channel playback time (in seconds)
uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform samplerXX iChannel0..3;          // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)
uniform float     iSampleRate;           // sound sample rate (i.e., 44100)
```

1. The type system will be key. 

// 
// TODO:
// * Add rich set of examples from Scheme (and Cat and Python and JavaScript) using Myna. 
// * Should I have a separate system for this? Or just stick it in? Probably just sticking it in is fine. 
// * Handle circular type references. That is going to be freaking awesome. 
