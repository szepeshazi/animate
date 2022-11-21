#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;
layout(location = 0) uniform float time;
layout(location = 1) uniform vec2 resolution;


void main() {
    const float gridSize = 30.0; // background grid size and ball radius
    const float bounceCount = 6.0; // number of times the ball should touch the ground
    const float canvasMultiplier = 1.2; // virtual canves size (extends visible area to the rigt)
    const float amp = 0.8; // initial bounce amplitude
    const float pi = 3.14159265; // hmm
    const float speed = 100.0; // ball speed

    // Grid
    float gridX = mod(gl_FragCoord.x + time * speed / 3.0, gridSize);
    float gridY = mod(gl_FragCoord.y, gridSize);
    vec2 V = vec2(gridX, gridY);
    float isGridY = step(1.0, V.y);
    float isGridX = step(1.0, V.x);
    float isGrid = min(isGridX, isGridY);
    vec4 grid = vec4(vec3(isGrid), 0.5);
    fragColor = grid;

    // Ball
    float canvasWidth = resolution.x * canvasMultiplier;
    float d = canvasWidth /  bounceCount;
    float ox = mod(time * speed, canvasWidth) ;

    float currentGrid = floor((ox + (d / 2.0)) / d);
    float oy = resolution.y - (gridSize * 0.8 + (abs(cos(ox / d * pi))) * resolution.y * (amp * pow(0.7, currentGrid * 1.2)));
    float mx = 10.0 * pow(ox, 0.65);
    vec2 center = vec2(mx, oy);

    float dist = distance(vec2(gl_FragCoord.x, gl_FragCoord.y), center);
    float r = smoothstep(gridSize, gridSize*.7, dist);
    vec4 ball = vec4(1.0, 1.0 - r, 1.0 - r, 1.0);

    float ballr = step(gridSize, dist);
    vec4 mixed = ballr * (grid) + (1.0 - ballr)* ball;

    fragColor = mixed;
}