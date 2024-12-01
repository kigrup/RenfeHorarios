using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Position;
using Toybox.WatchUi;
using Toybox.System;

class RenfeHorariosViewDelegate extends WatchUi.BehaviorDelegate {

	var notify;
	var gpsReady;
	//var positionInfo;
	var APIRequestInstance;

	function initialize(handler) {
		BehaviorDelegate.initialize();
		notify = handler;
		gpsReady = false;
		notify.invoke("Waiting\nfor GPS...");
		Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
	}

	function onMenu() {
		System.println("RenfeHorariosViewDelegate::onMenu");
        return true;
    }

	function onSelect() {
		System.println("RenfeHorariosViewDelegate::onSelect");
		return true;
	}

	function onPreviousPage() {
		System.println("RenfeHorariosViewDelegate::onPreviousPage");
		return true;
	}

	function onPosition(info as Position.Info) as Void {
		//positionInfo = position;
		if (gpsReady == false) {
			APIRequestInstance = new APIRequest(notify, info);
			notify.invoke("Requesting\nschedules...");
			APIRequestInstance.makeWebRequest();
			gpsReady = true;
		}
	}
}