package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

using StringTools;

class Health extends FlxSpriteGroup
{

    public var curHealth:Int;
    public var maxHealth:Int;

	var hpIcons:Array<FlxSprite> = new Array<FlxSprite>();

	public function new(_x:Float, _y:Float, _maxHealth:Int)
	{
        super(_x, _y);

        maxHealth = _maxHealth;
        curHealth = maxHealth;

        for(i in 0...maxHealth){
            var icon = new FlxSprite(i * 37, 0).loadGraphic("assets/images/healthIndicator.png", true, 35, 35);
            icon.animation.add("full", [0], 0, false);
            icon.animation.add("empty", [1], 0, false);
            icon.animation.play("full");
            hpIcons.push(icon);
            add(icon);
        }
	}

	public function hpDec():Void{

        curHealth--;
        updateHpIcons();

        var starFlyAway = new FlxSprite(hpIcons[curHealth].x - 8, hpIcons[curHealth].y - 8).loadGraphic("assets/images/healthStar.png");
        add(starFlyAway);

        starFlyAway.acceleration.y = FlxG.random.float(360, 430);
        starFlyAway.velocity.y -= FlxG.random.float(80, 120);
        starFlyAway.velocity.x = FlxG.random.float(-24, 24);
        starFlyAway.angularVelocity = starFlyAway.velocity.x;

        FlxTween.tween(starFlyAway, {alpha: 0}, 0.3, {
            onComplete: function(tween:FlxTween){
                starFlyAway.destroy();
            },
            startDelay: Conductor.eighthNoteTime/1000
        });

	}

    public function hide(){
        for(x in hpIcons){ 
            x.visible = false; 
        }
    }

    public function show(){
        for(x in hpIcons){ 
            x.visible = true; 
        }
    }
    
    public function updateHpIcons(){
        for(i in 0...maxHealth)
            if(i >= curHealth){
                hpIcons[i].animation.play("empty");

            }
            else{
                hpIcons[i].animation.play("full");
            }
    }
}
