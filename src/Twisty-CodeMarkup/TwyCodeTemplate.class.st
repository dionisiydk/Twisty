Class {
	#name : #TwyCodeTemplate,
	#superclass : #Object,
	#instVars : [
		'text'
	],
	#category : #'Twisty-CodeMarkup'
}

{ #category : #'instance creation' }
TwyCodeTemplate class >> with: aTwyText [
	^self new 
		text: aTwyText
]

{ #category : #styling }
TwyCodeTemplate >> styleSpan: aTwySpan [

	text spansDo: [ :templateSpan |
		
		(templateSpan isBelongsToSimilarProgramNodeAs: aTwySpan) ifTrue: [ 
			aTwySpan importAttributesFrom: templateSpan excepting: {TwyProgramNodeAttribute}
		]		
 	]
]

{ #category : #accessing }
TwyCodeTemplate >> text [
	^ text
]

{ #category : #accessing }
TwyCodeTemplate >> text: anObject [
	text := anObject
]
