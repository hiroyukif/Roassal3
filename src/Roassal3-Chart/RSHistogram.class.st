Class {
	#name : #RSHistogram,
	#superclass : #Object,
	#instVars : [
		'values',
		'numberOfBuckets',
		'minValueBlock',
		'maxValueBlock'
	],
	#category : #'Roassal3-Chart-Histogram'
}

{ #category : #accessing }
RSHistogram >> build [
	| data c d |
	data := self getBuckets collect: [ :l | l size ].
	c := RSChart new.
	d := RSBarPlot new.
	d y: data.
	c addPlot: d.
	c addDecoration: (RSYLabelDecoration new title: 'Frequency'; offset: -20 @ 0).
	c addDecoration: RSVerticalTick new.
	c
		addDecoration:
			(RSHorizontalTick new
				numberOfTicks: numberOfBuckets;
				labelConversion:
						[ :v | (v - 1) * (maxValueBlock rsValue: values max) / (numberOfBuckets - 1) ];
				doNotUseNiceLabel).
	^ c
]

{ #category : #accessing }
RSHistogram >> getBuckets [
	| buckets data index |
	buckets := self getBucketsDelimiters.
	data := OrderedCollection new.
	numberOfBuckets timesRepeat: [ data add: OrderedCollection new ].
	values
		do: [ :aValue | 
			index := numberOfBuckets.
			(2 to: buckets size)
				do: [ :inb | 
					((buckets at: inb - 1) <= aValue and: [ aValue < (buckets at: inb) ])
						ifTrue: [ index := inb - 1 ] ].
			(data at: index) add: aValue ].
	^ data asArray collect: #asArray
]

{ #category : #accessing }
RSHistogram >> getBucketsDelimiters [
	^ ((minValueBlock rsValue: values min)
		to: (maxValueBlock rsValue: values max)
		count: numberOfBuckets + 1) collect: #asFloat
]

{ #category : #initialization }
RSHistogram >> initialize [
	super initialize.
	self minValueBlock: [ :vMinValue | vMinValue ].
	self maxValueBlock: [ :vMaxValue | vMaxValue ].	
]

{ #category : #accessing }
RSHistogram >> maxValueBlock [
	^ maxValueBlock
]

{ #category : #accessing }
RSHistogram >> maxValueBlock: anObject [
	maxValueBlock := anObject
]

{ #category : #accessing }
RSHistogram >> minValueBlock [
	^ minValueBlock
]

{ #category : #accessing }
RSHistogram >> minValueBlock: anObject [
	minValueBlock := anObject
]

{ #category : #accessing }
RSHistogram >> numberOfBuckets: nb [
	numberOfBuckets := nb
]

{ #category : #accessing }
RSHistogram >> open [
	^ self build open
]

{ #category : #accessing }
RSHistogram >> values: someValues [
	values := someValues 
]