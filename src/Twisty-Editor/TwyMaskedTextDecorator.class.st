"
I implement masked text decoration.

Instance Variables
	mask:		<TwyText>

mask
	- text mask with editable regions marked by TwyMaskAsterixAttribute where
"
Class {
	#name : #TwyMaskedTextDecorator,
	#superclass : #TwyTextDecorator,
	#instVars : [
		'mask'
	],
	#category : #'Twisty-Editor'
}

{ #category : #'instance creation' }
TwyMaskedTextDecorator class >> withMaskFromString: stringWithAsterixes [
	^self withMaskFromString: stringWithAsterixes whereAsterixIs: $*
]

{ #category : #'instance creation' }
TwyMaskedTextDecorator class >> withMaskFromString: stringWithAsterixes whereAsterixIs: maskAsterixChar [ 
	^self new 
		maskString: stringWithAsterixes whereAsterixIs: maskAsterixChar
]

{ #category : #'instance creation' }
TwyMaskedTextDecorator class >> withMaskFromString: stringWithAsterixes whereAsterixIs: maskAsterixChar whichHideCharactersBy: secretMaskString withAsterix: secretAsterixChar [
	^(self withMaskFromString: stringWithAsterixes whereAsterixIs: maskAsterixChar)
		hideCharactersBy: secretMaskString withAsterix: secretAsterixChar;
		yourself
]

{ #category : #'instance creation' }
TwyMaskedTextDecorator class >> withMaskFromString: stringWithAsterixes whichHideCharactersBy: secretMaskString withAsterix: secretAsterixChar [
	^(self withMaskFromString: stringWithAsterixes)
		hideCharactersBy: secretMaskString withAsterix: secretAsterixChar;
		yourself
]

{ #category : #editing }
TwyMaskedTextDecorator >> cutSelection: aTextRegion [
]

{ #category : #accessing }
TwyMaskedTextDecorator >> defaultText [
	^mask copy
]

{ #category : #editing }
TwyMaskedTextDecorator >> extractNativeStringFrom: decoratedText [

	| inputValues |
	^String streamContents: [ :out |
		
		decoratedText spansDo: [ :eachSpan |
			(eachSpan hasAttribute: TwyMaskAsterixAttribute) ifTrue: [
				inputValues := eachSpan contents reject: [ :eachItem | 
					eachItem = (eachSpan getAttribute: TwyMaskAsterixAttribute) ].
				out nextPutAll: inputValues]
		]
	]
]

{ #category : #accessing }
TwyMaskedTextDecorator >> hideCharactersBy: secretMaskString withAsterix: secretAsterixChar [
	
	| secreteMaskStream |
	secreteMaskStream := secretMaskString readStream.
	
	mask withSubRegionDo: [:start :end :region |
		
		[start isAtEnd ] whileFalse: [ 
			[start hasAttribute: TwyMaskAsterixAttribute] whileFalse: [ start moveToSpanEnd; moveToStartOfNextSpan.
				start isAtEnd ifTrue: [ ^self ] ].
		
			[ secreteMaskStream atEnd not and: [ secreteMaskStream peek = $x]] whileTrue: [ start moveForward. secreteMaskStream next ].
			
			end moveTo: start.
			[end isAtSpanEnd not and: [ secreteMaskStream atEnd not and: [ secreteMaskStream peek = $*] ]] whileTrue: [ end moveForward. secreteMaskStream next ].
		
			region applyAttribute: TwySecretAsterixAttribute with: secretAsterixChar.
			
			region isEmpty 
				ifTrue: [	start isAtSpanEnd ifTrue: [ start moveToStartOfNextSpan ] ifFalse: [start moveForward]]
				ifFalse: [start moveTo: end]
			
			]		
	]

]

{ #category : #editing }
TwyMaskedTextDecorator >> insertCharacters: aString at: aTextRegion [

	| lastOverrideResult |
	lastOverrideResult := TwyOverrideResult noChangesBy: aString.
	aTextRegion end moveToTextEnd.
	
	aTextRegion 
		splittedBySpansDo: [ :spanRegion | 
			(spanRegion hasAttribute: TwyMaskAsterixAttribute) ifTrue: [ 
				lastOverrideResult := spanRegion overridePossibleCharactersWith: lastOverrideResult restString]
		]
		while: [:spanRegion | lastOverrideResult hasRestString].	
	
	lastOverrideResult ifNotNil: [ lastOverrideResult moveToEnd: aTextRegion] 
]

{ #category : #accessing }
TwyMaskedTextDecorator >> mask [
	
	^ mask
]

{ #category : #accessing }
TwyMaskedTextDecorator >> mask: anObject [
	
	mask := anObject
]

{ #category : #accessing }
TwyMaskedTextDecorator >> maskString: stringWithAsterixes whereAsterixIs: asterixCharacter [

	mask := stringWithAsterixes asTwyText.
	mask 
		withRegionsWhereCharactersAre: [:eachChar | eachChar = asterixCharacter]
		do: [:region | region applyAttribute: TwyMaskAsterixAttribute with: asterixCharacter]
]

{ #category : #editing }
TwyMaskedTextDecorator >> removeNextCharacterAt: aTextRegion [
]

{ #category : #editing }
TwyMaskedTextDecorator >> removePreviousCharacterAt: aTextRegion [
	
	| wasMoved |
	aTextRegion isEmpty ifFalse: [^self].
	
	((aTextRegion hasAttribute: TwyMaskAsterixAttribute) not or: [ aTextRegion start isAtSpanStart ]) ifTrue: [  
		
		wasMoved := aTextRegion start moveBackwardToSpanWhich: [:eachSpan | eachSpan hasAttribute: TwyMaskAsterixAttribute].
		wasMoved ifFalse: [ ^self ].

		aTextRegion start moveToSpanEnd.
	].

	aTextRegion collapseAtStart.
	aTextRegion start moveBackward.
	aTextRegion overridePossibleCharactersWith: (aTextRegion getStartAttribute: TwyMaskAsterixAttribute) asString.
	aTextRegion collapseAtStart.
]
