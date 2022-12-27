"
My subclasses decorate text editing with specific way. All text editing operations passed to me by TwyEditor inside text editing block.

There are two not editing operations which specific decorators can implement differently.
- defaultText 
	should create default text instance. For example TwyMaskedTextDecorator returns copy of mask instance.
- extractNativeStringFrom: aTwyText
	should extract native contents of decorated text. For TwyMaskedTextDecorator it is only ""asterix part"" of mask.
"
Class {
	#name : #TwyTextDecorator,
	#superclass : #Object,
	#category : #'Twisty-Editor'
}

{ #category : #editing }
TwyTextDecorator >> applyAttribute: aTwyAttribute at: aTextRegion [
	aTextRegion applyAttribute: aTwyAttribute 
]

{ #category : #editing }
TwyTextDecorator >> applyDefaultAttribute: aTwyAttribute at: aTwyText [
	aTwyText applyDefaultAttribute: aTwyAttribute 
]

{ #category : #editing }
TwyTextDecorator >> applyParagraphAttribute: aTwyAttribute at: aTextRegion [
	aTextRegion applyParagraphAttribute: aTwyAttribute 
]

{ #category : #editing }
TwyTextDecorator >> cutSelection: aTextRegion [ 	
	self subclassResponsibility 
]

{ #category : #accessing }
TwyTextDecorator >> defaultText [
	^TwyText new
]

{ #category : #editing }
TwyTextDecorator >> extractNativeStringFrom: decoratedText [
	^decoratedText asString
]

{ #category : #editing }
TwyTextDecorator >> insertCharacters: aString at: aTextRegion [ 	
	self subclassResponsibility 
]

{ #category : #editing }
TwyTextDecorator >> removeNextCharacterAt: aTextRegion [ 	
	self subclassResponsibility 
]

{ #category : #editing }
TwyTextDecorator >> removePreviousCharacterAt: aTextRegion [ 	
	self subclassResponsibility 
]
