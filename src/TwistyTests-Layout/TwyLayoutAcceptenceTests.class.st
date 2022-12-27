Class {
	#name : #TwyLayoutAcceptenceTests,
	#superclass : #TestCase,
	#instVars : [
		'font',
		'layout',
		'layoutCursor',
		'editor',
		'textChanges',
		'layoutStrategy',
		'text'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #helpers }
TwyLayoutAcceptenceTests >> layoutText: aString [
	text := aString asTwyText.
	text defaultAttributes add: TwyFontAttribute with: font.
	editor := text newEditor.
	
	layout := layoutStrategy layoutText: text.
	layout validate.
	layoutCursor := layout newCursor. 
	layoutCursor attachTo: editor cursor.
	
	textChanges := OrderedCollection new.
	text when: TwyTextStateChanged do: [ :ann | textChanges add: ann ].
	layout when: TwyLayoutChanged do: [ :ann | layout validate ]

]

{ #category : #helpers }
TwyLayoutAcceptenceTests >> layoutTextRegion: aTextRegion [
	
	aTextRegion text defaultAttributes add: TwyFontAttribute with: font.
	
	layout := layoutStrategy layoutText: aTextRegion.
	layout validate.
	layoutCursor := layout newCursor. 
	editor ifNotNil: [ layoutCursor attachTo: editor cursor].
	
	layout when: TwyLayoutChanged do: [ :ann | layout validate ]

]

{ #category : #running }
TwyLayoutAcceptenceTests >> setUp [
	super setUp.
	
	font := Mock new.
	(font stub widthOf: Any) willReturn: 1.
	(font stub height) willReturn: 10.

	layoutStrategy := TwyNativeLayoutStrategy new.
		

]

{ #category : #'tests-cancelling changes' }
TwyLayoutAcceptenceTests >> testCancellingMiddleCharInsertionInsideSingleLineWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345'.
	
	text 
		editContentsBy: [:region | 
			region end moveForward: 2. region collapseAtEnd.
			region replaceWith: '7']
		 andSubmitChangesBy: [ false ].
	
	layout extent should equal: 5 @ 10
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testChangingAttributeAtTheEndOfFirstWrappedLine [

	|   newAttr |
	self wrapOnByWidth: 3.
	
	self layoutText: '1234'.
	layout extent should equal: 3 @ 20.
	
	newAttr := TwyForeColorAttribute with: Color red.
	
	text editContentsBy: [:region | 
		region start linePosition: 1.
		region end linePosition: 3. 		
		region applyAttribute: newAttr].
			
	layout extent should equal: 3 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testChangingAttributeWhenMultilineTextWithNativeLayout [

	|   newAttr |
	self wrapOff.
	
	self layoutText: '1234', String cr, '567'.
	layout extent should equal: 4 @ 20.
	
	newAttr := TwyForeColorAttribute with: Color red.
	
	text editContentsBy: [:region | 
		region start linePosition: 1.
		region end linePosition: 3. 		
		region applyAttribute: newAttr].
			
	layout extent should equal: 4 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testChangingAttributeWhenMultilineTextWithWrapLayout [

	|   newAttr |
	self wrapOnByWidth: 3.
	
	self layoutText: '1234', String cr, '56'.
	layout extent should equal: 3 @ 30.
	
	newAttr := TwyForeColorAttribute with: Color red.
	
	text editContentsBy: [:region | 
		region start linePosition: 1.
		region end linePosition: 2. 		
		region applyAttribute: newAttr].
			
	layout extent should equal: 3 @ 30
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testChangingDefaultFontWhenNativeLayout [

	| newFont newFontAttr |
	self wrapOff.
	
	self layoutText: '1234'.
	layout extent should equal: 4 @ 10.
	
	newFont := Mock new.
	(newFont stub widthOf: $2) willReturn: 3.
	(newFont stub widthOf: $3) willReturn: 2.
	(newFont stub widthOf: $1) willReturn: 2.
	(newFont stub widthOf: $4) willReturn: 1.
	(newFont stub height) willReturn: 14.

	newFontAttr := TwyFontAttribute with: newFont.
	
	text editContentsBy: [:region | 
		text applyDefaultAttribute: newFontAttr.
	].
			
	layout extent should equal: 8 @ 14
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testChangingDefaultFontWhenWrapLayout [

	| newFont newFontAttr |
	self wrapOnByWidth: 4.
	
	self layoutText: '1234'.
	layout extent should equal: 4 @ 10.
	
	newFont := Mock new.
	(newFont stub widthOf: $2) willReturn: 3.
	(newFont stub widthOf: $3) willReturn: 2.
	(newFont stub widthOf: $1) willReturn: 2.
	(newFont stub widthOf: $4) willReturn: 2.
	(newFont stub height) willReturn: 14.

	newFontAttr := TwyFontAttribute with: newFont.
	
	text editContentsBy: [:region | 
		text applyDefaultAttribute: newFontAttr
	].
			
	layout extent should equal: 4 @ 42
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testChangingFirstLineAlignmentWhenNativeLayout [

	|   newAttr |
	self wrapOff.
	
	self layoutText: '12', String cr, '3456'.
	
	newAttr := TwyLineAlignmentAttribute with: TwyTextAlignment rightToLeft.
	
	text editContentsBy: [:region | 
		region start moveToTextStart.
		region end moveToTextStart. 		
		region applyParagraphAttribute: newAttr].
			
	layout extent should equal: 4 @ 20.
	layout topLine topLeftPosition should equal: 2@0
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testChangingFontWhenNativeLayout [

	| newFont newFontAttr |
	self wrapOff.
	
	self layoutText: '1234'.
	layout extent should equal: 4 @ 10.
	
	newFont := Mock new.
	(newFont stub widthOf: $2) willReturn: 3.
	(newFont stub widthOf: $3) willReturn: 2.
	(newFont stub height) willReturn: 14.

	newFontAttr := TwyFontAttribute with: newFont.
	
	text editContentsBy: [:region | 
		region end linePosition: 3. 
		region start linePosition: 1.
		region applyAttribute: newFontAttr].
			
	layout extent should equal: 7 @ 14
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testChangingFontWhenWrapLayout [

	| newFont newFontAttr |
	self wrapOnByWidth: 4.
	
	self layoutText: '1234'.
	layout extent should equal: 4 @ 10.
	
	newFont := Mock new.
	(newFont stub widthOf: $2) willReturn: 3.
	(newFont stub widthOf: $3) willReturn: 2.
	(newFont stub height) willReturn: 14.

	newFontAttr := TwyFontAttribute with: newFont.
	
	text editContentsBy: [:region | 
		region end linePosition: 3. 
		region start linePosition: 1.
		region applyAttribute: newFontAttr].
			
	layout extent should equal: 4 @ 28
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testChangingLastLineAlignmentWhenNativeLayout [

	|   newAttr |
	self wrapOff.
	
	self layoutText: '1234', String cr, '56'.
	
	newAttr := TwyLineAlignmentAttribute with: TwyTextAlignment rightToLeft.
	
	text editContentsBy: [:region | 
		region start moveToTextEnd.
		region end moveToTextEnd. 		
		region applyParagraphAttribute: newAttr].
			
	layout extent should equal: 4 @ 20.
	layout bottomLine topLeftPosition should equal: 2@10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testChangingThirdLineAlignmentWhenNativeLayout [

	|   newAttr |
	self wrapOff.
	
	self layoutText: '12', String cr, '34', String cr, '56', String cr, '1234'.
	
	newAttr := TwyLineAlignmentAttribute with: TwyTextAlignment rightToLeft.
	
	text editContentsBy: [:region | 
		region start lineNumber: 3.
		region end lineNumber: 3. 		
		region applyParagraphAttribute: newAttr].
			
	layout extent should equal: 4 @ 40.
	layout topLine topLeftPosition x should equal: 0.
	layout topLine belowLine topLeftPosition x should equal: 0.
	layout topLine belowLine belowLine topLeftPosition x should equal: 2
]

{ #category : #'tests-region-building layout' }
TwyLayoutAcceptenceTests >> testCharInsertionAtMiddleOfSingleLineRegionWithNativeLayout [
	| region |
	self wrapOff.
	
	text := '123456' asTwyText.
	region := text newRegion.
	region selectFullText.
	region start linePosition: 2.
	region end linePosition: 5.
	
	self layoutTextRegion: region.
	editor := text newEditor.
	editor withoutSelection moveForward: 3.
	editor insertCharacters: '7'.
	
	layout extent should equal: 4 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCharInsertionAtStartOfLineAndTab [

	self wrapOff.
	
	self layoutText: '	1'.
	
	editor insertCharacters: '3'.
	
	layout extent should equal: 12 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCharInsertionAtStartOfSecondLineWhenTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '678'.
	
	editor withoutSelection moveToTextEnd; moveToLineStart.
	editor insertCharacters: 'a'.
	
	layout extent should equal: 5 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCharInsertionAtTheEndOfMultilineTextWithBigestLastLineAndNativeLayout [

	self wrapOff.
	
	self layoutText: '123', String cr, '45678'.
	
	editor withoutSelection moveToTextEnd.
	
	editor insertCharacters: '9'.
	
	layout extent should equal: 6 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCharInsertionAtTheEndOfMultilineTextWithSmallLastLineAndNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '678'.
	
	editor withoutSelection moveToTextEnd.
	
	editor insertCharacters: '9'.
	
	layout extent should equal: 5 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCharInsertionAtTheEndOfSingleLineTextWhenItShouldBeWrapped [

	self wrapOnByWidth: 3.
	
	self layoutText: '123'.
	
	editor withoutSelection moveToTextEnd.

	editor insertCharacters: '4'.
		
	layout extent should equal: 3 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCharInsertionTwiceAtTheEndOfSingleLineTextWhenItShouldBeWrapped [

	self wrapOnByWidth: 3.
	
	self layoutText: '123'.
	
	editor withoutSelection moveToTextEnd.
	
	editor insertCharacters: '4'.
	
	layout extent should equal: 3 @ 20.
		
	editor insertCharacters: '5'.
	
	layout extent should equal: 3 @ 20.
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCharacterInsertionAtEmptyLineWhenNativeLayout [

	self wrapOff.
	
	self layoutText: ''.
	
	editor withoutSelection moveToTextEnd.
	
	editor insertCharacters: '1'.
	
	layout extent should equal: 1 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCharacterInsertionAtTheEndOfTextWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '12345'.
	
	editor withoutSelection moveToTextEnd.
	editor insertCharacters: '6'.
	
	layout extent should equal: 6 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionAfterFirstCharThenBackspaceThenBackspaceAtTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '123'.
	
	editor withoutSelection moveToTextStart; moveForward: 1.
	
	editor insertCharacters: String cr.
	editor removePreviousCharacter.
	
	editor removePreviousCharacter.
	
	layout extent should equal: 2 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionAfterFirstCharThenBackspaceThenBackspaceAtTextWithWrapLayout [

	self wrapOnByWidth: 4.
	
	self layoutText: '123'.
	
	editor withoutSelection moveToTextStart; moveForward: 1.
	
	editor insertCharacters: String cr.
	editor removePreviousCharacter; removePreviousCharacter.
	
	layout extent should equal: 2 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionAtEmptyMiddleLineWhenTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '123', String cr, String cr, '567'.
	
	editor withoutSelection moveToLineEnd; moveForward.

	editor insertCharacters: String cr.
	
	layout extent should equal: 3 @ 40
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionAtEmptyText [

	self wrapOff.
	
	self layoutText: ''.
	
	editor insertCharacters: String cr.
	
	layout extent should equal: 0 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionAtFirstLineInEmptyLinesGroupInsideTextMiddleWhenTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '123', String cr, String cr, String cr, '567'.
	
	editor withoutSelection moveToLineEnd; moveForward.
	
	editor insertCharacters: String cr.
	
	layout extent should equal: 3 @ 50
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionAtSecondLineThenBackspaceUpToLineStartWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '123', String cr, '567', String cr, '890'.
	
	editor withoutSelection moveToLineEnd; moveForward: 2.
	
	editor insertCharacters: String cr.
	editor removePreviousCharacter.
	
	editor removePreviousCharacter.
	
	layout extent should equal: 3 @ 30
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionAtStartOfSecondLineWhenTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '678'.
	
	editor withoutSelection moveToTextEnd; moveToLineStart.
	
	editor insertCharacters: String cr.
	
	layout extent should equal: 5 @ 30
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionAtTheEndOfMultilineTextWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '123', String cr, '45'.
	
	editor withoutSelection moveToTextEnd.
	editor insertCharacters: String cr, '678'.
	
	layout extent should equal: 3 @ 30
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionAtTheEndOfTextWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '12345'.
	
	editor withoutSelection moveToTextEnd.
	editor insertCharacters: String cr.
	
	layout extent should equal: 5 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionAtTheStartOfTab [

	self wrapOff.
	
	self layoutText: '1	2'.
	
	editor withoutSelection linePosition: 1; moveForward; moveBackward.
	
	editor withoutSelection isAtSpanStart should be: true.
	
	editor insertCharacters: String cr.

	editor insertCharacters: '3'.
	
	layout extent should equal: 12 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionInTwoLinesTextThenBackspaceThenCharInsertionWhileNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '678'.
	
	editor withoutSelection textPosition: 2.
	
	editor insertCharacters: String cr.
	editor removePreviousCharacter.
	
	editor insertCharacters: '0'.
	
	layout extent should equal: 6 @ 20.
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testCrInsertionTwiceAtMiddleOfSecondLineWhenTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '678'.
	
	editor withoutSelection moveToTextEnd; moveToLineStart; moveForward.
	editor insertCharacters: String cr.
	
	layout extent should equal: 5 @ 30.
	
	
	editor insertCharacters: String cr.
		
	layout extent should equal: 5 @ 40
]

{ #category : #'tests-navigation' }
TwyLayoutAcceptenceTests >> testCreationNewCursor [
	
	self wrapOff.
	
	self layoutText: '123456'.
	
	layoutCursor := layout newCursor.
	layoutCursor textPosition should equal: 0.
	layoutCursor layoutPosition should equal: 0@0
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testFirstCharDeletionInsideSingleLineTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345'.
	
	editor removeNextCharacter.
	
	layout extent should equal: 4 @ 10
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testFirstCharInsertionInsideSingleLineTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345'.
	
	editor insertCharacters: '6'.
	
	layout extent should equal: 6 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testFirstCharInsertionInsideSingleLineTextWithWrapLayout [

	self wrapOn.
	
	self layoutText: '12345'.
	
	editor insertCharacters: '6'.
	
	layout extent should equal: 6 @ 10
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleCRInsertionInsideSingleLineTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345'.
	
	editor withoutSelection moveForward: 2.
	
	editor insertCharacters: String cr.
	
	layout extent should equal: 3 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleCRInsertionInsideSingleLineTextWithWrapLayout [

	self wrapOn.
	
	self layoutText: '12345'.
	
	editor withoutSelection moveForward: 2.
	editor insertCharacters: String cr.
	
	layout extent should equal: 3 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleCRInsertionInsideSingleLineTextWithWrapLayoutWithSmallWidth [

	self wrapOnByWidth: 3.
	
	self layoutText: '12345'.

	editor withoutSelection moveForward: 2.
		
	editor insertCharacters: String cr.
	
	layout extent should equal: 3 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleCharDeletionInsideLastLineInTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '67890'.

	editor withoutSelection moveToTextEnd; moveBackward: 2.
	editor removeNextCharacter.
	
	layout extent should equal: 5 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleCharDeletionInsideSingleLineTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345'.
	
	editor withoutSelection moveForward: 2.
	
	editor removeNextCharacter.
	
	layout extent should equal: 4 @ 10
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleCharDeletionWhenLineShouldBeUnwrapped [

	self wrapOnByWidth: 5.
	
	self layoutText: '123456'.

	layout extent should equal: 5 @ 20.
		
	editor withoutSelection moveForward: 2.
			
	editor removeNextCharacter.
	
	layout extent should equal: 5 @ 10
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleCharInsertionInsideLastLineInTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '67890'.
	
	editor withoutSelection moveToTextEnd; moveBackward: 2.
	editor insertCharacters: '6'.
	
	layout extent should equal: 6 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleCharInsertionInsideSingleLineTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345'.
	
	editor withoutSelection moveForward: 2.
	editor insertCharacters: '6'.
	
	layout extent should equal: 6 @ 10
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleCharInsertionInsideSingleLineTextWithWrapLayout [

	self wrapOn.
	
	self layoutText: '12345'.
	
	editor withoutSelection moveForward: 2.
	editor insertCharacters: '6'.
	
	layout extent should equal: 6 @ 10
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleCharInsertionWhenLineShouldBeWrapped [

	self wrapOnByWidth: 5.
	
	self layoutText: '12345'.
	
	editor withoutSelection moveForward: 2.
	editor insertCharacters: '6'.
	
	layout extent should equal: 5 @ 20
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleMultilineStringInsertionInsideSingleLineTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345'.
	
	editor withoutSelection moveForward: 2.
	
	editor insertCharacters: '123456', String cr, '12'.
	
	layout extent should equal: 8 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testMiddleMultilineStringInsertionInsideSingleLineTextWithWrapLayout [

	self wrapOn.
	
	self layoutText: '12345'.
	
	editor withoutSelection moveForward: 2.
	
	editor insertCharacters: '123456', String cr, '12'.
	
	layout extent should equal: 8 @ 20
]

{ #category : #'tests-navigation' }
TwyLayoutAcceptenceTests >> testMoveDownAtLineStartThenMoveRight [
	
	self wrapOff.
	
	self layoutText: '123456', String cr, '123456'.
		
	layoutCursor moveDown.
	layoutCursor textPosition should equal: 7.
	layoutCursor layoutPosition should equal: 0@10.
		
	layoutCursor moveRight.
	layoutCursor textPosition should equal: 8.
	layoutCursor layoutPosition should equal: 1@10.

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testOverrideCharactersWhenNativeLayout [

	self wrapOff.
	font := Mock new.
	font stub height willReturn: 10.
	(font stub widthOf: [:char | char isDigit]) willReturn: 1.
	(font stub widthOf: $a) willReturn: 3.
	(font stub widthOf: $b) willReturn: 2.	

	self layoutText: '1234'.
	layout extent should equal: 4 @ 10.	
	
	text editContentsBy: [:region | 
		region start linePosition: 1.
		region end linePosition: 3. 		
		region overridePossibleCharactersWith: 'ab'].
			
	layout extent should equal: 7 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testOverrideCharactersWhenWrapLayout [

	self wrapOnByWidth: 4.
	font := Mock new.
	font stub height willReturn: 10.
	(font stub widthOf: [:char | char isDigit]) willReturn: 1.
	(font stub widthOf: $a) willReturn: 3.
	(font stub widthOf: $b) willReturn: 2.	

	self layoutText: '1234'.
	layout extent should equal: 4 @ 10.	
	
	text editContentsBy: [:region | 
		region start linePosition: 1.
		region end linePosition: 3. 		
		region overridePossibleCharactersWith: 'ab'].
			
	layout extent should equal: 4 @ 20
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutOfThreeSpansLineWhenLastMiddleSpanIsLastAtLineAndItShouldWrapLastItem [
	
	self wrapOnByWidth: 3.

	self layoutText: '1234' .
	
	editor withoutSelection linePosition: 1.
	editor selectTextBy linePosition: 3.	
	editor applyAttribute: TwyForeColorAttribute with: Color red.
	layout extent should equal: 3 @ 20.
		
	layoutStrategy preferredExtent: 2 @ 100.
	
	layout rebuildForNewExtent.	
	layout extent should equal: 2 @ 20.
	layout bottomLine extent should equal: 2@10
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutOfThreeSpansLineWhenLastWrappedSpanShouldBecomeUnwrapped [
	
	self wrapOnByWidth: 10.

	self layoutText: '1234' .
	
	"prepare text state"
	editor withoutSelection linePosition: 2.
	editor selectTextBy linePosition: 3.	
	editor applyAttribute: TwyForeColorAttribute with: Color red.
	layout extent should equal: 4 @ 10.
	
	"prepare initial layout"
	layoutStrategy preferredExtent: 3 @ 100.
	layout rebuildForNewExtent.	
	layout extent should equal: 3 @ 20.
	
	"actual test"
	layoutStrategy preferredExtent: 10 @ 100.
	layout rebuildForNewExtent.	
	layout extent should equal: 4 @ 10.
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutWhenFullMiddleSpanShouldBecomeWrapped [
	
	self wrapOnByWidth: 10.

	self layoutText: '12345' .
	
	editor withoutSelection linePosition: 3.
	editor selectTextBy linePosition: 4.	
	editor applyAttribute: TwyForeColorAttribute with: Color red.
	layout extent should equal: 5 @ 10.
		
	layoutStrategy preferredExtent: 3 @ 100.
	
	layout rebuildForNewExtent.	
	layout extent should equal: 3 @ 20
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutWhenMaxWidthIncreased [
	
	self wrapOnByWidth: 4.

	self layoutText: '1234567' .
			
	layout extent should equal: 4 @ 20.
	
	layoutStrategy preferredExtent: 5 @ 100.

	layout rebuildForNewExtent.
	
	layout extent should equal: 5 @ 20.
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutWhenMaxWidthIncreasedAndLastLineBecomeNotNeeded [
	
	self wrapOnByWidth: 3.

	self layoutText: '1234567' .
			
	layout extent should equal: 3 @ 30.
	
	layoutStrategy preferredExtent: 5 @ 100.

	layout rebuildForNewExtent.
	
	layout extent should equal: 5 @ 20.
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutWhenMaxWidthIncreasedButItIsLessThenSingleChar [

	font := Mock new.
	(font stub widthOf: Any) willReturn: 3.
	(font stub height) willReturn: 10.
	
	self wrapOnByWidth: 1.

	self layoutText: '12' .
			
	layout extent should equal: 3 @ 20.
	
	layoutStrategy preferredExtent: 2 @ 100.

	layout rebuildForNewExtent.
	
	layout extent should equal: 3 @ 20.
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutWhenMaxWidthLessThenSingleChar [

	font := Mock new.
	(font stub widthOf: Any) willReturn: 2.
	(font stub height) willReturn: 10.
	
	self wrapOnByWidth: 3.

	self layoutText: '12' .
			
	layout extent should equal: 2 @ 20.
	
	layoutStrategy preferredExtent: 1 @ 100.

	layout rebuildForNewExtent.
	
	layout extent should equal: 2 @ 20.
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutWhenMaxWidthReduced [
	
	self wrapOnByWidth: 5.

	self layoutText: '1234567' .
			
	layout extent should equal: 5 @ 20.
	
	layoutStrategy preferredExtent: 4 @ 100.

	layout rebuildForNewExtent.
	
	layout extent should equal: 4 @ 20.
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutWhenMaxWidthReducedAndNewLineRequired [
	
	self wrapOnByWidth: 5.

	self layoutText: '1234567' .
			
	layout extent should equal: 5 @ 20.
	
	layoutStrategy preferredExtent: 3 @ 100.
	
	layout rebuildForNewExtent.
	
	layout extent should equal: 3 @ 30.
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutWhenSpanAtSameLineShouldBecomeWrapped [
	
	self wrapOnByWidth: 7.

	self layoutText: '1234567' .
	
	text editContentsBy: [ :region |
		region start linePosition: 2.
		region end linePosition: 5.
		region applyAttribute: TwyForeColorAttribute with: Color red].
		
	layout extent should equal: 7 @ 10.
	
	layoutStrategy preferredExtent: 4 @ 100.

	layout rebuildForNewExtent.
	
	layout extent should equal: 4 @ 20.
]

{ #category : #'tests-rebuilding layout' }
TwyLayoutAcceptenceTests >> testRebuildingWrappedLayoutWhenThreeWrappedLinesAndMaxWidthIncreased [
	
	self wrapOnByWidth: 4.

	self layoutText: '1234567890' .
			
	layout extent should equal: 4 @ 30.
	
	layoutStrategy preferredExtent: 50 @ 100.

	layout rebuildForNewExtent.
	
	layout extent should equal: 10 @ 10.
]

{ #category : #'tests-region-building layout' }
TwyLayoutAcceptenceTests >> testRegionBetweenSpanMiddleAndEndWithNativeLayout [
	
	| region |
	self wrapOff.
	
	text := '123456' asTwyText.
	region := text newRegion.
	region selectFullText.
	region start linePosition: 2.
	region end linePosition: 6.
	
	self layoutTextRegion: region.
	
	layout extent should equal: 4 @ 10
]

{ #category : #'tests-region-building layout' }
TwyLayoutAcceptenceTests >> testRegionBetweenSpanStartAndMiddleWithNativeLayout [
	
	| region |
	self wrapOff.
	
	text := '123456' asTwyText.
	region := text newRegion.
	region selectFullText.
	region start linePosition: 0.
	region end linePosition: 3.
	
	self layoutTextRegion: region.
	
	layout extent should equal: 3 @ 10
]

{ #category : #'tests-region-building layout' }
TwyLayoutAcceptenceTests >> testRegionOfFullSpanWithNativeLayout [
	
	| region |
	self wrapOff.
	
	text := '123456' asTwyText.
	region := text newRegion.
	region selectFullText.
	
	self layoutTextRegion: region.
	
	layout extent should equal: 6 @ 10
]

{ #category : #'tests-region-building layout' }
TwyLayoutAcceptenceTests >> testRegionOfSingleSpanWithNativeLayout [
	
	| region |
	self wrapOff.
	
	text := '123456' asTwyText.
	region := text newRegion.
	region selectFullText.
	region start linePosition: 2.
	region end linePosition: 5.
	
	self layoutTextRegion: region.
	
	layout extent should equal: 3 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveCRAfterVirtualWrappedLine [

	self wrapOnByWidth: 2.
	
	self layoutText: '123', String cr, '45'.
	
	layout extent should equal: 2 @ 30.
	
	editor withoutSelection moveToTextEnd; moveToLineStart.
	
	editor removePreviousCharacter.
	
	layout extent should equal: 2 @ 30
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveCRThenRemoveVirtualWrappedLine [

	self wrapOnByWidth: 2.
	
	self layoutText: '123', String cr, '4'.
	
	layout extent should equal: 2 @ 30.
	
	editor withoutSelection moveToTextEnd; moveToLineStart.
	
	editor removePreviousCharacter.
	
	editor removePreviousCharacter.
	
	layout extent should equal: 2 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveCrAfterAnotherCRInTextStartedWithStringWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, String cr, '6789'.

	layout extent should equal: 5 @ 30.

	editor withoutSelection moveToTextEnd; moveToLineStart.

	editor removePreviousCharacter.
	
	layout extent should equal: 5 @ 20
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveCrBetweenTwoLinesWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '6789'.

	layout extent should equal: 5 @ 20.

	editor withoutSelection moveToTextEnd; moveToLineStart.
			
	editor removePreviousCharacter.
	
	layout extent should equal: 9 @ 10
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveCrBetweenTwoLinesWithWrapLayout [

	self wrapOn.
	
	self layoutText: '12345', String cr, '6789'.

	layout extent should equal: 5 @ 20.

	editor withoutSelection moveToTextEnd; moveToLineStart.

	editor removePreviousCharacter.
	
	layout extent should equal: 9 @ 10
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveCrBetweenTwoLinesWithWrapLayoutWithSmallWidth [

	self wrapOnByWidth: 7.
	
	self layoutText: '12345', String cr, '6789'.

	layout extent should equal: 5 @ 20.

	editor withoutSelection moveToTextEnd; moveToLineStart.

	editor removePreviousCharacter.
	
	layout extent should equal: 7 @ 20
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveCrBySelectionTwoLinesWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '6789'.

	layout extent should equal: 5 @ 20.

	editor withoutSelection moveToLineEnd.
	editor selectedText start moveBackward.
	editor selectedText end moveForward: 2.
			
	editor removePreviousCharacter.
	
	layout extent should equal: 7 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveCrBySelectionTwoLinesWhenOneIsEmptyAndWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, String cr, '6789'.

	layout extent should equal: 5 @ 30.

	editor withoutSelection moveToLineEnd.
	editor selectTextBy moveForward.

	editor removePreviousCharacter.

	layout extent should equal: 5 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveEmptyLineWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '1234', String cr.

	layout extent should equal: 4 @ 20.
	
	editor withoutSelection moveToTextEnd.

	editor removePreviousCharacter.
	
	layout extent should equal: 4 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveEmptyLineWhenWrapLayout [

	self wrapOn.
	
	self layoutText: '1234', String cr.

	layout extent should equal: 4 @ 20.
	
	editor withoutSelection moveToTextEnd.
			
	editor removePreviousCharacter.
	
	layout extent should equal: 4 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveMiddleSpanAtLineWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '123456789'.

	layout extent should equal: 9 @ 10.

	text editContentsBy: [:region | 
		region end linePosition: 3; splitSpan; linePosition: 6; splitSpan ].

	editor selectedText start moveToTextStart; moveToSpanEnd.
	editor selectedText end moveToTextEnd; moveToSpanStart.		
	editor removePreviousCharacter.

	layout extent should equal: 6 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveNextCREmptyLineWhenTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: String cr, '123'.

	layout extent should equal: 3 @ 20.
				
	editor removeNextCharacter.
	
	layout extent should equal: 3 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveNextCharAtEndOfLayoutLineUnderWrappedTextLine [

	self wrapOnByWidth: 4.
	
	self layoutText: '1234567'.

	layout extent should equal: 4 @ 20.

	editor withoutSelection moveToTextStart; moveForward: 4.

	editor removeNextCharacter.
	
	layout extent should equal: 4 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveOnlyCrWhenNativeLayout [

	self wrapOff.
	
	self layoutText: String cr.

	layout extent should equal: 0 @ 20.
	
	editor withoutSelection moveToTextEnd.
			
	editor removePreviousCharacter.
	
	layout extent should equal: 0 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveOnlyCrWhenWrapLayout [

	self wrapOn.
	
	self layoutText: String cr.

	layout extent should equal: 0 @ 20.
	
	editor withoutSelection moveToTextEnd.
			
	editor removePreviousCharacter.
	
	layout extent should equal: 0 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveOnlyItemWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '1'.

	editor withoutSelection moveToTextEnd.

	editor removePreviousCharacter.
	
	layout extent should equal: 0 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveOnlyItemWhenWrapLayout [

	self wrapOn.
	
	self layoutText: '1'.

	editor withoutSelection moveToTextEnd.
			
	editor removePreviousCharacter.
	
	layout extent should equal: 0 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemovePreviousCharAtEndOfWrappedVirtualLine [

	self wrapOnByWidth: 4.
	self layoutText: '1234567'.

	layout extent should equal: 4 @ 20.

	editor withoutSelection textPosition: 4.

	editor removePreviousCharacter.
	
	layout extent should equal: 4 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemovePreviousCharAtEndOfWrappedVirtualLineWhenNextLineHasVerySmallFirstChars [

	font := Mock new.
	(font stub widthOf: [:char | char between: $1 and: $4]) willReturn: 2.
	(font stub widthOf: [:char | char between: $5 and: $8]) willReturn: 1.
	(font stub height) willReturn: 10.

	self wrapOnByWidth: 8.
	self layoutText: '1234567'.

	layout extent should equal: 8 @ 20.

	editor withoutSelection textPosition: 4.

	editor removePreviousCharacter.
	
	layout extent should equal: 8 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testRemoveWrappedVirtualLine [

	self wrapOnByWidth: 3.
	
	self layoutText: '12345'.

	layout extent should equal: 3 @ 20.

	editor withoutSelection moveToTextEnd.
	editor selectedText start moveBackward: 2.
			
	editor removePreviousCharacter.
	
	layout extent should equal: 3 @ 10
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testSettingNewTextContents [

	self wrapOff.
	
	self layoutText: '123', String cr, String cr, '456'.
	
	editor newTextContents: '78', String cr, '90'.
	
	layout extent should equal: 2 @ 20
]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testSingleEmptyLineWithNativeLayout [
	
	self wrapOff.
	
	self layoutText: ''.
	
	layout extent should equal: 0 @ 10
	

]

{ #category : #'tests-navigation' }
TwyLayoutAcceptenceTests >> testSingleLineNavigation [
	
	self wrapOff.
	
	self layoutText: '123456'.
		
	layoutCursor moveRight; moveRight.
	layoutCursor textPosition should equal: 2.
	layoutCursor layoutPosition should equal: 2@0.
		
	layoutCursor moveLeft.
	layoutCursor textPosition should equal: 1.
	layoutCursor layoutPosition should equal: 1@0.
	
	layoutCursor moveToTextEnd.
	layoutCursor textPosition should equal: 6.
	layoutCursor layoutPosition should equal: 6@0.
]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testSingleLineWithMultipleSpansWithNativeLayout [
	
	| text |
	self wrapOff.
	
	text := '123456' asTwyText.
	text editContentsBy: [ :region |  
		region end 
			linePosition: 2; splitSpan;
			linePosition: 3; splitSpan;
			linePosition: 5; splitSpan.
	].
	
	self layoutText: text.
	
	layout extent should equal: 6 @ 10
	

]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testSingleLineWithNativeLayout [
	
	self wrapOff.
	
	self layoutText: '123456'.
	
	layout extent should equal: 6 @ 10
	

]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testSingleLineWithTwoSpansWithNativeLayout [
	
	| text |
	self wrapOff.
	
	text := '123456' asTwyText.
	text editContentsBy: [ :region |  
		region end linePosition: 2; splitSpan
	].
	
	self layoutText: text.
	
	layout extent should equal: 6 @ 10
	

]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testSingleLineWithWrapStrategy [
	
	self wrapOnByWidth: 4.

	self layoutText: '123456' .
			
	layout extent should equal: 4 @ 20
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testSplitAtTheEndOfFirstWrappedLine [

	self wrapOnByWidth: 3.
	
	self layoutText: '1234'.

	layout extent should equal: 3 @ 20.
		
	text editContentsBy: [:region | 
		region end linePosition: 3; splitSpan.
	].

	layout extent should equal: 3 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testSplitFirstLineOfMultilineTextWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '12345',String cr, '6789'.

	layout extent should equal: 5 @ 20.

	text editContentsBy: [:region | 
		region end linePosition: 3; splitSpan.
	].

	layout extent should equal: 5 @ 20
	
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testSplitFirstLineOfMultilineTextWhenWrapLayout [

	self wrapOnByWidth: 3.
	
	self layoutText: '1234',String cr, '56'.

	layout extent should equal: 3 @ 30.
		
	text editContentsBy: [:region | 
		region end linePosition: 2; splitSpan.
	].

	layout extent should equal: 3 @ 30
]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testThreeEmptyLinesWithNativeLayout [
	
	self wrapOff.
	
	self layoutText: String cr, String cr.
	
	layout extent should equal: 0 @ 30
	

]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testThreeLinesWithEmptyMIddleLineAndNativeLayout [

	self wrapOff.

	self layoutText: '12345', String cr, String cr, '67890'.

	layout extent should equal: 5 @ 30
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testTwoCharsInsertionAtTheEndOfSingleLineTextWhenItShouldBeWrapped [

	self wrapOnByWidth: 3.
	
	self layoutText: '123'.
	
	editor withoutSelection moveToTextEnd.
	
	editor insertCharacters: '45'.
	
	layout extent should equal: 3 @ 20
]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testTwoCrInsertionAtOnceAtMiddleOfSecondLineWhenTextWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '678'.
	
	editor withoutSelection moveToTextEnd; moveToLineStart; moveForward.
	editor insertCharacters: String cr, String cr.
	
	layout extent should equal: 5 @ 40
]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testTwoEmptyLinesWithNativeLayout [
	
	self wrapOff.
	
	self layoutText: String cr.
	
	layout extent should equal: 0 @ 20
	

]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testTwoEmptyLinesWithWrapLayout [
	
	self wrapOnByWidth: 4.
	
	self layoutText: String cr.
	
	layout extent should equal: 0 @ 20
	

]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testTwoLinesWithNativeLayout [

	self wrapOff.
	
	self layoutText: '12345', String cr, '67890'.
	
	layout extent should equal: 5 @ 20
	

]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testTwoLinesWithWrapStrategy [

	self wrapOnByWidth: 4.
	
	self layoutText: '12345', String cr, '67890'.
	
	layout extent should equal: 4 @ 40
	

]

{ #category : #'tests-restore layout after changes' }
TwyLayoutAcceptenceTests >> testTwoSplitsAndThenRemoveSplittedSpanWhenNativeLayout [

	self wrapOff.
	
	self layoutText: '123456789'.

	layout extent should equal: 9 @ 10.

	text editContentsBy: [:region | 
		region end linePosition: 3; splitSpan; linePosition: 6; splitSpan.
		region start moveToTextStart; moveToSpanEnd.
		region end moveToTextEnd; moveToSpanStart.				
		region backspaceKey
	].

	layout extent should equal: 6 @ 10
]

{ #category : #'tests-navigation' }
TwyLayoutAcceptenceTests >> testUpDownNavigationAtLinesMiddle [
	
	self wrapOff.
	
	self layoutText: '123456', String cr, '123456'.
		
	layoutCursor moveRight; moveRight; moveDown.
	layoutCursor textPosition should equal: 9.
	layoutCursor layoutPosition should equal: 2@10.
		
	layoutCursor moveLeft; moveUp.
	layoutCursor textPosition should equal: 1.
	layoutCursor layoutPosition should equal: 1@0.

]

{ #category : #'tests-building layout' }
TwyLayoutAcceptenceTests >> testWrapWideCharacter [

	font := Mock new.
	(font stub widthOf: Any) willReturn: 3.
	(font stub height) willReturn: 10.

	self wrapOnByWidth: 1.
	
	self layoutText: '12345'.
	
	layout extent should equal: 3 @ 50
	

]

{ #category : #helpers }
TwyLayoutAcceptenceTests >> wrapOff [

	layoutStrategy := TwyNativeLayoutStrategy new	

]

{ #category : #helpers }
TwyLayoutAcceptenceTests >> wrapOn [

	layoutStrategy := TwyWrapTextStrategy new.
	layoutStrategy preferredExtent: 100@100
]

{ #category : #helpers }
TwyLayoutAcceptenceTests >> wrapOnByWidth: aNumber [

	self wrapOn.
	layoutStrategy preferredExtent: aNumber@100
]
