package;

class GameplaySongState extends UIStateExt
{
	private var nextStep:Float = 0;
	private var currentStep:Float = 0;

	private var hitRegion:Float = 0;
	var hitCheck:Bool = false;
	var wasInHitRegion:Bool = false;

	private var beat:Int = -1;
	private var eighth:Int = -1;
	private var step:Int = -1;

	private var songBeat:Int = 0;
	private var songEighth:Int = 0;
	private var songStep:Int = 0;
	
	private var beatRegion:Int = 0;
	private var eighthRegion:Int = 0;
	private var stepRegion:Int = 0;

	override function create() { 
		super.create(); 
	}

	override function update(elapsed:Float)
	{
		//Conductor.update();

		songStep = Math.floor(Conductor.audioReference.time / Conductor.sixteenthNoteTime);
		songEighth = Math.round(songStep / 2);
		songBeat = Math.round(songStep / 4);

		stepRegion = Math.round(Conductor.audioReference.time / Conductor.sixteenthNoteTime);
		eighthRegion = Math.round(Conductor.audioReference.time / Conductor.eighthNoteTime);
		beatRegion = Math.round(Conductor.audioReference.time / Conductor.quarterNoteTime);

		if (Conductor.audioReference.time > nextStep){
			stepHit();
		}

		super.update(elapsed);
	}

	public function stepHit():Void {
		currentStep = nextStep;
		nextStep += Conductor.sixteenthNoteTime;

		step += 1;

		if (step % 2 == 0) { eighthHit(); }
		if (step % 4 == 0) { beatHit(); }
	}

	public function beatHit():Void { beat += 1; }

	public function eighthHit():Void { eighth += 1; }

	public function resetSong():Void{
		nextStep = 0;
		step = -1;
		beat = -1;
		eighth = -1;
	}

}
