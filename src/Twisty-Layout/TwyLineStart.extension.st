Extension { #name : #TwyLineStart }

{ #category : #'*Twisty-Layout' }
TwyLineStart >> isCoveredByLayoutLine: aLayoutLine [
	^aLayoutLine isCoversLineStart: self
]

{ #category : #'*Twisty-Layout' }
TwyLineStart >> isCoveredByLayoutSpan: aLayoutSpan [
	^aLayoutSpan isCoversLineStart: self
]

{ #category : #'*Twisty-Layout' }
TwyLineStart >> layoutContentsBy: aLayoutBuilder [

	aLayoutBuilder completeNewLine
]
