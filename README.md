# **Yellow Class Assessment**

**Functionalities included:**

 - Login
	 - Google Account
	 - Phone Number
 - Videos List
	 - Can add videos from Firebase Console
	 - Make sure they are of *https* format
	 - Supports full screen video mode.
 - Camera Preview
	 - Can move the camera preview widget around on the screen, while the video is playing
	 - Currently supports ***Portrait*** mode and ***Landscape Left*** mode.
 - Volume Controls
	- Contains a Volume Slider which increases/decreases the volume
- Cache Safety
	- User's basic info is stored in cache and Firebase Firestore
	- If cache is cleared, the data is retrieved from Firestore

**Technical Specifications:**
- Used GetX for State Management.
- Used Hive for Cache Management
- Used Chewie for video rendereing
- Used Firebase for Authentication and Database

## **Demo:**

![yellow_class gif](/demo/demo.gif)
