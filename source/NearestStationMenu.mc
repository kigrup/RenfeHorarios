using Toybox.WatchUi;
using Toybox.Position;
using Toybox.Time;

class NearestStationMenu extends WatchUi.CustomMenu {
    
    hidden var userPosition;

    function initialize(stationData as StationSchedule, position as Position.Location) {
        userPosition = position;
        CustomMenu.initialize(80, Graphics.COLOR_BLACK, {
            :titleItemHeight=> 100,
            :title=>new WatchUi.Text({
                :text=>"Renfe",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_MEDIUM,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_CENTER
            }),
            :footerItemHeight=> 50,
            :footer=>new WatchUi.Text({
                :text=>"Settings",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_SMALL,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_CENTER
            })
        });

        for (var trainIndex = 0; trainIndex < stationData.trains.size(); trainIndex++) {
            var train = stationData.trains[trainIndex];
            //System.println("NearestStationMenu:: train " + train["destinationStation"].toString());
            CustomMenu.addItem(new CustomMenuItem(
                trainIndex,
                {
                    :drawable=>new NearestStationMenuItemDrawable(
                        train[:destinationStationAbbreviation],
                        train[:departureMoment],
                        train[:platform],
                        userPosition
                    )
                }
            ));
        }
    }
}

class NearestStationMenuItemDrawable extends WatchUi.Drawable {

    var stationName;
    var departureMoment;
    var platform;
    var userPosition;

    var timeLeft;

    function initialize(_stationName, _departureMoment, _platform, _userPosition) {
        Drawable.initialize({
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
            :width=>380,
            :height=>80
        });
        stationName = _stationName;
        departureMoment = _departureMoment;
        platform = _platform;
        userPosition = _userPosition;
        updateLabels(false);
    }

    function updateLabels(redraw) {
        //System.println("NearestStationMenuItemDrawable::updateLabels: ENTER");
        var now = Time.Gregorian.localMoment(userPosition, Time.now());
        var durationDiference = departureMoment.subtract(now.toMoment().add(new Time.Duration(now.getOffset())));
        timeLeft = (durationDiference.value() / Time.Gregorian.SECONDS_PER_MINUTE) + "′";
        if (redraw) {
            WatchUi.requestUpdate();
        }
        //System.println("NearestStationMenuItemDrawable::updateLabels: EXIT");
    }

    function draw(dc) {
        //System.println("NearestStationMenuItemDrawable::draw");
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        // Draw minutes left for departure
        dc.drawText(
            15,
            dc.getHeight() / 2,
            Graphics.FONT_TINY,
            timeLeft,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        // Draw destination name
        dc.drawText(
            75,
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