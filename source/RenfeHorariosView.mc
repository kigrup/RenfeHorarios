import Toybox.Graphics;
import Toybox.WatchUi;

class RenfeHorariosView extends WatchUi.View {

    hidden var message;

    var swipeDownBitmapResource;
    var tapBitmapResource;

    function initialize() {
        View.initialize();
        message = "Loading...";
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        swipeDownBitmapResource = Application.loadResource(Rez.Drawables.SwipeDown);
        tapBitmapResource = Application.loadResource(Rez.Drawables.Tap);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        // Draw top message
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawBitmap(-15 + dc.getWidth()/2, 0, tapBitmapResource);
        dc.drawText(dc.getWidth()/2, 50, Graphics.FONT_XTINY, "Last station", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw middle message
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_SMALL, message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw bottom message
        /* var transform = new AffineTransform();
        transform.rotate(180.0);
        dc.drawBitmap2(-15 + dc.getWidth()/2, dc.getHeight()-25, swipeDownBitmapResource, {
            :transform => transform
        }); */
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
		    WatchUi.requestUpdate();
		}
	}

    function openNearestStationMenu() {
        //WatchUi.pushView(new NearestStationMenu(), delegate, transition);
    }
}
