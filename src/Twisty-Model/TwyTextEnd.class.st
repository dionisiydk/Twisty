"
I present end of text
"
Class {
	#name : #TwyTextEnd,
	#superclass : #TwyElement,
	#category : #'Twisty-Model'
}

{ #category : #editing }
TwyTextEnd >> delete [
]

{ #category : #'initialize-release' }
TwyTextEnd >> initialOrderNumber [

	^1.0
]

{ #category : #testing }
TwyTextEnd >> isDeleted [
	^false
]

{ #category : #testing }
TwyTextEnd >> isTextEnd [
	^true
]

{ #category : #accessing }
TwyTextEnd >> itemAt: anIndex ifAbsent: absentBlock [
	^absentBlock value
]

{ #category : #accessing }
TwyTextEnd >> nextSpanIfAbsent: aBlock [
	^aBlock value
]
