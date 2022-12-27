"
I'm active text cursor.

I subscribe on text changes and automatically fix my position after text changes.
You should detach me from text by #detachText when I'm not needed no more.

I announce my movement events
"
Class {
	#name : #TwyActiveTextCursor,
	#superclass : #TwyTextCursor,
	#instVars : [
		'announcer'
	],
	#category : #'Twisty-Model'
}

{ #category : #accessing }
TwyActiveTextCursor >> announcer [
	
	^ announcer
]

{ #category : #accessing }
TwyActiveTextCursor >> announcer: anObject [
	
	announcer := anObject
]

{ #category : #converting }
TwyActiveTextCursor >> asActiveCursor [
	^self
]

{ #category : #converting }
TwyActiveTextCursor >> asPassiveCursor [
	
	^span newPassiveCursor
		spanPosition: spanPosition;
		yourself
]

{ #category : #accessing }
TwyActiveTextCursor >> copy [

	| copy |
	copy := span newActiveCursor.
	copy moveTo: self.
	^copy
]

{ #category : #controlling }
TwyActiveTextCursor >> detachText [
	text unsubscribe: self
]

{ #category : #'initialize-release' }
TwyActiveTextCursor >> initialize [ 
	super initialize.
	announcer := Announcer new
]

{ #category : #private }
TwyActiveTextCursor >> publishMovement: aTwyCursorMoved [

	announcer announce: aTwyCursorMoved
]

{ #category : #accessing }
TwyActiveTextCursor >> text: aTwyText [ 
	super text: aTwyText.
	text when: TwyTextStateChanged send: #textChangedWith: to: self.
	announcer when: TwyCursorMoved send: #publishChange: to: aTwyText
]

{ #category : #private }
TwyActiveTextCursor >> textChangedWith: aTwyStateChanged [

	aTwyStateChanged correctPositionOf: self.
	 
]
