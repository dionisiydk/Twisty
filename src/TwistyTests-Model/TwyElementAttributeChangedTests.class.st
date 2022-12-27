Class {
	#name : #TwyElementAttributeChangedTests,
	#superclass : #TwyElementChangedTestCase,
	#instVars : [
		'initialAttribute',
		'newAttribute'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyElementAttributeChangedTests >> setUp [ 
	super setUp.
	
	initialAttribute := Mock new.
	change initialAttribute: initialAttribute.
	newAttribute := Mock new.
	change newAttribute: newAttribute.
]

{ #category : #tests }
TwyElementAttributeChangedTests >> testCancelling [

	[ 
		[ change cancel ]
			should strictly satisfy: 
		[ element applyAttribute: initialAttribute ]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementAttributeChangedTests >> testCancellingWhenInitialAttributeAbsent [

	[ 
		change initialAttribute: nil.
		[ change cancel ]
			should strictly satisfy: 
		[ element removeAttribute: newAttribute ]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementAttributeChangedTests >> testCorrectingPositionOfCursorShouldDoesNothing [

	change correctPositionOf: #textCursor
]

{ #category : #running }
TwyElementAttributeChangedTests >> textChangeClass [
	^TwyElementAttributeChanged
]
