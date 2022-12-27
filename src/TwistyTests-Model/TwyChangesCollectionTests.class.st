Class {
	#name : #TwyChangesCollectionTests,
	#superclass : #TestCase,
	#instVars : [
		'changes',
		'text'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyChangesCollectionTests >> setUp [
	super setUp.
	
	text := Mock new.
	changes := TwyChangesCollection of: text
]

{ #category : #tests }
TwyChangesCollectionTests >> testAdditionNewCursorChangeWhenNothingExistsYet [

	| newChange |
	newChange := Mock new.
	
	newChange stub isTextStateChange willReturn: false.
			
	changes add: newChange.
	
	changes cursorsChanges should equal: { newChange} 
	
]

{ #category : #tests }
TwyChangesCollectionTests >> testAdditionNewCursorChangeWhenThereIsAnotherAboutSameCursor [

	| newChange existedChange |
	newChange := Mock new.
	existedChange := Mock new.
	
	newChange stub isTextStateChange willReturn: false.
	(existedChange stub isAboutSameCursorAs: newChange) willReturn: true.
			
	changes cursorsChanges add:  existedChange. 
			
	changes add: newChange.
	
	changes cursorsChanges should equal: { existedChange. } 
	
]

{ #category : #tests }
TwyChangesCollectionTests >> testAdditionNewCursorChangeWhenThereIsAnothersAboutDifferentCursors [

	| newChange existedChange1 existedChange2 |
	newChange := Mock new.
	existedChange1 := Mock new.
	existedChange2 := Mock new.
	
	newChange stub isTextStateChange willReturn: false.
	(existedChange1 stub isAboutSameCursorAs: newChange) willReturn: false.
	(existedChange2 stub isAboutSameCursorAs: newChange) willReturn: false.
			
	changes cursorsChanges: { existedChange1. existedChange2 } asOrderedCollection.
			
	changes add: newChange.
	
	changes cursorsChanges should equal: { existedChange1. existedChange2. newChange} 
	
]

{ #category : #tests }
TwyChangesCollectionTests >> testAdditionNewTextChangeWhenNothingExistsYet [

	| newChange |
	newChange := Mock new.
	
	newChange stub isTextStateChange willReturn: true.
			
	changes add: newChange.
	
	changes textChanges should equal: { newChange} 
	
]

{ #category : #tests }
TwyChangesCollectionTests >> testAdditionNewTextChangeWhenOneAlreadyExists [

	| newChange |
	newChange := Mock new.
	
	newChange stub isTextStateChange willReturn: true.
	
	changes textChanges add: #existedChange.
			
	changes add: newChange.
	
	changes textChanges should equal: { #existedChange. newChange} 
	
]

{ #category : #tests }
TwyChangesCollectionTests >> testCancelling [

	[:modelChange1 :modelChange2 :cursorChange1 :cursorChange2 :cursorChange3 |
		changes textChanges: { modelChange1. modelChange2 }.
		changes cursorsChanges: { cursorChange1. cursorChange2 } asOrderedCollection.
		
		[ changes cancel ]
			should strictly satisfy: 
		[text when: TwyCursorMoved send: #add: to: changes. 
		modelChange2 cancel. 
		modelChange1 cancel will: [changes cursorsChanges add: cursorChange3]. 
		text unsubscribe: changes.
		cursorChange3 cancel. cursorChange2 cancel. cursorChange1 cancel]	
		
	] runWithMocks .
	
]

{ #category : #tests }
TwyChangesCollectionTests >> testCancellingShouldUnsubscribeFromTextWhenSomeErrorsHappens [

	| error |
	[:modelChange|
		changes textChanges: { modelChange}.
		
		error := Error new.
		modelChange stub cancel willRaise: error. 
		
		[ changes cancel ] should raise: error.
		
		text should receive unsubscribe: changes.
		
	] runWithMocks
]

{ #category : #tests }
TwyChangesCollectionTests >> testGettingTextChanges [

	| change1 change2 change3 |
	change1 := Mock new.
	change2 := Mock new.
	change3 := Mock new.
	
	change1 stub isTextStateChange willReturn: false.
	change2 stub isTextStateChange willReturn: true.	
	change3 stub isTextStateChange willReturn: true.
		
	changes add: change1; add: change2; add: change3.
	
	changes textChanges should equal: { change2. change3 } 
	
]

{ #category : #tests }
TwyChangesCollectionTests >> testHasEmptyCursorsChangesByDefault [

	changes cursorsChanges should be isEmpty
]

{ #category : #tests }
TwyChangesCollectionTests >> testHasEmptyTextChangesByDefault [

	changes textChanges should be isEmpty
]
