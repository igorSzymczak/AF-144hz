package core.states.AIStates
{
   import core.GameObject;
   import core.scene.Game;
   import core.ship.EnemyShip;
   import core.spawner.Spawner;
   import core.states.IState;
   import core.states.StateMachine;
   import flash.geom.Point;
   import generics.Util;
   import movement.Heading;
   
   public class AIReturnOrbit implements IState
   {
      private var g:Game;
      
      private var s:EnemyShip;
      
      private var sm:StateMachine;
      
      private var target:Point;
      
      public function AIReturnOrbit(param1:Game, param2:EnemyShip, param3:Number, param4:Number, param5:Heading, param6:int)
      {
         super();
         param2.target = null;
         param2.ellipseAlpha = Util.clampRadians(param3);
         param2.orbitStartTime = param4;
         if(param2.getConverger() == null)
         {
            param1.client.errorLog.writeError("converger == null in AiReturn, enemy: " + param2.name,"","",{});
            return;
         }
         if(!param2.aiCloak)
         {
            param2.setConvergeTarget(param5);
         }
         param2.setNextTurnDirection(param6);
         this.g = param1;
         this.s = param2;
         if(param2.factions.length == 1 && param2.factions[0] == "tempFaction")
         {
            param2.factions.splice(0,1);
         }
      }
      
      public function enter() : void
      {
         if (s.name = Game.debuggedEnemyName)
         {
         MessageLog.write(s.name + " STARTED ReturnOrbit, speed =" + Math.sqrt(Math.pow(s.course.speed.x, 2) + Math.pow(s.course.speed.y, 2)) + "px / sec");
         }
         var _loc2_:Number = s.orbitRadius * s.ellipseFactor * Math.cos(s.orbitAngle);
         var _loc4_:Number = s.orbitRadius * Math.sin(s.orbitAngle);
         var _loc1_:Spawner = s.spawner;
         if(_loc1_ == null)
         {
            g.client.errorLog.writeError("Spawner == null in AiReturn, enemy: " + s.name,"","",{});
            return;
         }
         var _loc5_:GameObject = _loc1_.parentObj;
         if(_loc5_ == null)
         {
            g.client.errorLog.writeError("Parent Obj == null in AiReturn, enemy: " + s.name,"","",{});
            return;
         }
         if(_loc5_.pos == null)
         {
            g.client.errorLog.writeError("Parent Obj pos == null in AiReturn, enemy: " + s.name,"","",{});
            return;
         }
         var _loc3_:Point = new Point(_loc5_.pos.x,_loc5_.pos.y);
         target = new Point();
         target.x = _loc2_ * Math.cos(s.ellipseAlpha) - _loc4_ * Math.sin(s.ellipseAlpha) + _loc3_.x;
         target.y = _loc2_ * Math.sin(s.ellipseAlpha) + _loc4_ * Math.cos(s.ellipseAlpha) + _loc3_.y;
         s.accelerate = false;
         s.setAngleTargetPos(target);
         s.target = null;
         s.stopShooting();
         if(s.course == null)
         {
            g.client.errorLog.writeError("course == null in AiReturn, enemy: " + s.name,"","",{});
            return;
         }
         s.course.speed.x = s.course.speed.y = 0;
      }
      
      public function execute() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(s.isFacingAngleTarget())
         {
            s.accelerate = true;
         }
         if(!s.aiCloak)
         {
            s.runConverger();
         }
         if(g.time > s.orbitStartTime)
         {
            _loc1_ = s.pos.x - target.x;
            _loc2_ = s.pos.y - target.y;
            if(_loc1_ * _loc1_ + _loc2_ * _loc2_ < 400 || g.time > s.orbitStartTime + 2000)
            {
               s.stateMachine.changeState(new AIOrbit(g,s,true));
               return;
            }
         }
         if(!s.isAddedToCanvas)
         {
            return;
         }
         s.regenerateShield();
         s.updateHealthBars();
         s.engine.update();
         s.updateWeapons();
      }
      
      public function exit() : void
      {
      }
      
      public function set stateMachine(param1:StateMachine) : void
      {
         this.sm = param1;
      }
      
      public function get type() : String
      {
         return "AIReturn";
      }
   }
}

