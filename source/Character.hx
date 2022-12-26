package;

import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Character extends FlxSprite
{

    var animTimer:Float = 0;

    var shakeIntensity:Float = 0;
    var shakeIntensityTween:FlxTween;

    var bounceTween:FlxTween;

    public var child:Character;

    var bopTween:FlxTween;
    public var truePos:FlxPoint;

    public var drunk:Bool = false;

    override public function new(_x:Float, _y:Float, _path:String){
        super(_x, _y);

        truePos = new FlxPoint(_x, _y);

        var graphic:FlxGraphic = FlxG.bitmap.add(_path);
        var graphicWidth:Int = Std.int(graphic.width/4);

        loadGraphic(graphic, true, graphicWidth, graphic.height);
        animation.add("idle", [0], 0, false);
        animation.add("miss", [1], 0, false);
        animation.add("drink", [2], 0, false);
        animation.add("drunk", [3], 0, false);
        idle();

        shakeIntensityTween = FlxTween.tween(this, {}, 0);
        bopTween = FlxTween.tween(this, {}, 0);
        bounceTween = FlxTween.tween(this, {}, 0);

    }
    
    override public function update(elapsed){
        super.update(elapsed);

        animTimer += elapsed;
        if((animation.curAnim.name == "miss" || animation.curAnim.name == "drink") && animTimer > Conductor.quarterNoteTime/1000){
            idle();
        }

        if(shakeIntensity == 0) {offset.x = 0;}
        else {offset.x = FlxG.random.float(-shakeIntensity, shakeIntensity);}
    }

    public function idle(){
        animTimer = 0;
        
        if(drunk){ animation.play("drunk"); }
        else{ animation.play("idle"); }
        

        if(child != null){
            child.idle();
        }
    }

    public function miss(_intensity:Float = 6){
        animTimer = 0;
        animation.play("miss");
        shake(_intensity, Conductor.quarterNoteTime / 1000);

        if(child != null){
            child.miss(_intensity/2);
        }
    }

    public function drink(_distance:Float = 10){
        animTimer = 0;
        animation.play("drink");
        bounce(_distance);

        if(child != null){
            child.drink(0);
        }
    }

    public function shake(_intensity:Float, _time:Float){
        shakeIntensityTween.cancel();
        shakeIntensity = _intensity;
        shakeIntensityTween = FlxTween.tween(this, {shakeIntensity: 0}, _time);
    }

    public function bounce(_distance:Float){
        bounceTween.cancel();
        offset.y = _distance;
        bounceTween = FlxTween.tween(this.offset, {y: 0}, (Conductor.eighthNoteTime / 1000));
    }

    public function bop(_distance:Float = 5){
        bopTween.cancel();
        y = truePos.y + _distance;
        FlxTween.tween(this, {y: truePos.y}, (Conductor.eighthNoteTime / 1000) * FlxG.random.float(0.7, 1.1));

        if(child != null){
            child.bop(_distance/3);
        }
    }

}