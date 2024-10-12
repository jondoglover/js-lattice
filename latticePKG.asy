import graph;

/**
 * pickDraw is a versatile Asymptote package centered around Pick's theorem.
 Initially developed for Stanford OHS UM170. v1.2
 * @author Jonathan Sakunkoo/Technodoggo 02/05/24
 */

/**
 * draws a grid from x1 to x2, y1 to y2 with specified thickness
 */
void drawGrid(int x1, int x2, int y1, int y2, real thickness) {
	for (int i = x1; i < x2 + 1; i += 1) {
		draw((i, y1)--(i, y2),linewidth(thickness));
	}
	for (int i = y1; i < y2 + 1; i += 1) {
		draw((x1, i)--(x2, i),linewidth(thickness));
	}
}

int iorb(path p, pair z) {
    if (inside(p,z)) {
        if (interior(windingnumber(p,z),currentpen)) {
            return 1;
        }
        else {
            return 2;
        }
    }
    else {
        return 0;
    }
}

void poly(path p, bool dispIB=true, pen interior=blue+5, pen boundary=red+5, path[] holes={(0,1)--(1,0)--(1,1)--cycle}) {
        int[] ns = {0,0,0};

        pen[] pens = {linewidth(0)+black,interior,boundary};
	
        // Initialize min and max values as integers
        int minX = intMax, maxX = intMin, minY = intMax, maxY = intMin;
        
        // Iterate over each point on the path
        for (int i = 0; i < size(p); ++i) {
            pair pt = point(p, i); // Get the i-th point on the path
        
            // Since we are working with lattice points, we can safely cast coordinates to int
            // Update min and max values
            minX = min(minX, (int) pt.x);
            maxX = max(maxX, (int) pt.x);
            minY = min(minY, (int) pt.y);
            maxY = max(maxY, (int) pt.y);
        }

	drawGrid(minX-1, maxX+1, minY-1, maxY+1, 0);
	draw(p,linewidth(1.5));
	for (int x = minX; x <= maxX; ++x) {
		for (int y = minY; y <= maxY; ++y) {
			pair z = (x, y);
                int result = iorb(p, z);
                dot(z, pens[result]);
                ns[result] += 1;
		}
	}

        for (int iterator = 0; iterator < size(holes); iterator += 1) {
            draw(holes[iterator]);
        }

	if (dispIB) {
		label("$I="+string(ns[1])+"$", (minX,minY-1.35), p=pens[1]);
		label("$A="+string((ns[2]/2+ns[1]-1))+"$", ((minX+maxX)/2,minY-1.35), p=5+black);
		label("$B="+string(ns[2])+"$", (maxX,minY-1.35), p=pens[2]);
	}
}

void poly(path p, bool dispIB=true, pen interior=blue+5, pen boundary=red+5, path[] holes={}) {
        int[] ns = {0,0,0};

        pen[] pens = {linewidth(0)+black,interior,boundary};
	
        // Initialize min and max values as integers
        int minX = intMax, maxX = intMin, minY = intMax, maxY = intMin;
        
        // Iterate over each point on the path
        for (int i = 0; i < size(p); ++i) {
            pair pt = point(p, i); // Get the i-th point on the path
        
            // Since we are working with lattice points, we can safely cast coordinates to int
            // Update min and max values
            minX = min(minX, (int) pt.x);
            maxX = max(maxX, (int) pt.x);
            minY = min(minY, (int) pt.y);
            maxY = max(maxY, (int) pt.y);
        }

	drawGrid(minX-1, maxX+1, minY-1, maxY+1, 0);
	draw(p,linewidth(1.5));
	for (int x = minX; x <= maxX; ++x) {
		for (int y = minY; y <= maxY; ++y) {
			pair z = (x, y);
            
                // int result = iorb(p, z);
                // dot(z, pens[result]);
                // ns[result] += 1;

                if (inside(p,z)) {
                    if (interior(windingnumber(p,z),currentpen)) {
                        int state = 0;
                        for (int iterator = 0; iterator < holes.length; iterator += 1) {
                            path hole = holes[iterator];
                            draw(hole,linewidth(1.5));
                            if (inside(hole,z)) {
                                if (interior(windingnumber(hole,z),currentpen)) {
                                    state = 1;
                                }
                                else {
                                    state = 2;
                                }
                            }
                        }
                        if (state == 0) {
                            ns[1] += 1;
                            dot(z, pens[1]);
                        }
                        if (state == 2) {
                            ns[2] += 2;
                            dot(z, pens[2]);
                        }
                    }
                    else {
                        ns[2] += 1;
                        dot(z, pens[2]);
                    }
                }
		}
	}

	if (dispIB) {
		label("$I="+string(ns[1])+"$", (minX,minY-1.35), p=pens[1]);
		label("$A="+string((ns[2]/2+ns[1]-1-holes.length))+"$", ((minX+maxX)/2,minY-1.35), p=5+black);
		label("$B="+string(ns[2])+"$", (maxX,minY-1.35), p=pens[2]);
	}
}
