/* 
Author: Yida Wang
Last date modified: September 6th, 2019

This program computes the Intersection over Union of two rectangles
as a percent:
                 Area(Intersection of R1 and R2) * 100
  IoU =    -----------------------------------------------------
           Area(R1) + Area(R2) - Area(Intersection of R1 and R2)

The answer will be specified as a percent: a number between 0 and 100.
For example, if the rectangles do not overlap, IoU = 0%.  If they are
at the same location and are the same height and width, IoU = 100%.
If they are the same area 30 and their area of overlap is 10, IoU =
20%.

Input: two bounding boxes, each specified as {Tx, Ty, Bx, By), where
	 (Tx, Ty) is the upper left corner point and
	 (Bx, By) is the lower right corner point.
       These are given in two global arrays R1 and R2.
Output: IoU (an integer, 0 <= IoU < 100).

In images, the origin (0,0) is located at the left uppermost pixel,
x increases to the right and y increases downward.
So in our bounding box representation, it will always be true that:
         Tx < Bx and Ty < By.

Assume images are 640x480 and bounding boxes fit within these bounds and
are always of size at least 1x1.

IoU should be specified as an integer (only the whole part of the division),
i.e., round down to the nearest whole number between 0 and 100 inclusive.
*/

#include <stdio.h>
#include <stdlib.h>

//DO NOT change the following declaration (you may change the initial value).
// Bounding box: {Tx, Ty, Bx, By}
int R1[] = {64, 51, 205, 410};
int R2[] = {64, 51, 205, 410};
int IoU;

int main() {

	// R1[0]: R1's top left x value
	// R1[1]: R1's top left y value
	// R1[2]: R1's bottom right x value
	// R1[3]: R1's bottom right y value
	// R2[0]: R2's top left x value
	// R2[1]: R2's top left y value
	// R2[2]: R2's bottom right x value
	// R2[3]: R2's bottom right y value
	//
	//	(R1[0],R1[1])	
	//  		---------------------
	//			-			  		-
	//			-					-
	//			-					-
	//			-(R2[0],R2[1])  	-
	//			-			---------------------
	//			-			-		-			-
	//		    -			-		-			-	
	//			---------------------			-
	//						-    (R1[2],R1[3])	-
	//						-					-		
	//						-					-
	//						---------------------
	//											(R2[2],R2[3])
	//

    // calculate the areas of R1 and R2 by using their coordinates.
    int area_R1 = (R1[2]-R1[0])*(R1[3]-R1[1]);
    int area_R2 = (R2[2]-R2[0])*(R2[3]-R2[1]);

    // declare variables
    // t1 is the right bottom min x or y value
    // t2 is the left top max x or y value
    // len is the horizontal difference
    // wid is the vertical difference
    // uarea is the union area
    int t1,t2,len,wid,uarea;

    // determining the minimum x value
    if (R1[2]>R2[2]) t1 = R2[2];		// store right bottom min x in t1
        else t1 =R1[2];
    // determining the maximum x value
    if (R1[0]>R2[0]) t2 = R1[0];		// store left top max x in t2
        else t2 =R2[0];

    // if the minimum x is less than the maximum x,
    // that means the two rectangles are not intersect horizontally.
    // so the IoU is 0.
    if (t1 < t2) {
        printf("Intersection over Union: %d%%\n", 0);
        return 0;
    }
    
    len = t1 - t2;						// calculate the horizontal difference.

    // determining the minimum y value
    if (R1[3]>R2[3]) t1 = R2[3];		// reusing t1 to store right bottom min y in t1
        else t1 =R1[3];
    // determining the maximum y value
    if (R2[1]>R1[1]) t2 = R2[1];		// resuing t2 to store left top max y in t2
        else t2 =R1[1];

    // if the minimum y is less than the maximum y,
    // that means the two rectangles are not intersect vertically.
    if (t1 < t2) IoU = 0;
    else{
        wid = t1 - t2;					// else calculate the vertical difference.
        uarea = len*wid;				// union area = horizontal difference * vertical difference.
        // caculate the IoU using given formula.
        IoU = (uarea*100)/(area_R1+area_R2-uarea);
    }

    // print out the result of IoU.
    printf("Intersection over Union: %d%%\n", IoU);
    return 0;
}

