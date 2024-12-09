class StationSchedule {
    var stationId;
    var timestamp;
    var trains;

    function toString() {
        return "{ stationId: " + stationId +", timeStamp: " + timestamp + ", trains: [...]}";
    }
}