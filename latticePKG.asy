import graph;

/**
 * This package, latticePKG, was developed for UM170. v1.1
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

void poly(path p, bool dispIB, pen interior, pen boundary) {
	int n_interior = 0;
	int n_boundary = 0;
	
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
			if (inside(p, z)) {
				if (interior(windingnumber(p,z), currentpen)) {
    					dot(z, interior);
    					n_interior+=1;
				}
				else {
    					dot(z, boundary);
    					n_boundary+=1;
				}
			}
		}
	}

	if (dispIB) {
		label("$I="+string(n_interior)+"$", (minX,minY-1.35), p=5+blue);
		label("$A="+string((n_boundary/2+n_interior-1))+"$", ((minX+maxX)/2,minY-1.35), p=5+black);
		label("$B="+string(n_boundary)+"$", (maxX,minY-1.35), p=5+red);
	}
}
