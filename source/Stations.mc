using Toybox.Position;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;
using Toybox.System;
using Toybox.Lang;

class Stations {
    static const byId = {
        "71600" => {
            :name => "Sant Vicenç de Calders",
            :latitude => 41.1861,
            :longitude => 1.5246
        },
        "71601" => {
            :name => "Calafell",
            :latitude => 41.1894,
            :longitude => 1.5749
        },
        "71602" => {
            :name => "Segur de Calafell",
            :latitude => 41.1924,
            :longitude => 1.6064
        },
        "71603" => {
            :name => "Cunit",
            :latitude => 41.1948,
            :longitude => 1.6320
        },
        "71604" => {
            :name => "Cubelles",
            :latitude => 41.2041,
            :longitude => 1.6759
        },
        "71700" => {
            :name => "Vilanova i la Geltrú",
            :latitude => 41.2202,
            :longitude => 1.7308
        },
        "71701" => {
            :name => "Sitges",
            :latitude => 41.2392, 
            :longitude => 1.8096
        },
        "71705" => {
            :name => "Castelldefels",
            :latitude => 41.2787,
            :longitude => 1.9793
        },
        "71706" => {
            :name => "Gavà",
            :latitude => 41.3031,
            :longitude => 2.0104
        },
        "71709" => {
            :name => "Viladecans",
            :latitude => 41.3092,
            :longitude => 2.0274
        },
        "71801" => {
            :name => "Barcelona-Sants",
            :latitude => 41.3792,
            :longitude => 2.1403
        },
        "71802" => {
            :name => "Barcelona-Passeig de Gràcia",
            :latitude => 41.3920,
            :longitude => 2.1653
        },
        "79400" => {
            :name => "Barcelona-Estació de França",
            :latitude => 41.3843,
            :longitude => 2.1854
        }
    };

    static function abbreviateName(name) {
        switch (name) {
            case "Sant Vicenç de Calders":      return "St. Vicenç";
            case "Calafell":                    return "Calafell";
            case "Segur de Calafell":           return "Segur de Calafell";
            case "Cunit":                       return "Cunit";
            case "Cubelles":                    return "Cubelles";
            case "Vilanova i la Geltrú":        return "Vilanova";
            case "Sitges":                      return "Sitges";
            case "Castelldefels":               return "Castelldefels";
            case "Gavà":                        return "Gavà";
            case "Viladecans":                  return "Viladecans";
            case "Barcelona-Sants":             return "Bcn. Sants";
            case "Barcelona-Passeig de Gràcia": return "Bcn. Passeig";
            case "Barcelona-Estació de França": return "Barcelona";
            default: return name;
        }
    }

    static function getNearestStation(position as Position.Location) {
        var closestStationId = "";
        var closestDistance = 999999;
        for (var stationIndex = 0; stationIndex < byId.size(); stationIndex++) {
            var stationId = byId.keys()[stationIndex];
            var distance = getDistance(position, [ byId[stationId][:latitude], byId[stationId][:longitude] ]);
            if (closestDistance > distance) {
                closestStationId = stationId;
                closestDistance = distance;
            }
        }
        //System.println("Stations::getNearestStation: returning " + byId[closestStationId][:name]);
        return closestStationId;
    }

    static function getDistance(origin as Position.Location, latitudeLongitude as Lang.Array) as Lang.Double {
        var originDegrees = origin.toDegrees();
        var latitudeDelta = latitudeLongitude[0] - originDegrees[0];
        var longitudeDelta = latitudeLongitude[1] - originDegrees[1];
        return Math.sqrt((latitudeDelta * latitudeDelta) + (longitudeDelta * longitudeDelta));
    }

    static function getMenuItems() {
        var values = [];
        for (var i = 0; i < byId.size(); i++) {
            var stationId = byId.keys()[i];
            var name = byId[stationId][:name];
            values.add(new WatchUi.MenuItem(
                name,
                "",
                stationId,
                {}
            ));
        }
        return values;
    }
}