extends Control
class_name Card

enum CARD_STATE {
	NORMAL, 
	DRAGGING, 
	PREVIEW,
	PRERELEASE, 
	}

const CARD_TYPE_NAME = [
	"UNKNOW",
	"攻击",
	"技能",
]

@onready var lab_name: Label = %lab_name
@onready var tr_icon: TextureRect = %tr_icon
@onready var lab_description: RichTextLabel = %lab_description
@onready var lab_type: Label = %lab_type
@onready var lab_cost: Label = %lab_cost

@export var card_state : CARD_STATE = CARD_STATE.NORMAL
@export var tween_speed : float = 0.1
@export var is_back : bool

@onready var card : TextureRect = $t_card
@onready var timer_preview = $timer_preview
@onready var timer_release = $timer_release

var cardID : StringName
var _model : CardModel

func _ready():
	_model = CardModel.new(cardID)
#	self.pivot_offset = Vector2(card.size.x/2, card.size.y)
	lab_name.text = _model.card_name
	lab_description.text = _model.card_description
	lab_type.text = CARD_TYPE_NAME[_model.card_type]
	lab_cost.text = str(_model.cost)
	tr_icon.texture = _model.icon

func predragging():
	if card_state == CARD_STATE.PRERELEASE:
		print("predragging")
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(card, "scale", Vector2(1,1), tween_speed)
		tween.play()
		card_state = CARD_STATE.DRAGGING

func prerelease():
	if card_state != CARD_STATE.PRERELEASE:
		# print("prerelease")
		var tween : Tween = get_tree().create_tween()
		tween.interpolate_property(card, "scale", Vector2(1.5,1.5), tween_speed)
		tween.play()
		card_state = CARD_STATE.PRERELEASE

func needs_target() -> bool:
	return _model.needs_target()

func can_release() -> bool:
	var player = GameInstance.player
	if _model.cost <= player.energy:
		return true
	return false

func get_effect_targets(caster: Character, targets: Array[Character]) -> Array:
	return _model.get_effect_targets(caster, targets)

func create_effects(targets: Array[Character]) -> Array[Effect]:
	var caster : Character = GameInstance.player
	var _targets : Array[Character] = get_effect_targets(caster, targets)
	var effects: Array[Effect]
	for e in _model.effects:
		var effect = Effect.create_effect(e, _targets)
		effects.append(effect)
	return effects

func _to_string() -> String:
	return self.name + " : " + _model.card_name
