"
I'm stream of TwyElement's. I have source characters stream which I used to produce text elements.
I used to convert string to TwyText

Public API and Key Messages

- next  
- do: 
- atEnd
- class side #on: characters stream
 
Internal Representation and Key Implementation Points.

    Instance Variables
	charactersPerSpan:		<Number>
	currentCharacters:		<WriteStream>
	separators:		<String>
	sourceStream:		<ReadStream>

I use separators to split different kind of text elements like CR and TAB. And I split character spans by maximum items (charactersPerSpan)
"
Class {
	#name : #TwyElementsReadStream,
	#superclass : #Object,
	#instVars : [
		'sourceStream',
		'charactersPerSpan',
		'currentCharacters',
		'separators'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyElementsReadStream class >> on: aReadStream [ 
	^self new 
		sourceStream: aReadStream
]

{ #category : #testing }
TwyElementsReadStream >> atEnd [
	^sourceStream atEnd
]

{ #category : #accessing }
TwyElementsReadStream >> charactersPerSpan [
	
	^ charactersPerSpan
]

{ #category : #accessing }
TwyElementsReadStream >> charactersPerSpan: anObject [
	
	charactersPerSpan := anObject
]

{ #category : #enumeration }
TwyElementsReadStream >> do: aBlockClosure [ 
	[self atEnd] whileFalse: [ aBlockClosure value: self next ]
]

{ #category : #'initialize-release' }
TwyElementsReadStream >> initialize [ 
	super initialize.
	
	currentCharacters := WriteStream on: (String new: 100).
	separators := String cr, String tab.
	charactersPerSpan := 200
]

{ #category : #'reading elements' }
TwyElementsReadStream >> next [

	| separator |
	
	self readNextCharacters.
	
	currentCharacters isEmpty ifFalse: [ ^TwyCharactersSpan with: currentCharacters contents].
	
	separator := sourceStream next.
	separator = Character cr ifTrue: [^TwyLineStart new].
	separator = Character tab ifTrue: [ ^TwyTabSpan new].
	
	self error: 'Unknown text separator'
]

{ #category : #private }
TwyElementsReadStream >> readNextCharacters [

	currentCharacters resetContents.

	[ (sourceStream atEnd or: [ currentCharacters size = charactersPerSpan ]) 
		or: [ separators includes: sourceStream peek ] ] whileFalse: [ 
			currentCharacters nextPut: sourceStream next 
	]
]

{ #category : #accessing }
TwyElementsReadStream >> sourceStream [
	^ sourceStream
]

{ #category : #accessing }
TwyElementsReadStream >> sourceStream: anObject [
	sourceStream := anObject
]
