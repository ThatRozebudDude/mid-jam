package;

import haxe.Json;
import openfl.utils.Assets;
import transition.data.FadeOut;
import transition.data.FadeIn;
import flixel.FlxG;
import flixel.FlxState;
import haxe.crypto.Md5;

using StringTools;

class Startup extends FlxState
{

	override public function create(){
		super.create();

		FlxG.log.redirectTraces = true;

		//"Uncapped" fps. maybe some other time
		//openfl.Lib.current.stage.frameRate = 999;

		Achievements.init();
		Newgrounds.init();

		FlxG.save.bind('save');
		SaveData.saveDataCheck();
		SaveData.reload();
		SaveData.importAchievements();

		UIStateExt.defaultTransIn = FadeIn;
        UIStateExt.defaultTransInArgs = [0.25];
        UIStateExt.defaultTransOut = FadeOut;
        UIStateExt.defaultTransOutArgs = [0.25];

		FlxG.mouse.visible = false;

		for(x in SongSelect.songList){
			setSongInfo(x);
		}

		SaveData.generateMissingScores();

		FlxG.switchState(new FlixelSplash());
	}

	override function update(elapsed){
		super.update(elapsed);
	}

	function setSongInfo(_name:String){
		if(Assets.exists("assets/songs/" + _name + "/chart0.json")){ //Segmented Songs :face_holding_back_tears:
			var count = 0;
			var finalHash = "";
			var finalNoteCount = 0;
			while(true){
				if(!Assets.exists("assets/songs/" + _name + "/chart" + count + ".json")){
					break;
				}
				else{
					var json = Assets.getText("assets/songs/" + _name + "/chart" + count + ".json").trim();
					while (!json.endsWith("}")){json = json.substr(0, json.length - 1);}
					var notes:Array<Array<Dynamic>> = cast Json.parse(json).notes;
					finalNoteCount += notes.length;
					finalHash += json;
				}
				count++;
			}
			SongSelect.maxCombo.set(_name, finalNoteCount);
			SongSelect.songHash.push(Md5.encode(finalHash));
		}
		else{ // Normal Songs
			var json = Assets.getText("assets/songs/" + _name + "/chart.json").trim();
			while (!json.endsWith("}")){json = json.substr(0, json.length - 1);}
			var notes:Array<Array<Dynamic>> = cast Json.parse(json).notes;
			SongSelect.maxCombo.set(_name, notes.length);
			SongSelect.songHash.push(Md5.encode(json));
		}
	}

}