"
I'm the root of the hierarchy of text state changes.
My subcasses implement required methods for ordering each others, for correction text cursors and affected layout spans

Public API and Key Messages

- correctPositionOf: aTwyCursor
- correctAffectedLayoutSpansStartingAt: aLayoutSpan by: aLayoutBuilder
- isRedundant
- isEmbody: anotherChange.
- see testing category
"
Class {
	#name : #TwyTextStateChanged,
	#superclass : #TwyImmediateChangeAnnouncement,
	#category : #'Twisty-Model'
}

{ #category : #'layout span correction' }
TwyTextStateChanged >> correctAffectedLayoutSpansStartingAt: aLayoutSpan by: aLayoutBuilder [
	self subclassResponsibility 
]

{ #category : #'cursor position correction' }
TwyTextStateChanged >> correctPositionOf: aTextCursor [
	
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextStateChanged >> isAboutContentsChangesOfSpan: aTwySpan [
	^false
]

{ #category : #testing }
TwyTextStateChanged >> isAffectLayoutLine: aLayoutLine [
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextStateChanged >> isAffectLayoutSpan: aLayoutSpan [
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextStateChanged >> isAffectTextAfterElement: aTextElement [
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextStateChanged >> isAffectTextAt: aTextCursor [
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextStateChanged >> isAffectTextBeforeElement: aTextElement [
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextStateChanged >> isAfter: aTextCursor [
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextStateChanged >> isBeforeChange: aTextChange [
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextStateChanged >> isEmbody: anotherTextChange [
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextStateChanged >> isRedundant [
	"
	Change is redundant when another change has more affect to changed elements. For example elementInserted change become redundant when inserted element is deleted.
	"
	self subclassResponsibility 
]

{ #category : #testing }
TwyTextStateChanged >> isTextStateChange [
	^true
]
