"
I'm the root of the hierarchy of text attributes classes.
Any text span and text itself contains collection of attributes. 
"
Class {
	#name : #TwyAttribute,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : #'Twisty-Model'
}

{ #category : #accessing }
TwyAttribute class >> defaultValue [
	self subclassResponsibility 
]

{ #category : #'instance creation' }
TwyAttribute class >> with: valueObject [
	^self new 
		value: valueObject 
]

{ #category : #comparing }
TwyAttribute >> = anotherAttribute [
	self class = anotherAttribute class ifFalse: [ ^false].
	
	^value = anotherAttribute value
]

{ #category : #comparing }
TwyAttribute >> hash [ 
	^value hash
]

{ #category : #printing }
TwyAttribute >> printOn: aStream [ 
	super printOn: aStream.
	aStream 
		nextPut: $(;
		print: value;
		nextPut: $)
]

{ #category : #accessing }
TwyAttribute >> value [
	^ value
]

{ #category : #accessing }
TwyAttribute >> value: anObject [
	value := anObject
]
