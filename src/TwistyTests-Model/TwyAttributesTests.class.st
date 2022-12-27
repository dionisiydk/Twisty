Class {
	#name : #TwyAttributesTests,
	#superclass : #TestCase,
	#instVars : [
		'attributes'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyAttributesTests >> setUp [
	super setUp.
	
	attributes := TwyAttributes new
]

{ #category : #tests }
TwyAttributesTests >> testAddingAttribute [

	| attribute |
	attribute := TwyFontAttribute new.
	
	attributes add: attribute.
	
	attributes contents should include: attribute at: TwyFontAttribute 
]

{ #category : #tests }
TwyAttributesTests >> testAddingAttributeWithValue [
	| actual |
	attributes add: TwyFontAttribute with: #font.
	actual := attributes contents at: TwyFontAttribute.
	actual should beInstanceOf: TwyFontAttribute.
	actual value should be: #font
]

{ #category : #tests }
TwyAttributesTests >> testCheckingAttributeExistence [

	attributes add: TwyFontAttribute new.
	
	(attributes includes: TwyFontAttribute) should be: true.
	
	(attributes includes: TwyForeColorAttribute) should be: false.
]

{ #category : #tests }
TwyAttributesTests >> testCopyShouldHasContentsDeepCopy [

	| attr1 attr2 copy |
	attr1 := Mock new.
	attr1 stub deepCopy willReturn: #attr1DeepCopy.
	attr2 := Mock new.
	attr2 stub deepCopy willReturn: #attr2DeepCopy.
	attributes contents at: #attr1Class put: attr1.
	attributes contents at: #attr2Class put: attr2.
	
	copy := attributes copy.
	copy contents should include: #attr1DeepCopy at: #attr1Class.
	copy contents should include: #attr2DeepCopy at: #attr2Class.
]

{ #category : #tests }
TwyAttributesTests >> testGettingAbsentAttribute [

	| actual |
	
	attributes contents removeAll.
	
	actual := attributes get: TwyFontAttribute ifAbsent: [#result].
	
	actual should be: #result
]

{ #category : #tests }
TwyAttributesTests >> testGettingAbsentAttributeValue [

	| actual |
	
	attributes contents removeAll.
	
	actual := attributes valueOf: TwyFontAttribute ifAbsent: [#result].
	
	actual should be: #result
]

{ #category : #tests }
TwyAttributesTests >> testGettingExistedAttribute [

	| attribute actual |
	attribute := TwyFontAttribute with: #font.
	
	attributes add: attribute.
	
	actual := attributes get: TwyFontAttribute ifAbsent: nil.
	
	actual should be: attribute
]

{ #category : #tests }
TwyAttributesTests >> testGettingExistedAttributeValue [

	| attribute actual |
	attribute := TwyFontAttribute with: #font.
	
	attributes add: attribute.
	
	actual := attributes valueOf: TwyFontAttribute ifAbsent: nil.
	
	actual should be: #font
]

{ #category : #tests }
TwyAttributesTests >> testHasEmptyContentsByDefault [

	attributes contents should be isEmpty
]

{ #category : #tests }
TwyAttributesTests >> testRemoveAttribute [

	| attribute |
	attribute := TwyFontAttribute new.
	
	attributes add: attribute.

	attributes remove: TwyFontAttribute.
	
	attributes contents should be isEmpty
]
