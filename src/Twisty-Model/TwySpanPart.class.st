Class {
	#name : #TwySpanPart,
	#superclass : #TwySpan,
	#instVars : [
		'endBorder',
		'startBorder'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwySpanPart class >> endFrom: startCursor [
	| endCursor |
	endCursor := startCursor copy.
	endCursor moveToSpanEnd.
	^self from: startCursor to: endCursor 
]

{ #category : #'instance creation' }
TwySpanPart class >> from: startCursor to: endCursor [
	^self new 
		startBorder: startCursor;
		endBorder: endCursor 
]

{ #category : #'instance creation' }
TwySpanPart class >> startUpTo: endCursor [
	| startCursor |
	startCursor := endCursor copy.
	startCursor moveToSpanStart.
	^self from: startCursor to: endCursor 
]

{ #category : #converting }
TwySpanPart >> asStringOn: aStream startingAt: startIndex upTo: endIndex [

	self span 
		asStringOn: aStream 
		startingAt: startIndex
		upTo: endIndex
]

{ #category : #converting }
TwySpanPart >> beEndBoundaryOf: aTextPart [
	
	next := TwyTextEnd of: aTextPart.
	next previous: self
]

{ #category : #converting }
TwySpanPart >> beStartBoundaryOf: aTextPart [
	
	previous := TwyTextStart of: aTextPart.
	previous next: self
]

{ #category : #testing }
TwySpanPart >> canIntegrate: aCharactersSpan [
	^self span canIntegrate: aCharactersSpan
]

{ #category : #converting }
TwySpanPart >> convertNextSpanToTextPartEnd [
	| nextSpan nextEnd nextStart |
	nextSpan := self span nextSpanIfAbsent: [ self error: 'should not happen' ].
	
	nextEnd := endBorder copy.
	nextEnd moveToEndOf: nextSpan.
	nextStart := endBorder copy.
	nextStart moveToStartOf: nextSpan.
	
	^TwySpanPart from: nextStart to: nextEnd
]

{ #category : #'drawer creation' }
TwySpanPart >> createDrawerBy: aTwyLayoutBuilder [ 
	^self span createDrawerBy: aTwyLayoutBuilder
]

{ #category : #editing }
TwySpanPart >> deleteFrom: startIndex to: endIndex [
	self span 
		deleteFrom: startIndex
		to: endIndex
]

{ #category : #drawing }
TwySpanPart >> drawOn: aCanvas from: start to: end at: aPoint font: aFont [

	self span 
		drawOn: aCanvas
		from: start
		to: end
		at: aPoint
		font: aFont
]

{ #category : #accessing }
TwySpanPart >> endBorder [
	^ endBorder
]

{ #category : #accessing }
TwySpanPart >> endBorder: anObject [
	endBorder := anObject
]

{ #category : #accessing }
TwySpanPart >> endPosition [
	^endBorder spanPosition
]

{ #category : #editing }
TwySpanPart >> insertSimpleString: aString at: index [
	^self span insertSimpleString: aString at: index
]

{ #category : #editing }
TwySpanPart >> insertTextStartedWith: anotherSpan at: spanPosition [
	^self span insertTextStartedWith: anotherSpan at: spanPosition
]

{ #category : #testing }
TwySpanPart >> isAfter: aTwySpan [
	^self span isAfter: aTwySpan
]

{ #category : #testing }
TwySpanPart >> isBefore: aTwySpan [
	^self span isBefore: aTwySpan
]

{ #category : #testing }
TwySpanPart >> isCoversSpan: aTwySpan [
	^self span isCoversSpan: aTwySpan
]

{ #category : #accessing }
TwySpanPart >> itemAt: anIndex ifAbsent:  aBlock [
	
	^self span itemAt: anIndex ifAbsent: aBlock
]

{ #category : #accessing }
TwySpanPart >> length [
	^endBorder spanPosition - startBorder spanPosition
]

{ #category : #'cursor creation' }
TwySpanPart >> newPassiveCursorAtStart [
	^startBorder span newPassiveCursor
		moveToStartOf: self;
		yourself
]

{ #category : #accessing }
TwySpanPart >> span [
	^startBorder span
]

{ #category : #editing }
TwySpanPart >> splitAt: index [
	self span splitAt: index.
	endBorder moveToEndOf: self span.
	self isLast ifTrue: [ text expandToSecondSpan]
]

{ #category : #accessing }
TwySpanPart >> startBorder [
	^ startBorder
]

{ #category : #accessing }
TwySpanPart >> startBorder: anObject [
	startBorder := anObject
]

{ #category : #accessing }
TwySpanPart >> startPosition [
	^startBorder spanPosition
]
