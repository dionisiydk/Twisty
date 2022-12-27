Class {
	#name : #TwyElementChangedTestCase,
	#superclass : #TwyTextChangeAnnouncementTestCase,
	#instVars : [
		'element'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #testing }
TwyElementChangedTestCase class >> isAbstract [
	^self == TwyElementChangedTestCase
]

{ #category : #running }
TwyElementChangedTestCase >> setUp [
	super setUp.
	
	element := Mock new.
	change element: element
]

{ #category : #tests }
TwyElementChangedTestCase >> testCorrectionAffectedLayoutSpans [

	[ :firstLayoutSpan :layoutBuilder :eachLayoutSpan |
		[ change correctAffectedLayoutSpansStartingAt: firstLayoutSpan by: layoutBuilder ]
			should strictly satisfy: 
		[ (firstLayoutSpan rightDo: Any while: Any) will: [ :action :condition |
			(condition value: eachLayoutSpan) should be: #isSpanCoversElement.
			action value: eachLayoutSpan ].
		(eachLayoutSpan isCovers: element) willReturn: #isSpanCoversElement.
		eachLayoutSpan fixRightBorder.
		layoutBuilder updateDrawerFor: eachLayoutSpan.
		layoutBuilder addCorrectionCommandFor: firstLayoutSpan]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsAboutContentsChangesOfOwnSpan [
	
	(change isAboutContentsChangesOfSpan: element) should be: true
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsAffectLayoutLine [

	| layoutLine |
	layoutLine := Mock new.
	(layoutLine stub isCovers: element) willReturn: #result.
	
	(change isAffectLayoutLine: layoutLine) should be: #result.
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsAffectLayoutSpan [

	| layoutSpan |
	layoutSpan := Mock new.
	(layoutSpan stub isCovers: element) willReturn: #result.
	
	(change isAffectLayoutSpan: layoutSpan) should be: #result.
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsAffectTextAfterElement [

	(element stub isAfter: #someElement) willReturn: #result.

	(change isAffectTextAfterElement: #someElement) should be: #result
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsAffectTextAtGivenPosition [

	| cursor |
	cursor := Mock new.
	(cursor stub isAt: element) willReturn: #result.
	
	(change isAffectTextAt: cursor) should be: #result.
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsAffectTextBeforeElement [

	(element stub isBefore: #someElement) willReturn: #result.

	(change isAffectTextBeforeElement: #someElement) should be: #result
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsAfterTextCursor [

	| cursor |
	cursor := Mock new.
	(cursor stub isBeforeOrAtStartOfElement: element) willReturn: #result.
	
	(change isAfter: cursor) should be: #result.
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsBeforeChange [

	| anotherChange |
	anotherChange := Mock new.
	(anotherChange stub isAffectTextAfterElement: element) willReturn: #result.
	
	(change isBeforeChange: anotherChange) should be: #result.
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsEmbodyAnotherChange [

	| anotherChange |
	anotherChange := Mock new.
	(anotherChange stub isAboutContentsChangesOfSpan: element) willReturn: #result.
	
	(change isEmbody: anotherChange) should be: #result
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsNotAboutContentsChangesOfAnotherElement [
	
	(change isAboutContentsChangesOfSpan: #anotherElement) should be: false
]

{ #category : #tests }
TwyElementChangedTestCase >> testIsRedundantWhenElementIsDeleted [

	element stub isDeleted willReturn: #result.
	
	change isRedundant should be: #result
]
