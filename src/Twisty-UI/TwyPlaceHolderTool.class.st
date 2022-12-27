"
I supply place holder on empty text morph.
You can edit place holder text from halo menu. It will open another TwyTextMorph on place holder text. And you can change any attributes.

It seams that place holder should be part of higher level widgets. But my implementation provides very simple solution.
"
Class {
	#name : #TwyPlaceHolderTool,
	#superclass : #TwyTextTool,
	#instVars : [
		'placeHolderText',
		'realTextLayout'
	],
	#category : #'Twisty-UI'
}

{ #category : #'instance creation' }
TwyPlaceHolderTool class >> with: placeHolderText [

	^self new 
		placeHolderText: placeHolderText 
]

{ #category : #controlling }
TwyPlaceHolderTool >> attachToMorph [

	realTextLayout := textMorph textLayout.
]

{ #category : #controlling }
TwyPlaceHolderTool >> attachToText [

	self text when: TwyChangesCompleted send: #textChanged to: self.
	
	self textChanged
]

{ #category : #controlling }
TwyPlaceHolderTool >> detachFromText [
	self text unsubscribe: self
]

{ #category : #testing }
TwyPlaceHolderTool >> isAttachedToText [
	^self text hasSubscriber: self
]

{ #category : #accessing }
TwyPlaceHolderTool >> placeHolderText [
	^ placeHolderText
]

{ #category : #accessing }
TwyPlaceHolderTool >> placeHolderText: anObject [
	placeHolderText := anObject
]

{ #category : #menu }
TwyPlaceHolderTool >> populateMenu: aMenu [
	super populateMenu: aMenu.
	
	aMenu add: 'change place holder' translated target: self selector: #requestNewPlaceHolder
]

{ #category : #menu }
TwyPlaceHolderTool >> requestNewPlaceHolder [
	
	| editor |
	editor := TwyTextMorph new.
	editor layoutStrategy: TwyNativeLayoutStrategy new.
	editor text: placeHolderText.
	editor beEditable.
	editor openInHand
]

{ #category : #private }
TwyPlaceHolderTool >> setUpPlaceHolder [

	| placeHolderLayout |
	placeHolderLayout := textMorph layoutStrategy layoutText: placeHolderText.
	textMorph textLayout: placeHolderLayout.		
	
]

{ #category : #private }
TwyPlaceHolderTool >> setUpRealText [

	| placeHolderLayout |
	placeHolderLayout := textMorph textLayout.
	placeHolderLayout detachText.
	
	textMorph textLayout: realTextLayout
]

{ #category : #private }
TwyPlaceHolderTool >> textChanged [

	(self text isEmpty and: [ textMorph textLayout == realTextLayout ]) ifTrue: [ 
		^self setUpPlaceHolder].
		
	(self text isEmpty not and: [ textMorph textLayout ~= realTextLayout ]) ifTrue: [ 
		^self setUpRealText]
		
	
]
