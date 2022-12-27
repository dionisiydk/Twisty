"
I supply blinked cursor to text morph for visual text navigation.
Blinked cursor is implemented by TwyCursorMorph which I add to text morph
"
Class {
	#name : #TwyCursorTool,
	#superclass : #TwyTextTool,
	#instVars : [
		'cursorMorph',
		'selectionRegion'
	],
	#category : #'Twisty-UI'
}

{ #category : #controlling }
TwyCursorTool >> attachToMorph [
	cursorMorph := TwyCursorMorph new.
	cursorMorph cursor: (textMorph ensureTool: TwySelectionTool) cursor.
	
	textMorph addMorph: cursorMorph.
	cursorMorph updatePosition
]

{ #category : #controlling }
TwyCursorTool >> attachToText [
	| selectionTool |
	selectionTool := textMorph ensureTool: TwySelectionTool.
	
	selectionRegion := selectionTool selectionRegion.
	selectionRegion when: TwyLayoutChanged send: #selectionChanged to: self
	
]

{ #category : #controlling }
TwyCursorTool >> detachFromText [
	selectionRegion unsubscribe: self.
	cursorMorph delete.
	cursorMorph := nil
]

{ #category : #controlling }
TwyCursorTool >> focusChanged: gotFocus [

	cursorMorph active: (gotFocus and: [selectionRegion isEmpty]).
	
]

{ #category : #testing }
TwyCursorTool >> isAttachedToText [
	^textMorph notNil
]

{ #category : #controlling }
TwyCursorTool >> selectionChanged [

	selectionRegion isEmpty ifTrue: [  cursorMorph show ] ifFalse: [ cursorMorph hide ]
]
