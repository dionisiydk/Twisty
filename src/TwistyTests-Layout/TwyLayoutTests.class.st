Class {
	#name : #TwyLayoutTests,
	#superclass : #TestCase,
	#instVars : [
		'layout',
		'layoutStrategy',
		'topLine'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyLayoutTests >> setUp [ 
	super setUp.
	
	topLine := Mock new.
	layoutStrategy := Mock new.
	layout := TwyLayout new.
	layout strategy: layoutStrategy.
	layout topLine: topLine
]

{ #category : #tests }
TwyLayoutTests >> testAccumulatingLinesLayout [
	
	[:line1 :line2 :eachLine1 :eachLine2 |
		layout extent: 2@4.
		[layout accumulateLinesLayoutFrom: line1 to: line2]
			should strictly satisfy: 
		[ (line1 downDo: Any while: Any) will: [ :actionBlock :conditionBlock |
			(conditionBlock value: line2) should be: false.
			(conditionBlock value: eachLine1) should be: true. 
			actionBlock value: eachLine1; value: eachLine2].
		eachLine1 fixPosition.
		eachLine1 extent willReturn: 10 @ 20.
		eachLine2 fixPosition.
		eachLine2 extent willReturn: 5 @ 6 ].
		
		layout extent should equal: 10 @ 30
	] runWithMocks 
	
		
]

{ #category : #tests }
TwyLayoutTests >> testAligningLines [

	[ :eachLine |
		topLine stub getParagraphAttribute: TwyLineAlignmentAttribute.
		
		[ layout alignLines]
			should strictly satisfy: 
		[(topLine downDo: Any) will: [ :arg | arg value: eachLine].
		eachLine isVirtual willReturn: false.
		(eachLine getParagraphAttribute: TwyLineAlignmentAttribute) willReturn: #alignment.
		eachLine applyAlignment: #alignment].	
	
	 ] runWithMocks
]

{ #category : #tests }
TwyLayoutTests >> testAligningLinesShouldUseTextLineAlignmentForVirtualLines [

	[ :eachLine |
		(topLine stub getParagraphAttribute: TwyLineAlignmentAttribute) willReturn: #alignment.
		
		[ layout alignLines]
			should strictly satisfy: 
		[(topLine downDo: Any) will: [ :arg | arg value: eachLine].
		eachLine isVirtual willReturn: true.		
		eachLine applyAlignment: #alignment].	
	
	 ] runWithMocks
]

{ #category : #tests }
TwyLayoutTests >> testApplyingAlignment [
	
	[:alignment :topLine |
		layout topLine: topLine.
		layout extent: 10 @ 20.		
		
		[layout applyAlignment: alignment]
			should lenient satisfy: 
		[(topLine downDo: Any) will: [ :actionBlock | actionBlock value: #eachLine ].
		alignment layoutLine: #eachLine within: 10]
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutTests >> testBuilding [

	[ :text  :builder |
		layout text: text.
		layout topLine: #topLine.
		layout strategy: nil.
		 
		[ layout buildBy: layoutStrategy]
			should strictly satisfy: 
		[(layoutStrategy createBuilderFor: layout startedAt: #topLine) willReturn: builder.
		builder layoutText: text.
		text when: TwyTextChanged send: #textChangedBy: to: layout].	
	
		layout strategy should be: layoutStrategy
	 ] runWithMocks
]

{ #category : #tests }
TwyLayoutTests >> testFindSpan [
	
	[:targetLine :topLine |
		layout topLine: topLine.
		
		[ (layout findSpanWith: #textCursor) should be: #result ]
			should strictly satisfy: 
		[(topLine downDo: Any) will: [ :block | block value: topLine; value: targetLine ].
		(topLine findSpanWith: #textCursor) willReturn: nil. 		
		(targetLine findSpanWith: #textCursor) willReturn: #result ].
	
	] runWithMocks 		
]

{ #category : #tests }
TwyLayoutTests >> testFindSpanWhenItAbsent [
	
	[:eachLine :topLine |
		layout topLine: topLine.
		
		[ (layout findSpanWith: #textCursor) should be: nil ]
			should strictly satisfy: 
		[(topLine downDo: Any) will: [ :block | block value: topLine; value: eachLine ].
		(topLine findSpanWith: #textCursor) willReturn: nil. 		
		(eachLine findSpanWith: #textCursor) willReturn: nil ].
	
	] runWithMocks 		
]

{ #category : #tests }
TwyLayoutTests >> testHandlingTextChanges [

	[ :builder :textChangedEvent |
		 
		[ layout textChangedBy: textChangedEvent ]
			should strictly satisfy: 
		[(layoutStrategy createBuilderFor: layout startedAt: topLine) willReturn: builder.
		textChangedEvent collectLayoutCommandsFor: builder.
		 builder processAllCommands].	
	
	 ] runWithMocks
]

{ #category : #tests }
TwyLayoutTests >> testHandlingTextChangesShouldTriggerEvent [

	| triggered |
	[ :builder :textChangedEvent |
		layout when: TwyLayoutChanged do: [ :ann | triggered := true ].
		 
		[ layout textChangedBy: textChangedEvent ]
			should strictly satisfy: 
		[(layoutStrategy createBuilderFor: layout startedAt: topLine) willReturn: builder.
		textChangedEvent collectLayoutCommandsFor: builder.
		builder processAllCommands].	
	
		triggered should be: true
	 ] runWithMocks
	
	
]

{ #category : #tests }
TwyLayoutTests >> testHasZeroExtentByDefault [
	
	layout extent should equal: 0@0
]

{ #category : #tests }
TwyLayoutTests >> testIncreasingExtentByLongDeltaShouldIncreaseWidth [
	
	layout extent: 5@5.
	
	layout increaseExtentBy: 10@20.
	
	layout extent x should equal: 10
]

{ #category : #tests }
TwyLayoutTests >> testIncreasingExtentByShortDeltaShouldNotChangeWidth [
	
	layout extent: 5@5.
	
	layout increaseExtentBy: 3@20.
	
	layout extent x should equal: 5
]

{ #category : #tests }
TwyLayoutTests >> testIncreasingExtentShouldIncreaseHeight [
	
	layout extent: 5@5.
	
	layout increaseExtentBy: 10@20.
	
	layout extent y should equal: 25
]

{ #category : #tests }
TwyLayoutTests >> testInitializationOnTextShouldCreateLineFirstSpan [
	| firstSpan |
	[ :textModelOrRegion | 
	[ layout initializeOn: textModelOrRegion ] should lenient
		satisfy: [ textModelOrRegion newPassiveCursorAtStart willReturn: #startCursor ].
	firstSpan := layout topLine firstSpan.
	firstSpan should beInstanceOf: TwyLayoutSpan.
	firstSpan rightBorder should be: #startCursor.
	firstSpan line should be: layout topLine ] runWithMocks
]

{ #category : #tests }
TwyLayoutTests >> testInitializationOnTextShouldCreateTopLine [
	[ :textModelOrRegion | 
	[ layout initializeOn: textModelOrRegion ] should lenient
		satisfy: [ textModelOrRegion newPassiveCursorAtStart willReturn: #startCursor ].
	layout topLine should beInstanceOf: TwyLayoutLine.
	layout topLine layout should be: layout ] runWithMocks
]

{ #category : #tests }
TwyLayoutTests >> testInitializationOnTextShouldSetIt [

	[ :textModelOrRegion |

		[ layout initializeOn: textModelOrRegion]
			should lenient satisfy: 
		[ textModelOrRegion newPassiveCursorAtStart willReturn: #startCursor ].
	
		layout text should be: textModelOrRegion
	
	 ] runWithMocks
]

{ #category : #tests }
TwyLayoutTests >> testLineAtXYPoint [
	
	[:targetLine :topLine |
		layout topLine: topLine.
		
		[ (layout lineAt: #point) should be: targetLine ]
			should strictly satisfy: 
		[(topLine downDo: Any) will: [ :block | block value: topLine; value: targetLine ].
		(topLine containsPoint: #point) willReturn: false. 		
		(targetLine containsPoint: #point) willReturn: true ].
	
	] runWithMocks 		
]

{ #category : #tests }
TwyLayoutTests >> testLineAtXYPointWhenItOutOfText [
	
	[:lastLine :topLine |
		layout topLine: topLine.
		
		[ (layout lineAt: #point) should be: lastLine ]
			should strictly satisfy: 
		[(topLine downDo: Any) will: [ :block | block value: topLine; value: lastLine ].
		(topLine containsPoint: #point) willReturn: false. 		
		(lastLine containsPoint: #point) willReturn: false ].
	
	] runWithMocks 		
]

{ #category : #tests }
TwyLayoutTests >> testNewCursorCreation [

	[ :topLine  |
		layout topLine: topLine.
		[layout newCursor should be: #result]
			should lenient satisfy: 
		[ topLine newCursor willReturn: #result].
			
	 ] runWithMocks
]
