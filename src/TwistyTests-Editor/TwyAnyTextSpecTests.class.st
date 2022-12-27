Class {
	#name : #TwyAnyTextSpecTests,
	#superclass : #TwyTextSpecTestCase,
	#category : #'TwistyTests-Editor'
}

{ #category : #tests }
TwyAnyTextSpecTests >> testAnyTextShouldBeValid [

	| actual |
	actual := TwyAnyTextSpec new check: nil.
	
	actual should be: true
]
