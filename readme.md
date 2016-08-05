Instructions to set up Smart City Forum
------------------------------------------
1. 	Clone the project from github.

2.	Install MongoDB and Tomcat, if you haven’t already.

3. 	Create a database in MongoDB by the name 'smartcitydb' (You can have a different name but you will have to edit config.properties accordingly).

4. 	Import the csv files to mongo with the following collection names (it is okay if the names are different. You will have to edit config.properties accordingly)--
	
		allworks 
		workdetails
		wardmaster
		billspaid
		minorCodeDetails
		corporators
		workNotes
		authorizedEmails
		superusers

5.	Customise config.properties file.  	

6. 	Build 'war' using 'mvn package'. Copy the '.jar' file from target folder and put it in Tomcat/webapps. 

7.	Create a folder in webapps named 'smartcityData'. 

It might take a few minutes when you hit the 'index.jsp for the first time. 