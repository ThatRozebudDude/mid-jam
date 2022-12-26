package;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class NoteHitGlow extends FlxSprite
{

    override public function new(_x:Float, _y:Float, _noteType:String, ?_time:Float = 0.1, ?_maxSize:Float = 1.4, ?_startAlpha:Float = 0.5){

        super(_x, _y);

        loadGraphic("assets/images/notes/" + _noteType + "/glow.png");

        offset.x += width/2;
        offset.y += height/2;

        alpha = _startAlpha;

        FlxTween.tween(this, {alpha: 0}, _time);
        FlxTween.tween(scale, {x: _maxSize, y: _maxSize}, _time, {onComplete: function(t){
            this.destroy();
        }});

    }

}