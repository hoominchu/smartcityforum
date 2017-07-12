package smartcity;

import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

/**
 * Created by minchu on 01/07/16.
 */
public class Geolocation {

    private static String[] getDMS(String string) {

        string = string.replaceAll("[^0-9.\\s-]", " ");
        String[] DMS = string.split(" ");

        return DMS;
    }

    public static String getWard(HttpServletRequest request) {
        String latitude = request.getParameter("lat");
        String longitude = request.getParameter("long");

        Boolean locInBoundaries = false;

        String wardBoundariesFilePath = "";

        if (request.getRequestURL().toString().contains(LoadProperties.properties.getString("WebsiteName"))) {
            wardBoundariesFilePath = LoadProperties.properties.getString("WardBoundariesJSONWeb");
        } else {
            wardBoundariesFilePath = LoadProperties.properties.getString("WardBoundariesJSONLocal");
        }

        String wardBoundariesJSON = FileUtil.getFileAsString(wardBoundariesFilePath);

        JSONObject jsonObject = new JSONObject(wardBoundariesJSON);
        JSONArray polygons = jsonObject.getJSONArray("features");

        for (int i = 0; i < polygons.length(); i++) {
            JSONObject polygon = (JSONObject) polygons.get(i);
            JSONObject geometry = polygon.getJSONObject("geometry");

            if (geometry.getString("type").equals("Polygon")) {
                JSONArray vertices = geometry.getJSONArray("coordinates");

                ArrayList<Double> latArray = new ArrayList<>();
                ArrayList<Double> longArray = new ArrayList<>();

                for (int j = 0; j < vertices.length(); j++) {
                    JSONArray locationObjects = vertices.getJSONArray(0);
                    for (int k = 0; k < locationObjects.length(); k++) {
                        String loc = locationObjects.get(k).toString();
                        String[] coordinates = loc.replace("[", "").replace("]", "").split(",");
                        Double lon = Double.parseDouble(coordinates[0]);
                        Double lat = Double.parseDouble(coordinates[1]);

                        latArray.add(lat);
                        longArray.add(lon);
                    }
                }


                Boolean locInPolygon = coordinate_is_inside_polygon(Double.parseDouble(latitude), Double.parseDouble(longitude), latArray, longArray);

                if (locInPolygon) {
                    String ward = polygon.getJSONObject("properties").getString("WardId");
                    return ward;
                }
            }
        }

        return "Location not inside the boundaries";

    }

    private static boolean coordinate_is_inside_polygon(
            double latitude, double longitude,
            ArrayList<Double> lat_array, ArrayList<Double> long_array) {

        double PI = 3.14159265;
        double TWOPI = 2 * PI;

        int i;
        double angle = 0;
        double point1_lat;
        double point1_long;
        double point2_lat;
        double point2_long;
        int n = lat_array.size();

        for (i = 0; i < n; i++) {
            point1_lat = lat_array.get(i) - latitude;
            point1_long = long_array.get(i) - longitude;
            point2_lat = lat_array.get((i + 1) % n) - latitude;
            //you should have paid more attention in high school geometry.
            point2_long = long_array.get((i + 1) % n) - longitude;
            angle += Angle2D(point1_lat, point1_long, point2_lat, point2_long);
        }

        if (Math.abs(angle) < PI)
            return false;
        else
            return true;
    }

    private static double Angle2D(double y1, double x1, double y2, double x2) {
        double PI = 3.14159265;
        double TWOPI = 2 * PI;
        double dtheta, theta1, theta2;

        theta1 = Math.atan2(y1, x1);
        theta2 = Math.atan2(y2, x2);
        dtheta = theta2 - theta1;
        while (dtheta > PI)
            dtheta -= TWOPI;
        while (dtheta < -PI)
            dtheta += TWOPI;

        return (dtheta);
    }

    public static boolean is_valid_gps_coordinate(double latitude,
                                                  double longitude) {
        //This is a bonus function, it's unused, to reject invalid lat/longs.
        if (latitude > -90 && latitude < 90 &&
                longitude > -180 && longitude < 180) {
            return true;
        }
        return false;
    }

    public static String convertDegreetoDecimal(String degreeString, String direction) {
        Double decimal;

        String[] DMS = getDMS(degreeString);

        for (int i = 0; i < DMS.length; i++) {
            DMS[i] = DMS[i].replace("-", "");
        }

        Double degrees = Double.parseDouble(DMS[0]);
        Double minutes = Double.parseDouble(DMS[2]);
        Double seconds = Double.parseDouble(DMS[4]);

        decimal = degrees + (minutes / 60) + (seconds / (60 * 60));

        if (direction.equalsIgnoreCase("s") || direction.equalsIgnoreCase("w")) {
            decimal = decimal * -1;
        }

        return decimal.toString();
    }
}
