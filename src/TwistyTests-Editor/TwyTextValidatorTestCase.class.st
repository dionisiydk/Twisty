Class {
	#name : #TwyTextValidatorTestCase,
	#superclass : #TestCase,
	#instVars : [
		'validator'
	],
	#category : #'TwistyTests-Editor'
}

{ #category : #testing }
TwyTextValidatorTestCase class >> isAbstract [ 	
	^self == TwyTextValidatorTestCase 
]

{ #category : #running }
TwyTextValidatorTestCase >> setUp [
	super setUp.
	
	validator := self validatorClass new.
	
]
