package;

import flixel.FlxBasic;
import flixel.util.FlxTimer;
import flixel.util.FlxGradient;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Achievements
{   

    public static var achievementMap:Map<String, Array<Dynamic>>;
    public static var ngMedalMap:Map<String, Int>;
    public static var achievementNames:Array<String> = ["beatTutorial", "fcEMB", "fcDDSD", "liverFailure", "fcChristmas", "fcHWGA", "thanks", "buttonMash", "tutorialFail", "cam"];

    public static function init(){
        achievementMap = new Map();
        ngMedalMap = new Map();

        //Name, Desc, unlocked bool, secret
        achievementMap.set("buttonMash", ["I Don't Know What I'm Doing!", "Spam like the idiot you are.", false, true]);
        achievementMap.set("beatTutorial", ["Give Me A Drink, Bartender!", "Complete the tutorial.", false, false]);
        achievementMap.set("fcEMB", ["God's Drunkest Driver", "Full Combo Early Mornin' Booze.", false, false]);
        achievementMap.set("fcDDSD", ["Drink Til' Yer Dead", "Full Combo Drunken Do-Si-Do.", false, false]);
        achievementMap.set("liverFailure", ["Liver Failure", "Full Combo Moonshine Melody.", false, false]);
        achievementMap.set("fcChristmas", ["Ice Cold", "Full Combo Holly Jolly Jivin'.", false, false]);
        achievementMap.set("fcHWGA", ["Dead Estate", "Full Combo Here We Go Again.", false, false]);
        achievementMap.set("thanks", ["Thank You!", "Visit the credits.", false, false]);
        achievementMap.set("tutorialFail", ["how", "", false, true]);
        achievementMap.set("cam", ["It's Like That Other Game", "Play the game on a Friday night.", false, true]);

        ngMedalMap.set("beatTutorial", 72211);
        ngMedalMap.set("fcEMB", 72212);
        ngMedalMap.set("fcDDSD", 72213);
        ngMedalMap.set("liverFailure", 72214);
        ngMedalMap.set("fcChristmas", 72215);
        ngMedalMap.set("fcHWGA", 72216);
        ngMedalMap.set("thanks", 72217);
        ngMedalMap.set("buttonMash", 72218);
        ngMedalMap.set("tutorialFail", 72219);
        ngMedalMap.set("cam", 72220);
    }

    public static function unlock(_achievementName:String, ?_dontUnlock:Bool = false){
        if(!achievementMap.get(_achievementName)[2]){
            FlxG.state.add(new AchievementSplash(_achievementName));

            if(!_dontUnlock){
                if(Newgrounds.isLoggedIn){
                    Newgrounds.awardMedal(ngMedalMap.get(_achievementName));
                }

                achievementMap.get(_achievementName)[2] = true;
                SaveData.achievements = achievementMap;
                SaveData.write();
            }
        }
    }

}

class AchievementSplash extends FlxSpriteGroup
{   
    override public function new(_name:String){

        super(0, 0);

        var icon = new FlxSprite(4, 4).loadGraphic("assets/images/achievements/" + _name + ".png");
        var lock = new FlxSprite(4, 4).loadGraphic("assets/images/achievements/lock.png");
        
        var unlockSplash = new FlxSprite(4, 4).loadGraphic("assets/images/achievements/unlock.png");

        var text = new FlxText(72, 0, 0, Achievements.achievementMap.get(_name)[0], 24);
        text.color = 0xFFF5BB73;
        text.y = 24 - text.height/2;

        var desc = new FlxText(72, 0, 0, Achievements.achievementMap.get(_name)[1], 16);
        desc.color = 0xFFF5BB73;
        desc.y = 52 - desc.height/2;

        var bgWidth = Std.int(text.width);
        if(desc.width > text.width) { bgWidth = Std.int(desc.width); }

        var bg = new FlxSprite().makeGraphic(76 + bgWidth, 72, 0xCC000000);
        var bgFade = FlxGradient.createGradientFlxSprite(24, 72, [0xCC000000, 0x00000000], 1, 0);
        bgFade.x = bg.width;

        x = -(bg.width + bgFade.width);

        add(bg);
        add(bgFade);
        add(icon);
        add(lock);
        add(text);
        add(desc);

        new FlxTimer().start(0.6, function(t){
            remove(lock);

            add(unlockSplash);
            FlxTween.tween(unlockSplash, {alpha: 0}, 0.175);
            FlxTween.tween(unlockSplash.scale, {x: 1.4, y: 1.4}, 0.175, {onComplete: function(t){
                unlockSplash.destroy();
            }});
        });

        FlxTween.tween(this, {x: 0}, 0.8, {ease: FlxEase.quintOut, onComplete: function(twn:FlxTween){
            FlxTween.tween(this, {x: -(bg.width + bgFade.width)}, 0.8, {ease: FlxEase.quintIn, startDelay: 1.5, onComplete: function(twn:FlxTween){ this.destroy(); }});
        }});

        FlxG.sound.play("assets/sounds/achievement.ogg");

    }
}

//Here are different achievement objects so I can keep certain checks out of random states
class KeySpamCheck extends FlxBasic
{

    public var keyMash:Float = 0;
    public static  final unlockTreshold:Float = 70;
    public static final addAmmount:Float = 10;

    public function new(){
        super();
    }

    override public function update(elapsed){
        super.update(elapsed);

        if(keyMash > 0){
            keyMash -= 1 * (elapsed/(1/60));
        }

        if(FlxG.keys.anyJustPressed([SaveData.binds[0], SaveData.binds[1], SaveData.binds[2]])){
            keyMash += addAmmount;
        }

        if(keyMash >= unlockTreshold){
            //trace("YUH!");
            Achievements.unlock("buttonMash");
            destroy();
        }

        //trace(keyMash);
    }

}