"
My subclasses should implement #check: message to validate given string

Instance Variables

"
Class {
	#name : #TwyTextSpec,
	#superclass : #Object,
	#category : #'Twisty-Editor'
}

{ #category : #testing }
TwyTextSpec >> check: verifiedString [

	self subclassResponsibility 
]
