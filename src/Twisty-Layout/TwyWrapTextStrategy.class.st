"
I build TwyTextLayout with wrapped lines based on preferredExtent restriction

Instance Variables:
	maxWidth	<Number>
	preferredExtent	<Point>
"
Class {
	#name : #TwyWrapTextStrategy,
	#superclass : #TwyLayoutStrategy,
	#instVars : [
		'maxWidth',
		'preferredExtent'
	],
	#category : #'Twisty-Layout'
}

{ #category : #testing }
TwyWrapTextStrategy >> allowArbitraryExtent [
	^true
]

{ #category : #'building layout' }
TwyWrapTextStrategy >> correctLayoutOf: aLayoutSpan [

	| rightBorder |
	
	rightBorder := aLayoutSpan rightBorderOffset.
	
	rightBorder = maxWidth ifTrue: [^self].
	
	rightBorder  > maxWidth ifTrue: [ self wrapExistedSpan: aLayoutSpan].

	rightBorder  < maxWidth ifTrue: [ self unwrapExistedSpan: aLayoutSpan ].
]

{ #category : #'building layout' }
TwyWrapTextStrategy >> layoutNewTextSpanStartingAt: aLayoutSpan by: aLayoutBuilder [

	| newSpan isLastSpan  |
	newSpan := aLayoutSpan.
	
	[
		newSpan putTextSpanItemsWhile: [ newSpan rightBorderOffset <= maxWidth ].		
		isLastSpan := newSpan isAtEndOfTextSpan.

		(isLastSpan not and: [newSpan isEmpty]) ifTrue: [ 
			newSpan == aLayoutSpan ifTrue: [ 
				aLayoutBuilder moveNewTextSpanToNewLine.
				newSpan putTextSpanItemsWhile: [ newSpan rightBorderOffset <= maxWidth ].
				isLastSpan := newSpan isAtEndOfTextSpan.
			 ].
			newSpan isEmpty ifTrue: [
				"we should garantie that span cant be wrapped by less then one item"
				newSpan putNextItem.
				isLastSpan := newSpan isAtEndOfTextSpan] ].

		aLayoutBuilder completeNewSpan.	
		isLastSpan
	] whileFalse: [ newSpan := aLayoutBuilder completeNewLine].
]

{ #category : #accessing }
TwyWrapTextStrategy >> maxWidth [
	^ maxWidth
]

{ #category : #accessing }
TwyWrapTextStrategy >> maxWidth: anObject [
	maxWidth := anObject
]

{ #category : #accessing }
TwyWrapTextStrategy >> preferredExtent [

	^preferredExtent

]

{ #category : #accessing }
TwyWrapTextStrategy >> preferredExtent: aPoint [

	preferredExtent := aPoint.
	maxWidth := preferredExtent x
]

{ #category : #'building layout' }
TwyWrapTextStrategy >> unwrapExistedSpan: aLayoutSpan [

	| allItemsWasAccepted |
	(aLayoutSpan isLastAtLine not or: [ aLayoutSpan isAtEndOfTextLine ])
		ifTrue: [^self].
			
	allItemsWasAccepted := aLayoutSpan putTextSpanItemsWhile: [ aLayoutSpan rightBorderOffset <= maxWidth ].
	
	allItemsWasAccepted ifFalse: [ ^self ].

	aLayoutSpan isAtEndOfTextSpan ifFalse: [ ^self ].
	aLayoutSpan isAtEndOfTextLine ifTrue: [^self].
	
	aLayoutSpan importNextSpanToLine
]

{ #category : #'building layout' }
TwyWrapTextStrategy >> wrapExistedSpan: aLayoutSpan [

	| newSpan |
	
	(aLayoutSpan isLastAtLine not or: [ aLayoutSpan isAtEndOfTextSpan ]) ifTrue: [ 
		newSpan := aLayoutSpan newRightSpan.
		aLayoutSpan insertLineAtTheEnd].
		
	aLayoutSpan rejectTextSpanItemsWhile: [ aLayoutSpan rightBorderOffset > maxWidth].
	aLayoutSpan isEmpty ifFalse: [ ^self ].
	
	aLayoutSpan isAtStartOfLine ifFalse: [ 
		aLayoutSpan migrateToNewLine.
		self unwrapExistedSpan: aLayoutSpan].
	
	aLayoutSpan isEmpty ifFalse: [
		(newSpan notNil and: [newSpan isEmpty ]) ifTrue: [newSpan delete ].
		^self].
	 
	aLayoutSpan putNextItem.
	(newSpan notNil and: [newSpan isEmpty ]) ifTrue: [newSpan delete ]
]
