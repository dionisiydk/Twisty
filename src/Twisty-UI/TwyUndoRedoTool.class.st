"
I supply text editing history to text morph to allow undo and redo operations
"
Class {
	#name : #TwyUndoRedoTool,
	#superclass : #TwyTextTool,
	#instVars : [
		'history'
	],
	#category : #'Twisty-UI'
}

{ #category : #controlling }
TwyUndoRedoTool >> attachToMorph [
	textMorph on: $z command do: [ history undoLastChange ].
	textMorph on: $y command do: [ history redoLastChange ].
]

{ #category : #controlling }
TwyUndoRedoTool >> attachToText [
	history := TwyChangesHistory of: self text
]

{ #category : #controlling }
TwyUndoRedoTool >> detachFromText [
	history detachText
]

{ #category : #testing }
TwyUndoRedoTool >> isAttachedToText [
	^history notNil
]
