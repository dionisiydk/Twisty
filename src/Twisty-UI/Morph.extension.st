Extension { #name : #Morph }

{ #category : #'*Twisty-UI' }
Morph >> isChildText: aTextMorph hasVisibleLineAt: aLayoutCursor [

	| cursorHeightDelta |
	cursorHeightDelta := aLayoutCursor height / 3.0.
	
	^self intersects: (
		(self position x @ aTextMorph position y) 
			+ (0 @ (aLayoutCursor layoutPosition y + 1) ) 
				extent: 1 @ (aLayoutCursor height - cursorHeightDelta)
	)
]

{ #category : #'*Twisty-UI' }
Morph >> isChildText: aTextMorph visibleAt: aLayoutCursor [

	| cursorHeightDelta |
	cursorHeightDelta := aLayoutCursor height / 3.0.
	
	^self intersects: (
		 aTextMorph position + aLayoutCursor layoutPosition + (0 @ 1) 
			extent: 1 @ (aLayoutCursor height - cursorHeightDelta)
	)
]

{ #category : #'*Twisty-UI' }
Morph >> makeChildText: aTextMorph visibleAt: aLayoutCursor [

	| oldY newY oldX newX |
	(self isChildText: aTextMorph visibleAt: aLayoutCursor)ifTrue: [ ^self ].
	
	self changeNoLayout.
	
	(self isChildText: aTextMorph hasVisibleLineAt: aLayoutCursor) ifFalse: [ 
		oldY := aTextMorph position y.
		newY := self position y + (self height - aLayoutCursor layoutPosition y - aLayoutCursor height).
		oldY < newY ifTrue: [ newY := self position y - aLayoutCursor layoutPosition y].
		aTextMorph position: self position x @ newY.			
	].

	(self isChildText: aTextMorph visibleAt: aLayoutCursor)ifTrue: [ ^self ].

	oldX := aTextMorph position x.
	newX := self position x + (self width - aLayoutCursor layoutPosition x).
	oldX < newX ifTrue: [ newX := self position x  - aLayoutCursor layoutPosition x].
	
	aTextMorph position: newX @ aTextMorph position y

]
