global actorAttributes = attributes actorProperties attribID:#( 0xaf709ca, 0x84ff0730 )
(
	parameters actorParameters rollout:actorPropertiesRollout
	(
		renderMode type:#integer ui:renderMode default:4
		modelName type:#string ui:modelName default:"" autodisplay:true
		materialName type:#string ui:materialName default:"" autodisplay:true
	)
	rollout actorPropertiesRollout "Actor Properties:"
	(
		dropdownlist renderMode "Actor render mode:" items:#( "invisible", "vertices", "wireframe", "normal", "bbox vertices", "bbox edges", "bbox" ) selection:4 align:#right label:false tooltip:"Change the mode of the animation."
		label modelNameLabel "Actor model name:"
		edittext modelName ""
		label materialNameLabel "Actor material name:"
		edittext materialName ""
	)
	fn getrollout = actorPropertiesRollout
)
for o in selection do custAttributes.add o actorAttributes