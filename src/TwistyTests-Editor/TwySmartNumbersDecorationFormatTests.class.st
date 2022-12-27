Class {
	#name : #TwySmartNumbersDecorationFormatTests,
	#superclass : #TestCase,
	#instVars : [
		'format'
	],
	#category : #'TwistyTests-Editor'
}

{ #category : #running }
TwySmartNumbersDecorationFormatTests >> setUp [
	super setUp.
	
	format := TwySmartNumbersDecorationFormat new
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testConvertingDecoratedPositionToNative [
	
	| actual |
	actual := format convertDecoratedPosition: 3 toNativeOn: '10 000'.
	
	actual should equal: 2
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testConvertingDecoratedPositionToNative2 [
	
	| actual |
	actual := format convertDecoratedPosition: 6 toNativeOn: '10 0 00'.
	
	actual should equal: 4
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testConvertingDecoratedPositionToNativeWhenItBeforeSeparator [
	
	| actual |
	actual := format convertDecoratedPosition: 6 toNativeOn: '10 000 000'.
	
	actual should equal: 5
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testConvertingDecoratedPositionToNativeWhenItIsEndOfText [
	
	| actual |
	actual := format convertDecoratedPosition: 6 toNativeOn: '10 000'.
	
	actual should equal: 5
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testConvertingDecoratedPositionToNativeWhenItIsStartOfText [
	
	| actual |
	actual := format convertDecoratedPosition: 0 toNativeOn: '10 000'.
	
	actual should equal: 0
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testConvertingDecoratedStringToNative [
	
	| actual |
	actual := format convertDecoratedStringToNative: '10 00 0'.
	
	actual should equal: '10000'
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testConvertingNativePositionToDecorated [
	
	| actual |
	actual := format convertNativePosition: 3 toDecoratedOn: '10 000'.
	
	actual should equal: 4
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testConvertingNativePositionToDecorated2 [
	
	| actual |
	actual := format convertNativePosition: 4 toDecoratedOn: '10 0 00'.
	
	actual should equal: 6
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testConvertingNativePositionToDecoratedWhenItIsStartOfText [
	
	| actual |
	actual := format convertNativePosition: 0 toDecoratedOn: '10 000'.
	
	actual should equal: 0
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testEmptyTextTransformation [
	
	| actual |
	actual := format transform: ''.
	
	actual should equal: ''
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testHasThousandsSeparatorByDefault [
	
	format thousandsSeparator should equal: ' '
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testTextTransformationWhenDecimalPartExistsWithCommaSeparator [
	
	| actual |
	actual := format transform: '10000,2345'.
	
	actual should equal: '10 000,2345'
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testTextTransformationWhenDecimalPartExistsWithPeriodSeparator [
	
	| actual |
	actual := format transform: '10000.2345'.
	
	actual should equal: '10 000.2345'
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testTextTransformationWhenItEndsWithDecimalSeparator [
	
	| actual |
	actual := format transform: '10000.'.
	
	actual should equal: '10 000.'
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testTextTransformationWhenNoThousands [
	
	| actual |
	actual := format transform: '10'.
	
	actual should equal: '10'
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testTextTransformationWhenOneThousandthGroupExists [
	
	| actual |
	actual := format transform: '10000'.
	
	actual should equal: '10 000'
]

{ #category : #tests }
TwySmartNumbersDecorationFormatTests >> testTextTransformationWhenTwoThousandthGroupExists [
	
	| actual |
	actual := format transform: '10123000'.
	
	actual should equal: '10 123 000'
]
