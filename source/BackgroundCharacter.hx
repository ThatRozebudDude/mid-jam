package;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class BackgroundCharacter extends FlxSprite
{
    public static var totalBGCharacters:Array<BackgroundCharacter> = [];

    public var truePos:FlxPoint;
    public var right:Bool = false;
    public var cameoID:Int = -1;

    var moveSpeed:Float = 1;

    var bopTween:FlxTween;

    override public function new(_path:String, _right:Bool = false, _cameoID:Int = -1){
        super(0, 286);

        loadGraphic(_path, false);

        y -= height;

        cameoID = _cameoID;

        right = _right;
        flipX = right;
        if(right){ x = -width; }
        else{ x = 576; }

        truePos = new FlxPoint(x, y);

        bopTween = FlxTween.tween(this, {}, 0);

        totalBGCharacters.push(this);
    }
    
    override public function update(elapsed){
        super.update(elapsed);

        if(right){
            x += moveSpeed * (elapsed/(1/60));
            if(x > 576){ destroy(); } 
        }
        else{
            x -= moveSpeed * (elapsed/(1/60));
            if(x < -width){ destroy(); } 
        }
    }

    public function bop(){
        bopTween.cancel();
        y = truePos.y + FlxG.random.float(4, 8);
        FlxTween.tween(this, {y: truePos.y}, (Conductor.eighthNoteTime / 1000) * FlxG.random.float(0.65, 1.4));
    }

    override public function destroy(){
        totalBGCharacters.remove(this);
        super.destroy();
    }

}