"
I am text morph based on active text. 
When I receive new text I build new layout by layoutStrategy.  There are two layout strategies: native and wrap layout. When text changed my layout automatically restored.

Any visual properties of text are belongs to text instance. There is no morph font color variables for example.
 
By default morph has no tools and text not editable and there are no ways to select text portions and there is no cursor.
You can add to me TwySelectionTool to provide way to visually select text regions and copy it to clipboard. There is shortcut message #anableSelection to add SelectionTool. 
There is TwyCursorTool which supplied blinked cursor morph. 
There is TwyEditorTool which provide editing capabilities to text morph. Shortcut message #beEditable adds TwyEditorTool , TwyCursorTool and TwyUndoRedoTool to morph.
TwyUndoRedoTool provides changes history mechanism with undo/redo operations. 
Tools can be extended. See TwyTextTool comment.
Tools approach allows replace usual hierarchy of text morphs by composition of tool classes.

See class side examples

Instance Variables
	tools:		<TwyTextTools>
	layoutStrategy:		<TwyLayoutStrategy>
	text:		<TwyText>
	textLayout:		<TwyLayout>
	textDecorator:		<TwyTextDecorator>
"
Class {
	#name : #TwyTextMorph,
	#superclass : #Morph,
	#instVars : [
		'layoutStrategy',
		'textLayout',
		'textDecorator',
		'tools',
		'text'
	],
	#category : #'Twisty-UI'
}

