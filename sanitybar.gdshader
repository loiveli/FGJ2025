shader_type canvas_item;

uniform float sanity = 20.0;
varying float relative_x;

void vertex() {
	// Called for every vertex the material is visible on.
	relative_x = UV.x;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float relative_sanity = sanity / 100.0;
	
	if (relative_x >= relative_sanity) {
		COLOR.r = 0.6;
	} else {
		COLOR.r = 1.0;
	}
}
