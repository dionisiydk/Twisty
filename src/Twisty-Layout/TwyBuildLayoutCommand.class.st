"
I build layout of text region between two text elements and two layout spans.

    Instance Variables
	elementAfterInsertion:		<TwyElement>
	elementBeforeInsertion:		<TwyElement>
	leftSpan:		<TwyLayoutSpan>
	rightSpan:		<TwyLayoutSpan>
"
Class {
	#name : #TwyBuildLayoutCommand,
	#superclass : #TwyLayoutBuiltCommand,
	#instVars : [
		'leftSpan',
		'rightSpan',
		'elementAfterInsertion',
		'elementBeforeInsertion'
	],
	#category : #'Twisty-Layout'
}

{ #category : #execution }
TwyBuildLayoutCommand >> correctState [

	leftSpan := leftSpan findLiveSpanFromLeft.
	rightSpan ifNotNil: [ rightSpan := rightSpan findLiveSpanFromRight].
	elementBeforeInsertion := elementBeforeInsertion findLiveElementBackward.
	elementAfterInsertion := elementAfterInsertion findLiveElementForward.
]

{ #category : #accessing }
TwyBuildLayoutCommand >> elementAfterInsertion [
	
	^ elementAfterInsertion
]

{ #category : #accessing }
TwyBuildLayoutCommand >> elementAfterInsertion: anObject [
	
	elementAfterInsertion := anObject
]

{ #category : #accessing }
TwyBuildLayoutCommand >> elementBeforeInsertion [
	
	^ elementBeforeInsertion
]

{ #category : #accessing }
TwyBuildLayoutCommand >> elementBeforeInsertion: anObject [
	
	elementBeforeInsertion := anObject
]

{ #category : #execution }
TwyBuildLayoutCommand >> executeBy: aLayoutBuilder [
	 
	aLayoutBuilder currentSpan: leftSpan.
		
	aLayoutBuilder layoutTextBetween: elementBeforeInsertion and: elementAfterInsertion.
	aLayoutBuilder setUpNextSpan.
	
	rightSpan ifNil: [ ^self ].
	
	aLayoutBuilder addCorrectionCommandFor: rightSpan
]

{ #category : #testing }
TwyBuildLayoutCommand >> hasBuiltPlaceAfterLayoutSpan: aTwyLayoutSpan [ 
	self startSpan == aTwyLayoutSpan ifTrue: [ ^true ].
	^self startSpan isPlacedAfter: aTwyLayoutSpan
]

{ #category : #testing }
TwyBuildLayoutCommand >> hasBuiltPlaceBeforeTextChange: aTextChange [

	^aTextChange isAffectTextAfterElement: elementBeforeInsertion
]

{ #category : #testing }
TwyBuildLayoutCommand >> hasBuiltPlaceChangedBy: aTextChange [

	^false
]

{ #category : #testing }
TwyBuildLayoutCommand >> isActiveAtLine: aLayoutLine [
	^leftSpan line == aLayoutLine
]

{ #category : #testing }
TwyBuildLayoutCommand >> isActiveAtSpan: aLayoutSpan [
	^leftSpan == aLayoutSpan
]

{ #category : #testing }
TwyBuildLayoutCommand >> isRedundant [
	^false
]

{ #category : #testing }
TwyBuildLayoutCommand >> isSimilarToSameClassCommand: aBuildLayoutCommand [

	elementBeforeInsertion == aBuildLayoutCommand elementBeforeInsertion ifFalse: [^false].
	elementAfterInsertion == aBuildLayoutCommand elementAfterInsertion ifFalse: [^false].
	
	^true

]

{ #category : #accessing }
TwyBuildLayoutCommand >> leftSpan [
	
	^ leftSpan
]

{ #category : #accessing }
TwyBuildLayoutCommand >> leftSpan: anObject [
	
	leftSpan := anObject
]

{ #category : #accessing }
TwyBuildLayoutCommand >> rightSpan [
	
	^ rightSpan
]

{ #category : #accessing }
TwyBuildLayoutCommand >> rightSpan: anObject [
	
	rightSpan := anObject
]

{ #category : #testing }
TwyBuildLayoutCommand >> shouldBeExecutedBefore: anotherCommand [
	^anotherCommand hasBuiltPlaceAfterLayoutSpan: self startSpan
]

{ #category : #execution }
TwyBuildLayoutCommand >> startSpan [
	^leftSpan
]
