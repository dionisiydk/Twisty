"
I present hierarchy of solid  text spans with single indivisible item
"
Class {
	#name : #TwySolidSpan,
	#superclass : #TwySpan,
	#category : #'Twisty-Model'
}

{ #category : #converting }
TwySolidSpan >> asStringOn: aStream startingAt: startIndex upTo: endIndex [

	endIndex = 0 ifTrue: [ ^self ].
	startIndex = 1 ifTrue: [ ^self ].

	self asStringOn: aStream
]

{ #category : #testing }
TwySolidSpan >> canIntegrate: aCharactersSpan [
	^false
]

{ #category : #editing }
TwySolidSpan >> delete [

	next isSpan | previous isSpan ifTrue: [ ^super delete ].
	
	previous insertEmptySpan.
	
	super delete.
]

{ #category : #editing }
TwySolidSpan >> deleteAllAfter: startIndex [
	(self isStartPosition: startIndex) ifTrue: [ self delete ]
]

{ #category : #editing }
TwySolidSpan >> deleteAllBefore: endIndex [
	(self isEndPosition: endIndex) ifTrue: [ self delete ]
]

{ #category : #editing }
TwySolidSpan >> deleteFrom: startIndex to: endIndex [
	startIndex >= endIndex ifTrue: [ ^self ].
	
	(self isStartPosition: startIndex) ifTrue: [ ^self delete ].
	
	(self isEndPosition: endIndex) ifTrue: [ ^self delete ] 
]

{ #category : #editing }
TwySolidSpan >> insertInto: targetSpan at: spanPosition [

	^targetSpan insertTextStartedWith: self at: spanPosition
]

{ #category : #testing }
TwySolidSpan >> isEmpty [
	^false
]

{ #category : #accessing }
TwySolidSpan >> itemAt: anIndex ifAbsent: absentBlock [
	anIndex = 1 ifTrue: [ ^ self singleItem ].
	^absentBlock value
	
]

{ #category : #accessing }
TwySolidSpan >> length [
	^1
]

{ #category : #editing }
TwySolidSpan >> overrideContentsFrom: startIndex to: endIndex with: newString [
"
overrideing now implemented yet
"
	^TwyOverrideResult noChangesBy: newString 
]

{ #category : #accessing }
TwySolidSpan >> singleItem [
	^self subclassResponsibility 
]

{ #category : #editing }
TwySolidSpan >> splitAt: spanPosition [
	 
]
