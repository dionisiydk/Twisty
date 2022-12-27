"
I present group of text characters with particular attributes 

Public API and Key Messages

- insertSimpleString: aString at: index 

Internal Representation and Key Implementation Points.

    Instance Variables
	contents:		<String>
"
Class {
	#name : #TwyCharactersSpan,
	#superclass : #TwySpan,
	#instVars : [
		'contents'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyCharactersSpan class >> of: aText with: aString [
	^(self of: aText)
		contents: aString
]

{ #category : #'instance creation' }
TwyCharactersSpan class >> with: aString [
	^self new 
		contents: aString
]

{ #category : #converting }
TwyCharactersSpan >> asStringOn: aStream [

	aStream nextPutAll: contents
]

{ #category : #converting }
TwyCharactersSpan >> asStringOn: aStream startingAt: startIndex upTo: endIndex [

	startIndex >= self length ifTrue: [ ^'' ].

	aStream nextPutAll: (contents copyFrom: ((startIndex + 1) min:  self length) to: (endIndex min: self length))
]

{ #category : #testing }
TwyCharactersSpan >> canIntegrate: aCharactersSpan [ 
	aCharactersSpan isEmpty ifTrue: [ ^true ].
	
	^aCharactersSpan hasSpecificAttributes not
]

{ #category : #accessing }
TwyCharactersSpan >> contents [
	
	^ contents
]

{ #category : #accessing }
TwyCharactersSpan >> contents: anObject [
	
	contents := anObject
]

{ #category : #copying }
TwyCharactersSpan >> copy [
	| copy |
	copy := super copy.

	copy contents: contents copy.	

	^copy
]

{ #category : #editing }
TwyCharactersSpan >> delete [
"
	we not delete single span at line. Line should always contain almost one span
"
	| deletedContents |
	previous isSpan | next isSpan ifTrue: [ ^super delete ].
	
	contents ifEmpty: [ ^self ].
	
	deletedContents := contents.
	
	contents := String empty.
	
	self publishChange: (TwyCharactersSpanDecreased on: self from: 0 to: deletedContents size initialContents: deletedContents).
]

{ #category : #editing }
TwyCharactersSpan >> deleteAllAfter: startIndex [

	^self deleteFrom: startIndex to: self length
]

{ #category : #editing }
TwyCharactersSpan >> deleteAllBefore: endIndex [

	^self deleteFrom: 0 to: endIndex
]

{ #category : #editing }
TwyCharactersSpan >> deleteFrom: startIndex to: endIndex [

	| initialContents |
	startIndex = endIndex & self isEmpty not ifTrue: [ ^self ].
	startIndex = 0 & endIndex = self length ifTrue: [ ^self delete].

	initialContents := contents.

	contents := (contents copyFrom: 1 to: startIndex), (contents copyFrom: endIndex + 1 to: self length).
	
	self publishChange: (TwyCharactersSpanDecreased on: self from: startIndex to: endIndex initialContents: initialContents).

]

{ #category : #editing }
TwyCharactersSpan >> deleteIfRedundant [
"
	we want no empty spans at line when there are another spans at line. #delete already has this logic
"
	self isEmpty ifTrue: [self delete]
]

{ #category : #drawing }
TwyCharactersSpan >> drawOn: aCanvas from: start to: end at: aPoint font: aFont [

	aCanvas 
		drawString: contents
		from: start
		to: end 
		at: aPoint 
		font: aFont
		color: (self getAttribute: TwyForeColorAttribute)
]

{ #category : #'initialize-release' }
TwyCharactersSpan >> initialize [ 
	super initialize.
	contents := String empty
]

{ #category : #editing }
TwyCharactersSpan >> insertInto: targetSpan at: spanPosition [

	(targetSpan canIntegrate: self)
		ifFalse: [^targetSpan insertTextStartedWith: self at: spanPosition].
			
	targetSpan insertSimpleString: contents at: spanPosition.
	
	next isTextEnd ifTrue: [ ^self ].
	
	targetSpan insertTextStartedWith: next at: spanPosition + contents size.
]

{ #category : #editing }
TwyCharactersSpan >> insertSimpleString: aString at: index [
"
	simple string should be single line and without special characters like tabs
"
	| initialContents |
	aString ifEmpty: [ ^self ].
	
	initialContents := contents.
	
	contents := String new: contents size + aString size streamContents: [:writeStream |  | readStream |
		readStream := contents readStream.
		writeStream
			nextPutAll: (readStream next: index);
			nextPutAll: aString;
			nextPutAll: readStream upToEnd.
	].

	self publishChange: (TwyCharactersSpanIncreased on: self at: index with: aString initialContents: initialContents).

	
]

{ #category : #testing }
TwyCharactersSpan >> isEmpty [
	^contents isEmpty
]

{ #category : #accessing }
TwyCharactersSpan >> itemAt: anIndex ifAbsent:  aBlock [

	^contents at: anIndex ifAbsent: aBlock	
]

{ #category : #accessing }
TwyCharactersSpan >> length [
	^contents size
]

{ #category : #editing }
TwyCharactersSpan >> overrideContentsFrom: startIndex to: endIndex with: newString [

	| actualEndIndex overrideLength overrideString initialContents change |
	
	startIndex = self length ifTrue: [ ^TwyOverrideResult noChangesBy: newString ].
	actualEndIndex := endIndex min: self length.
	
	overrideLength := actualEndIndex - startIndex min: newString size.
	overrideString := (newString size <= overrideLength) ifTrue: [ newString ] ifFalse: [ newString first: overrideLength ].
	
	initialContents := contents.
	contents := String streamContents: [ :s | 
			s nextPutAll: (contents copyFrom: 1 to: startIndex).
			s nextPutAll: overrideString.
			s nextPutAll: (contents copyFrom: startIndex + overrideString size + 1 to: contents size )] 
		limitedTo: contents size.

	change := TwySpanContentsOverridden 
		on: self from: startIndex to: startIndex + overrideString size initialContents: initialContents.
	self publishChange: change.
		
	^TwyOverrideResult of: change by: newString
]

{ #category : #printing }
TwyCharactersSpan >> printOn: aStream [

	aStream 
		nextPutAll: '<<';
		nextPutAll: contents;
		nextPutAll: '>>'
]

{ #category : #editing }
TwyCharactersSpan >> splitAt: index [

	| splittedContents separatedSpan |
	index = 0 | (index = self length) ifTrue: [ ^self].

	splittedContents := contents copyFrom: index + 1 to: self length.
	
	separatedSpan := TwyCharactersSpan of: text with: splittedContents.
	separatedSpan attributes: attributes copy.
	separatedSpan computeOrderBetween: self and: next.
	separatedSpan next: next.
	self next: separatedSpan.
	
	self publishChange: (TwyCharactersSpanSplitted at: index by: separatedSpan).
	
	self deleteAllAfter: index
]
