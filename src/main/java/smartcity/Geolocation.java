package smartcity;

/**
 * Created by minchu on 01/07/16.
 */
public class Geolocation {

    private static String[] getDMS(String string) {

        string = string.replaceAll("[^0-9.\\s-]", " ");
        String[] DMS = string.split(" ");

        return DMS;
    }

    public static String convertDegreetoDecimal(String degreeString, String direction) {
        Double decimal;

        String[] DMS = getDMS(degreeString);

        for (int i = 0; i<DMS.length; i++) {
            DMS[i] = DMS[i].replace("-","");
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
