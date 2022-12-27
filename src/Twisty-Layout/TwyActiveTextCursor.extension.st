Extension { #name : #TwyActiveTextCursor }

{ #category : #'*Twisty-Layout' }
TwyActiveTextCursor >> subscribeLayoutCursor: aLayoutCursor [
	self unsubscribeLayoutCursor: aLayoutCursor.
		
	text when: TwyChangesBegin send: #textWillBeChanged to: aLayoutCursor.
	text when: TwyChangesCompleted send: #textChanged to: aLayoutCursor.
	announcer when: TwyCursorMoved send: #textCursorMoved: to: aLayoutCursor.
]

{ #category : #'*Twisty-Layout' }
TwyActiveTextCursor >> unsubscribeLayoutCursor: aLayoutCursor [
	announcer unsubscribe: aLayoutCursor.
	text unsubscribe: aLayoutCursor
]
