"
I'm helper object to navigate editor selected text without expanding selection. With me you can move editor cursor without selection.
"
Class {
	#name : #TwyEditorNoSelectionDriver,
	#superclass : #TwyEditorDriver,
	#category : #'Twisty-Editor'
}

{ #category : #controlling }
TwyEditorNoSelectionDriver >> processCursorChanges [

	editor resetSelection
]
