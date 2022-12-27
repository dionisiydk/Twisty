Class {
	#name : #TwyTextCursorTestCase,
	#superclass : #TestCase,
	#instVars : [
		'text',
		'span',
		'spanPosition',
		'cursor'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #testing }
TwyTextCursorTestCase class >> isAbstract [
	^self == TwyTextCursorTestCase 
]

{ #category : #running }
TwyTextCursorTestCase >> setUp [
	super setUp.
	
	text := TwyText new.
	span := Mock new.
	(span stub isCoversSpan: span) willReturn: true.
	spanPosition := 5.
	
	cursor := self textCursorClass on: text.
	cursor span: span.
	cursor spanPosition: spanPosition.
	
	text stub
]

{ #category : #running }
TwyTextCursorTestCase >> textCursorClass [
	self subclassResponsibility 
]
