"
I implement general way to decorate editing with simple decoration format. I work only with single line texts. After each text change I replace full text with string which was transformed by my format

Instance Variables
	decorationFormat:		<TwyDecorationFormat>
"
Class {
	#name : #TwySingleLineDecorator,
	#superclass : #TwyNativeTextDecorator,
	#instVars : [
		'decorationFormat'
	],
	#category : #'Twisty-Editor'
}

{ #category : #'instance creation' }
TwySingleLineDecorator class >> smartNumbers [
	^self new 
		decorationFormat: TwySmartNumbersDecorationFormat new
]

{ #category : #editing }
TwySingleLineDecorator >> cutSelection: aTextRegion [

	super cutSelection: aTextRegion.
	
	self transformTextUnder: aTextRegion
]

{ #category : #accessing }
TwySingleLineDecorator >> decorationFormat [
	
	^ decorationFormat
]

{ #category : #accessing }
TwySingleLineDecorator >> decorationFormat: anObject [
	
	decorationFormat := anObject
]

{ #category : #editing }
TwySingleLineDecorator >> extractNativeStringFrom: decoratedText [
	^decorationFormat convertDecoratedStringToNative: decoratedText asString
]

{ #category : #editing }
TwySingleLineDecorator >> insertCharacters: aString at: aTextRegion [

	| lines |
	lines := aString lines.
	
	super insertCharacters: lines first at: aTextRegion.
	
	self transformTextUnder: aTextRegion
]

{ #category : #editing }
TwySingleLineDecorator >> removeNextCharacterAt: aTextRegion [

	super removeNextCharacterAt: aTextRegion.
	
	self transformTextUnder: aTextRegion
]

{ #category : #editing }
TwySingleLineDecorator >> removePreviousCharacterAt: aTextRegion [

	super removePreviousCharacterAt: aTextRegion.
	
	self transformTextUnder: aTextRegion
]

{ #category : #private }
TwySingleLineDecorator >> transformTextUnder: aTextRegion [

	| newText currentLinePosition currentText nativePosition newPosition |
	currentLinePosition := aTextRegion end linePosition.
	aTextRegion selectFullText.
	currentText := aTextRegion asString.
	nativePosition := (decorationFormat convertDecoratedPosition: currentLinePosition toNativeOn: currentText).
	newText := decorationFormat transform: currentText.
	aTextRegion replaceWith: newText.
	newPosition := (decorationFormat convertNativePosition: nativePosition toDecoratedOn: newText).
	aTextRegion end linePosition: newPosition.
	aTextRegion collapseAtEnd.

	
]
