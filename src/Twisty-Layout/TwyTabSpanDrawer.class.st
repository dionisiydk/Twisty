Class {
	#name : #TwyTabSpanDrawer,
	#superclass : #TwySolidSpanDrawer,
	#instVars : [
		'font'
	],
	#category : #'Twisty-Layout'
}

{ #category : #drawing }
TwyTabSpanDrawer >> drawSpanFrom: startCursor to: endCursor on: aCanvas at: aPoint [

]

{ #category : #accessing }
TwyTabSpanDrawer >> font [
	^ font
]

{ #category : #accessing }
TwyTabSpanDrawer >> font: anObject [
	font := anObject
]

{ #category : #computing }
TwyTabSpanDrawer >> height [
	^font height
]

{ #category : #computing }
TwyTabSpanDrawer >> widthOf: aCharacter [
	^10
]
