import Toybox.Application;
import Toybox.Lang;
import Toybox.Position;
import Toybox.WatchUi;

class RenfeHorariosApp extends Application.AppBase {

    var mainView;
    var mainViewDelegate;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
		mainView = new RenfeHorariosView();
        mainViewDelegate = new RenfeHorariosViewDelegate(mainView.method(:onReceive));
        return [ mainView, mainViewDelegate ];
    }

}

function getApp() as RenfeHorariosApp {
    return Application.getApp() as RenfeHorariosApp;
}