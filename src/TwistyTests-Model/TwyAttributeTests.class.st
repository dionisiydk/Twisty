Class {
	#name : #TwyAttributeTests,
	#superclass : #TestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwyAttributeTests >> testComparingSameKindAttributesWithDifferentValues [

	| attr1 attr2 |
	attr1 := TwyForeColorAttribute with: #color.
	attr2 := TwyForeColorAttribute with: #anotherColor.
	
	(attr1 = attr2) should be: false
]

{ #category : #tests }
TwyAttributeTests >> testComparingSameKindAttributesWithEqualValues [

	| attr1 attr2 |
	attr1 := TwyForeColorAttribute with: 'color' copy.
	attr2 := TwyForeColorAttribute with: 'color' copy.
	
	(attr1 = attr2) should be: true
]

{ #category : #tests }
TwyAttributeTests >> testComparingTwoDifferentKindAttributes [

	| attr1 attr2 |
	attr1 := TwyForeColorAttribute with: #color.
	attr2 := TwyBackColorAttribute with: #color.
	
	(attr1 = attr2) should be: false
]
