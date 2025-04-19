package core.states.AIStates
{
   import core.projectile.Projectile;
   import core.scene.Game;
   import core.ship.Ship;
   import core.states.IState;
   import core.states.StateMachine;
   import core.unit.Unit;
   import flash.geom.Point;
   import generics.Util;
   
   public class MissileStuck implements IState
   {
      public static var DT:Number = 7;

      private var m:Game;
      
      private var p:Projectile;
      
      private var sm:StateMachine;
      
      private var isEnemy:Boolean;
      
      private var stuckShip:Ship = null;
      
      private var stuckUnit:Unit = null;
      
      private var stuckOffset:Point;
      
      private var stuckAngle:Number;
      
      private var startAngle:Number;
      
      private var pos:Point;
      
      public function MissileStuck(param1:Game, param2:Projectile)
      {
         var _loc3_:Number = NaN;
         super();
         this.m = param1;
         this.p = param2;
         pos = param2.course.pos;
         stuckUnit = param2.target;
         stuckAngle = stuckUnit.rotation;
         var _loc4_:Point = new Point(pos.x - stuckUnit.pos.x,pos.y - stuckUnit.pos.y);
         var _loc5_:Number;
         if((_loc5_ = Number(_loc4_.length.valueOf())) > stuckUnit.radius * 0.8)
         {
            stuckOffset = new Point(stuckUnit.radius * 0.8 * _loc4_.x / _loc5_,stuckUnit.radius * 0.8 * _loc4_.y / _loc5_);
         }
         else
         {
            stuckOffset = _loc4_;
         }
         startAngle = param2.course.rotation;
         param2.course.rotation = startAngle;
         param2.course.speed.x = 0;
         param2.course.speed.y = 0;
         param2.acceleration = 0;
         _loc4_ = pos.clone();
         _loc3_ = Util.clampRadians(stuckUnit.rotation - stuckAngle);
         param2.course.rotation = startAngle + _loc3_;
         pos.x = stuckUnit.pos.x + Math.cos(_loc3_) * stuckOffset.x - Math.sin(_loc3_) * stuckOffset.y;
         pos.y = stuckUnit.pos.y + Math.sin(_loc3_) * stuckOffset.x + Math.cos(_loc3_) * stuckOffset.y;
         param2.error = new Point(_loc4_.x - pos.x,_loc4_.y - pos.y);
         param2.convergenceCounter = 0;
         param2.convergenceTime = 1000 / DT;
         if(param2.isHeal || param2.unit.factions.length > 0)
         {
            this.isEnemy = false;
         }
         else
         {
            this.isEnemy = param2.unit.type == "enemyShip" || param2.unit.type == "turret";
         }
      }
      
      public function enter() : void
      {
         p.ttl = p.ttlMax + p.aiStuckDuration * 1000;
      }
      
      public function execute() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!p.aiStuck)
         {
            p.target = null;
            p.ttl = p.ttlMax;
            p.numberOfHits = 1;
            p.acceleration = p.weapon.acceleration;
            sm.changeState(new Missile(m,p));
            return;
         }
         if(stuckUnit == null || !stuckUnit.alive)
         {
            return;
         }
         _loc2_ = Util.clampRadians(stuckUnit.rotation - stuckAngle);
         p.course.rotation = startAngle + _loc2_;
         pos.x = stuckUnit.pos.x + Math.cos(_loc2_) * stuckOffset.x - Math.sin(_loc2_) * stuckOffset.y;
         pos.y = stuckUnit.pos.y + Math.sin(_loc2_) * stuckOffset.x + Math.cos(_loc2_) * stuckOffset.y;
         _loc1_ = DT;
         _loc3_ = (p.convergenceTime - p.convergenceCounter) / p.convergenceTime;
         if(_loc3_ <= 0)
         {
            p.error = null;
         }
         if(p.error != null)
         {
            p.convergenceCounter++;
            _loc3_ = (p.convergenceTime - p.convergenceCounter) / p.convergenceTime;
            pos.x += p.error.x * _loc3_;
            pos.y += p.error.y * _loc3_;
         }
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
         return "MissileStuck";
      }
   }
}

