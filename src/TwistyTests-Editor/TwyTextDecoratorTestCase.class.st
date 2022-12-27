Class {
	#name : #TwyTextDecoratorTestCase,
	#superclass : #TestCase,
	#instVars : [
		'decorator',
		'textSelection',
		'selectionEnd',
		'selectionStart',
		'insertedString'
	],
	#category : #'TwistyTests-Editor'
}

{ #category : #testing }
TwyTextDecoratorTestCase class >> isAbstract [
	^self == TwyTextDecoratorTestCase
]

{ #category : #helpers }
TwyTextDecoratorTestCase >> cutSelection [
	^ decorator cutSelection: textSelection
]

{ #category : #running }
TwyTextDecoratorTestCase >> decoratorClass [
	self subclassResponsibility 
]

{ #category : #helpers }
TwyTextDecoratorTestCase >> insertCharacters [
	^ decorator insertCharacters: insertedString at: textSelection
]

{ #category : #helpers }
TwyTextDecoratorTestCase >> removeNextCharacter [
	^ decorator removeNextCharacterAt: textSelection
]

{ #category : #helpers }
TwyTextDecoratorTestCase >> removePreviousCharacter [
	^ decorator removePreviousCharacterAt: textSelection
]

{ #category : #running }
TwyTextDecoratorTestCase >> setUp [ 
	super setUp.
	
	decorator := self decoratorClass new.
	insertedString := 'inserted test string'.
	
	textSelection := Mock new.
	
	selectionEnd := Mock new.
	selectionStart := Mock new.
	
	textSelection stub end willReturn: selectionEnd.
	textSelection stub start willReturn: selectionStart.

	
]
