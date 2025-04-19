package core.ship
{
   import core.engine.EngineFactory;
   import core.player.EliteTechs;
   import core.player.FleetObj;
   import core.player.Player;
   import core.player.TechSkill;
   import core.scene.Game;
   import core.turret.Turret;
   import core.unit.Unit;
   import core.weapon.Weapon;
   import core.weapon.WeaponFactory;
   import data.DataLocator;
   import data.IDataManager;
   import generics.Random;
   import sound.ISound;
   import sound.SoundLocator;
   import starling.filters.ColorMatrixFilter;
   
   public class ShipFactory
   {
      public function ShipFactory()
      {
         super();
      }
      
      public static function createPlayer(param1:Game, param2:Player, param3:PlayerShip, param4:Array) : PlayerShip
      {
         var _loc10_:ColorMatrixFilter = null;
         var _loc8_:IDataManager = DataLocator.getService();
         var _loc6_:Object = _loc8_.loadKey("Skins",param2.activeSkin);
         var _loc11_:FleetObj = param2.getActiveFleetObj();
         param3.hideShadow = _loc6_.hideShadow;
         createBody(_loc6_.ship,param1,param3);
         param3 = PlayerShip(param3);
         param3.name = param2.name;
         param3.setIsHostile(param2.isHostile);
         param3.group = param2.group;
         param3.factions = param2.factions;
         param3.hpBase = param3.hpMax;
         param3.shieldHpBase = param3.shieldHpMax;
         param3.activeWeapons = 0;
         param3.unlockedWeaponSlots = param2.unlockedWeaponSlots;
         param3.player = param2;
         param3.artifact_convAmount = 0;
         param3.artifact_cooldownReduction = 0;
         param3.artifact_speed = 0;
         param3.artifact_powerRegen = 0;
         param3.artifact_powerMax = 0;
         param3.artifact_refire = 0;
         var _loc9_:Number = !!_loc11_.shipHue ? _loc11_.shipHue : 0;
         var _loc5_:Number = !!_loc11_.shipBrightness ? _loc11_.shipBrightness : 0;
         if(_loc9_ != 0 || _loc5_ != 0)
         {
            _loc10_ = createPlayerShipColorMatrixFilter(_loc11_);
            param3.movieClip.filter = _loc10_;
            param3.originalFilter = _loc10_;
         }
         param3.engine = EngineFactory.create(_loc6_.engine,param1,param3);
         var _loc7_:Number = !!_loc11_.engineHue ? _loc11_.engineHue : 0;
         addEngineTechToShip(param2,param3);
         param3.engine.colorHue = _loc7_;
         if(param2.engineColor != 0)
         {
            param3.engine.colorHue = param2.engineColor;
            param2.engineColor = 0;
         }
         CreatePlayerShipWeapon(param1,param2,0,param4,param3);
         addArmorTechToShip(param2,param3);
         addShieldTechToShip(param2,param3);
         addPowerTechToShip(param2,param3);
         addLevelBonusToShip(param1,param2.level,param3);
         param3.hp = param3.hpMax;
         param3.shieldHp = param3.shieldHpMax;
         return param3;
      }
      
      public static function createPlayerShipColorMatrixFilter(param1:FleetObj) : ColorMatrixFilter
      {
         if(RymdenRunt.isBuggedFlashVersion)
         {
            return null;
         }
         var _loc6_:ColorMatrixFilter = new ColorMatrixFilter();
         var _loc5_:Number = !!param1.shipHue ? param1.shipHue : 0;
         var _loc3_:Number = !!param1.shipBrightness ? param1.shipBrightness : 0;
         var _loc2_:Number = !!param1.shipSaturation ? param1.shipSaturation : 0;
         var _loc4_:Number = !!param1.shipContrast ? param1.shipContrast : 0;
         _loc6_.resolution = 2;
         _loc6_.adjustHue(_loc5_);
         _loc6_.adjustBrightness(_loc3_);
         _loc6_.adjustSaturation(_loc2_);
         _loc6_.adjustContrast(_loc4_);
         return _loc6_;
      }
      
      public static function CreatePlayerShipWeapon(param1:Game, param2:Player, param3:int, param4:Array, param5:PlayerShip) : void
      {
         var _loc7_:int = 0;
         var _loc6_:TechSkill = null;
         var _loc9_:Weapon = null;
         var _loc8_:Object = param4[param3];
         var _loc11_:int = 0;
         var _loc10_:int = -1;
         var _loc13_:String = "";
         if(param2 != null && param2.techSkills != null && _loc8_ != null)
         {
            _loc7_ = 0;
            while(_loc7_ < param2.techSkills.length)
            {
               _loc6_ = param2.techSkills[_loc7_];
               if(_loc6_.tech == _loc8_.weapon)
               {
                  _loc11_ = _loc6_.level;
                  _loc10_ = _loc6_.activeEliteTechLevel;
                  _loc13_ = _loc6_.activeEliteTech;
               }
               _loc7_++;
            }
         }
         var _loc12_:Weapon = WeaponFactory.create(_loc8_.weapon,param1,param5,_loc11_,_loc10_,_loc13_);
         _loc12_.setActive(param5,param2.weaponsState[param3]);
         _loc12_.hotkey = param2.weaponsHotkeys[param3];
         addLevelBonusToWeapon(param1,param2.level,_loc12_,param2);
         if(param3 < param5.weapons.length)
         {
            _loc9_ = param5.weapons[param3];
            param5.weapons[param3] = _loc12_;
            _loc9_.destroy();
         }
         else
         {
            param5.weapons.push(_loc12_);
         }
         if(param3 == param4.length - 1)
         {
            param2.saveWeaponData(param5.weapons);
         }
         else
         {
            param3 += 1;
            CreatePlayerShipWeapon(param1,param2,param3,param4,param5);
         }
      }
      
      private static function addArmorTechToShip(param1:Player, param2:PlayerShip) : void
      {
         var _loc8_:int = 0;
         var _loc3_:TechSkill = null;
         var _loc10_:Object = null;
         var _loc7_:int = 0;
         _loc8_ = 0;
         while(_loc8_ < param1.techSkills.length)
         {
            _loc3_ = param1.techSkills[_loc8_];
            if(_loc3_.tech == "m4yG1IRPIUeyRQHrC3h5kQ")
            {
               break;
            }
            _loc8_++;
         }
         var _loc9_:IDataManager = DataLocator.getService();
         var _loc5_:Object = _loc9_.loadKey("BasicTechs",_loc3_.tech);
         var _loc6_:int = _loc3_.level;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc10_ = _loc5_.techLevels[_loc7_];
            param2.armorThreshold += _loc10_.dmgThreshold;
            param2.armorThresholdBase += _loc10_.dmgThreshold;
            param2.hpBase += _loc10_.hpBonus;
            if(_loc7_ == _loc6_ - 1)
            {
               if(_loc10_.armorConvGain > 0)
               {
                  param2.hasArmorConverter = true;
                  param2.convCD = _loc10_.cooldown * 1000;
                  param2.convCost = _loc10_.armorConvCost;
                  param2.convGain = _loc10_.armorConvGain;
               }
            }
            _loc7_++;
         }
         param2.hpMax = param2.hpBase;
         var _loc4_:int = -1;
         var _loc11_:String = "";
         _loc4_ = _loc3_.activeEliteTechLevel;
         _loc11_ = _loc3_.activeEliteTech;
         EliteTechs.addEliteTechs(param2,_loc5_,_loc4_,_loc11_);
      }
      
      private static function addShieldTechToShip(param1:Player, param2:PlayerShip) : void
      {
         var _loc8_:int = 0;
         var _loc3_:TechSkill = null;
         var _loc10_:Object = null;
         var _loc7_:int = 0;
         _loc8_ = 0;
         while(_loc8_ < param1.techSkills.length)
         {
            _loc3_ = param1.techSkills[_loc8_];
            if(_loc3_.tech == "QgKEEj8a-0yzYAJ06eSLqA")
            {
               break;
            }
            _loc8_++;
         }
         var _loc9_:IDataManager = DataLocator.getService();
         var _loc5_:Object = _loc9_.loadKey("BasicTechs",_loc3_.tech);
         var _loc6_:int = _loc3_.level;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc10_ = _loc5_.techLevels[_loc7_];
            param2.shieldHpBase += _loc10_.hpBonus;
            param2.shieldRegenBase += _loc10_.regen;
            if(_loc7_ == _loc6_ - 1)
            {
               if(_loc10_.hardenMaxDmg > 0)
               {
                  param2.hasHardenedShield = true;
                  param2.hardenMaxDmg = _loc10_.hardenMaxDmg;
                  param2.hardenCD = _loc10_.cooldown * 1000;
                  param2.hardenDuration = _loc10_.duration * 1000;
               }
            }
            _loc7_++;
         }
         param2.shieldRegen = param2.shieldRegenBase;
         param2.shieldHpMax = param2.shieldHpBase;
         var _loc4_:int = -1;
         var _loc11_:String = "";
         _loc4_ = _loc3_.activeEliteTechLevel;
         _loc11_ = _loc3_.activeEliteTech;
         EliteTechs.addEliteTechs(param2,_loc5_,_loc4_,_loc11_);
      }
      
      private static function addEngineTechToShip(param1:Player, param2:PlayerShip) : void
      {
         var _loc5_:int = 0;
         var _loc3_:TechSkill = null;
         var _loc7_:Object = null;
         var _loc4_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < param1.techSkills.length)
         {
            _loc3_ = param1.techSkills[_loc5_];
            if(_loc3_.tech == "rSr1sn-_oUOY6E0hpAhh0Q")
            {
               break;
            }
            _loc5_++;
         }
         var _loc12_:IDataManager = DataLocator.getService();
         var _loc9_:Object = _loc12_.loadKey("BasicTechs",_loc3_.tech);
         var _loc10_:int = _loc3_.level;
         var _loc6_:int = 100;
         var _loc11_:int = 100;
         _loc4_ = 0;
         while(_loc4_ < _loc10_)
         {
            _loc7_ = _loc9_.techLevels[_loc4_];
            _loc6_ += _loc7_.acceleration;
            _loc11_ += _loc7_.maxSpeed;
            if(_loc4_ == _loc10_ - 1)
            {
               if(_loc7_.boost > 0)
               {
                  param2.hasBoost = true;
                  param2.boostBonus = _loc7_.boost;
                  param2.boostCD = _loc7_.cooldown * 1000;
                  param2.boostDuration = _loc7_.duration * 1000;
                  param2.totalTicksOfBoost = param2.boostDuration / Game.dt;
                  param2.ticksOfBoost = 0;
               }
            }
            _loc4_++;
         }
         param2.engine.acceleration = param2.engine.acceleration * _loc6_ / 100;
         param2.engine.speed = param2.engine.speed * _loc11_ / 100;
         var _loc8_:int = -1;
         var _loc13_:String = "";
         _loc8_ = _loc3_.activeEliteTechLevel;
         _loc13_ = _loc3_.activeEliteTech;
         EliteTechs.addEliteTechs(param2,_loc9_,_loc8_,_loc13_);
      }
      
      private static function addPowerTechToShip(param1:Player, param2:PlayerShip) : void
      {
         var _loc8_:int = 0;
         var _loc3_:TechSkill = null;
         var _loc10_:Object = null;
         var _loc7_:int = 0;
         _loc8_ = 0;
         while(_loc8_ < param1.techSkills.length)
         {
            _loc3_ = param1.techSkills[_loc8_];
            if(_loc3_.tech == "kwlCdExeJk-oEJZopIz5kg")
            {
               break;
            }
            _loc8_++;
         }
         var _loc9_:IDataManager = DataLocator.getService();
         var _loc5_:Object = _loc9_.loadKey("BasicTechs",_loc3_.tech);
         var _loc6_:int = _loc3_.level;
         param2.maxPower = 1;
         param2.powerRegBonus = 1;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc10_ = _loc5_.techLevels[_loc7_];
            param2.maxPower += 0.01 * Number(_loc10_.maxPower);
            param2.powerRegBonus += 0.01 * Number(_loc10_.powerReg);
            if(_loc7_ == _loc6_ - 1)
            {
               if(_loc10_.boost > 0)
               {
                  param2.hasDmgBoost = true;
                  param2.dmgBoostCD = _loc10_.cooldown * 1000;
                  param2.dmgBoostDuration = _loc10_.duration * 1000;
                  param2.dmgBoostCost = 0.01 * Number(_loc10_.boostCost);
                  param2.dmgBoostBonus = 0.01 * Number(_loc10_.boost);
                  param2.totalTicksOfBoost = param2.boostDuration / Game.dt;
                  param2.ticksOfBoost = 0;
               }
            }
            _loc7_++;
         }
         param2.weaponHeat.setBonuses(param2.maxPower,param2.powerRegBonus);
         var _loc4_:int = -1;
         var _loc11_:String = "";
         _loc4_ = _loc3_.activeEliteTechLevel;
         _loc11_ = _loc3_.activeEliteTech;
         EliteTechs.addEliteTechs(param2,_loc5_,_loc4_,_loc11_);
      }
      
      private static function addLevelBonusToShip(param1:Game, param2:Number, param3:PlayerShip) : void
      {
         if(param1.solarSystem.isPvpSystemInEditor)
         {
            param2 = 100;
         }
         var _loc5_:Number = param3.player.troons;
         var _loc4_:Number = _loc5_ / 200000;
         param2 += _loc4_;
         param3.hpBase = param3.hpBase * (100 + 8 * (param2 - 1)) / 100;
         param3.hpMax = param3.hpBase;
         param3.hp = param3.hpMax;
         param3.armorThresholdBase = param3.armorThresholdBase * (100 + 2.5 * 8 * (param2 - 1)) / 100;
         param3.shieldHpBase = param3.shieldHpBase * (100 + 8 * (param2 - 1)) / 100;
         param3.armorThreshold = param3.armorThresholdBase;
         param3.shieldHpMax = param3.shieldHpBase;
         param3.shieldHp = param3.shieldHpMax;
         param3.shieldRegenBase = param3.shieldRegenBase * (100 + 1 * (param2 - 1)) / 100;
         param3.shieldRegen = param3.shieldRegenBase;
      }
      
      private static function addLevelBonusToWeapon(param1:Game, param2:Number, param3:Weapon, param4:Player) : void
      {
         if(param1.solarSystem.isPvpSystemInEditor)
         {
            param2 = 100;
         }
         var _loc6_:Number = param4.troons;
         var _loc5_:Number = _loc6_ / 200000;
         param2 += _loc5_;
         param3.dmg.addLevelBonus(param2,8);
         if(param3.debuffValue != null)
         {
            param3.debuffValue.addLevelBonus(param2,8);
            param3.debuffValue2.addLevelBonus(param2,8);
         }
      }
      
      public static function createEnemy(param1:Game, param2:String, param3:int = 0) : EnemyShip
      {
         var _loc5_:Number = NaN;
         var _loc4_:Random = null;
         var _loc8_:IDataManager = DataLocator.getService();
         var _loc6_:Object = _loc8_.loadKey("Enemies",param2);
         if(param1.isLeaving)
         {
            return null;
         }
         if(_loc6_ == null)
         {
            trace("Key: ",param2);
            return null;
         }
         var _loc7_:EnemyShip = param1.shipManager.getEnemyShip();
         _loc7_.name = _loc6_.name;
         _loc7_.xp = _loc6_.xp;
         _loc7_.level = _loc6_.level;
         _loc7_.rareType = param3;
         _loc7_.aggroRange = _loc6_.aggroRange;
         _loc7_.chaseRange = _loc6_.chaseRange;
         _loc7_.observer = _loc6_.observer;
         if(_loc7_.observer)
         {
            _loc7_.visionRange = _loc6_.visionRange;
         }
         else
         {
            _loc7_.visionRange = _loc7_.aggroRange;
         }
         if(param1.isSystemTypeSurvival() && _loc7_.level < param1.hud.uberStats.uberLevel)
         {
            _loc5_ = param1.hud.uberStats.CalculateUberRankFromLevel(_loc7_.level);
            _loc7_.uberDifficulty = param1.hud.uberStats.CalculateUberDifficultyFromRank(param1.hud.uberStats.uberRank - _loc5_,_loc7_.level);
            _loc7_.uberLevelFactor = 1 + (param1.hud.uberStats.uberLevel - _loc7_.level) / 100;
            _loc7_.aggroRange *= _loc7_.uberLevelFactor;
            _loc7_.chaseRange *= _loc7_.uberLevelFactor;
            _loc7_.visionRange *= _loc7_.uberLevelFactor;
            _loc4_ = new Random(_loc7_.id);
            if(_loc7_.aggroRange > 2000)
            {
               _loc7_.aggroRange = 10000;
            }
            else if(param1.hud.uberStats.uberRank >= 9)
            {
               _loc7_.aggroRange = 50 * 60 + _loc4_.random(10000);
            }
            else if(param1.hud.uberStats.uberRank >= 6)
            {
               _loc7_.aggroRange = 2000 + _loc4_.random(10000);
            }
            else if(param1.hud.uberStats.uberRank >= 3)
            {
               _loc7_.aggroRange = 25 * 60 + _loc4_.random(10000);
            }
            else if(_loc7_.aggroRange < 50 * 60)
            {
               _loc7_.aggroRange = 1000 + _loc4_.random(10000);
            }
            _loc7_.chaseRange = _loc7_.aggroRange;
            _loc7_.visionRange = _loc7_.aggroRange;
            _loc7_.xp *= _loc7_.uberLevelFactor;
            _loc7_.level = param1.hud.uberStats.uberLevel;
         }
         _loc7_.orbitSpawner = _loc6_.orbitSpawner;
         if(_loc7_.orbitSpawner)
         {
            _loc7_.hpRegen = _loc6_.hpRegen;
         }
         _loc7_.aimSkill = _loc6_.aimSkill;
         if(_loc6_.hasOwnProperty("stopWhenClose"))
         {
            _loc7_.stopWhenClose = _loc6_.stopWhenClose;
         }
         if(_loc6_.hasOwnProperty("AIFaction1") && _loc6_.AIFaction1 != "")
         {
            _loc7_.factions.push(_loc6_.AIFaction1);
         }
         if(_loc6_.hasOwnProperty("AIFaction2") && _loc6_.AIFaction2 != "")
         {
            _loc7_.factions.push(_loc6_.AIFaction2);
         }
         if(_loc6_.hasOwnProperty("teleport"))
         {
            _loc7_.teleport = _loc6_.teleport;
         }
         _loc7_.kamikaze = _loc6_.kamikaze;
         if(_loc7_.kamikaze)
         {
            _loc7_.kamikazeLifeTreshhold = _loc6_.kamikazeLifeTreshhold;
            _loc7_.kamikazeHoming = _loc6_.kamikazeHoming;
            _loc7_.kamikazeTtl = _loc6_.kamikazeTtl;
            _loc7_.kamikazeDmg = _loc6_.kamikazeDmg;
            _loc7_.kamikazeRadius = _loc6_.kamikazeRadius;
            _loc7_.kamikazeWhenClose = _loc6_.kamikazeWhenClose;
         }
         if(_loc6_.hasOwnProperty("alwaysFire"))
         {
            _loc7_.alwaysFire = _loc6_.alwaysFire;
         }
         else
         {
            _loc7_.alwaysFire = false;
         }
         _loc7_.forcedRotation = _loc6_.forcedRotation;
         if(_loc7_.forcedRotation)
         {
            _loc7_.forcedRotationSpeed = _loc6_.forcedRotationSpeed;
            _loc7_.forcedRotationAim = _loc6_.forcedRotationAim;
         }
         _loc7_.melee = _loc6_.melee;
         if(_loc7_.melee)
         {
            _loc7_.meleeCharge = _loc6_.charge;
            _loc7_.meleeChargeSpeedBonus = Number(_loc6_.chargeSpeedBonus) / 100;
            _loc7_.meleeChargeDuration = _loc6_.chargeDuration;
            _loc7_.meleeCanGrab = _loc6_.grab;
         }
         _loc7_.flee = _loc6_.flee;
         if(_loc7_.flee)
         {
            _loc7_.fleeLifeTreshhold = _loc6_.fleeLifeTreshhold;
            _loc7_.fleeDuration = _loc6_.fleeDuration;
            if(_loc6_.hasOwnProperty("fleeClose"))
            {
               _loc7_.fleeClose = _loc6_.fleeClose;
            }
            else
            {
               _loc7_.fleeClose = 0;
            }
         }
         _loc7_.aiCloak = false;
         if(_loc6_.hasOwnProperty("hardenShield"))
         {
            _loc7_.aiHardenShield = false;
            _loc7_.aiHardenShieldDuration = _loc6_.hardenShieldDuration;
         }
         else
         {
            _loc7_.aiHardenShield = false;
            _loc7_.aiHardenShieldDuration = 0;
         }
         if(_loc6_.hasOwnProperty("sniper"))
         {
            _loc7_.sniper = _loc6_.sniper;
            if(_loc7_.sniper)
            {
               _loc7_.sniperMinRange = _loc6_.sniperMinRange;
            }
         }
         _loc7_.isHostile = true;
         _loc7_.group = null;
         createBody(_loc6_.ship,param1,_loc7_);
         _loc7_.engine = EngineFactory.create(_loc6_.engine,param1,_loc7_);
         if(_loc7_.uberDifficulty > 0)
         {
            _loc7_.hp = _loc7_.hpMax = _loc7_.hpMax * _loc7_.uberDifficulty;
            _loc7_.shieldHp = _loc7_.shieldHpMax = _loc7_.shieldHpMax * _loc7_.uberDifficulty;
            _loc7_.engine.speed *= _loc7_.uberLevelFactor;
            if(_loc7_.engine.speed > 380)
            {
               _loc7_.engine.speed = 380;
            }
         }
         if(param3 == 1)
         {
            _loc7_.hp = _loc7_.hpMax = _loc7_.hpMax * 3;
            _loc7_.shieldHp = _loc7_.shieldHpMax = _loc7_.shieldHpMax * 3;
         }
         if(param3 == 4)
         {
            _loc7_.hp = _loc7_.hpMax = _loc7_.hpMax * 3;
            _loc7_.shieldHp = _loc7_.shieldHpMax = _loc7_.shieldHpMax * 3;
            _loc7_.engine.speed *= 1.1;
         }
         if(param3 == 5)
         {
            _loc7_.color = 16746513;
            _loc7_.hp = _loc7_.hpMax = _loc7_.hpMax * 10;
            _loc7_.shieldHp = _loc7_.shieldHpMax = _loc7_.shieldHpMax * 10;
            _loc7_.engine.speed *= 1.3;
         }
         if(param3 == 3)
         {
            _loc7_.engine.speed *= 1.4;
         }
         if(_loc6_.hasOwnProperty("startHp"))
         {
            _loc7_.hp = 0.01 * _loc6_.startHp * _loc7_.hp;
         }
         CreateEnemyShipWeapon(param1,0,_loc6_.weapons,_loc7_);
         CreateEnemyShipExtraWeapon(param1,_loc7_.weapons.length,_loc6_.fleeWeaponItem,_loc7_,0);
         CreateEnemyShipExtraWeapon(param1,_loc7_.weapons.length,_loc6_.antiProjectileWeaponItem,_loc7_,1);
         if(!param1.isLeaving)
         {
            param1.shipManager.activateEnemyShip(_loc7_);
         }
         return _loc7_;
      }
      
      private static function CreateEnemyShipWeapon(param1:Game, param2:int, param3:Array, param4:EnemyShip) : void
      {
         var _loc7_:Weapon = null;
         if(param3.length == 0)
         {
            return;
         }
         var _loc6_:Object = param3[param2];
         var _loc5_:Weapon = WeaponFactory.create(_loc6_.weapon,param1,param4,0);
         param4.weaponRanges.push(new WeaponRange(_loc6_.minRange,_loc6_.maxRange));
         if(param2 < param4.weapons.length)
         {
            _loc7_ = param4.weapons[param2];
            param4.weapons[param2] = _loc5_;
            _loc7_.destroy();
         }
         else
         {
            param4.weapons.push(_loc5_);
         }
         if(param2 != param3.length - 1)
         {
            param2 += 1;
            CreateEnemyShipWeapon(param1,param2,param3,param4);
         }
      }
      
      private static function CreateEnemyShipExtraWeapon(param1:Game, param2:int, param3:Object, param4:EnemyShip, param5:int) : void
      {
         var _loc7_:Weapon = null;
         if(param3 == null)
         {
            return;
         }
         var _loc6_:Weapon = WeaponFactory.create(param3.weapon,param1,param4,0);
         param4.weaponRanges.push(new WeaponRange(0,0));
         if(param5 == 0)
         {
            param4.escapeWeapon = _loc6_;
         }
         else
         {
            param4.antiProjectileWeapon = _loc6_;
         }
         if(param2 < param4.weapons.length)
         {
            _loc7_ = param4.weapons[param2];
            param4.weapons[param2] = _loc6_;
            _loc7_.destroy();
         }
         else
         {
            param4.weapons.push(_loc6_);
         }
      }
      
      public static function createBody(param1:String, param2:Game, param3:Unit) : void
      {
         var _loc6_:IDataManager = DataLocator.getService();
         var _loc4_:Object = _loc6_.loadKey("Ships",param1);
         param3.switchTexturesByObj(_loc4_);
         if(_loc4_.blendModeAdd)
         {
            param3.movieClip.blendMode = "add";
         }
         param3.obj = _loc4_;
         param3.bodyName = _loc4_.name;
         param3.collisionRadius = _loc4_.collisionRadius;
         param3.hp = _loc4_.hp;
         param3.hpMax = _loc4_.hp;
         param3.shieldHp = _loc4_.shieldHp;
         param3.shieldHpMax = _loc4_.shieldHp;
         param3.armorThreshold = _loc4_.armor;
         param3.armorThresholdBase = _loc4_.armor;
         param3.shieldRegenBase = 1.5 * _loc4_.shieldRegen;
         param3.shieldRegen = param3.shieldRegenBase;
         if(param3 is Ship)
         {
            param3.enginePos.x = _loc4_.enginePosX;
            param3.enginePos.y = _loc4_.enginePosY;
            param3.weaponPos.x = _loc4_.weaponPosX;
            param3.weaponPos.y = _loc4_.weaponPosY;
         }
         else
         {
            param3 is Turret;
         }
         param3.weaponPos.x = _loc4_.weaponPosX;
         param3.weaponPos.y = _loc4_.weaponPosY;
         param3.explosionEffect = _loc4_.explosionEffect;
         param3.explosionSound = _loc4_.explosionSound;
         var _loc5_:ISound = SoundLocator.getService();
         if(param3.explosionSound != null)
         {
            _loc5_.preCacheSound(param3.explosionSound);
         }
      }
   }
}

