Class {
	#name : #TwySpanPartTests,
	#superclass : #TwyElementTestCase,
	#instVars : [
		'startBorder',
		'endBorder',
		'fullSpan'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwySpanPartTests >> setUp [
	super setUp.

	startBorder := Mock new.
	endBorder := Mock new.
	fullSpan := Mock new.
	startBorder stub span willReturn: fullSpan.
	
	textElement 
		startBorder: startBorder;
		endBorder: endBorder
]

{ #category : #tests }
TwySpanPartTests >> testConvertNextSpanToTextPartEnd [

	| actual |
	actual := textElement convertNextSpanToTextPartEnd.
	
	actual should beInstanceOf: TwySpanPart.
	actual span should beReturnedFrom: [ fullSpan nextSpanIfAbsent: Any ].
	actual text should be: text
]

{ #category : #tests }
TwySpanPartTests >> testSplitAtMiddlePositionWhenItIsLastSpan [

	startBorder stub spanPosition willReturn: 4.
	endBorder stub spanPosition willReturn: 20.
	nextElement stub isTextEnd willReturn: true.
	
	textElement splitAt: 10.
	
	[fullSpan splitAt: 10.
	endBorder moveToEndOf: fullSpan.
	text expandToSecondSpan] should beDoneInOrder 
]

{ #category : #tests }
TwySpanPartTests >> testSplitAtMiddlePositionWhenItIsNotLastSpan [

	startBorder stub spanPosition willReturn: 4.
	endBorder stub spanPosition willReturn: 20.
	nextElement stub isTextEnd willReturn: false.
	
	textElement splitAt: 10.
	
	[fullSpan splitAt: 10.
	endBorder moveToEndOf: fullSpan] should beDoneInOrder 
]

{ #category : #running }
TwySpanPartTests >> textElementClass [
	^TwySpanPart
]
