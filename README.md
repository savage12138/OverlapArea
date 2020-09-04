# OverlapArea
This program computes the Intersection over Union of two rectangles
as a percent:
   
![IoU = \frac {Area(R1 \cap R2) * 100 } {Area(R1) + Area(R2) - Area(R1 \cap R2)}](https://latex.codecogs.com/svg.latex?IoU%20=%20\frac%20{Area(R1%20\cap%20R2)%20*%20100%20}%20{Area(R1)%20+%20Area(R2)%20-%20Area(R1%20\cap%20R2)})
   
The answer will be specified as a percent: a number between 0 and 100.
For example, if the rectangles do not overlap, IoU = 0%.  If they are
at the same location and are the same height and width, IoU = 100%.
If they are the same area 30 and their area of overlap is 10, IoU =
20%.

This is frequently used in computer vision to measure how closely aligned two bounding boxes
are to each other. For example, comparing the location of a detected object of interest with that
of known correct “ground truth” location can be used to evaluate the accuracy of an object
detection algorithm. If the IoU is greater than some threshold, the detected object would be
counted as a true positive. 

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
