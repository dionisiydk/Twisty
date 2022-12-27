"
I dispatch processing to actual text change by:

	textChange correctAffectedLayoutSpansStartingAt: currentSpan by: layoutBuilder.
	
So concrete text change implements real logic to fix layout.
	
    Instance Variables
	textChange:		<TwyTextStateChanged>

"
Class {
	#name : #TwyProcessTextChangeCommand,
	#superclass : #TwyLayoutBuiltCommand,
	#instVars : [
		'textChange'
	],
	#category : #'Twisty-Layout'
}

{ #category : #'instance creation' }
TwyProcessTextChangeCommand class >> on: aTextChange [
	^self new 
		textChange: aTextChange
]

{ #category : #execution }
TwyProcessTextChangeCommand >> correctState [
]

{ #category : #execution }
TwyProcessTextChangeCommand >> executeBy: aLayoutBuilder [
	aLayoutBuilder restoreSpanCorruptedBy: textChange
]

{ #category : #testing }
TwyProcessTextChangeCommand >> hasBuiltPlaceAfterLayoutSpan: aTwyLayoutSpan [
	"ProcessTextChangeCommand's should be always created before any other commands. 
	So this method should be not called"
	
	self shouldNotImplement 
]

{ #category : #testing }
TwyProcessTextChangeCommand >> hasBuiltPlaceBeforeTextChange: aTextChange [ 
	^textChange isBeforeChange: aTextChange
]

{ #category : #testing }
TwyProcessTextChangeCommand >> hasBuiltPlaceChangedBy: anotherTextChange [

	^anotherTextChange isEmbody: textChange
]

{ #category : #testing }
TwyProcessTextChangeCommand >> isActiveAtLine: aLayoutLine [

	^textChange isAffectLayoutLine: aLayoutLine
]

{ #category : #testing }
TwyProcessTextChangeCommand >> isActiveAtSpan: aLayoutSpan [

	^textChange isAffectLayoutSpan: aLayoutSpan
]

{ #category : #testing }
TwyProcessTextChangeCommand >> isEmbody: anotherCommand [
	(super isEmbody: anotherCommand) ifTrue: [ ^true ].
	
	^anotherCommand hasBuiltPlaceChangedBy: textChange
]

{ #category : #testing }
TwyProcessTextChangeCommand >> isRedundant [
	^textChange isRedundant
]

{ #category : #testing }
TwyProcessTextChangeCommand >> isSimilarToSameClassCommand: aProcessTextChangeCommand [
	^textChange == aProcessTextChangeCommand textChange
]

{ #category : #printing }
TwyProcessTextChangeCommand >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(; print: textChange; nextPut: $)
]

{ #category : #testing }
TwyProcessTextChangeCommand >> shouldBeExecutedBefore: anotherCommand [ 

	^(anotherCommand hasBuiltPlaceBeforeTextChange: textChange) not
]

{ #category : #accessing }
TwyProcessTextChangeCommand >> textChange [
	
	^ textChange
]

{ #category : #accessing }
TwyProcessTextChangeCommand >> textChange: anObject [
	
	textChange := anObject
]
