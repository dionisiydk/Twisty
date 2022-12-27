Class {
	#name : #TwyTextAcceptenceTests,
	#superclass : #TestCase,
	#instVars : [
		'text',
		'cursor'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyTextAcceptenceTests >> setUp [
	super setUp.
	
	text := TwyText new.
	cursor := text newActiveCursor
]

{ #category : #running }
TwyTextAcceptenceTests >> tearDown [ 
	super tearDown.
	text validateSpansOrder
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testBackspaceKeyAtLineEnd [
	
	| selection |
	cursor insert: '123', String cr, '456'.
	
	cursor moveToTextStart; moveToLineEnd.
	cursor lineNumber should be: 1.
	
	selection := text newRegion.
	selection moveTo: cursor.
	selection backspaceKey.
	
	text asString should equal: '12', String cr, '456'.
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testBackspaceKeyAtLineStart [
	
	| selection |
	cursor insert: '123',String cr,'456'.
	
	cursor moveToLineStart.
	cursor lineNumber should be: 2.
	
	selection := text newRegion.
	selection moveTo: cursor.
	selection backspaceKey.
	
	text asString should equal: '123456'
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testBackspaceKeyAtTextEnd [
	
	| selection |
	cursor insert: '123456'.
	
	selection := text newRegion.

	selection start moveToTextEnd.
	selection end moveToTextEnd.
	selection backspaceKey.

	text asString should equal: '12345'.
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testBackspaceKeyTwiceAtLineStart [
	
	| selection |
	cursor insert: '123',String cr,'456'.
	
	cursor moveToLineStart.
	cursor lineNumber should be: 2.
	
	selection := text newRegion.
	selection moveTo: cursor.
	selection backspaceKey.
	selection backspaceKey.

	text asString should equal: '12456'
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testBackspaceOnlyLineSeparator [
	
	| selection |
	cursor insert: '123', String cr, '456'.
	
	cursor moveToTextStart; moveToLineEnd; moveForward.
	cursor lineNumber should be: 2.
	
	selection := text newRegion.
	selection moveTo: cursor.
	selection backspaceKey.
		
	text asString should equal: '123456'.
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingDeleteCr [
	| selection |
	cursor insert: '123' , String cr , '456'.
	text elements should haveSize: 5.
	selection := text newRegion.
	selection selectFullText.
	selection start moveToLineEnd.
	selection end moveToLineStart.
	selection start textPosition should equal: 3.
	selection end textPosition should equal: 4.
	text
		editContentsBy: [ selection delete ]
		andSubmitChangesBy: [ false ].
	text asString should equal: '123' , String cr , '456'.
	text elements should haveSize: 5.
	selection start textPosition should equal: 3.
	selection end textPosition should equal: 4
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingDeleteInsideSingleLine [
	| selection |
	cursor insert: '123456'.
	text elements should haveSize: 3.
	selection := text newRegion.
	selection selectFullText.
	selection start linePosition: 2.
	selection end linePosition: 4.
	text
		editContentsBy: [ selection delete ]
		andSubmitChangesBy: [ false ].
	text asString should equal: '123456'.
	text elements should haveSize: 3.
	selection start linePosition should equal: 2.
	selection end linePosition should equal: 4
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingDeleteOfFullMiltilineText [
	| selection |
	cursor insert: '123' , String cr , '456'.
	text elements should haveSize: 5.
	selection := text newRegion.
	selection selectFullText.
	selection start textPosition should equal: 0.
	selection end textPosition should equal: 7.
	text
		editContentsBy: [ selection delete ]
		andSubmitChangesBy: [ false ].
	text asString should equal: '123' , String cr , '456'.
	text elements should haveSize: 5.
	selection start textPosition should equal: 0.
	selection end textPosition should equal: 7
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingDeleteOfFullTextSpanAfterCr [
	| selection |
	cursor insert: '123' , String cr , '456'.
	text elements should haveSize: 5.
	selection := text newRegion.
	selection start
		moveToTextEnd;
		moveToLineStart.
	selection end moveToTextEnd.
	selection start textPosition should equal: 4.
	selection end textPosition should equal: 7.
	text
		editContentsBy: [ selection delete ]
		andSubmitChangesBy: [ false ].
	text asString should equal: '123' , String cr , '456'.
	text elements should haveSize: 5.
	selection start textPosition should equal: 4.
	selection end textPosition should equal: 7
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingDeleteOfFullTextSpanAfterCrWhenNextCrExists [
	| selection |
	cursor insert: '123' , String cr , '456' , String cr , '789'.
	text elements should haveSize: 7.
	selection := text newRegion.
	selection start
		moveToLineEnd;
		moveForward.
	selection end
		moveToLineEnd;
		moveForward;
		moveToLineEnd.
	selection start textPosition should equal: 4.
	selection end textPosition should equal: 7.
	text
		editContentsBy: [ selection delete ]
		andSubmitChangesBy: [ false ].
	text asString should
		equal: '123' , String cr , '456' , String cr , '789'.
	text elements should haveSize: 7.
	selection start textPosition should equal: 4.
	selection end textPosition should equal: 7
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingDeleteRegionWithCr [
	| selection |
	cursor insert: '123' , String cr , '456'.
	text elements should haveSize: 5.
	selection := text newRegion.
	selection selectFullText.
	selection start linePosition: 2.
	selection end linePosition: 1.
	selection start textPosition should equal: 2.
	selection end textPosition should equal: 5.
	text
		editContentsBy: [ selection delete ]
		andSubmitChangesBy: [ false ].
	text asString should equal: '123' , String cr , '456'.
	text elements should haveSize: 5.
	selection start textPosition should equal: 2.
	selection end textPosition should equal: 5
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingInsertionCR [
	cursor insert: '123456'.
	text elements should haveSize: 3.
	cursor textPosition: 3.
	text
		editContentsBy: [ cursor insert: String cr ]
		andSubmitChangesBy: [ false ].
	text asString should equal: '123456'.
	text elements should haveSize: 3.
	cursor textPosition should equal: 3
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingInsertionCRAfterSubmittingChanges [
	| change |
	cursor insert: '123456'.
	text elements should haveSize: 3.
	cursor textPosition: 3.
	change := text editContentsBy: [ cursor insert: String cr ].
	text editContentsBy: [ change cancel ].
	text asString should equal: '123456'.
	text elements should haveSize: 3.
	cursor textPosition should equal: 3
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingInsertionCRWithVetoAfterSubmittingChanges [
	| change |
	cursor insert: '123456'.
	text elements should haveSize: 3.
	cursor textPosition: 3.
	change := text editContentsBy: [ cursor insert: String cr ].
	text editContentsBy: [ change cancel ] andSubmitChangesBy: [ false ].
	text asString should equal: '123' , String cr , '456'
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingInsertionOfMultilineString [
	cursor insert: '12345'.
	text elements should haveSize: 3.
	cursor textPosition: 3.
	text
		editContentsBy: [ cursor insert: '67' , String cr , '89' ]
		andSubmitChangesBy: [ false ].
	text asString should equal: '12345'.
	text elements should haveSize: 3.
	cursor textPosition should equal: 3
]

{ #category : #'tests-editing-cancelling changes' }
TwyTextAcceptenceTests >> testCancellingInsertionSimpleSingleLineString [
	cursor insert: '123456'.
	text elements should haveSize: 3.
	cursor linePosition: 3.
	text
		editContentsBy: [ cursor insert: 'bbb' ]
		andSubmitChangesBy: [ false ].
	text asString should equal: '123456'.
	text elements should haveSize: 3.
	cursor linePosition should equal: 3
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testDeleteInsideSingleLine [
	| selection |
	cursor insert: '123456'.
	
	selection := text newRegion.
	selection start linePosition: 2.
	selection end linePosition: 4.
			
	selection delete.

	self assert: text asString equals: '1256'
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testDeleteInsideSingleLineWhenSelectionInverted [
	| selection |
	cursor insert: '123456'.
	
	selection := text newRegion.
	selection start linePosition: 4.
	selection end linePosition: 2.
		
	selection delete.

	self assert: text asString equals: '1256'
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testDeleteKey [

	| selection |
	cursor insert: '123',String cr,'456'.
	
	cursor moveToTextStart; moveToLineEnd.

	selection := text newRegion.
	selection moveTo: cursor.
	selection deleteKey.
	
	text asString should equal: '123456'.
	
	selection deleteKey.
	
	text asString should equal: '12356'
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testDeleteKeyBeforeTwoLines [

	| selection |
	cursor insert: '123', String cr, String cr, '456'.
	
	cursor moveToTextStart.
	cursor linePosition: 3.
	
	selection := text newRegion.
	selection moveTo: cursor.
	selection deleteKey.
	selection deleteKey.
	
	text asString should equal: '123456'.
	
	cursor lineNumber should equal: 1.
	cursor linePosition should equal: 3
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testDeleteKeyBetweenThreeEmptyLines [

	| selection |
	cursor insert: '123', String cr, String cr, String cr, '456'.
	
	cursor moveToTextStart; moveToLineEnd; moveForward.
	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 0.
	
	selection := text newRegion.
	selection moveTo: cursor.
	selection deleteKey.
	
	text asString should equal: '123

456'.
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testDeleteKeyBetweenTwoEmptyLinesThenMoveForwardAndBackwardTwice [

	| selection |
	cursor insert: '123', String cr, String cr, '456'.
	
	cursor moveToTextStart; moveToLineEnd; moveForward.
	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 0.
	
	selection := text newRegion.
	selection moveTo: cursor.
	selection deleteKey.
	
	text asString should equal: '123
456'.
	selection end moveForward; moveBackward; moveBackward.
		
	selection end lineNumber should equal: 1.
	selection end linePosition should equal: 3
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testDeleteSingleLine [
	
	| selection |
	cursor insert: '123',String cr,'456'.
	
	selection := text newRegion.
	selection selectFullText.
	selection end moveBackward: 2.
	selection start moveForward: 2.
	
	selection start lineNumber should equal: 1.
	
	selection delete.

	text asString should equal: '1256'
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testDeleteTwoLines [

	| selection |
	cursor insert: '123',String cr, 	'zzzz' , String cr , '456'.
	
	selection := text newRegion.
	selection selectFullText.
	selection end moveBackward: 2.
	selection start moveForward: 2.
	
	selection start lineNumber should equal: 1.
	selection delete.

	text asString should equal: '1256'
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testDeletionOnlyLineSeparator [
	
	| selection |
	cursor insert: '123', String cr, '456'.
	
	cursor moveToTextStart; moveToLineEnd.
	cursor lineNumber should be: 1.
	
	selection := text newRegion.
	selection moveTo: cursor.
	selection deleteKey.
		
	text asString should equal: '123456'
]

{ #category : #'tests-editing-special scenarios' }
TwyTextAcceptenceTests >> testInsertEmptyLineAtEndThenBackspaceThenDelete [
	
	| selection |
	cursor insert: 'ABC'.
	
	cursor moveToTextEnd. 
	cursor insert: String cr.

	selection := text newRegion.
	selection moveTo: cursor.
	selection backspaceKey.
	selection deleteKey.
	
	cursor isAtEnd should be: true.
	
	text asString should equal: 'ABC'.
	cursor linePosition should equal: 3

]

{ #category : #'tests-editing-special scenarios' }
TwyTextAcceptenceTests >> testInsertEmptyLineAtEndThenMoveBackThenDelete [
	
	| selection |
	cursor insert: 'ABC'.
	
	cursor moveToTextEnd. 
	cursor insert: String cr.
	
	cursor moveBackward.
	selection := text newRegion.
	selection moveTo: cursor.
	selection deleteKey.
	
	cursor isAtEnd should be: true.
	
	text asString should equal: 'ABC'.
	cursor linePosition should equal: 3

]

{ #category : #'tests-editing-special scenarios' }
TwyTextAcceptenceTests >> testInsertEmptyLineAtStartThenMoveBackThenDelete [
	
	| selection |
	cursor insert: 'ABC'.
	
	cursor moveToTextStart. 
	cursor insert: String cr.
	cursor moveBackward.
	
	selection := text newRegion.
	selection moveTo: cursor.
	selection deleteKey.
	
	cursor isAtStart should be: true.
	
	text asString should equal: 'ABC'.
	cursor linePosition should equal: 0

]

{ #category : #'tests-editing-special scenarios' }
TwyTextAcceptenceTests >> testInsertEmptyLineThenBacksaceThenInsertLineThenMoveForwardThenMoveBackTwice [
	
	| selection |
	cursor insert: 'AAACCC'.

	cursor linePosition: 3.	
	cursor insert: String cr.
	selection := text newRegion.
	selection moveTo: cursor.
	selection backspaceKey.
	selection end insert: String cr.
	
	text asString should equal: 'AAA', String cr, 'CCC'.
	
	selection end moveForward; moveBackward; moveBackward.

	selection end lineNumber should equal: 1.
	selection end linePosition should equal: 3.
	
]

{ #category : #'tests-editing-special scenarios' }
TwyTextAcceptenceTests >> testInsertEmptyLineThenMoveForwardThenMoveBackTwice [
	
	cursor insert: 'AAACCC'.

	cursor linePosition: 3.	
	cursor insert: String cr.
	
	text asString should equal: 'AAA', String cr, 'CCC'.
	
	cursor moveForward; moveBackward: 2.

	cursor lineNumber should equal: 1.
	cursor linePosition should equal: 3.
	
]

{ #category : #'tests-editing-special scenarios' }
TwyTextAcceptenceTests >> testInsertTwoEmptyLinesThenDeleteFirstAndMoveForward [
	
	| selection |
	cursor insert: 'AAACCC'.

	cursor linePosition: 3.	
	cursor insert: String cr; insert: String cr.
	cursor moveToTextStart.
	cursor linePosition: 3.	

	selection := text newRegion.
	selection moveTo: cursor.
	selection deleteKey.
	selection end moveForward.
	
	text asString should equal: 'AAA', String cr, 'CCC'.
	
	selection end lineNumber should equal: 2.
	selection end linePosition should equal: 0.
	
]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionEmptyLine [
	cursor insert: '123456'.
	cursor linePosition: 3.
	cursor insert: String cr.
	text asString should equal: '123' , String cr , '456'.
	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 0.
	text elements should haveSize: 5
]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionEmptyModel [
	| anotherModel |
	anotherModel := TwyText new.
	cursor insert: anotherModel.
	text elements should haveSize: 3.
	text firstSpan isEmpty should be: true
]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionModelWithSingleNotEmptySpan [
	| anotherModel singleSpan |
	anotherModel := TwyText new.
	singleSpan := anotherModel firstSpan.
	singleSpan contents: '12345'.
	cursor insert: anotherModel.
	text elements should haveSize: 3.
	text firstSpan contents should equal: singleSpan contents.
	cursor span should be: text firstSpan.
	cursor spanPosition should be: 5
]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionModelWithSingleSolidSpan [
	| anotherModel solidSpan |
	anotherModel := TwyText new.
	solidSpan := TwySolidSpan new.
	anotherModel start next: solidSpan.
	solidSpan next: anotherModel end.
	cursor insert: anotherModel.
	text elements should haveSize: 3.
	text firstSpan should be: solidSpan.
	cursor span should be: solidSpan.
	cursor spanPosition should be: 1
]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionMultilineString [
	
	cursor insert: '123456'.

	cursor linePosition: 3.	
	cursor insert: 'bb', String cr, 'bb'.
	
	text asString should equal: '123bb', String cr, 'bb456'.
	
	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 2
]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionNewLineAtTabEnd [
	
	cursor insert: '1	2'.

	cursor linePosition: 1; moveForward.
	
	cursor isAtSpanEnd should be: true.
	
	cursor insert: String cr.	
	
	text asString should equal: '1	
2'.
	
	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 0
]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionNewLineAtTabStart [
	
	cursor insert: '1	2'.

	cursor linePosition: 1; moveForward; moveBackward.
	
	cursor isAtSpanStart should be: true.
	
	cursor insert: String cr.	
	cursor insert: '3'.
	
	text asString should equal: '1
3	2'.
	
	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 1
]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionSimpleSingleLineString [
	
	cursor insert: '123456'.
	
	text asString should equal: '123456'.
	cursor linePosition should equal: 6.
	cursor lineNumber should equal: 1.
	cursor isAtEnd should be: true.
	cursor isAtStart should be: false.
	
	cursor linePosition: 3.
	cursor linePosition should equal: 3.
	
	cursor insert: 'bbb'.
	
	text asString should equal: '123bbb456'.
	
	cursor linePosition should equal: 6

]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionSimpleStringAtEnd [
	
	cursor insert: '123'.
	
	cursor moveToTextEnd. 
	
	cursor isAtEnd should be: true.
	
	cursor insert: '456'.
	
	text asString should equal: '123456'.
	cursor linePosition should equal: 6

]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionSimpleStringAtStart [
	
	cursor insert: '123'.
	
	cursor moveToTextStart.
	
	cursor isAtStart should be: true.
	cursor insert: '456'.
	
	text asString should equal: '456123'.	
	cursor linePosition should equal: 3

]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionSingleEmptyLine [
	
	cursor insert: String cr. 

	cursor isAtEnd should be: true.
	cursor lineNumber should equal: 2.
	
	cursor moveToTextStart.
		
	cursor lineNumber should equal: 1.
	
	cursor moveForward.
	
	cursor lineNumber should equal: 2
]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionThreeEmptyLines [
	
	cursor insert: String cr, String cr, String cr. 
	
	cursor isAtEnd should be: true.	
	cursor lineNumber should equal: 4.
	

]

{ #category : #'tests-editing-insertion' }
TwyTextAcceptenceTests >> testInsertionTwoEmptyLinesAndOneNotEmptyAtTheEnd [
	
	cursor insert: String cr, String cr, String cr, 'CDE'. 
	
	cursor isAtEnd should be: true.
	cursor lineNumber should equal: 4
]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testLineNumberPosition [
	
	cursor insert: '1asd', String cr, '2asd', String cr, '3asd', String cr, '4a'.
	
	cursor moveToTextStart.
	cursor linePosition: 3.
	
	cursor lineNumber should equal: 1.
	
	cursor lineNumber: 3.
	cursor linePosition should equal: 3.
	cursor span contents should equal: '3asd'.
	
	cursor lineNumber: 2.
	cursor linePosition should equal: 3.
	cursor span contents should equal: '2asd'.
	
	cursor lineNumber: 4.
	cursor linePosition should equal: 2.
	cursor span contents should equal: '4a'.

]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testLinePosition [
	
	cursor insert: 'ABC'.
	
	cursor isAtEnd should be:true.
	
	cursor linePosition: 1.
	cursor isAtStart should be: false.
	cursor linePosition should equal: 1.
	cursor isAtEnd should be: false.
	
	cursor linePosition: 0.
	cursor isAtStart should be: true.
	cursor linePosition should equal: 0.
	cursor isAtEnd should be: false.
	
]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testLinePositionWhenItNotExists [
	
	cursor insert: 'ABC'.
	
	cursor spanPosition: 1.
	
	[cursor linePosition: 10] should fail.

	cursor where span should be: text firstSpan.
	cursor where spanPosition should equal: 1
]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testMoveBackwardOnMultiLine [

	cursor insert: 'ABC', String cr, 'DEF'.
	
	cursor moveBackward: 3.
	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 0.
	
	cursor moveBackward.
	cursor lineNumber should equal: 1.
	cursor linePosition should equal: 3.
]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testMoveBackwardOnSingleLine [
	
	cursor insert: '123'.
	
	cursor isAtStart should be: false.
	
	cursor moveBackward: 3.
	cursor isAtStart should be: true.
	
	cursor moveBackward.
	cursor isAtStart should be: true.
]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testMoveForwardOnMultiLine [
	
	cursor insert: 'ABC', String cr, 'DEF'.
	
	cursor moveToTextStart.
	cursor lineNumber should equal: 1.
	cursor linePosition should equal: 0.
	
	cursor moveForward: 3.
	cursor lineNumber should equal: 1.
	cursor linePosition should equal: 3.
	
	cursor moveForward.
	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 0.
]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testMoveForwardOnSingleLine [

	cursor insert: '123'.
		
	cursor moveToTextStart.
	cursor isAtStart should be: true.
	cursor linePosition should equal: 0.
	
	cursor moveForward: 3.
	cursor isAtEnd should be: true.
	cursor linePosition should equal: 3.
	
	cursor moveForward.
	cursor isAtEnd should be: true.
	cursor linePosition should equal: 3.
]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testMoveToLineEnd [

	cursor insert: 'ac', String cr, 'def', String cr, 'ghi'.
	
	cursor moveToTextStart; moveToLineEnd; moveForward.

	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 0.
	
	cursor moveToLineEnd.
	
	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 3.
]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testMoveToStartThenToEnd [
	
	cursor insert: 'ABC', String cr, 'DEF'.
	
	cursor moveToTextStart.
	cursor isAtStart should be: true.
	cursor lineNumber should equal: 1.
	cursor linePosition should equal: 0.
	
	cursor moveToTextEnd.
	cursor isAtEnd should be: true.
	cursor lineNumber should equal: 2.
	cursor linePosition should equal: 3.
]

{ #category : #'tests-selection' }
TwyTextAcceptenceTests >> testMultiLinesFullTextRegionAsString [
	
	| region |
	cursor insert: '123', String cr, '456'.
	
	region := text newRegion.
	
	region selectFullText.
	
	self assert: region asString equals: '123
456'.


]

{ #category : #'tests-selection' }
TwyTextAcceptenceTests >> testMultiLinesRegionAsString [
	
	| region |
	cursor insert: '123', String cr, '456'.
	
	region := text newRegion.
	
	region selectFullText.
	region start moveForward.
	region end moveBackward.
	
	self assert: region asString equals: '23
45'.


]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testRemoveNextItem [

	cursor insert: '123',String cr,'456'.
	
	cursor moveToTextStart; moveToLineEnd; moveBackward.

	cursor removeNextItem.
	
	text asString should equal: '12', String cr,'456'.
	
	cursor removeNextItem.
	
	text asString should equal: '12456'
]

{ #category : #'tests-editing-deletion' }
TwyTextAcceptenceTests >> testRemovePreviousItem [

	cursor insert: '123',String cr,'456'.
	
	cursor moveToTextEnd; moveToLineStart; moveForward.

	cursor removePreviousItem.
	
	text asString should equal: '123', String cr,'56'.
	
	cursor removePreviousItem.
	
	text asString should equal: '12356'
]

{ #category : #'tests-editing-replacement' }
TwyTextAcceptenceTests >> testReplaceAll [
	
	| selection |
	cursor insert: 'ABC'.

	selection := text newRegion.
	selection selectFullText.
	selection replaceWith: 'DEF'.

	text asString should equal: 'DEF'
]

{ #category : #'tests-editing-replacement' }
TwyTextAcceptenceTests >> testReplacePart [

	| selection |
	cursor insert: '123456'.
	
	selection := text newRegion.
	selection selectFullText.
	selection end moveBackward: 3.

	selection replaceWith: 'DEF'.

	self assert: text asString equals: 'DEF456'
]

{ #category : #'tests-selection' }
TwyTextAcceptenceTests >> testReversedRegionAsString [
	
	| region |
	cursor insert: 'ABCDEF'.

	region := text newRegion.
	region start moveToTextStart.
	region end moveToTextStart.
	region start moveForward.
	
	self assert: region asString equals: 'A'.


]

{ #category : #'tests-selection' }
TwyTextAcceptenceTests >> testSelectionFullText [
	
	| region |
	cursor insert: '123', String cr, '456'.
	
	region := text newRegion.
	region selectFullText.
	
	region start isAtStart should be: true.
	region end isAtEnd should be: true.
]

{ #category : #'tests-selection' }
TwyTextAcceptenceTests >> testSingleLineFullTextRegionAsString [
	
	| region |
	cursor insert: '123456'.

	region := text newRegion.
	region selectFullText.	
	
	self assert: region asString equals: '123456'.


]

{ #category : #'tests-selection' }
TwyTextAcceptenceTests >> testSingleLineRegionAsString [
	
	| region |
	cursor insert: '123456'.

	region := text newRegion.
	region selectFullText.	
	region start moveForward.
	region end moveBackward.
	
	self assert: region asString equals: '2345'.


]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testTextPosition [
	
	cursor insert: 'ABC', String cr, 'DEF'.
	
	cursor moveToTextEnd.
	cursor moveBackward: 2.
	
	cursor textPosition should equal: 5.
	
	cursor textPosition: 4.
	cursor linePosition should equal: 0.
	cursor isAtLineStart should be: true.
	
	cursor textPosition: 3.
	cursor linePosition should equal: 3.
	cursor isAtLineEnd should be: true.

]

{ #category : #'tests-navigation' }
TwyTextAcceptenceTests >> testTextPositionWhenItNotExists [
	
	cursor insert: 'ABC'.
	
	cursor spanPosition: 1.
	
	[cursor textPosition: 10] should fail.
	
	cursor where spanPosition should equal: 1.
	cursor where span should be: text firstSpan
]
