"
I'm history of text changes. I created on text and subscribe on it changes. I can undo and redo last changes.

You can create me by
	TwyChangesHistory of: text

To undo last change use 
	history undoLastChange.

To redo last change use 
	history redoLastChange
 
    Instance Variables
	text:		<TwyText>
	redoList:		<Collection of: <TwyCTextChanged>>	
	undoList:		<Collection of: <TwyCTextChanged>>

"
Class {
	#name : #TwyChangesHistory,
	#superclass : #Object,
	#instVars : [
		'text',
		'undoList',
		'redoList'
	],
	#category : #'Twisty-Editor'
}

{ #category : #'instance creation' }
TwyChangesHistory class >> of: aTwyText [

	^self new 
		text: aTwyText
]

{ #category : #accessing }
TwyChangesHistory >> addNewChange: aTextChanged [

	undoList add: aTextChanged
]

{ #category : #accessing }
TwyChangesHistory >> addRedoChange: aTextChanged [

	redoList add: aTextChanged
]

{ #category : #subscription }
TwyChangesHistory >> attachToText [
	text when: TwyTextChanged send: #addNewChange: to: self
]

{ #category : #subscription }
TwyChangesHistory >> detachText [
	text unsubscribe: self
]

{ #category : #initialize }
TwyChangesHistory >> initialize [
	super initialize.
	
	undoList := OrderedCollection new.
	redoList := OrderedCollection new
]

{ #category : #controlling }
TwyChangesHistory >> redoLastChange [

	| lastChange  |
	redoList ifEmpty: [ ^self ].
	
	lastChange := redoList removeLast.
	
	text editContentsBy: [ lastChange cancel ].
	
	
]

{ #category : #accessing }
TwyChangesHistory >> redoList [
	^ redoList
]

{ #category : #accessing }
TwyChangesHistory >> redoList: anObject [
	redoList := anObject
]

{ #category : #accessing }
TwyChangesHistory >> text [
	^ text
]

{ #category : #accessing }
TwyChangesHistory >> text: aTwyText [
	text := aTwyText.
	self attachToText
	
]

{ #category : #controlling }
TwyChangesHistory >> undoLastChange [

	| lastChange redoChange |
	undoList ifEmpty: [ ^self ].
	
	lastChange := undoList removeLast.
	
	redoChange := text editContentsBy: [ lastChange cancel ].
	
	undoList remove: redoChange ifAbsent: [].
	redoList add: redoChange
]

{ #category : #accessing }
TwyChangesHistory >> undoList [
	^ undoList
]

{ #category : #accessing }
TwyChangesHistory >> undoList: anObject [
	undoList := anObject
]
