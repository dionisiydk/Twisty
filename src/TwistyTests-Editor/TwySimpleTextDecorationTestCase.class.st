Class {
	#name : #TwySimpleTextDecorationTestCase,
	#superclass : #TwyTextDecoratorTestCase,
	#category : #'TwistyTests-Editor'
}

{ #category : #testing }
TwySimpleTextDecorationTestCase class >> isAbstract [ 
	^self == TwySimpleTextDecorationTestCase 
]

{ #category : #tests }
TwySimpleTextDecorationTestCase >> testApplyingAttribute [

	[ 
		[ decorator applyAttribute: #attribute at: textSelection] 
			should strictly satisfy: 
		[ textSelection applyAttribute: #attribute] 
	] runWithMocks
]

{ #category : #tests }
TwySimpleTextDecorationTestCase >> testApplyingDefaultAttribute [

	[ :text |
		[ decorator applyDefaultAttribute: #attribute at: text] 
			should strictly satisfy: 
		[ text applyDefaultAttribute: #attribute] 
	] runWithMocks
]

{ #category : #tests }
TwySimpleTextDecorationTestCase >> testCharactersInsertion [
	[ 
		[ self insertCharacters ] 
			should strictly satisfy: 
		[ textSelection replaceWith: insertedString ] 
	] runWithMocks
]

{ #category : #tests }
TwySimpleTextDecorationTestCase >> testCutSelection [

	[ 
		[ self cutSelection] 
			should strictly satisfy: 
		[ textSelection cut] 
	] runWithMocks
]

{ #category : #tests }
TwySimpleTextDecorationTestCase >> testExtractionNativeValueFromDecoratedString [

	[:decoratedText |
	
		[(decorator extractNativeStringFrom: decoratedText) should be: #decoratedString]
			should strictly satisfy: 
		[ decoratedText asString willReturn: #decoratedString ]
	
	] runWithMocks 
]

{ #category : #tests }
TwySimpleTextDecorationTestCase >> testRemovingNextCharacter [
	[
		[ self removeNextCharacter ] 
			should strictly satisfy: 
		[ textSelection deleteKey ] 
	] runWithMocks
]

{ #category : #tests }
TwySimpleTextDecorationTestCase >> testRemovingPreviousCharacter [
	[ 
		[ self removePreviousCharacter ] 
			should strictly satisfy: 
		[ textSelection backspaceKey ] 
	] runWithMocks
]
