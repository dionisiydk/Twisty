Extension { #name : #TwySpan }

{ #category : #'*Twisty-Layout' }
TwySpan >> isCoveredByLayoutLine: aLayoutLine [
	^aLayoutLine isCoversSpan: self
]

{ #category : #'*Twisty-Layout' }
TwySpan >> isCoveredByLayoutSpan: aLayoutSpan [
	^aLayoutSpan isCoversSpan: self
]

{ #category : #'*Twisty-Layout' }
TwySpan >> layoutContentsBy: aLayoutBuilder [

	aLayoutBuilder newLayoutSpanFor: self.
	aLayoutBuilder layoutNewTextSpan
]
