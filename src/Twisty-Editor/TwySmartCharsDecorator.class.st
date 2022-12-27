"
I implement smart characters decoration. I can put few symbols on input or remove few symbols on delete or backspace operations

Instance Variables
	smartChars:		<Collection of TwySmartChar>
"
Class {
	#name : #TwySmartCharsDecorator,
	#superclass : #TwyNativeTextDecorator,
	#instVars : [
		'smartChars'
	],
	#category : #'Twisty-Editor'
}

{ #category : #'instance creation' }
TwySmartCharsDecorator class >> default [
	^self with: TwySmartChar defaultPairs
]

{ #category : #'instance creation' }
TwySmartCharsDecorator class >> with: smartCharsCollection [
	^self new
		smartChars: smartCharsCollection 
]

{ #category : #accessing }
TwySmartCharsDecorator >> addSmartChar: aSmartChar [

	smartChars add: aSmartChar
]

{ #category : #'initialize-release' }
TwySmartCharsDecorator >> initialize [ 
	super initialize.
	
	smartChars := OrderedCollection new
]

{ #category : #editing }
TwySmartCharsDecorator >> insertCharacters: aString at: aTextRegion [ 

	| activeChar |
	aString ifEmpty: [ ^self ].		
			
	aString size > 1 ifTrue: [ ^super insertCharacters: aString at: aTextRegion].
	
	activeChar := smartChars detect: [ :each | each isBasedOn: aString first ] ifNone: [ 
		^super insertCharacters: aString at: aTextRegion].
	
	activeChar insertAt: aTextRegion
	

]

{ #category : #editing }
TwySmartCharsDecorator >> removePreviousCharacterAt: aTextRegion [ 

	| activeChar previousChar |
	(smartChars isEmpty or: [aTextRegion isEmpty not]) ifTrue: [ ^super removePreviousCharacterAt: aTextRegion].

	previousChar := aTextRegion end previousItem.
	activeChar := smartChars detect: [ :each | each isBasedOn: previousChar ] ifNone: [ 
		^super removePreviousCharacterAt: aTextRegion].
	
	activeChar removeAsPreviousCharacterAt: aTextRegion
	

]

{ #category : #accessing }
TwySmartCharsDecorator >> smartChars [
	
	^ smartChars
]

{ #category : #accessing }
TwySmartCharsDecorator >> smartChars: anObject [
	
	smartChars := anObject
]
