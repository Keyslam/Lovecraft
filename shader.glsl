uniform mat4 ModelMatrix;
uniform mat4 ViewMatrix;
uniform mat4 PerspectiveMatrix;

vec4 position(mat4 transform_projection, vec4 vertex_position) {
    return PerspectiveMatrix * ViewMatrix * ModelMatrix * vertex_position;
}