"
I'm collection of text tools.

    Instance Variables
	contents:		<Collecton of: <TwyTextTool>>
	textMorph:		<TwyTextMorph>

"
Class {
	#name : #TwyTextTools,
	#superclass : #Object,
	#instVars : [
		'contents',
		'textMorph'
	],
	#category : #'Twisty-UI'
}

{ #category : #accessing }
TwyTextTools >> add: aTextTool for: aTextMorph [

	contents add: aTextTool.
	aTextTool attachTo: aTextMorph.
]

{ #category : #controlling }
TwyTextTools >> attachToNewText [

	contents do: [ :each | each attachToTextIfNeeded ]
]

{ #category : #accessing }
TwyTextTools >> backgroundDecorators [
	^contents select: [ :each | each isDecoratedBackground ]
]

{ #category : #controlling }
TwyTextTools >> detachFromText [

	contents do: [ :each | each detachFromText ]
]

{ #category : #'focus management' }
TwyTextTools >> focusChanged: gotFocus [

	contents do: [ :each | each focusChanged: gotFocus ]
]

{ #category : #accessing }
TwyTextTools >> get: aTextToolClass [

	^self get: aTextToolClass ifNone: [ self error: aTextToolClass asString, ' is not registered for this morph' ]
]

{ #category : #accessing }
TwyTextTools >> get: aTextToolClass ifNone: anAbsentBlock [

	| existed |
	existed := contents detect: [ :each | each isKindOf: aTextToolClass ] ifNone: [^anAbsentBlock value].
	existed attachToTextIfNeeded.
	^existed
]

{ #category : #testing }
TwyTextTools >> includes: aToolClass [

	^contents anySatisfy: [ :each | each isKindOf: aToolClass ]
]

{ #category : #'initialize-release' }
TwyTextTools >> initialize [ 
	super initialize.
	
	contents := OrderedCollection new: 2
]

{ #category : #menu }
TwyTextTools >> populateMenu: aMenu [

	contents do: [ :each | each populateMenu: aMenu ]	
]

{ #category : #printing }
TwyTextTools >> printOn: aStream [

	super printOn: aStream.
	contents asArray printOn: aStream
]
