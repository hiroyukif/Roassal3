"
I can add a popup on an element when a move over event occurs.

Here is an example:
-=-=-=-=
c := RSCanvas new.

classes := RSObject withAllSubclasses.

scale := TSScale linear
	domain: { (classes collect: #numberOfMethods) min . (classes collect: #numberOfMethods) max};
	range: { 'red'. 'blue' }.

classes do: [ :cls |
	| b |
	b := RSEllipse new.
	b size: cls numberOfMethods.
	b color: (scale scale: cls numberOfMethods).
	b model: cls.
	b @ RSPopup.
	c add: b ].

RSFlowLayout on: c shapes.

c @ RSControlsCanvas
-=-=-=-=
"
Class {
	#name : #RSPopup,
	#superclass : #RSAbstractPopup,
	#instVars : [
		'shapeBuilder',
		'modelBlock'
	],
	#category : #'Roassal3-Interaction-Popup'
}

{ #category : #accessing }
RSPopup class >> text: anObject [
	| inst |
	inst := self new.
	inst shapeBuilder textBlock: anObject.
	^ inst
]

{ #category : #hooks }
RSPopup >> createPopupFor: aShape event: event [
	| popupShape |
	popupShape := shapeBuilder shapeFor: (self modelFor: aShape).
	popupShape isFixed: true.
	event canvas addShape: popupShape.
	^ popupShape.
]

{ #category : #initialization }
RSPopup >> initialize [
	super initialize.
	self model: #model.
	shapeBuilder := RSSimplePopupBuilder new.
]

{ #category : #accessing }
RSPopup >> model [
	^ modelBlock
]

{ #category : #accessing }
RSPopup >> model: anObject [
	"
	- can be a one arg BlockClosure 
	- can be a ByteString
	"
	modelBlock := anObject.
]

{ #category : #accessing }
RSPopup >> modelFor: aRSShape [
	^ modelBlock rsValue: aRSShape
]

{ #category : #hooks }
RSPopup >> releasePopup: popup [
	popup remove
]

{ #category : #accessing }
RSPopup >> shapeBuilder [
	^ shapeBuilder
]

{ #category : #accessing }
RSPopup >> shapeBuilder: aShapeBuilder [
	shapeBuilder := aShapeBuilder
]

{ #category : #accessing }
RSPopup >> text: oneArgBlock [
	"The block is evaluated with the model provided as argument"
	self shapeBuilder textBlock: oneArgBlock
]

{ #category : #hooks }
RSPopup >> translatePopup: popup event: evt [ 
	| p e extent |
	p := evt camera fromSpaceToPixel: evt position.
	extent := popup canvas extent.
	e := (popup extent /2) + 5.
	p x + popup width > extent x ifTrue: [ 
		e := e x negated @ e y.
		p x - popup width < 0
		ifTrue: [ e := p x negated + (popup width/2 + 4) @ e y ].
		].
	p y + popup height > extent y ifTrue: [ 
		e := e x @ e y negated.
		p y - popup height < 0
		ifTrue: [ e := e x @ ( p y negated + (popup height/2 + 4) ) ]
		]. 
	popup translateTo: p + e.
]
