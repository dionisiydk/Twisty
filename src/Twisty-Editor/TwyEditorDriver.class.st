"
I'm the root of the hierarchy of editor helper objects for selected text navigation.

I delegate all messages to editor cursor. And my subclasses decide if selected region should be reset

    Instance Variables
	editor:		<TwyEditor>



"
Class {
	#name : #TwyEditorDriver,
	#superclass : #Object,
	#instVars : [
		'editor'
	],
	#category : #'Twisty-Editor'
}

{ #category : #'instance creation' }
TwyEditorDriver class >> on: anEditor [
	^self new 
		editor: anEditor
]

{ #category : #controlling }
TwyEditorDriver >> doesNotUnderstand: aMessage [

	| result |
	(editor cursor respondsTo: aMessage selector) ifFalse: [ 
		^super doesNotUnderstand: aMessage].
	
	result := aMessage sendTo: editor cursor.
	
	self processCursorChanges.
	
	^result
]

{ #category : #accessing }
TwyEditorDriver >> editor [
	
	^ editor
]

{ #category : #accessing }
TwyEditorDriver >> editor: anObject [
	
	editor := anObject
]

{ #category : #controlling }
TwyEditorDriver >> processCursorChanges [
	self subclassResponsibility 
]
