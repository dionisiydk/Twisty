Class {
	#name : #TwyCharactersSpanDecreasedTests,
	#superclass : #TwyElementChangedTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwyCharactersSpanDecreasedTests >> testCancelling [

	[
		change deletionStart: 2.
		change deletionEnd: 4.
		change initialContents: '123456'.
		[ change cancel ]
			should strictly satisfy: 
		[ element insertSimpleString: '34' at: 2]
	
	] runWithMocks 
]

{ #category : #tests }
TwyCharactersSpanDecreasedTests >> testCorrectingPositionOfCursorWhenDeletionHappensAfterIt [

	[:cursor |
		change deletionStart: 3.

		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: element) willReturn: true. 
		cursor spanPosition willReturn: 2; useArbitrarily]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyCharactersSpanDecreasedTests >> testCorrectingPositionOfCursorWhenDeletionHappensBeforeIt [

	[:cursor |
		change deletionStart: 3.
		change deletionEnd: 5.

		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: element) willReturn: true. 
		cursor spanPosition willReturn: 6; useArbitrarily.
		cursor moveBackward: 2 ]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyCharactersSpanDecreasedTests >> testCorrectingPositionOfCursorWhichAtAnotherSpan [

	[:cursor |
		change deletionStart: 3.

		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: element) willReturn: false]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyCharactersSpanDecreasedTests >> testCorrectingPositionOfCursorWhichPlacedInsideDeletionInterval [

	[:cursor |
		change deletionStart: 3.
		change deletionEnd: 6.

		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: element) willReturn: true.
		 cursor spanPosition willReturn: 5; useArbitrarily.
		cursor spanPosition: 3 ]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyCharactersSpanDecreasedTests >> testGettingRemovedCharacters [

	change initialContents: '123456'.
	change deletionStart: 2; deletionEnd: 4.
	
	change removedCharacters should equal: '34'
]

{ #category : #tests }
TwyCharactersSpanDecreasedTests >> testRemovedItemsBetweenTwoCursorsWhenBothEqualToDeletionBorders [

	| start end |
	start := Mock new.
	start stub spanPosition willReturn: 4.
	end := Mock new.
	end stub spanPosition willReturn: 7.
	
	change deletionStart: 4.
	change deletionEnd: 7.
	change initialContents: '123456789'.

	(change removedItemsBetween: start and: end) should equal: change removedCharacters
]

{ #category : #tests }
TwyCharactersSpanDecreasedTests >> testRemovedItemsBetweenTwoCursorsWhenBothInsideDeletionRegion [

	| start end |
	start := Mock new.
	start stub spanPosition willReturn: 4.
	end := Mock new.
	end stub spanPosition willReturn: 7.
	
	change deletionStart: 2.
	change deletionEnd: 8.
	change initialContents: '123456789'.

	(change removedItemsBetween: start and: end) should equal: '567'
]

{ #category : #tests }
TwyCharactersSpanDecreasedTests >> testRemovedItemsBetweenTwoCursorsWhenFirstBeforeDeletionStart [

	| start end |
	start := Mock new.
	start stub spanPosition willReturn: 3.
	end := Mock new.
	end stub spanPosition willReturn: 5.
	
	change deletionStart: 4.
	change deletionEnd: 8.
	change initialContents: '123456789'.

	(change removedItemsBetween: start and: end) should equal: '5'
]

{ #category : #tests }
TwyCharactersSpanDecreasedTests >> testRemovedItemsBetweenTwoCursorsWhenLastAfterDeletionEnd [

	| start end |
	start := Mock new.
	start stub spanPosition willReturn: 6.
	end := Mock new.
	end stub spanPosition willReturn: 9.
	
	change deletionStart: 4.
	change deletionEnd: 8.
	change initialContents: '123456789'.

	(change removedItemsBetween: start and: end) should equal: '78'
]

{ #category : #running }
TwyCharactersSpanDecreasedTests >> textChangeClass [
	^TwyCharactersSpanDecreased 
]
