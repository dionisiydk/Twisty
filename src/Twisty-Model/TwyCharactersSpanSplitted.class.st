"
I am event about insertion new span which was separated  during splitting characters span.

newElement is new separated span
elementBeforeInsertion is splitted span
elementAfterInsertion is next element after splitted span 
splitPosition is position inside splitted element where splitting was happen
"
Class {
	#name : #TwyCharactersSpanSplitted,
	#superclass : #TwyElementInserted,
	#instVars : [
		'splitPosition'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyCharactersSpanSplitted class >> at: splitPosition by: separatedSpan [

	^(self on: separatedSpan after: separatedSpan previous before: separatedSpan next)
		splitPosition: splitPosition
]

{ #category : #'cursor position correction' }
TwyCharactersSpanSplitted >> correctPositionOf: aTextCursor [ 

	(aTextCursor isAt: self splittedSpan) ifFalse: [ ^self ].

	aTextCursor spanPosition < splitPosition ifTrue: [ ^self ].
	
	aTextCursor 
		moveToSpan: self separatedSpan 
		at: aTextCursor spanPosition - splitPosition 
]

{ #category : #accessing }
TwyCharactersSpanSplitted >> separatedSpan [
	^self newElement
]

{ #category : #accessing }
TwyCharactersSpanSplitted >> separatedSpan: aCharactersSpan [
	self newElement: aCharactersSpan
]

{ #category : #accessing }
TwyCharactersSpanSplitted >> splitPosition [
	
	^ splitPosition
]

{ #category : #accessing }
TwyCharactersSpanSplitted >> splitPosition: anObject [
	
	splitPosition := anObject
]

{ #category : #accessing }
TwyCharactersSpanSplitted >> splittedSpan [
	^self elementBeforeInsertion
]

{ #category : #accessing }
TwyCharactersSpanSplitted >> splittedSpan: aCharactersSpan [
	self elementBeforeInsertion: aCharactersSpan
]
