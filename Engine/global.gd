extends Node

func _ready():
	
	if run.lv1beat == true:
		$level1star.show()
	
	if run.lv2beat == true:
		$level2star.show()
	
	if run.lv3beat == true:
		$level3star.show()
	
	$hs1.text = "Highscore: " + var2str(int(floor(run.highscore1)))
	$hs2.text = "Highscore: " + var2str(int(floor(run.highscore2)))
	$hs3.text = "Highscore: " + var2str(int(floor(run.highscore3)))
