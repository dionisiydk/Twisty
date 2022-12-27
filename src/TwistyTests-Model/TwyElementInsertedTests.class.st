Class {
	#name : #TwyElementInsertedTests,
	#superclass : #TwyTextChangeAnnouncementTestCase,
	#instVars : [
		'elementBeforeInsertion',
		'elementAfterInsertion',
		'newElement'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyElementInsertedTests >> setUp [ 
	super setUp.
	
	elementBeforeInsertion := Mock new.
	elementAfterInsertion := Mock new.
	newElement := Mock new.
	change elementBeforeInsertion: elementBeforeInsertion.
	change elementAfterInsertion: elementAfterInsertion.
	change newElement: newElement
]

{ #category : #tests }
TwyElementInsertedTests >> testCancelling [

	[
		[ change cancel ]
			should strictly satisfy: 
		[elementBeforeInsertion attachTo: elementAfterInsertion]
	
	] runWithMocks 
]

{ #category : #tests }
TwyElementInsertedTests >> testCorrectingAffectedLayoutSpansWhenInsertionHappensBeforeNotSpanElement [
	
	[ :layoutSpan :builder | 
	
		[ change correctAffectedLayoutSpansStartingAt: layoutSpan by: builder ] 
			should lenient satisfy: 
		[ elementBeforeInsertion isSpan willReturn: false; useArbitrarily.
		layoutSpan moveBorderToStartOf: newElement.
		layoutSpan rightSpan willReturn: #rightSpan; useArbitrarily.
		builder addLayoutCommand: (Instance of: TwyBuildLayoutCommand)] 
	] runWithMocks
]

{ #category : #tests }
TwyElementInsertedTests >> testCorrectingAffectedLayoutSpansWhenInsertionHappensBeforeSpan [
	| command |
	[ :layoutSpan :builder | 
	[ change correctAffectedLayoutSpansStartingAt: layoutSpan by: builder ]
		should lenient
		satisfy: [ elementBeforeInsertion isSpan
				willReturn: true;
				useArbitrarily.
			layoutSpan rightSpan
				willReturn: #rightSpan;
				useArbitrarily.
			(builder addLayoutCommand: Any) will: [ :arg | command := arg ] ].
	command should beInstanceOf: TwyBuildLayoutCommand.
	command leftSpan should be: layoutSpan.
	command rightSpan should be: #rightSpan.
	command elementBeforeInsertion: elementBeforeInsertion.
	command elementAfterInsertion: elementAfterInsertion ] runWithMocks
]

{ #category : #tests }
TwyElementInsertedTests >> testCorrectingPositionOfCursorWhenItIsAtEndOfSpabeBeforeInsertionButElementAfterInsertionHasNoPreviousSpan [

	[:cursor |

		(cursor stub isAtEndOf: elementBeforeInsertion) willReturn: true.
		(elementAfterInsertion stub previousSpanIfAbsent: Any) will: [ :arg | arg value ].
		
		[change correctPositionOf: cursor] should fail.

	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementInsertedTests >> testCorrectingPositionOfCursorWhenItIsAtEndOfSpanBeforeInsertion [

	[:cursor |
		
		[change correctPositionOf: cursor]
			should strictly satisfy: 
		[(cursor isAtEndOf: elementBeforeInsertion) willReturn: true.
		(elementAfterInsertion previousSpanIfAbsent: Any) willReturn: #lastNewSpan.
		cursor moveToEndOf: #lastNewSpan]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementInsertedTests >> testCorrectingPositionOfCursorWhenItIsNotAtEndOfSpanBeforeInsertion [

	[:cursor |

		[change correctPositionOf: cursor]
			should strictly satisfy: 
		[(cursor isAtEndOf: elementBeforeInsertion) willReturn: false]

	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementInsertedTests >> testIsAffectFirstLayoutSpanWhichCoversNotSpanElementBeforeInsertion [

	[:layoutSpan |
		[(change isAffectLayoutSpan: layoutSpan) should be: #result]
			should lenient satisfy: 
		[elementBeforeInsertion isSpan willReturn: false.
		(layoutSpan isFirstSpanWhichCovers: elementBeforeInsertion) willReturn: #result]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementInsertedTests >> testIsAffectLastLayoutSpanWhichCoversSpanBeforeInsertion [

	[:layoutSpan |
		[(change isAffectLayoutSpan: layoutSpan) should be: #result]
			should lenient satisfy: 
		[elementBeforeInsertion isSpan willReturn: true.
		(layoutSpan isLastSpanWhichCovers: elementBeforeInsertion) willReturn: #result]
	
	] runWithMocks 	
	
]

{ #category : #tests }
TwyElementInsertedTests >> testIsAffectLayoutLine [

	[ :layoutLine  |
		[ (change isAffectLayoutLine: layoutLine) should be: #result ]
			should lenient satisfy: 
		[elementBeforeInsertion isSpan willReturn: true.
		(layoutLine isLastLineWhichCovers: elementBeforeInsertion) willReturn: #result]
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementInsertedTests >> testIsAffectLayoutLineWhenInsertionHappensBeforeNotSpanElement [

	[ :layoutLine  |
		[ (change isAffectLayoutLine: layoutLine) should be: #result ]
			should lenient satisfy: 
		[elementBeforeInsertion isSpan willReturn: false.
		(layoutLine isFirstLineWhichCovers: elementAfterInsertion) willReturn: #result]
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementInsertedTests >> testIsAffectTextAfterElement [

	(elementBeforeInsertion stub isBefore: #someElement) willReturn: true; useOnce.

	(change isAffectTextAfterElement: #someElement) should be: false.
	
	(elementBeforeInsertion stub isBefore: #someElement) willReturn: false; useOnce.
	
	(change isAffectTextAfterElement: #someElement) should be: true.
]

{ #category : #tests }
TwyElementInsertedTests >> testIsAffectTextBeforeElement [

	(elementAfterInsertion stub isAfter: #someElement) willReturn: true; useOnce.

	(change isAffectTextBeforeElement: #someElement) should be: false.
	
	(elementAfterInsertion stub isAfter: #someElement) willReturn: false; useOnce.
	
	(change isAffectTextBeforeElement: #someElement) should be: true.
]

{ #category : #tests }
TwyElementInsertedTests >> testIsAfterTextCursorWhichBeforeNewAlement [

	| cursor |
	cursor := Mock new.
	(cursor stub isBeforeElement: newElement) willReturn: #result.
	
	(change isAfter: cursor) should be: #result
]

{ #category : #tests }
TwyElementInsertedTests >> testIsBeforeAnotherChange [

	| anotherChange |
	anotherChange := Mock new.
	(anotherChange stub isAffectTextAfterElement: elementBeforeInsertion) willReturn: #result .

	(change isBeforeChange: anotherChange) should be: #result
]

{ #category : #tests }
TwyElementInsertedTests >> testIsEmbodyAnotherTextChangeWhenItHappensBetweenInsertionBounds [

	| anotherTextChange |
	anotherTextChange := Mock new.
	(anotherTextChange stub isAffectTextAfterElement: elementBeforeInsertion) willReturn: true.
	(anotherTextChange stub isAffectTextBeforeElement: elementAfterInsertion) willReturn: true.
	
	(change isEmbody: anotherTextChange) should be: true
]

{ #category : #tests }
TwyElementInsertedTests >> testIsNotAffectTextAtAnyPosition [

	(change isAffectTextAt: Any) should be: false
]

{ #category : #tests }
TwyElementInsertedTests >> testIsNotEmbodyAnotherTextChangeWhenItHappensAfterRightInsertionBound [

	| anotherTextChange |
	anotherTextChange := Mock new.
	(anotherTextChange stub isAffectTextAfterElement: elementBeforeInsertion) willReturn: true.
	(anotherTextChange stub isAffectTextBeforeElement: elementAfterInsertion) willReturn: false.
	
	(change isEmbody: anotherTextChange) should be: false
]

{ #category : #tests }
TwyElementInsertedTests >> testIsNotEmbodyAnotherTextChangeWhenItHappensBeforeLeftInsertionBound [

	| anotherTextChange |
	anotherTextChange := Mock new.
	(anotherTextChange stub isAffectTextAfterElement: elementBeforeInsertion) willReturn: false.
	(anotherTextChange stub isAffectTextBeforeElement: elementAfterInsertion) willReturn: true.
	
	(change isEmbody: anotherTextChange) should be: false
]

{ #category : #running }
TwyElementInsertedTests >> textChangeClass [
	^TwyElementInserted
]
