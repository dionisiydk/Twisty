"
I transform text to number format where digit groups splitted on thousands by thousandsSeparator string

Instance Variables
	thousandsSeparator:		<String>

"
Class {
	#name : #TwySmartNumbersDecorationFormat,
	#superclass : #TwyDecorationFormat,
	#instVars : [
		'thousandsSeparator'
	],
	#category : #'Twisty-Editor'
}

{ #category : #operations }
TwySmartNumbersDecorationFormat >> convertDecoratedPosition: index toNativeOn: aString [
	
	| stringBeforeIndex nativeString |
	stringBeforeIndex := aString copyFrom: 1 to: (index min: aString size).
	nativeString := self convertDecoratedStringToNative: stringBeforeIndex.
	
	^index - (stringBeforeIndex size - nativeString size)
]

{ #category : #operations }
TwySmartNumbersDecorationFormat >> convertDecoratedStringToNative: aString [

	^aString copyReplaceAll: thousandsSeparator with: ''.
]

{ #category : #operations }
TwySmartNumbersDecorationFormat >> convertNativePosition: index toDecoratedOn: aString [
	
	| nativeIndex |
	
	index = 0 ifTrue: [ ^index ].
	
	nativeIndex := 0.
	1 to: aString size do: [ :i |
		(thousandsSeparator includes: (aString at: i)) ifFalse: [ 
			nativeIndex := nativeIndex + 1.
		 ].
		nativeIndex >= index ifTrue: [ ^i ]	
	 ]
]

{ #category : #'initialize-release' }
TwySmartNumbersDecorationFormat >> initialize [ 
	super initialize.
	
	thousandsSeparator := ' '
]

{ #category : #accessing }
TwySmartNumbersDecorationFormat >> thousandsSeparator [
	
	^ thousandsSeparator
]

{ #category : #accessing }
TwySmartNumbersDecorationFormat >> thousandsSeparator: anObject [
	
	thousandsSeparator := anObject
]

{ #category : #operations }
TwySmartNumbersDecorationFormat >> transform: aString [ 
	
	| decimalSeparator integerPart stream decimalPart integerStream result |
	decimalSeparator := aString detect: [ :each | each = $. or: [each = $,] ] ifNone: [ nil ].
	decimalSeparator 
		ifNil: [ integerPart := aString ]
		ifNotNil: [ stream := aString readStream.
			integerPart := stream upTo: decimalSeparator.
			decimalPart := stream upToEnd].
	
	integerPart := self convertDecoratedStringToNative: integerPart.
	result := String streamContents: [ :s |
		decimalSeparator ifNotNil: [ s nextPutAll: decimalPart reversed; nextPut: decimalSeparator].
		integerStream := integerPart reversed readStream.
		[integerStream atEnd] whileFalse: [
			s nextPutAll: (integerStream next: 3).
			integerStream atEnd ifFalse: [ s nextPutAll: thousandsSeparator].
		 ]		
	 ].

	^result reversed
]
