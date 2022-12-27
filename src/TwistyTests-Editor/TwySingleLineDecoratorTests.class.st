Class {
	#name : #TwySingleLineDecoratorTests,
	#superclass : #TwyTextDecoratorTestCase,
	#instVars : [
		'decorationFormat'
	],
	#category : #'TwistyTests-Editor'
}

{ #category : #running }
TwySingleLineDecoratorTests >> decoratorClass [
	^TwySingleLineDecorator 
]

{ #category : #running }
TwySingleLineDecoratorTests >> setUp [
	super setUp.
	
	decorationFormat := Mock new.
	decorator decorationFormat: decorationFormat
]

{ #category : #tests }
TwySingleLineDecoratorTests >> testCharactersInsertion [
	[ 
		[ self insertCharacters ] 
			should strictly satisfy: 
		[ textSelection replaceWith: insertedString.
		self transformTextModel ] 
	] runWithMocks
]

{ #category : #tests }
TwySingleLineDecoratorTests >> testCutSelection [

	[ 
		[ self cutSelection] 
			should strictly satisfy: 
		[ textSelection cut.
		self transformTextModel] 
	] runWithMocks
]

{ #category : #tests }
TwySingleLineDecoratorTests >> testExtractionNativeValueFromDecoratedString [

	[ :decoratedText |
		[ (decorator extractNativeStringFrom: decoratedText) should be: #result] 
			should strictly satisfy: 
		[decoratedText asString willReturn: #decoratedString. 
		(decorationFormat convertDecoratedStringToNative: #decoratedString) willReturn: #result] 
	] runWithMocks
]

{ #category : #tests }
TwySingleLineDecoratorTests >> testMultipleLinesInsertion [
	[ 
		insertedString := 'line1', String cr, 'line2'.
		[ self insertCharacters ] 
			should strictly satisfy: 
		[ textSelection replaceWith: 'line1'.
		self transformTextModel ] 
	] runWithMocks
]

{ #category : #tests }
TwySingleLineDecoratorTests >> testRemovingNextCharacter [
	[
		[ self removeNextCharacter ] 
			should strictly satisfy: 
		[ textSelection deleteKey.
		self transformTextModel ] 
	] runWithMocks
]

{ #category : #tests }
TwySingleLineDecoratorTests >> testRemovingPreviousCharacter [
	[ 
		[ self removePreviousCharacter ] 
			should strictly satisfy: 
		[ textSelection backspaceKey.
		self transformTextModel ] 
	] runWithMocks
]

{ #category : #specs }
TwySingleLineDecoratorTests >> transformTextModel [
	selectionEnd linePosition willReturn: #initialLinePosition.
	textSelection selectFullText.
	textSelection asString willReturn: #initialText.
	(decorationFormat convertDecoratedPosition: #initialLinePosition toNativeOn: #initialText) willReturn: #nativePosition.
	(decorationFormat transform: #initialText) willReturn: #newText.
	textSelection replaceWith: #newText.
	(decorationFormat convertNativePosition: #nativePosition toDecoratedOn: #newText) willReturn: #newPosition.
	selectionEnd linePosition: #newPosition.
	textSelection collapseAtEnd
]
