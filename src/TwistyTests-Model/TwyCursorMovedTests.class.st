Class {
	#name : #TwyCursorMovedTests,
	#superclass : #TwyTextChangeAnnouncementTestCase,
	#instVars : [
		'cursor',
		'oldSpan',
		'oldPosition'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyCursorMovedTests >> setUp [
	super setUp.
	
	cursor := Mock new.
	oldSpan := #oldSpan.
	oldPosition := #oldPosition.
	
	change 
		cursor: cursor;
		oldSpan: oldSpan;
		oldPosition: oldPosition
]

{ #category : #tests }
TwyCursorMovedTests >> testCancelling [

	[ 
		[ change cancel ]
			should strictly satisfy: 
		[ cursor moveToSpan: oldSpan at: oldPosition ]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyCursorMovedTests >> testIsAboutSameCursorAsAnotherMovement [

	| anotherMovement |
	anotherMovement := TwyCursorMoved new.
	anotherMovement cursor: cursor.
	
	(change isAboutSameCursorAs: anotherMovement) should be: true.
	
	anotherMovement cursor: #anotherCursor.
	
	(change isAboutSameCursorAs: anotherMovement) should be: false.
]

{ #category : #running }
TwyCursorMovedTests >> textChangeClass [
	^TwyCursorMoved
]
