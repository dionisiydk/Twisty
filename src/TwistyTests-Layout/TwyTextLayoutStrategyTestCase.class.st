Class {
	#name : #TwyTextLayoutStrategyTestCase,
	#superclass : #TestCase,
	#instVars : [
		'strategy'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #testing }
TwyTextLayoutStrategyTestCase class >> isAbstract [
	^self == TwyTextLayoutStrategyTestCase 
]

{ #category : #running }
TwyTextLayoutStrategyTestCase >> setUp [ 
	super setUp.
	strategy := self strategyClass new.
]

{ #category : #tests }
TwyTextLayoutStrategyTestCase >> testBuildTextLayout [

	[ :text :layout |
		[ (strategy layoutText: text) should be: layout ]
			should strictly satisfy:
		[ text prepareNewLayout willReturn: layout.
		layout buildBy: strategy ]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyTextLayoutStrategyTestCase >> testCreationBuilder [
	| layoutLine actual firstSpan |
	firstSpan := Mock new.
	layoutLine := Mock new.
	layoutLine stub firstSpan willReturn: firstSpan.
	firstSpan stub line willReturn: layoutLine.
	actual := strategy createBuilderFor: #layout startedAt: layoutLine.
	actual should beInstanceOf: TwyLayoutBuilder.
	actual layout should be: #layout.
	actual layoutStrategy should be: strategy.
	actual currentLine should be: layoutLine.
	actual currentSpan should be: firstSpan
]
