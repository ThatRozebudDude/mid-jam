package;

import transition.*;
import transition.data.*;

#if cpp
import cpp.vm.Gc;
#end
import openfl.system.System;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;

class UIStateExt extends FlxUIState
{
	private var useDefaultTransIn:Bool = true;
	private var useDefaultTransOut:Bool = true;

	public static var defaultTransIn:Class<Dynamic>;
	public static var defaultTransInArgs:Array<Dynamic>;
	public static var defaultTransOut:Class<Dynamic>;
	public static var defaultTransOutArgs:Array<Dynamic>;

	private var customTransIn:BasicTransition = null;
	private var customTransOut:BasicTransition = null;

	override function create()
	{
		if(customTransIn != null){
			CustomTransition.transition(customTransIn, null);
		}
		else if(useDefaultTransIn)
			CustomTransition.transition(Type.createInstance(defaultTransIn, defaultTransInArgs), null);
		super.create();
	}

	public function switchState(_state:FlxState){
		if(customTransOut != null){
			CustomTransition.transition(customTransOut, _state);
		}
		else if(useDefaultTransOut){
			CustomTransition.transition(Type.createInstance(defaultTransOut, defaultTransOutArgs), _state);
			return;
		}
		else{
			FlxG.switchState(_state);
			#if cpp
			System.gc();
			#end
			return;
		}
	}

	public function resetState() {
		switchState(Type.createInstance(Type.getClass(this), []));
	}

}
