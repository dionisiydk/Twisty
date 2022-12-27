Class {
	#name : #TwyCharactersSpanIncreasedTests,
	#superclass : #TwyElementChangedTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwyCharactersSpanIncreasedTests >> testCancelling [

	[
		change insertionPosition: 10.
		change insertedCharacters: '12345'.
		[ change cancel ]
			should strictly satisfy: 
		[ element deleteFrom: 10 to: 10 + 5]
	
	] runWithMocks 
]

{ #category : #tests }
TwyCharactersSpanIncreasedTests >> testCorrectingPositionOfCursorWhenInsertionHappensAfterIt [

	[:cursor |
		change insertionPosition: 3.

		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: element) willReturn: true. 
		cursor spanPosition willReturn: 2; useArbitrarily]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyCharactersSpanIncreasedTests >> testCorrectingPositionOfCursorWhenInsertionHappensBeforeIt [

	[:cursor |
		change insertionPosition: 3.
		change insertedCharacters: '12345'.

		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: element) willReturn: true. 
		cursor spanPosition willReturn: 6; useArbitrarily.
		cursor moveForward: 5]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyCharactersSpanIncreasedTests >> testCorrectingPositionOfCursorWhichAtAnotherSpan [

	[:cursor |
		change insertionPosition: 3.

		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[ (cursor isAt: element) willReturn: false]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyCharactersSpanIncreasedTests >> testCorrectingPositionOfCursorWhichAtInsertionPoint [

	[:cursor |
		change insertionPosition: 3.
		change insertedCharacters: '12345'.

		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: element) willReturn: true.
		cursor spanPosition willReturn: 3; useArbitrarily.
		cursor moveForward: 5]
	
	] runWithMocks
]

{ #category : #running }
TwyCharactersSpanIncreasedTests >> textChangeClass [
	^TwyCharactersSpanIncreased 
]
