using Toybox.WatchUi;
using Toybox.System;

class NearestStationInputDelegate extends WatchUi.Menu2InputDelegate {
    
    var stationSchedule;

    function initialize(data) {
		Menu2InputDelegate.initialize();
        stationSchedule = data;
    }

    function onBack() {
        System.exit();
    }

    function onSelect(item) {
        var trainLine = stationSchedule.trains[item.getId()][:stations];
		WatchUi.pushView(new TrainLineMenu(trainLine), new WatchUi.Menu2InputDelegate(), WatchUi.SLIDE_LEFT);
    }

    function onFooter() {
		var menu = new WatchUi.Menu2({:title=>"Settings"});
        menu.addItem(
            new MenuItem(
                "Filter",
                "Show only favorites",
                "filterFavorites",
                { :theme=>null }
            )
        );
        WatchUi.pushView(menu, new RenfeHorariosMenuDelegate(), WatchUi.SLIDE_UP);
    }
}