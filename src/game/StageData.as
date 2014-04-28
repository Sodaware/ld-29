package game
{

	public class StageData 
	{
		
		private var _levelNumber:int;
		private var _stageNumber:int;
		private var _levelType:int;
		private var _targetEnemies:int;
		private var _timeLimit:int;
		private var _chargeLimit:int;
		private var _sonarLimit:int;
		private var _speedMultiplier:Number;
		private var _totalAnimals:int;
		private var _mineFrequency:Number;
		private var _enemyAggression:Number;
		
		public function StageData(data:Array) 
		{
			this._levelNumber = data[0];
			this._stageNumber = data[1];
			this._levelType   = data[2];
			this._targetEnemies = data[3];
			this._timeLimit     = data[4];
			this._totalAnimals = data[5];
			this._speedMultiplier = data[6];
			this._chargeLimit     = data[7];
			this._sonarLimit      = data[8];
			this._mineFrequency   = data[9];
			this._enemyAggression = data[10];
			
		}
		
		public function get levelNumber():int 
		{
			return _levelNumber;
		}
		
		public function get stageNumber():int 
		{
			return _stageNumber;
		}
		
		public function get levelType():int 
		{
			return _levelType;
		}
		
		public function get targetEnemies():int 
		{
			return _targetEnemies;
		}
		
		public function get timeLimit():int 
		{
			return _timeLimit;
		}
		
		public function get chargeLimit():int 
		{
			return _chargeLimit;
		}
		
		public function get sonarLimit():int 
		{
			return _sonarLimit;
		}
		
		public function get speedMultiplier():Number 
		{
			return _speedMultiplier;
		}
		
		public function get mineFrequency():int 
		{
			return this._mineFrequency;
		}
		
		public function get totalAnimals():int 
		{
			return _totalAnimals;
		}
		
		public function get enemyAggression():Number 
		{
			return _enemyAggression;
		}
		
	}

}