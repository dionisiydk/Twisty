Class {
	#name : #TwyAnnouncerTests,
	#superclass : #TestCase,
	#instVars : [
		'announcer'
	],
	#category : #'TwistyTests-Model'
}

{ #category : #running }
TwyAnnouncerTests >> setUp [
	super setUp.
	
	announcer := TwyAnnouncer new.
]

{ #category : #tests }
TwyAnnouncerTests >> testCollectingTextChangesShouldReleaseCollectionSubscription [

	| event1 event2 actual |
	event1 := TwyTextStateChanged new.
	event2 := TwyTextStateChanged new.
	
	actual := announcer collectChangesOf: #text during: [ announcer announce: event1].
	
	announcer announce: event2.
	
	actual textChanges should equal: { event1 }
]

{ #category : #tests }
TwyAnnouncerTests >> testCollectingTextChangesShouldReleaseCollectionSubscriptionWhenGivenBlockFailed [
	
	[
		announcer collectChangesOf: #text during: [ self error: 'test'].
	] should fail.

	announcer subscriptions numberOfSubscriptions should equal: 0.
	
]

{ #category : #tests }
TwyAnnouncerTests >> testCollectingTextChangesShouldReturnCollectedChanges [
	| event1 event2 actual |
	event1 := TwyTextStateChanged new.
	event2 := TwyCursorMoved new.
	actual := announcer
		collectChangesOf: #text
		during: [ announcer
				announce: event1;
				announce: event2 ].
	actual should beInstanceOf: TwyChangesCollection.
	actual text should be: #text.
	actual textChanges should equal: {event1}.
	actual cursorsChanges should equal: {event2}
]
