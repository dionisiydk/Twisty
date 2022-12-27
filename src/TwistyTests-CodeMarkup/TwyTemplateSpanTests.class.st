Class {
	#name : #TwyTemplateSpanTests,
	#superclass : #TestCase,
	#instVars : [
		'templateSpan'
	],
	#category : #'TwistyTests-CodeMarkup'
}

{ #category : #running }
TwyTemplateSpanTests >> setUp [
	super setUp.
	
	templateSpan := TwySpan of: TwyText new
	
]

{ #category : #tests }
TwyTemplateSpanTests >> testBelongsToSimilarProgramNodeOfOtherSpan [

	| anotherSpan |
	anotherSpan := TwySpan of: TwyText new.
	
	templateSpan applyAttribute: (TwyProgramNodeAttribute with: RBArgumentNode new). 
	anotherSpan applyAttribute: (TwyProgramNodeAttribute with: RBArgumentNode new).
	
	(templateSpan isBelongsToSimilarProgramNodeAs: anotherSpan) should be: true
]

{ #category : #tests }
TwyTemplateSpanTests >> testNotBelongsToAnyProgramNodeWhenItNotHasSuchAttribute [

	| anotherSpan |
	anotherSpan := TwySpan of: TwyText new.
	
	anotherSpan applyAttribute: (TwyProgramNodeAttribute with: RBArgumentNode new).
	
	(templateSpan isBelongsToSimilarProgramNodeAs: anotherSpan) should be: false
]

{ #category : #tests }
TwyTemplateSpanTests >> testNotBelongsToDifferentProgramNodeOfOtherSpan [

	| anotherSpan |
	anotherSpan := TwySpan of: TwyText new.
	
	templateSpan applyAttribute: (TwyProgramNodeAttribute with: RBGlobalNode new). 
	anotherSpan applyAttribute: (TwyProgramNodeAttribute with: RBArgumentNode new).
	
	(templateSpan isBelongsToSimilarProgramNodeAs: anotherSpan) should be: false
]

{ #category : #tests }
TwyTemplateSpanTests >> testNotBelongsToProgramNodeOfOtherSpanWhenItNotHasIt [

	| anotherSpan |
	anotherSpan := TwySpan of: TwyText new.
	
	templateSpan applyAttribute: (TwyProgramNodeAttribute with: RBGlobalNode new). 
	
	(templateSpan isBelongsToSimilarProgramNodeAs: anotherSpan) should be: false
]
