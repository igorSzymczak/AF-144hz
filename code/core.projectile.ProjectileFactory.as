package core.projectile
{
   import core.particle.EmitterFactory;
   import core.player.Player;
   import core.scene.Game;
   import core.ship.EnemyShip;
   import core.ship.PlayerShip;
   import core.states.AIStates.AIStateFactory;
   import core.turret.Turret;
   import core.unit.Unit;
   import core.weapon.Weapon;
   import data.DataLocator;
   import data.IDataManager;
   import flash.geom.Point;
   import generics.Color;
   import movement.Heading;
   import sound.ISound;
   import sound.SoundLocator;
   import textures.TextureLocator;
   
   public class ProjectileFactory
   {
      public function ProjectileFactory()
      {
         super();
      }
      
      public static function create(param1:String, param2:Game, param3:Unit, param4:Weapon, param5:Heading = null) : Projectile
      {
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc13_:ISound = null;
         if(param3 == null)
         {
            return null;
         }
         if(param4 == null)
         {
            return null;
         }
         if(param2.me.ship == null && param4.ttl < 2000)
         {
            return null;
         }
         if(param3.movieClip != param2.camera.focusTarget)
         {
            if(isNaN(param3.pos.x))
            {
               return null;
            }
            if(param5 != null)
            {
               _loc6_ = param2.camera.getCameraCenter().subtract(param5.pos);
            }
            else
            {
               _loc6_ = param2.camera.getCameraCenter().subtract(param3.pos);
            }
            _loc7_ = _loc6_.x * _loc6_.x + _loc6_.y * _loc6_.y;
            _loc10_ = 450;
            if(param4.global && _loc7_ > 10 * 60 * 60 * 1000)
            {
               return null;
            }
            _loc8_ = 0;
            if(param4.type == "instant")
            {
               _loc8_ = param4.range;
            }
            else
            {
               _loc8_ = (Math.abs(param4.speed) + _loc10_) * 0.001 * param4.ttl + 500;
            }
            if(_loc7_ > _loc8_ * _loc8_)
            {
               return null;
            }
         }
         var _loc14_:IDataManager = DataLocator.getService();
         var _loc12_:Object = _loc14_.loadKey("Projectiles",param1);
         var _loc11_:Projectile = param2.projectileManager.getProjectile();
         if(param4.maxProjectiles > 0)
         {
            param4.projectiles.push(_loc11_);
            if(param4.projectiles.length > param4.maxProjectiles)
            {
               param4.projectiles[0].destroy(false);
            }
         }
         _loc11_.name = _loc12_.name;
         _loc11_.useShipSystem = param4.useShipSystem;
         _loc11_.unit = param3;
         if(param3 is EnemyShip || param3 is Turret)
         {
            _loc11_.isEnemy = true;
         }
         else if(param3 is PlayerShip)
         {
            _loc11_.ps = param3 as PlayerShip;
         }
         _loc11_.weapon = param4;
         if(param4.dmg.type == 6)
         {
            _loc11_.isHeal = true;
         }
         else
         {
            _loc11_.isHeal = false;
         }
         _loc11_.debuffType = param4.debuffType;
         _loc11_.collisionRadius = _loc12_.collisionRadius;
         _loc11_.ttl = param4.ttl;
         _loc11_.ttlMax = param4.ttl;
         _loc11_.numberOfHits = param4.numberOfHits;
         _loc11_.speedMax = param4.speed;
         _loc11_.rotationSpeedMax = param4.rotationSpeed;
         _loc11_.acceleration = param4.acceleration;
         _loc11_.dmgRadius = param4.dmgRadius;
         _loc11_.course.speed.x = param3.speed.x;
         _loc11_.course.speed.y = param3.speed.y;
         _loc11_.alive = true;
         _loc11_.randomAngle = param4.randomAngle;
         _loc11_.wave = _loc12_.wave;
         param4.waveDirection = param4.waveDirection == 1 ? -1 : 1;
         _loc11_.waveDirection = param4.waveDirection;
         _loc11_.waveAmplitude = _loc12_.waveAmplitude;
         _loc11_.waveFrequency = _loc12_.waveFrequency;
         _loc11_.boomerangReturnTime = _loc12_.boomerangReturnTime;
         _loc11_.boomerangReturning = false;
         _loc11_.clusterProjectile = _loc12_.clusterProjectile;
         _loc11_.clusterNrOfProjectiles = _loc12_.clusterNrOfProjectiles;
         _loc11_.clusterNrOfSplits = _loc12_.clusterNrOfSplits;
         _loc11_.clusterAngle = _loc12_.clusterAngle;
         _loc11_.aiDelayedAcceleration = _loc12_.aiDelayedAcceleration;
         _loc11_.aiDelayedAccelerationTime = _loc12_.aiDelayedAccelerationTime;
         _loc11_.switchTexturesByObj(_loc12_);
         _loc11_.blendMode = _loc12_.blendMode;
         _loc11_.determinedHue = NaN;
         _loc11_.determinedColor = NaN;
         _loc11_.movieClip.color = 16777215;
         if(param3 is PlayerShip)
         {
            var player:Player = (param3 as PlayerShip).player;
            if(!(player.id != "steam76561199032900322" && player.id != "steam76561198188053594" && player.id != "simple1622136353425"))
            {
               _loc11_.determinedHue = param2.clientDevHueColor;
               _loc11_.determinedColor = Color.HEXHue(65280,_loc11_.determinedHue);
               if("ribbonColor" in _loc12_)
               {
                  _loc12_.ribbonColor = _loc11_.determinedColor;
               }
            }
         }
         if(_loc12_.hasOwnProperty("aiAlwaysExplode"))
         {
            _loc11_.aiAlwaysExplode = _loc12_.aiAlwaysExplode;
         }
         if(_loc12_.ribbonTrail)
         {
            _loc11_.ribbonTrail = param2.ribbonTrailPool.getRibbonTrail();
            _loc11_.hasRibbonTrail = true;
            _loc11_.ribbonTrail.color = _loc12_.ribbonColor;
            _loc11_.ribbonTrail.movingRatio = _loc12_.ribbonSpeed;
            _loc11_.ribbonTrail.alphaRatio = _loc12_.ribbonAlpha;
            _loc11_.ribbonThickness = _loc12_.ribbonThickness;
            _loc11_.ribbonTrail.blendMode = "add";
            _loc11_.ribbonTrail.texture = TextureLocator.getService().getTextureMainByTextureName(_loc12_.ribbonTexture || "ribbon_trail");
            _loc11_.ribbonTrail.followTrailSegmentsLine(_loc11_.followingRibbonSegmentLine);
            _loc11_.ribbonTrail.isPlaying = false;
            _loc11_.ribbonTrail.visible = false;
            _loc11_.useRibbonOffset = _loc12_.useRibbonOffset;
         }
         var _loc9_:Boolean = param4.reloadTime < 60 && Math.random() < 0.4;
         if(_loc12_.thrustEffect != null && !_loc9_)
         {
            _loc11_.thrustEmitters = EmitterFactory.create(_loc12_.thrustEffect,param2,param3.pos.x,param3.pos.y,_loc11_,true);
         }
         _loc11_.forcedRotation = _loc12_.forcedRotation;
         if(_loc11_.forcedRotation)
         {
            _loc11_.forcedRotationAngle = Math.random() * 2 * 3.141592653589793 - 3.141592653589793;
            _loc11_.forcedRotationSpeed = _loc12_.forcedRotationSpeed;
         }
         _loc11_.explosionSound = _loc12_.explosionSound;
         if(_loc12_.explosionSound != null)
         {
            _loc13_ = SoundLocator.getService();
            _loc13_.preCacheSound(_loc12_.explosionSound);
         }
         _loc11_.explosionEffect = _loc12_.explosionEffect;
         _loc11_.stateMachine.changeState(AIStateFactory.createProjectileAI(_loc12_,param2,_loc11_));
         return _loc11_;
      }
   }
}

