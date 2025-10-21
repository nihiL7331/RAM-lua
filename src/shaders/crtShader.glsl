// This is a LÖVE 2D compatible fragment shader for a CRT effect.
// It uses 'extern' variables, which are uniforms that you can send
// from your Lua code using the shader:send() function.

// --- Uniforms (Controllable from Lua) ---
extern number curvature;         // How much the screen bends (e.g., 0.05)
extern number scanlineIntensity; // How visible the scanlines are (e.g., 0.2)
extern number scanlineCount;     // How many scanlines are on screen (e.g., 800.0)
extern number vignetteIntensity; // How dark the corners are (e.g., 0.8)

// Applies barrel distortion to texture coordinates to simulate a curved screen.
vec2 curveTexCoords(vec2 uv) {
    // Convert uv to be -1 to 1 centered
    uv = uv * 2.0 - 1.0;

    // Apply barrel distortion
    // This formula pushes coordinates away from the center
    uv = uv + uv * dot(uv, uv) * (curvature);

    // Convert back to 0 to 1 range
    return uv * 0.5 + 0.5;
}

// The main shader function LÖVE 2D calls for each pixel.
vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // 1. Apply screen curvature to the texture coordinates.
    vec2 curvedCoords = curveTexCoords(texture_coords);

    // 2. Sample the texture. If the curved coordinates are off-screen,
    // this will result in a black pixel, creating the rounded border effect.
    vec4 finalColor = vec4(0.0, 0.0, 0.0, 1.0);
    if (curvedCoords.x >= 0.0 && curvedCoords.x <= 1.0 && curvedCoords.y >= 0.0 && curvedCoords.y <= 1.0) {
        finalColor = Texel(texture, curvedCoords);
    }

    // 3. Apply scanlines.
    // We use the original texture_coords so scanlines are straight, not curved.
    float scanline = sin(texture_coords.y * scanlineCount) * scanlineIntensity;
    finalColor.rgb -= scanline * finalColor.rgb;

    // 4. Apply vignette effect.
    // This darkens the corners of the screen.
    float vignette = distance(texture_coords, vec2(0.5, 0.5));
    vignette = pow(vignette, 2.0) * vignetteIntensity;
    finalColor.rgb -= vignette * finalColor.rgb;

    // Apply the vertex color and return the final pixel color
    return finalColor * vcolor;
}