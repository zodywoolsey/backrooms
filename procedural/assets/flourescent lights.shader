shader_type spatial;
render_mode blend_mix,cull_back,diffuse_burley,specular_schlick_ggx
;
uniform vec3 uv1_offset = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform int depth_min_layers = 8;
uniform int depth_max_layers = 16;
uniform vec2 depth_flip = vec2(1.0);
uniform float variation = 0.0;
varying float elapsed_time;
void vertex() {
	elapsed_time = TIME;
	UV = UV*uv1_scale.xy+uv1_offset.xy;
}
float rand(vec2 x) {
    return fract(cos(mod(dot(x, vec2(13.9898, 8.141)), 3.14)) * 43758.5453);
}

vec2 rand2(vec2 x) {
    return fract(cos(mod(vec2(dot(x, vec2(13.9898, 8.141)),
						      dot(x, vec2(3.4562, 17.398))), vec2(3.14))) * 43758.5453);
}

vec3 rand3(vec2 x) {
    return fract(cos(mod(vec3(dot(x, vec2(13.9898, 8.141)),
							  dot(x, vec2(3.4562, 17.398)),
                              dot(x, vec2(13.254, 5.867))), vec3(3.14))) * 43758.5453);
}

float param_rnd(float minimum, float maximum, float seed) {
	return minimum+(maximum-minimum)*rand(vec2(seed));
}

vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

uniform sampler2D texture_1;
const float texture_1_size = 512.0;


uniform sampler2D texture_2;
const float texture_2_size = 512.0;

uniform sampler2D texture_3;
const float texture_3_size = 1024.0;

const float pack_size = 256.0;

vec2 pack_1x32_to_2x16(float s) {
	return vec2(s - mod(s, 1.0/pack_size), mod(s, 1.0/pack_size)*pack_size);
}

float pack_2x16_to_1x32(vec2 s) {
	return s.x + s.y/pack_size;
}

vec4 pack_2x32_to_4x16(vec2 s) {
	return vec4(s.xy - vec2(mod(s.x, 1.0/pack_size), mod(s.y, 1.0/pack_size)) , vec2(mod(s.x, 1.0/pack_size), mod(s.y, 1.0/pack_size))*pack_size);
}

vec2 pack_4x16_to_2x32(vec4 s) {
	return s.rg + s.ba/pack_size;
}

const float p_o2327265_albedo_color_r = 0.000000000;
const float p_o2327265_albedo_color_g = 0.000000000;
const float p_o2327265_albedo_color_b = 0.000000000;
const float p_o2327265_albedo_color_a = 1.000000000;
const float p_o2327265_metallic = 0.000000000;
const float p_o2327265_roughness = 0.200000000;
const float p_o2327265_emission_energy = 1.500000000;
const float p_o2327265_normal = 0.440000000;
const float p_o2327265_ao = 1.000000000;
const float p_o2327265_depth_scale = 0.430000000;
float o2327265_input_depth_tex(vec2 uv, float _seed_variation_) {
vec4 o2327427_0 = textureLod(texture_1, uv, 0.0);

return (dot((o2327427_0).rgb, vec3(1.0))/3.0);
}
const float p_o2327273_amount = 2.000000000;
vec3 o2327278_input_source(vec2 uv, float _seed_variation_) {
vec4 o2327267_0 = textureLod(texture_3, uv, 0.0);

return ((o2327267_0).rgb);
}
float o2327273_input_in(vec2 uv, float _seed_variation_) {
float o2327278_0_1_f = pack_2x16_to_1x32(o2327278_input_source((uv), _seed_variation_).xy);

return o2327278_0_1_f;
}
vec3 nm_o2327273(vec2 uv, float amount, float size, float _seed_variation_) {
	vec3 e = vec3(1.0/size, -1.0/size, 0);
	vec2 rv;
	if (0 == 0) {
		rv = vec2(1.0, -1.0)*o2327273_input_in(uv+e.xy, _seed_variation_);
		rv += vec2(-1.0, 1.0)*o2327273_input_in(uv-e.xy, _seed_variation_);
		rv += vec2(1.0, 1.0)*o2327273_input_in(uv+e.xx, _seed_variation_);
		rv += vec2(-1.0, -1.0)*o2327273_input_in(uv-e.xx, _seed_variation_);
		rv += vec2(2.0, 0.0)*o2327273_input_in(uv+e.xz, _seed_variation_);
		rv += vec2(-2.0, 0.0)*o2327273_input_in(uv-e.xz, _seed_variation_);
		rv += vec2(0.0, 2.0)*o2327273_input_in(uv+e.zx, _seed_variation_);
		rv += vec2(0.0, -2.0)*o2327273_input_in(uv-e.zx, _seed_variation_);
		rv *= size*amount/128.0;
	} else if (0 == 1) {
		rv = vec2(3.0, -3.0)*o2327273_input_in(uv+e.xy, _seed_variation_);
		rv += vec2(-3.0, 3.0)*o2327273_input_in(uv-e.xy, _seed_variation_);
		rv += vec2(3.0, 3.0)*o2327273_input_in(uv+e.xx, _seed_variation_);
		rv += vec2(-3.0, -3.0)*o2327273_input_in(uv-e.xx, _seed_variation_);
		rv += vec2(10.0, 0.0)*o2327273_input_in(uv+e.xz, _seed_variation_);
		rv += vec2(-10.0, 0.0)*o2327273_input_in(uv-e.xz, _seed_variation_);
		rv += vec2(0.0, 10.0)*o2327273_input_in(uv+e.zx, _seed_variation_);
		rv += vec2(0.0, -10.0)*o2327273_input_in(uv-e.zx, _seed_variation_);
		rv *= size*amount/512.0;
	} else if (0 == 2) {
		rv = vec2(2.0, 0.0)*o2327273_input_in(uv+e.xz, _seed_variation_);
		rv += vec2(-2.0, 0.0)*o2327273_input_in(uv-e.xz, _seed_variation_);
		rv += vec2(0.0, 2.0)*o2327273_input_in(uv+e.zx, _seed_variation_);
		rv += vec2(0.0, -2.0)*o2327273_input_in(uv-e.zx, _seed_variation_);
		rv *= size*amount/64.0;
	} else {
		rv = vec2(1.0, 0.0)*o2327273_input_in(uv+e.xz, _seed_variation_);
		rv += vec2(0.0, 1.0)*o2327273_input_in(uv+e.zx, _seed_variation_);
		rv += vec2(-1.0, -1.0)*o2327273_input_in(uv, _seed_variation_);
		rv *= size*amount/20.0;
	}
	return vec3(0.5)+0.5*normalize(vec3(rv, -1.0));
}


