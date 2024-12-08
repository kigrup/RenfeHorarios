import Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Position;
using Toybox.System;

class RenfeHorariosView extends WatchUi.View {

    public var localizationInitialized = false;
    hidden var messages;
    hidden var message;
    enum {
        WAITING_GPS,
        REQUESTING_SCHEDULES,
        LAST_STATION,
        SELECT_STATION
    }

    var swipeDownBitmapResource;
    var tapBitmapResource;

    var lastStation;
    var lastStationName;

    function initialize() {
        View.initialize();
        message = "Loading...";
        var lastStation = Application.Properties.getValue("lastStation");
        System.println("last station: ");
        System.println(lastStation);
        if (lastStation != null && lastStation == "") {
            System.println("lastStation not null nor empty");
            lastStationName = Stations.abbreviateName(Stations.byId[lastStation][:name]);
        }
    }

    function loadMessages() {
        messages = [
            Application.loadResource(Rez.Strings.WaitingGPS),
            Application.loadResource(Rez.Strings.RequestingSchedules),
            Application.loadResource(Rez.Strings.LastStation),
            Application.loadResource(Rez.Strings.SelectStation)
        ];
    }

    function onShow() as Void {
        swipeDownBitmapResource = Application.loadResource(Rez.Drawables.SwipeDown);
        tapBitmapResource = Application.loadResource(Rez.Drawables.Tap);
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Draw top message
        if (lastStation != null && lastStation != "") {
            dc.drawBitmap(-15 + dc.getWidth()/2, 0, tapBitmapResource);
            dc.drawText(dc.getWidth()/2, 50, Graphics.FONT_XTINY, messages[LAST_STATION], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(dc.getWidth()/2, 80, Graphics.FONT_XTINY, lastStationName, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        // Draw middle message
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_SMALL, message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw bottom message
        dc.drawBitmap(-15 + dc.getWidth()/2, dc.getHeight()-30, swipeDownBitmapResource);
        dc.drawText(dc.getWidth()/2, dc.getHeight()-45, Graphics.FONT_XTINY, messages[SELECT_STATION], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function onReceive(args) {
		if (args instanceof Lang.String) {
			message = args;
		} else if (args instanceof Number) {
            if (!localizationInitialized) {
                localizationInitialized = true;
                loadMessages();
            }
            message = messages[args];
        }
		WatchUi.requestUpdate();
	}
}

class RenfeHorariosViewDelegate extends WatchUi.BehaviorDelegate {

	var notify;
	var gpsReady;
	//var positionInfo;
	var APIRequestInstance;

	function initialize(handler) {
		BehaviorDelegate.initialize();
		notify = handler;
		gpsReady = false;
		notify.invoke(RenfeHorariosView.WAITING_GPS);
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
			notify.invoke(RenfeHorariosView.REQUESTING_SCHEDULES);
			APIRequestInstance.makeWebRequest();
			gpsReady = true;
		}
	}
}