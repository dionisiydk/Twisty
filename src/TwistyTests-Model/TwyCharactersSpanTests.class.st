Class {
	#name : #TwyCharactersSpanTests,
	#superclass : #TwyElementTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyCharactersSpanTests >> setUp [
	super setUp.
	
	textElement contents: 'span contents'.
]

{ #category : #tests }
TwyCharactersSpanTests >> testCanIntegrateEmptySpan [

	[ :anotherSpan  |
		[ (textElement canIntegrate: anotherSpan) should be: true]
			should strictly satisfy: 
		[anotherSpan isEmpty willReturn: true]
	] runWithMocks 
]

{ #category : #tests }
TwyCharactersSpanTests >> testCanIntegrateSpanWithoutSpecificAttributes [

	[ :anotherSpan  |
		[ (textElement canIntegrate: anotherSpan) should be: true]
			should strictly satisfy: 
		[anotherSpan isEmpty willReturn: false.
		anotherSpan hasSpecificAttributes willReturn: false]
	] runWithMocks 
]

{ #category : #tests }
TwyCharactersSpanTests >> testCantIntegrateSpanWithSpecificAttributes [

	[ :anotherSpan  |
		[ (textElement canIntegrate: anotherSpan) should be: false]
			should strictly satisfy: 
		[anotherSpan isEmpty willReturn: false.
		anotherSpan hasSpecificAttributes willReturn: true]
	] runWithMocks 
]

{ #category : #tests }
TwyCharactersSpanTests >> testConvertingToStringOnStream [

	| stream |
	textElement contents: '1234567'.
	
	stream := String new writeStream.
	
	textElement asStringOn: stream.
	
	stream contents should equal: '1234567'
]

{ #category : #tests }
TwyCharactersSpanTests >> testConvertingToStringStartingAtEnd [

	| stream |
	textElement contents: '1234567'.
	
	stream := String new writeStream.
	
	textElement asStringOn: stream startingAt: 8.
	
	stream contents should equal: ''
]

{ #category : #tests }
TwyCharactersSpanTests >> testConvertingToStringStartingAtMiddleUpToMiddle [

	| stream |
	textElement contents: '1234567'.
	
	stream := String new writeStream.
	
	textElement asStringOn: stream startingAt: 3 upTo: 5.
	
	stream contents should equal: '45'
]

{ #category : #tests }
TwyCharactersSpanTests >> testConvertingToStringStartingAtOffset [

	| stream |
	textElement contents: '1234567'.
	
	stream := String new writeStream.
	
	textElement asStringOn: stream startingAt: 3.
	
	stream contents should equal: '4567'
]

{ #category : #tests }
TwyCharactersSpanTests >> testConvertingToStringStartingAtStart [

	| stream |
	textElement contents: '1234567'.
	
	stream := String new writeStream.
	
	textElement asStringOn: stream startingAt: 0.
	
	stream contents should equal: '1234567'
]

{ #category : #tests }
TwyCharactersSpanTests >> testConvertingToStringUpToEnd [

	| stream |
	textElement contents: '1234567'.
	
	stream := String new writeStream.
	
	textElement asStringOn: stream upTo: 8.
	
	stream contents should equal: '1234567'
]

{ #category : #tests }
TwyCharactersSpanTests >> testConvertingToStringUpToOffset [

	| stream |
	textElement contents: '1234567'.
	
	stream := String new writeStream.
	
	textElement asStringOn: stream upTo: 4.
	
	stream contents should equal: '1234'
]

{ #category : #tests }
TwyCharactersSpanTests >> testConvertingToStringUpToStart [

	| stream |
	textElement contents: '1234567'.
	
	stream := String new writeStream.
	
	textElement asStringOn: stream upTo: 0.
	
	stream contents should equal: ''
]

{ #category : #tests }
TwyCharactersSpanTests >> testCopyShouldHasContentsCopy [

	| copy |
	textElement contents: '1234567'.
	
	copy := textElement copy.
	
	copy contents should equal: textElement contents.
	copy contents should not be: textElement contents
]

{ #category : #tests }
TwyCharactersSpanTests >> testCreateDrawerByLayoutBuilder [
	| actual |
	[ :layoutBuilder | 
	[ actual := textElement createDrawerBy: layoutBuilder ] should
		strictly
		satisfy: [ (layoutBuilder selectFontFor: textElement) willReturn: #font ].
	actual should beInstanceOf: TwyCharactersSpanDrawer.
	actual font should be: #font ] runWithMocks
]

{ #category : #tests }
TwyCharactersSpanTests >> testCreateDrawerByLayoutBuilderWhenSpanMarkedWithSecretAndMaskAttributes [
	| actual |
	[ :layoutBuilder | 
	textElement
		applyAttribute: (TwySecretAsterixAttribute with: #secretAsterixChar).
	textElement
		applyAttribute: (TwyMaskAsterixAttribute with: #maskAsterixChar).
	[ actual := textElement createDrawerBy: layoutBuilder ] should
		strictly
		satisfy: [ (layoutBuilder selectFontFor: textElement) willReturn: #font ].
	actual should beInstanceOf: TwySecretCharactersSpanDrawer.
	actual font should be: #font.
	actual substitutionChar should be: #secretAsterixChar.
	actual excludedChars should equal: #(#maskAsterixChar) ] runWithMocks
]

{ #category : #tests }
TwyCharactersSpanTests >> testCreateDrawerByLayoutBuilderWhenSpanMarkedWithSecretAttribute [
	| actual |
	[ :layoutBuilder | 
	textElement
		applyAttribute: (TwySecretAsterixAttribute with: #asterixChar).
	[ actual := textElement createDrawerBy: layoutBuilder ] should
		strictly
		satisfy: [ (layoutBuilder selectFontFor: textElement) willReturn: #font ].
	actual should beInstanceOf: TwySecretCharactersSpanDrawer.
	actual font should be: #font.
	actual substitutionChar should be: #asterixChar.
	actual excludedChars should be isEmpty ] runWithMocks
]

{ #category : #tests }
TwyCharactersSpanTests >> testCreationNewActiveCursor [
	| cursor |
	text := TwyText new.
	textElement text: text.
	cursor := textElement newActiveCursor.
	cursor should beInstanceOf: TwyActiveTextCursor.
	cursor text should be: text.
	cursor span should be: textElement.
	cursor isAtSpanStart should be: true
]

{ #category : #tests }
TwyCharactersSpanTests >> testCreationNewPassiveCursor [
	| cursor |
	text := TwyText new.
	textElement text: text.
	cursor := textElement newPassiveCursor.
	cursor should beInstanceOf: TwyPassiveTextCursor.
	cursor text should be: text.
	cursor span should be: textElement.
	cursor isAtSpanStart should be: true
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteAllAfterPosition [

	textElement contents: '1234567'.
	
	textElement deleteAllAfter: 3.
	
	textElement contents should equal: '123'.
	
	self assertNeighboursNotChanged 
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteAllBeforePosition [

	textElement contents: '1234567'.
	
	textElement deleteAllBefore: 5.
	
	textElement contents should equal: '67'.
	
	self assertNeighboursNotChanged 
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteEmptyInterval [

	textElement contents: '1234567'.
	
	textElement deleteFrom: 3 to: 3.
	
	textElement contents should equal: '1234567'.
	
	self assertNeighboursNotChanged.
	textChanges should be isEmpty 
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteEmptySpanByIntervalWhenNoSpansBeforeAndAfterShouldNotAnnounceAnything [

	textElement contents: ''.
	
	textElement deleteFrom: 0 to: 0.
	
	textChanges should be isEmpty		
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteEndPartOfSpan [

	textElement contents: '1234567'.
	
	textElement deleteFrom: 3 to: 7.
	
	textElement contents should equal: '123'.
	
	self assertNeighboursNotChanged 
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteFullSpanIntervalWhenNextIsSpan [

	| span |
	span := TwySpan new.
	
	textElement next: span.
	textElement contents: '1234567'.
	
	textElement deleteFrom: 0 to: 7.
	
	textElement contents should equal: '1234567'.
	
	previousElement next should be: span.
	span previous should be: previousElement 
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteFullSpanIntervalWhenNextIsSpanShouldAnnounceChange [
	| span |
	span := TwySpan new.
	textElement next: span.
	textElement contents: '1234567'.
	textElement deleteFrom: 0 to: 7.
	textChanges should haveSize: 1.
	textChanges first should beInstanceOf: TwyElementsGroupRemoved.
	textChanges first text should be: text.
	textChanges first firstRemovedElement should be: textElement
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteFullSpanIntervalWhenNoSpansBeforeAndAfter [

	textElement contents: '1234567'.
	
	textElement deleteFrom: 0 to: 7.
	
	textElement contents should be isEmpty.
	
	self assertNeighboursNotChanged 	
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteFullSpanIntervalWhenNoSpansBeforeAndAfterShouldAnnounceChange [
	| change |
	textElement contents: '1234567'.
	textElement deleteFrom: 0 to: 7.
	textChanges should haveSize: 1.
	(change := textChanges first) should
		beInstanceOf: TwyCharactersSpanDecreased.
	change text should be: text.
	change element should be: textElement.
	change initialContents should equal: '1234567'.
	change deletionStart should be: 0.
	change deletionEnd should be: 7
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteMiddlePartOfSpan [

	textElement contents: '1234567'.
	
	textElement deleteFrom: 3 to: 5.
	
	textElement contents should equal: '12367'.
	
	self assertNeighboursNotChanged 
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeletePartOfSpanShouldAnnounceChange [
	| change |
	textElement contents: '1234567'.
	textElement deleteFrom: 3 to: 5.
	textChanges should haveSize: 1.
	(change := textChanges first) should
		beInstanceOf: TwyCharactersSpanDecreased.
	change text should be: text.
	change element should be: textElement.
	change initialContents should equal: '1234567'.
	change deletionStart should be: 3.
	change deletionEnd should be: 5
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteRedundantWhenItIsEmptyAndNextIsSpan [

	| nextSpan |
	nextSpan := TwySpan new.	
	textElement next: nextSpan.

	textElement contents: ''.	
	textElement deleteIfRedundant.
	
	previousElement next should be: nextSpan.
	nextSpan previous should be: previousElement 
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteRedundantWhenItIsEmptyButNextAndPreviousIsNotSpan [

	textElement contents: ''.	
	textElement deleteIfRedundant.
	
	previousElement next should be: textElement.
	textElement next should be: nextElement
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteRedundantWhenItIsNotEmpty [

	textElement contents: '1234'.	
	textElement deleteIfRedundant.
	
	previousElement next should be: textElement.
	textElement next should be: nextElement
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteStartPartOfSpan [

	textElement contents: '1234567'.
	
	textElement deleteFrom: 0 to: 5.
	
	textElement contents should equal: '67'.
	
	self assertNeighboursNotChanged 
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteWhenNextIsSpan [

	| nextSpan |
	nextSpan := TwySpan new.	
	textElement next: nextSpan.
	
	textElement delete.
	
	previousElement next should be: nextSpan.
	nextSpan previous should be: previousElement 
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteWhenNoSpansBeforeAndAfter [

	textElement contents: '12345'.
	
	textElement delete.
	
	textElement contents should be isEmpty.
	
	self assertNeighboursNotChanged 
]

{ #category : #tests }
TwyCharactersSpanTests >> testDeleteWhenPreviousIsSpan [

	| previousSpan |
	previousSpan := TwySpan new.	
	textElement previous: previousSpan.
	
	textElement delete.
	
	nextElement previous should be: previousSpan.
	previousSpan next should be: nextElement
		
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testHasEmptyContentsByDefault [

	self textElementClass new contents should equal: ''
]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionIntoAnotherSpanWhenItCanBeIntegrated [

	self mockNeighbours.
	[ :targetSpan |
		[ textElement insertInto: targetSpan at: 5]
			should strictly satisfy: 
		[(targetSpan canIntegrate: textElement) willReturn: true. 
		targetSpan insertSimpleString: textElement contents at: 5.
		nextElement isTextEnd willReturn: false.
		targetSpan insertTextStartedWith: nextElement at: textElement length + 5]
	] runWithMocks 
]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionIntoAnotherSpanWhenItCantBeIntegrated [

	self mockNeighbours.
	[ :targetSpan |
		[ textElement insertInto: targetSpan at: 5]
			should strictly satisfy: 
		[(targetSpan canIntegrate: textElement) willReturn: false.
		targetSpan insertTextStartedWith: textElement at:  5]
	] runWithMocks 
]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionIntoAnotherSpanWhenItIsLastSpan [

	self mockNeighbours.
	[ :targetSpan |
		[ textElement insertInto: targetSpan at: 5]
			should strictly satisfy: 
		[(targetSpan canIntegrate: textElement) willReturn: true. 
		targetSpan insertSimpleString: textElement contents at: 5.
		nextElement isTextEnd willReturn: true]
	] runWithMocks 
]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionNewSpansWhenSelfIsEmpty [

	| insertedFirstElement insertedLastElement |
	insertedFirstElement := TwyCharactersSpan with: '1234'.
	insertedLastElement := TwyCharactersSpan with: '567'.
	insertedFirstElement next: insertedLastElement.
	
	textElement contents: ''.
	textElement insertElement: insertedFirstElement.
	
	previousElement next should be: insertedFirstElement.
	insertedFirstElement next should be: insertedLastElement.
	insertedLastElement next should be: nextElement
]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionNewSpansWhenSelfIsEmptyShouldAnnounceItDeletedAfterInsertionChange [
	| insertedFirstElement insertedLastElement deletion |
	insertedFirstElement := TwyCharactersSpan with: '1234'.
	insertedLastElement := TwyCharactersSpan with: '567'.
	insertedFirstElement next: insertedLastElement.
	textElement contents: ''.
	textElement insertElement: insertedFirstElement.
	textChanges should haveSize: 2.
	(deletion := textChanges last) should
		beInstanceOf: TwyElementsGroupRemoved.
	deletion text should be: text.
	deletion firstRemovedElement should be: textElement
]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionSimpleEmptyStringShouldDoNothing [

	textElement contents: '123456'.
	
	textElement insertSimpleString: '' at: 3.
		
	textChanges should be isEmpty
		
]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionSimpleStringShouldAnnounceChange [
	| change |
	textElement contents: '123456'.
	textElement insertSimpleString: 'test' at: 3.
	textChanges should haveSize: 1.
	(change := textChanges first) should
		beInstanceOf: TwyCharactersSpanIncreased.
	change text should be: text.
	change element should be: textElement.
	change initialContents should equal: '123456'.
	change insertionPosition should be: 3.
	change insertedCharacters should equal: 'test'
]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionSingleLineString [

	textElement contents: '123456'.
	
	textElement insertSimpleString: 'test' at: 3.
		
	textElement contents should equal: '123test456'
]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionTextAtEndPosition [

	| insertedFirstSpan insertedLastSpan |
	insertedFirstSpan := TwySpan new.
	insertedLastSpan := TwySpan new.
	insertedFirstSpan next: insertedLastSpan.
	
	textElement insertTextStartedWith: insertedFirstSpan at: textElement length.
	
	textElement next should be: insertedFirstSpan.
	insertedLastSpan next should be: nextElement
]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionTextAtMiddlePosition [

	| splittedSpan insertedFirstSpan insertedLastSpan |
	insertedFirstSpan := TwySpan new.
	insertedLastSpan := TwySpan new.
	insertedFirstSpan next: insertedLastSpan.
	textElement contents: '1234567'.
	textElement insertTextStartedWith: insertedFirstSpan at: 3.
	
	textElement contents should equal: '123'.
	textElement next should be: insertedFirstSpan.
	splittedSpan := insertedLastSpan next.
	splittedSpan contents should equal: '4567'.
	splittedSpan next should be: nextElement

]

{ #category : #tests }
TwyCharactersSpanTests >> testInsertionTextAtStartPosition [

	self mockNeighbours.
	[ :insertedSpan  |
		[ textElement insertTextStartedWith: insertedSpan at: 0]
			should strictly satisfy: 
		[previousElement insertElement: insertedSpan]
	] runWithMocks 
]

{ #category : #tests }
TwyCharactersSpanTests >> testIsEmptyWhenEmptyContents [

	textElement contents: ''.
	
	textElement isEmpty should be: true
]

{ #category : #tests }
TwyCharactersSpanTests >> testIsEndPosition [

	textElement contents: '12345'.
	
	(textElement isEndPosition: 0) should be: false.
	(textElement isEndPosition: 5) should be: true
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testIsNotEmptyWhenNotEmptyContents [

	textElement contents: '1234'.
	
	textElement isEmpty should be: false
]

{ #category : #tests }
TwyCharactersSpanTests >> testItemAtAbsentPosition [

	| actual |
	textElement contents: '12345'.
	
	actual := textElement itemAt: 6 ifAbsent: [ #result ].
	actual should be: #result
]

{ #category : #tests }
TwyCharactersSpanTests >> testItemAtExistedPosition [

	| actual |
	textElement contents: '12345'.
	
	actual := textElement itemAt: 2 ifAbsent: [ self error: 'should bot happen' ].
	actual should equal: $2
]

{ #category : #tests }
TwyCharactersSpanTests >> testItemAtZeroPosition [

	| actual |
	textElement contents: '12345'.
	
	actual := textElement itemAt: 0 ifAbsent: [ #result ].
	actual should be: #result
]

{ #category : #tests }
TwyCharactersSpanTests >> testLength [

	textElement contents: '12345'.
	
	textElement length should equal: 5
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideContentsAfterStartIndex [

	| result |
	textElement contents: '1234567'.
	
	result := textElement overrideContentsAfter: 4 with: 'abcRest'.
	
	textElement contents should equal: '1234abc'.
	
	result newString should be: 'abcRest'.
	result change should be: textChanges first
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideContentsAfterStartIndexShouldTriggerChange [
	textElement contents: '1234567'.
	textElement overrideContentsAfter: 4 with: 'abcRest'.
	textChanges should haveSize: 1.
	textChanges first should beInstanceOf: TwySpanContentsOverridden.
	textChanges first text should be: text.
	textChanges first overrideStart should be: 4.
	textChanges first overrideEnd should be: 7.
	textChanges first initialContents should equal: '1234567'
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideContentsBeforeEndIndex [

	| result |
	textElement contents: '1234567'.
	
	result := textElement overrideContentsBefore: 3 with: 'abcRest'.
	
	textElement contents should equal: 'abc4567'.
	
	result newString should be: 'abcRest'.
	result change should be: textChanges first
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideContentsBeforeEndIndexShouldTriggerChange [
	textElement contents: '1234567'.
	textElement overrideContentsBefore: 3 with: 'abcRest'.
	textChanges should haveSize: 1.
	textChanges first should beInstanceOf: TwySpanContentsOverridden.
	textChanges first text should be: text.
	textChanges first overrideStart should be: 0.
	textChanges first overrideEnd should be: 3.
	textChanges first initialContents should equal: '1234567'
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideContentsBeforeEndIndexWhenGivenStringTooSmall [

	| result |
	textElement contents: '1234567'.
	
	result := textElement overrideContentsBefore: 3 with: 'ab'.
	
	textElement contents should equal: 'ab34567'.
	
	result newString should be: 'ab'.
	result change should be: textChanges first
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideContentsBeforeEndIndexWhenGivenStringTooSmallShouldTriggerChange [
	textElement contents: '1234567'.
	textElement overrideContentsBefore: 3 with: 'ab'.
	textChanges should haveSize: 1.
	textChanges first should beInstanceOf: TwySpanContentsOverridden.
	textChanges first text should be: text.
	textChanges first overrideStart should be: 0.
	textChanges first overrideEnd should be: 2.
	textChanges first initialContents should equal: '1234567'
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideFullContentsShouldTriggerChangeEvent [
	textElement contents: '1234567'.
	textElement overrideFullContentsWith: 'abc1234rest'.
	textChanges should haveSize: 1.
	textChanges first should beInstanceOf: TwySpanContentsOverridden.
	textChanges first text should be: text.
	textChanges first overrideStart should be: 0.
	textChanges first overrideEnd should be: 7.
	textChanges first initialContents should equal: '1234567'
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideFullContentsWithBigString [

	| result |
	textElement contents: '1234567'.
	
	result := textElement overrideFullContentsWith: 'abc1234rest'.
	
	textElement contents should equal: 'abc1234'.
	
	result newString should be: 'abc1234rest'.
	result change should be: textChanges first
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideFullContentsWithSmallString [

	| result |
	textElement contents: '1234567'.
	
	result := textElement overrideFullContentsWith: 'abc'.
	
	textElement contents should equal: 'abc4567'.
	
	result newString should be: 'abc'.
	result change should be: textChanges first
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideIntervalShouldTriggerChange [
	textElement contents: '1234567'.
	textElement overrideContentsFrom: 2 to: 5 with: 'abcRest'.
	textChanges should haveSize: 1.
	textChanges first should beInstanceOf: TwySpanContentsOverridden.
	textChanges first text should be: text.
	textChanges first overrideStart should be: 2.
	textChanges first overrideEnd should be: 5.
	textChanges first initialContents should equal: '1234567'
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideIntervalWhichHasToBigStartIndex [

	| result |
	textElement contents: '1234567'.
	
	result := textElement overrideContentsFrom: 7 to: 10 with: 'abc'.
	
	textElement contents should equal: '1234567'.
	
	result newString should be: 'abc'.
	result change should be: nil.
	textChanges should be isEmpty
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideIntervalWithBigString [

	| result |
	textElement contents: '1234567'.
	
	result := textElement overrideContentsFrom: 2 to: 5 with: 'abcRest'.
	
	textElement contents should equal: '12abc67'.
	
	result newString should be: 'abcRest'.
	result change should be: textChanges first
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideIntervalWithSmallString [

	| result |
	textElement contents: '1234567'.
	
	result := textElement overrideContentsFrom: 2 to: 5 with: 'ab'.
	
	textElement contents should equal: '12ab567'.
	
	result newString should be: 'ab'.
	result change should be: textChanges first
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testOverrideIntervalWithStringWhenEndIndexIsTooBig [

	| result |
	textElement contents: '1234567'.
	
	result := textElement overrideContentsFrom: 4 to: 10 with: 'abcRest'.
	
	textElement contents should equal: '1234abc'.
	
	result newString should be: 'abcRest'.
	result change should be: textChanges first
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testShouldBeSpan [

	textElement isSpan should be: true
]

{ #category : #tests }
TwyCharactersSpanTests >> testSplittingAtEndOfSpan [

	textElement contents: '1234567'.
	
	textElement splitAt: 7.
	
	textElement contents should equal: '1234567'.
	
	self assertNeighboursNotChanged 
]

{ #category : #tests }
TwyCharactersSpanTests >> testSplittingAtEndOfSpanShouldAnnounceNothing [

	textElement contents: '1234567'.
	
	textElement splitAt: 7.
	
	textChanges should be isEmpty
]

{ #category : #tests }
TwyCharactersSpanTests >> testSplittingAtMiddleOfSpan [
	| splittedSpan |
	textElement contents: '1234567'.
	textElement splitAt: 3.
	textElement contents should equal: '123'.
	splittedSpan := textElement next.
	splittedSpan should beInstanceOf: TwyCharactersSpan.
	splittedSpan should not be: nextElement.
	splittedSpan next should be: nextElement.
	splittedSpan previous should be: textElement.
	splittedSpan contents should equal: '4567'.
	nextElement previous should be: splittedSpan.
	splittedSpan order should be > textElement order.
	splittedSpan order should be < nextElement order
]

{ #category : #tests }
TwyCharactersSpanTests >> testSplittingAtMiddleOfSpanShouldAnnounceDecreasingChange [
	| change |
	textElement contents: '1234567'.
	textElement splitAt: 3.
	(change := textChanges second) should
		beInstanceOf: TwyCharactersSpanDecreased.
	change text should be: text.
	change element should be: textElement.
	change initialContents should equal: '1234567'.
	change deletionStart should be: 3.
	change deletionEnd should be: 7
]

{ #category : #tests }
TwyCharactersSpanTests >> testSplittingAtMiddleOfSpanShouldAnnounceSplittingChange [
	| splitting |
	textElement contents: '1234567'.
	textElement splitAt: 3.
	(splitting := textChanges first) should
		beInstanceOf: TwyCharactersSpanSplitted.
	splitting text should be: text.
	splitting splittedSpan should be: textElement.
	splitting splitPosition should be: 3.
	splitting separatedSpan should be: textElement next.
	splitting elementAfterInsertion should be: nextElement
]

{ #category : #tests }
TwyCharactersSpanTests >> testSplittingAtMiddleOfSpanShouldAnnounceTwoChanges [
	textElement contents: '1234567'.
	textElement splitAt: 3.
	textChanges should haveSize: 2
]

{ #category : #tests }
TwyCharactersSpanTests >> testSplittingAtOutOfBoundsIndex [

	textElement contents: '1234567'.
	
	[textElement splitAt: 70] should fail.
	
	textElement contents should equal: '1234567'.
	
	self assertNeighboursNotChanged 
]

{ #category : #tests }
TwyCharactersSpanTests >> testSplittingAtStartOfSpan [

	textElement contents: '1234567'.
	
	textElement splitAt: 0.
	
	textElement contents should equal: '1234567'.
	
	self assertNeighboursNotChanged 
	
]

{ #category : #tests }
TwyCharactersSpanTests >> testSplittingAtStartOfSpanShouldAnnounceNothing [

	textElement contents: '1234567'.
	
	textElement splitAt: 0.
	
	textChanges should be isEmpty	
]

{ #category : #tests }
TwyCharactersSpanTests >> testSplittingSpanShouldCopyOriginalAttributes [

	| splittedSpan |
	textElement contents: '1234567'.
	textElement applyAttribute: (TxForeColorAttribute with: Color red).
	
	textElement splitAt: 3.
	
	textElement contents should equal: '123'.
	
	splittedSpan := textElement next.
	splittedSpan attributes should not be: textElement attributes.
	(splittedSpan getAttribute: TxForeColorAttribute) should equal: Color red
]

{ #category : #running }
TwyCharactersSpanTests >> textElementClass [ 
	^TwyCharactersSpan
]
