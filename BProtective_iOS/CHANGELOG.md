# Changelog

All notable changes to this project will be documented in this file.

## [SPRINT 1] - 2020-9-28 

### Added 
** Majority of pages are about UI **
- Landing page
- Login Page (User & Authority)
- Signup Page
- Main user page (User & Authority)
- Bond with user page
- List of Bonds page
- Bond Setting Privacy pagee
- Chat with Bond page
- Alarm List page
- Settings page (User & Authority)


### Changed

- None

### Removed

- None

## [SPRINT 2] - 2020-10-19 

### Added 
- Add backend functionalities for Login page
- Add backend functionalities for Bonding page
- Add backend functionalities for Main page
- Add backend functionalities for Setting (Password Changing)

### Changed

- None

### Removed

- None

## [SPRINT 3] - 2020-11-16 

### Added 
- Allows users to see Emergency alarm around
- Allows users to delete bonds
- Wire bonding functionality with front-end usability (Colin)

### Changed

- Cleanup existing front-end work on the login and signup page (Colin)
- Apply correct color scheme and logo to the launch screen page (Colin)

### Removed

- None

## [SPRINT 4] - 2020-12-07

### Added
- Authority can change their Passwords and get their current locations (Basic functionalities)
- Authority can see the list of all emergency alarms.
- When authority click on an alarm on the list, a map will display and show the path toward the alarm.
- Authority can pull to refresh the emergency alarm list.
- Authority main page which allows them to get their current location, see alarms around and set their statuses (Online, Offline)

### Changed
- Can now remove Bonds from both sides

### Removed
- None

## [SPRINT 5] - 2020-1-04

### Added

### Changed
- Bug Fixes

### Removed
- None

## [SPRINT 6] - 2020-2-21

### Added
- Bond Privacy Setting :
1. Extreme : View Bonds despite Status
2. Moderate: View Bonds only if that person is Feeeling Unsafe or in Emergency
3. Private: View Bonds only if that person is in Emergency
### Changed
- Bug Fixes

### Removed
- None

## [SPRINT 7] - 2020-3-17

### Added
- None

### Changed
- Bug Fixes (2 hours) - Display Bonds Privacy gone wrong
- Minor fixes (25 Issues - 5 hours) - Enhance and trying to remove things as suggested in XCode

### Removed
- None

## [SPRINT 8] - 2020-4-3

### Added
- Normal & Authority User: Add a slider on Map to narrow down restricted distances.
- Authority User: Add a slider at List of Emergency to narrow down emergency alarms.
- Differentiate the color of Unsafe (yellow) and Emergency (red).
- Added error handling refresh if user clicks initiate bond or link bond so the error message does not persist across views (Colin)
Fixed grammatical sentences and errors on BondUserView storyboard
- Applied consistent color scheme to entire project using application scheme file (Colin)
- Created loading icons to notify user when they login or signup that the connection is querying (Colin)
- Added BProtective logo to appropriate pages and project asset folder (Colin)
- The user input field on the BondUserView storyboard will now clear itself after a successful or unsuccessful bond
- Added activity indicator on ChangePassword storyboard so user will have an indicator telling them the application is speaking to the server (Colin)
- Added custom error handler for changing password; if user old password is the same as the new password the application will return an error until the user corrects it (Colin)
- Added custom error handler for if user does not enter anything when changing password, will display an error with relevant message (Colin)
- Added custom async DispatchQueue to handle activity indicator loading on the BondDisplayViewController, this will add a 2 second load timer to the retrieval and display of results (Colin)
- Added custom code to handle not sending server requests when user is trying to select an already applied privacy permission in the BondDisplayViewController. (Colin) 

### Changed
- Minor fixes (85 issues  - 6 hours) - Enhance and trying to remove things as suggested in XCode
- Bug Fixed : Cannot Login after Logout
- Bug Fixed : Refresh will remove Old alarms and add New alarms (did not delete properly before)
- Bug Fixed : Unable to load multiple alarms 
- Altered bond code return error functionality to be more ambiguous; In its current state the error will always return “You cannot bond to yourself” even if the user enters a completely random bond code. (Colin)
- Adjusted UI layout on BondUserView storyboard to be more user-friendly and aesthetically appealing/consistent with overall design (Colin)

### Removed
- Push Notification as we have to pay for Apple ID cost $100/ 
