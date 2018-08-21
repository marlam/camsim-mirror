/*
 * Copyright (C) 2012, 2013, 2014, 2015, 2016, 2017, 2018
 * Computer Graphics Group, University of Siegen
 * Written by Martin Lambers <martin.lambers@uni-siegen.de>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#version 450

const float pi = 3.14159265358979323846;

uniform sampler2D phase_texs[4];
uniform float frac_c_modfreq;

smooth in vec2 vtexcoord;

layout(location = 0) out vec3 fpmd;

void main(void)
{
    // The difference between A tap and B tap:
    float D[4];
    for (int i = 0; i < 4; i++) {
        D[i] = texture(phase_texs[i], vtexcoord).r;
    }

    float range;
    if (abs(D[0] - D[2]) <= 0.0 && abs(D[1] - D[3]) <= 0.0) {
        range = 0.0;
    } else {
        /*
        float phase_shift = atan(D[0] - D[2], D[1] - D[3]) - pi / 2.0;
        if (phase_shift < 0.0)
            phase_shift += 2.0 * pi;
        */
        float phase_shift = atan(D[3] - D[1], D[0] - D[2]);
        range = frac_c_modfreq * phase_shift / (4.0 * pi);
    }
    float amplitude = sqrt((D[0] - D[2]) * (D[0] - D[2]) + (D[1] - D[3]) * (D[1] - D[3])) * pi / 2.0;
    float intensity = (D[0] + D[1] + D[2] + D[3]) / 2.0;

    fpmd = vec3(range, amplitude, intensity);
}
