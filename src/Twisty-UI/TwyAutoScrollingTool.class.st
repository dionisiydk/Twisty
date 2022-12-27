"
I supply to text morph ability to fix it position inside owner to always show text under cursor. 
"
Class {
	#name : #TwyAutoScrollingTool,
	#superclass : #TwyTextTool,
	#instVars : [
		'cursor'
	],
	#category : #'Twisty-UI'
}

{ #category : #controlling }
TwyAutoScrollingTool >> attachToMorph [

]

{ #category : #controlling }
TwyAutoScrollingTool >> attachToText [
	| selectionTool |
	selectionTool := textMorph ensureTool: TwySelectionTool.
	cursor := selectionTool cursor.
	
	cursor when: TwyPositionChanged send: #ensureCursorVisibility to: self
]

{ #category : #accessing }
TwyAutoScrollingTool >> cursor [
	^cursor
]

{ #category : #controlling }
TwyAutoScrollingTool >> detachFromText [
	cursor unsubscribe: self
]

{ #category : #controlling }
TwyAutoScrollingTool >> ensureCursorVisibility [
	
	| ownerMorph |
	ownerMorph := textMorph owner.
	
	ownerMorph makeChildText: textMorph visibleAt: cursor
]

{ #category : #testing }
TwyAutoScrollingTool >> isAttachedToText [
	^cursor notNil
]
