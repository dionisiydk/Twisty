Class {
	#name : #TwyTextValidatorTests,
	#superclass : #TwyTextValidatorTestCase,
	#instVars : [
		'textSpec'
	],
	#category : #'TwistyTests-Editor'
}

{ #category : #running }
TwyTextValidatorTests >> setUp [
	super setUp.
	
	textSpec := Mock new.
	validator textSpec: textSpec.
]

{ #category : #tests }
TwyTextValidatorTests >> testHasTextSpecByDefault [
	TwyTextValidator new textSpec should beInstanceOf: TwyAnyTextSpec
]

{ #category : #tests }
TwyTextValidatorTests >> testValidationText [

	[ :textDecorator |
		[ (validator validateText: #text decoratedBy: textDecorator) should be: #result]
			should strictly satisfy:			
		[ (textDecorator extractNativeStringFrom: #text) willReturn: #textString.
		(textSpec check: #textString) willReturn: #result]
	] runWithMocks 
]

{ #category : #running }
TwyTextValidatorTests >> validatorClass [
	^TwyTextValidator 
]
