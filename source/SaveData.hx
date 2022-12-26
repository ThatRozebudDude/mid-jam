package;

import io.newgrounds.NG;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
using StringTools;

class SaveData
{
	
	public static var binds:Array<FlxKey>;
	public static var scores:Map<String, Score> = new Map();
	public static var achievements:Map<String, Array<Dynamic>> = new Map();
	public static var linearNotes:Bool = true;

	public static function resetSettings():Void{

		FlxG.save.data.binds = [FlxKey.C, FlxKey.X, FlxKey.Z];
		reload();

	}
	
	public static function reload():Void{

		binds = FlxG.save.data.binds;
		scores = FlxG.save.data.scores;
		achievements = FlxG.save.data.achievements;

	}
	
	public static function write():Void{

		FlxG.save.data.binds = binds;
		FlxG.save.data.scores = scores;
		FlxG.save.data.achievements = achievements;

		FlxG.save.flush();
		
		reload();

	}
	
	public static function saveDataCheck():Void{

		if(FlxG.save.data.binds == null)
			FlxG.save.data.binds = [FlxKey.C, FlxKey.X, FlxKey.Z];
		if(FlxG.save.data.scores == null)
			FlxG.save.data.scores = new Map<String, Score>();
		if(FlxG.save.data.achievements == null)
			FlxG.save.data.achievements = new Map<String, Array<Dynamic>>();

	}

	public static function generateMissingScores():Void{

		for(i in 0...SongSelect.songList.length){

			if(!scores.exists(SongSelect.songList[i])){
				scores.set(SongSelect.songList[i], new Score(0, SongSelect.songHash[i]));
			}
			else if(scores.get(SongSelect.songList[i]).hash != SongSelect.songHash[i]){
				scores.set(SongSelect.songList[i], new Score(0, SongSelect.songHash[i]));
			}

		}

		write();

	}

	public static function resetScores():Void{
		scores = new Map<String, Score>();
		generateMissingScores();

		Achievements.init();
		achievements = new Map<String, Array<Dynamic>>();
		importAchievements();

		if(Newgrounds.isLoggedIn){
			for(x in Achievements.ngMedalMap.keyValueIterator()){
				Achievements.achievementMap.get(x.key)[2] = NG.core.medals.get(x.value).unlocked;
			}
		}
	}

	public static function importAchievements():Void{
		if(Newgrounds.isLoggedIn){
			trace("NG Import");
			achievements = new Map<String, Array<Dynamic>>();
			for(x in Achievements.ngMedalMap.keyValueIterator()){
				trace(NG.core.medals.get(x.value).unlocked);
				Achievements.achievementMap.get(x.key)[2] = NG.core.medals.get(x.value).unlocked;
				trace(x.key + ": " + NG.core.medals.get(x.value).unlocked + " | " + Achievements.achievementMap.get(x.key)[2]);
			}
		}
		else{
			trace("Save Import");
			for(x in Achievements.achievementMap.keyValueIterator()){
				if(achievements.exists(x.key)){
					Achievements.achievementMap.get(x.key)[2] = achievements.get(x.key)[2];
				}
			}
		}

		achievements = Achievements.achievementMap;
		write();
	}
	
}

class Score{

	public var score:Int;
	public var hash:String;

	public function new(_score:Int = 0, _hash:String = ""){
		score = _score;
		hash = _hash;
	}

}