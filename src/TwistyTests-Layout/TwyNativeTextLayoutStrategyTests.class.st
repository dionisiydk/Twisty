Class {
	#name : #TwyNativeTextLayoutStrategyTests,
	#superclass : #TwyTextLayoutStrategyTestCase,
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyNativeTextLayoutStrategyTests >> strategyClass [
	^TwyNativeLayoutStrategy 
]

{ #category : #tests }
TwyNativeTextLayoutStrategyTests >> testCorrectionLayoutSpanWhenItIsEndOfTextLine [

	[:layoutBuilder :layoutSpan |
 
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[(layoutSpan putTextSpanItemsWhile: Any) will: [:arg | arg value should be: true].
		layoutSpan isAtEndOfTextLine willReturn: true]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyNativeTextLayoutStrategyTests >> testCorrectionLayoutSpanWhenItIsNotEndOfTextLine [

	[:layoutBuilder :layoutSpan |
 
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[(layoutSpan putTextSpanItemsWhile: Any) will: [:arg | arg value should be: true].
		layoutSpan isAtEndOfTextLine willReturn: false.
		layoutSpan importNextSpanToLine]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyNativeTextLayoutStrategyTests >> testLayoutNewTextSpan [

	[:layoutBuilder :layoutSpan :newSpan |
 
		[strategy layoutNewTextSpanStartingAt: layoutSpan by: layoutBuilder]
			should strictly satisfy: 
		[(layoutSpan putTextSpanItemsWhile: Any) will: [:arg | arg value should be: true].
		layoutBuilder completeNewSpan]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyNativeTextLayoutStrategyTests >> testPermitArbitraryExtent [

	strategy allowArbitraryExtent should be: false
]