{ #category : #examples }
TwyTextMorph class >> exampleAutoScrollingWithScrollPane [
"
self exampleAutoScrollingWithScrollPane
"
	| textMorph ownerMorph  scrollpane tool |
	
	textMorph := self new.
	textMorph layoutStrategy: TwyNativeLayoutStrategy new.
	textMorph text: self textContentsForExample asTwyText.
	textMorph beEditable.
	tool := textMorph ensureTool: TwyAutoScrollingTool.
	
	scrollpane := GeneralScrollPane new.
	scrollpane extent: 200 @ (textMorph extent y * 0.5).	
	scrollpane scrollTarget: textMorph.

	ownerMorph := Morph new.
	ownerMorph extent: scrollpane extent.
	ownerMorph color: Color white; borderWidth: 1; borderColor: Color black; layoutInset: 2@2.
	ownerMorph clipSubmorphs: true.
	ownerMorph addMorph: scrollpane.
	ownerMorph openInHand.
	^ownerMorph
]

{ #category : #examples }
TwyTextMorph class >> exampleAutoScrollingWithoutScrollPane [
"
self exampleAutoScrollingWithoutScrollPane
"
	| textMorph ownerMorph tool |
	
	textMorph := self new.
	textMorph layoutStrategy: TwyNativeLayoutStrategy new.
	textMorph text: self textContentsForExample asTwyText.
	textMorph beEditable.
	tool := textMorph ensureTool: TwyAutoScrollingTool.
	
	ownerMorph := Morph new.
	ownerMorph extent: textMorph width + 30 @ (tool cursor height + 1).
	ownerMorph color: Color white; borderWidth: 1; borderColor: Color black; layoutInset: 2@2.
	ownerMorph clipSubmorphs: true.
	ownerMorph addMorph: textMorph.
	ownerMorph openInHand
]

{ #category : #examples }
TwyTextMorph class >> exampleCenteredText [
"
self exampleCenteredText
"
	| m |

	m := self new.
	m beEditable.
	m textAlignment: TwyTextAlignment centered.
	m newTextContents: self textContentsForExample.	
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> exampleMask [
"
self exampleMask
"
	| m |
	
	m := self new.
	m layoutStrategy: TwyNativeLayoutStrategy new.
	m textDecorator: (TwyMaskedTextDecorator withMaskFromString: '8(***)***-**-**').
	m beEditable.
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> exampleMaskWithOnlyNumbers [
"
self exampleMaskWithOnlyNumbers
"
	| m |
	
	m := self new.
	m layoutStrategy: TwyNativeLayoutStrategy new.
	m textDecorator: (TwyMaskedTextDecorator withMaskFromString: '8(***)***-**-**').
	m beEditable.
	m textSpec: TwyDigitalTextSpec new.
	m newTextContents: '91222343'.
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> exampleNativeLayout [
"
self exampleNativeLayout
"
	| m |
	
	m := self new.
	m layoutStrategy: TwyNativeLayoutStrategy new.
	m text: self textContentsForExample asTwyText.
	m beEditable.	
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> exampleOverwriteEditingMode [
"
self exampleOverwriteEditingMode
"
	| m |
	
	m := self new.
	m layoutStrategy: TwyNativeLayoutStrategy new.
	m textDecorator: (TwyOverwriteModeDecorator new).
	m text: self textContentsForExample asTwyText.
	m beEditable.
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> examplePassword [
"
self examplePassword
"
	| m |
	
	m := self new.
	m text: 'secret password' asTwySecretText.
	m beEditable.
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> examplePlaceHolder [
"
self examplePlaceHolder.
You can edit place holder text from halo menu. It is opens another TwyTextMorph on place holder text. So you can change any attributes.
"
	| m |
	
	m := self new.
	m layoutStrategy: TwyWrapTextStrategy new.
	m extent: 50 @ 200.
	m text: '' asTwyText.
	m beEditable.
	m addTool: (TwyPlaceHolderTool with: 'input text' asTwyText).
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> exampleSecretMaskForCardNumber [
"
self exampleSecretMaskForCardNumber
"
	| m |
	
	m := self new.
	m layoutStrategy: TwyNativeLayoutStrategy new.
	m textDecorator: (TwyMaskedTextDecorator withMaskFromString: '____-____-____-____' whereAsterixIs: $_ whichHideCharactersBy: 'xxxx**********xx' withAsterix: $*).
	m beEditable.
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> exampleSmartCharacters [
"
self exampleSmartCharacters 
"
	| m |
	
	m := self new.
	m layoutStrategy: TwyNativeLayoutStrategy new.
	m textDecorator: TwySmartCharsDecorator default.
	m beEditable.
	m newTextContents: self textContentsForExample.	
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> exampleSmartNumbers [
"
self exampleSmartNumbers
"
	| m |
	
	m := self new.
	m textDecorator: TwySingleLineDecorator smartNumbers.	
	m beEditable.
	m textSpec: (TwyDecimalTextSpec maxDecimalDigits: 3).
	m newTextContents: '10000000'.
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> exampleTextWithTab [
"
self exampleTextWithTab
"
	| m |
	
	m := self new.
	m layoutStrategy: TwyNativeLayoutStrategy new.
	m text: ('123', String tab, '4567') asTwyText.
	m beEditable.
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> exampleWrapTextLayout [
"
self exampleWrapTextLayout
"
	| m |

	m := self new.
	m layoutStrategy: TwyWrapTextStrategy new.
	m extent: 50 @ 200.
	m text: self textContentsForExample asTwyText.
	m beEditable.
	m openInHand
]

{ #category : #examples }
TwyTextMorph class >> textContentsForExample [

	^'hello world
second line

WWWWWW
1234567890
test


third line
forth line'
]

{ #category : #menu }
TwyTextMorph >> addFillStyleMenuItems: aMenu hand: aHand [
	"Add the items for changing the current fill style of the Morph"
	aMenu addToggle: 'wrap text' target: self selector: #toggleWrapMode getStateSelector: #isWrapModeActive.
		
	tools populateMenu: aMenu.
	
	super addFillStyleMenuItems: aMenu hand: aHand
]

{ #category : #controlling }
TwyTextMorph >> addTool: aTextTool [
	
	(self hasTool: aTextTool class) ifTrue: [ self error: 'Only specific tool allowed!' ].
		
	tools add: aTextTool for: self
]

{ #category : #private }
TwyTextMorph >> adjustTextAnchor: t1 [
]

{ #category : #controlling }
TwyTextMorph >> beEditable [

	self ensureTool: TwyEditorTool; ensureTool: TwyCursorTool; ensureTool: TwyUndoRedoTool 
]

{ #category : #private }
TwyTextMorph >> buildLayoutForNewText [
	
	| newLayout |
	newLayout := layoutStrategy layoutText: text.
	
	self textLayout: newLayout
]

{ #category : #testing }
TwyTextMorph >> canHaveFillStyles [
	^true
]

{ #category : #menu }
TwyTextMorph >> changeColor [
	"Change the color of the receiver -- triggered, e.g. from a menu"

	UITheme current
		chooseColorIn: self
		title: 'Choose background color' translated
		color: self color
		for: [:newColor |
			self color: newColor]
]

{ #category : #menu }
TwyTextMorph >> chooseEmphasisOrAlignment [ 

	| tool |
	tool := self ensureTool: TwyEditorTool.
	tool changeAlignment 
]

{ #category : #menu }
TwyTextMorph >> chooseFont [

	| tool |
	tool := self ensureTool: TwyEditorTool.
	tool changeFont
]

{ #category : #menu }
TwyTextMorph >> chooseStyle [

	| tool |
	tool := self ensureTool: TwyEditorTool.
	tool changeEmphasis 
]

{ #category : #accessing }
TwyTextMorph >> defaultColor [
	^ Color transparent
]

{ #category : #private }
TwyTextMorph >> detachText [
	
	textLayout detachText.
	textLayout unsubscribe: self.
	
	tools detachFromText
	
]

{ #category : #accessing }
TwyTextMorph >> displayedContents [
	^text asString
]

{ #category : #drawing }
TwyTextMorph >> drawDropShadowOn: aCanvas [

	"| bnd gap |
	bnd := self bounds translateBy: self shadowOffset.

	aCanvas drawString: contents in: self bounds font: font color: self shadowColor."
]

{ #category : #drawing }
TwyTextMorph >> drawOn: aCanvas [

	tools backgroundDecorators do: [ :each | each drawTextBackgroundOn: aCanvas ].
	
	textLayout drawTextOn: aCanvas at: self position 
]

{ #category : #controlling }
TwyTextMorph >> enableSelection [

	self ensureTool: TwySelectionTool
]

{ #category : #controlling }
TwyTextMorph >> ensureTool: aTextToolClass [
	
	| newTool |
	^tools get: aTextToolClass ifNone: [ 
		newTool := aTextToolClass new.
		tools add: newTool for: self.
		newTool]
]

{ #category : #accessing }
TwyTextMorph >> extent: aPoint [ 
	layoutStrategy allowArbitraryExtent
		ifFalse: [^self].
	layoutStrategy preferredExtent: aPoint.
	self fixLayout
]

{ #category : #private }
TwyTextMorph >> fitTextExtent [
	super extent: textLayout extent
	
]

{ #category : #private }
TwyTextMorph >> fixLayout [
	
	textLayout rebuildForNewExtent.

	self fitTextExtent
]

{ #category : #'focus management' }
TwyTextMorph >> hasFocus [
	^self hasKeyboardFocus and: [ self hasTool: TwySelectionTool  ]
]

{ #category : #testing }
TwyTextMorph >> hasTool: aToolClass [
	^tools includes: aToolClass
]

{ #category : #testing }
TwyTextMorph >> hasTranslucentColor [

	^true
]

{ #category : #'initialize-release' }
TwyTextMorph >> initialize [
	super initialize.

	tools := TwyTextTools new.
	layoutStrategy := TwyNativeLayoutStrategy new.
	self textDecorator: TwyNativeTextDecorator new.

]

{ #category : #testing }
TwyTextMorph >> isEditable [
	^self hasTool: TwyEditorTool
]

{ #category : #testing }
TwyTextMorph >> isTextMorph [ 
	^true
]

{ #category : #testing }
TwyTextMorph >> isWrapModeActive [
	^layoutStrategy isKindOf: TwyWrapTextStrategy 
]

{ #category : #'focus management' }
TwyTextMorph >> keyboardFocusChange: gotFocus [
	super keyboardFocusChange: gotFocus.
	
	tools focusChanged: gotFocus
]

{ #category : #accessing }
TwyTextMorph >> layoutStrategy [
	^layoutStrategy
]

{ #category : #accessing }
TwyTextMorph >> layoutStrategy: aLayoutStrategy [
	layoutStrategy := aLayoutStrategy.
	layoutStrategy preferredExtent: self extent.
	textLayout strategy: layoutStrategy.
	self fixLayout
]

{ #category : #menu }
TwyTextMorph >> minHeight [
	^(text getAttribute: TwyFontAttribute) height
]

{ #category : #accessing }
TwyTextMorph >> nativeContents [
	^textDecorator extractNativeStringFrom: text asString
]

{ #category : #accessing }
TwyTextMorph >> newTextContents: aString [
"
I need way to set up initial text contents. If I have editor tool I use it for this. If not I just dublicate little logic from editor. I implement this method such way to not change my tools during initial setup.
"
	(self hasTool: TwyEditorTool) ifTrue: [ 
		(self ensureTool: TwyEditorTool) newTextContents: aString.
		^self
	 ].

	text editContentsBy: [:region |
		region selectFullText.
		textDecorator insertCharacters: aString at: region
	]
]

{ #category : #'focus management' }
TwyTextMorph >> takesKeyboardFocus [
	^true
]

{ #category : #accessing }
TwyTextMorph >> text [
	^ text
]

{ #category : #accessing }
TwyTextMorph >> text: aTwiText [
	text ifNotNil: [ self detachText ].
	text := aTwiText.
	self buildLayoutForNewText.
	tools attachToNewText
]

{ #category : #accessing }
TwyTextMorph >> textDecorator [
	
	^ textDecorator
]

{ #category : #accessing }
TwyTextMorph >> textDecorator: aTextDecorator [
	
	| defaultText |
	textDecorator := aTextDecorator.
	defaultText := textDecorator defaultText.
	self text: defaultText.
]

{ #category : #accessing }
TwyTextMorph >> textLayout [
	
	^ textLayout
]

{ #category : #accessing }
TwyTextMorph >> textLayout: aTwyLayout [
	
	textLayout ifNotNil: [textLayout unsubscribe: self].
	
	textLayout := aTwyLayout.	
	self fitTextExtent.	
	textLayout when: TwyLayoutChanged send: #textLayoutChanged to: self
]

{ #category : #private }
TwyTextMorph >> textLayoutChanged [
	textLayout validate.
	self fitTextExtent.
	self changed.
	
]

{ #category : #accessing }
TwyTextMorph >> textSpec: aTextSpec [
	
	| editorTool |
	editorTool := tools get: TwyEditorTool.
	editorTool textSpec: aTextSpec
]

{ #category : #accessing }
TwyTextMorph >> toggleWrapMode [

	self isWrapModeActive 
		ifTrue: [ self  layoutStrategy: TwyNativeLayoutStrategy new]
		ifFalse: [ self  layoutStrategy: TwyWrapTextStrategy new]
]

{ #category : #accessing }
TwyTextMorph >> tools [
	
	^ tools
]

{ #category : #accessing }
TwyTextMorph >> tools: anObject [
	
	tools := anObject
]
