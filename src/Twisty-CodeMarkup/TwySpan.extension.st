Extension { #name : #TwySpan }

{ #category : #'*Twisty-CodeMarkup' }
TwySpan >> isBelongsToSimilarProgramNodeAs: anotherSpan [

	| currentProgramNode comparedProgramNode |
	currentProgramNode := self getAttribute: TwyProgramNodeAttribute ifAbsent: [ ^false ].
	comparedProgramNode := anotherSpan getAttribute: TwyProgramNodeAttribute ifAbsent: [ ^false ].
	
	^currentProgramNode class = comparedProgramNode class
]
