Class {
	#name : #TwyElementTests,
	#superclass : #TwyElementTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwyElementTests >> testApplyingAttribute [

	| actual attr |
	
	attr := TwyFontAttribute with: #newFont.
	
	textElement applyAttribute: attr.
	
	actual := textElement getAttribute: TwyFontAttribute.
	
	actual should be: #newFont	
]

{ #category : #tests }
TwyElementTests >> testApplyingAttributeShouldAnnounceChange [
	| change oldAttr newAttr |
	oldAttr := TwyFontAttribute with: #oldFont.
	textElement applyAttribute: oldAttr.
	textChanges removeAll.
	newAttr := TwyFontAttribute with: #newFont.
	textElement applyAttribute: newAttr.
	textChanges should haveSize: 1.
	change := textChanges first.
	change should beInstanceOf: TwyElementAttributeChanged.
	change text should be: text.
	change initialAttribute should be: oldAttr.
	change newAttribute should be: newAttr.
	change element should be: textElement
]

{ #category : #tests }
TwyElementTests >> testApplyingAttributeWithExistedValueShouldNotAnnounceChange [

	| oldAttr newAttr |
		
	oldAttr := TwyFontAttribute with: #newFont.
	textElement applyAttribute: oldAttr.
	textChanges removeAll.
	
	newAttr := TwyFontAttribute with: #newFont.
	textElement applyAttribute: newAttr.	
	
	textChanges should be isEmpty
]

{ #category : #tests }
TwyElementTests >> testBackwardDo [

	| items prevPrevElement |
	prevPrevElement := TwyElement new.
	previousElement previous: prevPrevElement.
	
	items := OrderedCollection new.
	
	nextElement backwardDo: [ :each |  items add: each] while: [ :each |  each ~= prevPrevElement].
	
	items should equal: { textElement. previousElement }	
	
]

{ #category : #tests }
TwyElementTests >> testBackwardDoWhenAllElementsSatisfiedWhileBlock [

	| items prevPrevElement |
	prevPrevElement := Mock new.
	prevPrevElement stub isTextStart willReturn: true.
	previousElement basicPrevious: prevPrevElement.
	
	items := OrderedCollection new.
	
	nextElement backwardDo: [ :each |  items add: each] while: [ :each | true].
	
	items should equal: { textElement. previousElement }	
	
]

{ #category : #tests }
TwyElementTests >> testBackwardDoWhenNoElementsSatisfiedWhileBlock [

	| items |
	items := OrderedCollection new.
	
	nextElement backwardDo: [ :each |  items add: each] while: [ :each | false].
	
	items should be isEmpty
	
]

{ #category : #tests }
TwyElementTests >> testBackwardDoWithYourself [

	[:next |
		textElement basicNext: next.
		[ textElement withYourselfBackwardDo: #action ]
			should lenient satisfy: 
		[ next backwardDo: #action ]
	 ] runWithMocks
]

{ #category : #tests }
TwyElementTests >> testCheckingAttributeExistence [

	| attributes |
	attributes := Mock new.
	(attributes stub includes: #attributeClass) willReturn: #result.
	
	textElement attributes: attributes.
	
	(textElement hasAttribute: #attributeClass) should be: #result
]

{ #category : #tests }
TwyElementTests >> testCopyShouldHasAttributesCopy [

	| copy attributes |
	attributes := Mock new.
	attributes stub copy willReturn: #attributesCopy.
	
	textElement attributes: attributes.
	
	copy := textElement copy.
		
	copy attributes should be: #attributesCopy
	
]

{ #category : #tests }
TwyElementTests >> testCopyShouldResetNeighbours [

	| copy |
	copy := textElement copy.
		
	copy previous should be: nil.
	copy next should be: nil	
	
]

{ #category : #tests }
TwyElementTests >> testCopyShouldResetText [

	| copy |
	copy := textElement copy.
		
	copy text should be: nil	
	
]

{ #category : #tests }
TwyElementTests >> testDelete [

	textElement delete.
		
	previousElement next should be: nextElement.
	nextElement previous should be: previousElement 
		
	
]

{ #category : #tests }
TwyElementTests >> testDeleteShouldAnnounceChange [
	| change |
	textElement delete.
	textChanges should haveSize: 1.
	change := textChanges first.
	change should beInstanceOf: TwyElementsGroupRemoved.
	change text should be: text.
	change firstRemovedElement should be: textElement.
	change elementBeforeRemovedGroup should be: textElement previous.
	change elementAfterRemovedGroup should be: textElement next
]

{ #category : #tests }
TwyElementTests >> testEnsureAnySpanWhenNextIsNotSpan [
	| emptySpan |
	textElement ensureAnySpan.
	emptySpan := textElement next.
	emptySpan should beInstanceOf: TwyCharactersSpan.
	emptySpan contents should be isEmpty.
	emptySpan next should be: nextElement.
	emptySpan previous should be: textElement.
	emptySpan order should be > textElement order.
	emptySpan order should be < nextElement order.
	textChanges should be isEmpty
]

{ #category : #tests }
TwyElementTests >> testEnsureAnySpanWhenNextIsSpan [

	nextElement := TwySpan new.
	textElement next: nextElement.
	
	textElement ensureAnySpan.
	
	self assertNeighboursNotChanged.
	textChanges should be isEmpty
]

{ #category : #tests }
TwyElementTests >> testEnumeratingAttributes [

	| attr1 attr2 result |
	
	attr1 := TwyFontAttribute with: #newFont.
	attr2 := TwyForeColorAttribute with: #newColor.
	
	textElement applyAttribute: attr1; applyAttribute: attr2.
	
	result := OrderedCollection new.
	
	textElement attributesDo: [ :each | result add: each  ].
	
	result should equal: { attr1. attr2 }
]

{ #category : #tests }
TwyElementTests >> testFindLiveElementBackwardWhenCurrentIsDeleted [

	| actual |
	self mockNeighbours.
	nextElement stub previous willReturn: #anotherElement.
	previousElement stub findLiveElementBackward willReturn: #liveElement.
	
	actual := textElement findLiveElementBackward.
	
	actual should be: #liveElement
]

{ #category : #tests }
TwyElementTests >> testFindLiveElementBackwardWhenCurrentIsNotDeleted [

	| actual |
	actual := textElement findLiveElementBackward.
	
	actual should be: textElement
]

{ #category : #tests }
TwyElementTests >> testFindLiveElementForwardWhenCurrentIsDeleted [

	| actual |
	self mockNeighbours.
	nextElement stub previous willReturn: #anotherElement.
	nextElement stub findLiveElementForward willReturn: #liveElement.
	
	actual := textElement findLiveElementForward.
	
	actual should be: #liveElement
]

{ #category : #tests }
TwyElementTests >> testFindLiveElementForwardWhenCurrentIsNotDeleted [

	| actual |
	actual := textElement findLiveElementForward.
	
	actual should be: textElement
]

{ #category : #tests }
TwyElementTests >> testForwardDo [

	| items nextNextElement |
	nextNextElement := TwyElement new.
	nextElement next: nextNextElement.
	
	items := OrderedCollection new.
	
	previousElement forwardDo: [ :each |  items add: each] while: [ :each |  each ~= nextNextElement].
	
	items should equal: { textElement. nextElement }	
	
]

{ #category : #tests }
TwyElementTests >> testForwardDoWhenAllElementsSatisfiedWhileBlock [

	| items nextNextElement |
	nextNextElement := Mock new.
	nextNextElement stub isTextEnd willReturn: true.
	nextElement basicNext: nextNextElement.
	
	items := OrderedCollection new.
	
	previousElement forwardDo: [ :each |  items add: each] while: [ :each | true].
	
	items should equal: { textElement. nextElement }	
	
]

{ #category : #tests }
TwyElementTests >> testForwardDoWhenNoElementsSatisfiedWhileBlock [

	| items |
	
	items := OrderedCollection new.
	
	previousElement forwardDo: [ :each |  items add: each] while: [ :each | false].
	
	items should be isEmpty
	
]

{ #category : #tests }
TwyElementTests >> testForwardDoWithYourself [

	[:previous |
		textElement basicPrevious: previous.
		[ textElement withYourselfForwardDo: #action ]
			should lenient satisfy: 
		[ previous forwardDo: #action while: [:arg | (arg value: nil) = true] ]
	 ] runWithMocks
]

{ #category : #tests }
TwyElementTests >> testGettingAbsentAttribute [

	| actual |
	
	(text stub getAttribute: TwyFontAttribute) willReturn: #defaultValue.
	
	actual := textElement getAttribute: TwyFontAttribute.
	
	actual should be: #defaultValue
]

{ #category : #tests }
TwyElementTests >> testGettingAbsentAttributeBySpecialAbsentHandler [

	| actual |
	
	actual := textElement getAttribute: TwyFontAttribute ifAbsent: [#result].
	
	actual should be: #result
]

{ #category : #tests }
TwyElementTests >> testGettingExistedAttribute [

	| actual |
	
	textElement attributes add: TwyFontAttribute with: #font.

	actual := textElement getAttribute: TwyFontAttribute.
	
	actual should be: #font
	
]

{ #category : #tests }
TwyElementTests >> testGettingNextSpanWhenNextElementIsNotSpan [

	| actual |
	self mockNeighbours.
	
	[ 
		[ actual := textElement nextSpanIfAbsent: #block ]
			should strictly satisfy: 
		[ nextElement isSpan willReturn: false.
		(nextElement nextSpanIfAbsent: #block) willReturn: #span].
	
		actual should be: #span
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementTests >> testGettingNextSpanWhenNextElementIsSpan [

	| actual |
	self mockNeighbours.
	
	[ 
		[ actual := textElement nextSpanIfAbsent: #block ]
			should strictly satisfy: 
		[ nextElement isSpan willReturn: true].
	
		actual should be: nextElement
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementTests >> testGettingPreviousSpanWhenNextElementIsNotSpan [

	| actual |
	self mockNeighbours.
	
	[ 
		[ actual := textElement previousSpanIfAbsent: #block ]
			should strictly satisfy: 
		[ previousElement isSpan willReturn: false.
		(previousElement previousSpanIfAbsent: #block) willReturn: #span].
	
		actual should be: #span
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementTests >> testGettingPreviousSpanWhenNextElementIsSpan [

	| actual |
	self mockNeighbours.
	
	[ 
		[ actual := textElement previousSpanIfAbsent: #block ]
			should strictly satisfy: 
		[ previousElement isSpan willReturn: true].
	
		actual should be: previousElement
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementTests >> testHasAttributesByDefault [
	textElement attributes should beInstanceOf: TwyAttributes
]

{ #category : #tests }
TwyElementTests >> testHasNotSpecificAttributesWhenAttributesEmpty [

	[:attributes |
		textElement attributes: attributes.

		[textElement hasSpecificAttributes should be: false]
			should strictly satisfy: 
		[ attributes isEmpty willReturn: true]
	
	] runWithMocks 
]

{ #category : #tests }
TwyElementTests >> testHasSpecificAttributesWhenAttributesNotEmpty [

	[:attributes |
		textElement attributes: attributes.

		[textElement hasSpecificAttributes should be: true]
			should strictly satisfy: 
		[ attributes isEmpty willReturn: false]
	
	] runWithMocks 
]

{ #category : #tests }
TwyElementTests >> testImportAttributesFromAnotherElement [

	|   font color anotherElement |
	
	font := TwyFontAttribute with: #newFont.
	color := TwyForeColorAttribute with: #newColor.
	
	anotherElement := TwyElement of: text.	
	anotherElement applyAttribute: font; applyAttribute: color.
		
	textElement importAttributesFrom: anotherElement.
	
	(textElement getAttribute: TwyFontAttribute) should be: #newFont.
	(textElement getAttribute: TwyForeColorAttribute) should be: #newColor.	

]

{ #category : #tests }
TwyElementTests >> testImportAttributesFromAnotherElementWhenExceptionSpecified [

	|   font color anotherElement |
	
	font := TwyFontAttribute with: #newFont.
	color := TwyForeColorAttribute with: #newColor.
	
	anotherElement := TwyElement of: text.	
	anotherElement applyAttribute: font; applyAttribute: color.
		
	textElement importAttributesFrom: anotherElement excepting: {TwyFontAttribute}.
	
	(textElement getAttribute: TwyForeColorAttribute) should be: #newColor.	
	(textElement hasAttribute: TwyFontAttribute) should be: false.
	

]

{ #category : #tests }
TwyElementTests >> testImportAttributesShouldApplyItasCopies [

	|   font  anotherElement |
	
	font := TwyFontAttribute with: #newFont.
	
	anotherElement := TwyElement of: text.	
	anotherElement applyAttribute: font.
		
	textElement importAttributesFrom: anotherElement.
	
	font value: #newFontForOriginalSpan.
	
	(textElement getAttribute: TwyFontAttribute) should be: #newFont.	

]

{ #category : #tests }
TwyElementTests >> testInsertionEmptySpan [
	| emptySpan |
	textElement insertEmptySpan.
	emptySpan := textElement next.
	emptySpan should beInstanceOf: TwyCharactersSpan.
	emptySpan contents should be isEmpty.
	emptySpan next should be: nextElement.
	emptySpan previous should be: textElement.
	emptySpan order should be > textElement order.
	emptySpan order should be < nextElement order
]

{ #category : #tests }
TwyElementTests >> testInsertionEmptySpanShouldAnnounceChange [
	| insertion |
	textElement insertEmptySpan.
	textChanges should haveSize: 1.
	(insertion := textChanges first) should
		beInstanceOf: TwyElementInserted.
	insertion text should be: text.
	insertion newElement should be: textElement next.
	insertion elementBeforeInsertion should be: textElement.
	insertion elementAfterInsertion should be: nextElement
]

{ #category : #tests }
TwyElementTests >> testInsertionNewElement [

	| insertedFirstElement insertedLastElement |
	insertedFirstElement := TwyCharactersSpan new.
	insertedLastElement := TwyElement new.
	insertedFirstElement next: insertedLastElement.
	
	textElement insertElement: insertedFirstElement.

	textElement next should be: insertedFirstElement.
	insertedFirstElement previous should be: textElement.
	insertedLastElement next should be: nextElement.
	nextElement previous should be: insertedLastElement.
	insertedFirstElement text should be: text.
	insertedLastElement text should be: text.
	textElement order should be < insertedFirstElement order.
	insertedFirstElement order should be < insertedLastElement order.
	insertedLastElement order should be < nextElement order.
]

{ #category : #tests }
TwyElementTests >> testInsertionNewElementShouldAnnounceInsertionEventByYourself [
	| insertedElement insertion |
	insertedElement := TwyCharactersSpan new.
	textElement insertElement: insertedElement.
	textChanges should haveSize: 1.
	(insertion := textChanges first) should
		beInstanceOf: TwyElementInserted.
	insertion text should be: text.
	insertion newElement should be: insertedElement.
	insertion elementBeforeInsertion should be: textElement.
	insertion elementAfterInsertion should be: nextElement
]

{ #category : #tests }
TwyElementTests >> testInsertionNewElementShouldAnnounceSingleChangeByElement [
	| insertedElement |
	insertedElement := TwyElement new.
	textElement insertElement: insertedElement.
	textChanges should haveSize: 1
]

{ #category : #tests }
TwyElementTests >> testInsertionNewElementShouldAnnounceSingleChangeByText [
	| insertedElement |
	insertedElement := TwyElement new.
	textElement insertElement: insertedElement.
	textChanges should haveSize: 1
]

{ #category : #tests }
TwyElementTests >> testInsertionNewElementWhenEmptySpanRequired [
	| insertedElement insertion emptySpan |
	insertedElement := TwyElement new.
	textElement insertElement: insertedElement.
	emptySpan := textElement next.
	emptySpan should beInstanceOf: TwyCharactersSpan.
	emptySpan contents should be isEmpty.
	emptySpan next should be: insertedElement.
	(insertion := textChanges first) should
		beInstanceOf: TwyElementInserted.
	insertion text should be: text.
	insertion newElement should be: emptySpan.
	insertion elementBeforeInsertion should be: textElement.
	insertion elementAfterInsertion should be: nextElement
]

{ #category : #tests }
TwyElementTests >> testInsertionNewSpansBeforeEmptySpan [

	| insertedFirstElement insertedLastElement beforeSpan |
	insertedFirstElement := TwyCharactersSpan with: '1234'.
	insertedLastElement := TwyCharactersSpan with: '567'.
	insertedFirstElement next: insertedLastElement.
	beforeSpan := TwyCharactersSpan of: text with: ''.
	beforeSpan next: nextElement.
	textElement next: beforeSpan.
	
	textElement insertElement: insertedFirstElement.
	
	textElement next should be: insertedFirstElement.
	insertedFirstElement next should be: insertedLastElement.
	insertedLastElement next should be: nextElement
]

{ #category : #tests }
TwyElementTests >> testInsertionNewSpansBeforeEmptySpanShouldAnnounceItDeletedAfterInsertionChange [
	| insertedFirstElement insertedLastElement beforeSpan deletion |
	insertedFirstElement := TwyCharactersSpan with: '1234'.
	insertedLastElement := TwyCharactersSpan with: '567'.
	insertedFirstElement next: insertedLastElement.
	beforeSpan := TwyCharactersSpan of: text with: ''.
	beforeSpan next: nextElement.
	textElement next: beforeSpan.
	textElement insertElement: insertedFirstElement.
	textChanges should haveSize: 2.
	(deletion := textChanges last) should
		beInstanceOf: TwyElementsGroupRemoved.
	deletion text should be: text.
	deletion firstRemovedElement should be: beforeSpan
]

{ #category : #tests }
TwyElementTests >> testInsertionNewSpansShouldAnnounceOnlyActualInsertion [
	| insertedFirstElement insertedLastElement insertion |
	insertedFirstElement := TwyCharactersSpan with: '1234'.
	insertedLastElement := TwyCharactersSpan with: '567'.
	insertedFirstElement next: insertedLastElement.
	textElement insertElement: insertedFirstElement.
	textChanges should haveSize: 1.
	(insertion := textChanges first) should
		beInstanceOf: TwyElementInserted.
	insertion text should be: text.
	insertion newElement should be: insertedFirstElement.
	insertion elementBeforeInsertion should be: textElement.
	insertion elementAfterInsertion should be: nextElement
]

{ #category : #tests }
TwyElementTests >> testInsertionNewSpansWhenFirstIsEmpty [

	| insertedFirstElement insertedLastElement |
	insertedFirstElement := TwyCharactersSpan with: ''.
	insertedLastElement := TwyCharactersSpan with: '1234'.
	insertedFirstElement next: insertedLastElement.
	
	textElement insertElement: insertedFirstElement.
	
	textElement next should be: insertedLastElement.
	insertedLastElement next should be: nextElement
]

{ #category : #tests }
TwyElementTests >> testInsertionNewSpansWhenFirstIsEmptyShouldAnnounceItDeletedAfterInsertionChange [
	| insertedFirstElement insertedLastElement deletion |
	insertedFirstElement := TwyCharactersSpan with: ''.
	insertedLastElement := TwyCharactersSpan with: '1234'.
	insertedFirstElement next: insertedLastElement.
	textElement insertElement: insertedFirstElement.
	textChanges should haveSize: 2.
	(deletion := textChanges last) should
		beInstanceOf: TwyElementsGroupRemoved.
	deletion text should be: text.
	deletion firstRemovedElement should be: insertedFirstElement
]

{ #category : #tests }
TwyElementTests >> testInsertionNewSpansWhenLastIsEmpty [

	| insertedFirstElement insertedLastElement |
	insertedFirstElement := TwyCharactersSpan with: '1234'.
	insertedLastElement := TwyCharactersSpan with: ''.
	insertedFirstElement next: insertedLastElement.
	
	textElement insertElement: insertedFirstElement.
	
	textElement next should be: insertedFirstElement.
	insertedFirstElement next should be: nextElement
]

{ #category : #tests }
TwyElementTests >> testInsertionNewSpansWhenLastIsEmptyShouldAnnounceItDeletedAfterInsertionChange [
	| insertedFirstElement insertedLastElement deletion |
	insertedFirstElement := TwyCharactersSpan with: '1234'.
	insertedLastElement := TwyCharactersSpan with: ''.
	insertedFirstElement next: insertedLastElement.
	textElement insertElement: insertedFirstElement.
	textChanges should haveSize: 2.
	(deletion := textChanges last) should
		beInstanceOf: TwyElementsGroupRemoved.
	deletion text should be: text.
	deletion firstRemovedElement should be: insertedLastElement
]

{ #category : #tests }
TwyElementTests >> testInsertionNewSpansWhenNoEmptyNeighboursExists [

	| insertedFirstElement insertedLastElement |
	insertedFirstElement := TwyCharactersSpan with: '1234'.
	insertedLastElement := TwyCharactersSpan with: '567'.
	insertedFirstElement next: insertedLastElement.
	
	textElement insertElement: insertedFirstElement.
	
	textElement next should be: insertedFirstElement.
	nextElement previous should be: insertedLastElement
]

{ #category : #tests }
TwyElementTests >> testIsAfterAnotherSpan [

	previousElement order: 1.
	nextElement order: 2.
		
	(previousElement isAfter: nextElement) should be: false.
	(nextElement isAfter: previousElement) should be: true.
]

{ #category : #tests }
TwyElementTests >> testIsAttachedToNextElement [

	(textElement isAttachedTo: nextElement) should be: true
]

{ #category : #tests }
TwyElementTests >> testIsAttachedToPreviousElement [

	(textElement isAttachedTo: previousElement) should be: true
]

{ #category : #tests }
TwyElementTests >> testIsBeforeAnotherSpan [

	previousElement order: 1.
	nextElement order: 2.
		
	(previousElement isBefore: nextElement) should be: true.
	(nextElement isBefore: previousElement) should be: false.
]

{ #category : #tests }
TwyElementTests >> testIsDeletedWhenNextHasDifferentPrevious [

	nextElement previous: TwyElement new.
	
	textElement isDeleted should be: true
]

{ #category : #tests }
TwyElementTests >> testIsNotAttachedToNotNextAndNotPreviousElement [

	(textElement isAttachedTo: #someElement) should be: false
]

{ #category : #tests }
TwyElementTests >> testIsNotDeletedWhenNextHasItAsPrevious [

	nextElement previous: textElement.
	
	textElement isDeleted should be: false
]

{ #category : #tests }
TwyElementTests >> testNextShouldHasCurrentAsPrevious [

	nextElement previous should be: textElement
]

{ #category : #tests }
TwyElementTests >> testNotRequiredSpanBeforeNextElementWhenNextIsSpan [

	textElement next: TwySpan new.
	
	textElement requiredSpanBeforeNextElement should be: false

]

{ #category : #tests }
TwyElementTests >> testPreviousShouldHasCurrentAsNext [

	previousElement next should be: textElement
]

{ #category : #tests }
TwyElementTests >> testRemoveAbsentAttributeShouldAnnounceNothing [

	textElement removeAttribute: TwyFontAttribute.	
	
	textChanges should be isEmpty
]

{ #category : #tests }
TwyElementTests >> testRemoveAttribute [

	| attr |
	
	attr := TwyFontAttribute with: #newFont.
	textElement applyAttribute: attr.

	textElement removeAttribute: TwyFontAttribute.
	
	(textElement hasAttribute: TwyFontAttribute) should be: false
]

{ #category : #tests }
TwyElementTests >> testRemoveAttributeShouldAnnounceChange [
	| change attr |
	attr := TwyFontAttribute with: #oldFont.
	textElement applyAttribute: attr.
	textChanges removeAll.
	textElement removeAttribute: TwyFontAttribute.
	textChanges should haveSize: 1.
	change := textChanges first.
	change should beInstanceOf: TwyElementAttributeChanged.
	change text should be: text.
	change initialAttribute should be: attr.
	change newAttribute should be: nil.
	change element should be: textElement
]

{ #category : #tests }
TwyElementTests >> testRequiredSpanBeforeNextElementWhenNextIsNotSpan [

	textElement requiredSpanBeforeNextElement should be: true

]

{ #category : #tests }
TwyElementTests >> testRequiredSpanBeforeNextElementWhenNextIsNotSpanButPreviousIsSpan [

	textElement previous: TwySpan new.
	
	textElement requiredSpanBeforeNextElement should be: true

]

{ #category : #running }
TwyElementTests >> textElementClass [
	^TwyElement
]
