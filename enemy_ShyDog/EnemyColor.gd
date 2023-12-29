extends Polygon2D

func stateCurious():
	color = Color(0.1,1,0.1)
	
func stateThreatened():
	color = Color(0.6,0.6,0)

func stateWindup():
	color = Color(0.8,0,0)
	
func stateAttack():
	color = Color(0.5,0,0)
