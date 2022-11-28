package;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Note extends FlxSprite
{

    public var hitTime:Float = 0;
    public var type:String = "";
    public var inHitWindow = false;
    public var missed = false;
    public var missedAnim = false;
    public var hit = false;

    final timeOffset = 80;
    final missFinalAlpha = 0;

    override public function new(_hitTime:Float, _type:String = ""){

        super();

        hitTime = _hitTime + timeOffset;
        type = _type;

        switch(_type){
            case "red":
                loadGraphic("assets/images/drinkRed.png");

            case "blue":
                loadGraphic("assets/images/drinkBlue.png");

            case "green":
                loadGraphic("assets/images/drinkGreen.png");

            case "cactus":
                loadGraphic("assets/images/temp/cactus.png");

            default:
                loadGraphic("assets/images/drinkRed.png");
        }

        offset.x += width/2;
        offset.y += height/2;

    }
    
    override public function update(elapsed){
        super.update(elapsed);

        if(hitTime < Conductor.audioReference.time - Conductor.hitWindow/2){
            missed =  true;
            FlxTween.tween(this, {alpha: missFinalAlpha}, Conductor.sixteenthNoteTime / 1000);
        }
    }

}