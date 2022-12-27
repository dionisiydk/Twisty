"
I'm the root of the hierarchy of text spans drawers.
My responsibility is computing extent of span items and drawing it on canvas
"
Class {
	#name : #TwySpanDrawer,
	#superclass : #Object,
	#category : #'Twisty-Layout'
}

{ #category : #drawing }
TwySpanDrawer >> drawSpanFrom: startCursor to: endCursor on: aCanvas at: aPoint [

	self subclassResponsibility 
]

{ #category : #computing }
TwySpanDrawer >> height [ 
	self subclassResponsibility 
]

{ #category : #accessing }
TwySpanDrawer >> initialExtent [
	^0 @ self height
]

{ #category : #computing }
TwySpanDrawer >> widthOf: aCharacter [
	self subclassResponsibility 
]
