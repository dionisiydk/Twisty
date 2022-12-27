"
I supply selection text features to text morph.
I add usual shortcuts to select portion of text and copy it to clipboard.
"
Class {
	#name : #TwySelectionTool,
	#superclass : #TwyTextTool,
	#instVars : [
		'selectionRegion',
		'selectionModeModifier',
		'selectionColor',
		'focusedSelectionColor',
		'unfocusedSelectionColor'
	],
	#category : #'Twisty-UI'
}

{ #category : #controlling }
TwySelectionTool >> attachToMorph [

	textMorph on: $c ctrl do: [ self copySelectionToClipboard ].
	textMorph on: #mouseDown send: #moveCursorByMouse: to: self.
"	textMorph on: #mouseUp send: #selectionModeOff to: self."
	textMorph on: #mouseMove send: #extendSelectionByMouse: to: self.
	self moveCursorOn: Character arrowLeft by: #moveLeft.
	self moveCursorOn: Character arrowRight by: #moveRight.
	self moveCursorOn: Character arrowUp by: #moveUp .
	self moveCursorOn: Character arrowDown by: #moveDown.
	self moveCursorOn: Character end by: #moveToLineEnd.
	self moveCursorOn: Character home by: #moveToLineStart.
	self moveCursorOn: Character end ctrl by: #moveToTextEnd.
	self moveCursorOn: Character home ctrl by: #moveToTextStart.
]

{ #category : #controlling }
TwySelectionTool >> attachToText [
	
	selectionRegion := self textLayout newRegion.
	selectionRegion when: TwyLayoutChanged send: #changed to: textMorph
]

{ #category : #menu }
TwySelectionTool >> changeFocusedSelectionColor [
	"Change the color of the receiver -- triggered, e.g. from a menu"

	UITheme current
		chooseColorIn: textMorph
		title: 'Choose focused selection color' translated
		color: self focusedSelectionColor 
		for: [:newColor |
			self focusedSelectionColor: newColor]
]

{ #category : #menu }
TwySelectionTool >> changeUnfocusedSelectionColor [
	"Change the color of the receiver -- triggered, e.g. from a menu"

	UITheme current
		chooseColorIn: textMorph
		title: 'Choose unfocused selection color' translated
		color: self unfocusedSelectionColor 
		for: [:newColor |
			self unfocusedSelectionColor: newColor]
]

{ #category : #operations }
TwySelectionTool >> copySelectionToClipboard [
	
	Clipboard clipboardText: self selectedText asString
]

{ #category : #accessing }
TwySelectionTool >> cursor [
	
	^ selectionRegion end
]

{ #category : #controlling }
TwySelectionTool >> detachFromText [
	
	selectionRegion unsubscribe: textMorph.
	selectionRegion detachText.
	selectionRegion := nil.
]

{ #category : #drawing }
TwySelectionTool >> drawTextBackgroundOn: aCanvas [

	selectionRegion drawHighlightsOn: aCanvas at: textMorph position withColor: self selectionColor
]

{ #category : #controlling }
TwySelectionTool >> extendSelectionByMouse: evt [
	| localPoint |
	localPoint := evt cursorPoint - textMorph position.
	self moveCursorTo: localPoint withSelection: true
]

{ #category : #'focus management' }
TwySelectionTool >> focusChanged: gotFocus [
	
	selectionColor := gotFocus ifTrue: [ self focusedSelectionColor ] ifFalse: [ self unfocusedSelectionColor ].
	textMorph changed
]

{ #category : #accessing }
TwySelectionTool >> focusedSelectionColor [

	^focusedSelectionColor ifNil: [ textMorph theme selectionColor]
]

{ #category : #accessing }
TwySelectionTool >> focusedSelectionColor: aColor [
	
	focusedSelectionColor := aColor.
	self selectionColor: aColor
]

{ #category : #testing }
TwySelectionTool >> hasSelection [
	^selectionRegion isEmpty not
]

{ #category : #'initialize-release' }
TwySelectionTool >> initialize [
	super initialize.

	selectionModeModifier := KMModifier shift
]

{ #category : #testing }
TwySelectionTool >> isAttachedToText [
	
	^selectionRegion notNil

]

{ #category : #testing }
TwySelectionTool >> isDecoratedBackground [

	^selectionRegion isEmpty not
]

{ #category : #controlling }
TwySelectionTool >> moveCursorBy: aSelector withSelection: needsSelection [

	self cursor perform: aSelector.
	needsSelection ifFalse: [ self resetSelection]
]

{ #category : #controlling }
TwySelectionTool >> moveCursorByMouse: evt [
	| localPoint |
	localPoint := evt cursorPoint - textMorph position.
	
	self moveCursorTo: localPoint withSelection: Sensor shiftPressed.
"	self selectionModeOn."
	textMorph takeKeyboardFocus
]

{ #category : #controlling }
TwySelectionTool >> moveCursorOn: aShortcut by: aSelector [

	textMorph on: aShortcut asShortcut do: [
		self moveCursorBy: aSelector withSelection: false ].
	textMorph on: (selectionModeModifier + (aShortcut asShortcut deepCopy)) do: [
		self moveCursorBy: aSelector withSelection: true].
]

{ #category : #controlling }
TwySelectionTool >> moveCursorTo: localPoint withSelection: needsSelection [

	self cursor layoutPosition: localPoint.
	needsSelection ifFalse: [ self resetSelection]
]

{ #category : #menu }
TwySelectionTool >> populateMenu: aMenu [
	super populateMenu: aMenu.

	aMenu add: 'change focused selection highlight color' translated target: self selector: #changeFocusedSelectionColor.	
	aMenu add: 'change unfocused selection highlight color' translated target: self selector: #changeUnfocusedSelectionColor.
		aMenu add: 'spawn selection' translated target: self selector: #spawnSelection
]

{ #category : #controlling }
TwySelectionTool >> resetSelection [
	self selectedText collapseAtEnd
]

{ #category : #accessing }
TwySelectionTool >> selectedText [
	
	^ selectionRegion textRegion
]

{ #category : #accessing }
TwySelectionTool >> selectionColor [
	
	^ selectionColor ifNil: [ self unfocusedSelectionColor]
]

{ #category : #accessing }
TwySelectionTool >> selectionColor: aColor [
	
	selectionColor := aColor.
	textMorph changed
]

{ #category : #accessing }
TwySelectionTool >> selectionModeModifier [
	
	^ selectionModeModifier
]

{ #category : #accessing }
TwySelectionTool >> selectionModeModifier: anObject [
	
	selectionModeModifier := anObject
]

{ #category : #accessing }
TwySelectionTool >> selectionRegion [
	
	^ selectionRegion
]

{ #category : #menu }
TwySelectionTool >> spawnSelection [

	| selectionMorph |
	selectionMorph := TwyTextMorph new.
	selectionMorph layoutStrategy: TwyNativeLayoutStrategy new.
	selectionMorph text: self selectedText copy asTextPart.
	selectionMorph beEditable.
	selectionMorph openInHand
]

{ #category : #accessing }
TwySelectionTool >> unfocusedSelectionColor [

	^unfocusedSelectionColor ifNil: [ textMorph theme secondarySelectionColor]
]

{ #category : #accessing }
TwySelectionTool >> unfocusedSelectionColor: aColor [
	
	unfocusedSelectionColor := aColor.
	self selectionColor: aColor
]
