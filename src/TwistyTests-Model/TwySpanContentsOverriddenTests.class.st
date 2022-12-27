Class {
	#name : #TwySpanContentsOverriddenTests,
	#superclass : #TwyElementChangedTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwySpanContentsOverriddenTests >> testCancelling [

	[ :layoutLine :rightBorder |
		change overrideStart: 3.
		change overrideEnd: 5.
		change initialContents: '1234567'.
		[ change cancel]
			should lenient satisfy: 
		[element overrideContentsFrom: 3 to: 5 with: '45']
	 ] runWithMocks 
]

{ #category : #tests }
TwySpanContentsOverriddenTests >> testCorrectingPositionOfCursorShouldDoesNothing [

	change correctPositionOf: #textCursor
]

{ #category : #tests }
TwySpanContentsOverriddenTests >> testMoveTextRegionToEnd [

	[ :textRegion :regionEnd  |
		change overrideEnd: 4.
		[ change moveToEnd: textRegion ]
			should strictly satisfy: 
		[ textRegion end willReturn: regionEnd.
		regionEnd moveToSpan: element at: 4.
		textRegion collapseAtEnd]
	
	 ] runWithMocks
]

{ #category : #tests }
TwySpanContentsOverriddenTests >> testOverridenItemsCount [

	change overrideStart: 4.
	change overrideEnd: 7.
	
	change overridenItemsCount should equal: 3
]

{ #category : #running }
TwySpanContentsOverriddenTests >> textChangeClass [
	^TwySpanContentsOverridden
]
