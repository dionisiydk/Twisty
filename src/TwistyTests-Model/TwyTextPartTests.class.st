Class {
	#name : #TwyTextPartTests,
	#superclass : #TestCase,
	#instVars : [
		'text',
		'textPart',
		'startBoundarySpan',
		'endBoundarySpan'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyTextPartTests >> setUp [
	text := Mock new.
	startBoundarySpan := Mock new.
	endBoundarySpan := Mock new.
	
	textPart := TwyTextPart new. 
	textPart 
		text: text;
		startBoundarySpan: startBoundarySpan;
		endBoundarySpan: endBoundarySpan
]

{ #category : #tests }
TwyTextPartTests >> testExpandToSecondSpan [

	textPart expandToSecondSpan.
	
	textPart endBoundarySpan should beReturnedFrom: [
		startBoundarySpan convertNextSpanToTextPartEnd].
	startBoundarySpan should receive next: textPart endBoundarySpan
]
