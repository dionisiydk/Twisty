"
I validate strings which represent decimal numbers

Instance Variables
	decimalSeparators:		<String>
	decimalDigitsCount:		<Integer>
			
decimalSeparators
	- collection (string) of possible decimal separators
decimalDigitsCount
	- max decimal digits which allowed for given string

"
Class {
	#name : #TwyDecimalTextSpec,
	#superclass : #TwyTextSpec,
	#instVars : [
		'decimalSeparators',
		'decimalDigitsCount'
	],
	#category : #'Twisty-Editor'
}

{ #category : #'instance creation' }
TwyDecimalTextSpec class >> maxDecimalDigits: aNumber [
	^self new 
		decimalDigitsCount: aNumber
]

{ #category : #testing }
TwyDecimalTextSpec >> check: aString [

	| activeSeparator decimalPart |
	aString ifEmpty: [ ^true ].
	decimalDigitsCount = 0 ifTrue: [ ^aString isAllDigits ].
	
	activeSeparator := aString detect: [ :each | decimalSeparators includes: each ] ifNone: [ 
		^aString isAllDigits ].
	
	(aString occurrencesOf:  activeSeparator) > 1 ifTrue: [ ^false ].
	
	(aString allSatisfy: [ :each | each = activeSeparator or: [each isDigit]  ])
		ifFalse: [ ^false].
		
	decimalPart := aString readStream upTo: activeSeparator; upToEnd.
	^decimalPart size <= decimalDigitsCount 
]

{ #category : #accessing }
TwyDecimalTextSpec >> decimalDigitsCount [
	^ decimalDigitsCount
]

{ #category : #accessing }
TwyDecimalTextSpec >> decimalDigitsCount: anObject [
	decimalDigitsCount := anObject
]

{ #category : #accessing }
TwyDecimalTextSpec >> decimalSeparators [
	^ decimalSeparators
]

{ #category : #accessing }
TwyDecimalTextSpec >> decimalSeparators: anObject [
	decimalSeparators := anObject
]

{ #category : #'initialize-release' }
TwyDecimalTextSpec >> initialize [ 
	super initialize.
	
	decimalSeparators := '.'.
	decimalDigitsCount := 2
]
