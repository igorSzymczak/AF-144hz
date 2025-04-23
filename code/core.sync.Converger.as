package core.sync
{
   import core.deathLine.DeathLine;
   import core.scene.Game;
   import core.ship.EnemyShip;
   import core.ship.PlayerShip;
   import core.ship.Ship;
   import core.solarSystem.Body;
   import flash.geom.Point;
   import generics.Util;
   import movement.Heading;
   
   public class Converger
   {
      public static var actingUpEnemies: Array = [
         "Aureus Monachus lvl 73", 
         "Aureus Warrior lvl 75",
         "Aureus Sidus Shard 88",
         "Aureus Sidus Shard 80"
      ];

      public static var DT:Number = 33;
      
      public static const PI_DIVIDED_BY_8:Number = 0.39269908169872414;
      
      private const BLIP_OFFSET:Number = 30;
      
      public var course:Heading;
      
      private var target:Heading;
      
      private var error:Point;
      
      private var errorAngle:Number;
      
      private var convergeTime:Number = 1000;
      
      private var convergeStartTime:Number;
      
      private var errorOldTime:Number;
      
      private var ship:Ship;
      
      private var g:Game;
      
      private var angleTargetPos:Point;
      
      private var isFacingTarget:Boolean;
      
      private var nextTurnDirection:int;
      
      private const RIGHT:int = 1;
      
      private const LEFT:int = -1;
      
      private const NONE:int = 0;
      
      public function Converger(param1:Ship, param2:Game)
      {
         course = new Heading();
         error = new Point();
         super();
         this.ship = param1;
         this.g = param2;
         angleTargetPos = null;
         nextTurnDirection = 0;
      }
      
      public function run() : void
      {
         if(course == null || course.time >= g.time - DT)
         {
            return;
         }
         if(ship is EnemyShip)
         {
            aiRemoveError(course);
            updateHeading(course);
            aiAddError(course);
         }
         else
         {
            updateHeading(course);
            if(target != null)
            {
               calculateOffset();
            }
         }
      }
      
      public function calculateOffset() : void
      {
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc10_:* = undefined;
         var _loc11_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:DeathLine = null;
         while(target.time < course.time)
         {
            _loc6_ = target.pos.y;
            _loc8_ = target.pos.x;
            updateHeading(target);
            _loc10_ = g.deathLineManager.lines;
            _loc11_ = int(_loc10_.length);
            _loc7_ = 0;
            while(_loc7_ < _loc11_)
            {
               _loc4_ = _loc10_[_loc7_];
               if(_loc4_.lineIntersection2(course.pos.x,course.pos.y,_loc8_,_loc6_,ship.collisionRadius))
               {
                  target.pos.x = _loc8_;
                  target.pos.y = _loc6_;
                  target.speed.x = 0;
                  target.speed.y = 0;
                  break;
               }
               _loc7_++;
            }
         }
         var _loc1_:Number = target.pos.x - course.pos.x;
         var _loc5_:Number = target.pos.y - course.pos.y;
         var _loc2_:Number = Math.sqrt(_loc1_ * _loc1_ + _loc5_ * _loc5_);
         var _loc3_:Number = Util.angleDifference(target.rotation,course.rotation);
         if(_loc2_ > 30)
         {
            setCourse(target);
            return;
         }
         if(_loc3_ > 0.39269908169872414 || _loc3_ < -0.39269908169872414)
         {
            course.rotation = target.rotation;
            return;
         }
         var _loc9_:Number = 0.4;
         course.speed.x = target.speed.x + _loc9_ * _loc1_;
         course.speed.y = target.speed.y + _loc9_ * _loc5_;
         course.rotation += _loc3_ * 0.05;
         course.rotation = Util.clampRadians(course.rotation);
      }
      
      private function aiAddError(param1:Heading) : void
      {
         if(error.x == 0 && error.y == 0)
         {
            return;
         }
         var _loc2_:Number = g.time;
         var _loc4_:Number = (convergeTime - (_loc2_ - convergeStartTime)) / convergeTime;
         var _loc3_:Number = 3 * _loc4_ * _loc4_ - 2 * _loc4_ * _loc4_ * _loc4_;
         if(_loc4_ > 0)
         {
            param1.pos.x += _loc3_ * error.x;
            param1.pos.y += _loc3_ * error.y;
            param1.rotation += _loc3_ * errorAngle;
            errorOldTime = _loc2_;
         }
         else
         {
            error.x = 0;
            error.y = 0;
            errorOldTime = 0;
         }
      }
      
      private function aiRemoveError(param1:Heading) : void
      {
         if(error.x == 0 && error.y == 0 || errorOldTime == 0)
         {
            return;
         }
         var _loc3_:Number = (convergeTime - (errorOldTime - convergeStartTime)) / convergeTime;
         var _loc2_:Number = 3 * _loc3_ * _loc3_ - 2 * _loc3_ * _loc3_ * _loc3_;
         param1.pos.x -= _loc2_ * error.x;
         param1.pos.y -= _loc2_ * error.y;
         param1.rotation -= _loc2_ * errorAngle;
      }
      
      public function setNextTurnDirection(param1:int) : void
      {
         nextTurnDirection = param1;
      }
      
      public function setConvergeTarget(param1:Heading) : void
      {
         target = param1;
         if(ship is EnemyShip)
         {
            error.x = course.pos.x - target.pos.x;
            error.y = course.pos.y - target.pos.y;
            errorAngle = Util.angleDifference(course.rotation,target.rotation);
            convergeStartTime = g.time;
            course.speed = target.speed;
            course.pos = target.pos;
            course.rotation = target.rotation;
            course.time += Game.dt
            aiAddError(course);
         }
      }
      
      public function clearConvergeTarget() : void
      {
         target = null;
         error.x = 0;
         error.y = 0;
      }
      
      public function setCourse(param1:Heading, param2:Boolean = true) : void
      {
         if(param2)
         {
            fastforwardToServerTime(param1);
         }
         course = param1;
         target = null;
      }
      
      public function setAngleTargetPos(param1:Point) : void
      {
         isFacingTarget = false;
         angleTargetPos = param1;
      }
      
      public function isFacingAngleTarget() : Boolean
      {
         return isFacingTarget;
      }
      
      public function fastforwardToServerTime(param1:Heading) : void
      {
         if(param1 == null)
         {
            return;
         }
         while(param1.time < g.time - 5000)
         {
            updateHeading(param1);
         }
      }
      
      public function updateHeading(param1:Heading) : void
      {
         var shipPos:Point = null;
         var shipRot:Number = NaN;
         var angleToTarget:Number = NaN;
         var angleDiff:Number = NaN;
         var rotationStep:Number = NaN;
         var shouldReverse:Boolean = false;
         var distanceToTarget:Number = NaN;
         var enemyShip:EnemyShip = null;
         var speedX:Number = NaN;
         var speedY:Number = NaN;
         var currentSpeedSq:Number = NaN;
         var adjustedRotation:Number = NaN;
         var acceleration:Number = NaN;
         var maxSpeed:Number = NaN;
         var normX:Number = NaN;
         var normY:Number = NaN;
         var _loc8_:Number = NaN;
         var allBodies:* = undefined;
         var numBodies:int = 0;
         var i:int = 0;
         var body:Body = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var distanceSq:Number = NaN;
         var directionToBody:Number = NaN;
         var gravityForce:Number = NaN;
         var dt:Number = Game.dt;
         var bdt:Number = 33 / dt;
         if(ship is EnemyShip && angleTargetPos != null)
         {
            shipPos = ship.pos;
            shipRot = ship.rotation;
            angleToTarget = Math.atan2(angleTargetPos.y - shipPos.y,angleTargetPos.x - shipPos.x);
            angleDiff = Util.angleDifference(shipRot,angleToTarget + 3.141592653589793);
            rotationStep = 0.001 * ship.engine.rotationSpeed * dt;
            shouldReverse = angleDiff > 0.5 * 3.141592653589793 || angleDiff < -0.5 * 3.141592653589793;
            distanceToTarget = (angleTargetPos.y - shipPos.y) * (angleTargetPos.y - shipPos.y) + (angleTargetPos.x - shipPos.x) * (angleTargetPos.x - shipPos.x);
            enemyShip = ship as EnemyShip;
            if(distanceToTarget < 2500 && enemyShip.meleeCharge)
            {
               isFacingTarget = false;
            }
            else if(!shouldReverse)
            {
               param1.accelerate = true;
               param1.roll = false;
               if(angleDiff > 0 && angleDiff < 3.141592653589793 - rotationStep)
               {
                  param1.rotation += rotationStep;
                  param1.rotation = Util.clampRadians(param1.rotation);
                  isFacingTarget = false;
               }
               else if(angleDiff <= 0 && angleDiff > -3.141592653589793 + rotationStep)
               {
                  param1.rotation -= rotationStep;
                  param1.rotation = Util.clampRadians(param1.rotation);
                  isFacingTarget = false;
               }
            }
            else if(angleDiff > 0 && angleDiff < 3.141592653589793 - rotationStep)
            {
               param1.rotation += rotationStep;
               param1.rotation = Util.clampRadians(param1.rotation);
               isFacingTarget = false;
            }
            else if(angleDiff <= 0 && angleDiff > -3.141592653589793 + rotationStep)
            {
               param1.rotation -= rotationStep;
               param1.rotation = Util.clampRadians(param1.rotation);
               isFacingTarget = false;
            }
            else
            {
               isFacingTarget = true;
               param1.rotation = Util.clampRadians(angleToTarget);
            }
         }
         else 
         {
            // Obliczanie obrotu gracza
            if(param1.rotateLeft)
            {
               param1.rotation -= 0.001 * ship.engine.rotationSpeed * dt;
               param1.rotation = Util.clampRadians(param1.rotation);
            }
            if(param1.rotateRight)
            {
               param1.rotation += 0.001 * ship.engine.rotationSpeed * dt;
               param1.rotation = Util.clampRadians(param1.rotation);
            }
         }
         if(param1.accelerate)
         {
            speedX = param1.speed.x;
            speedY = param1.speed.y;
            currentSpeedSq = speedX * speedX + speedY * speedY;
            adjustedRotation = param1.rotation + ship.rollDir * ship.rollMod * ship.rollPassive;
            acceleration = ship.engine.acceleration * 0.5 * Math.pow(dt,2) * bdt;
            if(ship is EnemyShip)
            {
               speedX += Math.cos(adjustedRotation) * acceleration;
               speedY += Math.sin(adjustedRotation) * acceleration;
            }
            else
            {
               speedX += Math.cos(param1.rotation) * acceleration;
               speedY += Math.sin(param1.rotation) * acceleration;
            }
            maxSpeed = ship.engine.speed;
            if(ship.usingBoost)
            {
               maxSpeed = 0.01 * maxSpeed * (100 + ship.boostBonus);
            }
            else if(currentSpeedSq > maxSpeed * maxSpeed)
            {
               maxSpeed = Math.sqrt(currentSpeedSq);
            }
            if(ship.slowDownEndtime > g.time)
            {
               maxSpeed = ship.engine.speed * (1 - ship.slowDown);
            }
            currentSpeedSq = speedX * speedX + speedY * speedY;
            if(currentSpeedSq <= maxSpeed * maxSpeed)
            {
               param1.speed.x = speedX;
               param1.speed.y = speedY;
            }
            else
            {
               normX = Math.sqrt(currentSpeedSq);
               normY = speedX / normX * maxSpeed;
               _loc8_ = speedY / normX * maxSpeed;
               param1.speed.x = normY;
               param1.speed.y = _loc8_;
            }
         }
         else if(param1.deaccelerate)
         {
            param1.speed.x -= 0.1 * param1.speed.x / bdt;
            param1.speed.y -= 0.1 * param1.speed.y / bdt;
         }
         else if(ship is EnemyShip && param1.roll)
         {
            speedX = param1.speed.x;
            speedY = param1.speed.y;
            currentSpeedSq = speedX * speedX + speedY * speedY;
            if(currentSpeedSq <= ship.rollSpeed * ship.rollSpeed)
            {
               adjustedRotation = param1.rotation + ship.rollDir * ship.rollMod * 3.141592653589793 * 0.5;
               acceleration = ship.engine.acceleration * 0.5 * Math.pow(dt,2) * bdt;
               speedX += Math.cos(adjustedRotation) * acceleration;
               speedY += Math.sin(adjustedRotation) * acceleration;
               currentSpeedSq = speedX * speedX + speedY * speedY;
               if(currentSpeedSq <= ship.rollSpeed * ship.rollSpeed)
               {
                  param1.speed.x = speedX;
                  param1.speed.y = speedY;
               }
               else
               {
                  normX = Math.sqrt(currentSpeedSq);
                  normY = speedX / normX * ship.rollSpeed;
                  _loc8_ = speedY / normX * ship.rollSpeed;
                  param1.speed.x = normY;
                  param1.speed.y = _loc8_;
               }
            }
            else
            {
               param1.speed.x -= 0.02 * param1.speed.x;
               param1.speed.y -= 0.02 * param1.speed.y;
            }
         }
         if(ship is EnemyShip && !param1.accelerate)
         {
            param1.speed.x = 0.9 * param1.speed.x;
            param1.speed.y = 0.9 * param1.speed.y;
         }
         else
         {
            param1.speed.x -= 0.009 * param1.speed.x / bdt;
            param1.speed.y -= 0.009 * param1.speed.y / bdt;
         }
         if(ship is PlayerShip)
         {
            allBodies = g.bodyManager.bodies;
            numBodies = int(allBodies.length);
            i = 0;
            while(i < numBodies)
            {
               body = allBodies[i];
               if(body.type == "sun")
               {
                  dx = body.pos.x - param1.pos.x;
                  dy = body.pos.y - param1.pos.y;
                  distanceSq = dx * dx + dy * dy;
                  if(distanceSq <= body.gravityDistance)
                  {
                     if(distanceSq != 0)
                     {
                        if(distanceSq < body.gravityMin)
                        {
                           distanceSq = body.gravityMin;
                        }
                        directionToBody = Math.atan2(dy,dx);
                        directionToBody = Util.clampRadians(directionToBody);
                        gravityForce = body.gravityForce / distanceSq * dt * 0.001;
                        param1.speed.x += Math.cos(directionToBody) * gravityForce;
                        param1.speed.y += Math.sin(directionToBody) * gravityForce;
                     }
                  }
               }
               i++;
            }
         }

         var newPoint:Point = new Point();
         newPoint.x = param1.pos.x + param1.speed.x * dt * 0.001;
         newPoint.y = param1.pos.y + param1.speed.y * dt * 0.001;

         param1.pos = Point.interpolate(param1.pos, newPoint, dt * 0.001);

         param1.time += dt;
      }
   }
}

