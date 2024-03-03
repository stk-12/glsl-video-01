varying vec2 vUv;
uniform float uTime;
uniform sampler2D uTexCurrent;
uniform sampler2D uTexNext;
uniform sampler2D uTexDisp;
uniform vec2 uResolution;
uniform vec2 uTexResolution;
uniform float uProgress;

// パラボラ（放物線）の形状を生成
// x：パラボラの入力値（0〜1）
// k：パラボラの形状を制御 大きいほど角度が鋭くなる
float parabola( float x, float k ) {
  return pow( 4. * x * ( 1. - x ), k );
}


void main() {
  vec2 uv = vUv;

  vec2 ratio = vec2(
    min((uResolution.x / uResolution.y) / (uTexResolution.x / uTexResolution.y), 1.0),
    min((uResolution.y / uResolution.x) / (uTexResolution.y / uTexResolution.x), 1.0)
  );

  uv = vec2(
    vUv.x * ratio.x + (1.0 - ratio.x) * 0.5,
    vUv.y * ratio.y + (1.0 - ratio.y) * 0.5
  );

  vec3 texDisp = texture2D(uTexDisp, uv).rgb;
  float disp = texDisp.r;
  disp = disp * parabola(uProgress, 2.8);

  vec2 dispUv = vec2(uv.x, uv.y - disp);
  vec2 dispUv2 = vec2(uv.x, uv.y + disp);

  vec3 tex1 = texture2D(uTexCurrent, dispUv).rgb;
  vec3 tex2 = texture2D(uTexNext, dispUv2).rgb;

  vec3 color = mix(tex1, tex2, uProgress);

  gl_FragColor = vec4(color, 1.0);
}