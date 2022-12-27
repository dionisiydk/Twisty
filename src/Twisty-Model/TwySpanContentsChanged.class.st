"
I'm the root of the hierarchy of changes which affect contents of characters span.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	initialContents:		<String>

"
Class {
	#name : #TwySpanContentsChanged,
	#superclass : #TwyElementChanged,
	#instVars : [
		'initialContents'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwySpanContentsChanged class >> on: aTwyElement initialContents: aString [

	^(self on: aTwyElement)
		initialContents: aString
]

{ #category : #accessing }
TwySpanContentsChanged >> initialContents [
	
	^ initialContents
]

{ #category : #accessing }
TwySpanContentsChanged >> initialContents: anObject [
	
	initialContents := anObject
]
