"
I layout text models by applying layout strategy.
I can build full text layout and restore existed layout after text changes.

I restore broken layouts by sequentially enumarating lines and spans and applying restoring commands for broken layout elements. During this algorithm only broken parts of layout recompute extents by scanning underlying text regions. Other layout elements just fixes there positions.
Algorithm started with collection of TwyProcessTextChangeCommand's. This commands can fix underlying layout spans by recomputing extent to cover correctly text regions. They can build new layout region if new text was inserted. They can remove layout region if text region was removed. At the end commands can produce another commands. Commands are always sorted by text place they cover. So algorithm can continue after new commands appended. 
In most cases at the end of any command TwyCorrectSpanCommand added for next layout span. It is repeated after each command on currently broken text line. To not generate garbage of TwyCorrectSpanCommand objects TwyCorrectSpanCommand just change they state for the next span and readded itself to commands list.

Commands and text changes (TwyTextStateChanged) implements number of testing methods to ensure ordering of commands. See there protocols.

Instance Variables
	layout:		<TwyLayout>
	currentLine:		<TwyLayoutLine>
	currentSpan:		<TwyLayoutSpan>	
	layoutStrategy:		<TwyLayoutStrategy>
	commands: <(SortedCollection of: <TwyLayoutBuiltCommand>)>

"
Class {
	#name : #TwyLayoutBuilder,
	#superclass : #Object,
	#instVars : [
		'layout',
		'layoutStrategy',
		'commands',
		'currentLine',
		'currentSpan'
	],
	#category : #'Twisty-Layout'
}

