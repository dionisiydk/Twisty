"
I present actual visual layout of text. I contain computed information required for text drawing and navigation.

I am linked list of TwyLayoutLine's which are lincked lists of TwyLayoutSpan's.
Every line knows about below and above neighbour lines.
Every span knows about it line and left and right neighbour spans.
Layout spans has right border instance variable which is passive text cursor. Left border of span is right border of it left neighbour span. Left and right borders of layout span define underlying text region.
Layout span which left and right borders point to different spans are text spans borders. 
I ensure three invariants: 
- text spans border always connect basic layout spans. 
- there is almost one layout span at line which is not text spans border.
- it can be only empty layout span at line.
(It is also mean that TwyLineStart's text elements can be only covered by text spans borders).

I built on text by layout strategies (TwyNativeLayoutStrategy and TwyWrapTextStrategy). I subscribe on text changes and automatically restore my structure at the end of changes. When my structure is restored I announce TwyLayoutChanged event.

I provide objects to navigate through my structure: TwyLayoutCursor and TwyLayoutRegion. You can fetch them by #newCursor and #newRegion messages. They track text and layout changes and fix layout positions automatically. At the end of such changes they announce TwyPositionChanged event.
You should detach this objects from text by #detachText message to release text subscription.
You can also attach layout cursor to existed text cursor. At this case you maybe don't need to manage text subscription because you already manage underlying text cursors. It is your responsibility to manage this objects correctly.

I provide methods to enumarate lines and spans:
	layout linesDo: [ :eachLine |  ]
	layout spansDo: [ :eachSpan |  ]
	
Instance Variables:
	text <TwyText>
	topLine	<TwyTextLine>
	extent	<Point>
	strategy <TwyLayoutStrategy>
"
Class {
	#name : #TwyLayout,
	#superclass : #Announcer,
	#instVars : [
		'text',
		'topLine',
		'extent',
		'strategy'
	],
	#category : #'Twisty-Layout'
}

