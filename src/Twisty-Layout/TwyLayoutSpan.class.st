"
I am part of visual layout line. I cover interval of text span and contain it precomputed propertes like extent and offset from line start.

I know my left and right neighbour spans. I have right border of my underlying text (it is instance of TwyPassiveTextCursor). My left border is right border of my left span. Left and right borders define text region which I cover.
When my left and right borders points to different spans I become text spans border. You can ask me about it:
	layoutSpan isTextSpansBorder
I have drawer to compute extent and draw my text region. It is created during building layout algorithm.

    Instance Variables
	line:		<TwyLayoutLine>
	leftSpan:		<TwyLayoutSpan>
	rightSpan:		<TwyLayoutSpan>
	rightBorder:		<TwyPassiveTextCursor>
	drawer:		<TwySpanDrawer>
	extent:		<Point>	
	offset:		<Number>
	
extent
	- width@height of text region

offset
	- offset from line start. It is not includes own line offset


"
Class {
	#name : #TwyLayoutSpan,
	#superclass : #Object,
	#instVars : [
		'line',
		'leftSpan',
		'rightSpan',
		'rightBorder',
		'drawer',
		'offset',
		'extent'
	],
	#category : #'Twisty-Layout'
}

{ #category : #navigation }
TwyLayoutSpan >> aboveLine [ 
	^line aboveLine
]

{ #category : #controlling }
TwyLayoutSpan >> applyExtentToLine [ 
	line increaseExtentBy: extent
]

{ #category : #controlling }
TwyLayoutSpan >> avoidEndOfLine [

	self isFirstAtLine ifTrue: [ ^self ].
	self isLastAtLine ifFalse: [ ^self ].
	
	self belowLine ifNotNil: [:l |
		line := l.
		line firstSpan: self]
]

{ #category : #controlling }
TwyLayoutSpan >> avoidEndOfTextLine [

	rightBorder isAtLineEnd ifFalse: [^self].
	
	rightBorder moveToStartOfNextSpan
	
]

{ #category : #controlling }
TwyLayoutSpan >> avoidEndOfTextSpan [

	(rightBorder isAtSpanEnd and: [ rightBorder isAtLineEnd not ]) ifFalse: [^self].
	
	rightBorder moveToStartOfNextSpan
	
]

{ #category : #controlling }
TwyLayoutSpan >> avoidStartOfTextSpan [

	(rightBorder isAtSpanStart and: [ rightBorder isAtLineStart not ]) ifFalse: [^self].
	
	rightBorder moveToEndOfPreviousSpan
]

{ #category : #navigation }
TwyLayoutSpan >> belowLine [ 
	^line belowLine
]

{ #category : #controlling }
TwyLayoutSpan >> cleanUpRedundantNeighbours [

	self isTextSpansBorder ifTrue: [ ^self].
	
	[self isLayoutEnd not and: [ (rightSpan isCoversSameTextSpanAs: self) and: [ rightSpan isEmpty]]]
		whileTrue: [ rightSpan delete ]
]

{ #category : #computing }
TwyLayoutSpan >> computeLayoutPositionOf: aTextCursor [

	| iteratorOffset |
	iteratorOffset := offset + line topLeftPosition x.
	
	(self leftBorder selectTextUpTo: aTextCursor) itemsDo: [:spanItem |
		iteratorOffset := iteratorOffset + (drawer widthOf: spanItem)
	].

	^iteratorOffset @ line topLeftPosition y
]

{ #category : #testing }
TwyLayoutSpan >> contains: aTextCursor [ 
	
	((rightBorder isAtSpanAfter: aTextCursor) or: [ rightBorder isAtSamePositionWith: aTextCursor ]) ifFalse: [ ^false ].
	((self leftBorder isAtSpanBefore: aTextCursor) or: [ self leftBorder isAtSamePositionWith: aTextCursor ]) ifFalse: [ ^false ].
	^true 
]

{ #category : #controlling }
TwyLayoutSpan >> correctSpansRemovedBy: aTextChange [

	| currentSpan nextSpan shouldDeleteCurrentSpan |
	
	currentSpan := rightSpan.
	shouldDeleteCurrentSpan := aTextChange isRemoveLayoutSpan: currentSpan.
	
	[shouldDeleteCurrentSpan ]
		whileTrue: [	
			nextSpan := currentSpan rightSpan.
			shouldDeleteCurrentSpan := nextSpan notNil and: [aTextChange isRemoveLayoutSpan: nextSpan].
			currentSpan delete.
			currentSpan := nextSpan].

	aTextChange correctFirstRemovedLayoutSpan: self
]

{ #category : #controlling }
TwyLayoutSpan >> delete [
		
	self isFirstAtLine ifTrue: [ 
		self isSingleAtLine
			ifTrue: [ line delete ] 
			ifFalse: [ line firstSpan: rightSpan ]
	].
	
	self isLayoutStart ifFalse: [ leftSpan rightSpan: rightSpan].
	self isLayoutEnd ifFalse: [ rightSpan leftSpan: leftSpan].
	
]

{ #category : #drawing }
TwyLayoutSpan >> drawOn: aCanvas at: aPoint within: lineExtent [

	drawer ifNil: [ ^self ].
	
	drawer 
		drawSpanFrom: self leftBorder 
		to: self rightBorder
		on: aCanvas 
		at: aPoint + (offset @ (lineExtent y - drawer height))
]

{ #category : #accessing }
TwyLayoutSpan >> drawer [
	^ drawer
]

{ #category : #accessing }
TwyLayoutSpan >> drawer: aTwySpanDrawer [

	drawer := aTwySpanDrawer
]

{ #category : #accessing }
TwyLayoutSpan >> extent [
	^ extent
]

{ #category : #accessing }
TwyLayoutSpan >> extent: anObject [
	extent := anObject
]

{ #category : #controlling }
TwyLayoutSpan >> fetchTextCursor [
	^self leftBorder asActiveCursor
]

{ #category : #controlling }
TwyLayoutSpan >> findFirstSpanRemovedBy: aTextChange [

	| firstRemovedSpan |

	firstRemovedSpan := self.
	[aTextChange isRemoveLayoutSpan: firstRemovedSpan]
		whileFalse: [firstRemovedSpan := firstRemovedSpan rightSpan].
	
	^firstRemovedSpan
]

{ #category : #accessing }
TwyLayoutSpan >> findLiveSpanFromLeft [

	^self leftDetect: [ :each | each isDeleted not ] ifAbsent: [ nil ] .

]

{ #category : #accessing }
TwyLayoutSpan >> findLiveSpanFromRight [
	
	^self rightDetect: [ :each | each isDeleted not ] ifAbsent: [ nil ] .
]

{ #category : #controlling }
TwyLayoutSpan >> fixOffset [
	self isFirstAtLine ifTrue: [ 
		offset :=0.
		^self ].
	
	offset := leftSpan rightBorderOffset
]

{ #category : #controlling }
TwyLayoutSpan >> fixRightBorder [

	self isLastAtTextSpan ifTrue: [ ^rightBorder moveToSpanEnd].
		
	rightBorder isValid ifFalse: [ ^rightBorder moveToSpanEnd ]
]

{ #category : #accessing }
TwyLayoutSpan >> height [
	^extent y
]

{ #category : #controlling }
TwyLayoutSpan >> importNextSpanToLine [

	rightSpan ifNil: [ ^self ].
	(rightSpan isTextSpansBorder and: [rightSpan isAtStartOfTextLine]) ifTrue: [ ^self ].
	
	rightSpan migrateTo: line.
	
	rightSpan isTextSpansBorder ifTrue: [ rightSpan importNextSpanToLine]
]

{ #category : #controlling }
TwyLayoutSpan >> increaseFromLeftBy: delta [

	self isTextSpansBorder ifFalse: [ 
		extent := extent x + delta @ extent y].
	
	offset := offset - delta max: 0
]

{ #category : #'initialize-release' }
TwyLayoutSpan >> initialize [
	super initialize.
	
	offset := 0.
	extent := 0@0
]

{ #category : #'initialize-release' }
TwyLayoutSpan >> initializeWithDrawer: aSpanDrawer [
	self drawer: aSpanDrawer.
	extent := drawer initialExtent
]

{ #category : #controlling }
TwyLayoutSpan >> insertLineAtTheEnd [

	| newLine |
	newLine := line newBelowLine.
	rightSpan ifNotNil: [ 
		newLine importSpansFrom: line startedWith: rightSpan].
	^newLine
]

{ #category : #testing }
TwyLayoutSpan >> isAtEndOfTextLine [
	^rightBorder isAtLineEnd
]

{ #category : #testing }
TwyLayoutSpan >> isAtEndOfTextSpan [
	^rightBorder isAtSpanEnd 
]

{ #category : #testing }
TwyLayoutSpan >> isAtSameLineWith: aLayoutSpan [
	^line == aLayoutSpan line
]

{ #category : #testing }
TwyLayoutSpan >> isAtStartOfLine [

	self isFirstAtLine ifTrue: [ ^true ].
	
	^leftSpan isTextSpansBorder and: [leftSpan isFirstAtLine]
]

{ #category : #testing }
TwyLayoutSpan >> isAtStartOfTextLine [
	^rightBorder isAtLineStart
]

{ #category : #testing }
TwyLayoutSpan >> isAtStartOfTextSpan [
	^rightBorder isAtSpanStart
]

{ #category : #testing }
TwyLayoutSpan >> isBetweenTextElement: leftElement and: rightElement [

	self isTextSpansBorder ifTrue: [ 
		^(self leftBorder isAfterOrAtEndOfElement: leftElement) and: [ rightBorder isBeforeOrAtStartOfElement: rightElement ] ].
	
	^(self leftBorder isAfterElement: leftElement) and: [rightBorder isBeforeElement: rightElement]

]

{ #category : #testing }
TwyLayoutSpan >> isCoverOnlyTextSpan [

	^rightBorder isAtSameSpanWith: self leftBorder
]

{ #category : #testing }
TwyLayoutSpan >> isCoverWholeTextSpan [

	^self isAtEndOfTextSpan and: [ leftSpan isAtEndOfTextSpan ]
]

{ #category : #testing }
TwyLayoutSpan >> isCovers: aTwyElement [ 

	^aTwyElement isCoveredByLayoutSpan: self
]

{ #category : #testing }
TwyLayoutSpan >> isCovers: aTextElement afterPosition: spanPosition [
	^(self isCovers: aTextElement) and: [ rightBorder isAfterPosition: spanPosition atSpan: aTextElement ]
]

{ #category : #testing }
TwyLayoutSpan >> isCovers: aTextElement atOrAfterPosition: spanPosition [
	^(self isCovers: aTextElement) and: [ (rightBorder isBeforePosition: spanPosition atSpan: aTextElement) not ]
]

{ #category : #testing }
TwyLayoutSpan >> isCovers: aTextElement beforePosition: spanPosition [
	^(self isCovers: aTextElement) and: [ rightBorder isBeforePosition: spanPosition atSpan: aTextElement ]
]

{ #category : #testing }
TwyLayoutSpan >> isCoversLineStart: aTwyLineStart [
	
	self isTextSpansBorder ifFalse: [ ^false ].
	^self textSpan previous = aTwyLineStart
]

{ #category : #testing }
TwyLayoutSpan >> isCoversSameTextSpanAs: aLayoutSpan [

	^rightBorder isAtSameSpanWith: aLayoutSpan rightBorder	
]

{ #category : #testing }
TwyLayoutSpan >> isCoversSpan: aTwySpan [

	^rightBorder isAt: aTwySpan
]

{ #category : #testing }
TwyLayoutSpan >> isCoversTextChangedBy: aTextChange [

	^aTextChange isAffectTextAt: rightBorder
]

{ #category : #testing }
TwyLayoutSpan >> isDeleted [
	self isLayoutEnd ifFalse: [ ^rightSpan leftSpan ~= self].
	self isLayoutStart ifTrue: [ ^false ].
	^leftSpan rightSpan ~= self
]

{ #category : #testing }
TwyLayoutSpan >> isEmpty [
	
	^rightBorder isAtSamePositionWith: self leftBorder
]

{ #category : #testing }
TwyLayoutSpan >> isFirstAtLine [
	self isLayoutStart ifTrue: [ ^true ].
	
	^(self isAtSameLineWith: leftSpan) not
]

{ #category : #testing }
TwyLayoutSpan >> isFirstAtTextSpan [
"	leftSpan ifNil: [ ^true ]."
	^self isTextSpansBorder
"	^(leftSpan isCoversSameTextSpanAs: self) not"
]

{ #category : #testing }
TwyLayoutSpan >> isFirstSpanWhichCovers: aTextElement [

	(self textSpan isAfter: aTextElement) ifFalse: [ 
		(self isCovers: aTextElement) ifFalse: [ ^false ].
		^self isLayoutStart or: [ (leftSpan isCovers: aTextElement) not ]	
	 ].

	^leftSpan isNil or: [leftSpan textSpan isBefore: aTextElement]
]

{ #category : #testing }
TwyLayoutSpan >> isLastAtLine [
	self isLayoutEnd ifTrue: [ ^true ].
	
	^(self isAtSameLineWith: rightSpan) not
]

{ #category : #testing }
TwyLayoutSpan >> isLastAtTextSpan [
	
	self isLayoutEnd ifTrue: [ ^true ].
	
	^(rightSpan isCoversSameTextSpanAs: self) not
]

{ #category : #testing }
TwyLayoutSpan >> isLastSpanWhichCovers: aTextSpan [

	(self isCovers: aTextSpan) ifFalse: [ ^false ].
	^self isLayoutEnd or: [ (rightSpan isCovers: aTextSpan) not ]
]

{ #category : #testing }
TwyLayoutSpan >> isLayoutEnd [
	^rightSpan isNil
]

{ #category : #testing }
TwyLayoutSpan >> isLayoutStart [
	^leftSpan isNil
]

{ #category : #testing }
TwyLayoutSpan >> isOnlySpanRemovedBy: aTextChange [

	(aTextChange isRemoveLayoutSpan: self) ifFalse: [ ^false ].
	(self isLayoutEnd not and: [aTextChange isRemoveLayoutSpan: rightSpan]) ifTrue: [ ^false ].
	(self isLayoutStart not and: [aTextChange isRemoveLayoutSpan: leftSpan]) ifTrue: [ ^false ].
	
	^true
]

{ #category : #testing }
TwyLayoutSpan >> isOverlaidLineAtX: xPosition [ 
	^xPosition between: offset and: offset + extent x
]

{ #category : #testing }
TwyLayoutSpan >> isPlacedAfter: anotherLayoutSpan [
	
	^self leftBorder isAfter: anotherLayoutSpan rightBorder
]

{ #category : #testing }
TwyLayoutSpan >> isPlacedBeforeTextChange: aTextChange [
	^aTextChange isAfter: rightBorder
]

{ #category : #testing }
TwyLayoutSpan >> isSingleAtLine [
	(self isLayoutStart not and: [leftSpan isAtSameLineWith: self]) ifTrue: [ ^false ].
	
	(self isLayoutEnd not and:  [ rightSpan isAtSameLineWith: self]) ifTrue: [ ^false ].
	
	^true
]

{ #category : #testing }
TwyLayoutSpan >> isSingleAtTextSpan [

	(self isLayoutStart not and: [leftSpan isCoversSameTextSpanAs: self]) ifTrue: [ ^false ].
	(self isLayoutEnd not and: [rightSpan isCoversSameTextSpanAs: self]) ifTrue: [ ^false ].
	
	^true
	
]

{ #category : #testing }
TwyLayoutSpan >> isTextSpansBorder [
	self isLayoutStart ifTrue:  [ ^true ].
	
	^self isCoverOnlyTextSpan not
]

{ #category : #testing }
TwyLayoutSpan >> isValidTextSpansBorder [
	self isTextSpansBorder ifFalse: [ ^false ].
	
	^self leftBorder isAtSpanEnd and: [ rightBorder isAtSpanStart ]
]

{ #category : #accessing }
TwyLayoutSpan >> layout [
	^line layout
]

{ #category : #accessing }
TwyLayoutSpan >> leftBorder [
	
	leftSpan ifNil: [
		"it can happen on first span at layout. First span is always empty. So left border is same as right border"
		 ^rightBorder ].
	
	^leftSpan rightBorder
]

{ #category : #accessing }
TwyLayoutSpan >> leftDetect: predicateBlock ifAbsent: absentBlock [

	self leftDo: [:each | (predicateBlock value: each) ifTrue: [ ^each ] ].
	
	^absentBlock value

]

{ #category : #accessing }
TwyLayoutSpan >> leftDo: actionBlock [ 
	self leftDo: actionBlock while: [:each | true]

]

{ #category : #accessing }
TwyLayoutSpan >> leftDo: actionBlock while: conditionBlock [

	| current |
	current := self.
	[current notNil and:  [conditionBlock value: current] ] whileTrue: [ 
		actionBlock value: current.
		current := current leftSpan]
]

{ #category : #accessing }
TwyLayoutSpan >> leftSpan [
	^leftSpan
]

{ #category : #accessing }
TwyLayoutSpan >> leftSpan: anObject [
	
	leftSpan := anObject
]

{ #category : #accessing }
TwyLayoutSpan >> line [
	^ line
]

{ #category : #accessing }
TwyLayoutSpan >> line: anObject [
	line := anObject
]

{ #category : #controlling }
TwyLayoutSpan >> migrateTo: aLayoutLine [

	line == aLayoutLine ifTrue: [ ^self ].
	
	offset := aLayoutLine extent x.
	line removeSpan: self.
	line := aLayoutLine
]

{ #category : #controlling }
TwyLayoutSpan >> migrateToNewLine [

	| newLine |
	newLine := leftSpan insertLineAtTheEnd.
	leftSpan isTextSpansBorder ifTrue: [ 
		leftSpan migrateTo: newLine. 
		newLine firstSpan: leftSpan ].

	^newLine.
]

{ #category : #controlling }
TwyLayoutSpan >> moveBorderToEndOf: aTextSpan [

	rightBorder moveToEndOf: aTextSpan
]

{ #category : #controlling }
TwyLayoutSpan >> moveBorderToStartOf: aTextSpan [

	rightBorder moveToStartOf: aTextSpan
]

{ #category : #navigation }
TwyLayoutSpan >> moveLayoutCursor: aLayoutCursor leftToSpanWith: aTextCursor [

	| startSpan |
	startSpan := self findLiveSpanFromRight ifNil: [leftSpan].
	
	startSpan = self ifFalse: [ 
		^startSpan moveLayoutCursor: aLayoutCursor leftToSpanWith: aTextCursor  ].
	
	startSpan moveLayoutCursor: aLayoutCursor leftToSpanWith: aTextCursor ifNotFound:
		[rightSpan moveLayoutCursor: aLayoutCursor rightToSpanWith: aTextCursor ifNotFound: 
			[self error: 'Cant move layout cursor to given text cursor']]
]

{ #category : #navigation }
TwyLayoutSpan >> moveLayoutCursor: aLayoutCursor leftToSpanWith: aTextCursor ifNotFound: notFoundBlock [
	
	self leftDo: [ :each | 
		(aTextCursor isInsideLayoutSpan: each) ifTrue: [ ^ aLayoutCursor movedToSpan: each]
	]. 

	notFoundBlock value
]

{ #category : #navigation }
TwyLayoutSpan >> moveLayoutCursor: aLayoutCursor rightToSpanWith: aTextCursor [

	| startSpan |
	
	startSpan := self findLiveSpanFromLeft ifNil: [rightSpan].
	
	startSpan = self ifFalse: [ 
		^startSpan moveLayoutCursor: aLayoutCursor rightToSpanWith: aTextCursor  ].
	
	
	self moveLayoutCursor: aLayoutCursor rightToSpanWith: aTextCursor ifNotFound:
		[leftSpan moveLayoutCursor: aLayoutCursor leftToSpanWith: aTextCursor ifNotFound: 
			[self error: 'Cant move layout cursor to given text cursor']]
]

{ #category : #navigation }
TwyLayoutSpan >> moveLayoutCursor: aLayoutCursor rightToSpanWith: aTextCursor ifNotFound: notFoundBlock [
	
	self rightDo: [ :each | 
		(aTextCursor isInsideLayoutSpan: each) ifTrue: [ ^ aLayoutCursor movedToSpan: each]
	]. 

	notFoundBlock value
]

{ #category : #navigation }
TwyLayoutSpan >> moveTextCursor: aTextCursor insideAtOffset: offsetFromLineStart [ 

	| currentOffset currentItem itemWidth |
	
	currentOffset := offset + line topLeftPosition x.
		
	currentOffset + extent x < offsetFromLineStart ifTrue: [^aTextCursor moveTo: rightBorder].		
	currentOffset >= offsetFromLineStart ifTrue: [^aTextCursor moveTo: self leftBorder].

	itemWidth := 0.
	aTextCursor moveTo: self leftBorder.
	
	[currentOffset <= offsetFromLineStart & (aTextCursor isAtSamePositionWith: rightBorder) not] whileTrue: [
		currentItem := aTextCursor nextItemAtSpan.
		itemWidth := drawer widthOf: currentItem.		
		currentOffset := currentOffset + itemWidth.
		aTextCursor moveForward].
	
	currentOffset - offsetFromLineStart > (itemWidth // 2) ifTrue: [
		aTextCursor moveBackward]
]

{ #category : #controlling }
TwyLayoutSpan >> newRightSpan [

	| newSpan |
	newSpan := TwyLayoutSpan new.
	newSpan 
		line: line;
		rightBorder: rightBorder copy;
		drawer: drawer;
		extent: 0 @ self height;
		offset: self width + offset.
	rightSpan ifNotNil: [ 
		newSpan rightSpan: rightSpan.
		rightSpan leftSpan: newSpan].	
	rightSpan := newSpan.
	newSpan leftSpan: self.
	^newSpan
]

{ #category : #accessing }
TwyLayoutSpan >> offset [
	^ offset
]

{ #category : #accessing }
TwyLayoutSpan >> offset: anObject [
	offset := anObject
]

{ #category : #controlling }
TwyLayoutSpan >> offsetIncreasedBy:	deltaX [
	 
	offset := offset + deltaX
]

{ #category : #printing }
TwyLayoutSpan >> printContentsOn: aStream [ 

	self leftBorder printTextOn: aStream upTo: rightBorder
]

{ #category : #printing }
TwyLayoutSpan >> printOn: aStream [ 

	rightBorder ifNil: [
		super printOn: aStream.
		aStream nextPutAll: '(uninitialized)'.
		^self].
	
	self isLayoutStart
		ifTrue: [ aStream nextPutAll: 'LayoutStart'. ^self ].
	
	self isTextSpansBorder
		ifTrue: [ aStream nextPutAll: 'LayoutBorderBetweenTextSpans'. ^self ].
		
	aStream nextPutAll: 'L'.
	self isLayoutEnd ifTrue: [ aStream nextPutAll: 'End' ].
	aStream nextPutAll: '<<'.
	self printContentsOn: aStream.
	aStream nextPutAll: '>>'
]

{ #category : #controlling }
TwyLayoutSpan >> putNextItem [
	
	| spanItem spanItemWidth |
	spanItem := rightBorder nextItemAtSpan.
	spanItemWidth := drawer widthOf: spanItem.
	extent := extent x + spanItemWidth @ extent y.
	rightBorder moveForward.
	rightSpan ifNotNil: [	rightSpan reduceFromLeftBy: spanItemWidth]
]

{ #category : #controlling }
TwyLayoutSpan >> putTextSpanItemsWhile: conditionBlock [
	"
	It returns answer on question: was all items accepted?
	"	
		
	 [self isAtEndOfTextSpan not and: conditionBlock] whileTrue: [ 
		(rightSpan notNil and: [rightSpan isTextSpansBorder not and: [rightSpan isEmpty]]) 
			ifTrue: [rightSpan delete].
		self putNextItem].

	conditionBlock value ifFalse: [ self rejectLastItem. ^false].
	
	^true

]

{ #category : #controlling }
TwyLayoutSpan >> recomputeExtent [

	| newWidth iterator item itemWidth |
	self isTextSpansBorder ifTrue: [ ^extent := 0 @ extent y ].
	
	newWidth := 0.
	iterator := self leftBorder copy.
	[ iterator isAtSamePositionWith: self rightBorder ] whileFalse: [ 
		item := iterator nextItemAtSpan.
		itemWidth := drawer widthOf: item.
		newWidth := newWidth + itemWidth.
		iterator moveForward].
		
	extent := newWidth @ extent y
]

{ #category : #controlling }
TwyLayoutSpan >> reduceFromLeftBy: delta [

	self reduceWidthBy: delta.
	offset := offset + delta
]

{ #category : #controlling }
TwyLayoutSpan >> reduceFromRightBy: delta [

	self reduceWidthBy: delta
]

{ #category : #controlling }
TwyLayoutSpan >> reduceWidthBy: delta [
	
	self isTextSpansBorder ifTrue: [ ^self ].
	delta > extent x ifTrue: [ self error: 'Should not happen' ].
	
	extent := extent x - delta @ extent y
]

{ #category : #controlling }
TwyLayoutSpan >> rejectLastItem [
	| char itemWidth |
	rightBorder moveBackward.
	char := rightBorder nextItemAtSpan.
	itemWidth := drawer widthOf: char.
	extent := extent x - (itemWidth) @ extent y.
	rightSpan ifNotNil: [rightSpan increaseFromLeftBy: itemWidth].

]

{ #category : #controlling }
TwyLayoutSpan >> rejectTextSpanItemsWhile: conditionBlock [

	conditionBlock whileTrue: [ 
		self rejectLastItem		
	 ]
]

{ #category : #accessing }
TwyLayoutSpan >> rightBorder [
	
	^ rightBorder
]

{ #category : #accessing }
TwyLayoutSpan >> rightBorder: anObject [
	
	rightBorder := anObject
]

{ #category : #accessing }
TwyLayoutSpan >> rightBorderOffset [
	^offset + self width
]

{ #category : #accessing }
TwyLayoutSpan >> rightDetect: predicateBlock ifAbsent: absentBlock [

	self rightDo: [:each | (predicateBlock value: each) ifTrue: [ ^each ] ].
	
	^absentBlock value

]

{ #category : #accessing }
TwyLayoutSpan >> rightDo: actionBlock [ 
	self rightDo: actionBlock while: [:each | true]

]

{ #category : #accessing }
TwyLayoutSpan >> rightDo: actionBlock while: conditionBlock [

	| current |
	current := self.
	[current notNil and:  [conditionBlock value: current] ] whileTrue: [ 
		actionBlock value: current.
		current := current rightSpan]
]

{ #category : #accessing }
TwyLayoutSpan >> rightSpan [
	^rightSpan
]

{ #category : #accessing }
TwyLayoutSpan >> rightSpan: anObject [
	
	rightSpan := anObject
]

{ #category : #printing }
TwyLayoutSpan >> stringForSpecTitle [
	^String streamContents: [:s |  super printOn: s]
]

{ #category : #printing }
TwyLayoutSpan >> stringForSpecValidation [
	^'a', TwyLayoutSpan asString
]

{ #category : #accessing }
TwyLayoutSpan >> textLineNumber [

	^rightBorder lineNumber
]

{ #category : #accessing }
TwyLayoutSpan >> textRegion [
	self leftBorder selectTextUpTo: self rightBorder
]

{ #category : #accessing }
TwyLayoutSpan >> textSpan [
	^rightBorder span
]

{ #category : #validation }
TwyLayoutSpan >> validate [

	self layout validate: self width >= 0 description: 'Layout span width should be positive or zero by ', self width asString.

	self isTextSpansBorder ifTrue: [ 
		self isLayoutStart ifFalse: [ 
			self layout validate: (leftSpan textSpan nextSpanIfAbsent: [ nil ]) == rightSpan textSpan description: 'Layout spans shoud cover all text spans without skip'.
			self layout validate: (leftSpan textSpan isBefore: self textSpan) description: 'Layout spans shoud be placed in order of text spans '.
			
		 ].
		self layout validate: self width = 0 description: 'Text spans layout border should has zero width but ', self width asString ].
	
	
]

{ #category : #accessing }
TwyLayoutSpan >> width [
	^extent x
]
