"
I correct existed layout span to satisfy layout strategy restrictions. 
I can unwrap text and migrate next span to current line. Or I can just recompute span extent.
At the end I change my span for the right span and reappend myself to layout builder. I doing this if I'm not last span at text line.

    Instance Variables
	span:		<TwyLayoutSpan>

"
Class {
	#name : #TwyCorrectSpanCommand,
	#superclass : #TwyLayoutBuiltCommand,
	#instVars : [
		'span'
	],
	#category : #'Twisty-Layout'
}

{ #category : #'instance creation' }
TwyCorrectSpanCommand class >> span: aLayoutSpan [
	^self new 
		span: aLayoutSpan
]

{ #category : #execution }
TwyCorrectSpanCommand >> correctSpanBy: aLayoutBuilder [ 

	aLayoutBuilder correctLayoutOf: span
]

{ #category : #execution }
TwyCorrectSpanCommand >> correctState [
]

{ #category : #execution }
TwyCorrectSpanCommand >> executeBy: aLayoutBuilder [
		
	span fixOffset.
	span isTextSpansBorder 
		ifTrue: [span importNextSpanToLine ]
		ifFalse: [ self correctSpanBy: aLayoutBuilder].		
		
	span isAtEndOfTextSpan ifTrue: [ span cleanUpRedundantNeighbours ].
	self shouldStopAtThisSpan ifTrue: [ ^self].
	
	span := span rightSpan.	
	span ifNotNil: [ aLayoutBuilder addLayoutCommand: self]
]

{ #category : #testing }
TwyCorrectSpanCommand >> hasBuiltPlaceAfterLayoutSpan: aLayoutSpan [

	^span isPlacedAfter: aLayoutSpan
]

{ #category : #testing }
TwyCorrectSpanCommand >> hasBuiltPlaceBeforeTextChange: aTextChange [
	
	^span isPlacedBeforeTextChange: aTextChange
]

{ #category : #testing }
TwyCorrectSpanCommand >> hasBuiltPlaceChangedBy: aTextChange [

	^span isCoversTextChangedBy: aTextChange
]

{ #category : #testing }
TwyCorrectSpanCommand >> isActiveAtLine: aLayoutLine [
	^span line == aLayoutLine
]

{ #category : #testing }
TwyCorrectSpanCommand >> isActiveAtSpan: aLayoutSpan [
	^span == aLayoutSpan
]

{ #category : #testing }
TwyCorrectSpanCommand >> isRedundant [
	^span isDeleted
]

{ #category : #testing }
TwyCorrectSpanCommand >> isSimilarToSameClassCommand: aCorrectSpanCommand [ 
	
	^span == aCorrectSpanCommand span
]

{ #category : #printing }
TwyCorrectSpanCommand >> printOn: aStream [ 	
	super printOn: aStream.
	
	aStream nextPut: $(; print: span; nextPut: $)
]

{ #category : #testing }
TwyCorrectSpanCommand >> shouldBeExecutedBefore: anotherBuiltCommand [

	^anotherBuiltCommand hasBuiltPlaceAfterLayoutSpan: span
]

{ #category : #testing }
TwyCorrectSpanCommand >> shouldStopAtThisSpan [

	^span isAtEndOfTextLine 
]

{ #category : #accessing }
TwyCorrectSpanCommand >> span [
	
	^ span
]

{ #category : #accessing }
TwyCorrectSpanCommand >> span: anObject [
	
	span := anObject
]

{ #category : #execution }
TwyCorrectSpanCommand >> startSpan [
	^span
]
