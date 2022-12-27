"
I am position inside text layout. I implement moveRight, moveLeft, moveUp and moveDown methods according visual cursor navigation. 

I subscribe of text, textCursor and layout events to automatically correct my layout position. When I changed my position I announce TwyPositionChanged event.

    Instance Variables
	layout:		<TwyLayout>
	layoutPosition:		<Point>
	span:		<TwyLayoutSpan>
	textCursor:		<TwyTextCursor>
	desiredOffset:		<Number>
	firstMovement:		<TwyCursorMoved>
	shouldRecomputePositionOnlyAfterLayoutChanges:		<Boolean>
			
desiredOffset
	- desired x offset from start of ""visual line"". It can differ from actual (x,y) position.  Desired offset allow moving up and down with remembered of first offset. 

layout
	- underlying text layout

span
	- underlying current layout span

textCursor
	- underlying text cursor

layoutPosition
	- actual ""visual"" position inside text layout
"
Class {
	#name : #TwyLayoutCursor,
	#superclass : #Announcer,
	#instVars : [
		'span',
		'desiredOffset',
		'layout',
		'textCursor',
		'layoutPosition',
		'shouldRecomputePositionOnlyAfterLayoutChanges',
		'firstMovement'
	],
	#category : #'Twisty-Layout'
}

