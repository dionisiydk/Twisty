Class {
	#name : #TwyCodeMarkup,
	#superclass : #Object,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#instVars : [
		'currentRegion'
	],
	#category : #'Twisty-CodeMarkup'
}

{ #category : #'private ' }
TwyCodeMarkup >> markTextWithNode: aVariableNode [

	currentRegion selectTextBetween: aVariableNode start - 1 and: aVariableNode stop.
	
	currentRegion applyAttribute: TwyProgramNodeAttribute with: aVariableNode
]

{ #category : #processing }
TwyCodeMarkup >> processText: aTwyText by: aCompiler [

	| ast |
	currentRegion := aTwyText newRegion.
	
	aCompiler source: aTwyText asString.
	aCompiler useFaultyForParsing: true.
	ast := aCompiler parse.
	ast acceptVisitor: self
]

{ #category : #visiting }
TwyCodeMarkup >> visitLiteralNode: aLiteralNode [

	self markTextWithNode: aLiteralNode
]

{ #category : #visiting }
TwyCodeMarkup >> visitParseErrorNode: anErrorNode [

	self markTextWithNode: anErrorNode
]

{ #category : #visiting }
TwyCodeMarkup >> visitVariableNode: aVariableNode [

	self markTextWithNode: aVariableNode 
]
