"
I happens when some portion of characters span was overridden.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	overrideEnd:		<Integer>
	overrideStart:		<Integer>

"
Class {
	#name : #TwySpanContentsOverridden,
	#superclass : #TwySpanContentsChanged,
	#instVars : [
		'overrideStart',
		'overrideEnd'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwySpanContentsOverridden class >> on: aCharactersSpan from: startPosition to: endPosition initialContents: aString [
	^(self on: aCharactersSpan initialContents: aString)
		overrideStart: startPosition;
		overrideEnd: endPosition
]

{ #category : #cancelling }
TwySpanContentsOverridden >> cancel [

	| overrideString |
	overrideString := initialContents copyFrom: overrideStart + 1 to: overrideEnd.

	element overrideContentsFrom: overrideStart to: overrideEnd with: overrideString
]

{ #category : #'cursor position correction' }
TwySpanContentsOverridden >> correctPositionOf: aTextCursor [
]

{ #category : #'cursor position correction' }
TwySpanContentsOverridden >> moveToEnd: aTextRegion [

	aTextRegion end moveToSpan: element at: overrideEnd.
	aTextRegion collapseAtEnd
]

{ #category : #accessing }
TwySpanContentsOverridden >> overrideEnd [
	
	^ overrideEnd
]

{ #category : #accessing }
TwySpanContentsOverridden >> overrideEnd: anObject [
	
	overrideEnd := anObject
]

{ #category : #accessing }
TwySpanContentsOverridden >> overrideStart [
	
	^ overrideStart
]

{ #category : #accessing }
TwySpanContentsOverridden >> overrideStart: anObject [
	
	overrideStart := anObject
]

{ #category : #accessing }
TwySpanContentsOverridden >> overridenItemsCount [
	^overrideEnd - overrideStart
]
