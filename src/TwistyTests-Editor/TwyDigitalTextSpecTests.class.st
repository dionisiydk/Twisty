Class {
	#name : #TwyDigitalTextSpecTests,
	#superclass : #TwyTextSpecTestCase,
	#category : #'TwistyTests-Editor'
}

{ #category : #tests }
TwyDigitalTextSpecTests >> testEmptyStringShouldBeValid [

	| actual |
	actual := TwyDigitalTextSpec new check: ''.
	
	actual should be: true
]

{ #category : #tests }
TwyDigitalTextSpecTests >> testStringWithAllDigitsShouldBeValid [

	| actual |
	actual := TwyDigitalTextSpec new check: '123'.
	
	actual should be: true
]

{ #category : #tests }
TwyDigitalTextSpecTests >> testStringWithAlmostOneNotDigitCharaterShouldBeNotValid [

	| actual |
	actual := TwyDigitalTextSpec new check: '12 3'.
	
	actual should be: false
]
