"
I'm collection of text attributes

    Instance Variables
	contents:		Collection of TwyAttribute's


"
Class {
	#name : #TwyAttributes,
	#superclass : #Object,
	#instVars : [
		'contents'
	],
	#category : #'Twisty-Model'
}

{ #category : #accessing }
TwyAttributes >> add: aTwyAttribute [ 
	contents at: aTwyAttribute class put: aTwyAttribute 
]

{ #category : #accessing }
TwyAttributes >> add: anAttrabuteClass with: attributeValue [
	self add: (anAttrabuteClass with: attributeValue)
]

{ #category : #accessing }
TwyAttributes >> contents [
	^ contents
]

{ #category : #accessing }
TwyAttributes >> contents: anObject [
	contents := anObject
]

{ #category : #copying }
TwyAttributes >> copy [
	| copy |
	copy := super copy.
	
	copy contents: (contents collect: [:each | each deepCopy]).
	
	^copy
	
]

{ #category : #enumeration }
TwyAttributes >> do: aBlock [
	^contents do: aBlock
]

{ #category : #accessing }
TwyAttributes >> get: anAttributeClass ifAbsent: aBlock [

	^contents at: anAttributeClass ifAbsent: aBlock
]

{ #category : #testing }
TwyAttributes >> includes: aTextAttributeClass [
	^contents includesKey: aTextAttributeClass
]

{ #category : #'initialize-release' }
TwyAttributes >> initialize [ 
	super initialize.
	
	contents := Dictionary new
]

{ #category : #testing }
TwyAttributes >> isEmpty [
	^contents isEmpty
]

{ #category : #printing }
TwyAttributes >> printOn: aStream [

	super printOn: aStream.
	contents values printElementsOn: aStream
]

{ #category : #accessing }
TwyAttributes >> remove: aTwyAttributeClass [

	contents removeKey: aTwyAttributeClass ifAbsent: [  ]
]

{ #category : #accessing }
TwyAttributes >> valueOf: anAttributeClass ifAbsent: aBlock [

	| attribute |
	attribute := self get: anAttributeClass ifAbsent: aBlock.
	^attribute value
]
