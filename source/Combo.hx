package;

import openfl.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

using StringTools;

class Combo extends FlxSpriteGroup
{

    public var combo:Int = 0;
    public var maxCombo:Int = 0;
    public var totalHit:Int = 0;
    public var totalMissed:Int = 0;

    public var silent:Bool = false;

    final visibleCount = 10;

	var numbers:Array<FlxSprite> = new Array<FlxSprite>();
    var comboText:FlxSprite;

    var comboTextPath:String = "assets/images/hud/combo.png";
    var numbersPath:String = "assets/images/hud/comboNumbers.png";

	public function new(_x:Float, _y:Float)
	{
		super(_x, _y);

        if(Assets.exists("assets/images/stages/" + PlayState.stage + "/hudSkin/combo.png")){
            comboTextPath = "assets/images/stages/" + PlayState.stage + "/hudSkin/combo.png";
        }
        if(Assets.exists("assets/images/stages/" + PlayState.stage + "/hudSkin/comboNumbers.png")){
            numbersPath = "assets/images/stages/" + PlayState.stage + "/hudSkin/comboNumbers.png";
        }

        comboText = new FlxSprite().loadGraphic(comboTextPath);
        add(comboText);

        updateComboDisplay();
	}

	public function comboInc():Void{

        combo++;
        totalHit++;
        if(combo > maxCombo){
            maxCombo = combo;
        }

        updateComboDisplay();

	}

    function updateComboDisplay() {
        
        if(!silent){

            for(x in numbers){ 
                x.destroy(); 
            }
            numbers = new Array<FlxSprite>();
    
            if(combo >= visibleCount){
                numbers.push(new FlxSprite()); // OKAY SO, if you grab multiple glasses at once and i dont do this the first number starts flying away
                var comboString:String = Std.string(combo);
                for(i in 0...comboString.length){
                    var digit = new FlxSprite(50*i, (-5*i) + 8).loadGraphic(numbersPath, true, 62, 103);
                    digit.animation.add("digit", [Std.parseInt(comboString.charAt(i))], 0, false);
                    digit.animation.play("digit");
                    add(digit);
                    numbers.push(digit);
    
                    digit.scale.set(1.2, 1.2);
                    FlxTween.tween(digit.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.quartOut});
                }
                comboText.visible = true;
                comboText.x = (comboString.length) * 50 + 15;
                if(combo == visibleCount){
                    FlxG.sound.play("assets/sounds/cheer.ogg");
                    comboText.scale.set(1.2, 1.2);
                    FlxTween.cancelTweensOf(comboText);
                    FlxTween.tween(comboText.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.quartOut});
                }
            }
            else{
                comboText.visible = false;
            }

        }     

    }

    public function breakCombo() {

        if(!silent){

            if(combo >= visibleCount){
                var comboString:String = Std.string(combo);
                for(i in 0...comboString.length){
                    var digit = new FlxSprite(numbers[i+1].x-8, numbers[i+1].y-8).loadGraphic(numbersPath, true, 62, 103);
                    digit.animation.add("digit", [Std.parseInt(comboString.charAt(i))], 0, false);
                    digit.animation.play("digit");
                    add(digit);
    
                    digit.acceleration.y = FlxG.random.float(300, 400);
                    digit.velocity.y -= FlxG.random.float(40, 120);
                    digit.velocity.x = FlxG.random.float(-24, 24);
                    digit.angularVelocity = digit.velocity.x;
    
                    FlxTween.tween(digit, {alpha: 0}, 0.5, {
                        onComplete: function(tween:FlxTween){
                            digit.destroy();
                        },
                        startDelay: Conductor.sixteenthNoteTime/2000
                    });
                }
    
                var comboFlyAway = new FlxSprite(comboText.x-8, comboText.y-8).loadGraphic(comboTextPath);
                add(comboFlyAway);
    
                comboFlyAway.acceleration.y = FlxG.random.float(300, 400);
                comboFlyAway.velocity.y -= FlxG.random.float(40, 120);
                comboFlyAway.velocity.x = FlxG.random.float(-24, 24);
                comboFlyAway.angularVelocity = comboFlyAway.velocity.x;
    
                FlxTween.tween(comboFlyAway, {alpha: 0}, 0.5, {
                    onComplete: function(tween:FlxTween){
                        comboFlyAway.destroy();
                    },
                    startDelay: Conductor.sixteenthNoteTime/2000
                });
    
                FlxG.sound.play("assets/sounds/crowdGasp.ogg");
            }

        }
        
        combo = 0;
        updateComboDisplay();
        
    }
}
