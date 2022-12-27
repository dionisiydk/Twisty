Class {
	#name : #TwyCodeTemplateTests,
	#superclass : #TestCase,
	#instVars : [
		'template',
		'text'
	],
	#category : #'TwistyTests-CodeMarkup'
}

{ #category : #running }
TwyCodeTemplateTests >> setUp [
	super setUp.
	
	text := Mock new.
	template := TwyCodeTemplate with: text
]

{ #category : #tests }
TwyCodeTemplateTests >> testStylingSpan [

	[:stylingSpan :templateSpan  |
		[ template styleSpan: stylingSpan ]
			should strictly satisfy:
		[(text spansDo: Any) will: [:action | action value: templateSpan ].
		(templateSpan isBelongsToSimilarProgramNodeAs: stylingSpan) willReturn: true.
		stylingSpan importAttributesFrom: templateSpan excepting: { TwyProgramNodeAttribute }
		]
	] runWithMocks
]

{ #category : #tests }
TwyCodeTemplateTests >> testStylingSpanWhenNoTemplateFound [

	[:stylingSpan :templateSpan  |
		[ template styleSpan: stylingSpan ]
			should strictly satisfy:
		[(text spansDo: Any) will: [:action | action value: templateSpan ].
		(templateSpan isBelongsToSimilarProgramNodeAs: stylingSpan) willReturn: false]
	] runWithMocks
]
