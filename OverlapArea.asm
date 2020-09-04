# YIDA WANG
# SEP 6, 2019

# This program computes the Intersection over Union of two rectangles
# as a percent:
#                  Area(Intersection of R1 and R2) * 100
#   IoU =    -----------------------------------------------------
#            Area(R1) + Area(R2) - Area(Intersection of R1 and R2)

	.data
	# DO NOT change the following labels (you may change the initial values):
	R1:			.word 64, 51, 205, 410
	R2:			.word 64, 51, 205, 410
	areaR1:		.alloc 1
	areaR2: 	.alloc 1
	len:		.alloc 1
	wid: 		.alloc 1
	uarea: 		.alloc 1
	IoU:		.alloc 1

	# DECLARATION
	# $12: width of R1
	# $11: length of R1
	# $15: area of R1
	# $14: width of R2
	# $13: length of R2
	# $16: area of R2
	# $20: intersection length
	# $21: intersection width
	# uarea: Area(Intersection of R1 and R2)
	# $27: IoU
	# MinL/minL: the right bottom min x value
	# MinW/minW: the right bottom min y value
	# MaxL/maxL: the left top max x value
	# MaxW/maxW: the left top max y value

		.text

		# load data into registers from R1 and R2
		addi	$1, $0, R1 			# $1 holds base address of array R1
		lw		$2, 0($1)			# $2: R1[0]
		lw		$3, 4($1)			# $3: R1[1]
		lw		$4, 8($1)			# $4: R1[2]
		lw		$5, 12($1)			# $5: R1[3]
		addi	$6, $0, R2 			# $6 holds base address of array R2
		lw		$7, 0($6)			# $7: R2[0]
		lw		$8, 4($6)			# $8: R2[1]
		lw		$9, 8($6)			# $9: R2[2]
		lw		$10, 12($6)			# $10: R2[3]	

		# caculate the area of R1 and R2
		subu	$11, $4, $2			# $11: R1[2]-R1[0], length of R1
		subu 	$12, $5, $3			# $12: R1[3]-R1[1], width of R1
		subu	$13, $9, $7			# $13: R2[2]-R2[0], length of R2
		subu 	$14, $10, $8		# $14: R2[3]-R2[1], width of R2
		mult 	$11, $12			# $11 * $12
		mflo	$15					# area of R1, transfer from register LO to $15
		sw 		$15, areaR1($0)		# store result at areaR1
		mult	$13, $14			# $13 * $14
		mflo	$16					# area of R2, transfer from register LO to $16
		sw 		$16, areaR2($0)		# store result at areaR2

		# determine the minimum x value
MinL:	slt		$17, $9, $4			# is R2[2] < R1[2]?
		beq		$17, $0, L1			# if not, branch to L1
		addi	$18, $9, 0			# minL = R2[2]
		j MaxL						# jump to check MaxL
L1:		addi	$18, $4, 0			# minL = R1[2]

		# determine the maximum x value
MaxL:	addi	$17, $0, 0			# reset $17
		slt		$17, $7, $2			# is R2[0] < R1[0]?
		beq		$17, $0, L2			# if not, branch to L2
		addi	$19, $2, 0			# maxL = R1[0]
		j L2i						# jump to check minL < maxL
L2:		addi	$19, $7, 0			# maxL = R2[0]
		
		# check if the two rectangles are not intersect horizontally.
L2i:	addi	$17, $0, 0
		slt 	$17, $18, $19		# is minL < maxL?
		beq		$17, $0, Length 	# if not, branch to Length
		addi	$27, $0, 0			# set IoU = 0
		j End						# jump to end

		# calculate the horizontal difference
Length:	subu 	$20, $18, $19		# $20: MinL - MaxL (x-axis)
		sw		$20, len($0) 		# store result at len

		# determine the minimum y value
MinW:	addi	$17, $0, 0			# reset $17
		slt		$17, $10, $5		# is R2[3] < R1[3]?
		beq		$17, $0, L3			# if not, branch to L3
		addi	$18, $10, 0			# minW = R2[3]
		j MaxW 						# jump to check MaxW
L3:		addi	$18, $5, 0			# minW = R1[3]

		# determine the maximum y value
MaxW:	addi 	$17, $0, 0			# reset $17
		slt		$17, $3, $8			# is R1[1] < R2[1]?
		beq		$17, $0, L4			# if not, branch to L4
		addi	$19, $8, 0			# maxW = R2[1]
		j L4i 						# jump to check minW < maxW
L4:		addi	$19, $3, 0			# maxW = R1[1]
		
		# check if the two rectangles are not intersect vertically.
L4i:	addi	$17, $0, 0			# reset $17
		slt 	$17, $18, $19		# is minW < maxW?
		beq		$17, $0, Width 		# if not, branch to Width
		addi	$27, $0, 0			# set IoU = 0
		j End						# jump to end

		# calculate the vertical difference
Width:	subu	$21, $18, $19		# $21: MinW - MaxW (y-axis)
		sw		$21, wid($0) 		# store result at wid
		
		# calculate the union area
		mult 	$20, $21			# len * wid
		mflo	$22					# uarea store in $22
		sw		$22, uarea($0)		# store result in uarea

		# calculate the IoU
		add 	$23, $15, $16		# areaR1 + areaR2
		subu	$24, $23, $22 		# areaR1 + areaR2 - uarea
		addi	$25, $0, 100		# $25: 100
		mult	$22, $25			# uarea * 100
		mflo	$26					# $26 = uarea * 100
		div 	$26, $24			# (uarea*100)/(areaR1 + areaR2 - uarea)
		mflo	$27					# transfer quotient to $27
		sw		$27, IoU($0)		# store result in IoU
End:	jr $31						# return to OS