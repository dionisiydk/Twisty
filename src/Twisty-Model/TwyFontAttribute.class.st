"
I present font of text span.


"
Class {
	#name : #TwyFontAttribute,
	#superclass : #TwyAttribute,
	#category : #'Twisty-Model'
}

{ #category : #accessing }
TwyFontAttribute class >> defaultValue [ 
	^TextStyle defaultFont 
]

{ #category : #copying }
TwyFontAttribute >> deepCopy [
	^self class with: value
]