{ #category : #'instance creation' }
TwyLayout class >> of: aText [
	| textLayout |
	textLayout := self new.
	textLayout initializeOn: aText.
	^textLayout
]

{ #category : #controlling }
TwyLayout >> accumulateLinesLayoutFrom: aLayoutLine1 to: aLayoutLine2 [

	aLayoutLine1 
		downDo: [ :eachLine | eachLine fixPosition. self increaseExtentBy: eachLine extent] 
		while: [ :eachLine | (eachLine = aLayoutLine2) not ]
]

{ #category : #controlling }
TwyLayout >> alignLines [

	| textAlignment |
	textAlignment := topLine getParagraphAttribute: TwyLineAlignmentAttribute.
	
	self linesDo: [:each | 
		each isVirtual ifFalse: [  
			textAlignment := each getParagraphAttribute: TwyLineAlignmentAttribute].
		
		each applyAlignment: textAlignment		
	]
]

{ #category : #controlling }
TwyLayout >> applyAlignment: aTextAlignment [

	self linesDo: [:each | aTextAlignment layoutLine: each within: extent x]
]

{ #category : #accessing }
TwyLayout >> bottomLine [
	
	| result |
	self linesDo: [ :each | result := each  ].
	
	^result
]

{ #category : #building }
TwyLayout >> buildBy: aLayoutStrategy [ 
	
	| builder |
	strategy := aLayoutStrategy.
	builder := strategy createBuilderFor: self startedAt: topLine.
	
	builder layoutText: text.
	
	text when: TwyTextChanged send: #textChangedBy: to: self

]

{ #category : #controlling }
TwyLayout >> detachText [
	text unsubscribe: self
]

{ #category : #drawing }
TwyLayout >> drawTextOn: aCanvas at: aPoint [
	
	self linesDo: [:eachLine | 
		eachLine drawOn: aCanvas at: aPoint.
	]
]

{ #category : #accessing }
TwyLayout >> extent [
	^ extent
]

{ #category : #accessing }
TwyLayout >> extent: anObject [
	extent := anObject
]

{ #category : #accessing }
TwyLayout >> findSpanWith: aTextCursor [

	self linesDo: [ :each | 
		(each findSpanWith: aTextCursor) ifNotNil: [ :span | ^span ] ].
	^nil
]

{ #category : #accessing }
TwyLayout >> height [
	^extent y
]

{ #category : #controlling }
TwyLayout >> increaseExtentBy: deltaPoint [
	| width height |
	height := extent y + deltaPoint y.
	width := extent x max: deltaPoint x.
	extent := width @ height
]

{ #category : #'initialize-release' }
TwyLayout >> initialize [ 
	super initialize.
	
	self resetExtent
]

{ #category : #'initialize-release' }
TwyLayout >> initializeOn: aTextModelOrRegion [

	| firstSpan |
	text := aTextModelOrRegion.
	topLine := TwyLayoutLine inside: self.
	firstSpan := TwyLayoutSpan new.
	firstSpan rightBorder: aTextModelOrRegion newPassiveCursorAtStart.	
	firstSpan line: topLine.
	topLine firstSpan: firstSpan.
]

{ #category : #accessing }
TwyLayout >> lineAt: aPoint [

	| targetLine |
	self linesDo: [:each | 
		targetLine := each.
		(targetLine containsPoint: aPoint) ifTrue: [ ^targetLine ]].
	
	^targetLine
]

{ #category : #accessing }
TwyLayout >> lines [

	| lines |
	lines := OrderedCollection new.
	self linesDo: [ :each | lines add: each ].
	^lines 
]

{ #category : #accessing }
TwyLayout >> linesDo: aBlock [

	topLine downDo: aBlock
]

{ #category : #controlling }
TwyLayout >> newCursor [
	^topLine newCursor
]

{ #category : #controlling }
TwyLayout >> newRegion [
	^TwyLayoutRegion on: self
]

{ #category : #accessing }
TwyLayout >> publishChanges [
	self announce: TwyLayoutChanged
]

{ #category : #building }
TwyLayout >> rebuildForNewExtent [
	self resetExtent.
		
	topLine downDo: [:each | 
		each fixPosition.
		each rebuildForNewExtentBy: strategy.		
		each applyExtentToLayout].
	self alignLines.

	self publishChanges
]

{ #category : #'initialize-release' }
TwyLayout >> resetExtent [

	extent := 0@0
]

{ #category : #accessing }
TwyLayout >> spansDo: aBlock [

	topLine firstSpan rightDo: aBlock
]

{ #category : #accessing }
TwyLayout >> strategy [
	
	^ strategy
]

{ #category : #accessing }
TwyLayout >> strategy: anObject [
	
	strategy := anObject
]

{ #category : #accessing }
TwyLayout >> text [
	^ text
]

{ #category : #accessing }
TwyLayout >> text: anObject [
	text := anObject
]

{ #category : #'handling text changes' }
TwyLayout >> textChangedBy: aTextChanged [

	| builder |
	builder := strategy createBuilderFor: self startedAt: topLine. 
	aTextChanged collectLayoutCommandsFor: builder.
	builder processAllCommands.	
	self publishChanges 
]

{ #category : #accessing }
TwyLayout >> topLine [
	
	^ topLine
]

{ #category : #accessing }
TwyLayout >> topLine: anObject [
	
	topLine := anObject
]

{ #category : #validation }
TwyLayout >> validate [

	| lastSpan yOffset |
	yOffset := 0.
	self linesDo: [ :eachLine | 
		eachLine validate.
		self validate: eachLine topLeftPosition y = yOffset description: 'Layout lines should be placed one after another by Y'.
		yOffset := yOffset + eachLine height].

	lastSpan := self bottomLine lastSpan.
	self validate: lastSpan isLayoutEnd description: 'Last layout span should be LayoutEnd'.
	self validate: lastSpan line belowLine isNil description: 'LayoutEnd should be at last layout line'.
	self validate: yOffset = extent y description: 'Layout height should be sum of lines height'
]

{ #category : #validation }
TwyLayout >> validate: aBoolean description: failureDescription [
		
	aBoolean ifFalse: [ self error: failureDescription  ]
]

{ #category : #accessing }
TwyLayout >> width [
	^extent x
]
