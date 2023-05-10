shader_type canvas_item;

void fragment() {
	// Place fragment code here.
}

void vertex() {
	VERTEX.x += cos(TIME + VERTEX.x + VERTEX.y) * 3.0;
	VERTEX.y += sin(TIME + VERTEX.x + VERTEX.y) * 1.5;
}
