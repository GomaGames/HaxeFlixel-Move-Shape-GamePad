package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.addons.display.shapes.FlxShapeCross;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxMath;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.LogitechButtonID;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
  private static inline var shape_size : Float = 50;
  private var cross_shape : FlxShapeCross;
  private var shape_velocity : { x : Float, y : Float, rotation : Float };
  private var game_pad:FlxGamepad;

  /**
   * Function that is called up when to state is created to set it up.
   */
  override public function create():Void
  {
    // Hide the mouse
    FlxG.mouse.visible = false;

    // initialize shape velocity
    shape_velocity = { x : 0, y : 0, rotation : 0 };

    // setup and create shape
    var line_style:LineStyle = {
      color: FlxColor.CHARTREUSE,
      thickness: 2,
      pixelHinting: true
    };
    var fill_style:FillStyle = {
      hasFill: true,
      color: FlxColor.AZURE,
      alpha: 1.0
    };
    cross_shape = new FlxShapeCross(
      ( FlxG.width - shape_size ) / 2, ( FlxG.height - shape_size ) / 2,
      shape_size, shape_size/3,
      shape_size, shape_size/3,
      0.5, 0.5,
      line_style,
      fill_style
    );

    // smoothen out with anti-aliasing when rotated (affects performance)
    cross_shape.antialiasing = true;

    // add the shape to this state
    add(cross_shape);

    // call the superclass create() method *required*
    super.create();
  }

  /**
   * Function that is called when this state is destroyed - you might want to
   * consider setting all objects this state uses to null to help garbage collection.
   */
  override public function destroy():Void
  {
    // set sprites to null to help with gc
    cross_shape = null;

    super.destroy();
  }

  /**
   * Function that is called once every frame.
   */
  override public function update():Void
  {

    handleInput();

    handleAnimation();

    super.update();
  }

  private inline function handleInput():Void
  {
    // Important: can be null if there's no active gamepad yet!
    if (game_pad == null) {
      game_pad = FlxG.gamepads.lastActive;
    }else{
      updateGamepadMovement();
    }

  }

  private inline function handleAnimation():Void
  {
    // update the shape's position
    cross_shape.x += shape_velocity.x;
    cross_shape.y += shape_velocity.y;

    // update the shape's rotation
    cross_shape.angle += shape_velocity.rotation;
  }

  private inline function updateGamepadMovement():Void
  {
    // Vertical Movement
    if( game_pad.getAxis(LogitechButtonID.LEFT_ANALOGUE_Y) != 0 ){
      shape_velocity.y = game_pad.getYAxis(LogitechButtonID.LEFT_ANALOGUE_Y) * Reg.MOVE_SPEED;
    }else{
      // stop moving vertically
      shape_velocity.y *= .9; // set to = 0; to stop hard
    }

    // Horizontal Movement
    if( game_pad.getAxis(LogitechButtonID.LEFT_ANALOGUE_X) != 0 ){
      shape_velocity.x = game_pad.getXAxis(LogitechButtonID.LEFT_ANALOGUE_X) * Reg.MOVE_SPEED;
    }else{
      // stop moving horizontally
      shape_velocity.x *= .9; // set to = 0; to stop hard
    }

    /*
      Rotation Control
      (this registered as X axis for Logitech)
     */
    if ( game_pad.getAxis( LogitechButtonID.RIGHT_ANALOGUE_X ) != 0 ){

      // rotate shape
      shape_velocity.rotation = Reg.ROTATION_SPEED * game_pad.getXAxis( LogitechButtonID.RIGHT_ANALOGUE_X );

    }else{

      // stop rotating
      shape_velocity.rotation *= .9; // set to = 0; to stop hard

    }


    /*
      Test button presses
    */
    if (game_pad.pressed(LogitechButtonID.ONE)) {
      trace("The X button of the Logitech controller is pressed.");
    }

    if (game_pad.pressed(LogitechButtonID.TWO)) {
      trace("The A button of the Logitech controller is pressed.");
    }

    if (game_pad.pressed(LogitechButtonID.THREE)) {
      trace("The B button of the Logitech controller is pressed.");
    }

    if (game_pad.pressed(LogitechButtonID.FOUR)) {
      trace("The Y button of the Logitech controller is pressed.");
    }

  }
}
