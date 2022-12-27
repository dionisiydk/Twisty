Extension { #name : #GeneralScrollPane }

{ #category : #'*Twisty-UI' }
GeneralScrollPane >> isChildText: aTextMorph visibleAt: aLayoutCursor [

	^self scrollBounds intersects: (
		self position - scroller offset  + aLayoutCursor layoutPosition extent: 1 @ aLayoutCursor height)

]

{ #category : #'*Twisty-UI' }
GeneralScrollPane >> makeChildText: aTextMorph visibleAt: aLayoutCursor [

	(self isChildText: aTextMorph visibleAt: aLayoutCursor)ifTrue: [ ^self ].

	self scrollToShowNearly: (aLayoutCursor layoutPosition extent: 1 @ aLayoutCursor height)
]

{ #category : #'*Twisty-UI' }
GeneralScrollPane >> scrollToShowNearly: aRectangle [
	|offset newY newX scrollBounds |
	scrollBounds := self scrollBounds.
	offset := self scroller offset.
	((aRectangle top - offset y) >= 0 and: [
		(aRectangle bottom - offset y) <= scrollBounds height])
		ifFalse: [
			offset y > aRectangle top 
				ifTrue: [newY := aRectangle top min: self scrollTarget height - scrollBounds height]
				ifFalse: [ newY := aRectangle bottom - scrollBounds height max: 0].
				offset := offset x @ newY].
	((aRectangle left - offset x) >= 0 and: [
		(aRectangle right - offset x) <= scrollBounds width])
		ifFalse: [
			offset x > aRectangle left 
				ifTrue: [ newX := (aRectangle left min: self scrollTarget width - scrollBounds width) ]
				ifFalse: [ newX := aRectangle right - scrollBounds width max: 0].
			offset := newX @ offset y].
	offset = self scroller offset ifFalse: [
		self scroller offset: offset.
		self setScrollDeltas]
]
