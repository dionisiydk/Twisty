Class {
	#name : #TwyLayoutBuiltCommandTestCase,
	#superclass : #TestCase,
	#instVars : [
		'command',
		'builder'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #testing }
TwyLayoutBuiltCommandTestCase class >> isAbstract [ 
	^self = TwyLayoutBuiltCommandTestCase
]

{ #category : #helpers }
TwyLayoutBuiltCommandTestCase >> executeCommand [

	command executeBy: builder
]

{ #category : #running }
TwyLayoutBuiltCommandTestCase >> setUp [ 	
	super setUp.
	
	builder := Mock new.
	command := self commandClass new.
]

{ #category : #tests }
TwyLayoutBuiltCommandTestCase >> testIsNotSimilarToDifferentKindOfCommand [

	| differentKindCommand |
	differentKindCommand := TwyLayoutBuiltCommand allSubclasses detect: [ :each | each ~= command class ].
	
	(command isSimilarTo: differentKindCommand new) should be: false
]

{ #category : #tests }
TwyLayoutBuiltCommandTestCase >> testIsSimilarToYourself [

	command isSimilarTo: command
]
