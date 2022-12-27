"
I present start of text line
"
Class {
	#name : #TwyLineStart,
	#superclass : #TwyElement,
	#category : #'Twisty-Model'
}

{ #category : #converting }
TwyLineStart >> asStringOn: aStream [

	aStream nextPut: Character cr
]

{ #category : #testing }
TwyLineStart >> isLineStart [
	^true
]

{ #category : #accessing }
TwyLineStart >> itemAt: anIndex ifAbsent: absentBlock [
	^anIndex = 1 ifTrue: [ Character cr ] ifFalse: absentBlock
]

{ #category : #accessing }
TwyLineStart >> length [
	^1
]
