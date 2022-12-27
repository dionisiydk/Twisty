"
I present fore (font) color of text span.

My value is instance of Color
"
Class {
	#name : #TwyForeColorAttribute,
	#superclass : #TwyAttribute,
	#category : #'Twisty-Model'
}

{ #category : #accessing }
TwyForeColorAttribute class >> defaultValue [ 
	^Color black
]
