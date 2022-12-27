"
I provide standart operations for editing text. 

- #insertCharacters: aString 
- #removeNextCharacter
- #removePreviousCharacter
- #insertNewLine
- #applyAttibute:
- ... (see editing protocol)

I implement this operations inside editing block of text.
	text editContentsBy: aBlock 
So at the end text announces TwyTextChanged event.

I'm created on text and fetch text region as selected text for editing operations. You can ask me from text 
	text newEditor.
 You can modify selection by convenient helper objects (subclasses of TwyEditorDriver) who delegate messages to cursor (end of selected text) and reset or not selected region:
	editor selectTextBy moveForward 
- moves end of selected region at the next text item.
	editor withoutSelection moveForward 
- moves end of selected region at next text item and collapse selected region at the end.

I have text validator who responsible for text state verification after changes. Text validator can cancel changes if resulted text has wrong state. For example validator can check that text has only digits and forbid insertion of any other characters. By default I have TwyNullTextValidator who allow any text.

I delegate editing operations to text decorator who implements specifically its logic. Text decorator decide how characters should be inserted or removed, how selected text region should be changed. By default I have TwyNativeTextDecorator who insert characters with usual logic where characters are inserted at cursor position and selection region are reset. But there is TwyMaskedTextDecorator who doing it differently. It override asterix characters of mask with inserted string and skip non asterix characters. 

    Instance Variables
	text:		<TwyText>
	selectedText:		<TwyTextRegion>	
	textDecorator:		<TwyTextDecorator>
	textValidator:		<TwyTextValidator>

"
Class {
	#name : #TwyEditor,
	#superclass : #Object,
	#instVars : [
		'text',
		'selectedText',
		'textDecorator',
		'textValidator'
	],
	#category : #'Twisty-Editor'
}

{ #category : #'instance creation' }
TwyEditor class >> on: aTwyText [
	^self new 
		text: aTwyText;
		selectedText: aTwyText newRegion
]

{ #category : #editing }
TwyEditor >> applyAttribute: aTwyAttribute [

	self changeTextWith: [ 
		textDecorator applyAttribute: aTwyAttribute at: selectedText
	]
]

{ #category : #editing }
TwyEditor >> applyAttribute: aTwyAttributeClass with: attributeValue [ 

	self applyAttribute: (aTwyAttributeClass with: attributeValue)
]

{ #category : #editing }
TwyEditor >> applyDefaultAttribute: aTwyAttribute [

	self changeTextWith: [ 
		textDecorator applyDefaultAttribute: aTwyAttribute at: text
	]
]

{ #category : #editing }
TwyEditor >> applyDefaultAttribute: aTwyAttributeClass with: attributeValue [ 

	self applyDefaultAttribute: (aTwyAttributeClass with: attributeValue)
]

{ #category : #editing }
TwyEditor >> applyParagraphAttribute: aTwyAttribute [

	self changeTextWith: [ 
		textDecorator applyParagraphAttribute: aTwyAttribute at: selectedText
	]
]

{ #category : #editing }
TwyEditor >> applyParagraphAttribute: aTwyAttributeClass with: attributeValue [ 

	self applyParagraphAttribute: (aTwyAttributeClass with: attributeValue)
]

{ #category : #private }
TwyEditor >> changeTextWith: aBlock [
	
	text 
		editContentsBy: aBlock 
		andSubmitChangesBy: [ textValidator validateText: text decoratedBy: textDecorator]
]

{ #category : #editing }
TwyEditor >> copySelectionToClipboard [
	
	Clipboard clipboardText: selectedText asString
]

{ #category : #accessing }
TwyEditor >> cursor [
	^selectedText end
]

{ #category : #editing }
TwyEditor >> cutSelectionToClipboard [
	
	self copySelectionToClipboard.
	
	self changeTextWith: [ textDecorator cutSelection: selectedText ]
]

{ #category : #controlling }
TwyEditor >> detachText [
	selectedText detachText
]

{ #category : #accessing }
TwyEditor >> editDecorator [
	
	^ textDecorator
]

{ #category : #accessing }
TwyEditor >> editDecorator: anObject [
	
	textDecorator := anObject
]

{ #category : #accessing }
TwyEditor >> editValidator [
	^ textValidator
]

{ #category : #accessing }
TwyEditor >> editValidator: anObject [
	textValidator := anObject
]

{ #category : #'initialize-release' }
TwyEditor >> initialize [ 	
	super initialize.
	
	textDecorator := TwyNativeTextDecorator new.
	textValidator := TwyNullTextValidator new
]

{ #category : #editing }
TwyEditor >> insertCharacters: aString [

	self changeTextWith: [ 
		textDecorator insertCharacters: aString at: selectedText]
]

{ #category : #editing }
TwyEditor >> insertCharactersFromClipboard [
	
	self insertCharacters: Clipboard clipboardText asString
]

{ #category : #editing }
TwyEditor >> insertNewLine [ 

	self insertCharacters: String cr
]

{ #category : #editing }
TwyEditor >> insertTab [

	self insertCharacters: String tab
]

{ #category : #editing }
TwyEditor >> newTextContents: aString [

	self changeTextWith: [ 
		selectedText selectFullText.
		textDecorator insertCharacters: aString at: selectedText]
]

{ #category : #editing }
TwyEditor >> removeNextCharacter [

	self changeTextWith: [ 
		textDecorator removeNextCharacterAt: selectedText]
]

{ #category : #editing }
TwyEditor >> removePreviousCharacter [

	self changeTextWith: [ 
		textDecorator removePreviousCharacterAt: selectedText]
]

{ #category : #controlling }
TwyEditor >> resetSelection [
	selectedText collapseAtEnd.
	
]

{ #category : #movement }
TwyEditor >> selectTextBy [

	^TwyEditorSelectionDriver on: self
]

{ #category : #accessing }
TwyEditor >> selectedText [
	
	^ selectedText
]

{ #category : #accessing }
TwyEditor >> selectedText: anObject [
	
	selectedText := anObject
]

{ #category : #accessing }
TwyEditor >> text [
	
	^ text
]

{ #category : #accessing }
TwyEditor >> text: aTwyText [
	
	text := aTwyText
]

{ #category : #accessing }
TwyEditor >> textDecorator [
	
	^ textDecorator
]

{ #category : #accessing }
TwyEditor >> textDecorator: anObject [
	
	textDecorator := anObject
]

{ #category : #accessing }
TwyEditor >> textValidator [
	^ textValidator
]

{ #category : #accessing }
TwyEditor >> textValidator: anObject [
	textValidator := anObject
]

{ #category : #movement }
TwyEditor >> withoutSelection [

	^TwyEditorNoSelectionDriver on: self
]
