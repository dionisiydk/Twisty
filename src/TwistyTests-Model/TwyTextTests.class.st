Class {
	#name : #TwyTextTests,
	#superclass : #TestCase,
	#instVars : [
		'text'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyTextTests >> setUp [ 	
	super setUp.
	
	text := TwyText new
]

{ #category : #tests }
TwyTextTests >> testApplyingAttribute [
	
	| actual |
	text applyDefaultAttribute: (TwyFontAttribute with: #font).

	actual := text defaultAttributes valueOf: TwyFontAttribute ifAbsent: [nil].	
	actual should be: #font
	
]

{ #category : #tests }
TwyTextTests >> testApplyingAttributeShouldAnnounceChange [
	| change oldAttr newAttr textChanges |
	oldAttr := TwyFontAttribute with: #oldFont.
	text applyDefaultAttribute: oldAttr.
	textChanges := OrderedCollection new.
	text when: TwyTextStateChanged do: [ :ann | textChanges add: ann ].
	newAttr := TwyFontAttribute with: #newFont.
	text applyDefaultAttribute: newAttr.
	textChanges should haveSize: 1.
	change := textChanges first.
	change should beInstanceOf: TwyDefaultAttributeChanged.
	change text should be: text.
	change initialAttribute should be: oldAttr.
	change newAttribute should be: newAttr
]

{ #category : #tests }
TwyTextTests >> testConvertingToString [

	| string actual |
	string := ('line1', String cr, 'line2', String tab, 'line2end').
	text := string asTwyText.

	actual := text asString.
		
	actual should equal: string.
	text validateSpansOrder
]

{ #category : #tests }
TwyTextTests >> testConvertingToTextModel [

	text asTwyText should be: text
]

{ #category : #tests }
TwyTextTests >> testCopyHasNewElements [
	| originalElements textCopy elementsCopy |
	text := ('line1' , String cr , 'line2') asTwyText.
	originalElements := text elements.
	textCopy := text copy.
	elementsCopy := textCopy elements.
	(elementsCopy intersection: originalElements) should be isEmpty.
	elementsCopy do: [ :each | each text should be: textCopy ].
	elementsCopy should haveSize: 5.
	elementsCopy first should beInstanceOf: TwyTextStart.
	elementsCopy second contents should equal: 'line1'.
	elementsCopy second contents should not
		be: originalElements second contents.
	elementsCopy third should beInstanceOf: TwyLineStart.
	elementsCopy fourth contents should equal: 'line2'.
	elementsCopy fourth contents should not
		be: originalElements fourth contents.
	elementsCopy last should beInstanceOf: TwyTextEnd.
	elementsCopy last previous should be: elementsCopy fourth
]

{ #category : #tests }
TwyTextTests >> testCopyShouldBeSameString [

	| textCopy |
	text := ('line1', String cr, 'line2') asTwyText.

	textCopy := text copy.
	
	textCopy asString should equal: ('line1', String cr, 'line2')
]

{ #category : #tests }
TwyTextTests >> testCopyShouldHasNewAnnoucerInstance [

	| textCopy |
	text := ('line1', String cr, 'line2') asTwyText.
	text announcer: Mock new.

	textCopy := text copy.
	
	textCopy announcer should not be: text announcer
]

{ #category : #tests }
TwyTextTests >> testCopyShouldHasNewAttributesInstance [

	| textCopy |
	text := ('line1', String cr, 'line2') asTwyText.
	text defaultAttributes: Mock new.

	textCopy := text copy.
	
	textCopy defaultAttributes should not be: text announcer
]

{ #category : #tests }
TwyTextTests >> testCreationFromEmptyString [
	| elements |
	text := '' asTwyText.
	elements := text elements.
	elements should haveSize: 3.
	elements first should beInstanceOf: TwyTextStart.
	elements second contents should be isEmpty.
	elements last should beInstanceOf: TwyTextEnd
]

{ #category : #tests }
TwyTextTests >> testCreationFromString [
	| elements |
	text := ('line1' , String cr , 'line2') asTwyText.
	elements := text elements.
	elements should haveSize: 5.
	elements first should beInstanceOf: TwyTextStart.
	elements second contents should equal: 'line1'.
	elements third should beInstanceOf: TwyLineStart.
	elements fourth contents should equal: 'line2'.
	elements last should beInstanceOf: TwyTextEnd.
	elements do: [ :each | each text should be: text ]
]

{ #category : #tests }
TwyTextTests >> testCreationFromThreeEmptyStrings [
	| elements |
	text := (String cr , String cr) asTwyText.
	elements := text elements.
	elements should haveSize: 7.
	elements first should beInstanceOf: TwyTextStart.
	elements second contents should be isEmpty.
	elements third should beInstanceOf: TwyLineStart.
	elements fourth contents should be isEmpty.
	elements fifth should beInstanceOf: TwyLineStart.
	elements sixth contents should be isEmpty.
	elements last should beInstanceOf: TwyTextEnd
]

{ #category : #tests }
TwyTextTests >> testCreationFromTwoEmptyStrings [
	| elements |
	text := String cr asTwyText.
	elements := text elements.
	elements should haveSize: 5.
	elements first should beInstanceOf: TwyTextStart.
	elements second contents should be isEmpty.
	elements third should beInstanceOf: TwyLineStart.
	elements fourth contents should be isEmpty.
	elements last should beInstanceOf: TwyTextEnd
]

{ #category : #tests }
TwyTextTests >> testCreationNewActiveCursor [
	| cursor |
	cursor := text newActiveCursor.
	cursor should beInstanceOf: TwyActiveTextCursor.
	cursor text should be: text.
	cursor isAtStart should be: true
]

{ #category : #tests }
TwyTextTests >> testCreationNewPassiveCursor [
	| cursor |
	cursor := text newPassiveCursor.
	cursor should beInstanceOf: TwyPassiveTextCursor.
	cursor text should be: text.
	cursor isAtStart should be: true
]

{ #category : #tests }
TwyTextTests >> testCreationNewPassiveCursorAtStart [
	| cursor |
	cursor := text newPassiveCursorAtStart.
	cursor should beInstanceOf: TwyPassiveTextCursor.
	cursor text should be: text.
	cursor isAtStart should be: true
]

{ #category : #tests }
TwyTextTests >> testCreationNewRegion [

	| region |
	region := text newRegion.
		
	region isEmpty should be: true.
	region start should not be: region end.
	region start isAtStart should be: true.
	region end isAtStart should be: true
]

{ #category : #tests }
TwyTextTests >> testEditingContents [
	| events noArgsBlock |
	[ :announcer :changes | 
	events := OrderedCollection new.
	text announcer: announcer.
	(announcer stub announce: Any) will: [ :each | events add: each ].
	noArgsBlock := [  ].
	[ text editContentsBy: noArgsBlock ] should strictly
		satisfy: [ (announcer stub
				collectChangesOf: text
				during: (Identical to: noArgsBlock)) willReturn: changes ].
	events should haveSize: 3.
	events first should beInstanceOf: TwyChangesBegin.
	events second should beInstanceOf: TwyTextChanged.
	events second changes should be: changes.
	events last should beInstanceOf: TwyChangesCompleted ] runWithMocks
]

{ #category : #tests }
TwyTextTests >> testEditingContentsByAutoTextRegionArgument [
	| suppliedTextRegion events |
	[ :announcer | 
	events := OrderedCollection new.
	text announcer: announcer.
	(announcer stub announce: Any) will: [ :each | events add: each ].
	announcer stub when: Any send: Any to: Any.
	[ text editContentsBy: [ :region | suppliedTextRegion := region ] ]
		should strictly
		satisfy: [ (announcer stub collectChangesOf: text during: Any)
				will: [ :arg1 :arg2 | 
					arg2 value.
					#changes ].
			(announcer unsubscribe: (Instance of: TwyActiveTextCursor))
				useTwice ].
	suppliedTextRegion should beInstanceOf: TwyTextRegion.
	events second should beInstanceOf: TwyTextChanged.
	events second changes should be: #changes ] runWithMocks
]

{ #category : #tests }
TwyTextTests >> testEditingContentsShouldReturnChanges [
	| events actual |
	[ :announcer :changes | 
	events := OrderedCollection new.
	text announcer: announcer.
	(announcer stub announce: Any)
		will: [ :each | 
			events add: each.
			each ].
	[ actual := text editContentsBy: [  ] ] should strictly
		satisfy: [ (announcer stub collectChangesOf: text during: Any)
				willReturn: changes ].
	events second should beInstanceOf: TwyTextChanged.
	actual should be: events second ] runWithMocks
]

{ #category : #tests }
TwyTextTests >> testEditingContentsWhenChangesAreVetoed [
	| events noArgsBlock |
	[ :announcer :changes | 
	events := OrderedCollection new.
	text announcer: announcer.
	(announcer stub announce: Any) will: [ :each | events add: each ].
	noArgsBlock := [  ].
	[ text editContentsBy: noArgsBlock andSubmitChangesBy: [ false ] ]
		should strictly
		satisfy: [ (announcer stub
				collectChangesOf: text
				during: (Identical to: noArgsBlock)) willReturn: changes.
			changes cancel ].
	events should haveSize: 3.
	events first should beInstanceOf: TwyChangesBegin.
	events second should beInstanceOf: TwyChangesCancelled.
	events second changes should be: changes.
	events last should beInstanceOf: TwyChangesCompleted ] runWithMocks
]

{ #category : #tests }
TwyTextTests >> testEditingContentsWhenChangesAreVetoedShouldReturnChangesCancelledEvent [
	| events actual |
	[ :announcer :changes | 
	events := OrderedCollection new.
	text announcer: announcer.
	(announcer stub announce: Any) will: [ :each | events add: each ].
	[ actual := text editContentsBy: [  ] andSubmitChangesBy: [ false ] ]
		should strictly
		satisfy: [ (announcer stub collectChangesOf: text during: Any)
				willReturn: changes.
			changes cancel ].
	actual should beInstanceOf: TwyChangesCancelled.
	actual should be: events second ] runWithMocks
]

{ #category : #tests }
TwyTextTests >> testEnumerationRegionsWhichContentsSatisfiedConditionShouldUnsubscribeFullTextRegion [

	text := '12xxx6xx9' asTwyText.
	
	text 
		withRegionsWhereCharactersAre: [:eachChar | eachChar = $x ] 
		do: [:eachRegion | ].
		
	text announcer numberOfSubscriptions should equal: 0
]

{ #category : #tests }
TwyTextTests >> testEnumerationRegionsWhichContentsSatisfyCondition [
	| regions |
	text := '12xxx6xx9' asTwyText.
	regions := OrderedCollection new.
	text
		withRegionsWhereCharactersAre: [ :eachChar | eachChar = $x ]
		do: [ :eachRegion | regions add: eachRegion copy ].
	regions should haveSize: 2.
	regions first start spanPosition should equal: 2.
	regions first end spanPosition should equal: 5.
	regions last start spanPosition should equal: 6.
	regions last end spanPosition should equal: 8
]

{ #category : #tests }
TwyTextTests >> testGettingAbsentAttribute [

	| actual attributeClass |
	
	attributeClass := Mock new.
	attributeClass stub defaultValue willReturn: #defaultValue.
	
	actual := text getAttribute: attributeClass.
	
	actual should be: #defaultValue
]

{ #category : #tests }
TwyTextTests >> testGettingElements [
	| actual |
	actual := text elements.
	actual should haveSize: 3.
	actual first should be: text start.
	actual second should be: text firstSpan.
	actual last should be: text end
]

{ #category : #tests }
TwyTextTests >> testGettingExistedAttribute [

	| actual |
		
	text defaultAttributes add: TwyFontAttribute with: #font.
	
	actual := text getAttribute: TwyFontAttribute.
	
	actual should be: #font
	
]

{ #category : #tests }
TwyTextTests >> testGettingFirstSpan [

	| actual |

	actual := text firstSpan.
		
	actual should be: text start next
]

{ #category : #tests }
TwyTextTests >> testGettingLastSpan [

	| actual |

	actual := text lastSpan.
		
	actual should be: text end previous
]

{ #category : #tests }
TwyTextTests >> testHasAnnouncerByDefault [
	text := TwyText new.
	text announcer should beInstanceOf: TwyAnnouncer
]

{ #category : #tests }
TwyTextTests >> testHasDefaultAttributesByDefault [
	text defaultAttributes should beInstanceOf: TwyAttributes
]

{ #category : #tests }
TwyTextTests >> testHasTextEndByDefault [
	text end should beInstanceOf: TwyTextEnd
]

{ #category : #tests }
TwyTextTests >> testHasTextStartByDefault [
	text start should beInstanceOf: TwyTextStart
]

{ #category : #tests }
TwyTextTests >> testHasTextStartWithEmptySingleSpan [
	| start span |
	start := text start.
	span := start next.
	span should beInstanceOf: TwyCharactersSpan.
	span contents should be isEmpty.
	span previous should be: start.
	span next should be: text end.
	text end previous should be: span
]

{ #category : #tests }
TwyTextTests >> testIsEmpty [
	
	'some' asTwyText isEmpty should be: false.
	
	'' asTwyText isEmpty should be: true.
]

{ #category : #tests }
TwyTextTests >> testRemoveAbsentAttributeShouldAnnounceNothing [

	| textChanges |
	
	textChanges := OrderedCollection new.
	text when: TwyTextStateChanged do: [ :ann | textChanges add: ann ].
	
	text removeAttribute: TwyFontAttribute.
	
	textChanges should be isEmpty
]

{ #category : #tests }
TwyTextTests >> testRemoveAttribute [
	
	| actual |
	text applyDefaultAttribute: (TwyFontAttribute with: #font).
	
	text removeAttribute: TwyFontAttribute.

	actual := text defaultAttributes get: TwyFontAttribute ifAbsent: [nil].
		
	actual should be: nil
	
]

{ #category : #tests }
TwyTextTests >> testRemoveAttributeShouldAnnounceChange [
	| change textChanges attr |
	attr := TwyFontAttribute with: #oldFont.
	text applyDefaultAttribute: attr.
	textChanges := OrderedCollection new.
	text when: TwyTextStateChanged do: [ :ann | textChanges add: ann ].
	text removeAttribute: TwyFontAttribute.
	textChanges should haveSize: 1.
	change := textChanges first.
	change should beInstanceOf: TwyDefaultAttributeChanged.
	change text should be: text.
	change initialAttribute should be: attr.
	change newAttribute should be: nil
]
