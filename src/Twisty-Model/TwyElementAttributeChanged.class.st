"
I happens when text element attribute changed
"
Class {
	#name : #TwyElementAttributeChanged,
	#superclass : #TwyElementChanged,
	#instVars : [
		'initialAttribute',
		'newAttribute'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyElementAttributeChanged class >> on: aTextElement initialAttribute: aTextAttribute newAttribute: aTextAttribute2 [

	^(self on: aTextElement)
		initialAttribute: aTextAttribute;
		newAttribute: aTextAttribute2
]

{ #category : #cancelling }
TwyElementAttributeChanged >> cancel [
	
	initialAttribute ifNil: [ ^element removeAttribute: newAttribute ].
	
	element applyAttribute: initialAttribute
]

{ #category : #'cursor position correction' }
TwyElementAttributeChanged >> correctPositionOf: aTextCursor [
]

{ #category : #accessing }
TwyElementAttributeChanged >> initialAttribute [
	
	^ initialAttribute
]

{ #category : #accessing }
TwyElementAttributeChanged >> initialAttribute: anObject [
	
	initialAttribute := anObject
]

{ #category : #accessing }
TwyElementAttributeChanged >> newAttribute [
	
	^ newAttribute
]

{ #category : #accessing }
TwyElementAttributeChanged >> newAttribute: anObject [
	
	newAttribute := anObject
]
