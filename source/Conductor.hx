package;

import flixel.system.FlxSound;
import flixel.FlxG;

//hi mr muffin i did not steam your code :]
class Conductor
{
	private static var __bpm:Float = 100;
	public static var bpm(get, set):Float;

	public static var audioReference:FlxSound;
	public static var quarterNoteTime:Float = ((60 / bpm) * 1000); // beats in milliseconds
	public static var eighthNoteTime:Float = quarterNoteTime / 2; // steps in milliseconds
	public static var sixteenthNoteTime:Float = quarterNoteTime / 4; // steps in milliseconds

	public static var hitWindow:Float = 280;
	
	public function new(){
	}
	
	private static function get_bpm():Float{
		return __bpm;
	}

	private static function set_bpm(value:Float):Float{
		__bpm = value;
		quarterNoteTime = ((60 / bpm) * 1000); // beats in milliseconds
		eighthNoteTime = quarterNoteTime / 2; // steps in milliseconds
		sixteenthNoteTime = quarterNoteTime / 4; // steps in milliseconds
		return __bpm;
	}

}

