"
I'm characters drawer. I draw text with specified font
 
    Instance Variables
	font:		<Object>


"
Class {
	#name : #TwyCharactersSpanDrawer,
	#superclass : #TwySpanDrawer,
	#instVars : [
		'font'
	],
	#category : #'Twisty-Layout'
}

{ #category : #drawing }
TwyCharactersSpanDrawer >> drawSpanFrom: startCursor to: endCursor on: aCanvas at: aPoint [

	startCursor span 
		drawOn: aCanvas 
		from: startCursor spanPosition + 1 
		to: endCursor spanPosition 
		at: aPoint 
		font: font
]

{ #category : #accessing }
TwyCharactersSpanDrawer >> font [
	
	^ font
]

{ #category : #accessing }
TwyCharactersSpanDrawer >> font: anObject [
	
	font := anObject
]

{ #category : #accessing }
TwyCharactersSpanDrawer >> height [ 
	^font height
]

{ #category : #computing }
TwyCharactersSpanDrawer >> widthOf: aCharacter [
	^font widthOf: aCharacter
]
