Class {
	#name : #TwyOverrideResultTests,
	#superclass : #TestCase,
	#category : #'TwistyTests-Model'
}

{ #category : #tests }
TwyOverrideResultTests >> testGettingRestString [

	| change result |
	change := Mock new.
	change stub overridenItemsCount willReturn: 3.
	
	result := TwyOverrideResult of: change by: '123456'.
	
	result restString should equal: '456'
]

{ #category : #tests }
TwyOverrideResultTests >> testGettingRestStringWhenNoChanges [

	|result |
	
	result := TwyOverrideResult noChangesBy: '123456'.
	
	result restString should equal: '123456'
]

{ #category : #tests }
TwyOverrideResultTests >> testHasNotRestStringWhenNoChangesAndNewStringIsEmpty [

	| result |
	
	result := TwyOverrideResult noChangesBy: ''.
	
	result hasRestString should be: false
]

{ #category : #tests }
TwyOverrideResultTests >> testHasNotRestStringWhenOverridenItemsCountIsEqualToNewStringSize [

	| change result |
	change := Mock new.
	change stub overridenItemsCount willReturn: 6.
	
	result := TwyOverrideResult of: change by: '123456'.
	
	result hasRestString should be: false
]

{ #category : #tests }
TwyOverrideResultTests >> testHasRestStringWhenNoChangesAndNewStringNotEmpty [

	| result |
	
	result := TwyOverrideResult noChangesBy: '123456'.
	
	result hasRestString should be: true
]

{ #category : #tests }
TwyOverrideResultTests >> testHasRestStringWhenOverridenItemsLessThanNewStringSize [

	| change result |
	change := Mock new.
	change stub overridenItemsCount willReturn: 3.
	
	result := TwyOverrideResult of: change by: '123456'.
	
	result hasRestString should be: true
]

{ #category : #tests }
TwyOverrideResultTests >> testMoveTextRegionToEnd [

	| result |
	[:change  |
		change stub overrideEnd willReturn: 3.
		result := TwyOverrideResult of: change by: '123456'.
	
		[result moveToEnd: #textRegion]
			should strictly satisfy: 
		[ change moveToEnd: #textRegion ]
	] runWithMocks 
]

{ #category : #tests }
TwyOverrideResultTests >> testMoveTextRegionToEndWhenNoChanges [

	| result |

	result := TwyOverrideResult noChangesBy: '123456'.
	
	result moveToEnd: #textRegion
]
