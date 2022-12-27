Class {
	#name : #TwyLayoutRegionTests,
	#superclass : #TestCase,
	#instVars : [
		'layout',
		'start',
		'end',
		'region'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyLayoutRegionTests >> setUp [
	super setUp.
	
	layout := Mock new.
	start := Mock new.
	end := Mock new.
	
	region := TwyLayoutRegion new.
	region 
		layout: layout;
		start: start;
		end: end
]

{ #category : #tests }
TwyLayoutRegionTests >> testBoundsChangedNotification [

	| triggered |
	region when: TwyLayoutChanged do: [ :ann | triggered := true ].
	
	region boundsChanged.
	
	triggered should be: true
]

{ #category : #tests }
TwyLayoutRegionTests >> testCreationOnLayout [
	| actual |
	[ [ actual := TwyLayoutRegion on: layout ] should lenient
		satisfy: [ layout newCursor willReturn: start.
			start ignoreLayoutChanges.
			layout newCursor willReturn: end.
			end ignoreLayoutChanges.
			start
				when: TwyPositionChanged
				send: #boundsChanged
				to: [ :arg | 
					region := arg.
					true ].
			end
				when: TwyPositionChanged
				send: #boundsChanged
				to: [ :arg | 
					region := arg.
					true ].
			layout
				when: TwyLayoutChanged
				send: #recomputeBounds
				to: [ :arg | 
					region := arg.
					true ] ].
	actual should be: region.
	region should beInstanceOf: TwyLayoutRegion ] runWithMocks
]

{ #category : #tests }
TwyLayoutRegionTests >> testDetachTextModel [

	[ 
		[ region detachText ]
			should strictly satisfy: 
		[ start detachText.
		end detachText ]
	 ] runWithMocks 
]

{ #category : #tests }
TwyLayoutRegionTests >> testGettingTextRegion [
	| actual |
	start stub textCursor willReturn: #startTextCursor.
	end stub textCursor willReturn: #endTextCursor.
	actual := region textRegion.
	actual should beInstanceOf: TwyTextRegion.
	actual start should be: #startTextCursor.
	actual end should be: #endTextCursor
]

{ #category : #tests }
TwyLayoutRegionTests >> testIsEmpty [

	(start stub isAtSameTextPositionWith: end) willReturn: #result.
	
	region isEmpty should be: #result
]

{ #category : #tests }
TwyLayoutRegionTests >> testRecomputingBoundsWhenEndChanged [

	| regionChanged startTrigger endTrigger |
	[
		region when: TwyLayoutChanged do: [ :ann | regionChanged := true ].
		
		[region recomputeBounds]
			should strictly satisfy: 
		[start unsubscribe: region.
		end unsubscribe: region.
		start when: TwyPositionChanged send: #value to: [ :arg | startTrigger := arg. true ].		
		end when: TwyPositionChanged send: #value to: [ :arg | endTrigger := arg. true ].
		start synchronizeWithTextCursor.
		end synchronizeWithTextCursor will: [endTrigger value]. 
		start unsubscribe: [:arg | arg == startTrigger].
		end unsubscribe: [:arg | arg == endTrigger].
		start when: TwyPositionChanged send: #boundsChanged to: region.
		end when: TwyPositionChanged send: #boundsChanged to: region].
	
		regionChanged should be: true		
	] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutRegionTests >> testRecomputingBoundsWhenNothingChanged [

	| regionChanged startTrigger endTrigger |
	[
		region when: TwyLayoutChanged do: [ :ann | regionChanged := true ].
		
		[region recomputeBounds]
			should strictly satisfy: 
		[start unsubscribe: region.
		end unsubscribe: region.
		start when: TwyPositionChanged send: #value to: [ :arg | startTrigger := arg. true ].		
		end when: TwyPositionChanged send: #value to: [ :arg | endTrigger := arg. true ].
		start synchronizeWithTextCursor.
		end synchronizeWithTextCursor. 
		start unsubscribe: [:arg | arg == startTrigger].
		end unsubscribe: [:arg | arg == endTrigger].
		start when: TwyPositionChanged send: #boundsChanged to: region.
		end when: TwyPositionChanged send: #boundsChanged to: region].
	
		regionChanged should not be: true		
	] runWithMocks 
	
]

{ #category : #tests }
TwyLayoutRegionTests >> testRecomputingBoundsWhenStartChanged [

	| regionChanged startTrigger endTrigger |
	[
		region when: TwyLayoutChanged do: [ :ann | regionChanged := true ].
		
		[region recomputeBounds]
			should strictly satisfy: 
		[start unsubscribe: region.
		end unsubscribe: region.
		start when: TwyPositionChanged send: #value to: [ :arg | startTrigger := arg. true ].		
		end when: TwyPositionChanged send: #value to: [ :arg | endTrigger := arg. true ].
		start synchronizeWithTextCursor will: [startTrigger value].
		end synchronizeWithTextCursor. 
		start unsubscribe: [:arg | arg == startTrigger].
		end unsubscribe: [:arg | arg == endTrigger].
		start when: TwyPositionChanged send: #boundsChanged to: region.
		end when: TwyPositionChanged send: #boundsChanged to: region].
	
		regionChanged should be: true		
	] runWithMocks 
	
]
