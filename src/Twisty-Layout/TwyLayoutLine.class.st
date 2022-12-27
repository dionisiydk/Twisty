"
I am layout line with computed extent and offset properties. 
I know my below and above neghbour lines and my first layout span

    Instance Variables
	aboveLine:		<TwyLayoutLine>
	belowLine:		<TwyLayoutLine>
	extent:		<Point>
	firstSpan:		<TwyLayoutSpan>
	layout:		<TwyLayout>
	topLeftPosition:		<Point>

		
- extent
	extent of line box which bounds all spans
	
- topLeftPosition
	offset from left border of text layout box

"
Class {
	#name : #TwyLayoutLine,
	#superclass : #Object,
	#instVars : [
		'layout',
		'belowLine',
		'aboveLine',
		'firstSpan',
		'extent',
		'topLeftPosition'
	],
	#category : #'Twisty-Layout'
}

{ #category : #'instance creation' }
TwyLayoutLine class >> inside: aTwyLayout [ 
	^self new 
		layout: aTwyLayout
]

{ #category : #accessing }
TwyLayoutLine >> aboveLine [
	^aboveLine
]

{ #category : #accessing }
TwyLayoutLine >> aboveLine: anObject [
	
	aboveLine := anObject
]

{ #category : #alignment }
TwyLayoutLine >> alignCenteredWithin: maxLineWidth [

	topLeftPosition := maxLineWidth - extent x // 2 @ topLeftPosition y

]

{ #category : #alignment }
TwyLayoutLine >> alignLeftToRightWithin: maxLineWidth [

	topLeftPosition := 0 @ topLeftPosition y
]

{ #category : #alignment }
TwyLayoutLine >> alignRightToLeftWithin: maxLineWidth [

	topLeftPosition := maxLineWidth - extent x @ topLeftPosition y
]

{ #category : #alignment }
TwyLayoutLine >> applyAlignment: aTextAlignment [

	aTextAlignment layoutLine: self within: layout width
]

{ #category : #controlling }
TwyLayoutLine >> applyExtentToLayout [ 
	layout increaseExtentBy: extent
]

{ #category : #accessing }
TwyLayoutLine >> belowLine [
	^belowLine
]

{ #category : #accessing }
TwyLayoutLine >> belowLine: anObject [
	
	belowLine := anObject
]

{ #category : #accessing }
TwyLayoutLine >> bottomBorderOffset [
	^topLeftPosition y + self height
]

{ #category : #testing }
TwyLayoutLine >> containsPoint: aPoint [ 
	^aPoint y between: topLeftPosition y and: topLeftPosition y + extent y
]

{ #category : #controlling }
TwyLayoutLine >> delete [

	self isLayoutTop ifTrue: [ 
		layout topLine: belowLine.
		^belowLine aboveLine: nil].
	
	belowLine ifNotNil: [ belowLine aboveLine: aboveLine].
	aboveLine ifNotNil: [ aboveLine belowLine: belowLine].
	"self resetExtent "
]

{ #category : #accessing }
TwyLayoutLine >> downDo: actionBlock [ 

	self downDo: actionBlock while: [:each | true]
]

{ #category : #accessing }
TwyLayoutLine >> downDo: actionBlock while: conditionBlock [

	| current |
	current := self.
	[current notNil and:  [conditionBlock value: current] ] whileTrue: [ 
		actionBlock value: current.
		current := current belowLine]
]

{ #category : #drawing }
TwyLayoutLine >> drawOn: aCanvas at: aPoint [

	self spansDo: [:each | 
		each drawOn: aCanvas at: aPoint + topLeftPosition within: extent
	] 
]

{ #category : #accessing }
TwyLayoutLine >> extent [
	^ extent
]

{ #category : #accessing }
TwyLayoutLine >> extent: anObject [
	extent := anObject
]

{ #category : #accessing }
TwyLayoutLine >> findSpanWith: aTextCursor [
	
	self spansDo: [ :each | 
		(each contains: aTextCursor) ifTrue: [ ^each ] ].
	
	^nil
]

{ #category : #accessing }
TwyLayoutLine >> firstSpan [
	^firstSpan
]

{ #category : #accessing }
TwyLayoutLine >> firstSpan: anObject [
	
	firstSpan := anObject
]

{ #category : #accessing }
TwyLayoutLine >> firstTextSpan [
	^firstSpan textSpan
]

{ #category : #controlling }
TwyLayoutLine >> fixPosition [
	self isLayoutTop ifTrue: [ 
		topLeftPosition :=topLeftPosition x @ 0.
		^self ].
	
	topLeftPosition := topLeftPosition x @ aboveLine bottomBorderOffset.
	 
]

{ #category : #accessing }
TwyLayoutLine >> getParagraphAttribute: textAttrubuteClass [ 
	^self firstTextSpan getParagraphAttribute: textAttrubuteClass
]

{ #category : #accessing }
TwyLayoutLine >> height [
	^extent y
]

{ #category : #controlling }
TwyLayoutLine >> importSpansFrom: anotherLine startedWith: firstImportedSpan [

	firstImportedSpan rightDo: [ :each | each migrateTo: self ] while: [:each | each line = anotherLine ].
	firstSpan := firstImportedSpan
]

{ #category : #controlling }
TwyLayoutLine >> increaseExtentBy: deltaPoint [
	| width height |
	width := extent x + deltaPoint x.
	height := extent y max: deltaPoint y.
	extent := width @ height
]

{ #category : #'initialize-release' }
TwyLayoutLine >> initialize [ 
	super initialize.

	topLeftPosition := 0@0.
	self resetExtent
]

{ #category : #testing }
TwyLayoutLine >> isCovers: aTwyElement [
	
	^aTwyElement isCoveredByLayoutLine: self
]

{ #category : #testing }
TwyLayoutLine >> isCoversElementsBetween: firstElement and: lastElement [
	
	(self firstTextSpan isBefore: lastElement) ifFalse: [ ^false ].
	(self lastTextSpan isAfter: firstElement) ifFalse: [ ^false ].	
	
	^true
]

{ #category : #testing }
TwyLayoutLine >> isCoversLineStart: aTwyLineStart [
	
	^firstSpan isCoversLineStart: aTwyLineStart
]

{ #category : #testing }
TwyLayoutLine >> isCoversSpan: aTwySpan [
		
	(self firstTextSpan isAfter: aTwySpan) ifTrue: [ ^false ].
	(self lastTextSpan isBefore: aTwySpan) ifTrue: [ ^false ].
	
	^true
	
]

{ #category : #testing }
TwyLayoutLine >> isDeleted [
	belowLine ifNotNil: [ ^belowLine aboveLine ~= self ].
	aboveLine ifNotNil: [ ^aboveLine belowLine ~= self ].
	
	^false
]

{ #category : #testing }
TwyLayoutLine >> isFirstLineWhichCovers: aTextElement [

	(self isCovers: aTextElement) ifFalse: [ ^false ].
	
	^aboveLine isNil or: [ (aboveLine isCovers: aTextElement) not ]
]

{ #category : #testing }
TwyLayoutLine >> isLastLineWhichCovers: aTextElement [

	(self isCovers: aTextElement) ifFalse: [ ^false ].
	
	^belowLine isNil or: [ (belowLine isCovers: aTextElement) not ]
]

{ #category : #testing }
TwyLayoutLine >> isLayoutTop [
	^layout topLine == self
]

{ #category : #testing }
TwyLayoutLine >> isPlacedBelowThan: anotherLine [

	^topLeftPosition y > anotherLine topLeftPosition y
]

{ #category : #testing }
TwyLayoutLine >> isVirtual [
	firstSpan isLayoutStart ifTrue: [ ^false ].
	^firstSpan isCoversSameTextSpanAs: firstSpan leftSpan
]

{ #category : #accessing }
TwyLayoutLine >> lastSpan [
	| result |
	belowLine ifNotNil: [ ^belowLine firstSpan leftSpan ].
	
	firstSpan rightDo: [ :each | result := each ] while: [ :each | each line = self ].
	^result
]

{ #category : #accessing }
TwyLayoutLine >> lastTextSpan [
	^self lastSpan textSpan
]

{ #category : #accessing }
TwyLayoutLine >> layout [
	^ layout
]

{ #category : #accessing }
TwyLayoutLine >> layout: anObject [
	layout := anObject
]

{ #category : #accessing }
TwyLayoutLine >> layoutBounds [
	^0 @ topLeftPosition y extent: layout width @ self height
]

{ #category : #accessing }
TwyLayoutLine >> leftTextBorder [
	^firstSpan leftBorder
]

{ #category : #controlling }
TwyLayoutLine >> newBelowLine [

	| newLine |
	newLine := TwyLayoutLine new.
	newLine 
		layout: layout;
		belowLine: belowLine;
		aboveLine: self;
		topLeftPosition: 0 @ (topLeftPosition y + self height).
	belowLine ifNotNil: [ 
		belowLine aboveLine: newLine].
	^belowLine := newLine
	
]

{ #category : #accessing }
TwyLayoutLine >> newCursor [
	^TwyLayoutCursor 
		on: layout 
		at: (firstSpan isAtStartOfTextLine ifTrue: [firstSpan rightSpan] ifFalse: [firstSpan]) 
]

{ #category : #accessing }
TwyLayoutLine >> number [
	| result |
	result := 0.
	layout linesDo: [ :eachLine | 
		result := result + 1.
		eachLine == self ifTrue: [ ^result ]].
	
	self error: 'should not happen'
]

{ #category : #printing }
TwyLayoutLine >> printOn: aStream [

	super printOn: aStream.
	firstSpan ifNil: [ 
		aStream nextPutAll: '(uninitialized)'.
		^self].

	aStream 
		nextPut: $(;
		nextPutAll: self number asString;
		nextPutAll: '@';
		nextPutAll: firstSpan textLineNumber asString;
		nextPutAll: ':'.

	self spansDo: [ :eachSpan | eachSpan printContentsOn: aStream ].
	
	aStream nextPut: $)
]

{ #category : #controlling }
TwyLayoutLine >> rebuildForNewExtentBy: aLayoutStrategy [

	self resetExtent.
	
	firstSpan rightDo: [ :eachSpan  |
		eachSpan fixOffset.
		eachSpan isTextSpansBorder ifFalse: [ 
			aLayoutStrategy correctLayoutOf: eachSpan.
			eachSpan isAtEndOfTextSpan ifTrue: [	
					eachSpan cleanUpRedundantNeighbours].				
			eachSpan applyExtentToLine]			
	 ] while: [ :eachSpan | eachSpan line = self ]
]

{ #category : #controlling }
TwyLayoutLine >> reduceExtentBy: deltaPoint [
"
	It should reset height of line to recompute it during commiting layout changes
"
	| width |
	width := extent x - deltaPoint x.
	extent := width @ 0
]

{ #category : #controlling }
TwyLayoutLine >> removeSpan: aLayoutSpan [

	firstSpan == aLayoutSpan ifFalse: [ ^self ].
	
	firstSpan isLastAtLine ifFalse: [ 
		firstSpan := firstSpan rightSpan.
		^self].
	
	self delete
]

{ #category : #'initialize-release' }
TwyLayoutLine >> resetExtent [
	extent := 0@0
]

{ #category : #accessing }
TwyLayoutLine >> rightTextBorder [
	belowLine ifNil: [ ^self lastSpan rightBorder ].
	
	^belowLine leftTextBorder
]

{ #category : #accessing }
TwyLayoutLine >> spanAtOffset: xPosition [

	| targetOffset targetSpan |
	targetOffset := xPosition - topLeftPosition x.
	
	targetOffset < 0 ifTrue: [^firstSpan].
	
	self spansDo: [:eachSpan | 
		targetSpan := eachSpan. 
		(targetSpan isOverlaidLineAtX: targetOffset) ifTrue: [^targetSpan]].
	
	^targetSpan
]

{ #category : #accessing }
TwyLayoutLine >> spansDo: aBlock [ 
"
we skip all layout spans which connect adjacent text spans
"
	firstSpan 
		rightDo: [:each | each isTextSpansBorder ifFalse: [aBlock value: each]] 
		while: [ :each | each line == self ]
	
]

{ #category : #printing }
TwyLayoutLine >> stringForSpecTitle [
	^String streamContents: [:s |  super printOn: s]
]

{ #category : #accessing }
TwyLayoutLine >> topLeftPosition [
	^ topLeftPosition
]

{ #category : #accessing }
TwyLayoutLine >> topLeftPosition: anObject [
	topLeftPosition := anObject
]

{ #category : #validation }
TwyLayoutLine >> validate [

	| lastLineSpan xOffset |

	xOffset:=0.
	firstSpan 
			rightDo: [ :eachSpan | lastLineSpan := eachSpan. 
				eachSpan validate.
				layout validate: xOffset = eachSpan offset description: 'Layout spans at single line should be placed one after another by X'.
				xOffset := xOffset + eachSpan width
				] 
			while: [ :eachSpan | eachSpan line== self].
			
	layout validate: lastLineSpan isTextSpansBorder not description: 'Last span of layout line should never be "text spans border"'.
]

{ #category : #accessing }
TwyLayoutLine >> width [
	^extent x
]
