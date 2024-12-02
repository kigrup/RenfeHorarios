import Toybox.Graphics;
import Toybox.WatchUi;

class RenfeHorariosView extends WatchUi.View {

    hidden var messages;
    hidden var message;

    var swipeDownBitmapResource;
    var tapBitmapResource;

    function initialize() {
        View.initialize();
        message = "Loading...";
    }

    function onShow() as Void {
        swipeDownBitmapResource = Application.loadResource(Rez.Drawables.SwipeDown);
        tapBitmapResource = Application.loadResource(Rez.Drawables.Tap);
        messages = {
            :waitingGPSMessage => Application.loadResource(Rez.Strings.WaitingGPS)
        };
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        // Draw top message
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawBitmap(-15 + dc.getWidth()/2, 0, tapBitmapResource);
        dc.drawText(dc.getWidth()/2, 50, Graphics.FONT_XTINY, "Last station", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw middle message
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_SMALL, message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw bottom message
        dc.drawBitmap(-15 + dc.getWidth()/2, dc.getHeight()-30, swipeDownBitmapResource);
        dc.drawText(dc.getWidth()/2, dc.getHeight()-45, Graphics.FONT_XTINY, "Select station", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function onReceive(args) {
		if (args instanceof Lang.String) {
			message = args;
		} else if (args instanceof Lang.Symbol) {
            if (messages == null) {
                System.println("Messages not initialized");
            }
            message = messages[args];
        }
		WatchUi.requestUpdate();
	}
}
