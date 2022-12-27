"
I'm the root of the hierarchy of text tools.

My subclasses are responsible for specific behaviour of text morph.
It can be editor tool, selection tool, cursor tool, undo/redo tool and others. Text morph contains collection of such tools. Different combination of tools supplies different behavior. For example, text morph without any tools is simple readonly text field. Text morph with selection tool allows select text region and copy it to clipboard. If cursor tool are added to morph then blinked cursor are shown for visible text navigation.

Tools approach allows replace usual hierarchy of text morphs by composition of tool classes.

My subclasses should implement three methods:

- attachToMorph is responsible for morph events subscription
- attachToText is responsible for text events subscription. It can fetch required objects from text like cursors and regions.
- detachFromText should unsubscribe from text instance
- isAttachedToText. It is used to not subscribe on text twice

As extra posibilities tools can supply text background decoration to draw extra details on text morph. Selection highlighting is implemented such way. TwySelectionTool is decorated background.

Also tools can populate halo menu with add new controlling actions.

Internal Representation and Key Implementation Points.

    Instance Variables
	textMorph:		<TwyTextMorph>
"
Class {
	#name : #TwyTextTool,
	#superclass : #Object,
	#instVars : [
		'textMorph'
	],
	#category : #'Twisty-UI'
}

{ #category : #controlling }
TwyTextTool >> attachTo: aTextMorph [
	textMorph := aTextMorph.
	self attachToMorph.
	self attachToText
]

{ #category : #controlling }
TwyTextTool >> attachToMorph [
	self subclassResponsibility 
]

{ #category : #controlling }
TwyTextTool >> attachToText [
	self subclassResponsibility 
]

{ #category : #controlling }
TwyTextTool >> attachToTextIfNeeded [
	self isAttachedToText ifFalse: [ self attachToText ].
]

{ #category : #controlling }
TwyTextTool >> detachFromText [
	self subclassResponsibility 
]

{ #category : #'focus management' }
TwyTextTool >> focusChanged: gotFocus [
]

{ #category : #testing }
TwyTextTool >> isAttachedToText [
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextTool >> isDecoratedBackground [
	^false
]

{ #category : #menu }
TwyTextTool >> populateMenu: aMenu [
]

{ #category : #accessing }
TwyTextTool >> text [
	^textMorph text
]

{ #category : #accessing }
TwyTextTool >> textLayout [
	^textMorph textLayout
]
