"
I responsible for building text layout
"
Class {
	#name : #TwyLayoutStrategy,
	#superclass : #Object,
	#category : #'Twisty-Layout'
}

{ #category : #'building layout' }
TwyLayoutStrategy >> correctLayoutOf: aLayoutSpan [
	self subclassResponsibility 
]

{ #category : #'building layout' }
TwyLayoutStrategy >> createBuilderFor: aLayout startedAt: aLayoutLine [

	| builder |
	builder := TwyLayoutBuilder for: aLayout.
	builder 
		layoutStrategy: self;
		currentLine: aLayoutLine;
		currentSpan: aLayoutLine firstSpan.
	^builder
]

{ #category : #'building layout' }
TwyLayoutStrategy >> layoutNewTextSpanStartingAt: aLayoutSpan by: aLayoutBuilder [
	self subclassResponsibility 
]

{ #category : #'building layout' }
TwyLayoutStrategy >> layoutText: aTextModel [ 

	| layout |
	layout := aTextModel prepareNewLayout.
	layout buildBy: self.
	
	^layout

]
