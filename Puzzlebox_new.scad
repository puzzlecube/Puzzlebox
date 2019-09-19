height = 20; //mm
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
top = false;

xmult=2;
ymult=2;

top_text = "PuzzleBox"; // Text to add to the top of the box.
top_textsize = 7; // size param for text
top_font = "Linux Libertine Mono O:stype=Bold"; // Font for the text
text_spacing = .75; // Spacing of text

text_direction="ttb"; // Direction of text

text_rotation=0; //° Rotation of text
text_resolution=80; // Resolution of text, the $fn of the function.
text_posx=0;
text_posy=0; // NOTE: font appears to be offset by -1, adjusted in code.

module inner_joint(size,radius,ext,shift=0,ratio=inward) {
	echo("x",ext);
	translate([size*ratio,shift]) circle(radius+ext,$fn=16);
	translate([-size*ratio,shift]) circle(radius+ext,$fn=16);
}
module outer_joint(size,radius,ext,shift=0,ratio=outward) {
	echo("y",ext);
	translate([shift,size*ratio]) circle(radius+ext,$fn=16);
	translate([shift,-size*ratio]) circle(radius+ext,$fn=16);
}
/*module puzzlepiece2(size,radius,size_ext=0,mx=1,my=1) {
	ext=size_ext+tolerance;
	union() {
		union() {
			square(size-(ext*2),center=true);
			for (i == [1:mx]) {
			shift=(i*(size/(mx+1)))-(size/2);
			inner_joint(size,radius,shift);
			}
		}
		for (i == [1,my]) {
			shift=(i*(size/(my+1)))-(size/2);
			outer_joint(size,radius,shift);
		}
	}
}
*/
module puzzlepiece(size,radius,size_ext=0,mx=1,my=1) {
	function ext(m)=(size_ext*m)+tolerance;
	xsize=(size*mx)-(ext(mx)*2);
	ysize=(size*my)-(ext(my)*2);
	echo(my,ysize);
	color([0.5,0,1]) union() {
		color(1,0,0.5) difference() {
			square([xsize,ysize],center=true);
			for (i = [1:mx]) {
				shift=(i*(size/(mx+1)))-(size/2
				);
				inner_joint(xsize,radius,ext,shift,inward*mx/2);
			}
		}
		ext=size_ext+tolerance; // No clue why but it has to be redefined here.
		for (i = [1:my]) {
			shift=(i*(size/(my+1)))-(size/2);
			outer_joint(ysize,radius,ext,shift,outward*my/2);
		}
	}
}
if (top == false) {
//echo(inward,outward);
difference() {
	linear_extrude(height+thickness) puzzlepiece(piece_size,joint_radius,mx=xmult,my=ymult);
	translate([0,0,thickness*3]) 	linear_extrude(height+(thickness*2)) puzzlepiece(piece_size,joint_radius,thickness,mx=xmult,my=ymult);
}
linear_extrude(height-lid_thickness) difference() {
			puzzlepiece(piece_size,joint_radius,thickness,mx=xmult,my=ymult);
			puzzlepiece(piece_size,joint_radius,thickness+lip_thickness,mx=xmult,my=ymult);
}
} else {
	linear_extrude(lid_thickness) puzzlepiece(piece_size,joint_radius,thickness,mx=xmult,my=ymult);
	//translate([0,0,lid_thickness]) linear_extrude(thickness) puzzlepiece(piece_size,joint_radius);
	translate([text_posx,text_posy-1,lid_thickness]) rotate([0,0,text_rotation]) linear_extrude(text_thickness) text(text=top_text,size=top_textsize,font=top_font,halign="center",valign="center",spacing=text_spacing,direction=text_direction);
}
	