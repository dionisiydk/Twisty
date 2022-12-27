Class {
	#name : #TwySmartCharTests,
	#superclass : #TestCase,
	#instVars : [
		'smartChar',
		'textSelection',
		'selectionStart',
		'selectionEnd',
		'charBeforeSelection',
		'charAfterSelection'
	],
	#category : #'TwistyTests-Editor'
}

{ #category : #specs }
TwySmartCharTests >> insertMainChar [
	selectionStart insert: smartChar value asString
]

{ #category : #specs }
TwySmartCharTests >> insertOppositeChar [
	selectionEnd insert: smartChar oppositeValue asString.
	selectionEnd moveBackward
]

{ #category : #helpers }
TwySmartCharTests >> separatorCharacter [
	^Character space
]

{ #category : #running }
TwySmartCharTests >> setUp [
	super setUp.
	
	smartChar := TwySmartChar with: $( and: $).
	charBeforeSelection := $b.
	charAfterSelection := $a.
	
	selectionEnd := Mock new.
	selectionStart := Mock new.
	textSelection := Mock new.
	textSelection stub start willReturn: selectionStart.
	textSelection stub end willReturn: selectionEnd.
	selectionStart stub previousItem will: [charBeforeSelection].
	selectionEnd stub nextItem will: [charAfterSelection]
]

{ #category : #tests }
TwySmartCharTests >> testInsertionWhenSelectionEmptyAndBothSideOfSelectionAreSeparators [

	[
		charBeforeSelection := self separatorCharacter.
		charAfterSelection := self separatorCharacter.
		[ smartChar insertAt: textSelection ]
			should lenient satisfy: 
		[ textSelection isEmpty willReturn: true; useArbitrarily.
		self insertMainChar.
		self insertOppositeChar.
		selectionStart moveBackward]
	] runWithMocks 
]

{ #category : #tests }
TwySmartCharTests >> testInsertionWhenSelectionEmptyAndLeftSideOfSelectionIsSeparatorButRightAbsent [

	[
		charBeforeSelection := self separatorCharacter.
		charAfterSelection := nil.
		[ smartChar insertAt: textSelection ]
			should lenient satisfy: 
		[ textSelection isEmpty willReturn: true; useArbitrarily.
		self insertMainChar.
		self insertOppositeChar.
		selectionStart moveBackward]
	] runWithMocks 
]

{ #category : #tests }
TwySmartCharTests >> testInsertionWhenSelectionEmptyAndRightSideOfSelectionIsSeparatorButLeftAbsent [

	[
		charBeforeSelection := nil.
		charAfterSelection := self separatorCharacter.
		[ smartChar insertAt: textSelection ]
			should lenient satisfy: 
		[ textSelection isEmpty willReturn: true; useArbitrarily.
		self insertMainChar.
		self insertOppositeChar.
		selectionStart moveBackward]
	] runWithMocks 
]

{ #category : #tests }
TwySmartCharTests >> testInsertionWhenSelectionEmptyAndSidesOfSelectionAreNotSeparators [

	[
		charBeforeSelection := $b.
		charAfterSelection := $a.
		[ smartChar insertAt: textSelection ]
			should lenient satisfy: 
		[ textSelection isEmpty willReturn: true; useArbitrarily.
		self insertMainChar]
	] runWithMocks 
]

{ #category : #tests }
TwySmartCharTests >> testInsertionWhenSelectionNotEmpty [

	[
		[ smartChar insertAt: textSelection ]
			should lenient satisfy: 
		[ textSelection isEmpty willReturn: false; useArbitrarily.
		self insertMainChar.
		self insertOppositeChar]
	] runWithMocks 
]

{ #category : #tests }
TwySmartCharTests >> testInsertionWhenSelectionNotEmptyButItAlreadySurroundedByThisSmartChar [

	[
		charBeforeSelection := smartChar value.
		charAfterSelection := smartChar oppositeValue.
		[ smartChar insertAt: textSelection ]
			should lenient satisfy: 
		[ textSelection isEmpty willReturn: false; useArbitrarily.
		selectionStart removePreviousItem.
		selectionEnd removeNextItem]
	] runWithMocks 
]

{ #category : #tests }
TwySmartCharTests >> testIsBasedOnMainChar [

	| actual |
	actual := smartChar isBasedOn: smartChar value.
	actual should be: true
]

{ #category : #tests }
TwySmartCharTests >> testNotBasedOnNotMainChar [

	| actual |
	actual := smartChar isBasedOn: $x.
	actual should be: false
]

{ #category : #tests }
TwySmartCharTests >> testRemovingAsPreviousCharacterWhenNextIsNotOpposite [

	[
		charBeforeSelection := smartChar value.
		charAfterSelection := $x.
		[ smartChar removeAsPreviousCharacterAt: textSelection]
			should lenient satisfy: 
		[ textSelection backspaceKey]
	] runWithMocks 
]

{ #category : #tests }
TwySmartCharTests >> testRemovingAsPreviousCharacterWhenNextIsOpposite [

	[
		charBeforeSelection := smartChar value.
		charAfterSelection := smartChar oppositeValue.
		[ smartChar removeAsPreviousCharacterAt: textSelection]
			should lenient satisfy: 
		[ selectionEnd removeNextItem.
		selectionStart removePreviousItem.
		textSelection collapseAtStart]
	] runWithMocks 
]
