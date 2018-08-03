#pragma language glsl3

#ifdef VERTEX
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

vec4 position(mat4 transform_projection, vec4 vertex_position) {
	return projection_matrix * view_matrix * model_matrix * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	vec4 pixel = Texel(tex, texture_coords);
	return color * pixel;
}
#endif
