Class {
	#name : #TwyDefaultAttributeChangedTests,
	#superclass : #TwyTextChangeAnnouncementTestCase,
	#instVars : [
		'initialAttribute',
		'newAttribute'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyDefaultAttributeChangedTests >> setUp [ 
	super setUp.
	
	initialAttribute := Mock new.
	newAttribute := Mock new.
	
	change initialAttribute: initialAttribute.
	change newAttribute: newAttribute.
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testCancelling [

	[ 
		[ change cancel ]
			should strictly satisfy: 
		[ text applyDefaultAttribute: initialAttribute ]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testCancellingWhenInitialAttribiteAbsent [

	[ 
		change initialAttribute: nil.
		
		[ change cancel ]
			should strictly satisfy: 
		[ text removeAttribute: newAttribute ]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testCorrectingPositionOfCursorShouldDoesNothing [

	change correctPositionOf: #textCursor
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testCorrectionAffectedLayoutSpans [
	| command |
	[ :firstLayoutSpan :layoutBuilder :eachLayoutSpan | 
	[ change
		correctAffectedLayoutSpansStartingAt: firstLayoutSpan
		by: layoutBuilder ] should strictly
		satisfy: [ (layoutBuilder addLayoutCommand: Any) will: [ :c | command := c ] ].
	command should beInstanceOf: TwyRebuildSpanCommand.
	command span should be: firstLayoutSpan ] runWithMocks
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testIsAffectAnyLayoutLine [

	(change isAffectLayoutLine: Any) should be: true.
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testIsAffectAnyLayoutSpan [

	(change isAffectLayoutSpan: Any) should be: true.
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testIsAffectTextAtAnyGivenPosition [

	(change isAffectTextAt: Any) should be: true
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testIsAffectTextBeforeAnyElement [

	(change isAffectTextBeforeElement: Any) should be: true
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testIsAlwaysNotRedundant [

	change isRedundant should be: false
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testIsBeforeAnyChange [
	
	(change isBeforeChange: Any) should be: true.
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testIsNotAffectTextAfterAnyElement [

	(change isAffectTextAfterElement: Any) should be: false
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testIsNotAfterAnyTextCursor [
	
	(change isAfter: Any) should be: false.
]

{ #category : #tests }
TwyDefaultAttributeChangedTests >> testIsNotEmbodyAnyAnotherChange [

	(change isEmbody: Any) should be: false
]

{ #category : #running }
TwyDefaultAttributeChangedTests >> textChangeClass [
	^TwyDefaultAttributeChanged
]
