Class {
	#name : #TwyCorrectSpanCommandTests,
	#superclass : #TwyLayoutBuiltCommandTestCase,
	#instVars : [
		'span'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyCorrectSpanCommandTests >> commandClass [
	^TwyCorrectSpanCommand 
]

{ #category : #running }
TwyCorrectSpanCommandTests >> setUp [ 
	super setUp.
	
	span := Mock new.
	command span: span
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testHasBuiltPlaceAfterLayoutSpan [

	[ 
		[ (command hasBuiltPlaceAfterLayoutSpan: #someLayoutSpan) should be: #result]
			should strictly satisfy: 
		[(span isPlacedAfter: #someLayoutSpan) willReturn: #result]
	 ] runWithMocks 
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testHasBuiltPlaceBeforeTextChange [

	[:textChange |
		 [ (command hasBuiltPlaceBeforeTextChange: textChange) should be: #result]
			should strictly satisfy: 
		[(span isPlacedBeforeTextChange: textChange) willReturn: #result]
	 ] runWithMocks 
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testHasBuiltPlaceUnderTextChange [

	[:textChange |
		 [ (command hasBuiltPlaceChangedBy: textChange) should be: #result]
			should strictly satisfy: 
		[(span isCoversTextChangedBy: textChange) willReturn: #result]
	 ] runWithMocks 
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testIsActiveAtSpan [

	(command isActiveAtSpan: span) should be: true.

	(command isActiveAtSpan: #anotherSpan) should be: false.
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testIsActiveAtSpanLine [

	span stub line willReturn: #line.
	
	(command isActiveAtLine: #line) should be: true.

]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testIsNotActiveAtNotSpanLine [

	span stub line willReturn: #line.
	
	(command isActiveAtLine: #anotherLine) should be: false.

]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testIsNotSimilarToDifferentSpanCorrectionCommand [

	| similarCommand |
	similarCommand := self commandClass new.
	similarCommand span: #anotherSpan.
	
	(command isSimilarTo: similarCommand) should be: false
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testIsSimilarToSameSpanCorrectionCommand [

	| similarCommand |
	similarCommand := self commandClass new.
	similarCommand span: command span.
	
	(command isSimilarTo: similarCommand) should be: true
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testShouldBeExecutedBeforeAnotherCommand [

	[:anotherCommand |
		 [ (command shouldBeExecutedBefore: anotherCommand) should be: #result]
			should strictly satisfy: 
		[(anotherCommand hasBuiltPlaceAfterLayoutSpan: span) willReturn: #result]
	 ] runWithMocks 
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testShouldBeNotRedundantWhenSpanIsNotDeleted [

	span stub isDeleted willReturn: false.
	
	command isRedundant should be: false
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testShouldBeRedundantWhenSpanIsDeleted [

	span stub isDeleted willReturn: true.
	
	command isRedundant should be: true
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testWhenItNotTextSpansBorderAndAtEndOfTextLine [

	[ 
		[ self executeCommand]
			should strictly satisfy: 
		[span fixOffset. 
		span isTextSpansBorder willReturn: false.
		builder correctLayoutOf: span.
		span isAtEndOfTextSpan willReturn: false.
		span isAtEndOfTextLine willReturn: true]
	 ] runWithMocks 
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testWhenItNotTextSpansBorderAndAtEndOfTextSpanAndAtLineEnd [

	[ 
		[ self executeCommand]
			should strictly satisfy: 
		[span fixOffset. 
		span isTextSpansBorder willReturn: false.
		builder correctLayoutOf: span.
		span isAtEndOfTextSpan willReturn: true.
		span cleanUpRedundantNeighbours. 
		span isAtEndOfTextLine willReturn: true]
	 ] runWithMocks 
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testWhenItNotTextSpansBorderAndAtEndOfTextSpanButNotAtLineEnd [

	[ 
		[ self executeCommand]
			should strictly satisfy: 
		[span fixOffset. 
		span isTextSpansBorder willReturn: false.
		builder correctLayoutOf: span.
		span isAtEndOfTextSpan willReturn: true.
		span cleanUpRedundantNeighbours. 
		span isAtEndOfTextLine willReturn: false.
		span rightSpan willReturn: #rightSpan.
		(builder addLayoutCommand: command) when: [command span] is: #rightSpan].
	 ] runWithMocks 
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testWhenItTextSpansBorderAndAtEndOfTextLine [

	[ 
		[ self executeCommand]
			should strictly satisfy: 
		[span fixOffset. 
		span isTextSpansBorder willReturn: true.
		span importNextSpanToLine.
		span isAtEndOfTextSpan willReturn: false.
		span isAtEndOfTextLine willReturn: true]
	 ] runWithMocks 
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testWhenItTextSpansBorderAndAtEndOfTextSpanAndAtLineEnd [

	[ 
		[ self executeCommand]
			should strictly satisfy: 
		[span fixOffset. 
		span isTextSpansBorder willReturn: true.
		span importNextSpanToLine.
		span isAtEndOfTextSpan willReturn: true.
		span cleanUpRedundantNeighbours. 
		span isAtEndOfTextLine willReturn: true]
	 ] runWithMocks 
]

{ #category : #tests }
TwyCorrectSpanCommandTests >> testWhenItTextSpansBorderAndAtEndOfTextSpanButNotAtLineEnd [

	[ 
		[ self executeCommand]
			should strictly satisfy: 
		[span fixOffset. 
		span isTextSpansBorder willReturn: true.
		span importNextSpanToLine.
		span isAtEndOfTextSpan willReturn: true.
		span cleanUpRedundantNeighbours. 
		span isAtEndOfTextLine willReturn: false.
		span rightSpan willReturn: #rightSpan.
		(builder addLayoutCommand: command) when: [command span] is: #rightSpan].
	 ] runWithMocks 
]
