Class {
	#name : #TwyTextChangedTests,
	#superclass : #TestCase,
	#instVars : [
		'event',
		'changes'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyTextChangedTests >> setUp [
	super setUp.
	
	changes := Mock new.
	event := TwyTextChanged changes: changes
]

{ #category : #tests }
TwyTextChangedTests >> testCancellingChanges [

	[ 
		[ event cancel ]
			should strictly satisfy:
		[ changes cancel ]
	 ] runWithMocks 
]

{ #category : #tests }
TwyTextChangedTests >> testCollectingLayoutCommandsForBuilder [
	| builder commands |
	builder := Mock new.
	commands := OrderedCollection new.
	(builder stub addLayoutCommand: Any)
		will: [ :arg | commands add: arg ].
	changes stub textChanges willReturn: #(#change1 #change2).
	event collectLayoutCommandsFor: builder.
	commands should haveSize: 2.
	commands first should beInstanceOf: TwyProcessTextChangeCommand.
	commands first textChange should be: #change1.
	commands last should beInstanceOf: TwyProcessTextChangeCommand.
	commands last textChange should be: #change2
]

{ #category : #tests }
TwyTextChangedTests >> testHasTimeByDefault [

	event time should not be: nil
]
