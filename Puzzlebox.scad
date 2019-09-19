height = 50; //mm
sizeX = 50; //mm Size of piece on x axis
sizeY = 50; //mm Size on y axis

piece_size = 50;//mm Size of the main square [sizeX,sizeY]; //mm,mm Size of puzzle box
joint_radius = 10; //mm Radius of joints

joint_numerator = 6;
joint_denomenator = 10;

joint_diffnumerator = joint_denomenator-joint_numerator;

outward = (joint_numerator/joint_denomenator);
inward = (joint_diffnumerator/joint_denomenator);
thickness=.45; // Do not set this below your default extrusion width or you WILL get bad underextrusion on the straight parts! If they even show up once sliced. Also if you have the walls too thick you will need to have support on the top part. Or might need them anyways. TIP: when printing in clear set it to exactly your extrusion width for best clarity.
lid_thickness=1; //mm Thickness of the lid
lip_thickness=.45; //mm Thickness of the lip near the top of the puzzlebox bottom
text_thickness=1.2; //mm Thickness of the text
tolerance=0.075; //mm Extra gap between parts
top = true;

top_text = "PuzzleBox"; // Text to add to the top of the box.
top_textsize = 7; // size param for text
top_font = "Linux Libertine Mono O:stype=Bold"; // Font for the text
text_spacing = .75; // Spacing of text

text_direction="ttb"; // Direction of text

text_rotation=0; //° Rotation of text
text_resolution=80; // Resolution of text, the $fn of the function.
text_posx=0;
text_posy=0; // NOTE: font appears to be offset by -1, adjusted in code.
module puzzlepiece(size,radius,size_ext=0) {
	ext=size_ext+tolerance;
	union() {
		difference() {
			square(size-(ext*2),center=true);
			translate([size*inward,0]) circle(radius+ext,$fn=16);
			translate([-size*inward,0]) circle(radius+ext,$fn=16);
		}
		translate([0,size*outward]) 	circle(radius-ext,$fn=16);
		translate([0,-size*outward]) 	circle(radius-ext,$fn=16);
	}
}
if (top == false) {
//echo(inward,outward);
difference() {
	linear_extrude(height+thickness) puzzlepiece(piece_size,joint_radius);
	translate([0,0,thickness*3]) 	linear_extrude(height+(thickness*2)) puzzlepiece(piece_size,joint_radius,thickness);
}
linear_extrude(height-lid_thickness) difference() {
			puzzlepiece(piece_size,joint_radius,thickness);
			puzzlepiece(piece_size,joint_radius,thickness+lip_thickness);
}
} else {
	linear_extrude(lid_thickness) puzzlepiece(piece_size,joint_radius,thickness+(tolerance/2));
	//translate([0,0,lid_thickness]) linear_extrude(thickness) puzzlepiece(piece_size,joint_radius);
	translate([text_posx,text_posy-1,lid_thickness]) rotate([0,0,text_rotation]) linear_extrude(text_thickness) text(text=top_text,size=top_textsize,font=top_font,halign="center",valign="center",spacing=text_spacing,direction=text_direction);
}
	