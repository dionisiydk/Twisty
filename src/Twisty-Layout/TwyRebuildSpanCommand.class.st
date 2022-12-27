"
I'm doing same things as my superclass but I always reappend myself to builder to completelly rebuild full layout. For span correction I update drawer for it
"
Class {
	#name : #TwyRebuildSpanCommand,
	#superclass : #TwyCorrectSpanCommand,
	#category : #'Twisty-Layout'
}

{ #category : #execution }
TwyRebuildSpanCommand >> correctSpanBy: aLayoutBuilder [ 

	aLayoutBuilder 
		updateDrawerFor: span;
		correctLayoutOf: span
]

{ #category : #testing }
TwyRebuildSpanCommand >> shouldStopAtThisSpan [ 
	^false
]
