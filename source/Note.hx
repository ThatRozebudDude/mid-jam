package;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Note extends FlxSprite
{

    public var hitTime:Float = 0;
    public var lane:Int = 0;
    public var type:String = "";
    public var inHitWindow = false;
    public var missed = false;
    public var missedAnim = false;
    public var hit = false;

    final timeOffset = 0;
    final missFinalAlpha = 0;

    override public function new(_hitTime:Float, _lane:Int, _type:String = ""){

        super();

        hitTime = _hitTime + timeOffset;
        lane = _lane;
        type = _type;

        loadGraphic("assets/images/notes/" + type + "/drink.png");

        offset.x += width/2;
        offset.y += height/2;

    }
    
    override public function update(elapsed){
        super.update(elapsed);

        if(hitTime < Conductor.audioReference.time - Conductor.hitWindow/2){
            missed =  true;
            FlxTween.tween(this, {alpha: missFinalAlpha}, Conductor.sixteenthNoteTime / 1500);
        }
    }

}