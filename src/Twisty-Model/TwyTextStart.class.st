"
I present start of text
"
Class {
	#name : #TwyTextStart,
	#superclass : #TwyLineStart,
	#category : #'Twisty-Model'
}

{ #category : #editing }
TwyTextStart >> delete [
]

{ #category : #'initialize-release' }
TwyTextStart >> initialOrderNumber [

	^0
]

{ #category : #testing }
TwyTextStart >> isDeleted [
	^false
]

{ #category : #testing }
TwyTextStart >> isTextStart [
	^true
]

{ #category : #accessing }
TwyTextStart >> itemAt: anIndex ifAbsent: absentBlock [
	^absentBlock value
]

{ #category : #accessing }
TwyTextStart >> length [
	^0
]

{ #category : #accessing }
TwyTextStart >> previousSpanIfAbsent: aBlock [
	^aBlock value
]
