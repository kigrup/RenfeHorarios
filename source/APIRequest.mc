using Toybox.Application;
using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.Position;
using Toybox.Time;

class APIRequest {

	//var endpoint = "https://serveisgrs.rodalies.gencat.cat/api/departures?lang=es&fullResponse=true&stationId=";
	var endpoint = "https://script.google.com/macros/s/AKfycbwNgRh0rtHLaCgKtgCrgU7w_l4Kmnk5DzrANEJsuroXfn2EcD-yyCcEY-CaOVx-FZFP/exec?stationId=";

	var notify;
	var position as Position.Location;

	var stationId;

	function initialize(handler, positionLocation as Position.Location) {
		notify = handler;
		position = positionLocation;

		stationId = Stations.getNearestStation(position);
        Application.Properties.setValue("lastStation", stationId);

		endpoint += stationId;
	}

	function makeWebRequest() {
		var url = endpoint;
		var callback = :onReceiveResponse;
		var parameters = {};
		var options = {
			:method => Communications.HTTP_REQUEST_METHOD_GET,
			:headers => {
					"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
			},
			:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
		};

		Communications.makeWebRequest(
			url,
			parameters,
			options,
			method(callback)
		);
	}

	function onReceiveResponse(responseCode, data) {
		//System.println("APIRequest::onReceiveResponse: responseCode=" + responseCode.toString());
		if (responseCode == 200) {
			var stationSchedule = parseResponse(data);
			WatchUi.pushView(new NearestStationMenu(stationSchedule, position), new NearestStationInputDelegate(stationSchedule), WatchUi.SLIDE_LEFT);
		} else {
			if (responseCode == -104) {
				notify.invoke("Not connected to phone\nTurn on BT and try again");
			} else if (responseCode == -402) {
				notify.invoke("Stops response\ntoo large");
			} else {
				notify.invoke(responseCode.toString() + "\nonReceiveResponse");
			}
		}
	}

	function parseResponse(data) as StationSchedule {
        var filterFavorites = Application.Properties.getValue("filterFavoriteStations");
        var favoriteStationA = Application.Properties.getValue("favoriteStationA");
        var favoriteStationB = Application.Properties.getValue("favoriteStationB");

		var trains = [];
		for (var trainIndex = 0; trainIndex < data["trains"].size(); trainIndex++) {
			var train = data["trains"][trainIndex];
			//System.println("parseResponse: train[" + trainIndex + "] " + train.toString());
			if (!filterFavorites || true) {
				var trainStations = [];
				for (var stationIndex = 0; stationIndex < train["stations"].size(); stationIndex++) {
					var station = train["stations"][stationIndex];
					trainStations.add({
						:stationId => station["i"],
						:stationName => data["st"][station["i"]],
						:departureDatetime => station["t"].substring(11, 16),
						:platform => station["p"],
					});
				}
				trains.add({
					:departureMoment => parseDatetime(train["t"]),
					:platform => train["p"],
					:trainType => train["ty"],
					:line => train["l"],
					//:originStationId => train["originStation"]["id"],
					//:originStationName => train["originStation"]["name"],
					:destinationStationId => train["did"],
					:destinationStationName => data["st"][train["did"]],
					:destinationStationAbbreviation => Stations.abbreviateName(data["st"][train["did"]]),
					:stations => trainStations
				});
			}
		}
		var schedule = new StationSchedule();
		schedule.stationId = data["id"];
		schedule.timestamp = data["t"];
		schedule.trains = trains;
		return schedule;
    }

	function parseDatetime(textDatetime) { // 2024-11-25T21:28:00
		var moment = Time.Gregorian.moment({
			:year => textDatetime.substring(0, 4).toNumber(),
			:month => textDatetime.substring(5, 7).toNumber(),
			:day => textDatetime.substring(8, 10).toNumber(),
			:hour => textDatetime.substring(11, 13).toNumber(),
			:minute => textDatetime.substring(14, 16).toNumber(),
			:second => textDatetime.substring(17, 19).toNumber(),
		});
		return moment;
	}
}