"
I'm passive text cursor. 
After text changes my position can be broken. Somebody should manually fix it or use me for one shot operations.

I not announce any movement events
"
Class {
	#name : #TwyPassiveTextCursor,
	#superclass : #TwyTextCursor,
	#category : #'Twisty-Model'
}

{ #category : #converting }
TwyPassiveTextCursor >> asActiveCursor [

	^span newActiveCursor
		spanPosition: spanPosition;
		yourself
]

{ #category : #converting }
TwyPassiveTextCursor >> asPassiveCursor [
	^self
]

{ #category : #private }
TwyPassiveTextCursor >> detachText [
]

{ #category : #accessing }
TwyPassiveTextCursor >> incrementSpanPositionBy: delta [
	spanPosition := spanPosition + delta
]

{ #category : #private }
TwyPassiveTextCursor >> publishMovement: aTwyCursorMoved [
]
