package smartcity;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Created by minchu on 11/07/17.
 */
public class FileUtil {

    public static String getFileAsString(String filepath) {

        BufferedReader br = null;
        FileReader fr = null;

        String fullfile = "";

        try {

            fr = new FileReader(filepath);
            br = new BufferedReader(fr);

            String sCurrentLine;

            br = new BufferedReader(new FileReader(filepath));

            while ((sCurrentLine = br.readLine()) != null) {
                //sCurrentLine = sCurrentLine.replace(" ","");
                fullfile = fullfile.concat(sCurrentLine);
            }

        } catch (IOException e) {

            e.printStackTrace();

        } finally {

            try {

                if (br != null)
                    br.close();

                if (fr != null)
                    fr.close();

            } catch (IOException ex) {

                ex.printStackTrace();

            }
        }

        return fullfile;
    }
}
