shader_type canvas_item;

uniform vec4 Color_Filter : source_color;
uniform vec2 Blur_Direction = vec2(1.0, 0.0);
uniform float Blur_Amount = 0.01;
void fragment()
{
    // set color filter
    COLOR = texture(TEXTURE, UV) *Color_Filter;
    for(int i = -7; i <=7; i++) {
		COLOR += texture(TEXTURE, UV + Blur_Direction * float(i)  * Blur_Amount) / 11.0;
    }
}