extends Node

var selected_tool = DataTypes.Tools.NONE
var selected_crop = DataTypes.Crops.NONE

signal tool_selected(tool: DataTypes.Tools)
signal crop_selected(crop: DataTypes.Crops)

func select_tool(tool: DataTypes.Tools):
	tool_selected.emit(tool)
	selected_tool = tool

func select_crop(crop: DataTypes.Crops):
	crop_selected.emit(crop)
	selected_crop = crop
