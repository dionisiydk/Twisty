Class {
	#name : #TwyEditorTests,
	#superclass : #TestCase,
	#instVars : [
		'editor',
		'selectedText',
		'text',
		'textValidator',
		'textDecorator'
	],
	#category : #'TwistyTests-Editor'
}

{ #category : #running }
TwyEditorTests >> setUp [ 	
	super setUp.
	
	text := Mock new.
	selectedText := Mock new.
	textValidator := Mock new.
	textDecorator := Mock new.
	
	editor := TwyEditor new.
	editor 
		text: text;
		selectedText: selectedText;
		textValidator: textValidator;
		textDecorator: textDecorator
]

{ #category : #tests }
TwyEditorTests >> testChangeTextWithBlock [

	[
		[ editor changeTextWith: #block]
			should strictly satisfy: 
		[( text editContentsBy: #block andSubmitChangesBy: Any) will: [:arg1 :validationBlock | 
			validationBlock value should be: true].
		(textValidator validateText: text decoratedBy: textDecorator) willReturn: true]
			
 	] runWithMocks  
]

{ #category : #tests }
TwyEditorTests >> testChangeTextWithBlockShouldNotRestSelectionWhenValidationFailed [

	[
		[ editor changeTextWith: #block]
			should strictly satisfy: 
		[( text editContentsBy: #block andSubmitChangesBy: Any) will: [:arg1 :validationBlock | 
			validationBlock value].
		(textValidator validateText: text decoratedBy: textDecorator) willReturn: false]
			
 	] runWithMocks  
]

{ #category : #tests }
TwyEditorTests >> testCreationFromTextModel [
	| text |
	text := 'test text' asTwyText.
	editor := text newEditor.
	editor should beInstanceOf: TwyEditor.
	editor text should be: text.
	editor cursor isAtStart should be: true.
	editor selectedText isEmpty should be: true.
	editor selectedText end should be: editor cursor
]

{ #category : #tests }
TwyEditorTests >> testHasNativeTextDecoratorByDefault [
	TwyEditor new textDecorator should
		beInstanceOf: TwyNativeTextDecorator
]

{ #category : #tests }
TwyEditorTests >> testHasNullEditValidatorByDefault [
	TwyEditor new editValidator should beInstanceOf: TwyNullTextValidator
]

{ #category : #tests }
TwyEditorTests >> testResetSelection [

	[
		[ editor resetSelection]
			should strictly satisfy: 
		[ selectedText collapseAtEnd].
			
 	] runWithMocks 
]
