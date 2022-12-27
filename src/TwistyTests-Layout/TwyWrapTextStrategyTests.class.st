Class {
	#name : #TwyWrapTextStrategyTests,
	#superclass : #TwyTextLayoutStrategyTestCase,
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyWrapTextStrategyTests >> strategyClass [
	^TwyWrapTextStrategy 
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testAllowArbitraryExtent [

	strategy allowArbitraryExtent should be: true
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testCorrectionLayoutSpanWhenItExactlySatisfiedMaxLineWidth [

	[:layoutSpan |
		
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 100.
 
		strategy correctLayoutOf: layoutSpan
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testLayoutNewTextSpanShouldCreateLayoutSpansUpToEndOfTextSpan [

	[:layoutBuilder :layoutSpan :newSpan |
 
		[strategy layoutNewTextSpanStartingAt: layoutSpan by: layoutBuilder]
			should strictly satisfy: 
		[layoutSpan putTextSpanItemsWhile: Any.
		layoutSpan isAtEndOfTextSpan willReturn: false.
		layoutSpan isEmpty willReturn: false; useArbitrarily.
		layoutBuilder completeNewSpan.
				
		(layoutBuilder completeNewLine) willReturn: newSpan.
		newSpan putTextSpanItemsWhile: Any.
		newSpan isAtEndOfTextSpan willReturn: true.
		layoutBuilder completeNewSpan]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testLayoutNewTextSpanShouldCreateLayoutSpansWithRestrictedWidth [

	| restrictionBlock |
	[:layoutBuilder :layoutSpan |
				 
		[strategy layoutNewTextSpanStartingAt: layoutSpan by: layoutBuilder]
			should strictly satisfy: 
		[(layoutSpan putTextSpanItemsWhile: Any) will: [ :arg | restrictionBlock :=  arg].
		layoutSpan isAtEndOfTextSpan willReturn: true.
		layoutSpan isEmpty willReturn: false; useArbitrarily.
		layoutBuilder completeNewSpan].

		layoutSpan stub rightBorderOffset willReturn: 200.
		strategy maxWidth: 100.	
		restrictionBlock value should be: false.
		strategy maxWidth: 200.
		restrictionBlock value should be: true
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testLayoutNewTextSpanShouldMoveStartingSpanToNewLineWhenItCantBeLayoutedOnCurrentLine [

	[:layoutBuilder :layoutSpan :newSpan |
 
		[strategy layoutNewTextSpanStartingAt: layoutSpan by: layoutBuilder]
			should strictly satisfy: 
		[layoutSpan putTextSpanItemsWhile: Any.
		layoutSpan isAtEndOfTextSpan willReturn: false.
		layoutSpan isEmpty willReturn: true.
		layoutBuilder moveNewTextSpanToNewLine.
		layoutSpan putTextSpanItemsWhile: Any.
		layoutSpan isAtEndOfTextSpan willReturn: true.
		layoutSpan isEmpty willReturn: false.
		layoutBuilder completeNewSpan]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testLayoutNewTextSpanShouldNotWrapLastSingleItemWhenItTooBig [

	[:layoutBuilder :layoutSpan :newSpan |
 
		[strategy layoutNewTextSpanStartingAt: layoutSpan by: layoutBuilder]
			should strictly satisfy: 
		[layoutSpan putTextSpanItemsWhile: Any.
		layoutSpan isAtEndOfTextSpan willReturn: false.
		layoutSpan isEmpty willReturn: false; useArbitrarily.
		layoutBuilder completeNewSpan.
				
		(layoutBuilder completeNewLine) willReturn: newSpan.				
		newSpan putTextSpanItemsWhile: Any.
		newSpan isAtEndOfTextSpan willReturn: false.
		newSpan isEmpty willReturn: true; useArbitrarily.
		newSpan putNextItem.
		newSpan isAtEndOfTextSpan willReturn: true.
		layoutBuilder completeNewSpan]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testLayoutNewTextSpanShouldNotWrapSingleItemWhenItTooBig [

	[:layoutBuilder :layoutSpan :newSpan :newSpan2 |
 
		[strategy layoutNewTextSpanStartingAt: layoutSpan by: layoutBuilder]
			should strictly satisfy: 
		[layoutSpan putTextSpanItemsWhile: Any.
		layoutSpan isAtEndOfTextSpan willReturn: false.
		layoutSpan isEmpty willReturn: false; useArbitrarily.
		layoutBuilder completeNewSpan.
				
		(layoutBuilder completeNewLine) willReturn: newSpan.		
		newSpan putTextSpanItemsWhile: Any.
		newSpan isAtEndOfTextSpan willReturn: false.
		newSpan isEmpty willReturn: true; useArbitrarily.
		newSpan putNextItem.
		newSpan isAtEndOfTextSpan willReturn: false.
		layoutBuilder completeNewSpan.
				
		(layoutBuilder completeNewLine) willReturn: newSpan2.
		newSpan2 putTextSpanItemsWhile: Any.
		newSpan2 isAtEndOfTextSpan willReturn: true.
		layoutBuilder completeNewSpan]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testUnwrapExistedSpanShouldPutNewItemsWithRestrictedWidth [

	| conditionBlock |
	[ :layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 50.
		
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextLine willReturn: false.		
		(layoutSpan putTextSpanItemsWhile: Any) will: [:arg | conditionBlock := arg. false]].
	
		strategy maxWidth: 50.
		conditionBlock value should be: true.
		strategy maxWidth: 49.
		conditionBlock value should be: false.
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testUnwrapExistedSpanWhenItBecomeAtEndOfTextLineAfterPuttingNewItems [

	[ :layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 50.
		
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextLine willReturn: false.
		
		(layoutSpan putTextSpanItemsWhile: Any) willReturn: true.
		layoutSpan isAtEndOfTextSpan willReturn: true.
		layoutSpan isAtEndOfTextLine willReturn: true]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testUnwrapExistedSpanWhenItBecomeAtEndOfTextSpanButNotAtEndOfTextLineAfterPuttingNewItems [

	[ :layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 50.
		
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextLine willReturn: false.
		
		(layoutSpan putTextSpanItemsWhile: Any) willReturn: true.
		layoutSpan isAtEndOfTextSpan willReturn: true.
		layoutSpan isAtEndOfTextLine willReturn: false.
		layoutSpan importNextSpanToLine]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testUnwrapExistedSpanWhenItIsLastSpanAtLineAndAtEndOfTextLine [

	[ :layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 50.
		
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextLine willReturn: true; useArbitrarily]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testUnwrapExistedSpanWhenItIsNotLastSpanAtLine [

	[ :layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 50.
		
		[strategy correctLayoutOf: layoutSpan ]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: false; useArbitrarily]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testUnwrapExistedSpanWhenItNotBecomeAtEndOfTextSpanAfterPuttingNewItems [

	[ :layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 50.
		
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextLine willReturn: false.
		
		(layoutSpan putTextSpanItemsWhile: Any) willReturn: true.
		layoutSpan isAtEndOfTextSpan willReturn: false]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testUnwrapExistedSpanWhenNotAllTextItemsWasAccepted [

	[ :layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 50.
		
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextLine willReturn: false.
		
		(layoutSpan putTextSpanItemsWhile: Any) willReturn: false]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testWrapExistedSpanShouldKeepSingleItemWhenItTooBig [

	[:layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 200.
		
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextSpan willReturn: false; useArbitrarily.
		layoutSpan rejectTextSpanItemsWhile: Any.
		layoutSpan isEmpty willReturn: true; useArbitrarily.
		layoutSpan isAtStartOfLine willReturn: true.
		layoutSpan putNextItem].
		
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testWrapExistedSpanShouldKeepSingleItemWhenItTooBigAndNewLineWasCreated [

	[ :layoutSpan :newSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 200.
		
		[strategy correctLayoutOf: layoutSpan ]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: false; useArbitrarily.
		layoutSpan newRightSpan willReturn: newSpan.
		layoutSpan insertLineAtTheEnd.
		layoutSpan rejectTextSpanItemsWhile: Any.
		layoutSpan isEmpty willReturn: true; useArbitrarily.
		layoutSpan isAtStartOfLine willReturn: true.
		layoutSpan putNextItem.
		newSpan isEmpty willReturn: true.
		newSpan delete]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testWrapExistedSpanShouldMoveItToNewLineWhenItCantBeWrapped [

	[:layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 200.
		
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextLine willReturn: false; useArbitrarily.
		layoutSpan isAtEndOfTextSpan willReturn: false; useArbitrarily.
		layoutSpan rejectTextSpanItemsWhile: Any.
		layoutSpan isEmpty willReturn: true.
		layoutSpan isAtStartOfLine willReturn: false.
		layoutSpan migrateToNewLine.
		(layoutSpan putTextSpanItemsWhile: Any) willReturn: false "not all items was unwrapped".
		layoutSpan isEmpty willReturn: false].
		
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testWrapExistedSpanShouldRejectTextItemsWhileItWasNotWithRestrictedWidth [

	| conditionBlock |
	[:layoutSpan :newSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 200.
		 
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextSpan willReturn: false; useArbitrarily.
		(layoutSpan rejectTextSpanItemsWhile: Any) will: [:arg | conditionBlock := arg].
		layoutSpan isEmpty willReturn: false].
		
		strategy maxWidth: 199.
		conditionBlock value should be: true.
		strategy maxWidth: 200.
		conditionBlock value should be: false.	
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testWrapExistedSpanWhenItIsLastSpanAtLineAndAtEndOfTextLine [

	[:layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 200.
		 
		[strategy correctLayoutOf: layoutSpan]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextSpan willReturn: true; useArbitrarily.
		layoutSpan newRightSpan.
		layoutSpan insertLineAtTheEnd.

		layoutSpan rejectTextSpanItemsWhile: Any.
		layoutSpan isEmpty willReturn: false]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testWrapExistedSpanWhenItIsLastSpanAtLineAndNotAtEndOfTextLine [

	[ :layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 200.
		 
		[strategy correctLayoutOf: layoutSpan ]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: true; useArbitrarily.
		layoutSpan isAtEndOfTextSpan willReturn: false; useArbitrarily.
		layoutSpan rejectTextSpanItemsWhile: Any.
		layoutSpan isEmpty willReturn: false]
	
	] runWithMocks 
	

	
]

{ #category : #tests }
TwyWrapTextStrategyTests >> testWrapExistedSpanWhenItIsNotLastSpanAtLine [

	[ :layoutSpan |
		strategy maxWidth: 100.
		layoutSpan stub rightBorderOffset willReturn: 200.
		
		[strategy correctLayoutOf: layoutSpan ]
			should strictly satisfy: 
		[layoutSpan isLastAtLine willReturn: false; useArbitrarily.
		layoutSpan newRightSpan.
		layoutSpan insertLineAtTheEnd.
		layoutSpan rejectTextSpanItemsWhile: Any.
		layoutSpan isEmpty willReturn: false]
	
	] runWithMocks 
	

	
]
