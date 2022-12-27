"
I'm announcement about cursor movement.

Public API and Key Messages

- correctLayoutPositionOf: aLayoutCursor
- isAboutSameCursorAs: aTwyCursorMoved
- instances created by #startingAt: aTwyCursor
 
Internal Representation and Key Implementation Points.

    Instance Variables
	cursor:		<TwyCursor>
	oldPosition:		<Integer>
	oldSpan:		<TwySpan>
"
Class {
	#name : #TwyCursorMoved,
	#superclass : #TwyImmediateChangeAnnouncement,
	#instVars : [
		'cursor',
		'oldSpan',
		'oldPosition'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyCursorMoved class >> startingAt: aCursor [
	^(self onText: aCursor text)
		cursor: aCursor;
		oldSpan: aCursor span;
		oldPosition: aCursor spanPosition
]

{ #category : #cancelling }
TwyCursorMoved >> cancel [
	
	cursor moveToSpan: oldSpan at: oldPosition
]

{ #category : #layout }
TwyCursorMoved >> correctLayoutPositionOf: aLayoutCursor [ 
	(cursor isAfterPosition: oldPosition atSpan: oldSpan) 
		ifTrue: [aLayoutCursor textCursorMovedToRight ]
		ifFalse: [ aLayoutCursor textCursorMovedToLeft]

]

{ #category : #accessing }
TwyCursorMoved >> cursor [
	
	^ cursor
]

{ #category : #accessing }
TwyCursorMoved >> cursor: anObject [
	
	cursor := anObject
]

{ #category : #testing }
TwyCursorMoved >> isAboutSameCursorAs: aCursorMoved [
	^cursor == aCursorMoved cursor
]

{ #category : #testing }
TwyCursorMoved >> isTextStateChange [
	^false
]

{ #category : #accessing }
TwyCursorMoved >> oldPosition [
	
	^ oldPosition
]

{ #category : #accessing }
TwyCursorMoved >> oldPosition: anObject [
	
	oldPosition := anObject
]

{ #category : #accessing }
TwyCursorMoved >> oldSpan [
	
	^ oldSpan
]

{ #category : #accessing }
TwyCursorMoved >> oldSpan: anObject [
	
	oldSpan := anObject
]
