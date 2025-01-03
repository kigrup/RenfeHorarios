using Toybox.WatchUi;
using Toybox.System;

class SelectStationDelegate extends WatchUi.Menu2InputDelegate {
    
    hidden var onSelectMethod;

    function initialize(onSelect) {
        Menu2InputDelegate.initialize();
        onSelectMethod = onSelect;
    }

    function onSelect(item) {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        onSelectMethod.invoke(item.getId());
    }
}