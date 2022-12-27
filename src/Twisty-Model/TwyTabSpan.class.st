"
I present text tab as single separated text element
"
Class {
	#name : #TwyTabSpan,
	#superclass : #TwySolidSpan,
	#category : #'Twisty-Model'
}

{ #category : #converting }
TwyTabSpan >> asStringOn: aStream [

	aStream nextPut: self singleItem
]

{ #category : #accessing }
TwyTabSpan >> singleItem [ 

	^Character tab
]
