Class {
	#name : #TwyChangesHistoryTests,
	#superclass : #TestCase,
	#instVars : [
		'history',
		'text'
	],
	#category : #'TwistyTests-Editor'
}

{ #category : #running }
TwyChangesHistoryTests >> setUp [
	super setUp.
	
	text := Mock new.
	text stub when: Any send: Any to: Any.
	history := TwyChangesHistory of: text.
	
]

{ #category : #tests }
TwyChangesHistoryTests >> testDetachText [

	[ 
		[ history detachText ]
			should strictly satisfy:
		[ text unsubscribe: history ]
	 ] runWithMocks 
]

{ #category : #tests }
TwyChangesHistoryTests >> testHasEmptyRedoListByDefault [

	history redoList should be isEmpty
]

{ #category : #tests }
TwyChangesHistoryTests >> testHasEmptyUndoListByDefault [

	history undoList should be isEmpty
]

{ #category : #tests }
TwyChangesHistoryTests >> testRedoLastChange [

	[:change1 :change2 |
		history addRedoChange: change1; addRedoChange: change2.
		
		[ history redoLastChange ]
			should strictly satisfy: 
		[ (text editContentsBy: Any) will: [ :action | action value ].
			change2 cancel when: [history undoList] is: (Containing item: change2) not 
		]	
	 ] runWithMocks 
]

{ #category : #tests }
TwyChangesHistoryTests >> testRedoLastChangeWhenNothingExists [

	history redoList removeAll.
		
	history redoLastChange 

]

{ #category : #tests }
TwyChangesHistoryTests >> testSubscriptionOnTextChanges [
	| event |
	text := TwyText new.
	history := TwyChangesHistory of: text.
	event := TwyTextChanged new.
	text publishEvent: event.
	text publishEvent: TwyChangesCancelled.
	history undoList should haveSize: 1.
	history undoList should include: event
]

{ #category : #tests }
TwyChangesHistoryTests >> testUndoLastChange [

	[:change1 :change2 |
		history addNewChange: change1; addNewChange: change2.
		
		[ history undoLastChange ]
			should strictly satisfy: 
		[ (text editContentsBy: Any) will: [ :action | action value ].
			change2 cancel when: [history undoList] is: (Containing item: change2) not 
		]	
	 ] runWithMocks 
]

{ #category : #tests }
TwyChangesHistoryTests >> testUndoLastChangeShouldAddNewRedoChange [

	[:change  |
		history addNewChange: change.
		
		[ history undoLastChange ]
			should strictly satisfy: 
		[ (text editContentsBy: Any) willReturn: #redoChange	].
		
		history redoList should include: #redoChange
		 	
	 ] runWithMocks 
]

{ #category : #tests }
TwyChangesHistoryTests >> testUndoLastChangeShouldRemoveNewRedoChangeFromUndoList [

	[:change  |
		history addNewChange: change.
		
		[ history undoLastChange ]
			should strictly satisfy: 
		[ (text editContentsBy: Any) will: [ :arg |  history addNewChange: #redoChange. #redoChange]	].
		
		history undoList should not include: #redoChange
		 	
	 ] runWithMocks  
]

{ #category : #tests }
TwyChangesHistoryTests >> testUndoLastChangeWhenNothingExists [

	history undoList removeAll.
		
	history undoLastChange 

]
