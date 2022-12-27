"
I build TwyTextLayout with real lines of given text
"
Class {
	#name : #TwyNativeLayoutStrategy,
	#superclass : #TwyLayoutStrategy,
	#category : #'Twisty-Layout'
}

{ #category : #testing }
TwyNativeLayoutStrategy >> allowArbitraryExtent [
	^false
]

{ #category : #'building layout' }
TwyNativeLayoutStrategy >> correctLayoutOf: aLayoutSpan [ 

	aLayoutSpan putTextSpanItemsWhile: [ true ].
		
	aLayoutSpan isAtEndOfTextLine ifTrue: [^self].
	
	aLayoutSpan importNextSpanToLine
]

{ #category : #'building layout' }
TwyNativeLayoutStrategy >> layoutNewTextSpanStartingAt: aLayoutSpan by: aLayoutBuilder [

	aLayoutSpan putTextSpanItemsWhile: [ true ].	
	aLayoutBuilder completeNewSpan.
]

{ #category : #accessing }
TwyNativeLayoutStrategy >> preferredExtent [
	^0@0
]

{ #category : #accessing }
TwyNativeLayoutStrategy >> preferredExtent: aPoint [
]
