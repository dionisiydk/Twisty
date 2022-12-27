Class {
	#name : #TwyLayoutCursorTests,
	#superclass : #TestCase,
	#instVars : [
		'layoutSpan',
		'layout',
		'layoutCursor',
		'textCursor'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyLayoutCursorTests >> setUp [ 
	super setUp.
	
	layout := Mock new.
	(layout stub when: Any send: Any to: Any) useOnce.

	textCursor  := Mock new.	
	layoutSpan := Mock new.
	
	layoutCursor := TwyLayoutCursor new.
	layoutCursor 
		layout: layout;
		span: layoutSpan;
		textCursor: textCursor
	
]

{ #category : #specs }
TwyLayoutCursorTests >> subscribeOnTextCursor [

	self subscribeOnTextCursor: textCursor
]

{ #category : #specs }
TwyLayoutCursorTests >> subscribeOnTextCursor: aTextCursor [

	aTextCursor subscribeLayoutCursor: layoutCursor
]

{ #category : #tests }
TwyLayoutCursorTests >> testAttachingToTextCursor [
	
	[:newTextCursor :topLine :firstSpan |
	
		[layoutCursor attachTo: newTextCursor]
			should lenient satisfy: 
		[self unsubscribeTextCursor.
		layout topLine willReturn: topLine.
		topLine firstSpan willReturn: firstSpan.
		firstSpan moveLayoutCursor: layoutCursor rightToSpanWith: newTextCursor.
		self subscribeOnTextCursor: newTextCursor].
	
		layoutCursor textCursor should be: newTextCursor
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutCursorTests >> testBelowLayoutBoundsUpToLine [
	
	| actual |
	[:belowLine :bottomLine |
	
		[actual := layoutCursor belowLayoutBoundsUpTo: bottomLine] 
			should lenient satisfy: 
		[layoutSpan belowLine willReturn: belowLine.
		belowLine layoutBounds willReturn: (1@1 corner: 5@6).
		bottomLine layoutBounds willReturn: (10@20 corner: 30@40)].
	
		actual should equal: (1@1 corner: 30@40)
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testHasZeroDesiredOffsetByDefault [
	
	layoutCursor desiredOffset should equal: 0
]

{ #category : #tests }
TwyLayoutCursorTests >> testHasZeroValueByDefault [
	
	layoutCursor layoutPosition should equal: 0@0
]

{ #category : #tests }
TwyLayoutCursorTests >> testHeight [
	
	[ 
	
		[layoutCursor height should be: #spanHeight] 
			should strictly satisfy: 
		[layoutSpan height willReturn: #spanHeight].
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testIngoreLayoutChanges [
	
	[
		[ layoutCursor ignoreLayoutChanges ]
			should strictly satisfy: 
		[ layout unsubscribe: layoutCursor ]
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutCursorTests >> testIsAfterAnotherCursor [
	
	[:anotherCursor | 
	
		[(layoutCursor isAfter: anotherCursor) should be: #result] 
			should strictly satisfy: 
		[anotherCursor textCursor willReturn: #anotherTextCursor.
		(textCursor isAfter: #anotherTextCursor) willReturn: #result].
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testIsAtSameLineWithAnotherPositionFromSameLine [
	
	| actual |
	[:anotherCursor :line |
		
		[actual := layoutCursor isAtSameLineWith: anotherCursor] 
			should lenient satisfy: 
		[layoutSpan line willReturn: line.
		anotherCursor line willReturn: line].
		
		actual should be: true
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testIsAtSameTextPositionWithAnotherCursor [
	
	[:anotherCursor | 
	
		[(layoutCursor isAtSameTextPositionWith: anotherCursor) should be: #result] 
			should strictly satisfy: 
		[anotherCursor textCursor willReturn: #anotherTextCursor.
		(textCursor isAtSamePositionWith: #anotherTextCursor) willReturn: #result].
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testIsBeforeAnotherCursor [
	
	[:anotherCursor | 
	
		[(layoutCursor isBefore: anotherCursor) should be: #result] 
			should strictly satisfy: 
		[anotherCursor textCursor willReturn: #anotherTextCursor.
		(textCursor isBefore: #anotherTextCursor) willReturn: #result].
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testIsNotAtSameLineWithAnotherPositionFromSameLine [
	
	| actual |
	[:anotherCursor :line |
		
		[actual := layoutCursor isAtSameLineWith: anotherCursor] 
			should lenient satisfy: 
		[layoutSpan line willReturn: line.
		anotherCursor line willReturn: #anotherLine].
		
		actual should be: false
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testIsSubscribedOnLayoutChanges [
	
	[
		[layoutCursor layout: layout] 
			should strictly satisfy: 
		[layout when: TwyLayoutChanged send: #synchronizeWithTextCursor to: layoutCursor].
			
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testLayoutChangedProcessing [
	
	[:targetSpan |
		[layoutCursor layoutChanged]
			should lenient satisfy: 
		[(layout findSpanWith: textCursor) willReturn: targetSpan.
		(targetSpan computeLayoutPositionOf: textCursor) willReturn: 20@30].
	
		layoutCursor span should be: targetSpan.
		layoutCursor layoutPosition should equal: 20@30.
		layoutCursor desiredOffset should be: 20
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutCursorTests >> testLeftSideLineBounds [
	
	| actual |
	[:line |
		layoutCursor saveDesiredPositionAt: 2@3.
	
		[actual := layoutCursor leftSideLineBounds] 
			should strictly satisfy: 
		[layoutSpan line willReturn: line.
		line layoutBounds willReturn: (1@1 corner: 5@6)].
	
		actual should equal: (1@1 corner: 2@6)
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testMoveDown [
	
	| triggered |
	[:belowLine :targetSpan |
		layoutCursor desiredOffset: #offset.
		layoutCursor when: TwyPositionChanged do: [ :ann | triggered := true ].
	
		[layoutCursor moveDown] 
			should strictly satisfy: 
		[layoutSpan belowLine willReturn: belowLine.
		self unsubscribeTextCursor.
		(belowLine spanAtOffset: #offset) willReturn: targetSpan.
		targetSpan moveTextCursor: textCursor insideAtOffset: #offset.
		(targetSpan computeLayoutPositionOf: textCursor) willReturn: #actualXYValue.
		self subscribeOnTextCursor].
	
		layoutCursor span should be: targetSpan.
		layoutCursor desiredOffset should be: #offset.
		layoutCursor layoutPosition should be: #actualXYValue.
		triggered should be: true
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testMoveDownWhenAtLastLine [
	
	[
		[layoutCursor moveDown] 
			should strictly satisfy: 
		[layoutSpan belowLine willReturn: nil].
	
		layoutCursor span should be: layoutSpan
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testMoveLeft [
	
	[
		[layoutCursor moveLeft]
			should lenient satisfy: 
		[textCursor moveBackward].
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutCursorTests >> testMoveRight [
	
	[
		[layoutCursor moveRight]
			should lenient satisfy: 
		[textCursor moveForward].
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutCursorTests >> testMoveToLineEnd [
	
	[
		[layoutCursor moveToLineEnd]
			should lenient satisfy: 
		[textCursor moveToLineEnd].
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutCursorTests >> testMoveToLineStart [
	
	[
		[layoutCursor moveToLineStart]
			should lenient satisfy: 
		[textCursor moveToLineStart].
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutCursorTests >> testMoveToTextEnd [
	
	[:lastLine |
		[layoutCursor moveToTextEnd]
			should lenient satisfy: 
		[textCursor moveToTextEnd].
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutCursorTests >> testMoveToTextStart [
	
	[:lastLine |
		[layoutCursor moveToTextStart]
			should lenient satisfy: 
		[textCursor moveToTextStart].
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutCursorTests >> testMoveUp [
	
	| triggered |
	[:aboveLine :targetSpan |
		layoutCursor desiredOffset: #offset.
		layoutCursor when: TwyPositionChanged do: [ :ann | triggered := true ].
	
		[layoutCursor moveUp] 
			should strictly satisfy: 
		[layoutSpan aboveLine willReturn: aboveLine.
		self unsubscribeTextCursor.
		(aboveLine spanAtOffset: #offset) willReturn: targetSpan.
		targetSpan moveTextCursor: textCursor insideAtOffset: #offset.
		(targetSpan computeLayoutPositionOf: textCursor) willReturn: #actualXYValue.
		self subscribeOnTextCursor.].
	
		layoutCursor span should be: targetSpan.
		layoutCursor layoutPosition should be: #actualXYValue.
		layoutCursor desiredOffset should be: #offset.
		triggered should be: true
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testMoveUpWhenAtFirstLine [
	
	[
		[layoutCursor moveUp] 
			should strictly satisfy: 
		[layoutSpan aboveLine willReturn: nil].
	
		layoutCursor span should be: layoutSpan
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testMovedToSpan [
	
	| triggered |
	[:targetSpan |
		layoutCursor when: TwyPositionChanged do: [ :ann | triggered := true ].
		
		[layoutCursor movedToSpan: targetSpan]
			should lenient satisfy: 
		[(targetSpan computeLayoutPositionOf: textCursor) willReturn: 20@30].
	
		layoutCursor span should be: targetSpan.
		layoutCursor layoutPosition should equal: 20@30.
		layoutCursor desiredOffset should be: 20.
		triggered should be: true
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutCursorTests >> testRightSideLineBounds [
	
	| actual |
	[:line |
		layoutCursor saveDesiredPositionAt: 2@3.
	
		[actual := layoutCursor rightSideLineBounds] 
			should strictly satisfy: 
		[layoutSpan line willReturn: line.
		line layoutBounds willReturn: (10@10 corner: 30@40)].
	
		actual should equal: (2@3 corner:30@40)
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testSettingLayoutPosition [
	
	[:targetLine :targetSpan |
			
		[layoutCursor layoutPosition: 20@30] 
			should strictly satisfy: 
		[self unsubscribeTextCursor.
		(layout lineAt: 20@30) willReturn: targetLine.
		(targetLine spanAtOffset: 20) willReturn: targetSpan.
		targetSpan moveTextCursor: textCursor insideAtOffset: 20.
		(targetSpan computeLayoutPositionOf: textCursor) willReturn: 2@3.
		self subscribeOnTextCursor].
	
		layoutCursor span should be: targetSpan.
		layoutCursor desiredOffset should equal: 2.
		layoutCursor layoutPosition should equal: 2@3
			
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testShouldRecomputePositionAfterAnyTextCursorMovementByDefault [
	
	layoutCursor shouldRecomputePositionOnlyAfterLayoutChanges should be: false
]

{ #category : #tests }
TwyLayoutCursorTests >> testSynchronizationWithTextCursorWhenFirstMovementAbsent [
	
	[ :topLine :firstSpan |
		layoutCursor firstMovement: nil.
	
		[layoutCursor synchronizeWithTextCursor] 
			should strictly satisfy: 
		[layout topLine willReturn: topLine.
		topLine firstSpan willReturn: firstSpan.
		firstSpan moveLayoutCursor: layoutCursor rightToSpanWith: textCursor].
			
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testSynchronizationWithTextCursorWhenFirstMovementExists [
	
	[:firstMovement |
		layoutCursor firstMovement: firstMovement.
	
		[layoutCursor synchronizeWithTextCursor] 
			should strictly satisfy: 
		[firstMovement correctLayoutPositionOf: layoutCursor].
	
		layoutCursor firstMovement should be: nil
		
	] runWithMocks 

]

{ #category : #tests }
TwyLayoutCursorTests >> testTextPosition [
	
	[
		[layoutCursor textPosition should be: #result]
			should lenient satisfy: 
		[textCursor textPosition willReturn: #result].
	
	] runWithMocks 
]

{ #category : #specs }
TwyLayoutCursorTests >> unsubscribeTextCursor [
	textCursor unsubscribeLayoutCursor: layoutCursor.
]
