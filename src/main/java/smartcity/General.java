package smartcity;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.Locale;

/**
 * Created by minchu on 15/04/16.
 */
public class General {

    public static String capitalizeFirstLetter(String input) {
        return input.substring(0, 1).toUpperCase() + input.substring(1);
    }

    /**
     * Decides which language description should be displayed based on the language chosen by the user.
     *
     * @param languageParameter
     * @param workDescriptionEnglish
     * @param workDescriptionKannada
     * @return
     */
    public static String setWorkDescriptionFinal(String languageParameter, String workDescriptionEnglish, String workDescriptionKannada) {

        String workDescriptionFinal = null;

        if (languageParameter == null || languageParameter.equals("english")) {
            if ((workDescriptionEnglish.length() > 2) || workDescriptionKannada.equals("null") || workDescriptionKannada == null) {
                workDescriptionFinal = workDescriptionEnglish;
            } else {
                workDescriptionFinal = workDescriptionKannada;
            }
        } else if (languageParameter.equals("kannada")) {
            workDescriptionFinal = workDescriptionKannada;
        }

        workDescriptionFinal = cleanText(workDescriptionFinal);
        return workDescriptionFinal;
    }

    /**
     * Generates the basic dynamic link given the URL request and FILTERS set.
     */
    public static String genLink() {

        String baseLink = "";

        Iterator filtersIter = Filter.FILTERS.iterator();
        String dynamicLink = baseLink;

        while (filtersIter.hasNext()) {
            Filter call = (Filter) filtersIter.next();

            dynamicLink = dynamicLink + call.parameter + "=" + call.parameterValue + "&";
        }

        dynamicLink = dynamicLink.replaceAll("&&", "&");
        dynamicLink = dynamicLink.replace("?&", "?");

        return dynamicLink;
    }

    public static String rupeeFormat(String value) {
        value = value.replace(",", "");
        String decimal = "";
        String negSign = "";

        if (value.contains(".")) {
            decimal = value.substring(value.lastIndexOf("."));
            value = value.replace(decimal, "");
        }

        if (value.startsWith("-")) {
            negSign = "-";
            value = value.replaceFirst("-", "");
        }

        char lastDigit = value.charAt(value.length() - 1);
        String result = "";
        int len = value.length() - 1;
        int nDigits = 0;

        for (int i = len - 1; i >= 0; i--) {
            if (i <= 8) {
                result = value.charAt(i) + result;
                nDigits++;
                if (((nDigits % 2) == 0) && (i > 0)) {
                    result = "," + result;
                }
            }

        }
        return (negSign + result + lastDigit + decimal);
    }

    public static String rupeeFormat(int number) {
        String value = Integer.toString(number);
        value = value.replace(",", "");

        String decimal = "";
        String negSign = "";

        if (value.contains(".")) {
            decimal = value.substring(value.lastIndexOf("."));
            value = value.replace(decimal, "");
        }

        if (value.startsWith("-")) {
            negSign = "-";
            value = value.replaceFirst("-", "");
        }

        char lastDigit = value.charAt(value.length() - 1);
        String result = "";
        int len = value.length() - 1;
        int nDigits = 0;

        for (int i = len - 1; i >= 0; i--) {
            if (i <= 8) {
                result = value.charAt(i) + result;
                nDigits++;
                if (((nDigits % 2) == 0) && (i > 0)) {
                    result = "," + result;
                }
            }
        }
        return (negSign + result + lastDigit + decimal);
    }

    public static Calendar createDate(String dateString) {

        dateString = dateString.substring(0, 6) + "20" + dateString.substring(6);

        Calendar date = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("mm/dd/yyyy");

        try {
            date.setTime(dateFormat.parse(dateString));
        } catch (ParseException e) {
            //e.printStackTrace();
        }

        return date;

    }

    public static String cleanText(String text) {
        if (text.contains(",,")) {
            text = text.replaceAll(",,", "");
            text = text.substring(0, text.length() - 1);
        }
        return text;
    }

    public static String setBillPaidColor(int amountSanctioned, Integer billPaid) {
        String billPaidColor = "green";

        if (billPaid > amountSanctioned) {
            billPaidColor = "red";
        } else if (billPaid == 0) {
            billPaidColor = "black";
        }

        return billPaidColor;
    }

    public static String customSortKeySortTableJS(String dateString) {

        dateString = dateString.substring(0, 7) + "20" + dateString.substring(7);

        DateFormat originalFormat = new SimpleDateFormat("dd-MMM-yyyy", Locale.ENGLISH);
        DateFormat targetFormat = new SimpleDateFormat("yyyyMMdd", Locale.ENGLISH);
        String retString = "";

        try {
            Date date = originalFormat.parse(dateString);
            String formattedDate = targetFormat.format(date);
            retString = formattedDate + "000000";
        } catch (Exception e) {
            //e.printStackTrace();
        }
        return retString;
    }

    public static String setStatusLabelColor(String status) {
        String statusLabelColor;

        if (status.equalsIgnoreCase(LoadProperties.properties.getString("StatusCompleted"))) {
            statusLabelColor = "label-success";
        } else {
            statusLabelColor = "label-danger";
        }

        return statusLabelColor;
    }
}
