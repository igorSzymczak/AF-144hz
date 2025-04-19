package movement
{
   import core.hud.components.hotkeys.AbilityHotkey;
   import core.player.Player;
   import core.scene.Game;
   import core.ship.PlayerShip;
   import flash.utils.Dictionary;
   import playerio.Message;
   
   public class CommandManager
   {
      public var commands:Vector.<Command>;
      
      private var sendBuffer:Vector.<Command>;
      
      private var g:Game;
      
      public function CommandManager(param1:Game)
      {
         commands = new Vector.<Command>();
         sendBuffer = new Vector.<Command>();
         super();
         this.g = param1;
      }
      
      public function addMessageHandlers() : void
      {
         g.addMessageHandler("command",commandReceived);
      }
      
      public function flush() : void
      {
         if(sendBuffer.length == 0)
         {
            return;
         }
         var _loc2_:Message = g.createMessage("command");
         for each(var _loc1_ in sendBuffer)
         {
            _loc2_.add(_loc1_.type);
            _loc2_.add(_loc1_.active);
            _loc2_.add(_loc1_.time);
         }
         g.sendMessage(_loc2_);
         sendBuffer = new Vector.<Command>();
      }
      
      public function addCommand(param1:int, param2:Boolean) : void
      {
         var _loc3_:PlayerShip = g.playerManager.me.ship;
         var _loc4_:Heading = _loc3_.course;
         var _loc5_:Command;
         (_loc5_ = new Command()).type = param1;
         _loc5_.active = param2;
         while(_loc4_.time < g.time - 2 * Game.dt)
         {
            _loc3_.convergerUpdateHeading(_loc4_);
         }
         _loc5_.time = _loc4_.time;
         commands.push(_loc5_);
         sendCommand(_loc5_);
         _loc3_.clearConvergeTarget();
         _loc3_.runCommand(_loc5_);
      }
      
      private function sendCommand(param1:Command) : void
      {
         var _loc2_:Message = g.createMessage("command");
         _loc2_.add(param1.type);
         _loc2_.add(param1.active);
         _loc2_.add(param1.time);
         g.sendMessage(_loc2_);
      }
      
      public function commandReceived(param1:Message) : void
      {
         var _loc2_:Dictionary = g.playerManager.playersById;
         var _loc3_:String = param1.getString(0);
         var _loc4_:Command;
         (_loc4_ = new Command()).type = param1.getInt(1);
         _loc4_.active = param1.getBoolean(2);
         _loc4_.time = param1.getNumber(3);
         var _loc5_:Player = _loc2_[_loc3_];
         if(_loc5_ != null && _loc5_.ship != null)
         {
            _loc5_.ship.runCommand(_loc4_);
         }
      }
      
      public function runCommand(param1:Heading, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Command = null;
         _loc3_ = 0;
         while(_loc3_ < commands.length)
         {
            _loc4_ = commands[_loc3_];
            if(_loc4_.time >= param2)
            {
               if(_loc4_.time != param2)
               {
                  break;
               }
               param1.runCommand(_loc4_);
            }
            _loc3_++;
         }
      }
      
      public function clearCommands(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < commands.length)
         {
            if(commands[_loc2_].time >= param1)
            {
               break;
            }
            _loc3_++;
            _loc2_++;
         }
         if(_loc3_ != 0)
         {
            commands.splice(0,_loc3_);
         }
      }
      
      public function addBoostCommand(param1:AbilityHotkey = null) : void
      {
         var _loc2_:PlayerShip = g.me.ship;
         if(_loc2_.boostNextRdy < g.time && _loc2_.hasBoost)
         {
            g.hud.abilities.initiateCooldown("Engine");
            _loc2_.boost();
            addCommand(4,true);
         }
      }
      
      public function addDmgBoostCommand(param1:AbilityHotkey = null) : void
      {
         var _loc2_:PlayerShip = g.me.ship;
         if(_loc2_.hasDmgBoost && _loc2_.dmgBoostNextRdy < g.time)
         {
            g.hud.abilities.initiateCooldown("Power");
            _loc2_.dmgBoost();
            addCommand(7,true);
         }
      }
      
      public function addShieldConvertCommand(param1:AbilityHotkey = null) : void
      {
         var _loc2_:PlayerShip = g.me.ship;
         if(_loc2_.hasArmorConverter && _loc2_.convNextRdy < g.time)
         {
            g.hud.abilities.initiateCooldown("Armor");
            _loc2_.convertShield();
            addCommand(6,true);
         }
      }
      
      public function addHardenedShieldCommand(param1:AbilityHotkey = null) : void
      {
         var _loc2_:PlayerShip = g.me.ship;
         if(_loc2_.hardenNextRdy < g.time && _loc2_.hasHardenedShield)
         {
            g.hud.abilities.initiateCooldown("Shield");
            _loc2_.hardenShield();
            addCommand(5,true);
         }
      }
   }
}

