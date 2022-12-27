"
I happen when default text attribute changed
 
Internal Representation and Key Implementation Points.

    Instance Variables
	initialAttribute:		<TwyAttribute>
	newAttribute:		<TwyAttribute>
"
Class {
	#name : #TwyDefaultAttributeChanged,
	#superclass : #TwyTextStateChanged,
	#instVars : [
		'initialAttribute',
		'newAttribute'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyDefaultAttributeChanged class >> on: aTwyText initialAttribute: aTextAttribute newAttribute: aTextAttribute2 [

	^(self onText: aTwyText)
		initialAttribute: aTextAttribute;
		newAttribute: aTextAttribute2
]

{ #category : #cancelling }
TwyDefaultAttributeChanged >> cancel [
	
	initialAttribute ifNil: [ ^text removeAttribute: newAttribute ].
	
	text applyDefaultAttribute: initialAttribute
]

{ #category : #'layout span correction' }
TwyDefaultAttributeChanged >> correctAffectedLayoutSpansStartingAt: firstLayoutSpan by: layoutBuilder [

	layoutBuilder addLayoutCommand: (TwyRebuildSpanCommand span: firstLayoutSpan)
]

{ #category : #'cursor position correction' }
TwyDefaultAttributeChanged >> correctPositionOf: aTextCursor [
]

{ #category : #accessing }
TwyDefaultAttributeChanged >> initialAttribute [
	
	^ initialAttribute
]

{ #category : #accessing }
TwyDefaultAttributeChanged >> initialAttribute: anObject [
	
	initialAttribute := anObject
]

{ #category : #testing }
TwyDefaultAttributeChanged >> isAffectLayoutLine: aLayoutLine [
	^true
]

{ #category : #testing }
TwyDefaultAttributeChanged >> isAffectLayoutSpan: aLayoutSpan [
	^true
]

{ #category : #testing }
TwyDefaultAttributeChanged >> isAffectTextAfterElement: aTwyElement [ 	
	^false
]

{ #category : #testing }
TwyDefaultAttributeChanged >> isAffectTextAt: aTwyCursor [
	^true
]

{ #category : #testing }
TwyDefaultAttributeChanged >> isAffectTextBeforeElement: aTwyElement [ 	
	^true
]

{ #category : #testing }
TwyDefaultAttributeChanged >> isAfter: aTwyCursor [
	^false
]

{ #category : #testing }
TwyDefaultAttributeChanged >> isBeforeChange: aTwyTextChange [
	
	^true
]

{ #category : #testing }
TwyDefaultAttributeChanged >> isEmbody: aTwyTextChange [
	^false
]

{ #category : #testing }
TwyDefaultAttributeChanged >> isRedundant [
	^false
]

{ #category : #accessing }
TwyDefaultAttributeChanged >> newAttribute [
	
	^ newAttribute
]

{ #category : #accessing }
TwyDefaultAttributeChanged >> newAttribute: anObject [
	
	newAttribute := anObject
]
