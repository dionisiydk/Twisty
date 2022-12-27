Class {
	#name : #TwyTextPart,
	#superclass : #Object,
	#instVars : [
		'text',
		'startBoundarySpan',
		'endBoundarySpan'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyTextPart class >> from: startCursor to: endCursor [
	^self new 
		setUpFrom: startCursor to: endCursor
]

{ #category : #editing }
TwyTextPart >> editContentsBy: editBlock andSubmitChangesBy: validationBlock [
	^text editContentsBy: editBlock andSubmitChangesBy: validationBlock
]

{ #category : #accessing }
TwyTextPart >> end [
	^ endBoundarySpan next
]

{ #category : #accessing }
TwyTextPart >> endBoundarySpan [
	^ endBoundarySpan
]

{ #category : #accessing }
TwyTextPart >> endBoundarySpan: aSpanPart [
	endBoundarySpan := aSpanPart
]

{ #category : #editing }
TwyTextPart >> expandToSecondSpan [

	endBoundarySpan := startBoundarySpan convertNextSpanToTextPartEnd.
	startBoundarySpan next: endBoundarySpan
]

{ #category : #accessing }
TwyTextPart >> firstSpan [
	^startBoundarySpan
]

{ #category : #accessing }
TwyTextPart >> getAttribute: anAttributeClass [ 

	^text getAttribute: anAttributeClass
]

{ #category : #accessing }
TwyTextPart >> lastSpan [
	^endBoundarySpan
]

{ #category : #accessing }
TwyTextPart >> newActiveCursor [
	^text newActiveCursor
]

{ #category : #'cursor creation' }
TwyTextPart >> newPassiveCursorAtStart [
	^startBoundarySpan newPassiveCursorAtStart
]

{ #category : #initialization }
TwyTextPart >> setUpFrom: startCursor to: endCursor [
	text := startCursor text.
	
	(startCursor isAtSameSpanWith: endCursor) 
		ifTrue: [ startBoundarySpan := endBoundarySpan := TwySpanPart from: startCursor to: endCursor]
		ifFalse: [ startBoundarySpan := TwySpanPart endFrom: startCursor.
			endBoundarySpan := TwySpanPart startUpTo: endCursor].
		
	startBoundarySpan beStartBoundaryOf: self.	
	endBoundarySpan beEndBoundaryOf: self
]

{ #category : #accessing }
TwyTextPart >> start [
	^ startBoundarySpan previous
]

{ #category : #accessing }
TwyTextPart >> startBoundarySpan [
	^ startBoundarySpan
]

{ #category : #accessing }
TwyTextPart >> startBoundarySpan: aSpanPart [
	startBoundarySpan := aSpanPart
]

{ #category : #accessing }
TwyTextPart >> text [
	^ text
]

{ #category : #accessing }
TwyTextPart >> text: anObject [
	text := anObject
]

{ #category : #subscription }
TwyTextPart >> when: anAnnouncement send: aSymbol to: anObject [
	text when: anAnnouncement send: aSymbol to: anObject
]
