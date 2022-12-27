"
I'm special kind of characters drawer. I hide real characters by drawing it with substitutionChar. I skip characters from excluded list.
I used by text spans with TwySecretAsterixAttribute.
 
    Instance Variables
	excludedChars:		<(Collection of: <Character>)>
	substitutionChar:		<Character>
"
Class {
	#name : #TwySecretCharactersSpanDrawer,
	#superclass : #TwyCharactersSpanDrawer,
	#instVars : [
		'substitutionChar',
		'excludedChars'
	],
	#category : #'Twisty-Layout'
}

{ #category : #'instance creation' }
TwySecretCharactersSpanDrawer class >> withSubstitutionChar: aCharacter [
	^self new 
		substitutionChar: aCharacter
]

{ #category : #drawing }
TwySecretCharactersSpanDrawer >> buildSubstitutionStringFrom: startCursor to: endCursor [ 

	^String streamContents: [ :s |
		(startCursor selectTextUpTo: endCursor) itemsDo: [ :char | 
			(excludedChars includes: char) 
				ifTrue: [ s nextPut: char ]
				ifFalse: [ s nextPut: substitutionChar ]
	 	]	
	] limitedTo: (endCursor spanPosition - startCursor spanPosition)
]

{ #category : #drawing }
TwySecretCharactersSpanDrawer >> drawSpanFrom: startCursor to: endCursor on: aCanvas at: aPoint [

	| substitutionString |
	substitutionString := self buildSubstitutionStringFrom: startCursor to: endCursor.
	
	aCanvas 
		drawString: substitutionString
		from: startCursor spanPosition + 1
		to: endCursor spanPosition 
		at: aPoint 
		font: font
		color: (startCursor span getAttribute: TwyForeColorAttribute)
]

{ #category : #accessing }
TwySecretCharactersSpanDrawer >> excludeChar: aCharacter [
	excludedChars add: aCharacter 
]

{ #category : #accessing }
TwySecretCharactersSpanDrawer >> excludedChars [
	^ excludedChars
]

{ #category : #accessing }
TwySecretCharactersSpanDrawer >> excludedChars: anObject [
	excludedChars := anObject
]

{ #category : #initalize }
TwySecretCharactersSpanDrawer >> initialize [
	super initialize.
	
	excludedChars := OrderedCollection new.
]

{ #category : #accessing }
TwySecretCharactersSpanDrawer >> substitutionChar [
	^ substitutionChar
]

{ #category : #accessing }
TwySecretCharactersSpanDrawer >> substitutionChar: anObject [
	substitutionChar := anObject
]

{ #category : #computing }
TwySecretCharactersSpanDrawer >> widthOf: aCharacter [
	^(excludedChars includes: aCharacter) 
		ifTrue: [ font widthOf: aCharacter ]
		ifFalse: [ font widthOf: substitutionChar ]
]
