"
I happens when new text elements was inserted
 
Internal Representation and Key Implementation Points.

    Instance Variables
	elementAfterInsertion:		<TwyElement>
	elementBeforeInsertion:		<TwyElement>
	newElement:		<TwyElement>

"
Class {
	#name : #TwyElementInserted,
	#superclass : #TwyTextStateChanged,
	#instVars : [
		'newElement',
		'elementAfterInsertion',
		'elementBeforeInsertion'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyElementInserted class >> on: newElement after: elementBeforeInsertion before: elementAfterInsertion [

	^(self onText: elementBeforeInsertion text) 
		newElement: newElement;
		elementAfterInsertion: elementAfterInsertion;
		elementBeforeInsertion: elementBeforeInsertion 
]

{ #category : #cancelling }
TwyElementInserted >> cancel [
	elementBeforeInsertion attachTo: elementAfterInsertion
]

{ #category : #'layout span correction' }
TwyElementInserted >> correctAffectedLayoutSpansStartingAt: aLayoutSpan by: aLayoutBuilder [

	| command |
	elementBeforeInsertion isSpan ifFalse: [ 	
		aLayoutSpan moveBorderToStartOf: newElement].

	command := TwyBuildLayoutCommand new.
	command 
		leftSpan: aLayoutSpan;
		rightSpan: aLayoutSpan rightSpan;
		elementBeforeInsertion: elementBeforeInsertion;
		elementAfterInsertion: elementAfterInsertion.

	aLayoutBuilder addLayoutCommand: command
]

{ #category : #'cursor position correction' }
TwyElementInserted >> correctPositionOf: aTextCursor [ 
	
	| lastInsertedSpan |
	(aTextCursor isAtEndOf: elementBeforeInsertion) ifFalse: [ ^self ].
	
	lastInsertedSpan := elementAfterInsertion previousSpanIfAbsent: [ self error: 'Should not happen' ].
	
	aTextCursor moveToEndOf: lastInsertedSpan 
]

{ #category : #accessing }
TwyElementInserted >> elementAfterInsertion [
	
	^ elementAfterInsertion
]

{ #category : #accessing }
TwyElementInserted >> elementAfterInsertion: anObject [
	
	elementAfterInsertion := anObject
]

{ #category : #accessing }
TwyElementInserted >> elementBeforeInsertion [
	
	^ elementBeforeInsertion
]

{ #category : #accessing }
TwyElementInserted >> elementBeforeInsertion: anObject [
	
	elementBeforeInsertion := anObject
]

{ #category : #testing }
TwyElementInserted >> isAffectLayoutLine: aLayoutLine [
	
	elementBeforeInsertion isSpan ifTrue: [ 
		^aLayoutLine isLastLineWhichCovers: elementBeforeInsertion].

	^aLayoutLine isFirstLineWhichCovers: elementAfterInsertion
]

{ #category : #testing }
TwyElementInserted >> isAffectLayoutSpan: aLayoutSpan [

	elementBeforeInsertion isSpan ifTrue: [ 
		^aLayoutSpan isLastSpanWhichCovers: elementBeforeInsertion].

	^aLayoutSpan isFirstSpanWhichCovers: elementBeforeInsertion.

]

{ #category : #testing }
TwyElementInserted >> isAffectTextAfterElement: aTextElement [
	^(elementBeforeInsertion isBefore: aTextElement) not
]

{ #category : #testing }
TwyElementInserted >> isAffectTextAt: aTextCursor [
	^false
]

{ #category : #testing }
TwyElementInserted >> isAffectTextBeforeElement: aTextElement [
	^(elementAfterInsertion isAfter: aTextElement) not
]

{ #category : #testing }
TwyElementInserted >> isAfter: aTextCursor [
	^aTextCursor isBeforeElement: newElement
]

{ #category : #testing }
TwyElementInserted >> isBeforeChange: aTextChange [
	
	^aTextChange isAffectTextAfterElement: elementBeforeInsertion 
]

{ #category : #testing }
TwyElementInserted >> isEmbody: anotherTextChange [
	^(anotherTextChange isAffectTextAfterElement: elementBeforeInsertion)
		and: [ anotherTextChange isAffectTextBeforeElement: elementAfterInsertion  ]
]

{ #category : #testing }
TwyElementInserted >> isRedundant [
	^false
]

{ #category : #accessing }
TwyElementInserted >> newElement [
	^ newElement
]

{ #category : #accessing }
TwyElementInserted >> newElement: anObject [
	newElement := anObject
]
