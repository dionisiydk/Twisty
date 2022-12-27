"
I happens when some portion of characters span was insertion.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	insertedCharacters:		<String>
	insertionPosition:		<Integer>
"
Class {
	#name : #TwyCharactersSpanIncreased,
	#superclass : #TwySpanContentsChanged,
	#instVars : [
		'insertionPosition',
		'insertedCharacters'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyCharactersSpanIncreased class >> on: aTwyElement at: insertionPosition with: insertedString initialContents: aString [

	^(self on: aTwyElement initialContents: aString)
		insertionPosition: insertionPosition;
		insertedCharacters: insertedString
]

{ #category : #cancelling }
TwyCharactersSpanIncreased >> cancel [
	
	element deleteFrom: insertionPosition to: insertionPosition + insertedCharacters size
]

{ #category : #'cursor position correction' }
TwyCharactersSpanIncreased >> correctPositionOf: aTextCursor [ 

	(aTextCursor isAt: element) ifFalse: [ ^self ].
	aTextCursor spanPosition < insertionPosition ifTrue: [ ^self ].
	
	aTextCursor moveForward: insertedCharacters size
]

{ #category : #accessing }
TwyCharactersSpanIncreased >> insertedCharacters [
	
	^ insertedCharacters
]

{ #category : #accessing }
TwyCharactersSpanIncreased >> insertedCharacters: anObject [
	
	insertedCharacters := anObject
]

{ #category : #accessing }
TwyCharactersSpanIncreased >> insertionPosition [
	
	^ insertionPosition
]

{ #category : #accessing }
TwyCharactersSpanIncreased >> insertionPosition: anObject [
	
	insertionPosition := anObject
]
