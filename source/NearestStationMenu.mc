using Toybox.WatchUi;
using Toybox.Position;
using Toybox.Time;
using Toybox.System;

class NearestStationMenu extends WatchUi.CustomMenu {
    
    hidden var userPosition;

    function initialize(stationData as StationSchedule, position as Position.Location) {
        userPosition = position;
        var stationName = Stations.byId[stationData.stationId.toString()][:name];
        CustomMenu.initialize(80, Graphics.COLOR_BLACK, {
            :titleItemHeight=> 100,
            :title => new WatchUi.TextArea({
                :text => stationName,
                :color => Graphics.COLOR_WHITE,
                :font => [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY],
                :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY => WatchUi.LAYOUT_VALIGN_CENTER + 20,
                :width => 280,
                :height => 85,
                :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            }),
            :footerItemHeight => 100,
            :footer => new WatchUi.Text({
                :text => Application.loadResource(Rez.Strings.Settings),
                :color => Graphics.COLOR_WHITE,
                :font => Graphics.FONT_SMALL,
                :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY => WatchUi.LAYOUT_VALIGN_CENTER
            })
        });

        for (var trainIndex = 0; trainIndex < stationData.trains.size(); trainIndex++) {
            var train = stationData.trains[trainIndex];
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

    var stationNameTextArea;
    var platformText;

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

        stationNameTextArea = new WatchUi.TextArea({
            :text => stationName,
            :color => Graphics.COLOR_WHITE,
            :font => [Graphics.FONT_TINY, Graphics.FONT_XTINY],
            :locX => 75,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :width => 260,
            :height => 80,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        });
        if (platform != null) {
            platformText = new WatchUi.Text({
                :text => platform,
                :color => Graphics.COLOR_LT_GRAY,
                :font => Graphics.FONT_TINY,
                :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
                :locX => 350,
                :locY => WatchUi.LAYOUT_VALIGN_CENTER,
                :width => 30,
                :height => 80
            });
        }
    }

    function updateLabels(redraw) {
        var now = Time.Gregorian.localMoment(userPosition, Time.now());
        var durationDiference = departureMoment.subtract(now.toMoment().add(new Time.Duration(now.getOffset())));
        timeLeft = (durationDiference.value() / Time.Gregorian.SECONDS_PER_MINUTE) + "′";
        if (redraw) {
            WatchUi.requestUpdate();
        }
    }

    function draw(dc) {
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
        stationNameTextArea.draw(dc);
        // Draw plaform number
        if (platform != null){
            platformText.draw(dc);
        }
        
    }
}