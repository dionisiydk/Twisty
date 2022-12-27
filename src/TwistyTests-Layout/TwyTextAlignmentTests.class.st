Class {
	#name : #TwyTextAlignmentTests,
	#superclass : #TestCase,
	#instVars : [
		'alignment'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyTextAlignmentTests >> setUp [
	super setUp.
	
	alignment := TwyTextAlignment new.
]

{ #category : #tests }
TwyTextAlignmentTests >> testLayoutLine [

	[:line | 
		alignment lineAlignmentSelector: #selector.
		
		[alignment layoutLine: line within: 20]
			should strictly satisfy: 
		[line perform: #selector with: 20]
	
	] runWithMocks 

	
]
