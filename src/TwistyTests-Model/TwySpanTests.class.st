Class {
	#name : #TwySpanTests,
	#superclass : #TwyElementTestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwySpanTests >> testApplyingParagraphAttribute [

	| lineStartSpan  |

	[:lineStart |
		lineStartSpan := TwySpan new.
		textElement previous: lineStartSpan.
		lineStart stub isTextStart willReturn: false.
		lineStart stub isSpan willReturn: false.
		lineStartSpan basicPrevious: lineStart.
	
		[textElement applyParagraphAttribute: #attribute]
			should strictly satisfy: 
		[ lineStart applyAttribute: #attribute]	
	
	] runWithMocks 
]

{ #category : #tests }
TwySpanTests >> testAttachToAnotherSpan [

	| anotherSpan |
	anotherSpan := TwySpan new.
	nextElement next: anotherSpan.
	
	textElement attachTo: anotherSpan.
	
	textElement next should be: anotherSpan.
	anotherSpan previous should be: textElement
]

{ #category : #tests }
TwySpanTests >> testAttachToAnotherSpanShouldAnnounceTextChange [
	| anotherSpan deletion |
	anotherSpan := TwySpan new.
	nextElement next: anotherSpan.
	textElement attachTo: anotherSpan.
	textChanges should haveSize: 1.
	(deletion := textChanges first) should
		beInstanceOf: TwyElementsGroupRemoved.
	deletion text should be: text.
	deletion firstRemovedElement should be: nextElement.
	deletion elementBeforeRemovedGroup should be: textElement.
	deletion elementAfterRemovedGroup should be: anotherSpan
]

{ #category : #tests }
TwySpanTests >> testAttachToAnotherSpanShouldAnnounceTextChangeByOwnSpan [
	| anotherSpan |
	anotherSpan := TwySpan new.
	nextElement next: anotherSpan.
	textElement attachTo: anotherSpan.
	textChanges should haveSize: 1
]

{ #category : #tests }
TwySpanTests >> testAttachToAnotherSpanShouldDoNothingWhenItIsAlreadyAttached [
	
	textElement attachTo: nextElement.
	
	textElement next should be: nextElement.
	textChanges should be isEmpty

]

{ #category : #tests }
TwySpanTests >> testGettingLineEndSpan [

	| actual lineEndSpan lineEnd |

	lineEndSpan := TwySpan new.
	textElement next: lineEndSpan.
	lineEnd := Mock new.
	lineEnd stub isTextEnd willReturn: false.
	lineEnd stub isSpan willReturn: false.
	lineEndSpan basicNext: lineEnd.
	
	actual := textElement lineEndSpan.
	
	actual should be: lineEndSpan
]

{ #category : #tests }
TwySpanTests >> testGettingLineNumber [

	| lineStart1 lineStart2 |
	lineStart1 := TwyLineStart new.
	previousElement previous: lineStart1. 
	lineStart2 := TwyLineStart new.
	lineStart1 previous: lineStart2. 
	lineStart2 previous: TwyTextStart new.	
	
	textElement lineNumber should be: 3.
	
]

{ #category : #tests }
TwySpanTests >> testGettingLineStart [

	| actual lineStartSpan lineStart |

	lineStartSpan := TwySpan new.
	textElement previous: lineStartSpan.
	lineStart := Mock new.
	lineStart stub isTextStart willReturn: false.
	lineStart stub isSpan willReturn: false.
	lineStartSpan basicPrevious: lineStart.
	
	actual := textElement lineStart.
	
	actual should be: lineStart
]

{ #category : #tests }
TwySpanTests >> testGettingLineStartSpan [

	| actual lineStartSpan lineStart |

	lineStartSpan := TwySpan new.
	textElement previous: lineStartSpan.
	lineStart := Mock new.
	lineStart stub isTextStart willReturn: false.
	lineStart stub isSpan willReturn: false.
	lineStartSpan basicPrevious: lineStart.
	
	actual := textElement lineStartSpan.
	
	actual should be: lineStartSpan
]

{ #category : #tests }
TwySpanTests >> testGettingParagraphAttribute [

	| lineStartSpan  |

	[:lineStart |
		lineStartSpan := TwySpan new.
		textElement previous: lineStartSpan.
		lineStart stub isTextStart willReturn: false.
		lineStart stub isSpan willReturn: false.
		lineStartSpan basicPrevious: lineStart.
	
		[(textElement getParagraphAttribute: #attributeClass) should be: #lineStartAttribute]
			should strictly satisfy: 
		[ (lineStart getAttribute: #attributeClass) willReturn: #lineStartAttribute ]	
	
	] runWithMocks 
]

{ #category : #tests }
TwySpanTests >> testIsFirst [

	self mockNeighbours.
	previousElement stub isTextStart willReturn: #result.
	
	textElement isFirst should be: #result.
	
]

{ #category : #tests }
TwySpanTests >> testIsFirstAtLine [

	self mockNeighbours.
	previousElement stub isSpan willReturn: true; useOnce.
	
	textElement isFirstAtLine should be: false.
	
	previousElement stub isSpan willReturn: false; useOnce.
	
	textElement isFirstAtLine should be: true.
	
]

{ #category : #tests }
TwySpanTests >> testIsLast [

	self mockNeighbours.
	nextElement stub isTextEnd willReturn: #result.
	
	textElement isLast should be: #result.
	
]

{ #category : #tests }
TwySpanTests >> testIsLastAtLine [

	self mockNeighbours.
	nextElement stub isSpan willReturn: true; useOnce.
	
	textElement isLastAtLine should be: false.
	
	nextElement stub isSpan willReturn: false; useOnce.
	
	textElement isLastAtLine should be: true.
	
]

{ #category : #tests }
TwySpanTests >> testIsStartPosition [

	(textElement isStartPosition: 0) should be: true.
	(textElement isStartPosition: 10) should be: false
	
]

{ #category : #tests }
TwySpanTests >> testNotRequiredSpanBeforeNextElement [

	textElement requiredSpanBeforeNextElement should be: false
]

{ #category : #tests }
TwySpanTests >> testOffsetFromLineStart [

	| actual lineStartSpan lineStart previousSpan |
	lineStart := Mock new.
	lineStart stub isTextStart willReturn: false.
	lineStart stub isSpan willReturn: false.
	
	lineStartSpan := Mock new.
	lineStartSpan stub isTextStart willReturn: false.
	lineStartSpan stub isSpan willReturn: true.
	lineStartSpan stub length willReturn: 10.
	lineStartSpan stub previous willReturn: lineStart.	
	
	previousSpan := Mock new.
	previousSpan stub isTextStart willReturn: false.
	previousSpan stub isSpan willReturn: true.
	previousSpan stub length willReturn: 15.
	previousSpan stub previous willReturn: lineStartSpan.
	textElement basicPrevious: previousSpan.
		
	actual := textElement offsetFromLineStart.
	
	actual should be: 25
]

{ #category : #tests }
TwySpanTests >> testOffsetFromTextStart [

	| actual previousSpan textStart firstSpan |
	textStart := Mock new.
	textStart stub isTextStart willReturn: true.
	
	firstSpan := Mock new.
	firstSpan stub isTextStart willReturn: false.
	firstSpan stub length willReturn: 10.
	firstSpan stub previous willReturn: textStart.
	
	previousSpan := Mock new.
	previousSpan stub isTextStart willReturn: false.
	previousSpan stub length willReturn: 15.
	previousSpan stub previous willReturn: firstSpan.
	textElement basicPrevious: previousSpan.
		
	actual := textElement offsetFromTextStart.
	
	actual should be: 25
]

{ #category : #running }
TwySpanTests >> textElementClass [
	^TwySpan
]
