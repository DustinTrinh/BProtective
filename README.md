# Group_26

## 1. Project Source Code

BProtective source code for both the iOS application and web application can be found at the following link : 
https://github.com/SenecaCollegeBTSProjects/Group_26

## 2. Project Technical Documents

BProtective technical documentation can be found at the following link : https://github.com/SenecaCollegeBTSProjects/Group_26/tree/master/BProtective_Documentations

## 3. Installation Packages

BProtective iOS application requires the following packages:
- https://cocoapods.org
- https://developer.apple.com/xcode/
- https://git-scm.com/downloads

BProtective web application requires the following packages: 
-All Web App packages are listed in 'requirements.txt' under 'BProtective_Web' (Link in Git repo: https://github.com/SenecaCollegeBTSProjects/Group_26/blob/master/BProtective_Web/requirements.txt)

## 4. Installation Instructions

BProtective iOS application:
- Open a new terminal 
- Run the commmand "git clone https://github.com/SenecaCollegeBTSProjects/Group_26.gitæ
- Run the command "cd Group_26/BProtective_iOS"
- Run the command "ls" to view all files and folders in /BProtective_iOS
- If there is a folder called "pods", run the command "rm -rf pods"
- Run the command "pod install"
- Run the command "open BProtective.xcworkspace" and Xcode will open the project BProtective.xcworkspace file
- In Xcode, at the top navigation bar, to the right of the play and stop buttons, select the dropdown menu for IPhone simulators and select "IPhone 11"
- In Xcode click on "Product" at the top, then click on "Build for", then click on "Running"
- Xcode will build the project and run it in an IPhone 11 simulator that will be visible upon completed compiliation 

BProtective web application:
- Install the latest version of python
- In command line run 'git clone https://github.com/SenecaCollegeBTSProjects/Group_26.git'
- Navigate to the 'BProtective_Web' folder ('cd BProtective_Web' in command line)
- In command line run 'pip install --r requirements.txt'
- In command line run 'python login.py'
- Open the link to the local instance in a browser

## 5. A list of deviations from what was proposed in BTR490 - BTS530

BProtective iOS application:
- Removed Chat with Bond functionality
- Removed functions that allow users to change their Name and Email

BProtective web application:
- Removed Activate User functionality
- Removed Add Authority functionality
- Logs aren't created when iOS users perform logged activities 

## 6. A list of known bugs

BProtective iOS application:
- Memory error when scrolling too fast at Authority Alarm list. (Application cannot process the request fast enough)

BProtective web application:
- Entering the URLs to pages that should require users to be logged in to access such as '/home' or '/accounts' will allow access even if the user isn't logged in

## 7. Instructions on how to run the system on Heroku including usernames and required password

BProtective iOS application:
- Visit the following link : https://appetize.io/app/6zxkq7dubjnvw8535gefvwv3qm?device=iphone11promax&scale=75&orientation=portrait&osVersion=13.7
- Press the "Tap to play" button on the IPhone emulator

BProtective web application:
- Visit the following link : https://bprotective-web.herokuapp.com/
- Select 'Login' from the navbar at the top of the screen
- Use the username 'a@a.ca' and the password '123456' for an Admin account
