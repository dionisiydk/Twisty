"
I happens when some portion of characters span was removed
 
Internal Representation and Key Implementation Points.

    Instance Variables
	deletionEnd:		<Integer>
	deletionStart:		<Integer>

"
Class {
	#name : #TwyCharactersSpanDecreased,
	#superclass : #TwySpanContentsChanged,
	#instVars : [
		'deletionStart',
		'deletionEnd'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyCharactersSpanDecreased class >> on: aTwyElement from: deletionStart to: deletionEnd initialContents: aString [

	^(self on: aTwyElement initialContents: aString)
		deletionStart: deletionStart;
		deletionEnd: deletionEnd
]

{ #category : #cancelling }
TwyCharactersSpanDecreased >> cancel [

	element insertSimpleString: self removedCharacters at: deletionStart
]

{ #category : #'cursor position correction' }
TwyCharactersSpanDecreased >> correctPositionOf: aTextCursor [ 
	
	(aTextCursor isAt: element) ifFalse: [ ^self ].

	aTextCursor spanPosition <= deletionStart ifTrue: [ ^self ].
	
	aTextCursor spanPosition >= deletionEnd ifTrue: [ 
		^ aTextCursor moveBackward: deletionEnd - deletionStart ].
	
	aTextCursor spanPosition: deletionStart
]

{ #category : #accessing }
TwyCharactersSpanDecreased >> deletionEnd [
	
	^ deletionEnd
]

{ #category : #accessing }
TwyCharactersSpanDecreased >> deletionEnd: anObject [
	
	deletionEnd := anObject
]

{ #category : #accessing }
TwyCharactersSpanDecreased >> deletionStart [
	
	^ deletionStart
]

{ #category : #accessing }
TwyCharactersSpanDecreased >> deletionStart: anObject [
	
	deletionStart := anObject
]

{ #category : #accessing }
TwyCharactersSpanDecreased >> removedCharacters [

	^initialContents copyFrom: deletionStart + 1 to: deletionEnd 
]

{ #category : #accessing }
TwyCharactersSpanDecreased >> removedItemsBetween: startCursor and: endCursor [

	^initialContents 
		copyFrom: (deletionStart max: startCursor spanPosition) + 1 
		to: (deletionEnd min: endCursor spanPosition)
]
