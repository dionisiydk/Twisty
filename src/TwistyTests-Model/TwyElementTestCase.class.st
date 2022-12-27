Class {
	#name : #TwyElementTestCase,
	#superclass : #TestCase,
	#instVars : [
		'text',
		'nextElement',
		'previousElement',
		'textElement',
		'textChanges'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #testing }
TwyElementTestCase class >> isAbstract [ 
	^self == TwyElementTestCase
]

{ #category : #helpers }
TwyElementTestCase >> assertNeighboursNotChanged [
	
	textElement next should be: nextElement.
	nextElement previous should be: textElement		
	
]

{ #category : #helpers }
TwyElementTestCase >> mockNeighbours [

	nextElement := Mock new.
	previousElement := Mock new.
	textElement 
		basicNext: nextElement;
		basicPrevious: previousElement
]

{ #category : #running }
TwyElementTestCase >> setUp [
	super setUp.
	
	textChanges := OrderedCollection new.
	text := Mock new.
	(text stub publishChange: Any) will: [ :ann | textChanges add: ann ].
	nextElement := TwyElement of: text.
	nextElement order: 100.
	previousElement := TwyElement of: text.
	previousElement order: 10.
	
	textElement := self textElementClass of: text.
	textElement 
		next:  nextElement;
		previous: previousElement;
		order: 50
	
]

{ #category : #running }
TwyElementTestCase >> textElementClass [
	self subclassResponsibility 
]
