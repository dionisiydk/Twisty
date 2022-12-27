Class {
	#name : #TwyTabSpanTests,
	#superclass : #TwyElementTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwyTabSpanTests >> testConvertingToStringOnStream [

	| stream |
	
	stream := String new writeStream.
	
	textElement asStringOn: stream.
	
	stream contents should equal: String tab
]

{ #category : #tests }
TwyTabSpanTests >> testConvertingToStringStartingAtEnd [

	| stream |
	
	stream := String new writeStream.
	
	textElement asStringOn: stream startingAt: 1.
	
	stream contents should equal: ''
]

{ #category : #tests }
TwyTabSpanTests >> testConvertingToStringStartingAtMiddleUpToMiddle [

	| stream |
	
	stream := String new writeStream.
	
	textElement asStringOn: stream startingAt: 0 upTo: 1.
	
	stream contents should equal: String tab
]

{ #category : #tests }
TwyTabSpanTests >> testConvertingToStringStartingAtStart [

	| stream |
	
	stream := String new writeStream.
	
	textElement asStringOn: stream startingAt: 0.
	
	stream contents should equal: String tab
]

{ #category : #tests }
TwyTabSpanTests >> testConvertingToStringUpToEnd [

	| stream |

	stream := String new writeStream.
	
	textElement asStringOn: stream upTo: 1.
	
	stream contents should equal: String tab
]

{ #category : #tests }
TwyTabSpanTests >> testConvertingToStringUpToStart [

	| stream |

	stream := String new writeStream.
	
	textElement asStringOn: stream upTo: 0.
	
	stream contents should equal: ''
]

{ #category : #tests }
TwyTabSpanTests >> testCreateDrawerByLayoutBuilder [
	| actual |
	[ :layoutBuilder | 
	[ actual := textElement createDrawerBy: layoutBuilder ] should
		strictly
		satisfy: [ (layoutBuilder selectFontFor: textElement) willReturn: #font ].
	actual should beInstanceOf: TwyTabSpanDrawer.
	actual font should be: #font ] runWithMocks
]

{ #category : #tests }
TwyTabSpanTests >> testSingleItemShoudBeTabCharacter [

	textElement singleItem should equal: Character tab
]

{ #category : #running }
TwyTabSpanTests >> textElementClass [
	^TwyTabSpan
]
