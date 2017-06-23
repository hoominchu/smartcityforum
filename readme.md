Instructions to set up Smart City Forum
------------------------------------------
1. 	Clone the project from github.

2.	Install MongoDB and Tomcat, if you haven’t already and start both the services.

3. 	Rename the data (csv) files with the following names accordingly:
		allworks.csv
		workdetails.csv
		wardmaster.csv
		billspaid.csv
		minorcodedetails.csv
		corporators.csv
		authorizedemails.csv
		superusers.csv
	Put all the csv files in one folder.

4. 	Run the shell script and provide with the directory of the folder containing all csv files when prompted.

5.	Customise config.properties file.  	

6. 	Build 'war' using 'mvn package'. Copy the '.jar' file from target folder and put it in Tomcat/webapps. 

7.	Create a folder in webapps named 'smartcityData'. 

Customizations can be done by editing 'src/main/resources/config.properties' file. 