Class {
	#name : #TwyElementsGroupRemovedTests,
	#superclass : #TwyTextChangeAnnouncementTestCase,
	#instVars : [
		'elementBeforeRemovedGroup',
		'elementAfterRemovedGroup',
		'firstRemovedElement'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyElementsGroupRemovedTests >> setUp [
	super setUp.
	
	elementBeforeRemovedGroup := Mock new.
	elementAfterRemovedGroup := Mock new.
	firstRemovedElement := Mock new.
	
	change elementBeforeRemovedGroup: elementBeforeRemovedGroup.
	change elementAfterRemovedGroup: elementAfterRemovedGroup.
	change firstRemovedElement: firstRemovedElement
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testCancelling [

	[
		[ change cancel ]
			should strictly satisfy: 
		[firstRemovedElement previous: (Instance of: TwyTextStart). 
		elementBeforeRemovedGroup insertElement: firstRemovedElement ]
	
	] runWithMocks 
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testCorrectingAffectedSpans [
	
	[ :layoutSpan :firstRemovedSpan :builder | 
	
		[ change correctAffectedLayoutSpansStartingAt: layoutSpan by: builder ] 
			should strictly satisfy: 
		[(layoutSpan isOnlySpanRemovedBy: change) willReturn: false.
		(layoutSpan findFirstSpanRemovedBy: change) willReturn: firstRemovedSpan.
		firstRemovedSpan correctSpansRemovedBy: change.
		builder addCorrectionCommandFor: firstRemovedSpan.
		builder addCorrectionCommandFor: layoutSpan] 
	] runWithMocks
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testCorrectingFirstRemovedLayoutSpan [

	[:layoutSpan :firstRemovedSpan |
		[change correctFirstRemovedLayoutSpan: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLayoutEnd willReturn: false.
		elementAfterRemovedGroup isSpan willReturn: true.
		layoutSpan moveBorderToStartOf: elementAfterRemovedGroup]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testCorrectingFirstRemovedLayoutSpanWhenElementAfterRemoveIsNotSpan [

	[:layoutSpan :firstRemovedSpan |
		[change correctFirstRemovedLayoutSpan: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLayoutEnd willReturn: false.
		elementAfterRemovedGroup isSpan willReturn: false.
		(elementAfterRemovedGroup nextSpanIfAbsent: Any) willReturn: #spanAfterRemovedGroup.
		layoutSpan moveBorderToStartOf: #spanAfterRemovedGroup]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testCorrectingFirstRemovedLayoutSpanWhichIsLayoutEnd [

	[:layoutSpan :firstRemovedSpan |
		[change correctFirstRemovedLayoutSpan: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLayoutEnd willReturn: true.
		(firstRemovedElement previousSpanIfAbsent: Any) willReturn: #spanBeforeRemovedGroup.
		layoutSpan moveBorderToEndOf: #spanBeforeRemovedGroup]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testCorrectingPositionOfCursorShouldMoveItToSpanAfterRemovedGroupWhenBeforeElementIsNotSpan [

	[:cursor |
		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAfterElement: elementBeforeRemovedGroup) willReturn: true.
		(cursor isBeforeElement: elementAfterRemovedGroup) willReturn: true.
		elementBeforeRemovedGroup isSpan willReturn: false.
		elementAfterRemovedGroup isSpan willReturn: true.
		cursor moveToStartOf: elementAfterRemovedGroup]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testCorrectingPositionOfCursorShouldMoveItToSpanBeforeRemovedGroupWhenItIsSpan [

	[:cursor |
		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAfterElement: elementBeforeRemovedGroup) willReturn: true.
		(cursor isBeforeElement: elementAfterRemovedGroup) willReturn: true.
		elementBeforeRemovedGroup isSpan willReturn: true.
		cursor moveToEndOf: elementBeforeRemovedGroup]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testCorrectingPositionOfCursorWhichIsNotAfterElementBeforeRemovedGroup [

	[:cursor |
		[change correctPositionOf: cursor]
			should strictly satisfy: 
		[(cursor isAfterElement: elementBeforeRemovedGroup) willReturn: false]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testCorrectingPositionOfCursorWhichIsNotBeforeElementAfterRemovedGroup [

	[:cursor |
		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAfterElement: elementBeforeRemovedGroup) willReturn: true.
		(cursor isBeforeElement: elementAfterRemovedGroup) willReturn: false]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testCorrectingSingleRemovedLayoutSpan [
	
	[ :layoutSpan | 
		[ change correctAffectedLayoutSpansStartingAt: layoutSpan by: nil ] 
			should strictly satisfy: 
		[ (layoutSpan isOnlySpanRemovedBy: change) willReturn: true.
		layoutSpan delete ] 
	] runWithMocks
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsAffectLastLayoutSpanWhichCoversElementBeforeRemovedGroup [

	[:layoutSpan |
		[(change isAffectLayoutSpan: layoutSpan) should be: true]
			should lenient satisfy: 
		[(layoutSpan isLastSpanWhichCovers: elementBeforeRemovedGroup) willReturn: true]
		
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsAffectLayoutLineWhichCoversRemovedElements [

	[ :layoutLine  |
		[ (change isAffectLayoutLine: layoutLine) should be: true ]
			should lenient satisfy: 
		[(layoutLine isCoversElementsBetween: elementBeforeRemovedGroup and: elementAfterRemovedGroup) 
			willReturn: true]
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsAffectLayoutLineWhichIsLastLineWhichCoverElementBeforeInsertion [

	[ :layoutLine  |
		[ (change isAffectLayoutLine: layoutLine) should be: true ]
			should lenient satisfy: 
		[(layoutLine isCoversElementsBetween: elementBeforeRemovedGroup and: elementAfterRemovedGroup) 
			willReturn: false.
		(layoutLine isLastLineWhichCovers: elementBeforeRemovedGroup) willReturn: true]
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsAffectLayoutSpanWhichCoverFirstRemovedElement [

	[:layoutSpan |
		[(change isAffectLayoutSpan: layoutSpan) should be: true]
			should lenient satisfy: 
		[(layoutSpan isLastSpanWhichCovers: elementBeforeRemovedGroup) willReturn: false.
		(layoutSpan isCovers: firstRemovedElement) willReturn: true; useArbitrarily]
		
	] runWithMocks
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsAffectLayoutSpanWhichCoversAnyRemovedElement [

	[:layoutSpan |
		[(change isAffectLayoutSpan: layoutSpan) should be: true]
			should lenient satisfy: 
		[(layoutSpan isLastSpanWhichCovers: elementBeforeRemovedGroup) willReturn: false.
		(layoutSpan isCovers: firstRemovedElement) willReturn: false; useArbitrarily.
		(layoutSpan isBetweenTextElement: elementBeforeRemovedGroup and: elementAfterRemovedGroup) willReturn: true]
		
	] runWithMocks
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsAffectTextAfterElement [

	(elementBeforeRemovedGroup stub isBefore: #someElement) willReturn: true; useOnce.

	(change isAffectTextAfterElement: #someElement) should be: false.
	
	(elementBeforeRemovedGroup stub isBefore: #someElement) willReturn: false; useOnce.
	
	(change isAffectTextAfterElement: #someElement) should be: true.
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsAffectTextAtPositionInsideRemovedRegion [

	| cursor |
	cursor := Mock new.
	
	(cursor stub isBeforeElement: elementAfterRemovedGroup) willReturn: true; useOnce.
	(cursor stub isAfterElement: elementBeforeRemovedGroup) willReturn: true; useOnce.

	(change isAffectTextAt: cursor) should be: true
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsAffectTextBeforeElement [

	(elementAfterRemovedGroup stub isAfter: #someElement) willReturn: true; useOnce.

	(change isAffectTextBeforeElement: #someElement) should be: false.
	
	(elementAfterRemovedGroup stub isAfter: #someElement) willReturn: false; useOnce.
	
	(change isAffectTextBeforeElement: #someElement) should be: true.
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsAfterTextCursorWhichAfterLastRemovedElement [

	| cursor |
	
	cursor := Mock new.
	(cursor stub isBeforeOrAtStartOfElement: firstRemovedElement) willReturn: #result.
	
	(change isAfter: cursor) should be: #result
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsBeforeAnotherChange [

	| anotherChange |
	anotherChange := Mock new.
	(anotherChange stub isAffectTextAfterElement: elementBeforeRemovedGroup) willReturn: #result .

	(change isBeforeChange: anotherChange) should be: #result
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsEmbodyAnotherTextChangeWhenItHappensInsideRemovedGroup [

	| anotherTextChange |
	anotherTextChange := Mock new.
	(anotherTextChange stub isAffectTextAfterElement: elementBeforeRemovedGroup) willReturn: true.
	(anotherTextChange stub isAffectTextBeforeElement: elementAfterRemovedGroup) willReturn: true.
	
	(change isEmbody: anotherTextChange) should be: true
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsNotAffectLayoutLineWhichNotCoverRemovedElementsAndNotCoverElementBeforeInsertion [

	[ :layoutLine  |
		[ (change isAffectLayoutLine: layoutLine) should be: false ]
			should lenient satisfy: 
		[(layoutLine isCoversElementsBetween: elementBeforeRemovedGroup and: elementAfterRemovedGroup) 
			willReturn: false.
		(layoutLine isLastLineWhichCovers: elementBeforeRemovedGroup) willReturn: false]
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsNotAffectLayoutSpanWhichNotCoversAnyRemovedElementAndNotLastSpanBeforeRemovedGroup [

	[:layoutSpan |
		[(change isAffectLayoutSpan: layoutSpan) should be: false]
			should lenient satisfy: 
		[(layoutSpan isCovers: firstRemovedElement) willReturn: false.
		(layoutSpan isLastSpanWhichCovers: elementBeforeRemovedGroup) willReturn: false.
		(layoutSpan isBetweenTextElement: elementBeforeRemovedGroup and: elementAfterRemovedGroup) willReturn: false]
		
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsNotAffectTextAtPositionAfterRemovedRegion [

	| cursor |
	cursor := Mock new.
	
	(cursor stub isBeforeElement: elementAfterRemovedGroup) willReturn: false; useOnce.
	(cursor stub isAfterElement: elementBeforeRemovedGroup) willReturn: true; useOnce.

	(change isAffectTextAt: cursor) should be: false
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsNotAffectTextAtPositionBeforeRemovedRegion [

	| cursor |
	cursor := Mock new.
	
	(cursor stub isBeforeElement: elementAfterRemovedGroup) willReturn: false; useOnce.
	(cursor stub isAfterElement: elementBeforeRemovedGroup) willReturn: false; useOnce.

	(change isAffectTextAt: cursor) should be: false
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsNotEmbodyAnotherTextChangeWhenItHappensAfterRemovedGroup [

	| anotherTextChange |
	anotherTextChange := Mock new.
	(anotherTextChange stub isAffectTextAfterElement: elementBeforeRemovedGroup) willReturn: true.
	(anotherTextChange stub isAffectTextBeforeElement: elementAfterRemovedGroup) willReturn: false.
	
	(change isEmbody: anotherTextChange) should be: false
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsNotEmbodyAnotherTextChangeWhenItHappensBeforeRemovedGroup [

	| anotherTextChange |
	anotherTextChange := Mock new.
	(anotherTextChange stub isAffectTextAfterElement: elementBeforeRemovedGroup) willReturn: false.
	(anotherTextChange stub isAffectTextBeforeElement: elementAfterRemovedGroup) willReturn: true.
	
	(change isEmbody: anotherTextChange) should be: false
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsNotRemoveLayoutSpanWhichNotCoversAnyRemovedElements [

	[:layoutSpan |
		[(change isRemoveLayoutSpan: layoutSpan) should be: false]
			should lenient satisfy: 
		[(layoutSpan isCovers: firstRemovedElement) willReturn: false.
		(layoutSpan isBetweenTextElement: elementBeforeRemovedGroup and: elementAfterRemovedGroup) willReturn: false]
		
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsRemoveLayoutSpanWhichCoverFirstRemovedElement [

	[:layoutSpan |
		[(change isRemoveLayoutSpan: layoutSpan) should be: true]
			should lenient satisfy: 
		[(layoutSpan isCovers: firstRemovedElement) willReturn: true; useArbitrarily]
		
	] runWithMocks
]

{ #category : #tests }
TwyElementsGroupRemovedTests >> testIsRemoveLayoutSpanWhichCoversAnyRemovedElement [

	[:layoutSpan |
		[(change isRemoveLayoutSpan: layoutSpan) should be: true]
			should lenient satisfy: 
		[(layoutSpan isCovers: firstRemovedElement) willReturn: false; useArbitrarily.
		(layoutSpan isBetweenTextElement: elementBeforeRemovedGroup and: elementAfterRemovedGroup) willReturn: true]
		
	] runWithMocks
]

{ #category : #running }
TwyElementsGroupRemovedTests >> textChangeClass [
	^TwyElementsGroupRemoved 
]
