"
My subclasses implement simple string transformation and convertion between native and decorated text positions

"
Class {
	#name : #TwyDecorationFormat,
	#superclass : #Object,
	#category : #'Twisty-Editor'
}

{ #category : #operations }
TwyDecorationFormat >> convertDecoratedPosition: index toNativeOn: aString [

	self subclassResponsibility 
]

{ #category : #operations }
TwyDecorationFormat >> convertDecoratedStringToNative: aString [

	self subclassResponsibility 
]

{ #category : #operations }
TwyDecorationFormat >> convertNativePosition: index toDecoratedOn: aString [

	self subclassResponsibility 
]
