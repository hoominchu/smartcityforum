package smartcity;

import com.drew.imaging.ImageMetadataReader;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;

import java.io.File;

/**
 * Created by minchu on 01/07/16.
 */
public class ExifExtractor {


    public static String[] getGPSCoordinatesOfJPEG(File file) {
        String[] gpsCoordinates = {"", "", "", ""};

        try {
            Metadata metadata = ImageMetadataReader.readMetadata(file);

            for (Directory directory : metadata.getDirectories()) {
                for (Tag tag : directory.getTags()) {
                    //System.out.println(tag.toString());
                    if (tag.toString().toLowerCase().contains("gps")) {
                        //System.out.println(tag.toString());
                        if (tag.toString().contains("GPS Latitude Ref")) {
                            gpsCoordinates[0] = tag.toString().substring(tag.toString().indexOf("-") + 2).replace("\"", "");
                        }
                        if (tag.toString().contains("GPS Latitude") && !tag.toString().toLowerCase().contains("ref")) {
                            gpsCoordinates[1] = tag.toString().substring(tag.toString().indexOf("-") + 2).replace("\"", "");
                        }
                        if (tag.toString().contains("GPS Longitude Ref")) {
                            gpsCoordinates[2] = tag.toString().substring(tag.toString().indexOf("-") + 2).replace("\"", "");
                        }
                        if (tag.toString().contains("GPS Longitude") && !tag.toString().toLowerCase().contains("ref")) {
                            gpsCoordinates[3] = tag.toString().substring(tag.toString().indexOf("-") + 2).replace("\"", "");
                        }
                    }
                }
            }

            // get tag description
        } catch (Exception e) {
            System.out.println("Error in ExifExtractor.java");
            System.out.println("Message : " + e.getMessage());
            System.out.println("Cause : " + e.getCause());
            e.printStackTrace();
        } finally {
            return gpsCoordinates;
        }
    }

    public static String getLastModifiedDateNTime(File file) {
        String uploadDateNTime = "";

        try {
            Metadata metadata = ImageMetadataReader.readMetadata(file);

            for (Directory directory : metadata.getDirectories()) {
                for (Tag tag : directory.getTags()) {
                    //System.out.println(tag.toString());
                    if (tag.toString().toLowerCase().contains("modified date")) {
                        //System.out.println(tag.toString());
                        uploadDateNTime = tag.toString().substring(28,38) + " " + tag.toString().substring(tag.toString().length()-4) + " at " + tag.toString().substring(39,44);
                    }
                }
            }

            // get tag description
        } catch (Exception e) {
            System.out.println("Error in ExifExtractor.java");
            System.out.println("Message : " + e.getMessage());
            System.out.println("Cause : " + e.getCause());
            e.printStackTrace();
        } finally {
            return uploadDateNTime;
        }
    }
}
