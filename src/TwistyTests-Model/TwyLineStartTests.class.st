Class {
	#name : #TwyLineStartTests,
	#superclass : #TwyElementTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwyLineStartTests >> testConvertingToStringOnStream [

	| stream |
	
	stream := String new writeStream.
	
	textElement asStringOn: stream.
	
	stream contents should equal: String cr
]

{ #category : #tests }
TwyLineStartTests >> testGettingItemAtFirstPositionShouldReturnCR [ 

	| actual |
	actual := textElement itemAt: 1 ifAbsent: [ #absent ].
	
	actual should equal: Character cr
]

{ #category : #tests }
TwyLineStartTests >> testGettingItemAtNotFirstPositionShouldExecuteAbsentBlock [

	| actual |
	actual := textElement itemAt: 2 ifAbsent: [ #absent ].
	
	actual should be: #absent
]

{ #category : #running }
TwyLineStartTests >> textElementClass [ 	
	^TwyLineStart
]
