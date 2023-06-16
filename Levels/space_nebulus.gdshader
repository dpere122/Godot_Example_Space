shader_type canvas_item;

void fragment() {
	// Place fragment code here.
}

void vertex() {
	VERTEX.x += cos(TIME*0.08 + VERTEX.x + VERTEX.y) * 10.0;
	VERTEX.y += sin(TIME*0.08 + VERTEX.x + VERTEX.y) * 10.0;
}
