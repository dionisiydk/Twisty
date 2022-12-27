Class {
	#name : #TwyDecimalTextSpecTests,
	#superclass : #TwyTextSpecTestCase,
	#instVars : [
		'spec'
	],
	#category : #'TwistyTests-Editor'
}

{ #category : #running }
TwyDecimalTextSpecTests >> setUp [
	super setUp.
	
	spec := TwyDecimalTextSpec new
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testDigitalStringWithDecimalSeparatorShouldBeNotValidWhenZeroDecimalDigitsCount [

	| actual |
	spec decimalDigitsCount: 0.
	
	actual := spec check: '1.3'.
	
	actual should be: false
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testDigitalStringWithFirstDecimalSeparatorShouldBeValid [

	| actual |
	actual := spec check: '.1'.
	
	actual should be: true
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testDigitalStringWithLastDecimalSeparatorShouldBeValid [

	| actual |
	actual := spec check: '123.'.
	
	actual should be: true
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testDigitalStringWithSecondDecimalSeparatorShouldBeValid [

	| actual |
	spec decimalSeparators: '.,'.
	
	actual := spec check: '1,3'.
	
	actual should be: true
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testDigitalStringWithTooMuchDecimalDigitsShouldBeNotValid [

	| actual |
	spec decimalDigitsCount: 1.
	actual := spec check: '123.34'.
	
	actual should be: false
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testDigitalStringWithTwoDecimalSeparatorsShouldBeNotValid [

	| actual |
	actual := spec check: '12.3.3'.
	
	actual should be: false
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testDigitalStringWithTwoDifferentDecimalSeparatorsShouldBeNotValid [

	| actual |
	spec decimalSeparators: ',.'.
	
	actual := spec check: '1,23.'.
	
	actual should be: false
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testEmptyStringShouldBeValid [

	| actual |
	actual := spec check: ''.
	
	actual should be: true
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testHasDecimalDigitsCountByDefault [

	spec decimalDigitsCount should equal: 2
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testHasDecimalSeparatorsByDefault [

	spec decimalSeparators should equal: '.'
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testOnlyDecimalSeparatorShouldBeValid [

	| actual |
	actual := spec check: '.'.
	
	actual should be: true
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testStringWithAllDigitsShouldBeValid [

	| actual |
	actual := spec check: '123'.
	
	actual should be: true
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testStringWithAlmostOneNotDigitalCharacterShouldBeNotValid [

	| actual |
	actual := spec check: '123.2 3'.
	
	actual should be: false
]

{ #category : #tests }
TwyDecimalTextSpecTests >> testStringWithDecimalDigitsShouldBeValid [

	| actual |
	actual := spec check: '123.23'.
	
	actual should be: true
]
