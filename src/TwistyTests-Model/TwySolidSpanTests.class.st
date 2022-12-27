Class {
	#name : #TwySolidSpanTests,
	#superclass : #TwyElementTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwySolidSpanTests >> testCanNotIntegrateAnySpan [

	(textElement canIntegrate: nil) should be: false
]

{ #category : #tests }
TwySolidSpanTests >> testDelete [

	self testDeleteWhenNoSpansBeforeAndAfter 
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteAllAfterEndPosition [

	textElement deleteAllAfter: 1.
	
	self assertNeighboursNotChanged 
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteAllAfterStartPositionWhenNoSpanAfterAndBefore [
	| emptySpan |
	textElement deleteAllAfter: 0.
	emptySpan := previousElement next.
	emptySpan should beInstanceOf: TwyCharactersSpan.
	emptySpan next should be: nextElement
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteAllAfterStartPositionWhenPreviousIsSpan [

	| span |
	span := TwySpan new.
	textElement previous: span.
	textElement deleteAllAfter: 0.
	
	span next should be: nextElement.
	nextElement previous should be: span
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteAllBeforeEndPositionWhenNextIsSpan [

	| span |
	span := TwySpan new.
	textElement next: span.
	textElement deleteAllBefore: 1.
	
	span previous should be: previousElement.
	previousElement next should be: span
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteAllBeforeEndPositionWhenNoSpanAfterAndBefore [
	| emptySpan |
	textElement deleteAllBefore: 1.
	emptySpan := previousElement next.
	emptySpan should beInstanceOf: TwyCharactersSpan.
	emptySpan next should be: nextElement
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteAllBeforeStartPosition [

	textElement deleteAllBefore: 0.
	
	self assertNeighboursNotChanged 
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteBetweenEqualPositions [

	textElement deleteFrom: 0 to: 0.
	
	self assertNeighboursNotChanged 
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteBetweenPositionsWhenStartIsGreaterThenEnd [

	textElement deleteFrom: 1 to: 0.
	
	self assertNeighboursNotChanged 
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteBetweenSomePositionAndEndPosition [

	| span |
	span := TwySpan new.
	textElement previous: span.
	
	textElement deleteFrom: -10 to: 1.
	
	span next should be: nextElement.
	nextElement previous should be: span
	
	
	
	
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteBetweenStartAndAnotherPositions [

	| span |
	span := TwySpan new.
	textElement previous: span.
	
	textElement deleteFrom: 0 to: 100.
	
	span next should be: nextElement.
	nextElement previous should be: span
	
	
	
	
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteWhenNextIsSpan [

	| span |
	span := TwySpan new.
	textElement next: span.
	
	textElement delete.
	
	span previous should be: previousElement.
	previousElement next should be: span
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteWhenNoSpansBeforeAndAfter [
	| emptySpan |
	textElement delete.
	emptySpan := previousElement next.
	emptySpan should beInstanceOf: TwyCharactersSpan.
	emptySpan contents should be isEmpty.
	emptySpan next should be: nextElement.
	emptySpan previous should be: previousElement
]

{ #category : #tests }
TwySolidSpanTests >> testDeleteWhenPreviousIsSpan [

	| span |
	span := TwySpan new.
	textElement previous: span.
	
	textElement delete.
	
	span next should be: nextElement.
	nextElement previous should be: span
]

{ #category : #tests }
TwySolidSpanTests >> testGettingItemAtAbsentPosition [

	| executed |
	textElement itemAt: 2 ifAbsent: [ executed := true ].
	
	executed should be: true
	
	
	
]

{ #category : #tests }
TwySolidSpanTests >> testInsertionIntoAnotherSpan [

	[ :targetSpan |
		[ textElement insertInto: targetSpan at: 5 ]
			should strictly satisfy: 
		[ targetSpan insertTextStartedWith: textElement at: 5]
	 ] runWithMocks 
]

{ #category : #tests }
TwySolidSpanTests >> testIsEndPosition [

	(textElement isEndPosition: 0) should be: false.
	(textElement isEndPosition: textElement length) should be: true
	
]

{ #category : #tests }
TwySolidSpanTests >> testLength [

	textElement length should equal: 1
]

{ #category : #tests }
TwySolidSpanTests >> testOverridingContentsShouldReturnNoChanges [

	| result |
	result := textElement overrideContentsFrom: 0 to: 1 with: '1234'.
	
	result hasRestString should be: true.
	self assertNeighboursNotChanged 
	
	
	
]

{ #category : #tests }
TwySolidSpanTests >> testShouldBeNotEmpty [

	textElement isEmpty should be: false
]

{ #category : #tests }
TwySolidSpanTests >> testSplittingShouldDoNothing [

	textElement splitAt: Any.
	
	self assertNeighboursNotChanged 
	
	
	
]

{ #category : #running }
TwySolidSpanTests >> textElementClass [
	^TwySolidSpan
]
