extends PanelContainer


func _on_tool_hoe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.HOE)
	print("Farming mode: Hoe")


func _on_tool_water_can_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.WATERING_CAN)
	print("Farming mode: Watering Can")


func _on_seed_potato_pressed() -> void:
	ToolManager.select_crop(DataTypes.Crops.POTATO)
	print("Seed: Potato")


func _on_seed_parsnip_pressed() -> void:
	ToolManager.select_crop(DataTypes.Crops.PARNSIP)
	print("Seed: Parsnip")


func _on_seed_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.SEED)
	print("Farming mode: Seed")
