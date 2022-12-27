Class {
	#name : #TwyNullTextValidatorTests,
	#superclass : #TwyTextValidatorTestCase,
	#category : #'TwistyTests-Editor'
}

{ #category : #tests }
TwyNullTextValidatorTests >> testValidationText [

	( validator validateText: Any decoratedBy: Any) should be: true
]

{ #category : #running }
TwyNullTextValidatorTests >> validatorClass [
	^TwyNullTextValidator 
]
