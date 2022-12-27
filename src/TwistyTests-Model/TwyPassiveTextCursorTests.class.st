Class {
	#name : #TwyPassiveTextCursorTests,
	#superclass : #TwyTextCursorTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwyPassiveTextCursorTests >> testConvertingToActiveCursor [

	| activeCursor |
	activeCursor := cursor asActiveCursor.

	activeCursor should beReturnedFrom: [ span newActiveCursor].
	activeCursor should receive spanPosition: spanPosition
]

{ #category : #tests }
TwyPassiveTextCursorTests >> testConvertingToPassiveCursorShouldReturnItself [

	cursor asPassiveCursor should be: cursor
]

{ #category : #tests }
TwyPassiveTextCursorTests >> testIncrementSpanPosition [

	cursor spanPosition: 2.
	
	cursor incrementSpanPositionBy: 1000.
	
	cursor spanPosition should equal: 1002
]

{ #category : #running }
TwyPassiveTextCursorTests >> textCursorClass [ 
	^TwyPassiveTextCursor 
]