void fragment() {
	float _seed_variation_ = variation;
	vec2 uv = fract(UV);
	{

		float depth_scale = 0.2*p_o2327265_depth_scale;

		vec3 view_dir = normalize(normalize(-VERTEX)*mat3(TANGENT*depth_flip.x,-BINORMAL*depth_flip.y,NORMAL));
		float num_layers = mix(float(depth_max_layers),float(depth_min_layers), abs(dot(vec3(0.0, 0.0, 1.0), view_dir)));
		float layer_depth = 1.0 / num_layers;
		float current_layer_depth = 0.0;
		vec2 P = view_dir.xy * depth_scale;
		vec2 delta = P / num_layers / dot(VIEW, NORMAL);
		vec2  ofs = uv;

		float depth = o2327265_input_depth_tex(ofs, _seed_variation_);

		float current_depth = 0.0;
		while(current_depth < depth) {
			ofs -= delta;

			depth = o2327265_input_depth_tex(ofs, _seed_variation_);

			current_depth += layer_depth;
		}
		vec2 prev_ofs = ofs + delta;
		float after_depth  = depth - current_depth;

		float before_depth = o2327265_input_depth_tex(prev_ofs, _seed_variation_) - current_depth + layer_depth;

		float weight = after_depth / (after_depth - before_depth);
		ofs = mix(ofs, prev_ofs, weight);
		uv = ofs;
	}
vec4 o2327667_0 = textureLod(texture_2, uv, 0.0);
vec3 o2327273_0_1_rgb = nm_o2327273((uv), p_o2327273_amount, 1024.000000000, _seed_variation_);

	vec3 albedo_tex = vec3(1.0).rgb;
	albedo_tex = mix(pow((albedo_tex + vec3(0.055)) * (1.0 / (1.0 + 0.055)),vec3(2.4)),albedo_tex * (1.0 / 12.92),lessThan(albedo_tex,vec3(0.04045)));
	ALBEDO = albedo_tex*vec4(p_o2327265_albedo_color_r, p_o2327265_albedo_color_g, p_o2327265_albedo_color_b, p_o2327265_albedo_color_a).rgb;
	METALLIC = 1.0*p_o2327265_metallic;
	ROUGHNESS = 1.0*p_o2327265_roughness;
	NORMALMAP = o2327273_0_1_rgb;
	EMISSION = ((o2327667_0).rgb)*p_o2327265_emission_energy;

}



