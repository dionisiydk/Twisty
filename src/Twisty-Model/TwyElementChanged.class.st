"
I'm the root of the hierarchy of text changes which affect single element.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	element:		<TwyElement>
"
Class {
	#name : #TwyElementChanged,
	#superclass : #TwyTextStateChanged,
	#instVars : [
		'element'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyElementChanged class >> on: aTwyElement [ 
	^(self onText: aTwyElement text) 
		element: aTwyElement
]

{ #category : #'layout span correction' }
TwyElementChanged >> correctAffectedLayoutSpansStartingAt: aLayoutSpan by: aLayoutBuilder [

	aLayoutSpan 
		rightDo: [ :eachSpan | 
			eachSpan fixRightBorder.
			aLayoutBuilder updateDrawerFor: eachSpan ]
		while: [ :eachSpan | eachSpan isCovers: element ].
		
	aLayoutBuilder addCorrectionCommandFor: aLayoutSpan
]

{ #category : #accessing }
TwyElementChanged >> element [
	
	^ element
]

{ #category : #accessing }
TwyElementChanged >> element: anObject [
	
	element := anObject
]

{ #category : #testing }
TwyElementChanged >> isAboutContentsChangesOfSpan: aTwySpan [
	^element == aTwySpan
]

{ #category : #testing }
TwyElementChanged >> isAffectLayoutLine: aLayoutLine [
	^aLayoutLine isCovers: element
]

{ #category : #testing }
TwyElementChanged >> isAffectLayoutSpan: aLayoutSpan [
	^aLayoutSpan isCovers: element
]

{ #category : #testing }
TwyElementChanged >> isAffectTextAfterElement: aTextElement [
	^element isAfter: aTextElement
]

{ #category : #testing }
TwyElementChanged >> isAffectTextAt: aTextCursor [
	^aTextCursor isAt: element
]

{ #category : #testing }
TwyElementChanged >> isAffectTextBeforeElement: aTextElement [
	^element isBefore: aTextElement
]

{ #category : #testing }
TwyElementChanged >> isAfter: aTextCursor [
	^aTextCursor isBeforeOrAtStartOfElement: element 
]

{ #category : #testing }
TwyElementChanged >> isBeforeChange: aTextChange [
	
	^aTextChange isAffectTextAfterElement: element
]

{ #category : #testing }
TwyElementChanged >> isEmbody: anotherTextChange [
	^ anotherTextChange isAboutContentsChangesOfSpan: element
]

{ #category : #testing }
TwyElementChanged >> isRedundant [
	^element isDeleted
]
