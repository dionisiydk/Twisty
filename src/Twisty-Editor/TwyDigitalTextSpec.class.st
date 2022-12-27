"
I consider only strings which have only digit characters
"
Class {
	#name : #TwyDigitalTextSpec,
	#superclass : #TwyTextSpec,
	#category : #'Twisty-Editor'
}

{ #category : #testing }
TwyDigitalTextSpec >> check: verifiedString [

	^verifiedString isEmpty or: [verifiedString isAllDigits ]
]
