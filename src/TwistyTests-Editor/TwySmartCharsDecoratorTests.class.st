Class {
	#name : #TwySmartCharsDecoratorTests,
	#superclass : #TwySimpleTextDecorationTestCase,
	#category : #'TwistyTests-Editor'
}

{ #category : #running }
TwySmartCharsDecoratorTests >> decoratorClass [
	^TwySmartCharsDecorator
]

{ #category : #helpers }
TwySmartCharsDecoratorTests >> prepareRealTestWithText: aString andSmartChars: twoSmartChars [ 

	| text |
	decorator addSmartChar: (TwySmartChar with: twoSmartChars first and: twoSmartChars second).

	text := decorator defaultText.
	textSelection := text newRegion.
	textSelection replaceWith: aString.
	textSelection end moveToTextStart.
	textSelection start moveToTextStart.
	
	^text
	

]

{ #category : #'tests-design' }
TwySmartCharsDecoratorTests >> testHasEmptySmartCharsByDefault [

	decorator smartChars should be isEmpty
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealRemovingPreviousSmartCharWhenItAtTheEndOfLine [

	| text |
	text := self prepareRealTestWithText: '1234(', String cr, '567' andSmartChars: '()'. 
	textSelection start moveToTextStart; moveToLineEnd.
	textSelection end moveToTextStart; moveToLineEnd.
	
	self removePreviousCharacter.
	
	text asString should equal: '1234', String cr, '567'.
	
	textSelection start linePosition should be: 4.
	textSelection end linePosition should be: 4
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealRemovingPreviousSmartCharWhenNextIsNotOpposite [

	| text |
	text := self prepareRealTestWithText: '1(234' andSmartChars: '()'. 
	textSelection start linePosition: 2.
	textSelection end linePosition: 2.
	
	self removePreviousCharacter.
	
	text asString should equal: '1234'.
	
	textSelection start linePosition should be: 1.
	textSelection end linePosition should be: 1
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealRemovingPreviousSmartCharWhenNextIsOpposite [

	| text |
	text := self prepareRealTestWithText: '1()234' andSmartChars: '()'. 
	textSelection start linePosition: 2.
	textSelection end linePosition: 2.
	
	self removePreviousCharacter.
	
	text asString should equal: '1234'.
	
	textSelection start linePosition should be: 1.
	textSelection end linePosition should be: 1
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionAtEndOfLineWhenLastCharIsSeparator [

	| text |
	text := self prepareRealTestWithText: '1234 ', String cr, '567' andSmartChars: '()'.
	textSelection start moveToLineEnd.
	textSelection end moveToLineEnd.
		
	insertedString := '('.
	self insertCharacters.
	
	text asString should equal: '1234 ()', String cr, '567'.
	textSelection start linePosition should be: 6.
	textSelection end linePosition should be: 6
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionAtEndOfTextWhenLastCharIsNotSeparator [

	| text |
	text := self prepareRealTestWithText: '1234' andSmartChars: '()'.
	textSelection start moveToTextEnd.
	textSelection end moveToTextEnd.
		
	insertedString := '('.
	self insertCharacters.
	
	text asString should equal: '1234('.
	textSelection start linePosition should be: 5.
	textSelection end linePosition should be: 5
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionAtEndOfTextWhenLastCharIsSeparator [

	| text |
	text := self prepareRealTestWithText: '1234 ' andSmartChars: '()'.
	textSelection start moveToTextEnd.
	textSelection end moveToTextEnd.
		
	insertedString := '('.
	self insertCharacters.
	
	text asString should equal: '1234 ()'.
	textSelection start linePosition should be: 6.
	textSelection end linePosition should be: 6
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionAtStartOfTextWhenFirstCharIsNotSeparator [

	| text |
	text := self prepareRealTestWithText: '1234' andSmartChars: '()'.
	
	insertedString := '('.
	self insertCharacters.
	
	text asString should equal: '(1234'.
	textSelection start linePosition should be: 1.
	textSelection end linePosition should be: 1
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionAtStartOfTextWhenFirstCharSeparator [

	| text |
	text := self prepareRealTestWithText: ' 1234' andSmartChars: '()'.
	
	insertedString := '('.
	self insertCharacters.
	
	text asString should equal: '() 1234'.
	textSelection start linePosition should be: 1.
	textSelection end linePosition should be: 1
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionTwiceWhenFullTextSelected [

	| text |
	text := self prepareRealTestWithText: '1234' andSmartChars: '()'.
	textSelection start moveToTextStart.
	textSelection end moveToTextEnd.
	
	insertedString := '('.
	self insertCharacters.	
	
	text asString should equal: '(1234)'.
	
	self insertCharacters.	

	text asString should equal: '1234'.
	textSelection start linePosition should be: 0.
	textSelection end linePosition should be: 4.
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionTwiceWhenMultiLineSelection [

	| text |
	text := self prepareRealTestWithText: '1234', String cr, '567' andSmartChars: '()'.
	textSelection start moveToTextStart; moveForward.
	textSelection end moveToTextEnd; moveBackward.
		
	insertedString := '('.
	self insertCharacters.
	
	text asString should equal: '1(234', String cr, '56)7'.

	self insertCharacters.
	text asString should equal: '1234', String cr, '567'.

	textSelection start lineNumber should be: 1.
	textSelection start linePosition should be: 1.
	textSelection end lineNumber should be: 2.
	textSelection end linePosition should be: 2
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionWhenFullTextSelected [

	| text |
	text := self prepareRealTestWithText: '1234' andSmartChars: '()'.
	textSelection start moveToTextStart.
	textSelection end moveToTextEnd.
	
	insertedString := '('.
	self insertCharacters.	
	
	text asString should equal: '(1234)'.
	textSelection start linePosition should be: 1.
	textSelection end linePosition should be: 5.
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionWhenMultiLineSelection [

	| text |
	text := self prepareRealTestWithText: '1234', String cr, '567' andSmartChars: '()'.
	textSelection start moveToTextStart; moveForward.
	textSelection end moveToTextEnd; moveBackward.
		
	insertedString := '('.
	self insertCharacters.
	
	text asString should equal: '1(234', String cr, '56)7'.
	textSelection start lineNumber should be: 1.
	textSelection start linePosition should be: 2.
	textSelection end lineNumber should be: 2.
	textSelection end linePosition should be: 2
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionWhenSelectionNotEmpty [

	| text |
	text := self prepareRealTestWithText: '1234' andSmartChars: '()'.
	textSelection start moveToTextStart; moveForward.
	textSelection end moveToTextEnd; moveBackward.
	
	insertedString := '('.
	self insertCharacters.
		
	text asString should equal: '1(23)4'.
	textSelection start linePosition should be: 2.
	textSelection end linePosition should be: 4
]

{ #category : #'tests-acceptance' }
TwySmartCharsDecoratorTests >> testRealSmartCharInsertionWhenSelectionNotEmptyAndAlreadySurroundedBySmartChars [

	| text |
	text := self prepareRealTestWithText: '1234' andSmartChars: '()'.
	textSelection start moveToTextStart; moveForward.
	textSelection end moveToTextEnd; moveBackward.
	
	insertedString := '('.
	self insertCharacters.	
	
	text asString should equal: '1(23)4'.
	
	self insertCharacters.
	
	text asString should equal: '1234'.
	textSelection start linePosition should be: 1.
	textSelection end linePosition should be: 3.
]

{ #category : #'tests-design' }
TwySmartCharsDecoratorTests >> testRemovingPreviousSmartCharacterWhenSelectionEmpty [

	[:smartChar1 :smartChar2 :smartChar3 | 
		decorator addSmartChar: smartChar1; addSmartChar: smartChar2; addSmartChar: smartChar3.
		[ self removePreviousCharacter]
			should lenient satisfy: 
		[textSelection isEmpty willReturn: true; useArbitrarily.
		selectionEnd previousItem willReturn: $S.
		(smartChar1 isBasedOn: $S) willReturn: false; useArbitrarily.
		(smartChar2 isBasedOn: $S) willReturn: true; useArbitrarily.
		smartChar2 removeAsPreviousCharacterAt: textSelection]
	] runWithMocks
]

{ #category : #'tests-design' }
TwySmartCharsDecoratorTests >> testRemovingPreviousSmartCharacterWhenSelectionNotEmpty [

	[:smartChar1 :smartChar2 :smartChar3 | 
		decorator addSmartChar: smartChar1; addSmartChar: smartChar2; addSmartChar: smartChar3.
		[ self removePreviousCharacter]
			should strictly satisfy: 
		[textSelection isEmpty willReturn: false; useArbitrarily.
		textSelection backspaceKey]
	] runWithMocks
]

{ #category : #'tests-design' }
TwySmartCharsDecoratorTests >> testSingleNotSmartCharacterInsertion [

	[:smartChar1 | 
		insertedString  := 'S'.
		decorator addSmartChar: smartChar1.
		[ self insertCharacters ]
			should strictly satisfy: 
		[ (smartChar1 isBasedOn: $S) willReturn: false; useArbitrarily.
		textSelection replaceWith: insertedString]
	] runWithMocks
]

{ #category : #'tests-design' }
TwySmartCharsDecoratorTests >> testSmartCharacterInsertion [

	[:smartChar1 :smartChar2 :smartChar3 | 
		insertedString  := 'S'.
		decorator addSmartChar: smartChar1; addSmartChar: smartChar2; addSmartChar: smartChar3.
		[ self insertCharacters ]
			should strictly satisfy: 
		[ (smartChar1 isBasedOn: $S) willReturn: false; useArbitrarily.
		(smartChar2 isBasedOn: $S) willReturn: true; useArbitrarily.
		smartChar2 insertAt: textSelection]
	] runWithMocks
]
