package core.states.AIStates
{
   import core.scene.Game;
   import core.ship.EnemyShip;
   import core.states.IState;
   import core.states.StateMachine;
   import flash.geom.Point;
   import movement.Heading;
   
   public class AIFlee implements IState
   {
      private var g:Game;
      
      private var s:EnemyShip;
      
      private var sm:StateMachine;
      
      private var startTime:Number;
      
      private var startDelay:Number = 1000;
      
      public function AIFlee(param1:Game, param2:EnemyShip, param3:Point, param4:Heading, param5:int)
      {
         super();
         param2.target = null;
         param2.setAngleTargetPos(param3);
         if(!param2.aiCloak)
         {
            param2.setConvergeTarget(param4);
         }
         param2.setNextTurnDirection(param5);
         this.g = param1;
         this.s = param2;
      }
      
      public function enter() : void
      {
         if (s.name = Game.debuggedEnemyName)
         {
         MessageLog.write(s.name + " STARTED Flee, speed =" + Math.sqrt(Math.pow(s.course.speed.x, 2) + Math.pow(s.course.speed.y, 2)) + "px / sec");
         }
         s.stopShooting();
         s.accelerate = true;
         startTime = g.time;
      }
      
      public function execute() : void
      {
         if(!s.aiCloak)
         {
            s.runConverger();
         }
         s.regenerateShield();
         s.updateHealthBars();
         s.engine.update();
         s.updateWeapons();
      }
      
      public function exit() : void
      {
         s.rollPassive = 0;
         s.rollSpeed = 0;
         s.rollMod = 0;
         s.rollDir = 0;
         s.setAngleTargetPos(null);
      }
      
      public function set stateMachine(param1:StateMachine) : void
      {
         this.sm = param1;
      }
      
      public function get type() : String
      {
         return "AIFlee";
      }
   }
}

