"
I present smart character pair. See class side defaults

Instance Variables
	oppositeValue:		<Character>
	value:		<Character>
"
Class {
	#name : #TwySmartChar,
	#superclass : #Object,
	#instVars : [
		'value',
		'oppositeValue'
	],
	#category : #'Twisty-Editor'
}

{ #category : #default }
TwySmartChar class >> defaultPairs [

	^{
		TwySmartChar with: $( and: $).
		TwySmartChar with: $[ and: $].
		TwySmartChar with: ${ and: $}.
		TwySmartChar with: $' and: $'.
		TwySmartChar with: $" and: $".
	}
]

{ #category : #'instance creation' }
TwySmartChar class >> with: mainCharacter and: oppositeCharacter [
	^self new
		value: mainCharacter;
		oppositeValue: oppositeCharacter 
		
]

{ #category : #operations }
TwySmartChar >> insertAt: aTextRegion [ 
	| charBeforeRegion charAfterRegion emptyRegion |
		
	charBeforeRegion := aTextRegion start previousItem.
	charAfterRegion := aTextRegion end nextItem.
	emptyRegion := aTextRegion isEmpty.

	emptyRegion ifFalse: [
		charBeforeRegion = value & charAfterRegion = oppositeValue ifTrue: [ 
			aTextRegion start removePreviousItem.
			^aTextRegion end removeNextItem]
	].
 
	aTextRegion start insert: value asString.
			
	emptyRegion ifTrue: [ 
		((charBeforeRegion isNil or: [ charBeforeRegion isSeparator ])
			and: [ charAfterRegion isNil or: [ charAfterRegion isSeparator ] ])
				ifFalse: [^self].
	].
	
	aTextRegion end insert: oppositeValue asString.
	aTextRegion end moveBackward.
	emptyRegion ifTrue: [ 	aTextRegion start moveBackward ]
]

{ #category : #testing }
TwySmartChar >> isBasedOn: aCharacter [
	^value = aCharacter
]

{ #category : #accessing }
TwySmartChar >> oppositeValue [
	
	^ oppositeValue
]

{ #category : #accessing }
TwySmartChar >> oppositeValue: anObject [
	
	oppositeValue := anObject
]

{ #category : #operations }
TwySmartChar >> removeAsPreviousCharacterAt: aTextRegion [ 
	| charBeforeSelection charAfterSelection |
	
	charBeforeSelection := aTextRegion start previousItem.
	charAfterSelection := aTextRegion end nextItem.
	
	charBeforeSelection = value & charAfterSelection = oppositeValue ifTrue: [ 
			aTextRegion end removeNextItem.
			aTextRegion start removePreviousItem.
			^aTextRegion collapseAtStart].
 
	aTextRegion backspaceKey
]

{ #category : #accessing }
TwySmartChar >> value [
	
	^value
]

{ #category : #accessing }
TwySmartChar >> value: anObject [
	
	value := anObject
]
