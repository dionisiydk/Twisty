"
I'm the root of the hierarchy of text cursors.

I implement text navigation and provide interface for text editing.
See navigation, operations and testing method categories

To create my instance ask text for new cursor by #newActiveCursor/#newPassiveCursor

Internal Representation and Key Implementation Points.

    Instance Variables
	span:		<TwySpan>
	spanPosition:		<Integer>
	text:		<TwyText>

"
Class {
	#name : #TwyTextCursor,
	#superclass : #Object,
	#instVars : [
		'text',
		'span',
		'spanPosition'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyTextCursor class >> on: aText [ 
	^self new
		text: aText
]

{ #category : #operations }
TwyTextCursor >> applyAttribute: aTextAttribute upTo: endCursor [
	
	| endSpan startSpan |
	(endCursor isAtSamePositionWith: self) ifTrue: [ 
		span isEmpty ifTrue: [ ^span applyAttribute: aTextAttribute ].
		^self].

	startSpan := span.
	self isAtSpanStart ifFalse: [ 
		self isAtSpanEnd 
			ifTrue: [ startSpan := startSpan next ] 
			ifFalse: [ self splitSpan. startSpan := startSpan next ]].
			
	endSpan := endCursor span.
	endCursor isAtSpanEnd ifFalse: [ 
		endCursor isAtSpanStart ifTrue: [ endSpan := endSpan previous ] ifFalse: [ endCursor splitSpan ]].
	
	startSpan 
		withYourselfForwardDo: [ :eachSpan | eachSpan applyAttribute: aTextAttribute ] 
		while: [ :eachSpan | (eachSpan == endSpan) not ].		
	endSpan applyAttribute: aTextAttribute
]

{ #category : #operations }
TwyTextCursor >> applyParagraphAttribute: aTwyAttribute upTo: endCursor [

	span applyParagraphAttribute: aTwyAttribute.
	
	(endCursor isAtSameSpanWith: self) ifTrue: [^self ].
	
	endCursor span
		backwardDo: [ :eachSpan | eachSpan isSpan ifFalse: [eachSpan applyAttribute: aTwyAttribute] ] 
		while: [ :eachSpan | (eachSpan == span) not ].		
				
	 

]

{ #category : #operations }
TwyTextCursor >> deleteBackSideOfSpan [
	span deleteAllBefore: spanPosition	
	
]

{ #category : #operations }
TwyTextCursor >> deleteForwardSideOfSpan [
	span deleteAllAfter: spanPosition
	
	
]

{ #category : #operations }
TwyTextCursor >> deleteUpTo: aTextCursor [
	
	(aTextCursor isAtSameSpanWith: self) ifTrue: [ 
		^span deleteFrom: spanPosition to: aTextCursor spanPosition].

	span attachTo: aTextCursor span.
	self deleteForwardSideOfSpan.
	aTextCursor deleteBackSideOfSpan.
	
	
]

{ #category : #private }
TwyTextCursor >> detachText [

	self subclassResponsibility 
]

{ #category : #testing }
TwyTextCursor >> hasAttribute: aTextAttrbuteClass [ 
	^span hasAttribute: aTextAttrbuteClass
]

{ #category : #operations }
TwyTextCursor >> insert: aTwyTextSource [

	| textModel |
	textModel := aTwyTextSource asTwyText.
	
	textModel firstSpan insertInto: span at: spanPosition
]

{ #category : #testing }
TwyTextCursor >> isAfter: aTextCursor [ 
	^self isAfterPosition: aTextCursor spanPosition atSpan: aTextCursor span
]

{ #category : #testing }
TwyTextCursor >> isAfterElement: aTextElement [

	^span isAfter: aTextElement
]

{ #category : #testing }
TwyTextCursor >> isAfterOrAtEndOfElement: aTextElement [

	^(self isAfterElement: aTextElement) or: [ self isAtEndOf: aTextElement ]
]

{ #category : #testing }
TwyTextCursor >> isAfterOrAtPosition: positionInsideAnotherSpan atSpan: anotherSpan [
	span == anotherSpan ifFalse: [ ^span isAfter: anotherSpan].
	
	^spanPosition >= positionInsideAnotherSpan
]

{ #category : #testing }
TwyTextCursor >> isAfterPosition: positionInsideAnotherSpan atSpan: anotherSpan [
	span == anotherSpan ifFalse: [ ^span isAfter: anotherSpan].
	
	^spanPosition > positionInsideAnotherSpan
]

{ #category : #testing }
TwyTextCursor >> isAt: aTwySpan [
	^span isCoversSpan: aTwySpan
]

{ #category : #testing }
TwyTextCursor >> isAtEnd [
	^span isLast and: [ self isAtSpanEnd ]
]

{ #category : #testing }
TwyTextCursor >> isAtEndOf: aTwySpan [
	(self isAt: aTwySpan) ifFalse: [ ^false ].
	^self isAtSpanEnd
]

{ #category : #testing }
TwyTextCursor >> isAtLineEnd [
	^span isLastAtLine and: [ self isAtSpanEnd ]
]

{ #category : #testing }
TwyTextCursor >> isAtLineStart [
	^span isFirstAtLine and: [ self isAtSpanStart ]
]

{ #category : #testing }
TwyTextCursor >> isAtSamePositionWith: aTextCursor [

	(aTextCursor isAtSameSpanWith: self) ifTrue: [ ^spanPosition = aTextCursor spanPosition ].
	
	(self isAtSpanStart and: [ aTextCursor isAtEndOf: span previous ]) ifTrue: [ ^true ].
	(self isAtSpanEnd and: [ aTextCursor isAtStartOf: span next ]) ifTrue: [ ^true ].
	
	^false
]

{ #category : #testing }
TwyTextCursor >> isAtSameSpanWith: aTextCursor [ 
	^span == aTextCursor span
]

{ #category : #testing }
TwyTextCursor >> isAtSpanAfter: aTextCursor [ 
	(self isAtSameSpanWith: aTextCursor) ifFalse: [ ^false ].
	^spanPosition > aTextCursor spanPosition
]

{ #category : #testing }
TwyTextCursor >> isAtSpanBefore: aTextCursor [ 
	(self isAtSameSpanWith: aTextCursor) ifFalse: [ ^false ].
	^spanPosition < aTextCursor spanPosition
]

{ #category : #testing }
TwyTextCursor >> isAtSpanEnd [
	^span isEndPosition: spanPosition
]

{ #category : #testing }
TwyTextCursor >> isAtSpanStart [
	^span isStartPosition: spanPosition 
]

{ #category : #testing }
TwyTextCursor >> isAtStart [
	^span isFirst and: [ self isAtSpanStart]
]

{ #category : #testing }
TwyTextCursor >> isAtStartOf: aTwySpan [
	(self isAt: aTwySpan) ifFalse: [ ^false ].
	^self isAtSpanStart
]

{ #category : #testing }
TwyTextCursor >> isBefore: aTextCursor [ 
	^self isBeforePosition: aTextCursor spanPosition atSpan: aTextCursor span
]

{ #category : #testing }
TwyTextCursor >> isBeforeElement: aTextElement [

	^span isBefore: aTextElement
]

{ #category : #testing }
TwyTextCursor >> isBeforeOrAtPosition: positionInsideAnotherSpan atSpan: anotherSpan [
	span == anotherSpan ifFalse: [ ^span isBefore: anotherSpan].
	
	^spanPosition <= positionInsideAnotherSpan
]

{ #category : #testing }
TwyTextCursor >> isBeforeOrAtStartOfElement: aTextElement [

	^(self isBeforeElement: aTextElement) or: [ self isAtStartOf: aTextElement ]
]

{ #category : #testing }
TwyTextCursor >> isBeforePosition: positionInsideAnotherSpan atSpan: anotherSpan [
	span == anotherSpan ifFalse: [ ^span isBefore: anotherSpan].
	
	^spanPosition < positionInsideAnotherSpan
]

{ #category : #testing }
TwyTextCursor >> isInsideLayoutSpan: aLayoutSpan [  
	^aLayoutSpan contains: self
]

{ #category : #testing }
TwyTextCursor >> isValid [
	^spanPosition <= span endPosition
]

{ #category : #accessing }
TwyTextCursor >> lineNumber [
	^span lineNumber
]

{ #category : #accessing }
TwyTextCursor >> lineNumber: anInteger [
	| currentLine newLine |
	currentLine := self lineNumber.
	
	span
		forwardDo: [:eachSpan | eachSpan isSpan ifFalse: [ 
					newLine := eachSpan. currentLine := currentLine + 1] ]
		while: [ :eachSpan | currentLine < anInteger ].		
	newLine ifNotNil: [ ^self moveToSpan: newLine next at: spanPosition ].
	
	span
		backwardDo: [:eachSpan | eachSpan isSpan ifFalse: [ 
					newLine := eachSpan. currentLine := currentLine - 1] ]
		while: [ :eachSpan | currentLine + 1 > anInteger ].
	newLine ifNotNil: [ ^self moveToSpan: newLine next at: spanPosition ].
]

{ #category : #accessing }
TwyTextCursor >> linePosition [

	^span offsetFromLineStart + spanPosition
]

{ #category : #accessing }
TwyTextCursor >> linePosition: offsetFromLineStart [

	| targetPosition lineStart |
	lineStart := span lineStart.
	targetPosition := offsetFromLineStart.
	
	lineStart
		forwardDo: [ :each | 
			targetPosition > each endPosition
				ifTrue: [targetPosition := targetPosition - each endPosition]
				ifFalse: [ ^self moveToSpan: each at: targetPosition ]
		] 
		while: [ :each | each isSpan].

	self error: 'Given line position not exists' 
			
	
	
]

{ #category : #navigation }
TwyTextCursor >> moveBackward [
	| previousSpan newPosition |
	(span isStartPosition: spanPosition) ifFalse: [ 
		^self spanPosition: spanPosition - 1 ].
	
	previousSpan := span previousSpanIfAbsent: [ ^self ].
	(previousSpan isAttachedTo: span) 
		ifTrue: [ newPosition := previousSpan endPosition - 1 ]
		ifFalse: [ newPosition := previousSpan endPosition ].
		
	self moveToSpan: previousSpan at: newPosition
]

{ #category : #navigation }
TwyTextCursor >> moveBackward: steps [

	steps timesRepeat: [ self moveBackward  ]
]

{ #category : #navigation }
TwyTextCursor >> moveBackwardToSpanWhich: spanConditionBlock [ 

	span backwardDo: [:eachSpan | 
		(eachSpan isSpan and: [spanConditionBlock value: eachSpan]) ifTrue: [ 
			self moveToEndOf: eachSpan.
			^true]
	 ].

	^false
		
	
]

{ #category : #navigation }
TwyTextCursor >> moveForward [
	| nextSpan newPosition |
	(span isEndPosition: spanPosition) ifFalse: [ 
		^self spanPosition: spanPosition + 1 ].
	
	nextSpan := span nextSpanIfAbsent: [ ^self ].
	(nextSpan isAttachedTo: span) 
		ifTrue: [  newPosition := nextSpan startPosition + 1 ]
		ifFalse: [ newPosition := nextSpan startPosition ].
		
	self moveToSpan: nextSpan at: newPosition.
	
]

{ #category : #navigation }
TwyTextCursor >> moveForward: steps [

	steps timesRepeat: [ self moveForward ]
]

{ #category : #navigation }
TwyTextCursor >> moveForwardToItemWhich: itemConditionBlock butNotFarThan: endCursor [

	| eachItem |
	[ eachItem := self nextItemAtSpan.
	(self isAtSamePositionWith: endCursor) not and: (eachItem isNil or: [ (itemConditionBlock value: eachItem) not ])] 
			whileTrue: [ self moveForward ]
]

{ #category : #navigation }
TwyTextCursor >> moveTo: aTextCursor [

	self moveToSpan: aTextCursor span at: aTextCursor spanPosition
]

{ #category : #navigation }
TwyTextCursor >> moveToEndOf: aTwySpan [

	self moveToSpan: aTwySpan at: aTwySpan endPosition
]

{ #category : #navigation }
TwyTextCursor >> moveToEndOfPreviousSpan [

	| previousSpan |
	previousSpan := span previousSpanIfAbsent: [ ^self ].
	self moveToEndOf: previousSpan
]

{ #category : #navigation }
TwyTextCursor >> moveToLineEnd [

	self moveToEndOf: span lineEndSpan
]

{ #category : #navigation }
TwyTextCursor >> moveToLineStart [

	self moveToStartOf: span lineStartSpan 
]

{ #category : #navigation }
TwyTextCursor >> moveToSpan: aTwySpan at: aNumber [

	| movement |
	span == aTwySpan & (spanPosition = aNumber) ifTrue: [ ^self ].
	
	movement := TwyCursorMoved startingAt: self.
	
	span := aTwySpan.
	spanPosition := aNumber min: span endPosition max: span startPosition.
	
	self publishMovement: movement
]

{ #category : #navigation }
TwyTextCursor >> moveToSpanEnd [

	self spanPosition: span endPosition
]

{ #category : #navigation }
TwyTextCursor >> moveToSpanStart [

	self spanPosition: span startPosition
]

{ #category : #navigation }
TwyTextCursor >> moveToStartOf: aTwySpan [

	self moveToSpan: aTwySpan at: aTwySpan startPosition
]

{ #category : #navigation }
TwyTextCursor >> moveToStartOfNextSpan [

	| nextSpan |
	nextSpan := span nextSpanIfAbsent: [ ^self ].
	self moveToStartOf: nextSpan
]

{ #category : #navigation }
TwyTextCursor >> moveToTextEnd [
	
	self moveToEndOf: text lastSpan
]

{ #category : #navigation }
TwyTextCursor >> moveToTextStart [

	self moveToStartOf: text firstSpan
]

{ #category : #accessing }
TwyTextCursor >> nextItem [
	
	^span itemAt: spanPosition + 1ifAbsent: [ 
		span next itemAt: 1 ifAbsent: [ nil ]
	 ]
]

{ #category : #accessing }
TwyTextCursor >> nextItemAtSpan [
	
	^span itemAt: spanPosition + 1ifAbsent: [ nil ]
]

{ #category : #operations }
TwyTextCursor >> overridePossibleCharactersWith: newString upTo: aTextCursor [
	
	| result |
	(aTextCursor isAtSameSpanWith: self) ifTrue: [ 
		^span overrideContentsFrom: spanPosition to: aTextCursor spanPosition with: newString ].

	result := span overrideContentsAfter: spanPosition with: newString.
	
	span 
		forwardDo: [ :each | result := each overrideFullContentsWith: result restString ]
		while: [ :each | aTextCursor isAt: each ].
		
	^aTextCursor span overrideContentsBefore: aTextCursor spanPosition with: result restString
]

{ #category : #accessing }
TwyTextCursor >> previousItem [
	
	^span itemAt: spanPosition ifAbsent: [ 
		span previous itemAt: span previous length ifAbsent: [ nil ]
	 ]
]

{ #category : #printing }
TwyTextCursor >> printBackSideOfSpanOn: aStream [

	span asStringOn: aStream upTo: spanPosition.
]

{ #category : #printing }
TwyTextCursor >> printFrontSideOfSpanOn: aStream [

	span asStringOn: aStream startingAt: spanPosition.
]

{ #category : #printing }
TwyTextCursor >> printTextOn: aStream upTo: endTextCursor [ 

	(endTextCursor isAtSameSpanWith: self) ifTrue: [ 
		^span asStringOn: aStream startingAt: spanPosition upTo: endTextCursor spanPosition].

	self printFrontSideOfSpanOn: aStream.
	span forwardDo: [ :each | each asStringOn: aStream ] while: [ :each | (endTextCursor isAt: each) not].
	endTextCursor printBackSideOfSpanOn: aStream
]

{ #category : #private }
TwyTextCursor >> publishMovement: aTwyCursorMoved [

	self subclassResponsibility 
]

{ #category : #operations }
TwyTextCursor >> removeNextItem [

	| operationCursor |
	operationCursor := span newPassiveCursor.
	operationCursor moveTo: self; moveForward.
	self deleteUpTo: operationCursor
]

{ #category : #operations }
TwyTextCursor >> removePreviousItem [

	| operationCursor |
	operationCursor := span newPassiveCursor.
	operationCursor moveTo: self; moveBackward.
	operationCursor deleteUpTo: self
]

{ #category : #operations }
TwyTextCursor >> selectTextUpTo: anotherCursor [
	^TwyTextRegion from: self to: anotherCursor
]

{ #category : #accessing }
TwyTextCursor >> span [
	
	^ span
]

{ #category : #accessing }
TwyTextCursor >> span: aTwySpan [
	span := aTwySpan	
]

{ #category : #accessing }
TwyTextCursor >> spanPosition [
	
	^ spanPosition
]

{ #category : #accessing }
TwyTextCursor >> spanPosition: aNumber [
	| movement |
	spanPosition = aNumber ifTrue: [ ^self ].
	
	movement := TwyCursorMoved startingAt: self.
	spanPosition := aNumber.
	self publishMovement: movement
]

{ #category : #operations }
TwyTextCursor >> splitSpan [
	span splitAt: spanPosition
]

{ #category : #accessing }
TwyTextCursor >> text [
	
	^ text
]

{ #category : #accessing }
TwyTextCursor >> text: aTwyText [
	
	text := aTwyText.
	self moveToTextStart
]

{ #category : #accessing }
TwyTextCursor >> textPosition [

	^span offsetFromTextStart + spanPosition
]

{ #category : #accessing }
TwyTextCursor >> textPosition: offsetFromTextStart [

	| targetPosition textStart |
	textStart := text start.
	targetPosition := offsetFromTextStart.
	
	textStart
		forwardDo: [ :each | 
			(each isSpan and: [targetPosition <= each length])
				ifTrue: [ ^self moveToSpan: each at: targetPosition ]
				ifFalse: [targetPosition := targetPosition - each length]
		].
	
	self error: 'Given line position not exists' 
			
	
	
]
