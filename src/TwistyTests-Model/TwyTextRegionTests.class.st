Class {
	#name : #TwyTextRegionTests,
	#superclass : #TestCase,
	#instVars : [
		'region',
		'start',
		'end'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyTextRegionTests >> setUp [
	super setUp.
	
	start := Mock new.
	end := Mock new.
	(end stub isBefore: start) willReturn: false.
	region := TwyTextRegion from: start to: end
]

{ #category : #tests }
TwyTextRegionTests >> testApplyingAttribute [

	[ :span |
		[region applyAttribute: #textAttribute]
			should strictly satisfy: 
		[start applyAttribute: #textAttribute upTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testApplyingAttributeWithValue [

	[ :span |
		[region applyAttribute: TwyBackColorAttribute with: #color]
			should strictly satisfy: 
		[start applyAttribute: (Instance of: TwyBackColorAttribute) & (Satisfying for: [:attr | attr value == #color]) upTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testApplyingParagraphAttribute [

	[ :span |
		[region applyParagraphAttribute: #textAttribute]
			should strictly satisfy: 
		[start applyParagraphAttribute: #textAttribute upTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testApplyingParagraphAttributeWithValue [

	[ :span |
		[region applyParagraphAttribute: TwyBackColorAttribute with: #color]
			should strictly satisfy: 
		[start applyParagraphAttribute: (Instance of: TwyBackColorAttribute) & (Satisfying for: [:attr | attr value == #color]) upTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testBackspaceKeyWhenRegionIsEmpty [

	[
		[ region backspaceKey]
			should strictly satisfy: 
		[(start isAtSamePositionWith: end ) willReturn: true.
		start moveBackward.
		start deleteUpTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testBackspaceKeyWhenRegionIsNotEmpty [

	[
		[ region backspaceKey]
			should strictly satisfy: 
		[(start isAtSamePositionWith: end ) willReturn: false.
		 start deleteUpTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testCollapseAtEnd [

	[ 
		[ region collapseAtEnd]
			should strictly satisfy: 
		[ start moveTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testCollapseAtStart [

	[ 
		[ region collapseAtStart]
			should strictly satisfy: 
		[ end moveTo: start]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testConvertingToString [

	[ 
		[ region asString should equal: 'result' ]
			should strictly satisfy: 
		[(start printTextOn: (Kind of: Stream) upTo: end)
			will: [ :stream :regionEnd | stream nextPutAll: 'result' ] 
		 ]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testCopy [

	[:startCopy :endCopy :regionCopy |

		[region copy should be: regionCopy]
			should strictly satisfy: 
		[start copy willReturn: startCopy.
		end copy willReturn: endCopy.
		(startCopy selectTextUpTo: endCopy) willReturn: regionCopy]
	
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testCreationNewPassiveCursorAtStart [

	[ 
		[ region newPassiveCursorAtStart should be: #result]
			should strictly satisfy: 
		[ start asPassiveCursor willReturn: #result]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testDelete [

	[ 
		[ region delete]
			should strictly satisfy: 
		[ start deleteUpTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testDeleteKeyWhenRegionIsEmpty [

	[
		[ region deleteKey]
			should strictly satisfy: 
		[(start isAtSamePositionWith: end ) willReturn: true. 
		end moveForward.
		start deleteUpTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testDeleteKeyWhenRegionIsNotEmpty [

	[
		[ region deleteKey]
			should strictly satisfy: 
		[(start isAtSamePositionWith: end ) willReturn: false. 
		start deleteUpTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testEnumerationThroughCharacterGroupsWhenNothingSatisfiedCondition [

	| eachSubRegion |
	[ :eachGroupStart :eachGroupEnd  :groupRegion |
		[ region splittedByGroupsWhereCharactersAre: Any do: [:arg | eachSubRegion := arg] ]
			should strictly satisfy: 
		[start copy willReturn: eachGroupStart.
		start copy willReturn: eachGroupEnd.
		(eachGroupStart selectTextUpTo: eachGroupEnd) willReturn: groupRegion.
		(eachGroupEnd isAtSamePositionWith: end ) willReturn: false.
		eachGroupStart moveForwardToItemWhich: Any butNotFarThan: end.
		eachGroupEnd moveTo: eachGroupStart.
		eachGroupEnd moveForwardToItemWhich: Any butNotFarThan: end.
		groupRegion isEmpty willReturn: true.
		groupRegion detachText].
	
		eachSubRegion should be: nil
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testEnumerationThroughCharacterGroupsWhichSatisfiedCondition [

	| eachSubRegion conditionBlock |
	[ :eachGroupStart :eachGroupEnd  :groupRegion |
		conditionBlock := [:eachChar | eachChar = #eachChar ].
		[ region splittedByGroupsWhereCharactersAre: conditionBlock do: [:arg | eachSubRegion := arg] ]
			should strictly satisfy: 
		[start copy willReturn: eachGroupStart.
		start copy willReturn: eachGroupEnd.
		(eachGroupStart selectTextUpTo: eachGroupEnd) willReturn: groupRegion.
		(eachGroupEnd isAtSamePositionWith: end ) willReturn: false.
		eachGroupStart moveForwardToItemWhich: (Identical to: conditionBlock) butNotFarThan: end.
		eachGroupEnd moveTo: eachGroupStart.
		eachGroupEnd moveForwardToItemWhich: [ :inverseCondition | inverseCondition value: #anotherChar ] butNotFarThan: end.
		groupRegion isEmpty willReturn: false.
		(eachGroupStart moveTo: eachGroupEnd) when: [ eachSubRegion ] is: groupRegion.
		(eachGroupEnd isAtSamePositionWith: end ) willReturn: true.
		groupRegion detachText]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testEnumerationThroughSpanSubRegions [

	| iterations |
	[:eachSpanStart :eachSpanEnd  :spanRegion |

		[iterations := 0. 
		region splittedBySpansDo: [:each | iterations := iterations + 1. each should be: spanRegion].
		iterations should be: 2	]
			should strictly satisfy: 
		[start copy willReturn: eachSpanStart.
		start copy willReturn: eachSpanEnd.
		(eachSpanStart selectTextUpTo: eachSpanEnd) willReturn: spanRegion.
		eachSpanEnd moveToSpanEnd.
		(eachSpanEnd isAtSameSpanWith: end ) willReturn: false.
		eachSpanStart moveToStartOfNextSpan.
		eachSpanEnd moveTo: eachSpanStart; moveToSpanEnd.		
		(eachSpanEnd isAtSameSpanWith: end ) willReturn: true.
		spanRegion detachText]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testEnumerationThroughSpanSubRegionsWithCondition [

	| iterations |
	[:eachSpanStart :eachSpanEnd  :spanRegion |

		[iterations := 0. 
		region 
			splittedBySpansDo: [:each | iterations := iterations + 1 ] 
			while: [:each | each should be: spanRegion. iterations < 1] ]
			should strictly satisfy: 
		[start copy willReturn: eachSpanStart.
		start copy willReturn: eachSpanEnd.
		(eachSpanStart selectTextUpTo: eachSpanEnd) willReturn: spanRegion.
		eachSpanEnd moveToSpanEnd.
		(eachSpanEnd isAtSameSpanWith: end ) willReturn: false.
		eachSpanStart moveToStartOfNextSpan.
		eachSpanEnd moveTo: eachSpanStart; moveToSpanEnd.
		(eachSpanEnd isAtSameSpanWith: end ) willReturn: true.
		spanRegion detachText].
	
		iterations should be: 1
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testGettingAttribute [

	[ :span |
		[(region getStartAttribute: #attributeClass) should be: #result]
			should strictly satisfy: 
		[start span willReturn: span.
		(span getAttribute: #attributeClass) willReturn: #result]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testGettingSpanAtEnd [

	end stub span willReturn: #span.

	region spanAtEnd should be: #span.

]

{ #category : #tests }
TwyTextRegionTests >> testHasAttribute [

	[ :span |
		[(region hasAttribute: #attributeClass) should be: #result]
			should strictly satisfy: 
		[(start isAtSameSpanWith: end) willReturn: true.
		(start hasAttribute: #attributeClass) willReturn: #result]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testIsCoversSingleSpan [

	[
		[region isCoversSingleSpan should be: #result]
			should strictly satisfy: 
		[(start isAtSameSpanWith: end) willReturn: #result]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testIsEmptyWhenStartAtSamePositionWithEnd [

	(start stub isAtSamePositionWith: end) willReturn: true. 

	region isEmpty should be: true
]

{ #category : #tests }
TwyTextRegionTests >> testIsNotEmptyWhenStartNotAtSamePositionWithEnd [

	(start stub isAtSamePositionWith: end) willReturn: false. 

	region isEmpty should be: false
]

{ #category : #tests }
TwyTextRegionTests >> testMoveToPositionOfAnotherCursor [

	[ 
		[ region moveTo: #textCursor]
			should strictly satisfy: 
		[start moveTo: #textCursor. 
		end moveTo: #textCursor]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testOverridePossibleCharacters [

	[ :span |
		[(region overridePossibleCharactersWith: #newString) should be: #result]
			should strictly satisfy: 
		[(start overridePossibleCharactersWith: #newString upTo: end) willReturn: #result]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testReplaceWithAnotherTextModel [

	[ 
		[ region replaceWith: #textModelSource]
			should strictly satisfy: 
		[ start deleteUpTo: end.
		end insert: #textModelSource.
		start moveTo: end]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testSelectingFullText [

	[ 
		[ region selectFullText]
			should strictly satisfy: 
		[ start moveToTextStart.
		end moveToTextEnd]
	] runWithMocks 
]

{ #category : #tests }
TwyTextRegionTests >> testSelectingTextBetweenTwoPositions [

	[ 
		[ region selectTextBetween: 2 and: 10]
			should strictly satisfy: 
		[ start textPosition: 2.
		end textPosition: 10]
	] runWithMocks 
]
