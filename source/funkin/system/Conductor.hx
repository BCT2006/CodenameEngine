package funkin.system;

import funkin.system.Song.SwagSong;

/**
 * ...
 * @author
 */

typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Int;
}

class Conductor
{
	/**
	 * Current BPM
	 */
	public static var bpm:Int = 100;

	/**
	 * Current Crochet (time per beat), in milliseconds.
	 */
	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds
	
	/**
	 * Current StepCrochet (time per step), in milliseconds.
	 */
	public static var stepCrochet:Float = crochet / 4; // steps in milliseconds

	
	/**
	 * Current position of the song, in milliseconds.
	 */
	public static var songPosition:Float;
	
	@:dox(hide) public static var lastSongPos:Float;
	@:dox(hide) public static var offset:Float = 0;

	@:dox(hide) public static var safeFrames:Int = 10;
	@:dox(hide) public static var safeZoneOffset:Float = (safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds

	/**
	 * Array of all BPM changes that have been mapped.
	 */
	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	@:dox(hide) public function new() {}

	/**
	 * Maps BPM changes from a song.
	 * @param song Song to map BPM changes from.
	 */
	public static function mapBPMChanges(song:SwagSong)
	{
		bpmChangeMap = [];

		var curBPM:Int = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length)
		{
			if(song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		trace("new BPM map BUDDY " + bpmChangeMap);
	}

	public static function changeBPM(newBpm:Int)
	{
		bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
	}
}