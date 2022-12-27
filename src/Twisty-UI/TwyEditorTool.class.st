"
I supply editing text features to text morph.
I subscribe for appropriate morph events and delegate editing actions to TwyEditor instance (see it comment). This operations are performed on selected text region which I fetch from  TwySelectionTool.
"
Class {
	#name : #TwyEditorTool,
	#superclass : #TwyTextTool,
	#instVars : [
		'editor'
	],
	#category : #'Twisty-UI'
}

{ #category : #controlling }
TwyEditorTool >> attachToMorph [

	editor textDecorator: textMorph textDecorator.
	
	textMorph on: #keyStroke send: #insertCharacterFromEvent: to: self.
	textMorph on: Character delete do: [ editor removeNextCharacter ].
	textMorph on: Character backspace do: [ editor removePreviousCharacter ].
	textMorph on: Character cr do: [ editor insertNewLine ].
	textMorph on: Character tab do: [ editor insertTab ].
	textMorph on: $x ctrl do: [ editor cutSelectionToClipboard ].
	textMorph on: $v ctrl do: [ editor insertCharactersFromClipboard ].
]

{ #category : #controlling }
TwyEditorTool >> attachToText [

	| selection |
	selection := textMorph ensureTool: TwySelectionTool. 
	editor
		text: textMorph text; 
		selectedText: selection selectedText
]

{ #category : #menu }
TwyEditorTool >> changeAlignment [

	| reply |
	reply := UIManager default 
				chooseFrom: #(leftToRignt centered rightToLeft) 
				values: #(leftToRight centered rightToLeft) .
	reply ifNotNil:[
		editor applyDefaultAttribute: TwyLineAlignmentAttribute with: (TwyTextAlignment perform: reply)
	].

]

{ #category : #menu }
TwyEditorTool >> changeEmphasis [

	| reply |
	reply := UIManager default 
				chooseFrom: (self emphasisChoices collect: [:t | t translated]) 
				values: self emphasisChoices.
	reply ifNotNil:[
		self defaultTextFont: (self defaultTextFont emphasized: (TextEmphasis perform: reply) emphasisCode)
	].

]

{ #category : #menu }
TwyEditorTool >> changeFont [
	| newFont chooser|
	"newFont := StrikeFont fromUser: self fontToUse."
	chooser := textMorph openModal: (
		Cursor wait showWhile: [FontChooser 
			windowTitle: 'Choose a Font' 
			for: self 
			setSelector: #defaultTextFont: 
			getSelector: #defaultTextFont]).
	newFont := chooser result.
	newFont ifNotNil:[self defaultTextFont: newFont].
]

{ #category : #menu }
TwyEditorTool >> changeFontColor [
	"Change the color of the receiver -- triggered, e.g. from a menu"

	UITheme current
		chooseColorIn: textMorph
		title: 'Choose font color' translated
		color: self defaultTextColor
		for: [:newColor |
			self defaultTextColor: newColor]
]

{ #category : #menu }
TwyEditorTool >> changeSelectedTextAlignment [

	| reply |
	reply := UIManager default 
				chooseFrom: #(leftToRignt centered rightToLeft) 
				values: #(leftToRight centered rightToLeft) .
	reply ifNotNil:[
		editor applyParagraphAttribute: TwyLineAlignmentAttribute with: (TwyTextAlignment perform: reply)
	].

]

{ #category : #menu }
TwyEditorTool >> changeSelectedTextEmphasis [

	| reply |
	reply := UIManager default 
				chooseFrom: (self emphasisChoices collect: [:t | t translated]) 
				values: self emphasisChoices.
	reply ifNotNil:[
		self selectedTextFont: (self font emphasized: (TextEmphasis perform: reply) emphasisCode)
	].

]

{ #category : #menu }
TwyEditorTool >> changeSelectedTextFont [
	| newFont chooser|
	"newFont := StrikeFont fromUser: self fontToUse."
	chooser := textMorph openModal: (
		Cursor wait showWhile: [FontChooser 
			windowTitle: 'Choose selected text font' 
			for: self
			setSelector: #selectedTextFont: 
			getSelector: self selectedTextFont]).
	newFont := chooser result.
	newFont ifNotNil:[self selectedTextFont: newFont].
]

{ #category : #menu }
TwyEditorTool >> changeSelectedTextFontColor [
	"Change the color of the receiver -- triggered, e.g. from a menu"

	UITheme current
		chooseColorIn: textMorph
		title: 'Choose selected text font color' translated
		color: self selectedTextColor
		for: [:newColor |
			self selectedTextColor: newColor]
]

{ #category : #accessing }
TwyEditorTool >> defaultTextColor [
	^self text getAttribute: TwyForeColorAttribute
]

{ #category : #accessing }
TwyEditorTool >> defaultTextColor: aColor [
	^editor applyDefaultAttribute: TwyForeColorAttribute with: aColor
]

{ #category : #accessing }
TwyEditorTool >> defaultTextFont [
	^self text getAttribute: TwyFontAttribute 
]

{ #category : #accessing }
TwyEditorTool >> defaultTextFont: aFont [
	^editor applyDefaultAttribute: TwyFontAttribute with: aFont
]

{ #category : #controlling }
TwyEditorTool >> detachFromText [ 

	editor 
		text: nil;
		selectedText: nil
]

{ #category : #menu }
TwyEditorTool >> emphasisChoices [
	"Returns the emphasis selectors that are sent to a TextEmphasis."
	
	^ #(normal bold italic narrow underlined struckOut)
]

{ #category : #initialize }
TwyEditorTool >> initialize [ 
	super initialize.
	
	editor := TwyEditor new.
]

{ #category : #controlling }
TwyEditorTool >> insertCharacterFromEvent: aKeyboardEvent [ 
	| char |
	char := aKeyboardEvent keyCharacter.

	(char isAlphaNumeric | (char = Character space) or: [ '+=-_!@#$%^&*()~`[]{}''|\/<>,.?"' includes: char])
		ifFalse: [ ^self ].
	
	editor insertCharacters: char asString 

]

{ #category : #testing }
TwyEditorTool >> isAttachedToText [
	
	^editor text notNil
]

{ #category : #controlling }
TwyEditorTool >> newTextContents: aString [
	editor newTextContents: aString

]

{ #category : #menu }
TwyEditorTool >> populateMenu: aMenu [
	super populateMenu: aMenu.
	
	aMenu add: 'change font color' translated target: self selector: #changeFontColor.
	aMenu add: 'change font' translated target: self selector: #changeFont.
	aMenu add: 'change emphasis' translated target: self selector: #changeEmphasis.
	aMenu add: 'change alignment' translated target: self selector: #changeAlignment.	
	
	aMenu addLine.
	aMenu add: 'change selected text font' translated target: self selector: #changeSelectedTextFont.
	aMenu add: 'change selected text font color' translated target: self selector: #changeSelectedTextFontColor.
	aMenu add: 'change selected text emphasis' translated target: self selector: #changeSelectedTextEmphasis.
	aMenu add: 'change selected text alignment' translated target: self selector: #changeSelectedTextAlignment.	
	

]

{ #category : #accessing }
TwyEditorTool >> selectedText [
	^editor selectedText
]

{ #category : #accessing }
TwyEditorTool >> selectedTextColor [
	^self selectedText getStartAttribute: TwyForeColorAttribute 
]

{ #category : #accessing }
TwyEditorTool >> selectedTextColor: aColor [ 
	editor applyAttribute: TwyForeColorAttribute with: aColor
]

{ #category : #accessing }
TwyEditorTool >> selectedTextFont [
	^self selectedText getStartAttribute: TwyFontAttribute 
]

{ #category : #accessing }
TwyEditorTool >> selectedTextFont: aFont [
	editor applyAttribute: TwyFontAttribute with: aFont
]

{ #category : #accessing }
TwyEditorTool >> textSpec: aTextSpec [
	
	self textValidator: (TwyTextValidator withSpec: aTextSpec)
]

{ #category : #accessing }
TwyEditorTool >> textValidator [
	
	^ editor textValidator
]

{ #category : #accessing }
TwyEditorTool >> textValidator: aTextValidator [
	
	editor textValidator: aTextValidator
]
