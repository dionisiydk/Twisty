Class {
	#name : #TwyElementsReadStreamTests,
	#superclass : #TestCase,
	#instVars : [
		'elementsStream'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #helpers }
TwyElementsReadStreamTests >> createStreamOn: aString [

	elementsStream := TwyElementsReadStream on: aString readStream.
]

{ #category : #tests }
TwyElementsReadStreamTests >> testAtEndAfterLastLineSeparator [

	self createStreamOn: 'single line', String cr.
	
	elementsStream next; next.
	
	elementsStream atEnd should be: true
]

{ #category : #tests }
TwyElementsReadStreamTests >> testAtEndAfterLastSingleString [

	self createStreamOn: 'single line'.
	
	elementsStream next.
	
	elementsStream atEnd should be: true
]

{ #category : #tests }
TwyElementsReadStreamTests >> testAtEndAfterLastTabSeparator [

	self createStreamOn: 'single line', String tab.
	
	elementsStream next; next.
	
	elementsStream atEnd should be: true
]

{ #category : #tests }
TwyElementsReadStreamTests >> testHasCharactersPerSpanLimitBuDefault [

	TwyElementsReadStream new charactersPerSpan should equal: 200
]

{ #category : #tests }
TwyElementsReadStreamTests >> testNotAtEndBeforeFullText [

	self createStreamOn: 'single line', String cr.
	
	elementsStream atEnd should be: false
]

{ #category : #tests }
TwyElementsReadStreamTests >> testNotAtEndBeforeLastLineSeparator [

	self createStreamOn: 'single line', String cr.
	
	elementsStream next.
	
	elementsStream atEnd should be: false
]

{ #category : #tests }
TwyElementsReadStreamTests >> testNotAtEndBeforeLastTabSeparator [

	self createStreamOn: 'single line', String tab.
	
	elementsStream next.
	
	elementsStream atEnd should be: false
]

{ #category : #tests }
TwyElementsReadStreamTests >> testOnSimpleStringWithSingleLine [
	| actual |
	self createStreamOn: 'single line'.
	actual := elementsStream next.
	actual should beInstanceOf: TwyCharactersSpan.
	actual contents should equal: 'single line'
]

{ #category : #tests }
TwyElementsReadStreamTests >> testOnSimpleStringWithTooLongLine [
	| first last |
	self createStreamOn: '12345'.
	elementsStream charactersPerSpan: 4.
	first := elementsStream next.
	first should beInstanceOf: TwyCharactersSpan.
	first contents should equal: '1234'.
	last := elementsStream next.
	last should beInstanceOf: TwyCharactersSpan.
	last contents should equal: '5'
]

{ #category : #tests }
TwyElementsReadStreamTests >> testOnSimpleStringWithTwoLines [
	| first second last |
	self createStreamOn: 'line1' , String cr , 'line2'.
	first := elementsStream next.
	first should beInstanceOf: TwyCharactersSpan.
	first contents should equal: 'line1'.
	second := elementsStream next.
	second should beInstanceOf: TwyLineStart.
	last := elementsStream next.
	last should beInstanceOf: TwyCharactersSpan.
	last contents should equal: 'line2'
]

{ #category : #tests }
TwyElementsReadStreamTests >> testOnStringWithTab [
	| first second last |
	self createStreamOn: 'span1' , String tab , 'span2'.
	first := elementsStream next.
	first should beInstanceOf: TwyCharactersSpan.
	first contents should equal: 'span1'.
	second := elementsStream next.
	second should beInstanceOf: TwyTabSpan.
	last := elementsStream next.
	last should beInstanceOf: TwyCharactersSpan.
	last contents should equal: 'span2'
]

{ #category : #tests }
TwyElementsReadStreamTests >> testOnStringWithTabAndFolowedNewLine [
	| first second last third |
	self createStreamOn: 'span1' , String tab , String cr , 'span2'.
	first := elementsStream next.
	first should beInstanceOf: TwyCharactersSpan.
	first contents should equal: 'span1'.
	second := elementsStream next.
	second should beInstanceOf: TwyTabSpan.
	third := elementsStream next.
	third should beInstanceOf: TwyLineStart.
	last := elementsStream next.
	last should beInstanceOf: TwyCharactersSpan.
	last contents should equal: 'span2'
]
