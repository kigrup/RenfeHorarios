using Toybox.WatchUi;
using Toybox.Position;
using Toybox.Time;

class TrainLineMenu extends WatchUi.CustomMenu {
    
    function initialize(trainStations) {
        CustomMenu.initialize(80, Graphics.COLOR_BLACK, {});

        for (var stationIndex = 0; stationIndex < trainStations.size(); stationIndex++) {
            var station = trainStations[stationIndex];
            var platform = null;
            if (station has :platform) {
                platform = station[:platform];
            }
            CustomMenu.addItem(new CustomMenuItem(
                stationIndex,
                {
                    :drawable=>new TrainLineMenuItemDrawable(
                        station[:departureDatetime],
                        station[:stationName],
                        platform
                    )
                }
            ));
        }
    }
}

class TrainLineMenuItemDrawable extends WatchUi.Drawable {

    var departureTime;
    var stationName;
    var platform;

    function initialize(_departureTime, _stationName, _platform) {
        Drawable.initialize({
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
            :width=>380,
            :height=>80
        });

        departureTime = _departureTime;
        stationName = _stationName;
        if (_platform != null) {
            platform = _platform;
        }
    }

    function draw(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        // Draw minutes left for departure
        dc.drawText(
            10,
            dc.getHeight() / 2,
            Graphics.FONT_TINY,
            departureTime,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        // Draw station name
        dc.drawText(
            100,
            dc.getHeight() / 2,
            Graphics.FONT_TINY,
            stationName,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        // Draw plaform number
        if (platform != null){
            dc.drawText(
                350,
                dc.getHeight() / 2,
                Graphics.FONT_TINY,
                platform,
                Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
        
    }
}