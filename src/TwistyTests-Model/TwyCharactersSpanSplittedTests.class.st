Class {
	#name : #TwyCharactersSpanSplittedTests,
	#superclass : #TwyTextChangeAnnouncementTestCase,
	#instVars : [
		'separatedSpan',
		'splittedSpan'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyCharactersSpanSplittedTests >> setUp [ 

	super setUp.
	
	separatedSpan := Mock new.
	splittedSpan := Mock new.
	change 
		splittedSpan: splittedSpan;
		separatedSpan: separatedSpan;
		splitPosition: 5.
]

{ #category : #tests }
TwyCharactersSpanSplittedTests >> testCorrectingPositionOfCursorWhenSplitHappensAfterIt [

	[:cursor |
		change splitPosition: 5.
		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: splittedSpan) willReturn: true.  
		cursor spanPosition willReturn: 4; useArbitrarily]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyCharactersSpanSplittedTests >> testCorrectingPositionOfCursorWhenSplitHappensBeforeIt [

	[:cursor |
		change splitPosition: 3.

		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: splittedSpan) willReturn: true. 
		 cursor spanPosition willReturn: 5; useArbitrarily.
		cursor moveToSpan: separatedSpan at: 2]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyCharactersSpanSplittedTests >> testCorrectingPositionOfCursorWhichAtAnotherSpan [

	[:cursor |
		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: splittedSpan) willReturn: false]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyCharactersSpanSplittedTests >> testCorrectingPositionOfCursorWhichAtSplitPoint [

	[:cursor |
		change splitPosition: 3.

		[change correctPositionOf: cursor]
			should lenient satisfy: 
		[(cursor isAt: splittedSpan) willReturn: true. 
		 cursor spanPosition willReturn: 3; useArbitrarily.
		cursor moveToSpan: separatedSpan at: 0]
	
	] runWithMocks 	
	
]

{ #category : #running }
TwyCharactersSpanSplittedTests >> textChangeClass [
	^TwyCharactersSpanSplitted
]
