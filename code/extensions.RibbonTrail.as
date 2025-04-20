package extensions
{
   import core.scene.Game;
   import flash.geom.Point;
   import starling.animation.IAnimatable;
   import starling.display.DisplayObject;
   import starling.display.Mesh;
   import starling.rendering.IndexData;
   import starling.rendering.VertexData;
   import starling.textures.Texture;
   
   public class RibbonTrail extends Mesh implements IAnimatable
   {
      private static var sRenderAlpha:Vector.<Number> = new <Number>[1,1,1,1];
      
      private static var sMapTexCoords:Vector.<Number> = new <Number>[0,0,0,0];
      
      protected var mVertexData:VertexData;
      
      protected var mIndexData:IndexData;
      
      protected var mTexture:Texture;
      
      protected var mRibbonSegments:Vector.<RibbonSegment>;
      
      protected var mNumRibbonSegments:int;
      
      protected var mFollowingEnable:Boolean = true;
      
      protected var mMovingRatio:Number = 0.5;
      
      protected var mAlphaRatio:Number = 0.95;
      
      protected var mRepeat:Boolean = false;
      
      protected var mIsPlaying:Boolean = false;
      
      protected var mFollowingRibbonSegmentLine:Vector.<RibbonSegment>;
      
      protected var g:Game;
      
      protected var alphaArray:Array;
      
      public function RibbonTrail(param1:Game, param2:int = 8)
      {
         this.mMovingRatio = 0.5;
         this.mAlphaRatio = 0.95;
         alphaArray = [];
         this.g = param1;
         mVertexData = new VertexData();
         mIndexData = new IndexData();
         mRibbonSegments = new Vector.<RibbonSegment>(0);
         raiseCapacity(param2 * Game.bdt * 2);
         super(mVertexData,mIndexData);
         updatevertexData();
         style.textureRepeat = false;
         blendMode = "add";
      }
      
      override public function set color(param1:uint) : void
      {
         vertexData.colorize("color",param1);
      }
      
      public function get followingEnable() : Boolean
      {
         return mFollowingEnable;
      }
      
      public function set followingEnable(param1:Boolean) : void
      {
         mFollowingEnable = param1;
      }
      
      public function get isPlaying() : Boolean
      {
         return mIsPlaying;
      }
      
      public function set isPlaying(param1:Boolean) : void
      {
         mIsPlaying = param1;
      }
      
      public function get movingRatio() : Number
      {
         return mMovingRatio;
      }
      
      public function set movingRatio(param1:Number) : void
      {
         if(mMovingRatio != param1)
         {
            mMovingRatio = param1 < 0 ? 0 : (param1 > 1 ? 1 : param1);
         }
      }
      
      public function get alphaRatio() : Number
      {
         return mAlphaRatio;
      }
      
      public function set alphaRatio(param1:Number) : void
      {
         if(mAlphaRatio != param1)
         {
            mAlphaRatio = param1 < 0 ? 0 : (param1 > 1 ? 1 : param1);
         }
      }
      
      public function get repeat() : Boolean
      {
         return mRepeat;
      }
      
      public function set repeat(param1:Boolean) : void
      {
         if(mRepeat != param1)
         {
            mRepeat = param1;
         }
      }
      
      public function getRibbonSegment(param1:int) : RibbonSegment
      {
         return mRibbonSegments[param1];
      }
      
      public function followTrailSegmentsLine(param1:Vector.<RibbonSegment>) : void
      {
         mFollowingRibbonSegmentLine = param1;
      }
      
      public function resetAllTo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 1) : void
      {
         var _loc6_:RibbonSegment = null;
         alphaArray = [];
         if(mNumRibbonSegments > mRibbonSegments.length)
         {
            return;
         }
         var _loc7_:int = 0;
         while(_loc7_ < mNumRibbonSegments)
         {
            _loc6_ = mRibbonSegments[_loc7_];
            _loc6_.setTo(param1,param2,param3,param4,param5);
            _loc7_++;
         }
      }
      
      protected function updatevertexData() : void
      {
         var _loc1_:Number = 1 / (mNumRibbonSegments - 1);
         var _loc4_:Number = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < mNumRibbonSegments)
         {
            _loc2_ = _loc3_ * 2;
            _loc4_ = _loc3_ * _loc1_;
            if(mRepeat)
            {
               sMapTexCoords[0] = _loc3_;
               sMapTexCoords[1] = 0;
               sMapTexCoords[2] = _loc3_;
               sMapTexCoords[3] = 1;
            }
            else
            {
               sMapTexCoords[0] = _loc4_;
               sMapTexCoords[1] = 0;
               sMapTexCoords[2] = _loc4_;
               sMapTexCoords[3] = 1;
            }
            setTexCoords(_loc2_,sMapTexCoords[0],sMapTexCoords[1]);
            setTexCoords(_loc2_ + 1,sMapTexCoords[2],sMapTexCoords[3]);
            _loc3_++;
         }
      }
      
      protected function createTrailSegment() : RibbonSegment
      {
         return new RibbonSegment();
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         return null;
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc3_:RibbonSegment = null;
         var _loc8_:RibbonSegment = null;
         var _loc5_:* = null;
         var _loc6_:Number = NaN;
         if(!mIsPlaying)
         {
            return;
         }
         var _loc7_:int = int(!!mFollowingRibbonSegmentLine ? mFollowingRibbonSegmentLine.length : 0);
         if(_loc7_ == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         if(mRibbonSegments.length < mNumRibbonSegments)
         {
            return;
         }
         while(_loc4_ < mNumRibbonSegments)
         {
            _loc3_ = mRibbonSegments[_loc4_];
            _loc8_ = _loc4_ < _loc7_ ? mFollowingRibbonSegmentLine[_loc4_] : null;
            if(_loc8_)
            {
               _loc3_.copyFrom(_loc8_);
            }
            else if(mFollowingEnable && _loc5_)
            {
               _loc3_.tweenTo(_loc5_);
            }
            _loc5_ = _loc3_;
            _loc2_ = _loc4_ * 2;
            _loc6_ = Math.min(0.50, _loc3_.alpha * Math.pow(Game.bdt, 2));
            setVertexPosition(_loc2_,_loc3_.x0,_loc3_.y0);
            setVertexPosition(_loc2_ + 1,_loc3_.x1,_loc3_.y1);
            if(alphaArray.length <= _loc4_)
            {
               alphaArray.push(_loc6_);
               setVertexAlpha(_loc2_,_loc6_);
               setVertexAlpha(_loc2_ + 1,_loc6_);
               alphaArray[_loc4_] = _loc6_;
            }
            if(alphaArray[_loc4_] != _loc6_)
            {
               setVertexAlpha(_loc2_,_loc6_);
               setVertexAlpha(_loc2_ + 1,_loc6_);
               alphaArray[_loc4_] = _loc6_;
            }
            _loc4_++;
         }
      }
      
      public function raiseCapacity(param1:int) : void
      {
         var _loc3_:RibbonSegment = null;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc2_:int = int(mNumRibbonSegments);
         mNumRibbonSegments = Math.min(8129,_loc2_ + param1);
         mRibbonSegments.fixed = false;
         _loc4_ = _loc2_;
         while(_loc4_ < mNumRibbonSegments)
         {
            _loc3_ = createTrailSegment();
            _loc3_.ribbonTrail = this;
            mRibbonSegments[_loc4_] = _loc3_;
            if(_loc4_ > 0)
            {
               _loc5_ = _loc4_ * 2 - 2;
               mIndexData.addQuad(_loc5_,_loc5_ + 1,_loc5_ + 2,_loc5_ + 3);
            }
            _loc4_++;
         }
         mRibbonSegments.fixed = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         mVertexData.clear();
         mVertexData = null;
         mIndexData.clear();
         mIndexData = null;
         mFollowingRibbonSegmentLine = null;
         mFollowingEnable = false;
         mTexture = null;
         mRibbonSegments = null;
         mIsPlaying = false;
         mNumRibbonSegments = 0;
      }
   }
}

