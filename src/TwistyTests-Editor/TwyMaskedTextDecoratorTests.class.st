Class {
	#name : #TwyMaskedTextDecoratorTests,
	#superclass : #TwyTextDecoratorTestCase,
	#category : #'TwistyTests-Editor'
}

{ #category : #running }
TwyMaskedTextDecoratorTests >> decoratorClass [ 
	^TwyMaskedTextDecorator 
]

{ #category : #specs }
TwyMaskedTextDecoratorTests >> overridePreviousCharWithAsterix [
	
	textSelection collapseAtStart.	
	selectionStart moveBackward.
	(textSelection getStartAttribute: TwyMaskAsterixAttribute) willReturn: #asterixChar.
	textSelection overridePossibleCharactersWith: 'asterixChar'.
	textSelection collapseAtStart
]

{ #category : #running }
TwyMaskedTextDecoratorTests >> prepareRealTestWithMask: maskTemplate [

	| text |
	decorator maskString: maskTemplate whereAsterixIs: $*.
	
	text := decorator defaultText.
	textSelection := text newRegion.
	selectionEnd := textSelection end.
	selectionStart := textSelection start.
	
	^text
]

{ #category : #running }
TwyMaskedTextDecoratorTests >> setUp [
	super setUp
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testCharactersInsertionShouldIgnoreSpansWithoutAsterix [
	
	[:spanRegion |
		 
		[ self insertCharacters ] 
			should strictly satisfy: 
		[selectionEnd moveToTextEnd.
		(textSelection splittedBySpansDo: Any while: Any) will: [ :action :condition | action value: spanRegion ].
		(spanRegion hasAttribute: TwyMaskAsterixAttribute) willReturn: false] 
	] runWithMocks
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testCharactersInsertionShouldOverrideEachNextSpanWithRemainsCharacters [
	
	[:spanRegion :spanRegion2 :result1 :result2 |
		 
		[ self insertCharacters ] 
			should strictly satisfy: 
		[result1 restString willReturn: 'restString'; useArbitrarily.
		result2 restString willReturn: 'rest'; useArbitrarily.
		selectionEnd moveToTextEnd.
		(textSelection splittedBySpansDo: Any while: Any) 
			will: [ :action :condition | action value: spanRegion; value: spanRegion2 ].
		(spanRegion hasAttribute: TwyMaskAsterixAttribute) willReturn: true.
		(spanRegion overridePossibleCharactersWith: insertedString) willReturn: result1.
		(spanRegion2 hasAttribute: TwyMaskAsterixAttribute) willReturn: true.
		(spanRegion2 overridePossibleCharactersWith: 'restString') willReturn: result2.
		result2 moveToEnd: textSelection] 
	] runWithMocks
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testCharactersInsertionShouldOverrideSpansWithAsterix [
	
	[:spanRegion :result |
		 
		[ self insertCharacters ] 
			should strictly satisfy: 
		[selectionEnd moveToTextEnd.
		(textSelection splittedBySpansDo: Any while: Any) will: [ :action :condition | action value: spanRegion ].
		(spanRegion hasAttribute: TwyMaskAsterixAttribute) willReturn: true.
		(spanRegion overridePossibleCharactersWith: insertedString) willReturn: result.		
		result moveToEnd: textSelection] 
	] runWithMocks
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testCharactersInsertionShouldStopWhenEmptyRestStringReturned [
	
	[:spanRegion |
		 
		insertedString := ''.
		[ self insertCharacters ] 
			should strictly satisfy: 
		[selectionEnd moveToTextEnd.
		(textSelection splittedBySpansDo: Any while: Any) will: [ :action :condition | 
			(condition value: spanRegion) should be: false ].
		] 
	] runWithMocks
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testCreationMaskFromString [
	
	[:stringWithAsterixes :text :textRegion |
		 
		[ decorator maskString: stringWithAsterixes whereAsterixIs: $*] 
			should strictly satisfy: 
		[stringWithAsterixes asTwyText willReturn: text.
		(text withRegionsWhereCharactersAre: Any do: Any) will: [ :condition :action |
			(condition value: $*) should be: true.
			(condition value: $r) should be: false.
			action value: textRegion ].
		textRegion applyAttribute: TwyMaskAsterixAttribute with: $*].
		
		decorator mask should be: text
	] runWithMocks
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testCreationMaskFromStringWithHiddenSecretCharacters [
	| mask spans |
	decorator := TwyMaskedTextDecorator
		withMaskFromString: '* **** '
		whichHideCharactersBy: 'x**x*'
		withAsterix: $-.
	mask := decorator mask.
	spans := mask elements allButFirst allButLast.
	spans should haveSize: 6.
	spans first contents should equal: '*'.
	(spans first hasAttribute: TwySecretAsterixAttribute) should
		be: false.
	spans second contents should equal: ' '.
	(spans second hasAttribute: TwySecretAsterixAttribute) should
		be: false.
	spans third contents should equal: '**'.
	(spans third hasAttribute: TwySecretAsterixAttribute) should be: true.
	(spans third getAttribute: TwySecretAsterixAttribute) should
		equal: $-.
	spans fourth contents should equal: '*'.
	(spans fourth hasAttribute: TwySecretAsterixAttribute) should
		be: false.
	spans fifth contents should equal: '*'.
	(spans fifth hasAttribute: TwySecretAsterixAttribute) should be: true.
	(spans fifth getAttribute: TwySecretAsterixAttribute) should
		equal: $-.
	spans sixth contents should equal: ' '.
	(spans sixth hasAttribute: TwySecretAsterixAttribute) should
		be: false
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testCutSelection [
	
	self cutSelection
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testExtractionNativeValueFromDecoratedString [

	| text actual |
	text := self prepareRealTestWithMask: '8(***)***-**-**'.
	
	selectionEnd linePosition: 3.
	textSelection collapseAtEnd.
	insertedString := 'ABC'.
	self insertCharacters.
	
	selectionEnd linePosition: 8.
	textSelection collapseAtEnd.
	insertedString := 'DEF'.
	self insertCharacters.
		
	text asString should equal: '8(*AB)C*D-EF-**'.

	actual := decorator extractNativeStringFrom: text.
	
	actual should equal: 'ABCDEF'
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testGettingDefaultText [
	
	| maskText |
	maskText := Mock new.
	maskText stub copy willReturn: #maskCopy.
	
	decorator mask: maskText.
	
	decorator defaultText should be: #maskCopy
]

{ #category : #'tests-acceptance' }
TwyMaskedTextDecoratorTests >> testRealMultipleCharactersInsertion [

	| text |
	
	text := self prepareRealTestWithMask: '8(***)***-**-**'.

	insertedString := 'ABCD'.

	self insertCharacters.
	
	text asString should equal: '8(ABC)D**-**-**'.
	textSelection isEmpty should be: true.
	selectionEnd linePosition should be: 7
]

{ #category : #'tests-acceptance' }
TwyMaskedTextDecoratorTests >> testRealMultipleCharactersInsertion2 [

	| text |
	
	text := self prepareRealTestWithMask: '8(***)***-**-**'.

	selectionEnd linePosition: 3.
	textSelection collapseAtEnd.
	
	insertedString := 'ABC'.
	self insertCharacters.
	
	text asString should equal: '8(*AB)C**-**-**'.
	textSelection isEmpty should be: true.
	selectionEnd linePosition should be: 7
]

{ #category : #'tests-acceptance' }
TwyMaskedTextDecoratorTests >> testRealRemovingPreviousCharacter [

	| text |
	text := self prepareRealTestWithMask: '8(***)***-**-**'.
	
	insertedString := 'ABCD'.
	self insertCharacters.
	textSelection end moveBackward.
	textSelection collapseAtEnd.
	
	textSelection end nextItemAtSpan should equal: $D.
	
	self removePreviousCharacter.
	
	text asString should equal: '8(AB*)D**-**-**'.
	textSelection end linePosition should equal: 4
]

{ #category : #'tests-acceptance' }
TwyMaskedTextDecoratorTests >> testRealRemovingPreviousCharacterWhenNoAsterixExists [

	| text |
	text := self prepareRealTestWithMask: '8(***)***-**-**'.
	
	textSelection end linePosition: 3; moveBackward.
	textSelection collapseAtEnd.
	
	textSelection end previousItem should equal: $(.
	
	self removePreviousCharacter.
	
	text asString should equal: '8(***)***-**-**'.
	textSelection end linePosition should equal: 2.
	textSelection start linePosition should equal: 2
]

{ #category : #'tests-acceptance' }
TwyMaskedTextDecoratorTests >> testRealSingleCharacterInsertion [

	| text |
	text := self prepareRealTestWithMask: '8(***)***-**-**'.
	
	insertedString := 'A'.
	self insertCharacters.
	
	text asString should equal: '8(A**)***-**-**'.
	textSelection isEmpty should be: true.
	selectionEnd linePosition should be: 3
]

{ #category : #'tests-acceptance' }
TwyMaskedTextDecoratorTests >> testRealSingleCharacterInsertionAtSecondAsterix [
	| text |
	text := self prepareRealTestWithMask: '8(***)***-**-**'.
	
	insertedString := 'A'.
	selectionEnd linePosition: 3.
	textSelection collapseAtEnd.
	self insertCharacters.
	
	text asString should equal: '8(*A*)***-**-**'.
	textSelection isEmpty should be: true.
	selectionEnd linePosition should be: 4
]

{ #category : #'tests-acceptance' }
TwyMaskedTextDecoratorTests >> testRealVeryBigStringInsertion [

	| text |
	
	text := self prepareRealTestWithMask: '1**4**7*'.

	insertedString := 'ABCDEFGHIJ'.

	self insertCharacters.
	
	text asString should equal: '1AB4CD7E'.
	textSelection isEmpty should be: true.
	selectionEnd isAtEnd should be: true
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testRemovingNextCharacter [
	
	self removeNextCharacter
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testRemovingPreviousCharacterWhenCurrentSpanIsAsterixAndRegionNotAtSpanStart [
	
	[:eachSpan | 
		[ self removePreviousCharacter ] 
			should strictly satisfy: 
		[textSelection isEmpty willReturn: true.
		(textSelection hasAttribute: TwyMaskAsterixAttribute) willReturn: true.
		selectionStart isAtSpanStart willReturn: false.
		self overridePreviousCharWithAsterix] 
	] runWithMocks
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testRemovingPreviousCharacterWhenCurrentSpanIsAsterixButRegionIsAtSpanStart [
	
	[:eachSpan | 
		[ self removePreviousCharacter ] 
			should strictly satisfy: 
		[textSelection isEmpty willReturn: true.
		(textSelection hasAttribute: TwyMaskAsterixAttribute) willReturn: true.
		selectionStart isAtSpanStart willReturn: true.
		(selectionStart moveBackwardToSpanWhich: Any) will: [:condition | condition value: eachSpan. true].
		(eachSpan hasAttribute: TwyMaskAsterixAttribute) willReturn: true.
		selectionStart moveToSpanEnd.
		self overridePreviousCharWithAsterix] 
	] runWithMocks
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testRemovingPreviousCharacterWhenCurrentSpanIsNotAsterix [
	
	[:eachSpan | 
		[ self removePreviousCharacter ] 
			should strictly satisfy: 
		[textSelection isEmpty willReturn: true.
		(textSelection hasAttribute: TwyMaskAsterixAttribute) willReturn: false.
		(selectionStart moveBackwardToSpanWhich: Any) will: [:condition | condition value: eachSpan. true].
		(eachSpan hasAttribute: TwyMaskAsterixAttribute) willReturn: true.
		selectionStart moveToSpanEnd.
		self overridePreviousCharWithAsterix] 
	] runWithMocks
]

{ #category : #'tests-design' }
TwyMaskedTextDecoratorTests >> testRemovingPreviousCharacterWhenNoAsterixExists [
	
	[:eachSpan | 
		[ self removePreviousCharacter ] 
			should strictly satisfy: 
		[textSelection isEmpty willReturn: true.
		(textSelection hasAttribute: TwyMaskAsterixAttribute) willReturn: false.
		(selectionStart moveBackwardToSpanWhich: Any) willReturn: false] 
	] runWithMocks
]
