Class {
	#name : #TwyTextChangeAnnouncementTestCase,
	#superclass : #TestCase,
	#instVars : [
		'change',
		'text'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #testing }
TwyTextChangeAnnouncementTestCase class >> isAbstract [
	^self == TwyTextChangeAnnouncementTestCase 
]

{ #category : #running }
TwyTextChangeAnnouncementTestCase >> setUp [
	super setUp.
	
	text := Mock new.
	change := self textChangeClass onText: text.
]

{ #category : #running }
TwyTextChangeAnnouncementTestCase >> textChangeClass [
	self subclassResponsibility 
]
