package core.states.AIStates
{
   import core.particle.Emitter;
   import core.particle.EmitterFactory;
   import core.scene.Game;
   import core.ship.EnemyShip;
   import core.states.IState;
   import core.states.StateMachine;
   import core.unit.Unit;
   import generics.Util;
   import core.hud.components.chat.MessageLog;
   
   public class AITeleport implements IState
   {
      private var g:Game;
      
      private var s:EnemyShip;
      
      private var sm:StateMachine;
      
      private var target:Unit;
      
      private var targetX:Number;
      
      private var targetY:Number;
      
      private var duration:Number;
      
      private var emitters1:Vector.<Emitter>;
      
      private var emitters2:Vector.<Emitter>;
      
      public function AITeleport(param1:Game, param2:EnemyShip, param3:Unit, param4:int = 1, param5:Number = 0, param6:Number = 0)
      {
         super();
         this.g = param1;
         this.s = param2;
         this.target = param3;
         this.targetX = param5;
         this.targetY = param6;
         this.duration = param4;
      }
      
      public function enter() : void
      {
         if (s.name = Game.debuggedEnemyName)
         {
         MessageLog.write(s.name + " STARTED Teleport, speed =" + Math.sqrt(Math.pow(s.course.speed.x, 2) + Math.pow(s.course.speed.y, 2)) + "px / sec");
         }
         s.invulnerable = true;
         emitters1 = EmitterFactory.create("UZ3AiNHAEUmBD4ev0Itu0A",g,s.pos.x,s.pos.y,s,true);
         emitters2 = EmitterFactory.create("5BSaDIEYj0mEuVkMVp1JGw",g,targetX,targetY,null,true);
      }
      
      public function execute() : void
      {
         if(target == null && s.target == null && g.time > s.orbitStartTime && g.time - 2000 < s.orbitStartTime)
         {
            // auerus warrioir is not doing that
            s.stateMachine.changeState(new AIOrbit(g,s,true));
            s.course.pos.x = targetX;
            s.course.pos.y = targetY;
            s.clearConvergeTarget();

         }
      }
      
      public function exit() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         for each(var _loc2_ in emitters1)
         {
            _loc2_.killEmitter();
         }
         for each(_loc2_ in emitters2)
         {
            _loc2_.killEmitter();
         }
         if(target != null)
         {
            _loc1_ = target.pos.x - targetX;
            _loc3_ = target.pos.y - targetY;
            if(_loc3_ != 0 || _loc1_ != 0)
            {
               s.rotation = Util.clampRadians(Math.atan2(_loc3_,_loc1_));
            }
         }
         else if(s.target != null)
         {
            _loc1_ = s.target.pos.x - targetX;
            _loc3_ = s.target.pos.y - targetY;
            if(_loc3_ != 0 || _loc1_ != 0)
            {
               s.rotation = Util.clampRadians(Math.atan2(_loc3_,_loc1_) - 3.141592653589793);
            }
            s.target = null;
         }
         s.course.pos.x = targetX;
         s.course.pos.y = targetY;
         s.clearConvergeTarget();
         s.invulnerable = false;
         if(s.shieldRegenCounter > -3000)
         {
            s.shieldRegenCounter = -3000;
         }
        //  MessageLog.write(s.name + " ENDED a tp, with a speed of " + Math.sqrt(Math.pow(s.course.speed.x, 2) + Math.pow(s.course.speed.y, 2)) + "px / tick");
      }
      
      public function set stateMachine(param1:StateMachine) : void
      {
         this.sm = param1;
      }
      
      public function get type() : String
      {
         return "AITeleport";
      }
   }
}

