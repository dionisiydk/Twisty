Class {
	#name : #TwyOverwriteModeDecoratorTests,
	#superclass : #TwySimpleTextDecorationTestCase,
	#category : #'TwistyTests-Editor'
}

{ #category : #running }
TwyOverwriteModeDecoratorTests >> decoratorClass [
	^TwyOverwriteModeDecorator
]

{ #category : #tests }
TwyOverwriteModeDecoratorTests >> testCharactersInsertion [

	[ 
		[ self insertCharacters]
			should strictly satisfy: 
		[selectionEnd moveForward: insertedString size.
		textSelection replaceWith: insertedString ]
	] runWithMocks
]

{ #category : #tests }
TwyOverwriteModeDecoratorTests >> testRealCharactersInsertion [

	| text |
	text := decorator defaultText.
	textSelection := text newRegion.
	textSelection replaceWith: '12345'.
	textSelection end moveToTextStart.
	textSelection start moveToTextStart.
	
	decorator insertCharacters: 'ABC' at: textSelection.
	
	text asString should equal: 'ABC45'
]
