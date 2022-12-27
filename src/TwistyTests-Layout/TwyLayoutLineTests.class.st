Class {
	#name : #TwyLayoutLineTests,
	#superclass : #TestCase,
	#instVars : [
		'line',
		'layout',
		'belowLine',
		'aboveLine',
		'belowLineFirstSpan',
		'lineLastSpan',
		'lineFirstSpan',
		'lineFirstTextSpan',
		'lineLastTextSpan'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #helpers }
TwyLayoutLineTests >> lineSpansDoWith: spans [ 
	
	(line firstSpan rightDo: Any while: Any) will: [ :action :condition | 
		spans do: [ :each | condition value: each. action value: each]].
	
	spans do: [ :each | 
		each isTextSpansBorder willReturn: false; useArbitrarily.
		each line willReturn: line; useArbitrarily.		
	 ]
]

{ #category : #helpers }
TwyLayoutLineTests >> mockNeighbours [
	
	belowLine := Mock new.
	aboveLine :=  Mock new.
	
	belowLine stub firstSpan willReturn: belowLineFirstSpan.
	
	line 
		belowLine: belowLine;
		aboveLine: aboveLine
]

{ #category : #setUp }
TwyLayoutLineTests >> setUp [
	super setUp.
	
	layout := Mock new.
	
	aboveLine := TwyLayoutLine new.
	belowLine := TwyLayoutLine new.
	
	belowLineFirstSpan := Mock new.
	belowLine firstSpan: belowLineFirstSpan.	
	lineLastSpan := Mock new.
	belowLineFirstSpan stub leftSpan willReturn: lineLastSpan.
	lineFirstSpan := Mock new.
	
	line := TwyLayoutLine new.
	line 
		layout: layout;
		belowLine: belowLine;
		aboveLine: aboveLine;
		firstSpan: lineFirstSpan.
	
	belowLine aboveLine:line.
	aboveLine belowLine: line.
	
	lineFirstTextSpan := Mock new.
	lineLastTextSpan := Mock new.
	lineFirstSpan stub textSpan willReturn: lineFirstTextSpan.
	lineLastSpan stub textSpan willReturn: lineLastTextSpan 
]

{ #category : #tests }
TwyLayoutLineTests >> testAlignmentCentered [
	
	line extent: 10 @ 20.
	line topLeftPosition: 50@100.
	
	line alignCenteredWithin: 15.
	
	line topLeftPosition should equal: 2 @ 100
]

{ #category : #tests }
TwyLayoutLineTests >> testAlignmentLeftToRignt [
	
	line topLeftPosition: 1@2.
	
	line alignLeftToRightWithin: 1234.
	
	line topLeftPosition should equal: 0 @ 2
]

{ #category : #tests }
TwyLayoutLineTests >> testAlignmentRightToLeft [
	
	line extent: 10 @ 20.
	line topLeftPosition: 2@100.
	
	line alignRightToLeftWithin: 15.
	
	line topLeftPosition should equal: 5 @ 100
]

{ #category : #tests }
TwyLayoutLineTests >> testApplyExtentToLayout [ 
	
	[
		line extent: 20@30.
		[line applyExtentToLayout ]
			should strictly satisfy: 
		[ layout increaseExtentBy: 20@30 ]
	] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutLineTests >> testApplyingAllignment [
	
	[:alignment |
		[line applyAlignment: alignment]
			should strictly satisfy: 
		[layout width willReturn: #layoutWidth.
		alignment layoutLine: line within: #layoutWidth]
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutLineTests >> testBottomBorderOffset [
	
	line topLeftPosition: 3 @ 123.
	line extent: 10@20.
	
	line bottomBorderOffset should equal: 143
]

{ #category : #tests }
TwyLayoutLineTests >> testContainsPointWhichInsideLineBounds [

	| actual |
	line topLeftPosition: 10 @ 20.
	line extent: 50 @ 8.
	
	actual := line containsPoint: 20 @ 23.
	
	actual should be: true
]

{ #category : #tests }
TwyLayoutLineTests >> testContainsPointWhichInsideLineHeightButOutOfWidth [

	| actual |
	line topLeftPosition: 10 @ 20.
	line extent: 50 @ 8.
	
	actual := line containsPoint: 100 @ 23.
	
	actual should be: true
]

{ #category : #tests }
TwyLayoutLineTests >> testDelete [
	
	layout stub topLine willReturn: #topLine.

	line delete.
	
	belowLine aboveLine should be: aboveLine.
	aboveLine belowLine should be: belowLine.
	line extent should equal: 0@0
]

{ #category : #tests }
TwyLayoutLineTests >> testDeleteWhenItFirstLayoutLine [

	[
		line aboveLine: nil.
	 	
		[line delete]
			should strictly satisfy: 
		[layout topLine willReturn: line. 
		layout topLine: belowLine ].
	
		belowLine aboveLine should be: nil.
		line extent should equal: 0@0
	] runWithMocks.

]

{ #category : #tests }
TwyLayoutLineTests >> testFindSpan [
	
	[:targetSpan :firstSpan |
		line firstSpan: firstSpan.
		
		[ (line findSpanWith: #textCursor) should be: targetSpan ]
			should strictly satisfy: 
		[self lineSpansDoWith: {firstSpan. targetSpan}.
		(firstSpan contains: #textCursor) willReturn: false. 	
		(targetSpan contains: #textCursor) willReturn: true ].
	
	] runWithMocks 		

]

{ #category : #tests }
TwyLayoutLineTests >> testFindSpanWhenItAbsent [
	
	[:eachSpan :firstSpan |
		line firstSpan: firstSpan.
		
		[ (line findSpanWith: #textCursor) should be: nil ]
			should strictly satisfy: 
		[self lineSpansDoWith: {firstSpan. eachSpan}.
		(firstSpan contains: #textCursor) willReturn: false. 	
		(eachSpan contains: #textCursor) willReturn: false ].
	
	] runWithMocks 		

]

{ #category : #tests }
TwyLayoutLineTests >> testFirstTextSpan [
	
	| firstSpan |
	firstSpan := Mock new.
	firstSpan stub textSpan willReturn: #firstTextSpan.

	line firstSpan: firstSpan.

	line firstTextSpan should be: #firstTextSpan.
]

{ #category : #tests }
TwyLayoutLineTests >> testFixPositionWhenItIsLayoutTop [
	
	layout stub topLine willReturn: line.
	
	line topLeftPosition: 3 @ 123.
	
	line fixPosition.
	
	line topLeftPosition should equal: 3 @ 0
]

{ #category : #tests }
TwyLayoutLineTests >> testFixPositionWhenItIsNotLayoutTop [
	
	layout stub topLine willReturn: #anotherLine.
	
	aboveLine := Mock new.
	aboveLine stub bottomBorderOffset willReturn: 40.
	line aboveLine: aboveLine.
	line topLeftPosition: 3 @ 123.
	
	line fixPosition.
	
	line topLeftPosition should equal: 3 @ 40
]

{ #category : #tests }
TwyLayoutLineTests >> testGettingParagraphAttribute [
	
	[:firstTextSpan |
		[(line getParagraphAttribute: #textAttribute) should be: #result]
			should strictly satisfy: 
		[lineFirstSpan textSpan willReturn: firstTextSpan.
		(firstTextSpan getParagraphAttribute: #textAttribute) willReturn: #result]
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutLineTests >> testGettingSpanAtOffset [

	[:targetSpan :firstSpan |
		line topLeftPosition: 4 @ 10.
		line firstSpan: firstSpan.
		
		[ (line spanAtOffset: 20) should be: targetSpan ]
			should strictly satisfy: 
		[self lineSpansDoWith: {firstSpan. targetSpan}.
		(firstSpan isOverlaidLineAtX: 16) willReturn: false. 		
		(targetSpan isOverlaidLineAtX: 16) willReturn: true ].
	
	] runWithMocks 		

]

{ #category : #tests }
TwyLayoutLineTests >> testGettingSpanAtOffsetWhenItsTooBig [

	[:eachSpan :firstSpan :lastSpan |
		line topLeftPosition: 4 @ 10.
		line firstSpan: firstSpan.
		
		[ (line spanAtOffset: 20) should be: lastSpan ]
			should strictly satisfy: 
		[self lineSpansDoWith: {eachSpan. lastSpan}.
		(eachSpan isOverlaidLineAtX: 16) willReturn: false. 		
		(lastSpan isOverlaidLineAtX: 16) willReturn: false ].
	
	] runWithMocks 		

]

{ #category : #tests }
TwyLayoutLineTests >> testGettingSpanAtOffsetWhenItsTooSmall [

	| actual |
	line topLeftPosition: 4 @ 10.
	line firstSpan: #firstSpan.
	
	actual := line spanAtOffset: 2.
	
	actual should be: #firstSpan
]

{ #category : #tests }
TwyLayoutLineTests >> testHasZeroExtentByDefault [
	
	line extent should equal: 0@0
]

{ #category : #tests }
TwyLayoutLineTests >> testHasZeroOriginPositionByDefault [
	
	line topLeftPosition should equal: 0@0
]

{ #category : #tests }
TwyLayoutLineTests >> testImportSpansFromAnotherLine [ 
	
	[:anotherLine :firstImportedSpan :eachSpan |
		
		[line importSpansFrom: anotherLine startedWith: firstImportedSpan ]
			should strictly satisfy: 
		[ (firstImportedSpan rightDo: Any while: Any) will: [:actionBlock :conditionBlock |
			(conditionBlock value: eachSpan) should be: true.
			actionBlock value: eachSpan].
		eachSpan line willReturn: anotherLine.
		eachSpan migrateTo: line].
		line firstSpan should be: firstImportedSpan 
	
	] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutLineTests >> testIncreasingExtentByHighDeltaShouldIncreaseHeight [
	
	line extent: 5 @ 20.
	
	line increaseExtentBy: 10@25.
	
	line height should equal: 25
]

{ #category : #tests }
TwyLayoutLineTests >> testIncreasingExtentByLowDeltaShouldNotChangeHeight [
	
	line extent: 5 @ 20.
	
	line increaseExtentBy: 10@3.
	
	line height should equal: 20
]

{ #category : #tests }
TwyLayoutLineTests >> testIncreasingExtentShouldIncreaseWidth [
	
	line extent: 5 @ 20.
	
	line increaseExtentBy: 10@20.
	
	line width should equal: 15
]

{ #category : #tests }
TwyLayoutLineTests >> testIsCoversLineStart [

	[:firstSpan :textElement |
		line firstSpan: firstSpan.
		[(line isCoversLineStart: #lineStart) should be: #result]
			should lenient satisfy: 
		[(firstSpan isCoversLineStart: #lineStart) willReturn: #result]
	] runWithMocks.
]

{ #category : #tests }
TwyLayoutLineTests >> testIsCoversTextElement [

	[:textElement |
		[(line isCovers: textElement) should be: #result]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutLine: line) willReturn: #result]
	] runWithMocks.
]

{ #category : #tests }
TwyLayoutLineTests >> testIsCoversTextElementsWhichBetweenFirstAndLastTextSpans [

	[
		[(line isCoversElementsBetween: #firstElement and: #lastElement) should be: true]
			should lenient satisfy: 
		[(lineFirstTextSpan isBefore: #lastElement) willReturn: true.
		(lineLastTextSpan isAfter: #firstElement) willReturn: true]
	] runWithMocks.

]

{ #category : #tests }
TwyLayoutLineTests >> testIsCoversTextSpanWhenItIsBetweenFirstAndLastLineSpans [

	[
		[(line isCoversSpan: #textSpan) should be: true]
			should lenient satisfy: 
		[(lineFirstTextSpan isAfter: #textSpan) willReturn: false.
		(lineLastTextSpan isBefore: #textSpan) willReturn: false]
	] runWithMocks.
]

{ #category : #tests }
TwyLayoutLineTests >> testIsDeletedWhenAboveLineHasNotThisBelowLine [
	
	line belowLine: nil.
	aboveLine belowLine: #anotherLine.
	
	line isDeleted should be: true
]

{ #category : #tests }
TwyLayoutLineTests >> testIsDeletedWhenBelowLineHasNotThisAboveLine [
	
	line aboveLine: nil.
	belowLine aboveLine: #anotherLine.
	
	line isDeleted should be: true
]

{ #category : #tests }
TwyLayoutLineTests >> testIsFirstLineWhichCoversTextElementWhenItCoversItAndAboveLineNotCoversIt [

	self mockNeighbours.
	[:textElement |
		[(line isFirstLineWhichCovers: textElement) should be: true]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutLine: line) willReturn: true.
		(aboveLine isCovers: textElement) willReturn: false]
	] runWithMocks.

]

{ #category : #tests }
TwyLayoutLineTests >> testIsLastLineWhichCoversTextElementWhenItCoversItAndBelowLineNotCoversIt [

	self mockNeighbours.
	[:textElement |
		[(line isLastLineWhichCovers: textElement) should be: true]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutLine: line) willReturn: true.
		(belowLine isCovers: textElement) willReturn: false]
	] runWithMocks.

]

{ #category : #tests }
TwyLayoutLineTests >> testIsLayoutTopWhenItTopLine [
	
	layout stub topLine willReturn: line.
	
	line isLayoutTop should be: true
]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotCoversTextElementsWhichFirstElementAfterLastLineSpan [

	[
		[(line isCoversElementsBetween: #firstElement and: #lastElement) should be: false]
			should lenient satisfy: 
		[(lineFirstTextSpan isBefore: #lastElement) willReturn: true.
		(lineLastTextSpan isAfter: #firstElement) willReturn: false]
	] runWithMocks.

]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotCoversTextElementsWhichLastElementBeforeFirstLineSpan [

	[
		[(line isCoversElementsBetween: #firstElement and: #lastElement) should be: false]
			should lenient satisfy: 
		[(lineFirstTextSpan isBefore: #lastElement) willReturn: false]
	] runWithMocks.

]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotCoversTextSpanWhenFirstSpanAfterIt [

	[
		[(line isCoversSpan: #textSpan) should be: false]
			should lenient satisfy: 
		[(lineFirstTextSpan isAfter: #textSpan) willReturn: true]
	] runWithMocks.
]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotCoversTextSpanWhenLastSpanBeforeIt [

	[
		[(line isCoversSpan: #textSpan) should be: false]
			should lenient satisfy: 
		[(lineFirstTextSpan isAfter: #textSpan) willReturn: false.
		(lineLastTextSpan isBefore: #textSpan) willReturn: true]
	] runWithMocks.
]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotDeletedWhenAboveLineHasThisBelowLine [
	
	aboveLine belowLine: line.
	
	line isDeleted should be: false
]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotDeletedWhenBelowLineHasThisAboveLine [
	
	belowLine aboveLine: line.
	
	line isDeleted should be: false
]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotDeletedWhenItIsSingleLine [
	
	line aboveLine: nil; belowLine: nil.
	
	line isDeleted should be: false
]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotFirstLineWhichCoversTextElementWhenAboveLineCoversItToo [

	self mockNeighbours.
	[:textElement |
		[(line isFirstLineWhichCovers: textElement) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutLine: line) willReturn: true.
		(aboveLine isCovers: textElement) willReturn: true]
	] runWithMocks.

]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotFirstLineWhichCoversTextElementWhenItNotCoversIt [

	self mockNeighbours.
	[:textElement |
		[(line isFirstLineWhichCovers: textElement) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutLine: line) willReturn: false]
	] runWithMocks.

]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotLastLineWhichCoversTextElementWhenAboveLineCoversItToo [

	self mockNeighbours.
	[:textElement |
		[(line isLastLineWhichCovers: textElement) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutLine: line) willReturn: true.
		(belowLine isCovers: textElement) willReturn: true]
	] runWithMocks.

]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotLastLineWhichCoversTextElementWhenItNotCoversIt [

	self mockNeighbours.
	[:textElement |
		[(line isLastLineWhichCovers: textElement) should be: false]
			should lenient satisfy: 
		[(textElement isCoveredByLayoutLine: line) willReturn: false]
	] runWithMocks.

]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotLayoutTopWhenItIsNotTopLine [
	
	layout stub topLine willReturn: #anotherLine.
	
	line isLayoutTop should be: false
]

{ #category : #tests }
TwyLayoutLineTests >> testIsNotVirtualWhenItFirstLineAtLayout [
	
	[
		[line isVirtual should be: false]
			should lenient satisfy: 
		[lineFirstSpan isLayoutStart willReturn: true]
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutLineTests >> testIsVirtual [
	
	[:previousLineLastSpan |
		[line isVirtual should be: #result]
			should lenient satisfy: 
		[lineFirstSpan isLayoutStart willReturn: false.
		lineFirstSpan leftSpan willReturn: previousLineLastSpan.
		(lineFirstSpan isCoversSameTextSpanAs: previousLineLastSpan) willReturn: #result]
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutLineTests >> testLayoutBounds [
	
	| actual |
	line topLeftPosition: 12@2.
	line extent: 4@3.
	layout stub width willReturn: 20.
	
	actual := line layoutBounds.
	
	actual should equal: (0@2 extent: 20@3)
]

{ #category : #tests }
TwyLayoutLineTests >> testNewBelowLine [
	
	| actual |
	actual := line newBelowLine.

	actual aboveLine should be: line.	
	line belowLine should be: actual.
	actual belowLine should be: belowLine.
	actual layout should be: layout

	
]

{ #category : #tests }
TwyLayoutLineTests >> testNewBelowLineShouldSetNewTopLeftPosition [
	
	| actual |
	line topLeftPosition: 0@20.
	line extent: 4@6.
	
	actual := line newBelowLine.

	actual topLeftPosition should equal: 0@26.	
	
	
]

{ #category : #tests }
TwyLayoutLineTests >> testNewCursorCreation [
	| actual subscriber1 subscriber2 |
	[ :firstSpan :textCursor | 
	line firstSpan: firstSpan.
	[ actual := line newCursor ] should lenient
		satisfy: [ firstSpan isAtStartOfTextLine willReturn: false.
			(layout
				when: TwyLayoutChanged
				send: #synchronizeWithTextCursor
				to: Any) will: [ :arg1 :arg2 :arg3 | subscriber1 := arg3 ].
			firstSpan fetchTextCursor willReturn: textCursor.
			(firstSpan computeLayoutPositionOf: textCursor) willReturn: 2 @ 10.
			(textCursor subscribeLayoutCursor: Any)
				will: [ :arg | subscriber2 := arg ] ].
	actual should beInstanceOf: TwyLayoutCursor.
	actual textCursor should be: textCursor.
	actual layout should be: layout.
	actual span should be: firstSpan.
	actual layoutPosition should equal: 2 @ 10.
	actual desiredOffset should equal: 2.
	subscriber1 should be: actual.
	subscriber2 should be: actual ] runWithMocks
]

{ #category : #tests }
TwyLayoutLineTests >> testNewCursorCreationWhenFirstSpanIsAtStartOfTextLine [
	| actual subscriber1 subscriber2 |
	[ :firstSpan :secondSpan :textCursor | 
	line firstSpan: firstSpan.
	[ actual := line newCursor ] should lenient
		satisfy: [ firstSpan isAtStartOfTextLine willReturn: true.
			firstSpan rightSpan willReturn: secondSpan.
			(layout
				when: TwyLayoutChanged
				send: #synchronizeWithTextCursor
				to: Any) will: [ :arg1 :arg2 :arg3 | subscriber1 := arg3 ].
			secondSpan fetchTextCursor willReturn: textCursor.
			(secondSpan computeLayoutPositionOf: textCursor) willReturn: 2 @ 10.
			(textCursor subscribeLayoutCursor: Any)
				will: [ :arg | subscriber2 := arg ] ].
	actual should beInstanceOf: TwyLayoutCursor.
	actual textCursor should be: textCursor.
	actual layout should be: layout.
	actual span should be: secondSpan.
	actual layoutPosition should equal: 2 @ 10.
	actual desiredOffset should equal: 2.
	subscriber1 should be: actual.
	subscriber2 should be: actual ] runWithMocks
]

{ #category : #tests }
TwyLayoutLineTests >> testNotContainsPointWhichAboveLine [

	| actual |
	line topLeftPosition: 10 @ 20.
	line extent: 50 @ 8.
	
	actual := line containsPoint: 20 @ 29.
	
	actual should be: false
]

{ #category : #tests }
TwyLayoutLineTests >> testNotContainsPointWhichBelowLine [

	| actual |
	line topLeftPosition: 10 @ 20.
	line extent: 50 @ 8.
	
	actual := line containsPoint: 20 @ 19.
	
	actual should be: false
]

{ #category : #tests }
TwyLayoutLineTests >> testPlacedAboveAnotherLineWithBiggerTopLeftPosition [
	
	| anotherLine |
	anotherLine := TwyLayoutLine new.
	anotherLine topLeftPosition: 0@30.
	
	line topLeftPosition: 0@20.
	
	(line isPlacedBelowThan: anotherLine) should be: false
]

{ #category : #tests }
TwyLayoutLineTests >> testPlacedBelowAnotherLineWithSmallerTopLeftPosition [
	
	| anotherLine |
	anotherLine := TwyLayoutLine new.
	anotherLine topLeftPosition: 0@10.
	
	line topLeftPosition: 0@20.
	
	(line isPlacedBelowThan: anotherLine) should be: true
]

{ #category : #tests }
TwyLayoutLineTests >> testRebuildingShouldCleanupNeighboursOfEndOfTextSpan [

	[:eachSpan :layoutStrategy |
		
		[ line rebuildForNewExtentBy: layoutStrategy ]
			should strictly satisfy: 
		[(lineFirstSpan rightDo: Any while: Any) will: [:action :condition | action value: eachSpan].	
		eachSpan fixOffset.
		eachSpan isTextSpansBorder willReturn: false.
		layoutStrategy correctLayoutOf: eachSpan.
		eachSpan isAtEndOfTextSpan willReturn: true.
		eachSpan cleanUpRedundantNeighbours.
		eachSpan applyExtentToLine]

	 ] runWithMocks
]

{ #category : #tests }
TwyLayoutLineTests >> testRebuildingShouldCorrectAllRealSpans [

	[:eachSpan :layoutStrategy |
		
		[ line rebuildForNewExtentBy: layoutStrategy ]
			should strictly satisfy: 
		[(lineFirstSpan rightDo: Any while: Any ) will: [:action :condition | action value: eachSpan].	
		eachSpan fixOffset.
		eachSpan isTextSpansBorder willReturn: false.
		layoutStrategy correctLayoutOf: eachSpan.
		eachSpan isAtEndOfTextSpan willReturn: false.
		eachSpan applyExtentToLine]

	 ] runWithMocks
]

{ #category : #tests }
TwyLayoutLineTests >> testRebuildingShouldCorrectOnlyLineSpans [

	[:layoutStrategy :anotherLineSpan :thisLineSpan |
		
		[ line rebuildForNewExtentBy: layoutStrategy ]
			should strictly satisfy: 
		[thisLineSpan line willReturn: line; useArbitrarily.
		anotherLineSpan line willReturn: #anotherLine; useArbitrarily.
		
		(lineFirstSpan rightDo: Any while: Any ) will: [:action :condition | 
			(condition value: thisLineSpan) should be: true.
			(condition value: anotherLineSpan) should be: false].	
		]

	 ] runWithMocks
]

{ #category : #tests }
TwyLayoutLineTests >> testRebuildingShouldResetExtentBeforeLinesScanning [

	[ 
		line extent: 10@100.

		[ line rebuildForNewExtentBy: #strategy]
			should strictly satisfy: 
		[(lineFirstSpan rightDo: Any while: Any) when: [line extent] is: 0@0]

	 ] runWithMocks
]

{ #category : #tests }
TwyLayoutLineTests >> testRebuildingShouldSkipAllTextSpanBorders [

	[:eachSpan :layoutStrategy |
		
		[ line rebuildForNewExtentBy: layoutStrategy ]
			should strictly satisfy: 
		[(lineFirstSpan rightDo: Any while: Any ) will: [:action :condition | action value: eachSpan].	
		eachSpan fixOffset.
		eachSpan isTextSpansBorder willReturn: true]

	 ] runWithMocks
]

{ #category : #tests }
TwyLayoutLineTests >> testReduceExtentShouldReduceWidth [
	
	line extent: 50 @ 20.
	
	line reduceExtentBy: 10@20.
	
	line width should equal: 40
]

{ #category : #tests }
TwyLayoutLineTests >> testReduceExtentShouldResetHeight [
	
	line extent: 50 @ 20.
	
	line reduceExtentBy: 10@20.
	
	line height should equal: 0
]

{ #category : #tests }
TwyLayoutLineTests >> testRemoveFirstSpanWhenItIsNotOnlySpanAtLine [
	
	[:firstSpan :removedSpan |
		line firstSpan: removedSpan.
		[line removeSpan: removedSpan ]
			should strictly satisfy: 
		[removedSpan isLastAtLine willReturn: false.
		removedSpan rightSpan willReturn: #rightSpan].
		
		line firstSpan should be: #rightSpan
		
	] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutLineTests >> testRemoveFirstSpanWhenItIsOnlySpanAtLine [
	
	[:firstSpan :removedSpan |
		line firstSpan: removedSpan.
		[line removeSpan: removedSpan ]
			should strictly satisfy: 
		[removedSpan isLastAtLine willReturn: true.
		layout topLine willReturn: #anotherLine].
		
		belowLine aboveLine should be: aboveLine.
		aboveLine belowLine should be: belowLine
		
	] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutLineTests >> testRemoveFirstSpanWhenItIsOnlySpanAtLineAndLineIsLayoutTop [
	
	[:firstSpan :removedSpan |
		line firstSpan: removedSpan.
		[line removeSpan: removedSpan ]
			should strictly satisfy: 
		[removedSpan isLastAtLine willReturn: true.
		layout topLine willReturn: line.
		layout topLine: belowLine].
		
		belowLine aboveLine should be: nil.
		
	] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutLineTests >> testRemoveNotFirstSpan [
	
	[:firstSpan :removedSpan |
		line firstSpan: firstSpan.
		[line removeSpan: removedSpan ]
			should strictly satisfy: 
		[].
		
	] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutLineTests >> testResetExtent [
	
	line extent: #extent.
	
	line resetExtent.

	line extent should equal: 0@0
	
]
