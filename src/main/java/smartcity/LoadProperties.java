package smartcity;

import java.util.Locale;
import java.util.ResourceBundle;

public class LoadProperties {

    public static ResourceBundle properties = loadProperties();

    private static ResourceBundle loadProperties () {
        ResourceBundle resourceBundle = null;
        try {
            Locale locale = new Locale("en", "US");
            resourceBundle = ResourceBundle.getBundle("config", locale);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return resourceBundle;
    }
}