{ #category : #'instance creation' }
TwyLayoutBuilder class >> for: aLayout [
	^self new 
		layout: aLayout
]

{ #category : #accessing }
TwyLayoutBuilder >> addCorrectionCommandFor: aLayoutSpan [
	
	self addLayoutCommand: (TwyCorrectSpanCommand span: aLayoutSpan )
]

{ #category : #accessing }
TwyLayoutBuilder >> addLayoutCommand: aLayoutBuiltCommand [ 

	(commands anySatisfy: [ :each | each isEmbody: aLayoutBuiltCommand ]) 
		ifTrue: [^self].
	(commands removeAllSuchThat: [ :each | aLayoutBuiltCommand isEmbody: each ]).
	
	commands add: aLayoutBuiltCommand 
]

{ #category : #accessing }
TwyLayoutBuilder >> commands [
	
	^ commands
]

{ #category : #accessing }
TwyLayoutBuilder >> commands: anObject [
	
	commands := anObject
]

{ #category : #'building layout' }
TwyLayoutBuilder >> completeNewLine [ 
"
	We should insert new line with empty span imported from current line.
	If this new layout span is at end of text span we should move it to start of next text span
"
	| newLine newLineFirstSpan |
	currentLine applyExtentToLayout.
	
	newLineFirstSpan := currentSpan newRightSpan.
	newLineFirstSpan avoidEndOfTextLine.
	
	newLine := currentSpan insertLineAtTheEnd.

	currentLine := newLine.
	currentSpan := newLineFirstSpan.
	^currentSpan
]

{ #category : #'building layout' }
TwyLayoutBuilder >> completeNewSpan [
	currentSpan applyExtentToLine.
	 
]

{ #category : #'building layout' }
TwyLayoutBuilder >> correctLayoutOf: aLayoutSpan [
	
	layoutStrategy correctLayoutOf: aLayoutSpan
]

{ #category : #accessing }
TwyLayoutBuilder >> currentLine [
	^ currentLine
]

{ #category : #accessing }
TwyLayoutBuilder >> currentLine: anObject [
	currentLine := anObject
]

{ #category : #accessing }
TwyLayoutBuilder >> currentSpan [
	^ currentSpan
]

{ #category : #accessing }
TwyLayoutBuilder >> currentSpan: aLayoutSpan [
	currentSpan := aLayoutSpan.
	currentLine := currentSpan ifNotNil: [ currentSpan line]
]

{ #category : #'building layout' }
TwyLayoutBuilder >> findNextSpanAtCurrentLineFor: aLayoutCommand [

	currentSpan 
		rightDo: [ :eachSpan | currentSpan fixOffset. currentSpan applyExtentToLine ]
		while: [ :eachSpan | currentSpan := eachSpan. 
			currentSpan line = currentLine and: [(aLayoutCommand isActiveAtSpan: eachSpan) not] ].	

	^currentSpan line = currentLine and: [aLayoutCommand isActiveAtSpan: currentSpan]
]

{ #category : #'initialize-release' }
TwyLayoutBuilder >> initialize [ 
	super initialize.
	
	commands := SortedCollection sortBlock: [:c1 :c2 | 
		c1 shouldBeExecutedBefore: c2 ]
]

{ #category : #testing }
TwyLayoutBuilder >> isAtLayoutEnd [
	^currentSpan isLayoutEnd
]

{ #category : #accessing }
TwyLayoutBuilder >> layout [
	^ layout
]

{ #category : #accessing }
TwyLayoutBuilder >> layout: anObject [
	layout := anObject
]

{ #category : #'building layout' }
TwyLayoutBuilder >> layoutNewTextSpan [	
	
	layoutStrategy layoutNewTextSpanStartingAt: currentSpan by: self
	
]

{ #category : #accessing }
TwyLayoutBuilder >> layoutStrategy [
	^ layoutStrategy
]

{ #category : #accessing }
TwyLayoutBuilder >> layoutStrategy: anObject [
	layoutStrategy := anObject
]

{ #category : #'building layout' }
TwyLayoutBuilder >> layoutText: aText [
	
	self layoutTextBetween: aText start and: aText end. 
	
	currentLine applyExtentToLayout.
	layout alignLines.

	^layout
]

{ #category : #'building layout' }
TwyLayoutBuilder >> layoutTextBetween: startElement and: endElement [
	
	self completeNewSpan.
	
	startElement forwardDo: [:eachElement |
		
		eachElement layoutContentsBy: self.
		
	] while: [:eachElement | (eachElement = endElement) not].
	
	
]

{ #category : #'building layout' }
TwyLayoutBuilder >> moveNewTextSpanToNewLine [ 
"
	current span is start of new text span. I should create new line and move current span to it. If current span has text spans border at the left I should move it too. 
"
	| newLine  |
		
	newLine := currentSpan migrateToNewLine.
	
	currentLine applyExtentToLayout.
	currentLine := newLine
]

{ #category : #'building layout' }
TwyLayoutBuilder >> newLayoutSpanFor: aTextSpan [ 

	| drawer |
	currentSpan := currentSpan newRightSpan.
	currentSpan avoidEndOfTextSpan.
	drawer := aTextSpan createDrawerBy: self.	
	currentSpan initializeWithDrawer: drawer.
	
	"border should be always between two text spans"
	currentSpan isTextSpansBorder ifTrue: [ currentSpan := currentSpan newRightSpan ]
]

{ #category : #'building layout' }
TwyLayoutBuilder >> prepareCommands [

	commands do: [ :each | each correctState ].
	
	commands removeAllSuchThat: [ :each | each isRedundant ]
]

{ #category : #'building layout' }
TwyLayoutBuilder >> processAllCommands [

	| currentCommand |
	layout resetExtent.
	currentLine :=layout topLine.
	currentLine fixPosition.
	currentSpan := nil.

	[commands isEmpty] whileFalse: [
		currentCommand := commands first.
		currentCommand correctState.
		commands removeFirst.	
		self processNextCommand: currentCommand.
		self skipDeletedSpans ].

	currentLine ifNotNil: [ self processNextCommand: TwyCompleteLayoutCommand new].
	layout alignLines
]

{ #category : #'building layout' }
TwyLayoutBuilder >> processNextCommand: currentCommand [

	currentCommand isRedundant ifTrue: [ ^self ].

	currentSpan ifNotNil: [			
		(self findNextSpanAtCurrentLineFor: currentCommand)
			ifTrue: [ ^currentCommand executeBy: self ]
			ifFalse: [ currentSpan := nil ].
	 ].

	currentLine 
		downDo: [:eachLine | currentLine fixPosition. currentLine applyExtentToLayout	] 
		while: [:eachLine | currentLine := eachLine. (currentCommand isActiveAtLine: eachLine) not].
		
	currentLine resetExtent.
	currentSpan := currentLine firstSpan.
	(self findNextSpanAtCurrentLineFor: currentCommand) ifFalse: [
		currentCommand class == TwyCompleteLayoutCommand ifFalse: [self error: 'should not happen']].
		
	currentCommand executeBy: self
]

{ #category : #'building layout' }
TwyLayoutBuilder >> restoreSpanCorruptedBy: aTextChange [
	aTextChange correctAffectedLayoutSpansStartingAt: currentSpan by: self
]

{ #category : #'building layout' }
TwyLayoutBuilder >> selectFontFor: aCharactersSpan [

	^aCharactersSpan getAttribute: TwyFontAttribute
]

{ #category : #'building layout' }
TwyLayoutBuilder >> setUpNextSpan [

	| nextSpan |
	nextSpan := currentSpan rightSpan ifNil: [^currentSpan := nil].
	
	(nextSpan isTextSpansBorder and: [ nextSpan isValidTextSpansBorder not]) ifTrue: [ 
		currentSpan := currentSpan newRightSpan.
		currentSpan avoidEndOfTextSpan.		
	].
	
	currentSpan := nextSpan.
	
	currentSpan isTextSpansBorder ifTrue: [ currentSpan avoidEndOfLine ]
]

{ #category : #'building layout' }
TwyLayoutBuilder >> skipDeletedSpans [
	currentSpan ifNil: [ ^self ].
	
	currentSpan := currentSpan findLiveSpanFromRight.
	
	currentSpan ifNil: [ 
		currentLine isDeleted ifFalse: [ 
			currentLine fixPosition. currentLine applyExtentToLayout ].
		currentLine := nil.
		^self ].
	
	currentSpan line = currentLine ifTrue: [ ^self ].
	
	currentLine isDeleted ifFalse: [ 
		currentLine fixPosition. currentLine applyExtentToLayout ].
	
	currentLine := currentSpan line.
	currentLine resetExtent.
	
]

{ #category : #'building layout' }
TwyLayoutBuilder >> updateDrawerFor: aLayoutSpan [

	| drawer |
	drawer := aLayoutSpan textSpan createDrawerBy: self.	
	aLayoutSpan 
		initializeWithDrawer: drawer;
		recomputeExtent
]
