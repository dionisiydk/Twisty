Class {
	#name : #TwyActiveTextCursorTests,
	#superclass : #TwyTextCursorTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwyActiveTextCursorTests >> testApplyingAttributeWhenEndCursorIsAtSpanEnd [

	[:endCursor :separatedSpan :eachSpan :lastSpan |
		[ cursor applyAttribute: #attribute upTo: endCursor]
			should strictly satisfy: 
		[(endCursor isAtSamePositionWith: cursor) willReturn: false.
		(span isEndPosition: spanPosition) willReturn: false; useArbitrarily.
		(span isStartPosition: spanPosition) willReturn: true; useArbitrarily.
		endCursor isAtSpanEnd willReturn: true; useArbitrarily.
		endCursor isAtSpanStart willReturn: false; useArbitrarily.
		endCursor span willReturn: lastSpan; useArbitrarily.
		(span withYourselfForwardDo: Any while: Any) will: [:action :condition | 
			(condition value: #notLastSpan) should be: true.
			(condition value: lastSpan) should be: false.
			action value: eachSpan].
		eachSpan applyAttribute: #attribute.
		lastSpan applyAttribute: #attribute]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testApplyingAttributeWhenEndCursorIsAtSpanStart [

	[:endCursor :separatedSpan :eachSpan :lastSpan :lastPreviousSpan  |
		[ cursor applyAttribute: #attribute upTo: endCursor]
			should strictly satisfy: 
		[(endCursor isAtSamePositionWith: cursor) willReturn: false.
		lastSpan previous willReturn: lastPreviousSpan.
		(span isEndPosition: spanPosition) willReturn: false; useArbitrarily.
		(span isStartPosition: spanPosition) willReturn: true; useArbitrarily.
		endCursor isAtSpanEnd willReturn: false; useArbitrarily.
		endCursor isAtSpanStart willReturn: true; useArbitrarily.
		endCursor span willReturn: lastSpan; useArbitrarily.		
		(span withYourselfForwardDo: Any while: Any) will: [:action :condition | 
			(condition value: #notLastSpan) should be: true.
			(condition value: lastPreviousSpan) should be: false.
			action value: eachSpan].
		eachSpan applyAttribute: #attribute.
		lastPreviousSpan applyAttribute: #attribute]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testApplyingAttributeWhenStartAndEndAreAtMiddleOfSpans [

	[:endCursor :separatedSpan :eachSpan :lastSpan |
		[ cursor applyAttribute: #attribute upTo: endCursor]
			should strictly satisfy: 
		[(endCursor isAtSamePositionWith: cursor) willReturn: false.
		(span isEndPosition: spanPosition) willReturn: false; useArbitrarily.
		(span isStartPosition: spanPosition) willReturn: false; useArbitrarily.
		span splitAt: spanPosition.
		span next willReturn: separatedSpan.
		endCursor isAtSpanEnd willReturn: false; useArbitrarily.
		endCursor isAtSpanStart willReturn: false; useArbitrarily.
		endCursor span willReturn: lastSpan; useArbitrarily.
		endCursor splitSpan.		
		(separatedSpan withYourselfForwardDo: Any while: Any) will: [:action :condition | 
			(condition value: #notLastSpan) should be: true.
			(condition value: lastSpan) should be: false.
			action value: eachSpan].
		eachSpan applyAttribute: #attribute.
		lastSpan applyAttribute: #attribute]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testApplyingAttributeWhenStartAtSamePositionWithEndAndSpanIsEmpty [

	[:endCursor :separatedSpan |
		[ cursor applyAttribute: #attribute upTo: endCursor]
			should strictly satisfy: 
		[(endCursor isAtSamePositionWith: cursor) willReturn: true.
		span isEmpty willReturn: true.
		span applyAttribute: #attribute]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testApplyingAttributeWhenStartAtSamePositionWithEndAndSpanIsNotEmpty [

	[:endCursor |
		[ cursor applyAttribute: #attribute upTo: endCursor]
			should strictly satisfy: 
		[(endCursor isAtSamePositionWith: cursor) willReturn: true.
		span isEmpty willReturn: false]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testApplyingAttributeWhenStartCursorIsAtSpanEnd [

	[:endCursor :separatedSpan :eachSpan :lastSpan :startNextSpan |
		[ cursor applyAttribute: #attribute upTo: endCursor]
			should strictly satisfy: 
		[(endCursor isAtSamePositionWith: cursor) willReturn: false.
		(span isEndPosition: spanPosition) willReturn: true; useArbitrarily.
		(span isStartPosition: spanPosition) willReturn: false; useArbitrarily.
		span next willReturn: startNextSpan.
		endCursor isAtSpanEnd willReturn: false; useArbitrarily.
		endCursor isAtSpanStart willReturn: false; useArbitrarily.
		endCursor span willReturn: lastSpan; useArbitrarily.
		endCursor splitSpan.		
		(startNextSpan withYourselfForwardDo: Any while: Any) will: [:action :condition | 
			action value: eachSpan].
		eachSpan applyAttribute: #attribute.
		lastSpan applyAttribute: #attribute]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testApplyingAttributeWhenStartCursorIsAtSpanStart [

	[:endCursor :separatedSpan :eachSpan :lastSpan |
		[ cursor applyAttribute: #attribute upTo: endCursor]
			should strictly satisfy: 
		[(endCursor isAtSamePositionWith: cursor) willReturn: false.
		(span isEndPosition: spanPosition) willReturn: false; useArbitrarily.
		(span isStartPosition: spanPosition) willReturn: true; useArbitrarily.
		endCursor isAtSpanEnd willReturn: false; useArbitrarily.
		endCursor isAtSpanStart willReturn: false; useArbitrarily.
		endCursor span willReturn: lastSpan; useArbitrarily.
		endCursor splitSpan.
		(span withYourselfForwardDo: Any while: Any) will: [:action :condition | 
			action value: eachSpan].
		eachSpan applyAttribute: #attribute.
		lastSpan applyAttribute: #attribute]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testApplyingParagraphAttribute [

	[:endCursor :endSpan :eachSpan :eachLine :firstLine |
		[ cursor applyParagraphAttribute: #attribute upTo: endCursor]
			should strictly satisfy: 
		[span applyParagraphAttribute: #attribute.
		(endCursor isAtSameSpanWith: cursor) willReturn: false.
		endCursor span willReturn: endSpan.
		(endSpan backwardDo: Any while: Any) will: [:action :condition |
			action value: eachSpan; value: eachLine.
			(condition value: eachSpan) should be: true.
			(condition value: span) should be: false ].
		eachSpan isSpan willReturn: true.
		eachLine isSpan willReturn: false.
		eachLine applyAttribute: #attribute]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testApplyingParagraphAttributeWhenEndCursorIsAtSameSpan [

	[:endCursor |
		[ cursor applyParagraphAttribute: #attribute upTo: endCursor]
			should strictly satisfy: 
		[span applyParagraphAttribute: #attribute.
		(endCursor isAtSameSpanWith: cursor) willReturn: true]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testConvertingToActiveCursorShouldReturnItself [

	cursor asActiveCursor should be: cursor
]

{ #category : #tests }
TwyActiveTextCursorTests >> testConvertingToPassiveCursor [
	
	| passiveCursor |
	passiveCursor := cursor asPassiveCursor.
	
	passiveCursor should beReturnedFrom: [ span newPassiveCursor ].
	passiveCursor should receive spanPosition: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testCopy [

	| cursorCopy |
	cursorCopy := cursor copy.

	cursorCopy should beReturnedFrom: [ span newActiveCursor ].
	cursorCopy should receive moveTo: cursor
]

{ #category : #tests }
TwyActiveTextCursorTests >> testDeleteBackSideOfSpan [

	cursor deleteBackSideOfSpan.
			
	span should receive deleteAllBefore: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testDeleteForwardSideOfSpan [

	cursor deleteForwardSideOfSpan.
	
	span should receive deleteAllAfter: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testDeleteUpToAnotherCursorWhenTheyAtSameSpan [

	| anotherCursor |
	anotherCursor := Mock new.
	(anotherCursor stub isAtSameSpanWith: cursor) willReturn: true.
	anotherCursor stub spanPosition willReturn: #anotherSpanPosition.
		
	cursor deleteUpTo: anotherCursor.

	span should receive deleteFrom: spanPosition to: #anotherSpanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testDeleteUpToAnotherCursorWhenTheyNotAtSameSpan [

	| anotherCursor |
	anotherCursor := Mock new.
	(anotherCursor stub isAtSameSpanWith: cursor) willReturn: false.
	anotherCursor stub span willReturn: #anotherSpan.
		
	cursor deleteUpTo: anotherCursor.
		
	[span attachTo: #anotherSpan.
	span deleteAllAfter: spanPosition.
	anotherCursor deleteBackSideOfSpan] should beDone
]

{ #category : #tests }
TwyActiveTextCursorTests >> testDetachTextModel [

	cursor detachText.
	
	text should receive unsubscribe: cursor
]

{ #category : #tests }
TwyActiveTextCursorTests >> testGettingLineNumber [

	cursor lineNumber should beReturnedFrom: [ span lineNumber ]

]

{ #category : #tests }
TwyActiveTextCursorTests >> testGettingLinePosition [

	span stub offsetFromLineStart willReturn: 10.
	
	cursor linePosition should equal: 10 + spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testGettingTextPosition [

	span stub offsetFromTextStart willReturn: 10.
	
	cursor textPosition should equal: 10 + spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testHasAttribute [

	(cursor hasAttribute: #attributeClass) should beReturnedFrom: [ span hasAttribute: #attributeClass]
]

{ #category : #tests }
TwyActiveTextCursorTests >> testInsertionTextModel [

	[ :textCompatible :anotherText :startSpan |
		textCompatible stub asTwyText willReturn: anotherText.
		anotherText stub firstSpan willReturn: startSpan.
		
		cursor insert: textCompatible.
		
		startSpan should receive insertInto: span at: spanPosition
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAfterAnotherCursorWhenItAtDifferentSpan [

	| anotherCursor |
	
	anotherCursor := Mock new.
	anotherCursor stub span willReturn: #differentSpan.
	(span stub isAfter: #differentSpan) willReturn: #result.
	anotherCursor stub spanPosition willReturn: Any.
	
	(cursor isAfter: anotherCursor) should be: #result.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAfterAnotherCursorWhenItAtSameSpan [

	| anotherCursor |
	
	anotherCursor := Mock new.
	anotherCursor stub span willReturn: span.
	anotherCursor stub spanPosition willReturn: spanPosition - 1.
	
	(cursor isAfter: anotherCursor) should be: true.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAfterElement [

	(cursor isAfterElement: #anotherElement) should beReturnedFrom: [ span isAfter: #anotherElement ]

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAfterOrAtPositionAtDIfferentSpanWhichPlacedBeforeCursorSpan [

	| anotherSpan |
	
	anotherSpan := Mock new.
	(span stub isAfter: anotherSpan) willReturn: #result.
	
	(cursor isAfterOrAtPosition: Any atSpan: anotherSpan) should be: #result.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAfterOrAtPositionAtSameSpanAtGivenPosition [

	cursor spanPosition: 10.
	
	(cursor isAfterOrAtPosition: 10 atSpan: span) should be: true.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAfterOrAtPositionAtSameSpanWhenPositionIsBeforeCursorPosition [

	cursor spanPosition: 10.
	
	(cursor isAfterOrAtPosition: 9 atSpan: span) should be: true.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAfterPositionAtDIfferentSpanWhichPlacedBeforeCursorSpan [

	| anotherSpan |
	
	anotherSpan := Mock new.
	(span stub isAfter: anotherSpan) willReturn: #result.
	
	(cursor isAfterPosition: Any atSpan: anotherSpan) should be: #result.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAfterPositionAtSameSpanWhenPositionIsBeforeCursorPosition [

	cursor spanPosition: 10.
	
	(cursor isAfterPosition: 9 atSpan: span) should be: true.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtEndOfGivenSpanWhenItIsOwnSpanAndCursorIsAtSpanEnd [

	(cursor isAtEndOf: span) should beReturnedFrom: [span isEndPosition: spanPosition]
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtEndWhenAtLastSpanAndAtSpanEnd [

	span stub isLast willReturn: true.
	(span stub isEndPosition: spanPosition) willReturn: true.
	
	cursor isAtEnd should be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtLineEndWhenAtLineLastSpanAndAtSpanEnd [

	span stub isLastAtLine willReturn: true.
	(span stub isEndPosition: spanPosition) willReturn: true.
	
	cursor isAtLineEnd should be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtLineStartWhenAtLineFirstSpanAndAtSpanStart [

	span stub isFirstAtLine willReturn: true.
	(span stub isStartPosition: spanPosition) willReturn: true.
	
	cursor isAtLineStart should be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtSamePositionWithAnotherCursorWhenAtSameSpanAndSpanPosition [

	| anotherCursor |
	anotherCursor := Mock new.
	(anotherCursor stub isAtSameSpanWith: cursor) willReturn: true.
	anotherCursor stub spanPosition willReturn: spanPosition.
	
	(cursor isAtSamePositionWith: anotherCursor) should be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtSamePositionWithAnotherCursorWhichAtEndOfPreviousSpanAndCursorIsAtStart [

	[:anotherCursor :previousElement |
		[(cursor isAtSamePositionWith: anotherCursor) should be: true ]
			should strictly satisfy: 
		[ (anotherCursor isAtSameSpanWith: cursor) willReturn: false.
		(span isStartPosition: spanPosition) willReturn: true.
		span previous willReturn: previousElement.
		(anotherCursor isAtEndOf: previousElement) willReturn: true]
			
		
	] runWithMocks
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtSamePositionWithAnotherCursorWhichAtStartOfNextSpanAndCursorIsAtEnd [

	[:anotherCursor |
		[(cursor isAtSamePositionWith: anotherCursor) should be: true ]
			should strictly satisfy: 
		[ (anotherCursor isAtSameSpanWith: cursor) willReturn: false.
		(span isStartPosition: spanPosition) willReturn: false.
		(span isEndPosition: spanPosition) willReturn: true.
		span next willReturn: #nextElement.
		(anotherCursor isAtStartOf: #nextElement) willReturn: true]
			
		
	] runWithMocks
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtSameSpanWithAnotherCursor [

	| anotherCursor |
	anotherCursor := TwyTextCursor new.
	anotherCursor span: span.
	
	(cursor isAtSameSpanWith: anotherCursor) should be: true.
	
	anotherCursor span: TwySpan new.

	(cursor isAtSameSpanWith: anotherCursor) should be: false.
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtSpan [

	| anotherSpan |
	anotherSpan := Mock new.
	(span stub isCoversSpan: anotherSpan) willReturn: false.
	
	(cursor isAt: anotherSpan) should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtSpanAfterAnotherCursorWhenAtSameSpanAndAtGreaterPosition [

	| anotherCursor |
	anotherCursor := Mock new.
	anotherCursor stub span willReturn: span.
	anotherCursor stub spanPosition willReturn: cursor spanPosition - 1.
	
	(cursor isAtSpanAfter: anotherCursor) should be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtSpanBeforeAnotherCursorWhenAtSameSpanAndAtLesserPosition [

	| anotherCursor |
	anotherCursor := Mock new.
	anotherCursor stub span willReturn: span.
	anotherCursor stub spanPosition willReturn: cursor spanPosition + 1.
	
	(cursor isAtSpanBefore: anotherCursor) should be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtSpanEnd [

	cursor isAtSpanEnd should beReturnedFrom: [ span isEndPosition: spanPosition ]
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtSpanStart [

	cursor isAtSpanStart should beReturnedFrom: [ span isStartPosition: spanPosition ]
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtStartOfGivenSpanWhenItIsOwnSpanAndCursorIsAtSpanStart [

	(cursor isAtStartOf: span) should beReturnedFrom: [ span isStartPosition: spanPosition ]
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsAtStartWhenAtFirstSpanAndAtSpanStart [

	span stub isFirst willReturn: true.
	(span stub isStartPosition: spanPosition) willReturn: true.
	
	cursor isAtStart should be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsBeforeAnotherCursorWhenItAtDifferentSpan [

	| anotherCursor |
	
	anotherCursor := Mock new.
	anotherCursor stub span willReturn: #differentSpan.
	(span stub isBefore: #differentSpan) willReturn: #result.
	anotherCursor stub spanPosition willReturn: Any.
	
	(cursor isBefore: anotherCursor) should be: #result.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsBeforeAnotherCursorWhenItAtSameSpan [

	| anotherCursor |
	
	anotherCursor := Mock new.
	anotherCursor stub span willReturn: span.
	anotherCursor stub spanPosition willReturn: spanPosition + 1.
	
	(cursor isBefore: anotherCursor) should be: true.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsBeforeElement [
	
	(cursor isBeforeElement: #anotherElement) should beReturnedFrom: [ span isBefore: #anotherElement ]
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsBeforeOrAtPositionAtDIfferentSpanWhichPlacedAfterCursorSpan [

	| anotherSpan |
	
	anotherSpan := Mock new.
	(span stub isBefore: anotherSpan) willReturn: #result.
	
	(cursor isBeforeOrAtPosition: Any atSpan: anotherSpan) should be: #result.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsBeforeOrAtPositionAtSameSpanAtGivenPosition [

	cursor spanPosition: 10.
	
	(cursor isBeforeOrAtPosition: 10 atSpan: span) should be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsBeforeOrAtPositionAtSameSpanWhenPositionIsAfterCursorPosition [

	cursor spanPosition: 10.
	
	(cursor isBeforeOrAtPosition: 11 atSpan: span) should be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsBeforePositionAtDIfferentSpanWhichPlacedAfterCursorSpan [

	| anotherSpan |
	
	anotherSpan := Mock new.
	(span stub isBefore: anotherSpan) willReturn: #result.
	
	(cursor isBeforePosition: Any atSpan: anotherSpan) should be: #result.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsBeforePositionAtSameSpanWhenPositionIsAfterCursorPosition [

	cursor spanPosition: 10.
	
	(cursor isBeforePosition: 11 atSpan: span) should be: true.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsInsideLayoutSpan [
	
	| layoutSpan |
	layoutSpan := Mock new.
	(layoutSpan stub contains: cursor) willReturn: #result.
	
	(cursor isInsideLayoutSpan: layoutSpan) should be: #result
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAfterOrAtPositionAtSameSpanWhenPositionIsAfterCursorPosition [

	cursor spanPosition: 10.
	
	(cursor isAfterOrAtPosition: 11 atSpan: span) should be: false.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAfterPositionAtSameSpanWhenPositionIsAfterCursorPosition [

	cursor spanPosition: 10.
	
	(cursor isAfterPosition: 11 atSpan: span) should be: false.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAfterSamePositionAtSameSpan [

	cursor spanPosition: 10.
	
	(cursor isAfterPosition: 10 atSpan: span) should be: false.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtEndOfGivenSpanWhenItIsNotOwnSpan [

	(cursor isAtEndOf: #anotherSpan) should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtEndOfGivenSpanWhenItIsOwnSpanButCursorIsNotAtSpanEnd [

	(cursor isAtEndOf: span) should beReturnedFrom: [ span isEndPosition: spanPosition ]
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtEndWhenAtLastSpanButNotAtSpanEnd [

	span stub isLast willReturn: true.
	(span stub isEndPosition: spanPosition) willReturn: false.
	
	cursor isAtEnd should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtEndWhenNotAtLastSpanButAtSpanEnd [

	span stub isLast willReturn: false.
	(span stub isEndPosition: spanPosition) willReturn: true.
	
	cursor isAtEnd should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtLineEndWhenAtLineLastSpanButNotAtSpanEnd [

	span stub isLastAtLine willReturn: true.
	(span stub isEndPosition: spanPosition) willReturn: false.
	
	cursor isAtLineEnd should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtLineEndWhenNotAtLineLastSpanButAtSpanEnd [

	span stub isLastAtLine willReturn: false.
	(span stub isEndPosition: spanPosition) willReturn: true.
	
	cursor isAtLineEnd should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtLineStartWhenAtLineFirstSpanButNotAtSpanStart [

	span stub isFirstAtLine willReturn: true.
	(span stub isStartPosition: spanPosition) willReturn: false.
	
	cursor isAtLineStart should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtLineStartWhenNotAtLineFirstSpanButAtSpanStart [

	span stub isFirstAtLine willReturn: false.
	(span stub isStartPosition: spanPosition) willReturn: true.
	
	cursor isAtLineStart should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtSamePositionWithAnotherCursorWhenAtSameSpanButAtDifferentSpanPosition [

	| anotherCursor |
	anotherCursor := Mock new.
	(anotherCursor stub isAtSameSpanWith: cursor) willReturn: true.
	anotherCursor stub spanPosition willReturn: spanPosition + 1.
		
	(cursor isAtSamePositionWith: anotherCursor) should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtSamePositionWithAnotherCursorWhichAtDifferentSpanAndCursorNotAtStartOrEnd [

	[:anotherCursor :previousElement |
		[(cursor isAtSamePositionWith: anotherCursor) should be: false ]
			should strictly satisfy: 
		[ (anotherCursor isAtSameSpanWith: cursor) willReturn: false.
		(span isStartPosition: spanPosition) willReturn: false.
		(span isEndPosition: spanPosition) willReturn: false.]			
		
	] runWithMocks
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtSamePositionWithAnotherCursorWhichAtNotStartOfNextSpanAndCursorIsAtEnd [

	[:anotherCursor |
		[(cursor isAtSamePositionWith: anotherCursor) should be: false ]
			should strictly satisfy: 
		[ (anotherCursor isAtSameSpanWith: cursor) willReturn: false.
		(span isStartPosition: spanPosition) willReturn: false.
		(span isEndPosition: spanPosition) willReturn: true.
		span next willReturn: #nextElement.
		(anotherCursor isAtStartOf: #nextElement) willReturn: false]
			
		
	] runWithMocks
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtSamePositionWithAnotherCursorWhichNotAtEndOfPreviousSpanAndCursorIsAtStart [

	[:anotherCursor :previousElement |
		[(cursor isAtSamePositionWith: anotherCursor) should be: false ]
			should strictly satisfy: 
		[ (anotherCursor isAtSameSpanWith: cursor) willReturn: false.
		(span isStartPosition: spanPosition) willReturn: true.
		span previous willReturn: previousElement.
		(anotherCursor isAtEndOf: previousElement) willReturn: false.
		(span isEndPosition: spanPosition) willReturn: false.]
			
		
	] runWithMocks
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtSpanAfterAnotherCursorWhenItAtDifferentSpan [

	| anotherCursor |
	anotherCursor := Mock new.
	anotherCursor stub span willReturn: #anotherSpan.
	anotherCursor stub spanPosition willReturn: cursor spanPosition - 1.
	
	(cursor isAtSpanAfter: anotherCursor) should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtSpanAfterAnotherCursorWhenItAtSameSpanButWithLesserPosition [

	| anotherCursor |
	anotherCursor := Mock new.
	anotherCursor stub span willReturn: span.
	anotherCursor stub spanPosition willReturn: cursor spanPosition + 1.
	
	(cursor isAtSpanAfter: anotherCursor) should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtSpanBeforeAnotherCursorWhenItAtDifferentSpan [

	| anotherCursor |
	anotherCursor := Mock new.
	anotherCursor stub span willReturn: #anotherSpan.
	anotherCursor stub spanPosition willReturn: cursor spanPosition - 1.
	
	(cursor isAtSpanBefore: anotherCursor) should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtSpanBeforeAnotherCursorWhenItAtSameSpanButAtGreaterPosition [

	| anotherCursor |
	anotherCursor := Mock new.
	anotherCursor stub span willReturn: span.
	anotherCursor stub spanPosition willReturn: cursor spanPosition - 1.
	
	(cursor isAtSpanBefore: anotherCursor) should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtStartOfGivenSpanWhenItIsNotOwnSpan [

	(cursor isAtStartOf: #anotherSpan) should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtStartOfGivenSpanWhenItIsOwnSpanButCursorIsNotAtSpanStart [

	(cursor isAtStartOf: span) should beReturnedFrom: [ span isStartPosition: spanPosition ]
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtStartWhenAtFirstSpanButNotAtSpanStart [

	span stub isFirst willReturn: true.
	(span stub isStartPosition: spanPosition) willReturn: false.
	
	cursor isAtStart should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotAtStartWhenNotAtFirstSpanButAtSpanStart [

	span stub isFirst willReturn: false.
	(span stub isStartPosition: spanPosition) willReturn: true.
	
	cursor isAtStart should be: false
]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotBeforeOrAtPositionAtSameSpanWhenPositionIsBeforeCursorPosition [

	cursor spanPosition: 10.
	
	(cursor isBeforeOrAtPosition: 9 atSpan: span) should be: false.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotBeforePositionAtSameSpanWhenPositionIsBeforeCursorPosition [

	cursor spanPosition: 10.
	
	(cursor isBeforePosition: 9 atSpan: span) should be: false.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testIsNotBeforeSamePositionAtSameSpan [

	cursor spanPosition: 10.
	
	(cursor isBeforePosition: 10 atSpan: span) should be: false.

]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveBackwardToSpanWhichSatisfiedConditionWhenCurrentPositionAlreadyAtSuchSpan [

	| wasMoved |
	text := ('firstX', String cr, 'lastX') asTwyText.
		
	cursor := text newPassiveCursor.
	cursor moveToTextEnd.

	wasMoved := cursor moveBackwardToSpanWhich: [ :eachSpan | eachSpan contents includes: $X].
	
	wasMoved should be: true.
	cursor span should be: text firstSpan
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveBackwardToSpanWhichSatisfiedConditionWhenCurrentPositionInsideAnotherSpan [

	| wasMoved |
	text := ('first', String cr, 'last') asTwyText.
		
	cursor := text newPassiveCursor.
	cursor moveToTextEnd.

	wasMoved := cursor moveBackwardToSpanWhich: [ :eachSpan | eachSpan contents = 'first'].
	
	wasMoved should be: true.
	cursor span should be: text firstSpan
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveBackwardToSpanWhichSatisfiedConditionWhenNoSuchSpansExists [

	| wasMoved |
	text := ('firstX', String cr, 'lastX') asTwyText.
		
	cursor := text newPassiveCursor.
	cursor moveToTextEnd.

	wasMoved := cursor moveBackwardToSpanWhich: [ :eachSpan | false] .
	
	wasMoved should be: false.
	cursor isAtEnd should be: true.
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveBackwardWhenAfterStartOfSpan [

	(span stub isStartPosition: spanPosition) willReturn: false.

	cursor moveBackward.
	
	cursor span should be: span.
	cursor spanPosition should be: spanPosition - 1
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveBackwardWhenAtStartOfSpanAndPreviousElementIsNotSpan [

	[:previousSpan | 
		[ cursor moveBackward]
			should strictly satisfy: 
		[ (span isStartPosition: spanPosition) willReturn: true.
		(span previousSpanIfAbsent: Any) willReturn: previousSpan.
		(previousSpan isAttachedTo: span) willReturn: false.
		previousSpan endPosition willReturn: 20; useArbitrarily].
	
		cursor span should be: previousSpan.
		cursor spanPosition should be: 20
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveBackwardWhenAtStartOfSpanAndPreviousElementIsSpan [

	[:previousSpan | 
		[ cursor moveBackward]
			should strictly satisfy: 
		[ (span isStartPosition: spanPosition) willReturn: true.
		(span previousSpanIfAbsent: Any) willReturn: previousSpan.
		(previousSpan isAttachedTo: span) willReturn: true.
		previousSpan endPosition willReturn: 20; useArbitrarily].
	
		cursor span should be: previousSpan.
		cursor spanPosition should be: 19
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveBackwardWhenAtStartOfSpanAndTherIsNoPreviousSpan [

	(span stub isStartPosition: spanPosition) willReturn: true.
	(span stub previousSpanIfAbsent: Any) will: [:arg | arg value].
		
	cursor moveBackward.
	
	cursor span should be: span.
	cursor spanPosition should be: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveForwardToItemWhichSatisfiedCondition [

	| endCursor |
	text := '12345' asTwyText.
	
	cursor := text newPassiveCursor.
	endCursor := text newPassiveCursor.
	endCursor moveToTextEnd.
	
	cursor moveForwardToItemWhich: [ :eachChar | eachChar = $3 ] butNotFarThan: endCursor.
	
	cursor spanPosition should be: 2
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveForwardToItemWhichSatisfiedConditionWhenItExistsAfterTextCr [

	| endCursor |
	text := ('12345', String cr, '678') asTwyText.
	
	cursor := text newPassiveCursor.
	endCursor := text newPassiveCursor.
	endCursor moveToTextEnd.
	
	cursor moveForwardToItemWhich: [ :eachChar | eachChar = $7 ] butNotFarThan: endCursor.
	
	cursor textPosition should be: 7
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveForwardToItemWhichSatisfiedConditionWhenItExistsOnlyAfterEndCursor [

	| endCursor |
	text := '12345' asTwyText.
	
	cursor := text newPassiveCursor.
	endCursor := text newPassiveCursor.
	endCursor spanPosition:  3.
	
	cursor moveForwardToItemWhich: [ :eachChar | eachChar = $4 ] butNotFarThan: endCursor.
	
	cursor spanPosition should be: 3
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveForwardToItemWhichSatisfiedConditionWhenItIsCurrentItem [

	| endCursor |
	text := '12345' asTwyText.
	
	cursor := text newPassiveCursor.
	endCursor := text newPassiveCursor.
	endCursor moveToTextEnd.
	
	cursor moveForwardToItemWhich: [ :eachChar | eachChar = $1 ] butNotFarThan: endCursor.
	
	cursor textPosition should be: 0
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveForwardToItemWhichSatisfiedConditionWhenThereIsNothing [

	| endCursor |
	text := '12345' asTwyText.
	
	cursor := text newPassiveCursor.
	endCursor := text newPassiveCursor.
	endCursor moveToTextEnd.
	
	cursor moveForwardToItemWhich: [ :eachChar | false ] butNotFarThan: endCursor.
	
	cursor spanPosition should be: 5
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveForwardWhenAtEndOfSpanAndNextElementIsNotSpan [

	[ :nextSpan |
		[ cursor moveForward]
			should strictly satisfy: 
		[ (span isEndPosition: spanPosition) willReturn: true.
		(span nextSpanIfAbsent: Any) willReturn: nextSpan.
		(nextSpan isAttachedTo: span) willReturn: false.
		nextSpan startPosition willReturn: 0; useArbitrarily].
	
		cursor span should be: nextSpan.
		cursor spanPosition should be: 0
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveForwardWhenAtEndOfSpanAndNextElementIsSpan [

	[ :nextSpan |
		[ cursor moveForward]
			should strictly satisfy: 
		[ (span isEndPosition: spanPosition) willReturn: true.
		(span nextSpanIfAbsent: Any) willReturn: nextSpan.
		(nextSpan isAttachedTo: span) willReturn: true.
		nextSpan startPosition willReturn: 0.
		nextSpan endPosition willReturn: 20].
	
		cursor span should be: nextSpan.
		cursor spanPosition should be: 1
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveForwardWhenAtEndOfSpanAndThereIsNoNextSpan [

	(span stub isEndPosition: spanPosition) willReturn: true.
	(span stub nextSpanIfAbsent: Any) will: [:arg | arg value].
		
	cursor moveForward.
	
	cursor span should be: span.
	cursor spanPosition should be: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveForwardWhenBeforeEndOfSpan [

	(span stub isEndPosition: spanPosition) willReturn: false.
	
	cursor moveForward.

	cursor span should be: span.
	cursor spanPosition should be: spanPosition + 1
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToEndOfPreviousSpan [

	| previousSpan |
	previousSpan := Mock new.
	(span stub previousSpanIfAbsent: Any) willReturn: previousSpan.
	previousSpan stub endPosition willReturn: 20.
		
	cursor moveToEndOfPreviousSpan.
		
	cursor span should be: previousSpan.
	cursor spanPosition should be: 20
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToEndOfPreviousSpanWhenItAbsent [

	(span stub previousSpanIfAbsent: Any) will: [:arg | arg value]..
	
	cursor moveToEndOfPreviousSpan.
	
	cursor span should be: span.
	cursor spanPosition should be: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToEndOfSpan [

	| newSpan |
	newSpan := Mock new.
	newSpan stub endPosition willReturn: 20.
	
	cursor moveToEndOf: newSpan.
	
	cursor span should be: newSpan.
	cursor spanPosition should be: 20
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToLineEnd [

	| lineEndSpan |
	lineEndSpan := Mock new.
	span stub lineEndSpan willReturn: lineEndSpan.
	lineEndSpan stub endPosition willReturn: 10.
		
	cursor moveToLineEnd.

	cursor span should be: lineEndSpan.
	cursor spanPosition should be: 10
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToLineStart [

	| lineStartSpan |
	lineStartSpan := Mock new.
	span stub lineStartSpan willReturn: lineStartSpan.
	lineStartSpan stub startPosition willReturn: 2.
		
	cursor moveToLineStart. 
		
	cursor span should be: lineStartSpan.
	cursor spanPosition should be: 2
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToNewSpanAtNewPosition [

	| anotherSpan |
	
	anotherSpan := Mock new.
	anotherSpan stub endPosition willReturn: 30.
		
	cursor moveToSpan: anotherSpan at: 23.
	
	cursor span should be: anotherSpan.
	cursor spanPosition should be: 23
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToNewSpanAtNewPositionShouldAnnounceMovement [
	| anotherSpan movement |
	anotherSpan := Mock new.
	cursor announcer when: TwyCursorMoved do: [ :ann | movement := ann ].
	
	cursor moveToSpan: anotherSpan at: 23.
	
	movement should beInstanceOf: TwyCursorMoved.
	movement text should be: text.
	movement cursor should be: cursor.
	movement oldSpan should be: span.
	movement oldPosition should equal: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToNewSpanAtNewPositionWhenItIsBeforeSpanStartPosition [

	| anotherSpan |
	anotherSpan := Mock new.
	anotherSpan stub startPosition willReturn: 10.
	anotherSpan stub endPosition willReturn: 20.
		
	cursor moveToSpan: anotherSpan at: 9.
	
	cursor span should be: anotherSpan.
	cursor spanPosition should be: anotherSpan startPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToNewSpanAtNewPositionWhenItIsNotExists [

	| anotherSpan |
	anotherSpan := Mock new.
	anotherSpan stub endPosition willReturn: 20.
		
	cursor moveToSpan: anotherSpan at: 23.
	
	cursor span should be: anotherSpan.
	cursor spanPosition should be: anotherSpan endPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToPositionOfAnotherCursor [

	[:anotherCursor :anotherSpan |
		anotherCursor stub span willReturn: anotherSpan.
		anotherSpan stub endPosition willReturn: 30.
		anotherCursor stub spanPosition willReturn: 23.
		
		cursor moveTo: anotherCursor.
			
		cursor span should be: anotherSpan.
		cursor spanPosition should be: 23
	] runWithMocks .


]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToSameSpanAndSamePositionShouldAnnounceNothing [

	| triggered |
	
	cursor announcer when: TwyCursorMoved do: [ :ann | triggered := true ].
		
	cursor moveToSpan: span at: spanPosition.
	
	triggered should not be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToSpanEnd [

	span stub endPosition willReturn: 10.
	
	cursor moveToSpanEnd.
	
	cursor span should be: span.
	cursor spanPosition should be: 10
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToSpanStart [

	span stub startPosition willReturn: 2.
	
	cursor moveToSpanStart.

	cursor span should be: span.
	cursor spanPosition should be: 2
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToStartOfNextSpan [

	| nextSpan |
	nextSpan := Mock new.
	(span stub nextSpanIfAbsent: Any) willReturn: nextSpan.
	nextSpan stub startPosition willReturn: 2.
	nextSpan stub endPosition willReturn: 30.

	cursor moveToStartOfNextSpan.
	
	cursor span should be: nextSpan.
	cursor spanPosition should be: 2
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToStartOfNextSpanWhenItAbsent [

	(span stub nextSpanIfAbsent: Any) will: [:arg | arg value].
	
	cursor moveToStartOfNextSpan.
	
	cursor span should be: span.
	cursor spanPosition should be: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToStartOfSpan [

	| anotherSpan |
	anotherSpan := Mock new.
	anotherSpan stub startPosition willReturn: 2.
	anotherSpan stub endPosition willReturn: 30.

	cursor moveToStartOf: anotherSpan.

	cursor span should be: anotherSpan.
	cursor spanPosition should be: 2
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToTextEnd [

	| lastSpan |
	lastSpan := Mock new.
	text stub lastSpan willReturn: lastSpan.
	lastSpan stub endPosition willReturn: 10.
	
	cursor moveToTextEnd.
	
	cursor span should be: lastSpan.
	cursor spanPosition should be: 10
]

{ #category : #tests }
TwyActiveTextCursorTests >> testMoveToTextStart [

	| firstSpan |
	firstSpan := Mock new.
	text stub firstSpan willReturn: firstSpan.
	firstSpan stub startPosition willReturn: 2.
	
	cursor moveToTextStart.
	
	cursor span should be: firstSpan.
	cursor spanPosition should be: 2
]

{ #category : #tests }
TwyActiveTextCursorTests >> testNextItemAtSpan [

	(span stub itemAt: spanPosition + 1 ifAbsent: Any) will: [:position :noneBlock | 
			noneBlock value should be: nil. #item].
		
	cursor nextItemAtSpan should be: #item
]

{ #category : #tests }
TwyActiveTextCursorTests >> testNextItemWhenItAbsentAtCurrentSpanAndAbsentAtNextElement [

	[:nextElement |
		[ cursor nextItem should be: nil]
			should strictly satisfy: 
		[(span itemAt: spanPosition + 1 ifAbsent: Any) will: [:position :absentBlock | absentBlock value].
		span next willReturn: nextElement.
		(nextElement itemAt: 1 ifAbsent: Any) will: [:position :absentBlock | absentBlock value]].
	] runWithMocks   
]

{ #category : #tests }
TwyActiveTextCursorTests >> testNextItemWhenItAbsentAtCurrentSpanAndExistsAtNextElement [

	[:nextElement |
		[ cursor nextItem should be: #item]
			should strictly satisfy: 
		[(span itemAt: spanPosition + 1 ifAbsent: Any) will: [:position :absentBlock | absentBlock value].
		span next willReturn: nextElement.
		(nextElement itemAt: 1 ifAbsent: Any) willReturn: #item].
	] runWithMocks   
]

{ #category : #tests }
TwyActiveTextCursorTests >> testNextItemWhenItExistsAtCurrentSpan [

	(span stub itemAt: spanPosition + 1 ifAbsent: Any) willReturn: #item.
	
	cursor nextItem should be: #item
]

{ #category : #tests }
TwyActiveTextCursorTests >> testOverrideCharactersUpToAnotherCursorWhenTheyAtDifferentSpans [

	[:anotherCursor :eachSpan :lastSpan :lastResult |
		[ (cursor overridePossibleCharactersWith: #newString upTo: anotherCursor) should be: lastResult]
			should strictly satisfy: 
		[(anotherCursor isAtSameSpanWith: cursor) willReturn: false.
		anotherCursor spanPosition willReturn: #anotherSpanPosition; useArbitrarily.
		anotherCursor span willReturn: lastSpan; useArbitrarily.
		(span overrideContentsAfter: spanPosition with: #newString) willReturn: (TwyOverrideResult noChangesBy: #restString1).
		(span forwardDo: Any while: Any) will: [ :arg1 :arg2 | arg1 value: eachSpan ].
		(eachSpan overrideFullContentsWith: #restString1) willReturn: (TwyOverrideResult noChangesBy: #restString2).
		(lastSpan overrideContentsBefore: #anotherSpanPosition with: #restString2) willReturn: lastResult ]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testOverrideCharactersUpToAnotherCursorWhenTheyAtSameSpan [

	[:anotherCursor |
		[ (cursor overridePossibleCharactersWith: #newString upTo: anotherCursor) should be: #restString]
			should strictly satisfy: 
		[(anotherCursor isAtSameSpanWith: cursor) willReturn: true.
		anotherCursor spanPosition willReturn: #anotherSpanPosition.
		(span overrideContentsFrom: spanPosition to: #anotherSpanPosition with: #newString) willReturn: #restString ]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testPreviousItemWhenItAbsentAtCurrentSpanAndAbsentAtPreviousElement [

	[:previousElement |
		[ cursor previousItem should be: nil]
			should strictly satisfy: 
		[(span itemAt: spanPosition ifAbsent: Any) will: [:position :absentBlock | absentBlock value].
		span previous willReturn: previousElement; useArbitrarily.
		previousElement length willReturn: 10.
		(previousElement itemAt: 10 ifAbsent: Any) will: [:position :absentBlock | absentBlock value]]	
	] runWithMocks  
]

{ #category : #tests }
TwyActiveTextCursorTests >> testPreviousItemWhenItAbsentAtCurrentSpanAndExistsAtPreviousElement [

	[:previousElement |
		[ cursor previousItem should be: #item]
			should strictly satisfy: 
		[(span itemAt: spanPosition ifAbsent: Any) will: [:position :absentBlock | absentBlock value].
		span previous willReturn: previousElement; useArbitrarily.
		previousElement length willReturn: 10.
		(previousElement itemAt: 10 ifAbsent: Any) willReturn: #item]	
	] runWithMocks  
]

{ #category : #tests }
TwyActiveTextCursorTests >> testPreviousItemWhenItExistsAtCurrentSpan [

	(span stub itemAt: spanPosition ifAbsent: Any) willReturn: #item.
	
	cursor previousItem should be: #item
]

{ #category : #tests }
TwyActiveTextCursorTests >> testPrintingBackSideOfSpan [

	cursor printBackSideOfSpanOn: #stream.
	
	span should receive asStringOn: #stream upTo: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testPrintingFrontSideOfSpan [

	cursor printFrontSideOfSpanOn: #stream.
	
	span should receive asStringOn: #stream startingAt: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testPrintingTextUpToAnotherCursorWhenTheyAtSameSpan [

	| anotherCursor |
	anotherCursor := Mock new.
	(anotherCursor stub isAtSameSpanWith: cursor) willReturn: true.
	anotherCursor stub spanPosition willReturn: #anotherSpanPosition.
	
	cursor printTextOn: #stream upTo: anotherCursor.

	span should receive asStringOn: #stream startingAt: spanPosition upTo: #anotherSpanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testPrintingTextUpToAnotherCursorWhenTheyNotAtSameSpan [

	[:anotherCursor :stream :eachSpan |
		[ cursor printTextOn: stream upTo: anotherCursor]
			should strictly satisfy: 
		[(anotherCursor isAtSameSpanWith: cursor) willReturn: false.
		span asStringOn: stream startingAt: spanPosition.
		(span forwardDo: Any while: Any) will: [:arg1 :arg2 | 
			arg1 value: eachSpan.
			(arg2 value: eachSpan) should be: false].
		eachSpan asStringOn: stream.		
		(anotherCursor isAt: eachSpan) willReturn: true.
		anotherCursor printBackSideOfSpanOn: stream]
	] runWithMocks 
]

{ #category : #tests }
TwyActiveTextCursorTests >> testProcessingTextChanges [

	| change |
	change := Mock new.
	
	cursor textChangedWith: change.
	
	change should receive correctPositionOf: cursor
]

{ #category : #tests }
TwyActiveTextCursorTests >> testSettingNewSpanPosition [

	cursor spanPosition: 123.
	
	cursor spanPosition should equal: 123
]

{ #category : #tests }
TwyActiveTextCursorTests >> testSettingNewSpanPositionShouldAnnounceMovement [
	| movement |
	cursor announcer when: TwyCursorMoved do: [ :ann | movement := ann ].
	cursor spanPosition: 123.
	movement should beInstanceOf: TwyCursorMoved.
	movement text should be: text.
	movement cursor should be: cursor.
	movement oldSpan should be: span.
	movement oldPosition should be: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testSettingSamePositionShouldAnnounceNothing [

	| triggered |
	
	cursor announcer when: TwyCursorMoved do: [ :ann | triggered := true ].
		
	cursor spanPosition: spanPosition.
	
	triggered should not be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testShouldBeAtStartByDefault [

	(TwyActiveTextCursor on: text) isAtStart should be: true
]

{ #category : #tests }
TwyActiveTextCursorTests >> testShouldDelegateAnnouncementToTextModel [

	| movement annFromText |
	cursor announcer when: TwyCursorMoved do: [ :ann | movement := ann].
	text when: TwyCursorMoved do: [ :ann | annFromText := ann ].
	
	cursor spanPosition: 123.
	
	annFromText should be: movement
	
]

{ #category : #tests }
TwyActiveTextCursorTests >> testSplitSpan [

	cursor splitSpan.
	
	span should receive splitAt: spanPosition
]

{ #category : #tests }
TwyActiveTextCursorTests >> testSubscribingLayoutCursor [

	[:cursorAnnouncer |
		cursor announcer: cursorAnnouncer.	
		[cursor subscribeLayoutCursor: #layoutCursor]
			should strictly satisfy: 
		[cursorAnnouncer unsubscribe: #layoutCursor.
		text unsubscribe: #layoutCursor. 
		text when: TwyChangesBegin send: #textWillBeChanged to: #layoutCursor.
		text when: TwyChangesCompleted send: #textChanged to: #layoutCursor.
		cursorAnnouncer when: TwyCursorMoved send: #textCursorMoved: to: #layoutCursor. ]
	] runWithMocks 

]

{ #category : #tests }
TwyActiveTextCursorTests >> testUnsubscribingLayoutCursor [

	| cursorAnnouncer |
	cursorAnnouncer := Mock new.
	cursor announcer: cursorAnnouncer.	

	cursor unsubscribeLayoutCursor: #layoutCursor.

	cursorAnnouncer should receive unsubscribe: #layoutCursor
]

{ #category : #running }
TwyActiveTextCursorTests >> textCursorClass [
	^TwyActiveTextCursor
]
