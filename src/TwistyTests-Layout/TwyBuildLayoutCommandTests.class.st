Class {
	#name : #TwyBuildLayoutCommandTests,
	#superclass : #TwyLayoutBuiltCommandTestCase,
	#instVars : [
		'leftSpan',
		'rightSpan',
		'elementBeforeInsertion',
		'elementAfterInsertion'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyBuildLayoutCommandTests >> commandClass [
	^TwyBuildLayoutCommand 
]

{ #category : #running }
TwyBuildLayoutCommandTests >> setUp [
	super setUp.
	
	leftSpan := Mock new.
	rightSpan := Mock new.
	elementBeforeInsertion := Mock new.
	elementAfterInsertion := Mock new.
	
	command 
		leftSpan: leftSpan;
		rightSpan: rightSpan;
		elementBeforeInsertion: elementBeforeInsertion;
		elementAfterInsertion: elementAfterInsertion
		
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testCorrectionState [

	[
		[ command correctState ]
			should lenient satisfy: 
		[ leftSpan findLiveSpanFromLeft willReturn: #leftLiveSpan.
		rightSpan findLiveSpanFromRight willReturn: #rightLiveSpan.
		elementBeforeInsertion findLiveElementBackward willReturn: #backwardLiveElement.
		elementAfterInsertion findLiveElementForward willReturn: #forwardLiveElement ].
	
		command leftSpan should be: #leftLiveSpan.
		command rightSpan should be: #rightLiveSpan.
		command elementBeforeInsertion should be: #backwardLiveElement.
		command elementAfterInsertion should be: #forwardLiveElement.
		
	] runWithMocks 
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testHasBuiltPlaceAfterLayoutSpan [

	[ 
		[ (command hasBuiltPlaceAfterLayoutSpan: #someLayoutSpan) should be: #result]
			should strictly satisfy: 
		[(leftSpan isPlacedAfter: #someLayoutSpan) willReturn: #result]
	 ] runWithMocks 
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testHasBuiltPlaceAfterLeftLayoutSpan [

	 (command hasBuiltPlaceAfterLayoutSpan: leftSpan) should be: true
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testHasBuiltPlaceBeforeTextChangeWhichAffectTextAfterInsertion [

	[:textChange |
		 [ (command hasBuiltPlaceBeforeTextChange: textChange) should be: #result]
			should strictly satisfy: 
		[(textChange isAffectTextAfterElement: elementBeforeInsertion) willReturn: #result]
	 ] runWithMocks 
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testHasNotBuiltPlaceUnderAnyTextChangeBecauseCommandAboutNewSpans [

	 (command hasBuiltPlaceChangedBy: Any) should be: false
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testIsActiveAtLeftSpanLine [

	leftSpan stub line willReturn: #line.
	
	(command isActiveAtLine: #line) should be: true.

]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testIsActiveAtSpan [

	(command isActiveAtSpan: leftSpan) should be: true.

	(command isActiveAtSpan: #anotherSpan) should be: false.
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testIsNotActiveAtNotLeftSpanLine [

	leftSpan stub line willReturn: #line.
	
	(command isActiveAtLine: #anotherLine) should be: false.

]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testIsNotSimilarToDifferentRegionBuildCommand [

	| similarCommand |
	similarCommand := self commandClass new.
	similarCommand elementBeforeInsertion: #someBeforeSpan.
	similarCommand elementAfterInsertion: #someAfterSpan.
	
	(command isSimilarTo: similarCommand) should be: false
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testIsSimilarToSameRegionBuildCommand [

	| similarCommand |
	similarCommand := self commandClass new.
	similarCommand elementBeforeInsertion: command elementBeforeInsertion.
	similarCommand elementAfterInsertion: command elementAfterInsertion.
	
	(command isSimilarTo: similarCommand) should be: true
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testShouldBeExecutedBeforeAnotherCommand [

	[:anotherCommand |
		 [ (command shouldBeExecutedBefore: anotherCommand) should be: #result]
			should strictly satisfy: 
		[(anotherCommand hasBuiltPlaceAfterLayoutSpan: leftSpan) willReturn: #result]
	 ] runWithMocks 
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testShouldBeNotRedundant [

	 command isRedundant should be: false
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testShouldLayoutTextBetweenLeftAndRightSpans [

	[ 
		[ self executeCommand ]
			should strictly satisfy: 
		[builder currentSpan: leftSpan. 
		builder layoutTextBetween: elementBeforeInsertion and: elementAfterInsertion.
		builder setUpNextSpan.
		builder addCorrectionCommandFor: rightSpan ]
	 ] runWithMocks 
]

{ #category : #tests }
TwyBuildLayoutCommandTests >> testWhenNoRightSpan [

	[
		command rightSpan: nil. 
		[ self executeCommand ]
			should strictly satisfy: 
		[builder currentSpan: leftSpan. 
		builder layoutTextBetween: elementBeforeInsertion and: elementAfterInsertion.
		builder setUpNextSpan ]
	 ] runWithMocks 
]
