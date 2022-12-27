"
I'm the root of the hierarchy of text span objects. My subclasses present different kind of text items groups

Public API and Key Messages

- insertInto: targetSpan at: spanPosition  
- insertTextStartedWith: anotherSpan at: spanPosition 
- canIntegrate: aTwyCharactersSpan
- deleteFrom: startIndex to: endIndex 
- deleteAllBefore: endIndex
- deleteAllAfter: startIndex
- splitAt: spanPosition
- overrideContentsAfter: startIndex with: newString
- overrideContentsBefore: endIndex with: newString
- overrideContentsFrom: startIndex to: endIndex with: newString
- getParagraphAttribute: anAttributeClass
- newActiveCursor/newPassiveCursor
"
Class {
	#name : #TwySpan,
	#superclass : #TwyElement,
	#category : #'Twisty-Model'
}

{ #category : #editing }
TwySpan >> applyParagraphAttribute: aTwyAttribute [
	^self lineStart applyAttribute: aTwyAttribute
]

{ #category : #converting }
TwySpan >> asStringOn: aStream startingAt: index [

	^self asStringOn: aStream startingAt: index upTo: self endPosition

]

{ #category : #converting }
TwySpan >> asStringOn: aStream startingAt: startIndex upTo: endIndex [
	self subclassResponsibility 
]

{ #category : #converting }
TwySpan >> asStringOn: aStream upTo: index [
	
	^self asStringOn: aStream startingAt: self startPosition upTo: index
]

{ #category : #testing }
TwySpan >> canIntegrate: aCharactersSpan [ 

	self subclassResponsibility 
]

{ #category : #editing }
TwySpan >> deleteAllAfter: startIndex [

	self subclassResponsibility 
]

{ #category : #editing }
TwySpan >> deleteAllBefore: endIndex [

	self subclassResponsibility 
]

{ #category : #editing }
TwySpan >> deleteFrom: startIndex to: endIndex [

	self subclassResponsibility 
]

{ #category : #accessing }
TwySpan >> endPosition [
	^self length
]

{ #category : #accessing }
TwySpan >> getParagraphAttribute: anAttributeClass [
	^self lineStart getAttribute: anAttributeClass
]

{ #category : #editing }
TwySpan >> insertInto: targetSpan at: spanPosition [
	self subclassResponsibility 
]

{ #category : #editing }
TwySpan >> insertTextStartedWith: anotherSpan at: spanPosition [

	(self isStartPosition: spanPosition) ifTrue: [ 
		^previous insertElement: anotherSpan].
	
	(self isEndPosition: spanPosition) ifTrue: [ 
		^self insertElement: anotherSpan].

	self splitAt: spanPosition.
	self insertElement: anotherSpan.
]

{ #category : #testing }
TwySpan >> isCoversSpan: aTwySpan [
	^self = aTwySpan
]

{ #category : #testing }
TwySpan >> isEmpty [

	self subclassResponsibility 
]

{ #category : #testing }
TwySpan >> isEndPosition: index [
	^index = self endPosition
]

{ #category : #testing }
TwySpan >> isFirst [
	^previous isTextStart
]

{ #category : #testing }
TwySpan >> isFirstAtLine [
	^previous isSpan not
]

{ #category : #testing }
TwySpan >> isLast [
	^next isTextEnd
]

{ #category : #testing }
TwySpan >> isLastAtLine [
	^next isSpan not
]

{ #category : #testing }
TwySpan >> isSpan [ 
	^true
]

{ #category : #testing }
TwySpan >> isStartPosition: index [
	^index = self startPosition
]

{ #category : #accessing }
TwySpan >> lineEndSpan [

	| end |
	end := self.
	self forwardDo: [ :each | end := each ] while: [ :each | each isSpan ].
	^end
]

{ #category : #accessing }
TwySpan >> lineNumber [

	| result |
	result := 1.
	self 
		backwardDo: [:each | each isLineStart ifTrue: [ result := result + 1]].
	^result
]

{ #category : #accessing }
TwySpan >> lineStart [

	^self lineStartSpan previous
]

{ #category : #accessing }
TwySpan >> lineStartSpan [

	| start |
	start := self.
	self backwardDo: [ :each | start := each ] while: [ :each | each isSpan ].
	^start
]

{ #category : #accessing }
TwySpan >> newActiveCursor [
	^text newActiveCursor
		moveToStartOf: self;
		yourself
]

{ #category : #accessing }
TwySpan >> newPassiveCursor [
	^text newPassiveCursor
		moveToStartOf: self;
		yourself
]

{ #category : #accessing }
TwySpan >> offsetFromLineStart [

	| offset |
	offset := 0.
	self backwardDo: [ :each | offset := each length + offset ] while: [ :each | each isSpan  ].
	^offset
]

{ #category : #accessing }
TwySpan >> offsetFromTextStart [

	| offset |
	offset := 0.
	self backwardDo: [ :each | offset := each length + offset ].
	^offset
]

{ #category : #editing }
TwySpan >> overrideContentsAfter: startIndex with: newString [

	^self overrideContentsFrom: startIndex to: self length with: newString
]

{ #category : #editing }
TwySpan >> overrideContentsBefore: endIndex with: newString [

	^self overrideContentsFrom: self startPosition to: endIndex with: newString 
]

{ #category : #editing }
TwySpan >> overrideContentsFrom: startIndex to: endIndex with: newString [

	self subclassResponsibility 
]

{ #category : #editing }
TwySpan >> overrideFullContentsWith: newString [

	^self overrideContentsFrom: self startPosition to: self endPosition with: newString 
]

{ #category : #testing }
TwySpan >> requiredSpanBeforeNextElement [ 
	^false
]

{ #category : #editing }
TwySpan >> splitAt: spanPosition [
	self subclassResponsibility 
]

{ #category : #accessing }
TwySpan >> startPosition [
	^0
]
