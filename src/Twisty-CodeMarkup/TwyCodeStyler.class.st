Class {
	#name : #TwyCodeStyler,
	#superclass : #Object,
	#instVars : [
		'codeTemplate'
	],
	#category : #'Twisty-CodeMarkup'
}

{ #category : #processing }
TwyCodeStyler >> processText: aTwyText [

	aTwyText spansDo: [ :each | 
		codeTemplate styleSpan: each
	]
]
