extends TargetSelector
class_name SingleTargetSelector

func select_targets(ability, user):
	return [user.get_selected_target()]  # 假设用户有某种方式选择目标
