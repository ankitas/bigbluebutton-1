/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
*
* Copyright (c) 2010 BigBlueButton Inc. and by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 2.1 of the License, or (at your option) any later
* version.
*
* BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
* 
*/
package org.bigbluebutton.modules.videodock.business
{
	import com.asfusion.mate.events.Dispatcher;	
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;	
	import mx.collections.ArrayCollection;	
	import org.bigbluebutton.common.LogUtil;
	import org.bigbluebutton.core.BBB;
	import org.bigbluebutton.core.managers.UserManager;
	import org.bigbluebutton.main.events.BBBEvent;
	import org.bigbluebutton.main.model.users.BBBUser;
	import org.bigbluebutton.main.model.users.events.StreamStartedEvent;
	import org.bigbluebutton.modules.videodock.Util;
	import org.bigbluebutton.modules.videodock.events.StartBroadcastEvent;
	import org.bigbluebutton.modules.videodock.model.VideoConfOptions;

	
	public class VideoProxy
	{		
		private var videoOptions:VideoConfOptions;
		
		private var nc:NetConnection;
		private var ns:NetStream;
		
		private function parseOptions():void {
			videoOptions = new VideoConfOptions();
			videoOptions.parseOptions();	
		}
		
		public function VideoProxy(url:String)
		{
			parseOptions();
		
		}
				
		public function get connection():NetConnection{
			return this.nc;
		}
		
		public function startPublishing(e:StartBroadcastEvent):void{
			ns.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
			ns.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			ns.addEventListener( AsyncErrorEvent.ASYNC_ERROR, onAsyncError );
			ns.client = this;
			ns.attachCamera(e.camera);
			if ((BBB.getFlashPlayerVersion() >= 11) && videoOptions.enableH264) {
				LogUtil.info("Using H264 codec for video.");
				ns.videoStreamSettings = Util.getH264VideoStreamSettings(videoOptions);
			}
			
			ns.publish(e.stream);
		}
		
		
		
		public function stopBroadcasting():void{
			if (ns != null) {
				ns.attachCamera(null);
				ns.close();
				ns = null;
				ns = new NetStream(nc);
			}			
		}
		
		public function disconnect():void {
			if (nc != null) nc.close();
		}
		
		public function onBWCheck(... rest):Number { 
			return 0; 
		} 
		
		public function onBWDone(... rest):void { 
			var p_bw:Number; 
			if (rest.length > 0) p_bw = rest[0]; 
			// your application should do something here 
			// when the bandwidth check is complete 
			trace("bandwidth = " + p_bw + " Kbps."); 
		}
		
		public function openAvailableVideos():void{
//			var dispatcher:Dispatcher = new Dispatcher();
//			var users:ArrayCollection = UserManager.getInstance().getConference().users;
//			for (var i:int = 0; i < users.length; i++){
//				var user:BBBUser = (users.getItemAt(i) as BBBUser);
//				if (user.hasStream) dispatcher.dispatchEvent(new StreamStartedEvent(user.userID, user.name, user.streamName));
//			}
      
      var globalDispatcher:Dispatcher = new Dispatcher();
      globalDispatcher.dispatchEvent(new BBBEvent(BBBEvent.OPEN_WEBCAM_WINDOWS));
      
		}
	}
}
