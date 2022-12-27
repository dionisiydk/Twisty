Class {
	#name : #TwyLayoutSpanTests,
	#superclass : #TestCase,
	#instVars : [
		'layoutSpan',
		'line',
		'spanEnd',
		'spanStart',
		'drawer',
		'rightSpan',
		'rightBorder',
		'leftBorder',
		'leftSpan'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyLayoutSpanTests >> mockNeighbours [

	rightSpan := Mock new.
	leftSpan := Mock new.
	leftSpan stub rightBorder willReturn: leftBorder.
	layoutSpan rightSpan: rightSpan.
	layoutSpan leftSpan: leftSpan
]

{ #category : #running }
TwyLayoutSpanTests >> setUp [
	super setUp.
	
	line := Mock new.
	drawer := Mock new.
	drawer stub height willReturn: 10.
	rightBorder := Mock new.
	rightSpan := TwyLayoutSpan new.
	leftBorder := Mock new.
	leftSpan := TwyLayoutSpan new.
	leftSpan rightBorder: leftBorder.
	
	layoutSpan := TwyLayoutSpan new.
	layoutSpan
		leftSpan: leftSpan;
		rightSpan: rightSpan; 
		line: line;
		drawer: drawer;
		rightBorder: rightBorder.
		
	leftSpan rightSpan: layoutSpan.
	rightSpan leftSpan: layoutSpan
]

{ #category : #tests }
TwyLayoutSpanTests >> testApplyExtentToLine [
	
	[
		layoutSpan extent: #extent.
		[layoutSpan applyExtentToLine ]
			should strictly satisfy: 
		[line increaseExtentBy: #extent].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidEndOfLineWhenItIsFirstAtLine [
	
	leftSpan line: #anotherLine.

	layoutSpan avoidEndOfLine.
	
	layoutSpan line should be: line
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidEndOfLineWhenItIsLastAtLine [
		
	[:belowLine |
		leftSpan line: line.
		rightSpan line: belowLine.
		[layoutSpan avoidEndOfLine]
			should lenient satisfy: 
		[line belowLine willReturn: belowLine.
		belowLine firstSpan: layoutSpan].
	
		layoutSpan line should be: belowLine
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidEndOfLineWhenItIsNotLastAtLine [
	
	leftSpan line: line.
	rightSpan line: line.

	layoutSpan avoidEndOfLine.

	layoutSpan line should be: line
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidEndOfTextLineWhenBorderAtLineEnd [
	
	
	[
		[layoutSpan avoidEndOfTextLine]
			should lenient satisfy: 
		[rightBorder isAtLineEnd willReturn: true.
		rightBorder moveToStartOfNextSpan]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidEndOfTextLineWhenBorderNotAtLineEnd [
	
	
	[
		[layoutSpan avoidEndOfTextLine]
			should lenient satisfy: 
		[rightBorder isAtLineEnd willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidEndOfTextSpanWhenBorderAtLineEnd [
	
	
	[
		[layoutSpan avoidEndOfTextSpan]
			should lenient satisfy: 
		[rightBorder isAtSpanEnd willReturn: true.
		rightBorder isAtLineEnd willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidEndOfTextSpanWhenBorderAtSpanEndAndNotAtLineEnd [
	
	
	[
		[layoutSpan avoidEndOfTextSpan]
			should lenient satisfy: 
		[rightBorder isAtSpanEnd willReturn: true.
		rightBorder isAtLineEnd willReturn: false.
		rightBorder moveToStartOfNextSpan]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidEndOfTextSpanWhenBorderNotAtSpanEnd [
	
	
	[
		[layoutSpan avoidEndOfTextSpan]
			should lenient satisfy: 
		[rightBorder isAtSpanEnd willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidStartOfTextSpanWhenBorderAtLineStart [
	
	
	[
		[layoutSpan avoidStartOfTextSpan]
			should lenient satisfy: 
		[rightBorder isAtSpanStart willReturn: true.
		rightBorder isAtLineStart willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidStartOfTextSpanWhenBorderAtSpanStartAndNotAtLineStart [
	
	
	[
		[layoutSpan avoidStartOfTextSpan]
			should lenient satisfy: 
		[rightBorder isAtSpanStart willReturn: true.
		rightBorder isAtLineStart willReturn: false.
		rightBorder moveToEndOfPreviousSpan]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testAvoidStartOfTextSpanWhenBorderNotAtSpanStart [
	
	
	[
		[layoutSpan avoidStartOfTextSpan]
			should lenient satisfy: 
		[rightBorder isAtSpanStart willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testCleanUpRedundantNeighboursWhenItLayoutEnd [
	
	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
	
	layoutSpan rightSpan: nil.
	
	layoutSpan cleanUpRedundantNeighbours
]

{ #category : #tests }
TwyLayoutSpanTests >> testCleanUpRedundantNeighboursWhenItTextSpansBorder [
	
	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: false.
	
	layoutSpan cleanUpRedundantNeighbours
]

{ #category : #tests }
TwyLayoutSpanTests >> testCleanUpRedundantNeighboursWhenNextRightSpanAtAnotherTextSpan [
	self mockNeighbours.
	[
		(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
		[layoutSpan cleanUpRedundantNeighbours ]
			should strictly satisfy: 
		[(rightSpan isCoversSameTextSpanAs: layoutSpan) willReturn: true.
		rightSpan isEmpty willReturn: true.
		rightSpan delete.
		(rightSpan isCoversSameTextSpanAs: layoutSpan) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testCleanUpRedundantNeighboursWhenNextRightSpanAtSameTextSpanButNotEmpty [
	self mockNeighbours.
	[
		(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
		[layoutSpan cleanUpRedundantNeighbours ]
			should strictly satisfy: 
		[(rightSpan isCoversSameTextSpanAs: layoutSpan) willReturn: true.
		rightSpan isEmpty willReturn: true.
		rightSpan delete.
		(rightSpan isCoversSameTextSpanAs: layoutSpan) willReturn: true.
		rightSpan isEmpty willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testCleanUpRedundantNeighboursWhenNextRightSpanIsLayoutEnd [
	self mockNeighbours.
	[
		(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
		[layoutSpan cleanUpRedundantNeighbours ]
			should strictly satisfy: 
		[(rightSpan isCoversSameTextSpanAs: layoutSpan) willReturn: true.
		rightSpan isEmpty willReturn: true.
		rightSpan delete will: [layoutSpan rightSpan: nil]]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testComputingLayoutPosition [
	| actual |
	[:textCursor :textRegion  |
		layoutSpan offset: 10.
		line stub topLeftPosition willReturn: 20@14.
	
		[actual := layoutSpan computeLayoutPositionOf: textCursor]
			should strictly satisfy: 
		[(leftBorder selectTextUpTo: textCursor) willReturn: textRegion.
		(textRegion itemsDo: (Kind of: BlockClosure))  
			will: [:arg | arg value: #char1. arg value: #char2].
		(drawer widthOf: #char1) willReturn: 10.
		(drawer widthOf: #char2) willReturn: 20].
		
		actual should equal: 60 @ 14.
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testContainsTextCursorWhichAtLeftBound [

	(leftBorder stub isAtSpanBefore: #textCursor) willReturn: false. 
	(leftBorder stub isAtSamePositionWith: #textCursor) willReturn: true.

	(rightBorder stub isAtSpanAfter: #textCursor) willReturn: true.
	
	(layoutSpan contains: #textCursor) should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testContainsTextCursorWhichAtRightBound [

	(leftBorder stub isAtSpanBefore: #textCursor) willReturn: true. 

	(rightBorder stub isAtSpanAfter: #textCursor) willReturn: false.
	(rightBorder stub isAtSamePositionWith: #textCursor) willReturn: true.
	
	(layoutSpan contains: #textCursor) should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testContainsTextCursorWhichBetweenLeftAndRightBounds [

	(leftBorder stub isAtSpanBefore: #textCursor) willReturn: true. 
	(rightBorder stub isAtSpanAfter: #textCursor) willReturn: true.
	
	(layoutSpan contains: #textCursor) should be: true
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testCorrectionSpansRemovedByTextChangeWhenOnlyRightSpanWasRemoved [
	
	self mockNeighbours.	
	[:textChange :rightRightSpan |

		[layoutSpan correctSpansRemovedBy: textChange]
			should lenient satisfy: 
		[rightSpan rightSpan willReturn: rightRightSpan.
		(textChange isRemoveLayoutSpan: rightSpan) willReturn: true.
		rightSpan delete.
		(textChange isRemoveLayoutSpan: rightRightSpan) willReturn: false.
		textChange correctFirstRemovedLayoutSpan: layoutSpan]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testCorrectionSpansRemovedByTextChangeWhenRightSpanWasNotRemoved [
	
	self mockNeighbours.	
	[:textChange |

		[layoutSpan correctSpansRemovedBy: textChange]
			should lenient satisfy: 
		[(textChange isRemoveLayoutSpan: rightSpan) willReturn: false.
		textChange correctFirstRemovedLayoutSpan: layoutSpan]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testCoverWholeTextSpanWhenLeftAndRightBordersAtTheEndOfTextSpan [

	leftBorder stub isAtSpanEnd willReturn: true.
	rightBorder stub isAtSpanEnd willReturn: true.
	
	layoutSpan isCoverWholeTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testDelete [

 	leftSpan line: line.
	
	layoutSpan delete.

	leftSpan rightSpan should be: rightSpan.
	rightSpan leftSpan should be: leftSpan	
]

{ #category : #tests }
TwyLayoutSpanTests >> testDeleteWhenItFirstAndNotSingleAtLine [

	[ :anotherLine |
		leftSpan line: anotherLine.
		rightSpan line: line.
		[ layoutSpan delete ]
			should lenient satisfy: 
		[line firstSpan: rightSpan ].
	
		leftSpan rightSpan should be: rightSpan.
		rightSpan leftSpan should be: leftSpan.
		
	 ] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testDeleteWhenItFirstAndSingleAtLine [

	[ :anotherLine1 |
		leftSpan line: anotherLine1.
		rightSpan line: #anotherLine2.
		[ layoutSpan delete ]
			should lenient satisfy: 
		[line delete].
	
		leftSpan rightSpan should be: rightSpan.
		rightSpan leftSpan should be: leftSpan.
		
	 ] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testDeleteWhenItLayoutEndAndNotSingleAtLine [

	layoutSpan rightSpan: nil.
	leftSpan line: line.

	layoutSpan delete.
	
	leftSpan rightSpan should be: nil
]

{ #category : #tests }
TwyLayoutSpanTests >> testDeleteWhenItLayoutEndAndSingleAtLine [

	[ 
		layoutSpan rightSpan: nil.
		leftSpan line: #anotherSpan.
		[ layoutSpan delete ]
			should lenient satisfy: 
		[line delete].
	
		leftSpan rightSpan should be: nil.
		
	 ] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testDeleteWhenItLayoutStartAndNotSingleAtLine [

	[ 
		layoutSpan leftSpan: nil.
		rightSpan line: line.
		[ layoutSpan delete ]
			should lenient satisfy: 
		[line firstSpan: rightSpan].
	
		rightSpan leftSpan should be: nil.
		
	 ] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testDeleteWhenItLayoutStartAndSingleAtLine [

	[ 
		layoutSpan leftSpan: nil.
		rightSpan line: #anotherSpan.
		[ layoutSpan delete ]
			should lenient satisfy: 
		[line delete].
	
		rightSpan leftSpan should be: nil.
		
	 ] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testDeleteWhenItNotFirstAtLine [

	leftSpan line: line.
	
	layoutSpan delete.

	leftSpan rightSpan should be: rightSpan.
	rightSpan leftSpan should be: leftSpan	
]

{ #category : #tests }
TwyLayoutSpanTests >> testFetchTextCursor [

	leftBorder stub asActiveCursor willReturn: #newTextCursor.
	
	layoutSpan fetchTextCursor should be: #newTextCursor
]

{ #category : #tests }
TwyLayoutSpanTests >> testFetchTextCursorWhenNoLeftBound [

	layoutSpan leftSpan: nil.
	rightBorder stub asActiveCursor willReturn: #newTextCursor.
	
	layoutSpan fetchTextCursor should be: #newTextCursor
]

{ #category : #tests }
TwyLayoutSpanTests >> testFindFirstSpanRemovedByTextChangeWhenItRightSpan [
	
	self mockNeighbours.	
	[:textChange |

		[(layoutSpan findFirstSpanRemovedBy: textChange) should be: rightSpan]
			should lenient satisfy: 
		[(textChange isRemoveLayoutSpan: layoutSpan) willReturn: false.
		(textChange isRemoveLayoutSpan: rightSpan) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testFindFirstSpanRemovedByTextChangeWhenItThisSpan [
	
	
	[:textChange |

		[(layoutSpan findFirstSpanRemovedBy: textChange) should be: layoutSpan]
			should lenient satisfy: 
		[(textChange isRemoveLayoutSpan: layoutSpan) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testFindLiveSpanFromLeft [
	
	| actual |
	actual := layoutSpan findLiveSpanFromLeft.
	
	actual should be: layoutSpan
]

{ #category : #tests }
TwyLayoutSpanTests >> testFindLiveSpanFromLeftWhenCurrentIsDeleted [
	
	| actual |
	leftSpan rightSpan: rightSpan.
	rightSpan leftSpan: leftSpan.

	actual := layoutSpan findLiveSpanFromLeft.
	
	actual should be: leftSpan
]

{ #category : #tests }
TwyLayoutSpanTests >> testFindLiveSpanFromLeftWhenItNoExists [
	
	| actual |
	leftSpan rightSpan: rightSpan.
	rightSpan leftSpan: leftSpan.
	layoutSpan leftSpan: nil.

	actual := layoutSpan findLiveSpanFromLeft.
	
	actual should be: nil
]

{ #category : #tests }
TwyLayoutSpanTests >> testFindLiveSpanFromRight [
	
	| actual |
	actual := layoutSpan findLiveSpanFromRight.
	
	actual should be: layoutSpan
]

{ #category : #tests }
TwyLayoutSpanTests >> testFindLiveSpanFromRightWhenCurrentIsDeleted [
	
	| actual |
	leftSpan rightSpan: rightSpan.
	rightSpan leftSpan: leftSpan.

	actual := layoutSpan findLiveSpanFromRight.
	
	actual should be: rightSpan
]

{ #category : #tests }
TwyLayoutSpanTests >> testFindLiveSpanFromRightWhenItNoExists [
	
	| actual |
	leftSpan rightSpan: rightSpan.
	rightSpan leftSpan: leftSpan.
	layoutSpan rightSpan: nil.

	actual := layoutSpan findLiveSpanFromRight.
	
	actual should be: nil
]

{ #category : #tests }
TwyLayoutSpanTests >> testFixOffsetWhenItIsFirstLineSpan [
	
	self mockNeighbours.
	[ 				
		[layoutSpan fixOffset]
			should lenient satisfy: 
		[leftSpan line willReturn: #anotherLine].
	
		layoutSpan offset should equal: 0
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testFixOffsetWhenItIsNotFirstLineSpan [
	
	self mockNeighbours.
	[
		layoutSpan leftSpan: leftSpan.
				
		[layoutSpan fixOffset]
			should lenient satisfy: 
		[leftSpan line willReturn: line.
		leftSpan rightBorderOffset willReturn: 34].
	
		layoutSpan offset should equal: 34
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testFixingRightBorderWhenItIsLastAtTextSpan [
	
	self mockNeighbours.
	[	
		[layoutSpan fixRightBorder]
			should lenient satisfy: 
		[(rightSpan isCoversSameTextSpanAs: layoutSpan) willReturn: false.
		rightBorder moveToSpanEnd].
	
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testFixingRightBorderWhenItIsNotLastAtTextSpan [
	
	self mockNeighbours.
	[	
		[layoutSpan fixRightBorder]
			should lenient satisfy: 
		[(rightSpan isCoversSameTextSpanAs: layoutSpan) willReturn: true.
		rightBorder isValid willReturn: false.
		rightBorder moveToSpanEnd].
	
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testFixingRightBorderWhenItNotBroken [
	
	self mockNeighbours.
	[	
		[layoutSpan fixRightBorder]
			should lenient satisfy: 
		[(rightSpan isCoversSameTextSpanAs: layoutSpan) willReturn: true.
		rightBorder isValid willReturn: true].
	
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testGettingAboveLine [
	
	line stub aboveLine willReturn: #result.
	
	layoutSpan aboveLine should be: #result
]

{ #category : #tests }
TwyLayoutSpanTests >> testGettingBelowLine [
	
	line stub belowLine willReturn: #result.
		
	layoutSpan belowLine should be: #result
]

{ #category : #tests }
TwyLayoutSpanTests >> testHasZeroExtentByDefault [

	layoutSpan extent should equal: 0@0
]

{ #category : #tests }
TwyLayoutSpanTests >> testHasZeroSpansOffsetByDefault [

	layoutSpan offset should equal: 0
]

{ #category : #tests }
TwyLayoutSpanTests >> testHeight [
	
	layoutSpan extent: 10@20.
	
	layoutSpan height should be: 20
]

{ #category : #tests }
TwyLayoutSpanTests >> testImportNextSpanToLine [
	self mockNeighbours.
	[
		[layoutSpan importNextSpanToLine]
			should strictly satisfy: 
		[rightSpan isTextSpansBorder willReturn: false; useArbitrarily.
		rightSpan migrateTo: line ].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testImportNextSpanToLineWhenItIsTextSpansBorderAndItIsAtTextLineStart [
	self mockNeighbours.
	[
		[layoutSpan importNextSpanToLine]
			should strictly satisfy: 
		[rightSpan isTextSpansBorder willReturn: true; useArbitrarily.
		rightSpan isAtStartOfTextLine willReturn: true ].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testImportNextSpanToLineWhenItIsTextSpansBorderAndItNotAtTextLineStart [
	self mockNeighbours.
	[
		[layoutSpan importNextSpanToLine]
			should strictly satisfy: 
		[rightSpan isTextSpansBorder willReturn: true; useArbitrarily.
		rightSpan isAtStartOfTextLine willReturn: false.
		rightSpan migrateTo: line.
		rightSpan importNextSpanToLine ].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testIncreaseFromLeftByOffset [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
	layoutSpan extent: 40@20.
	layoutSpan offset: 10.
	
	layoutSpan increaseFromLeftBy: 3.
	
	layoutSpan extent should equal: 43@20.
	layoutSpan offset: 7

]

{ #category : #tests }
TwyLayoutSpanTests >> testIncreaseFromLeftByOffsetWhenItFirstSpanAtLine [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
	layoutSpan extent: 40@20.
	layoutSpan offset: 0.
	
	layoutSpan increaseFromLeftBy: 3.
	
	layoutSpan extent should equal: 43@20.
	layoutSpan offset: 0

]

{ #category : #tests }
TwyLayoutSpanTests >> testIncreaseFromLeftByOffsetWhenItIsTextSpansBorder [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: false.
	layoutSpan extent: 0@20.
	layoutSpan offset: 10.
	
	layoutSpan increaseFromLeftBy: 3.
	
	layoutSpan extent should equal: 0@20.
	layoutSpan offset: 7

]

{ #category : #tests }
TwyLayoutSpanTests >> testInitializingWithDrawer [

	[:newDrawer |
		[layoutSpan initializeWithDrawer: newDrawer]
			should strictly satisfy: 
		[newDrawer initialExtent willReturn: #extent].
		layoutSpan drawer should be: newDrawer.		
		layoutSpan extent should equal: #extent
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testInsertLineAtTheEnd [
	
	| actual |
	[:newLine |
		[actual := layoutSpan insertLineAtTheEnd ]
			should strictly satisfy: 
		[line newBelowLine willReturn: newLine.
		newLine importSpansFrom: line startedWith: rightSpan].
		actual should be: newLine
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsAtEndOfTextLineSpanWhenBorderAtEndOfLine [

	rightBorder stub isAtLineEnd willReturn: true.
	
	layoutSpan isAtEndOfTextLine should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsAtEndOfTextSpanWhenBorderAtEndOfSpan [

	rightBorder stub isAtSpanEnd willReturn: true.
	
	layoutSpan isAtEndOfTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsAtSameLineWithAnotherSpan [

	| anotherSpan |
	anotherSpan := TwyLayoutSpan new.
	anotherSpan line: line.

	(layoutSpan isAtSameLineWith: anotherSpan) should be: true.
	
	anotherSpan line: #anotherLine.
	
	(layoutSpan isAtSameLineWith: anotherSpan) should be: false.
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsAtStartOfLayoutLineWhenItIsFirstAtLine [
	self mockNeighbours.
	
	leftSpan stub line willReturn: #anotherLine.
	
	layoutSpan isAtStartOfLine should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsAtStartOfLayoutLineWhenItIsNotFirstAtLineButLeftTextSpansBorderIs [
	self mockNeighbours.
	
	leftSpan stub line willReturn: line.
	leftSpan stub isTextSpansBorder willReturn: true.
	leftSpan stub isFirstAtLine willReturn: true.
	
	layoutSpan isAtStartOfLine should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsAtStartOfTextLineSpanWhenBorderAtStartOfLine [

	rightBorder stub isAtLineStart willReturn: true.
	
	layoutSpan isAtStartOfTextLine should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsAtStartOfTextSpanWhenBorderAtStartOfSpan [

	rightBorder stub isAtSpanStart willReturn: true.
	
	layoutSpan isAtStartOfTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsBetweenTextElementsWhenItTextSpansBorder [
	
	[:leftElement :rightElement | 
		[(layoutSpan isBetweenTextElement: leftElement and: rightElement) should be: true]
			should lenient satisfy: 
		[(rightBorder isAtSameSpanWith: leftBorder) willReturn: false.
		(leftBorder isAfterOrAtEndOfElement: leftElement) willReturn: true.
		(rightBorder isBeforeOrAtStartOfElement: rightElement) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsBetweenTextElementsWhenLeftAndRightBordersBetweenIt [
	
	[:leftElement :rightElement | 
		[(layoutSpan isBetweenTextElement: leftElement and: rightElement) should be: true]
			should lenient satisfy: 
		[(rightBorder isAtSameSpanWith: leftBorder) willReturn: true.
		(leftBorder isAfterElement: leftElement) willReturn: true.
		(rightBorder isBeforeElement: rightElement) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsCoverOnlyTextSpan [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: #result.
	
	layoutSpan isCoverOnlyTextSpan should be: #result
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsCoverOnlyTextSpanWhenLeftBorderAbsent [

	layoutSpan leftSpan: nil.
	(rightBorder stub isAtSameSpanWith: rightBorder) willReturn: true.
	
	layoutSpan isCoverOnlyTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsCoversChangedText [
	
	
	[:textChange |
		[(layoutSpan isCoversTextChangedBy: textChange) should be: #result]
			should lenient satisfy: 
		[(textChange isAffectTextAt: rightBorder) willReturn: #result]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsCoversLineStartWhenItIsTextSpansBorder [
	
	[:textSpan |
		[(layoutSpan isCoversLineStart: #lineStart) should be: true]
			should lenient satisfy: 
		[(rightBorder isAtSameSpanWith: leftBorder) willReturn: false.
		rightBorder span willReturn: textSpan.
		textSpan previous willReturn: #lineStart].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsCoversSameTextSpanAsAnotherSpanWhenTheirBordersAtSameTextSpan [

	[:anotherSpan |
		[(layoutSpan isCoversSameTextSpanAs: anotherSpan) should be: #result]
			should strictly satisfy: 
		[ anotherSpan rightBorder willReturn: #anotherBorder.
		(rightBorder isAtSameSpanWith: #anotherBorder) willReturn: #result ]
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsCoversTextElement [
	
	[:textElement |
		 layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCovers: textElement) should be: #result]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: #result].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsCoversTextSpan [
	
	[
		layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCoversSpan: #textSpan) should be: #result]
			should lenient satisfy: 
		[(rightBorder isAt: #textSpan) willReturn: #result].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsCoversTextSpanAfterPositionWhenRightBorderIsAtItAndAfterGivenPosition [
	
	[:textElement |
		layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCovers: textElement afterPosition: 4) should be: true]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true.
		(rightBorder isAfterPosition: 4 atSpan: textElement) willReturn: true].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsCoversTextSpanAtOrAfterPositionWhenRightBorderIsAtItAndAfterGivenPosition [
	
	[:textElement |
		layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCovers: textElement atOrAfterPosition: 4) should be: true]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true.
		(rightBorder isBeforePosition: 4 atSpan: textElement) willReturn: false].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsCoversTextSpanBeforePositionWhenRightBorderIsAtItAndBeforeGivenPosition [
	
	[:textElement |
		layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCovers: textElement beforePosition: 4) should be: true]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true.
		(rightBorder isBeforePosition: 4 atSpan: textElement) willReturn: true].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsDeletedWhenLeftSpanNotAttachedToIt [
	
	layoutSpan rightSpan: nil.
	
	leftSpan rightSpan: #anotherSpan.
	
	layoutSpan isDeleted should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsDeletedWhenRightSpanNotAttachedToIt [
	
	rightSpan leftSpan: #anotherSpan.
	
	layoutSpan isDeleted should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsEmpty [

	(rightBorder stub isAtSamePositionWith: leftBorder) willReturn: #result.
	
	layoutSpan isEmpty should be: #result
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsEmptyWhenLeftBorderAbsent [

	layoutSpan leftSpan: nil.
	(rightBorder stub isAtSamePositionWith: rightBorder) willReturn: true.
		
	layoutSpan isEmpty should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsFirstAtTextSpanWhenLeftSpanAbset [
	
	layoutSpan leftSpan: nil.
		
	layoutSpan isFirstAtTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsFirstAtTextSpanWhenLeftSpanAtAnotherTextSpan [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: false. 
	
	layoutSpan isFirstAtTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsFirstSpanWhichCoversTextElementWhenSpanCoversItAndLeftSpanIsNot [
	

	self mockNeighbours.	
	[:rightTextSpan :textElement |
		[(layoutSpan isFirstSpanWhichCovers: textElement) should be: true]
			should lenient satisfy: 
		[rightBorder span willReturn: rightTextSpan.
		(rightTextSpan isAfter: textElement) willReturn: false.
		(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true.
		(leftSpan isCovers: textElement) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsFirstSpanWhichCoversTextElementWhenThisSpanCoversItAndLeftSpanIsAbsent [
	

	self mockNeighbours.	
	[:rightTextSpan :textElement |
		layoutSpan leftSpan: nil.
		[(layoutSpan isFirstSpanWhichCovers: textElement) should be: true]
			should lenient satisfy: 
		[rightBorder span willReturn: rightTextSpan.
		(rightTextSpan isAfter: textElement) willReturn: false.
		(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsFirstSpanWhichCoversTextElementWhichIsBeforeThisTextSpanWhenThisIsLayoutStart [
	

	self mockNeighbours.	
	[:leftTextSpan :rightTextSpan |
		layoutSpan leftSpan: nil.
		[(layoutSpan isFirstSpanWhichCovers: #textElement) should be: true]
			should lenient satisfy: 
		[rightBorder span willReturn: rightTextSpan.
		(rightTextSpan isAfter: #textElement) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsFirstSpanWhichCoversTextElementWhichIsBetweenThisAndLeftSpan [
	

	self mockNeighbours.	
	[:leftTextSpan :rightTextSpan |
		[(layoutSpan isFirstSpanWhichCovers: #textElement) should be: true]
			should lenient satisfy: 
		[leftSpan textSpan willReturn: leftTextSpan.
		rightBorder span willReturn: rightTextSpan.
		(rightTextSpan isAfter: #textElement) willReturn: true.
		(leftTextSpan isBefore: #textElement) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsLastAtLine [

	rightSpan line: #anotherLine.

	layoutSpan isLastAtLine should be: true.
	
	rightSpan line: line.

	layoutSpan isLastAtLine should be: false.

]

{ #category : #tests }
TwyLayoutSpanTests >> testIsLastAtLineWhenItLayoutEnd [

	layoutSpan rightSpan: nil.

	layoutSpan isLastAtLine should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsLastAtTextSpanWhenItLayoutEnd [

	layoutSpan rightSpan: nil.
	
	layoutSpan isLastAtTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsLastAtTextSpanWhenRightSpanAtAnotherTextSpan [

	self mockNeighbours.
	
	(rightSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: false. 
	
	layoutSpan isLastAtTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsLastSpanWhichCoversTextSpanWhenItCoversItAndItLayoutEnd [
	
	
	[:textElement |
		layoutSpan rightSpan: nil.
		[(layoutSpan isLastSpanWhichCovers: textElement) should be: true]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsLastSpanWhichCoversTextSpanWhenItCoversItAndRightSpanIsNot [
	
	
	self mockNeighbours.
	[:textElement |
		[(layoutSpan isLastSpanWhichCovers: textElement) should be: true]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true.
		(rightSpan isCovers: textElement) willReturn: false ]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsLayoutEnd [

	layoutSpan rightSpan: nil.
	
	layoutSpan isLayoutEnd should be: true.
	
	layoutSpan rightSpan: leftSpan.
	
	layoutSpan isLayoutEnd should be: false.
	
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsLayoutStart [

	layoutSpan leftSpan: nil.
	
	layoutSpan isLayoutStart should be: true.
	
	layoutSpan leftSpan: leftSpan.
	
	layoutSpan isLayoutStart should be: false.
	
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotAtEndOfTextLineWhenBorderIsNotAtEndOfLine [

	rightBorder stub isAtLineEnd willReturn: false.
	
	layoutSpan isAtEndOfTextLine should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotAtEndOfTextSpanWhenBorderIsNotAtEndOfSpan [

	rightBorder stub isAtSpanEnd willReturn: false.
	
	layoutSpan isAtEndOfTextSpan should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotAtStartOfLayoutLineWhenItIsNotFirstAtLineAndLeftSpanIsNotTextSpansBorder [
	self mockNeighbours.
	
	leftSpan stub line willReturn: line.
	leftSpan stub isTextSpansBorder willReturn: false.
	
	layoutSpan isAtStartOfLine should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotAtStartOfLayoutLineWhenItIsNotFirstAtLineButLeftTextSpansBorderIsNot [
	self mockNeighbours.
	
	leftSpan stub line willReturn: line.
	leftSpan stub isTextSpansBorder willReturn: true.
	leftSpan stub isFirstAtLine willReturn: false.
	
	layoutSpan isAtStartOfLine should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotAtStartOfTextLineWhenBorderIsNotAtStartOfLine [

	rightBorder stub isAtLineStart willReturn: false.
	
	layoutSpan isAtStartOfTextLine should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotBetweenTextElementsWhenLeftBorderBeforeIt [
	
	[:leftElement :rightElement | 
		[(layoutSpan isBetweenTextElement: leftElement and: rightElement) should be: false]
			should lenient satisfy: 
		[(rightBorder isAtSameSpanWith: leftBorder) willReturn: true.
		(leftBorder isAfterElement: leftElement) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotBetweenTextElementsWhenRightBorderAfterIt [
	
	[:leftElement :rightElement | 
		[(layoutSpan isBetweenTextElement: leftElement and: rightElement) should be: false]
			should lenient satisfy: 
		[(rightBorder isAtSameSpanWith: leftBorder) willReturn: true.
		(leftBorder isAfterElement: leftElement) willReturn: true.
		(rightBorder isBeforeElement: rightElement) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotCoversTextSpanAfterPositionWhenRightBorderIsAtItButNotAfterGivenPosition [
	
	[:textElement |
		layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCovers: textElement afterPosition: 4) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true.
		(rightBorder isAfterPosition: 4 atSpan: textElement) willReturn: false].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotCoversTextSpanAfterPositionWhenRightBorderIsNotAtIt [
	
	[:textElement |
		layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCovers: textElement afterPosition: 4) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: false].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotCoversTextSpanAtOrAfterPositionWhenRightBorderIsAtItButBeforeGivenPosition [
	
	[:textElement |
		layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCovers: textElement atOrAfterPosition: 4) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true.
		(rightBorder isBeforePosition: 4 atSpan: textElement) willReturn: true].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotCoversTextSpanAtOrAfterPositionWhenRightBorderIsNotAtIt [
	
	[:textElement |
		layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCovers: textElement atOrAfterPosition: 4) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: false].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotCoversTextSpanBeforePositionWhenRightBorderIsAtItButNotBeforeGivenPosition [
	
	[:textElement |
		layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCovers: textElement beforePosition: 4) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true.
		(rightBorder isBeforePosition: 4 atSpan: textElement) willReturn: false].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotCoversTextSpanBeforePositionWhenRightBorderIsNotAtIt [
	
	[:textElement |
		layoutSpan rightBorder: rightBorder.
				
		[(layoutSpan isCovers: textElement beforePosition: 4) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: false].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotDeletedWhenLeftSpanAttachedToIt [
	
	layoutSpan rightSpan: nil.
	leftSpan rightSpan: layoutSpan.
	
	layoutSpan isDeleted should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotDeletedWhenRightSpanAttachedToIt [
	
	rightSpan leftSpan: layoutSpan.
	layoutSpan isDeleted should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotFirstAtTextSpanWhenLeftSpanAtSameTextSpan [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
	
	layoutSpan isFirstAtTextSpan should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotFirstSpanWhichCoversTextElementWhenSpanCoversItButLeftSpanCoversItToo [
	

	self mockNeighbours.	
	[:rightTextSpan :textElement |
		[(layoutSpan isFirstSpanWhichCovers: textElement) should be: false]
			should lenient satisfy: 
		[rightBorder span willReturn: rightTextSpan.
		(rightTextSpan isAfter: textElement) willReturn: false.
		(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true.
		(leftSpan isCovers: textElement) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotFirstSpanWhichCoversTextElementWhichIsAfterLeftTextSpan [
	

	self mockNeighbours.	
	[:leftTextSpan :rightTextSpan |
		[(layoutSpan isFirstSpanWhichCovers: #textElement) should be: false]
			should lenient satisfy: 
		[leftSpan textSpan willReturn: leftTextSpan.
		rightBorder span willReturn: rightTextSpan.
		(rightTextSpan isAfter: #textElement) willReturn: true.
		(leftTextSpan isBefore: #textElement) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotFirstSpanWhichCoversTextElementWhichIsAfterThisTextSpan [
	

	self mockNeighbours.	
	[:rightTextSpan :textElement |
		[(layoutSpan isFirstSpanWhichCovers: textElement) should be: false]
			should lenient satisfy: 
		[rightBorder span willReturn: rightTextSpan.
		(rightTextSpan isAfter: textElement) willReturn: false.
		(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotLastAtTextSpanWhenRightSpanAtSameTextSpan [

	self mockNeighbours.
	
	(rightSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: true. 
	
	layoutSpan isLastAtTextSpan should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotLastSpanWhichCoversTextSpanWhenItCoversItButRightSpanCoversItToo [
	
	
	self mockNeighbours.
	[:textElement |
		[(layoutSpan isLastSpanWhichCovers: textElement) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: true.
		(rightSpan isCovers: textElement) willReturn: true ]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotLastSpanWhichCoversTextSpanWhenItNotCoversIt [
	
	
	self mockNeighbours.
	[:textElement |
		[(layoutSpan isLastSpanWhichCovers: textElement) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutSpan: layoutSpan) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotOnlySpanRemovedByTextChangeWhenLeftSpanWasRemovedToo [
	
	
	[:textChange |
		[(layoutSpan isOnlySpanRemovedBy: textChange) should be: false]
			should lenient satisfy: 
		[(textChange isRemoveLayoutSpan: layoutSpan) willReturn: true.
		(textChange isRemoveLayoutSpan: rightSpan) willReturn: false.
		(textChange isRemoveLayoutSpan: leftSpan) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotOnlySpanRemovedByTextChangeWhenRightSpanWasRemovedToo [
	
	
	[:textChange |
		[(layoutSpan isOnlySpanRemovedBy: textChange) should be: false]
			should lenient satisfy: 
		[(textChange isRemoveLayoutSpan: layoutSpan) willReturn: true.
		(textChange isRemoveLayoutSpan: rightSpan) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotOnlySpanRemovedByTextChangeWhichWasNotRemoveIt [
	
	
	[:textChange |
	
		[(layoutSpan isOnlySpanRemovedBy: textChange) should be: false]
			should lenient satisfy: 
		[(textChange isRemoveLayoutSpan: layoutSpan) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotSingleAtLineWhenLeftSpanAtSameLine [

	leftSpan line: line.
	rightSpan line: #anotherLine2.
	
	layoutSpan isSingleAtLine should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotSingleAtLineWhenRightSpanAtSameLine [

	leftSpan line: #anotherLine.
	rightSpan line: line.
	
	layoutSpan isSingleAtLine should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotSingleAtTextSpanWhenItLayoutEndAndRightSpanCoverSameTextSpan [

	self mockNeighbours.

	layoutSpan rightSpan: nil.	
	(leftSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: true.

	layoutSpan isSingleAtTextSpan should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotSingleAtTextSpanWhenLeftCoversSameTextSpan [

	self mockNeighbours.
	
	(leftSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: true.
	(rightSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: false.

	layoutSpan isSingleAtTextSpan should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotSingleAtTextSpanWhenRightCoversSameTextSpan [

	self mockNeighbours.
	
	(leftSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: false.
	(rightSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: true.

	layoutSpan isSingleAtTextSpan should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotTextSpansBorderWhenLeftAndRightSpansAtSameTextSpan [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
	
	layoutSpan isTextSpansBorder should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotValidTextSpansBorderWhenItIsNotTextSpansBorder [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
	
	layoutSpan isValidTextSpansBorder should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotValidTextSpansBorderWhenLeftBorderIsNotAtSpanEnd [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: false.
	rightBorder stub isAtSpanStart willReturn: true.
	leftBorder stub isAtSpanEnd willReturn: false.	
	
	layoutSpan isValidTextSpansBorder should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsNotValidTextSpansBorderWhenRightBorderIsNotAtSpanStart [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: false.
	rightBorder stub isAtSpanStart willReturn: false.
	leftBorder stub isAtSpanEnd willReturn: true.	
	
	layoutSpan isValidTextSpansBorder should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsOnlySpanRemovedByTextChangeWhenItLayoutEndAndLeftSpanWasNotRemoved [
	
	
	[:textChange |
		layoutSpan rightSpan: nil.
		[(layoutSpan isOnlySpanRemovedBy: textChange) should be: true]
			should lenient satisfy: 
		[(textChange isRemoveLayoutSpan: layoutSpan) willReturn: true.
		(textChange isRemoveLayoutSpan: leftSpan) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsOnlySpanRemovedByTextChangeWhenItLayoutStartAndRightSpanWasNotRemoved [
	
	
	[:textChange |
		layoutSpan leftSpan: nil.
		[(layoutSpan isOnlySpanRemovedBy: textChange) should be: true]
			should lenient satisfy: 
		[(textChange isRemoveLayoutSpan: layoutSpan) willReturn: true.
		(textChange isRemoveLayoutSpan: rightSpan) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsOnlySpanRemovedByTextChangeWhenRightAndLeftSpansWasNotRemoved [
	
	
	[:textChange |
		[(layoutSpan isOnlySpanRemovedBy: textChange) should be: true]
			should lenient satisfy: 
		[(textChange isRemoveLayoutSpan: layoutSpan) willReturn: true.
		(textChange isRemoveLayoutSpan: rightSpan) willReturn: false.
		(textChange isRemoveLayoutSpan: leftSpan) willReturn: false]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsPlacedAfterAnotherSpan [

	| anotherSpan |
	
	anotherSpan := TwyLayoutSpan new.
	anotherSpan rightBorder: #anotherSpanRightBorder.
	
	(leftBorder stub isAfter: #anotherSpanRightBorder) willReturn: #result.
	
	(layoutSpan isPlacedAfter: anotherSpan) should be: #result
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsPlacedBeforeTextChange [
	
	
	[:textChange |
		[layoutSpan isPlacedBeforeTextChange: textChange]
			should lenient satisfy: 
		[textChange isAfter: rightBorder]
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsSingleAtLineWhenBothNeighboursAtDifferentLines [

	leftSpan line: #anotherLine1.
	rightSpan line: #anotherLine2.
	
	layoutSpan isSingleAtLine should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsSingleAtLineWhenItLayoutEndAndLeftSpanAtDifferentLine [

	leftSpan line: #anotherLine.
	layoutSpan rightSpan: nil.
	
	layoutSpan isSingleAtLine should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsSingleAtLineWhenItLayoutStartAndRightSpanAtDifferentLine [

	rightSpan line: #anotherLine2.
	layoutSpan leftSpan: nil.
	
	layoutSpan isSingleAtLine should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsSingleAtTextSpanWhenBothNeighboursCoverDifferentTextSpans [

	self mockNeighbours.
	
	(leftSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: false.
	(rightSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: false.

	layoutSpan isSingleAtTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsSingleAtTextSpanWhenItLayoutEndAndRightSpanCoverDifferentTextSpan [

	self mockNeighbours.

	layoutSpan rightSpan: nil.	
	(leftSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: false.

	layoutSpan isSingleAtTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsSingleAtTextSpanWhenItLayoutStartAndRightSpanCoverDifferentTextSpan [

	self mockNeighbours.

	layoutSpan leftSpan: nil.	
	(rightSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: false.

	layoutSpan isSingleAtTextSpan should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsSingleAtTextSpanWhenItLayoutStartAndRightSpanCoversSameTextSpan [

	self mockNeighbours.

	layoutSpan leftSpan: nil.	
	(rightSpan stub isCoversSameTextSpanAs: layoutSpan) willReturn: true.

	layoutSpan isSingleAtTextSpan should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsTextSpansBorderWhenItFirstLayoutSpan [

	layoutSpan leftSpan: nil.
		
	layoutSpan isTextSpansBorder should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsTextSpansBorderWhenLeftAndRightSpansAtDifferentTextSpans [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: false.
	
	layoutSpan isTextSpansBorder should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testIsValidTextSpansBorderWhenLeftBorderIsAtSpanEndAndRightBorderIsAtSpanStart [

	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: false.
	rightBorder stub isAtSpanStart willReturn: true.
	leftBorder stub isAtSpanEnd willReturn: true.	
	
	layoutSpan isValidTextSpansBorder should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testMigrateToAnotherLine [
	
	[:anotherLine |
		layoutSpan offset: 30.

		[layoutSpan migrateTo: anotherLine]
			should strictly satisfy: 
		[anotherLine extent willReturn: 10@30.
		line removeSpan: layoutSpan].
		
		layoutSpan offset should equal: 10.
		layoutSpan line should be: anotherLine
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testMigrateToAnotherLineWhenItIsAlreadyHere [
	
	layoutSpan migrateTo: line.
	
	layoutSpan line should be: line
]

{ #category : #tests }
TwyLayoutSpanTests >> testMigrateToNewLine [
	self mockNeighbours.
	
	[:newLine |
		[layoutSpan migrateToNewLine should be: newLine]
			should strictly satisfy: 
		[leftSpan insertLineAtTheEnd willReturn: newLine.
		leftSpan isTextSpansBorder willReturn: false].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testMigrateToNewLineWhenLeftSpanIsTextSpansBorder [
	self mockNeighbours.
	
	[:newLine |
		[layoutSpan migrateToNewLine should be: newLine]
			should strictly satisfy: 
		[leftSpan insertLineAtTheEnd willReturn: newLine.
		leftSpan isTextSpansBorder willReturn: true.
		leftSpan migrateTo: newLine.
		newLine firstSpan: leftSpan ].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveBorderToEndOfTextSpan [

	[ :textSpan |
		[ layoutSpan moveBorderToEndOf: textSpan ]
			should strictly satisfy: 
		[ rightBorder moveToEndOf: textSpan]
	 ] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveBorderToStartOfTextSpan [

	[ :textSpan |
		[ layoutSpan moveBorderToStartOf: textSpan ]
			should strictly satisfy: 
		[ rightBorder moveToStartOf: textSpan]
	 ] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveLayoutCursorLeftToTextCursorWhenItAlreadyHere [
	
	[:layoutCursor :textCursor |
		[layoutSpan moveLayoutCursor: layoutCursor leftToSpanWith: textCursor]
			should strictly satisfy: 
		[(textCursor isInsideLayoutSpan: layoutSpan) willReturn: true. 
		layoutCursor movedToSpan: layoutSpan].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveLayoutCursorLeftToTextCursorWhenItAndAllRightSpansDeleted [
	
	self mockNeighbours.
	[:layoutCursor :textCursor |
		[layoutSpan moveLayoutCursor: layoutCursor leftToSpanWith: textCursor]
			should strictly satisfy: 
		[rightSpan leftSpan willReturn: #anotherSpan; useArbitrarily.
		rightSpan isDeleted willReturn: true.
		rightSpan rightSpan willReturn: nil.
		leftSpan moveLayoutCursor: layoutCursor leftToSpanWith: textCursor].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveLayoutCursorLeftToTextCursorWhenItAtNextSpan [
	
	[:layoutCursor :textCursor |
		[layoutSpan moveLayoutCursor: layoutCursor leftToSpanWith: textCursor]
			should strictly satisfy: 
		[(textCursor isInsideLayoutSpan: layoutSpan) willReturn: false.
		(textCursor isInsideLayoutSpan: leftSpan) willReturn: true.
		 layoutCursor movedToSpan: leftSpan].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveLayoutCursorLeftToTextCursorWhenItDeleted [
	
	self mockNeighbours.
	[:layoutCursor :textCursor |
		[layoutSpan moveLayoutCursor: layoutCursor leftToSpanWith: textCursor]
			should strictly satisfy: 
		[rightSpan leftSpan willReturn: #anotherSpan; useArbitrarily.
		rightSpan isDeleted willReturn: false.
		rightSpan moveLayoutCursor: layoutCursor leftToSpanWith: textCursor].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveLayoutCursorLeftToTextCursorWhenItsNotFoundAtLeftSide [
	
	| errorBlock |
	self mockNeighbours.
	[:layoutCursor :textCursor |
		[layoutSpan moveLayoutCursor: layoutCursor leftToSpanWith: textCursor]
			should strictly satisfy: 
		[rightSpan leftSpan willReturn: layoutSpan; useArbitrarily.
		(textCursor isInsideLayoutSpan: layoutSpan) willReturn: false.
		(textCursor isInsideLayoutSpan: leftSpan) willReturn: false.
		leftSpan leftSpan willReturn: nil.
		rightSpan moveLayoutCursor: layoutCursor rightToSpanWith: textCursor ifNotFound: [:arg | errorBlock := arg. true]].
	
		errorBlock should beKindOf: BlockClosure.
		errorBlock should fail
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveLayoutCursorRightToTextCursorWhenItAlreadyHere [
	
	[:layoutCursor :textCursor |
		[layoutSpan moveLayoutCursor: layoutCursor rightToSpanWith: textCursor]
			should strictly satisfy: 
		[(textCursor isInsideLayoutSpan: layoutSpan) willReturn: true.
		layoutCursor movedToSpan: layoutSpan].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveLayoutCursorRightToTextCursorWhenItAndAllLeftSpansDeleted [
	
	self mockNeighbours.
	[:layoutCursor :textCursor |
		[layoutSpan moveLayoutCursor: layoutCursor rightToSpanWith: textCursor]
			should strictly satisfy: 
		[rightSpan leftSpan willReturn: #anotherSpan; useArbitrarily.
		leftSpan isDeleted willReturn: true.
		leftSpan leftSpan willReturn: nil.
		rightSpan moveLayoutCursor: layoutCursor rightToSpanWith: textCursor].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveLayoutCursorRightToTextCursorWhenItAtNextSpan [
	
	[:layoutCursor :textCursor  |
		[layoutSpan moveLayoutCursor: layoutCursor rightToSpanWith: textCursor]
			should strictly satisfy: 
		[(textCursor isInsideLayoutSpan: layoutSpan) willReturn: false.
		(textCursor isInsideLayoutSpan: rightSpan) willReturn: true.
		layoutCursor movedToSpan: rightSpan].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveLayoutCursorRightToTextCursorWhenItDeleted [
	
	self mockNeighbours.
	[:layoutCursor :textCursor |
		[layoutSpan moveLayoutCursor: layoutCursor rightToSpanWith: textCursor]
			should strictly satisfy: 
		[rightSpan leftSpan willReturn: #anotherSpan; useArbitrarily.
		leftSpan isDeleted willReturn: false.
		leftSpan moveLayoutCursor: layoutCursor rightToSpanWith: textCursor].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveLayoutCursorRightToTextCursorWhenItsNotFoundAtRightSide [
	
	| errorBlock |
	self mockNeighbours.
	[:layoutCursor :textCursor |
		[layoutSpan moveLayoutCursor: layoutCursor rightToSpanWith: textCursor]
			should strictly satisfy: 
		[rightSpan leftSpan willReturn: layoutSpan.
		(textCursor isInsideLayoutSpan: layoutSpan) willReturn: false.
		(textCursor isInsideLayoutSpan: rightSpan) willReturn: false.
		rightSpan rightSpan willReturn: nil.
		leftSpan moveLayoutCursor: layoutCursor leftToSpanWith: textCursor ifNotFound: [:arg | errorBlock := arg. true]].
	
		errorBlock should beKindOf: BlockClosure.
		errorBlock should fail
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveTextCursorAtOffsetWhenItBecomeAtTheRightBorder [

	[:textCursor |
		layoutSpan offset: 10.
		layoutSpan extent: 100 @ 20.
		line stub topLeftPosition willReturn: 20@30.
	
		[layoutSpan moveTextCursor: textCursor insideAtOffset: 33]
			should strictly satisfy: 
		[textCursor moveTo: leftBorder.
		(textCursor isAtSamePositionWith: rightBorder) willReturn: false.
		textCursor nextItemAtSpan willReturn: #char1.
		(drawer widthOf: #char1) willReturn: 2.
		textCursor moveForward.
		(textCursor isAtSamePositionWith: rightBorder) willReturn: true].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveTextCursorAtOffsetWhenLineOffsetExists [

	[:textCursor |
		layoutSpan offset: 10.
		layoutSpan extent: 100 @ 20.
		line stub topLeftPosition willReturn: 20@30.
	
		[layoutSpan moveTextCursor: textCursor insideAtOffset: 33]
			should strictly satisfy: 
		[textCursor moveTo: leftBorder.
		(textCursor isAtSamePositionWith: rightBorder) willReturn: false; useArbitrarily.
		textCursor nextItemAtSpan willReturn: #char1.
		(drawer widthOf: #char1) willReturn: 2.
		textCursor moveForward.
		textCursor nextItemAtSpan willReturn: #char2.
		(drawer widthOf: #char2) willReturn: 3.
		textCursor moveForward.
		textCursor moveBackward].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveTextCursorAtOffsetWhichOutsideOfLeftBound [

	layoutSpan offset: 10.
	layoutSpan extent: 2 @ 3.
	line stub topLeftPosition willReturn: 20@30.
	
	[:textCursor |
		[layoutSpan moveTextCursor: textCursor insideAtOffset: 29]
			should strictly satisfy: 
		[ textCursor moveTo: leftBorder ]
	] runWithMocks
		
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveTextCursorAtOffsetWhichOutsideOfRightBound [

	layoutSpan offset: 10.
	layoutSpan extent: 2 @ 3.
	line stub topLeftPosition willReturn: 20@30.
	
	[:textCursor |
		[layoutSpan moveTextCursor: textCursor insideAtOffset: 33]
			should strictly satisfy: 
		[ textCursor moveTo: rightBorder ]
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveTextCursorAtOffsetWhichStandAtLeftPartOfChar [
	
	[:textCursor |
		layoutSpan offset: 10.
		layoutSpan extent: 100 @ 20.
		line stub topLeftPosition willReturn: 0@0.
	
		[layoutSpan moveTextCursor: textCursor insideAtOffset: 13]
			should strictly satisfy: 
		[textCursor moveTo: leftBorder.
		(textCursor isAtSamePositionWith: rightBorder) willReturn: false; useArbitrarily.
		textCursor nextItemAtSpan willReturn: #char1.
		(drawer widthOf: #char1) willReturn: 2.
		textCursor moveForward.
		textCursor nextItemAtSpan willReturn: #char2.
		(drawer widthOf: #char2) willReturn: 3.
		textCursor moveForward.
		textCursor moveBackward].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testMoveTextCursorAtOffsetWhichStandAtRightPartOfChar [
	
	[:textCursor |
		layoutSpan offset: 10.
		layoutSpan extent: 100 @ 20.
		line stub topLeftPosition willReturn: 0@0.
	
		[layoutSpan moveTextCursor: textCursor insideAtOffset: 14]
			should strictly satisfy: 
		[textCursor moveTo: leftBorder.
		(textCursor isAtSamePositionWith: rightBorder) willReturn: false; useArbitrarily.
		textCursor nextItemAtSpan willReturn: #char1.
		(drawer widthOf: #char1) willReturn: 2.
		textCursor moveForward.
		textCursor nextItemAtSpan willReturn: #char2.
		(drawer widthOf: #char2) willReturn: 3.
		textCursor moveForward].
		
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testNewRightSpanShouldBeInsertedFromTheRight [
	| actual |
	[ :newCursor | 
	[ actual := layoutSpan newRightSpan ] should strictly
		satisfy: [ rightBorder copy willReturn: newCursor ].
	actual should beInstanceOf: TwyLayoutSpan.
	actual rightSpan should be: rightSpan.
	actual leftSpan should be: layoutSpan.
	layoutSpan rightSpan should be: actual.
	rightSpan leftSpan should be: actual ] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testNewRightSpanShouldHasInitialExtent [
	
	| actual |
	[:newCursor |
		
		layoutSpan extent: 2@10.
		[actual := layoutSpan newRightSpan ]
			should strictly satisfy: 
		[rightBorder copy willReturn: newCursor].
		actual extent should equal: 0@10.
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testNewRightSpanShouldHasSameDrawer [
	
	| actual |
	[:newCursor |
		
		[actual := layoutSpan newRightSpan ]
			should strictly satisfy: 
		[rightBorder copy willReturn: newCursor].
		actual drawer should be: drawer.
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testNewRightSpanShouldHasSeparatedCursor [
	
	| actual |
	[:newCursor |
		
		[actual := layoutSpan newRightSpan ]
			should strictly satisfy: 
		[rightBorder copy willReturn: newCursor].
		actual rightBorder should be: newCursor
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testNewRightSpanShouldHaveAccumulatedOffset [
	
	| actual |
	[:newCursor |
		layoutSpan extent: 2@10.
		layoutSpan offset: 30.
		[actual := layoutSpan newRightSpan ]
			should strictly satisfy: 
		[rightBorder copy willReturn: newCursor].
		actual offset should equal: 32.
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testNewRightSpanShoulsHasSameLine [
	
	| actual |
	[:newCursor |
		
		[actual := layoutSpan newRightSpan ]
			should strictly satisfy: 
		[rightBorder copy willReturn: newCursor].
		actual line should be: line
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testNotAtStartOfTextSpanWhenBorderIsNotAtStartOfSpan [

	rightBorder stub isAtSpanStart willReturn: false.
	
	layoutSpan isAtStartOfTextSpan should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testNotContainsTextCursorWhichAfterRightBound [

	(leftBorder stub isAtSpanBefore: #textCursor) willReturn: true. 
	(rightBorder stub isAtSpanAfter: #textCursor) willReturn: false.
	(rightBorder stub isAtSamePositionWith: #textCursor) willReturn: false.
	
	(layoutSpan contains: #textCursor) should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testNotContainsTextCursorWhichBeforeLeftBound [

	(leftBorder stub isAtSpanBefore: #textCursor) willReturn: false. 
	(leftBorder stub isAtSamePositionWith: #textCursor) willReturn: false.

	(rightBorder stub isAtSpanAfter: #textCursor) willReturn: true.
	
	(layoutSpan contains: #textCursor) should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testNotCoverWholeTextSpanWhenLeftBorderAtEndOfTextSpanButRightIsNot [

	leftBorder stub isAtSpanEnd willReturn: true.
	rightBorder stub isAtSpanEnd willReturn: false.
	
	layoutSpan isCoverWholeTextSpan should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testNotCoverWholeTextSpanWhenRightBorderAtEndOfTextSpanButLeftIsNot [

	leftBorder stub isAtSpanEnd willReturn: false.
	rightBorder stub isAtSpanEnd willReturn: true.
	
	layoutSpan isCoverWholeTextSpan should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testNotCoversLineStartWhenItIsNotTextSpansBorder [
	
	[
		[(layoutSpan isCoversLineStart: #lineStart) should be: false]
			should lenient satisfy: 
		[(rightBorder isAtSameSpanWith: leftBorder) willReturn: true].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testNotCoversWrongLineStart [
	
	[:textSpan |
		[(layoutSpan isCoversLineStart: #lineStart) should be: false]
			should lenient satisfy: 
		[(rightBorder isAtSameSpanWith: leftBorder) willReturn: false.
		rightBorder span willReturn: textSpan.
		textSpan previous willReturn: #anotherLineStart].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testNotOverlaidLineAtXPositionWhenItLeftOfSpanBounds [

	| actual |
	layoutSpan offset: 12.
	layoutSpan extent: 40@20.
	
	actual := layoutSpan isOverlaidLineAtX: 11.

	actual should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testNotOverlaidLineAtXPositionWhenItRightOfSpanBounds [

	| actual |
	layoutSpan offset: 12.
	layoutSpan extent: 40@20.
	
	actual := layoutSpan isOverlaidLineAtX: 53.

	actual should be: false
]

{ #category : #tests }
TwyLayoutSpanTests >> testOverlaidLineAtXPositionWhenItInsideSpanBounds [

	| actual |
	layoutSpan offset: 12.
	layoutSpan extent: 40@20.
	
	actual := layoutSpan isOverlaidLineAtX: 13.

	actual should be: true
]

{ #category : #tests }
TwyLayoutSpanTests >> testPutNextItem [

	self mockNeighbours.	
	[
		layoutSpan extent: 40@20.
		[layoutSpan putNextItem]
			should strictly satisfy: 
		[rightBorder nextItemAtSpan willReturn: #spanItem.
		(drawer widthOf: #spanItem) willReturn: 10.
		rightBorder moveForward.
		rightSpan reduceFromLeftBy: 10].
	
		layoutSpan extent should equal: 50@20
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testPutNextItemWhenNoRightSpan [

	self mockNeighbours.	
	[
		layoutSpan extent: 40@20.
		layoutSpan rightSpan: nil.
		[layoutSpan putNextItem]
			should strictly satisfy: 
		[rightBorder nextItemAtSpan willReturn: #spanItem.
		(drawer widthOf: #spanItem) willReturn: 10.
		rightBorder moveForward].
	
		layoutSpan extent should equal: 50@20
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testRecomputingExtent [
	
	[:iteratorCursor |
	
		layoutSpan extent: 10@40.
		[layoutSpan recomputeExtent]
			should lenient satisfy: 
		[(rightBorder isAtSameSpanWith: leftBorder) willReturn: true.
		leftBorder copy willReturn: iteratorCursor.
		(iteratorCursor isAtSamePositionWith: rightBorder) willReturn: false.
		iteratorCursor nextItemAtSpan willReturn: #item1.
		(drawer widthOf: #item1) willReturn: 2.
		iteratorCursor moveForward.
		(iteratorCursor isAtSamePositionWith: rightBorder) willReturn: false.
		iteratorCursor nextItemAtSpan willReturn: #item2.
		(drawer widthOf: #item2) willReturn: 3.
		iteratorCursor moveForward.
		(iteratorCursor isAtSamePositionWith: rightBorder) willReturn: true].
		
		layoutSpan extent should equal: 5 @ 40
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testRecomputingExtentOfTextSpansBorder [
	
	[:iteratorCursor |
	
		layoutSpan extent: 10@40.
		[layoutSpan recomputeExtent]
			should lenient satisfy: 
		[(rightBorder isAtSameSpanWith: leftBorder) willReturn: false].
		
		layoutSpan extent should equal: 0 @ 40
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testReduceFromLeftByOffset [

	layoutSpan extent: 40@20.
	layoutSpan offset: 10.
	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
	
	layoutSpan reduceFromLeftBy: 3.
	
	layoutSpan extent should equal: 37@20.
	layoutSpan offset: 13

]

{ #category : #tests }
TwyLayoutSpanTests >> testReduceFromLeftByOffsetWhenItTextSpansBorder [

	layoutSpan extent: 40@20.
	layoutSpan offset: 10.	
	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: false.
	
	layoutSpan reduceFromLeftBy: 3.
	
	layoutSpan extent should equal: 40@20.
	layoutSpan offset: 13

]

{ #category : #tests }
TwyLayoutSpanTests >> testReduceFromRightByOffset [

	layoutSpan extent: 40@50.
	layoutSpan offset: 20.
	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: true.
	
	layoutSpan reduceFromRightBy: 10.	
	
	layoutSpan extent should equal: 30@50.
	layoutSpan offset should equal: 20.
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testReduceFromRightByOffsetWhenItTextSpansBorder [

	layoutSpan extent: 40@50.
	layoutSpan offset: 20.
	(rightBorder stub isAtSameSpanWith: leftBorder) willReturn: false.
	
	layoutSpan reduceFromRightBy: 10.	
	
	layoutSpan extent should equal: 40@50.
	layoutSpan offset should equal: 20.
	
]

{ #category : #tests }
TwyLayoutSpanTests >> testRejectLastItem [

	self mockNeighbours.	
	[
		layoutSpan extent: 40@20.
		[layoutSpan rejectLastItem]
			should strictly satisfy: 
		[rightBorder moveBackward.
		rightBorder nextItemAtSpan willReturn: #char.
		(drawer widthOf: #char) willReturn: 10.
		rightSpan increaseFromLeftBy: 10].
	
		layoutSpan extent should equal: 30@20
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testRejectLastItemWhenNoRightSpan [

	self mockNeighbours.	
	[
		layoutSpan extent: 40@20.
		layoutSpan rightSpan: nil.
		[layoutSpan rejectLastItem]
			should strictly satisfy: 
		[rightBorder moveBackward.
		rightBorder nextItemAtSpan willReturn: #char.
		(drawer widthOf: #char) willReturn: 10].
	
		layoutSpan extent should equal: 30@20
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testRightBorderOffset [

	layoutSpan offset: 10.
	layoutSpan extent: 20@30.
	
	layoutSpan rightBorderOffset should equal: 30
]

{ #category : #tests }
TwyLayoutSpanTests >> testRightDoBlock [

	[:actionBlock :conditionBlock :rightSpan1 :rightSpan2 |		
		layoutSpan rightSpan: rightSpan1.
		[layoutSpan rightDo: actionBlock while: conditionBlock]
			should strictly satisfy: 
		[(conditionBlock value: layoutSpan) willReturn: true.
		actionBlock value: layoutSpan.
		(conditionBlock value: rightSpan1) willReturn: true.
		actionBlock value: rightSpan1.
		rightSpan1 rightSpan willReturn: rightSpan2.
		(conditionBlock value: rightSpan2) willReturn: false].
	
		] runWithMocks 
]

{ #category : #tests }
TwyLayoutSpanTests >> testTextSpan [
	
	[
				
		[layoutSpan textSpan should be: #textSpan]
			should lenient satisfy: 
		[rightBorder span willReturn: #textSpan].
		
	] runWithMocks
]

{ #category : #tests }
TwyLayoutSpanTests >> testWidth [
	
	layoutSpan extent: 10@20.
	
	layoutSpan width should be: 10
]