{ #category : #'instance creation' }
TwyLayoutCursor class >> on: aLayout at: aLayoutSpan [ 

	^self new 
		layout: aLayout;
		textCursor: aLayoutSpan fetchTextCursor;
		movedToSpan: aLayoutSpan;
		subscribeOnTextCursor;
		yourself
]

{ #category : #accessing }
TwyLayoutCursor >> aboveLine [
	^span aboveLine
]

{ #category : #accessing }
TwyLayoutCursor >> attachTo: aTextCursor [

	textCursor ifNotNil: [ textCursor unsubscribeLayoutCursor: self ].
	textCursor := aTextCursor.
	
	self synchronizeWithTextCursor.
	
	self subscribeOnTextCursor 
]

{ #category : #accessing }
TwyLayoutCursor >> belowLayoutBoundsUpTo: aLayoutLine [

	| startBounds endBounds |
	startBounds := span belowLine layoutBounds.
	endBounds := aLayoutLine layoutBounds.
	
	^startBounds origin corner: endBounds corner
]

{ #category : #accessing }
TwyLayoutCursor >> desiredOffset [
	^ desiredOffset
]

{ #category : #accessing }
TwyLayoutCursor >> desiredOffset: anObject [
	desiredOffset := anObject
]

{ #category : #controlling }
TwyLayoutCursor >> detachText [

	textCursor unsubscribeLayoutCursor: self.
	textCursor detachText.
]

{ #category : #accessing }
TwyLayoutCursor >> firstMovement [
	
	^ firstMovement
]

{ #category : #accessing }
TwyLayoutCursor >> firstMovement: anObject [
	
	firstMovement := anObject
]

{ #category : #accessing }
TwyLayoutCursor >> height [
	^span height
]

{ #category : #controlling }
TwyLayoutCursor >> ignoreLayoutChanges [
	layout unsubscribe: self
]

{ #category : #'initialize-release' }
TwyLayoutCursor >> initialize [ 
	super initialize.
	
	shouldRecomputePositionOnlyAfterLayoutChanges := false.
	self saveDesiredPositionAt: 0@0
]

{ #category : #testing }
TwyLayoutCursor >> isAfter: aLayoutCursor [
	^textCursor isAfter: aLayoutCursor textCursor
]

{ #category : #testing }
TwyLayoutCursor >> isAtSameLineWith: aLayoutCursor [ 
	^self line == aLayoutCursor line
]

{ #category : #testing }
TwyLayoutCursor >> isAtSameTextPositionWith: aLayoutCursor [
	^textCursor isAtSamePositionWith: aLayoutCursor textCursor
]

{ #category : #testing }
TwyLayoutCursor >> isBefore: aLayoutCursor [
	^textCursor isBefore: aLayoutCursor textCursor
]

{ #category : #accessing }
TwyLayoutCursor >> layout [
	^ layout
]

{ #category : #accessing }
TwyLayoutCursor >> layout: aTwyLayout [
	layout := aTwyLayout.
	layout when: TwyLayoutChanged send: #synchronizeWithTextCursor to: self
]

{ #category : #private }
TwyLayoutCursor >> layoutChanged [

	span := layout findSpanWith: textCursor.
	span ifNil: [
		self error: 'Cant find layout span for textPosition'.
		 ^self layoutPosition: 0@0 ].
	self recomputeLayoutPosition 
]

{ #category : #accessing }
TwyLayoutCursor >> layoutPosition [
	^layoutPosition
]

{ #category : #accessing }
TwyLayoutCursor >> layoutPosition: aPoint [

	| line |
	self moveTextCursorBy: [ 
		line := layout lineAt: aPoint.
		span := line spanAtOffset: aPoint x.
		span moveTextCursor: textCursor insideAtOffset: aPoint x.
		self recomputeLayoutPosition
	]
]

{ #category : #accessing }
TwyLayoutCursor >> leftSideLineBounds [ 

	| lineBounds |
	lineBounds := self line layoutBounds.
	
	^lineBounds origin corner: layoutPosition x @ lineBounds corner y
]

{ #category : #accessing }
TwyLayoutCursor >> line [
	^span line
]

{ #category : #movement }
TwyLayoutCursor >> moveDown [

	| belowLine |
	belowLine := span belowLine.
	belowLine ifNil: [^self].
	
	self moveToLine: belowLine
]

{ #category : #movement }
TwyLayoutCursor >> moveLeft [

	textCursor moveBackward.
]

{ #category : #movement }
TwyLayoutCursor >> moveRight [

	textCursor moveForward.

]

{ #category : #private }
TwyLayoutCursor >> moveTextCursorBy: aBlock [

	textCursor unsubscribeLayoutCursor: self.
	aBlock value.
	self subscribeOnTextCursor 
]

{ #category : #private }
TwyLayoutCursor >> moveToLine: aTextLine [ 

	self moveTextCursorBy: [ 
		span := aTextLine spanAtOffset: desiredOffset.
		span moveTextCursor: textCursor insideAtOffset: desiredOffset.
		layoutPosition := span computeLayoutPositionOf: textCursor
	].

	self positionChanged
]

{ #category : #movement }
TwyLayoutCursor >> moveToLineEnd [

	textCursor moveToLineEnd
]

{ #category : #movement }
TwyLayoutCursor >> moveToLineStart [

	textCursor moveToLineStart
]

{ #category : #movement }
TwyLayoutCursor >> moveToTextEnd [

	textCursor moveToTextEnd
]

{ #category : #movement }
TwyLayoutCursor >> moveToTextStart [

	textCursor moveToTextStart
]

{ #category : #movement }
TwyLayoutCursor >> moveUp [

	| aboveLine |

	aboveLine := span aboveLine.
	aboveLine ifNil: [^self].
	
	self moveToLine: aboveLine 
]

{ #category : #private }
TwyLayoutCursor >> movedToSpan: aLayoutSpan [ 
	span := aLayoutSpan.
	self recomputeLayoutPosition.
]

{ #category : #private }
TwyLayoutCursor >> positionChanged [
	self announce: TwyPositionChanged 
]

{ #category : #'initialize-release' }
TwyLayoutCursor >> prepareAtTextStart [

	self layoutPosition: 0@0
]

{ #category : #private }
TwyLayoutCursor >> recomputeLayoutPosition [
	self saveDesiredPositionAt: (span computeLayoutPositionOf: textCursor)
]

{ #category : #accessing }
TwyLayoutCursor >> rightSideLineBounds [ 

	| lineBounds |
	lineBounds := self line layoutBounds.
	
	^layoutPosition corner: lineBounds corner
]

{ #category : #accessing }
TwyLayoutCursor >> saveDesiredPositionAt: aPoint [

	layoutPosition := aPoint.
	desiredOffset := layoutPosition x.
	self positionChanged 
]

{ #category : #accessing }
TwyLayoutCursor >> shouldRecomputePositionOnlyAfterLayoutChanges [
	
	^ shouldRecomputePositionOnlyAfterLayoutChanges
]

{ #category : #accessing }
TwyLayoutCursor >> shouldRecomputePositionOnlyAfterLayoutChanges: anObject [
	
	shouldRecomputePositionOnlyAfterLayoutChanges := anObject
]

{ #category : #accessing }
TwyLayoutCursor >> span [
	^ span
]

{ #category : #accessing }
TwyLayoutCursor >> span: anObject [
	span := anObject
]

{ #category : #private }
TwyLayoutCursor >> subscribeOnTextCursor [

	textCursor subscribeLayoutCursor: self
]

{ #category : #private }
TwyLayoutCursor >> synchronizeWithTextCursor [

	firstMovement ifNotNil: [ 
		firstMovement correctLayoutPositionOf: self.
		firstMovement := nil.
		^self].
	
	span := layout topLine firstSpan.
	self textCursorMovedToRight.
]

{ #category : #private }
TwyLayoutCursor >> textChanged [

	shouldRecomputePositionOnlyAfterLayoutChanges := false
]

{ #category : #accessing }
TwyLayoutCursor >> textCursor [
	^ textCursor
]

{ #category : #accessing }
TwyLayoutCursor >> textCursor: aTextCursor [
	textCursor := aTextCursor
]

{ #category : #private }
TwyLayoutCursor >> textCursorMoved: movementEvent [

	firstMovement ifNil: [ firstMovement := movementEvent].
	
	shouldRecomputePositionOnlyAfterLayoutChanges ifTrue: [^self].
	
	self synchronizeWithTextCursor
]

{ #category : #private }
TwyLayoutCursor >> textCursorMovedToLeft [

	span moveLayoutCursor: self leftToSpanWith: textCursor
]

{ #category : #private }
TwyLayoutCursor >> textCursorMovedToRight [

	span moveLayoutCursor: self rightToSpanWith: textCursor
]

{ #category : #accessing }
TwyLayoutCursor >> textPosition [
	^ textCursor textPosition
]

{ #category : #private }
TwyLayoutCursor >> textWillBeChanged [

	shouldRecomputePositionOnlyAfterLayoutChanges := true
]
