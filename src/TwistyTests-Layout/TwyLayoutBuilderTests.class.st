Class {
	#name : #TwyLayoutBuilderTests,
	#superclass : #TestCase,
	#instVars : [
		'builder',
		'layout',
		'layoutStrategy',
		'currentLine',
		'currentSpan'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyLayoutBuilderTests >> setUp [
	super setUp.

	layout := Mock new.
	layoutStrategy := Mock new.
	currentLine := Mock new.
	currentSpan := Mock new.
	currentSpan stub line willReturn: currentLine.
			
	builder := TwyLayoutBuilder new.
	builder 
		layout: layout;
		currentSpan: currentSpan;
		layoutStrategy: layoutStrategy
	
]

{ #category : #tests }
TwyLayoutBuilderTests >> testAddCorrectionCommandForLayoutSpan [
	builder commands: OrderedCollection new.
	builder addCorrectionCommandFor: #layoutSpan.
	builder commands should haveSize: 1.
	builder commands first should beInstanceOf: TwyCorrectSpanCommand.
	builder commands first span should be: #layoutSpan
]

{ #category : #tests }
TwyLayoutBuilderTests >> testAddLayoutCommandShouldBeOrdered [
	| command1 command2 command3 |
	command1 := Mock new.
	command2 := Mock new.
	command3 := Mock new.
	(command1 stub isEmbody: Any) willReturn: false.
	(command2 stub isEmbody: Any) willReturn: false.
	(command3 stub isEmbody: Any) willReturn: false.
	(command1 stub shouldBeExecutedBefore: command2) willReturn: false.
	(command1 stub shouldBeExecutedBefore: command3) willReturn: true.
	(command2 stub shouldBeExecutedBefore: command3) willReturn: true.
	builder
		addLayoutCommand: command1;
		addLayoutCommand: command2;
		addLayoutCommand: command3.
	builder commands should haveSize: 3.
	builder commands first should equal: command2.
	builder commands second should equal: command1.
	builder commands last should equal: command3
]

{ #category : #tests }
TwyLayoutBuilderTests >> testAddLayoutCommandShouldIgnoreItWhenItEmbodiedByExistedCommand [
	
	[:newCommand :similarCommand :anotherCommand1 :anotherCommand2 |
		builder commands: { anotherCommand1. similarCommand. anotherCommand2 }.
		[ builder addLayoutCommand: newCommand ]
			should lenient satisfy:
		[( anotherCommand1 isEmbody: newCommand) willReturn: false.
		(similarCommand isEmbody: newCommand) willReturn: true ].
	
		builder commands should not include: newCommand.
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testAddLayoutCommandShouldRemoveAllExistedCommandsWhichEmbodiedByGivenNewCommand [
	
	[:newCommand :existedCommand1 :existedCommand2 :existedCommand3 |
		builder commands: { existedCommand1. existedCommand2. existedCommand3 } asOrderedCollection.
		[ builder addLayoutCommand: newCommand ]
			should lenient satisfy:
		[( existedCommand1 isEmbody: newCommand) willReturn: false.
		(existedCommand2 isEmbody: newCommand) willReturn: false.
		( existedCommand3  isEmbody: newCommand) willReturn: false.
		
		( newCommand isEmbody: existedCommand1) willReturn: true.
		(newCommand isEmbody: existedCommand2 ) willReturn: false.
		( newCommand isEmbody: existedCommand3 ) willReturn: true].
	
		builder commands should include: newCommand.
		builder commands should include: existedCommand2.	
		builder commands should not include: existedCommand1.
		builder commands should not include: existedCommand3.
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testAddLayoutCommandWhenNoExistsYet [
	
	builder addLayoutCommand: #newCommand.
	
	builder commands should include: #newCommand
]

{ #category : #tests }
TwyLayoutBuilderTests >> testCompletingNewLine [

	[:lineFirstSpan |
		[builder completeNewLine]
			should strictly satisfy:
		[currentLine applyExtentToLayout.
		currentSpan newRightSpan willReturn: lineFirstSpan.
		lineFirstSpan avoidEndOfTextLine.
		currentSpan insertLineAtTheEnd willReturn: #newLine].
	
		builder currentLine should be: #newLine.
		builder currentSpan should be: lineFirstSpan
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testCompletingNewSpan [

	[
		[builder completeNewSpan]
			should strictly satisfy:
		[currentSpan applyExtentToLine].
			
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testCorrectLayoutSpan [

	[:existedSpan   |
		[builder correctLayoutOf: existedSpan]
			should strictly satisfy:
		[layoutStrategy correctLayoutOf: existedSpan].
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testCreationNewLayoutSpanForTextSpan [

	[:textSpan :newLayoutSpan |
		[builder newLayoutSpanFor: textSpan]
			should lenient satisfy: 
		[(textSpan createDrawerBy: builder) willReturn: #spanDrawer.
		 currentSpan newRightSpan willReturn: newLayoutSpan.
		newLayoutSpan avoidEndOfTextSpan.
		newLayoutSpan initializeWithDrawer: #spanDrawer.
		newLayoutSpan isTextSpansBorder willReturn: false ].
	
		builder currentSpan should be: newLayoutSpan 
	] runWithMocks 	

]

{ #category : #tests }
TwyLayoutBuilderTests >> testCreationNewLayoutSpanForTextSpanShouldBuildTextSpansBorder [

	[:textSpan :newLayoutSpan |
		[builder newLayoutSpanFor: textSpan]
			should lenient satisfy: 
		[(textSpan createDrawerBy: builder) willReturn: #spanDrawer.
		 currentSpan newRightSpan willReturn: newLayoutSpan.
		newLayoutSpan avoidEndOfTextSpan.
		newLayoutSpan initializeWithDrawer: #spanDrawer.
		newLayoutSpan isTextSpansBorder willReturn: true.
		newLayoutSpan newRightSpan willReturn: #actualLayoutSpan ].
	
		builder currentSpan should be: #actualLayoutSpan
	] runWithMocks 	

]

{ #category : #tests }
TwyLayoutBuilderTests >> testHasEmptyCommandsByDefault [
	
	builder commands should be isEmpty
]

{ #category : #tests }
TwyLayoutBuilderTests >> testIsAtLayoutEndWhenCurrentSpanIsLayoutEnd [

	currentSpan stub isLayoutEnd willReturn: #result.
	
	builder isAtLayoutEnd should be: #result
]

{ #category : #tests }
TwyLayoutBuilderTests >> testLayoutSpan [

	[
		[builder layoutNewTextSpan]
			should strictly satisfy:
		[layoutStrategy layoutNewTextSpanStartingAt: currentSpan by: builder].
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testLayoutText [

	[:textModel :eachElement :textStart :textEnd |
	
		[builder layoutText: textModel]
			should strictly satisfy:
		[textModel start willReturn: textStart.
		textModel end willReturn: textEnd.
		currentSpan applyExtentToLine.
		(textStart forwardDo: Any while: Any ) 
			will: [:actionBlock :conditionBlock | actionBlock value: eachElement].
		(eachElement layoutContentsBy: builder).
		currentLine applyExtentToLayout.	
		layout alignLines]	
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testLayoutTextBetweenTwoElements [

	[:startElement :endElement :eachElement |
				
		[builder layoutTextBetween: startElement and: endElement]
			should strictly satisfy:
		[currentSpan applyExtentToLine.
		(startElement forwardDo: Any while: Any ) 
			will: [:actionBlock :conditionBlock | actionBlock value: eachElement].
		(eachElement layoutContentsBy: builder)]
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testLayoutTextBetweenTwoElementsShouldStopAtEndElement [

	[:startElement :endElement |
	
		[builder layoutTextBetween: startElement and: endElement]
			should strictly satisfy:
		[currentSpan applyExtentToLine.
		(startElement forwardDo: Any while: Any ) will: [:actionBlock :conditionBlock | 
			(conditionBlock value: endElement) should be: false]]
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testRestoreSpanCorruptedByChange [

	[:textChange |
		[builder restoreSpanCorruptedBy: textChange]
			should strictly satisfy:
		[textChange correctAffectedLayoutSpansStartingAt: currentSpan by: builder]
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testSetUpNextSpanWhenItAbsent [

	[
		[builder setUpNextSpan]
			should strictly satisfy:
		[currentSpan rightSpan willReturn: nil].
	
		builder currentLine should be: currentLine.
		builder currentSpan should be: nil
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testSetUpNextSpanWhenItIsInvalidTextSpansBorder [

	[:nextSpan :textSpansBorder |
		[builder setUpNextSpan]
			should strictly satisfy:
		[currentSpan rightSpan willReturn: nextSpan.
		nextSpan isTextSpansBorder willReturn: true; useArbitrarily.
		nextSpan isValidTextSpansBorder willReturn: false.
		currentSpan newRightSpan willReturn: textSpansBorder.
		textSpansBorder avoidEndOfTextSpan.
		nextSpan avoidEndOfLine.
		].
	
		builder currentLine should be: currentLine.
		builder currentSpan should be: nextSpan
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testSetUpNextSpanWhenItIsNotTextSpansBorder [

	[:nextSpan |
		[builder setUpNextSpan]
			should strictly satisfy:
		[currentSpan rightSpan willReturn: nextSpan.
		nextSpan isTextSpansBorder willReturn: false; useArbitrarily].
	
		builder currentLine should be: currentLine.
		builder currentSpan should be: nextSpan
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testSetUpNextSpanWhenItIsValidTextSpansBorder [

	[:nextSpan |
		[builder setUpNextSpan]
			should strictly satisfy:
		[currentSpan rightSpan willReturn: nextSpan.
		nextSpan isTextSpansBorder willReturn: true; useArbitrarily.
		nextSpan isValidTextSpansBorder willReturn: true.
		nextSpan avoidEndOfLine].
	
		builder currentLine should be: currentLine.
		builder currentSpan should be: nextSpan
	
	] runWithMocks 
]

{ #category : #tests }
TwyLayoutBuilderTests >> testUpdatingDrawerForSpan [

	[:layoutSpan :textSpan |
		[builder updateDrawerFor: layoutSpan]
			should strictly satisfy:
		[layoutSpan textSpan willReturn: textSpan.
		(textSpan createDrawerBy: builder) willReturn: #drawer.
		layoutSpan initializeWithDrawer: #drawer.
		layoutSpan recomputeExtent].
			
	] runWithMocks 
]
