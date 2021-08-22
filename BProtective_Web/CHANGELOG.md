# Changelog

All notable changes to this project will be documented in this file.

## [SPRINT 1] - 2020-9-28 

### Added 
** Majority of pages are about UI **
- Templates for the layout
- Landing page
- Login Page (User)
- Main user page (User)
- Analyze alarms page
- User Logs
- View accounts


### Changed

- None

### Removed

- None

## [SPRINT 2] - 2020-10-17

### Added 

- Backend for creating, getting, and deleting alarms
- Functionality to load alarms onto analyze alarms page


### Changed

- None

### Removed

- None


## [SPRINT 3] - 2020-11-16

### Added 

- Functionality to load normalUsers onto the accounts page
- Functionality and backend to ban, unban, and delete normalUsers
- Fuctionality to write users to correct collections when creating an account
- Functionality to get user information for Normal and Authority Users

### Changed

- Added 'Banned' property to normalUser

### Removed

- None


## [SPRINT 4] - 2020-12-7

### Added 

- Backend and database calls for ActivityLogs
- Functionality to load and display Activity Log data on the lgs page in the web view
- Added 'Banned' property to authorityUser

### Changed

- Fixed login functionality to login users based on the collection their information is found in

### Removed

- None

## [SPRINT 1 SEMESTER 2] - 2021-01-26

### Changed Layout of Accounts Page (Author - Jordan Hui)
*Added CSS styling and changed the layout of buttons in the Accounts page [#61](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/61)

### Changed Layout of Analyze Alarms Page (Author - Jordan Hui)
*Added CSS styling and changed the layout of buttons in the Analyze Alarms page [#62](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/62)

### Changed HTML For Analyze Alarms Page in login.py (Author - Jordan Hui)
*Changed the HTML generated in login.py when navigating to the Analyze Alarms page, adding class names and seperating lines [#62](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/62)

### Added static directory with a stylesheet (Author - Jaron Bloom)
*Added "style.css" to update background color of index page, signin and sign up pages[#65](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/65)
*stylesheet updates form placement on sign in and sign up page. [#65](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/65)

### Update Base-two Template (Author - Jaron Bloom)
*Added link to style.css in base-two.html to allow the change to the sign up form to display. [#64](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/64)

### Update Base Template (Author - Jaron Bloom)
*Added link to style.css in base.html to allow the change to the sign in form to display. [#65](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/65)

### Changed HTML For Analyze Alarms Page in login.py (Author - Jordan Hui)
*Changed the HTML generated in login.py when navigating to the Analyze Alarms page, adding class names and seperating lines

## [SPRINT 2 SEMESTER 2] - 2021-02-17

### Moved CSS Styling for the Accounts and AnalyzeAlarms Pages to CSS Files (Author - Jordan Hui)
*Moved the CSS code for the Accounts and AnalyzeAlarms pages from accounts.html and analyzaAlarms.html to static/accounts.css and static/alarms.css respectively

### Changed Layout of Logs Page (Author - Jordan Hui)
*Added CSS styling in static/logs.css and changed the layout of information in the Logs page

### Changed Type of Dates in Database From String to Timestamp (Author - Jordan Hui)
*Changed the type of all dates/times stored in the database from string to timestamp to allow sorting by date for alarms and logs

### Changed Database Call for Alarms (Author - Jordan Hui)
*Changed database call for alarms to sort by date in descending order and to include a filter for the number of alarms to show

### Changed Database Call for Logs (Author - Jordan Hui)
*Changed database call for logs to sort by date in descending order

### Changed HTML For Analyze Alarms Page in login.py (Author - Jordan Hui)
*Changed the HTML generated in login.py when navigating to the Analyze Alarms page, adding a dropdown selector to change the number of alarms displayed on the page

### Add functionality for password reset (Author - Jaron Bloom)
*Add functionality to reset password
*Had technical issues with caused work to be lost. Carrying Addition to SPRINT 3

## [SPRINT 3 SEMESTER 2] - 2021-02-23

### Added Single Marker Functionality for Analyze Alarms Page (Author - Jordan Hui)
*Added functionality to show a single marker on the map in the AnalyzeAlarms page, as well as functionality to display data from the selected alarm and return to that alarm in the list

## [SPRINT 3 SEMESTER 2] - 2021-04-07

### Moved HTML Generation Functions for AnalyzeAlarms, Logs, and Accounts from Login.py to Thier Own Files
*Moved HTML generation functions to their own files to improve readbility of login.py

### Added Functionality to Filter for Alarms Within 50km of a Selected Alarm in the AnalyzeAlarms Page (Author - Jordan Hui)
*Added function that checks if alarms are within 50km of a selected alarm, as well adding buttons to navigate to and from the page that displays alarms that fit those conditions

### Changed URLs for AnalyzeAlarms-Related Queries (Author - Jordan Hui)
*Changed URLs for AnalyzeAlarms Queries to show what condition is being queried (ie: limit on number of alarms, limit on distance)
### Add functionality for password reset (Author - Jaron Bloom)
*Add functionality to reset password through /passwordReset page, allowing the user to updated or change their password through a form. This was worked on through issue [#71](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/71)

### Fix login bug (Author - Jaron Bloom)
*Currently fixing bug allowing users to log in without credentials through issue [#83](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/83). 

## [SPRINT 4 SEMESTER 2]
### Fix login bug (Author - Jaron Bloom)
*Corrected functionality in the routes file "login.py" to ensure the correct information was being pulled from the form fields and compared to the data in the database collection correctly. Issue was reesolved through issue[#83](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/83)

### Update login form for security (Author - Jaron Bloom)
*Updated the login form in the login.html file to ensure that the users information was not displaying in the URL bar upon signing into the web application. Update completed through issue [#90](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/90)

### Fix password functionality (Author - Jaron Bloom)
*Properly tested the functionality once issue #83 was resolved. Fixed the functionality to ensure that emails to reset passwords were sent to the user. Bugg fixed through issue [#91](https://github.com/SenecaCollegeBTSProjects/Group_26/issues/91)
