"
I present back color of text span.

My value is instance of Color
"
Class {
	#name : #TwyBackColorAttribute,
	#superclass : #TwyAttribute,
	#category : #'Twisty-Model'
}

{ #category : #accessing }
TwyBackColorAttribute class >> defaultValue [ 
	^Color transparent
]
