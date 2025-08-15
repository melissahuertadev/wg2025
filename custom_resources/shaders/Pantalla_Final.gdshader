shader_type canvas_item;

// Tamaño del círculo
// control deslizante en el editor de Godot entre 0 (círculo invisible) y 1 (círculo que cubre todo).
uniform float radius : hint_range(0.0, 1.0);
// Centro del círculo en coordenadas UV (0 a 1)
// vec2(0.5, 0.5) significa centro exacto de la textura
uniform vec2 center = vec2(0.5, 0.5);
uniform vec2 aspect_ratio = vec2(1.0, 1.0); // ancho / alto

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV; // Coordenadas de textura
	// Ajustar proporción para que la distancia sea circular
	vec2 diff = uv - center;
	diff.x *= aspect_ratio.x / aspect_ratio.y; // compensar ancho/alto
	float dist = length(diff);
	//float dist = distance(uv, center); // Distancia del pixel al centro

	if (dist < radius) {
		// Dentro del círculo → transparente
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	} else {
		// Fuera del círculo → negro opaco
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}