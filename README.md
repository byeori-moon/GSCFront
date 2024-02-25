# PENGY

<img width="50%" src="https://github.com/GDSC-CAU/Pengy-FE/assets/100814191/8c5541e2-5338-432a-b7b5-b474b9207dbf"/>

## UN's Sustainable Development 
### Goal 11. Sustainable Cities and Communities

### Solution
In modern society, many fire-related issues arise due to ignorance and carelessness. Our app aims to address these problems by introducing a highly unique approach to space management.

To tackle this issue, we have structured the app around managing one's space. The main functionality of the app is to construct one's space and place various objects within it.

During this process, we identify objects that pose a fire hazard for placement. Through this, users must use the camera to identify and register objects with fire hazards while constructing their space. In doing so, users become aware of fire-hazardous objects and receive information about the various problems associated with them and their solutions. Based on the provided solutions, users' perception shifts from ignorance to awareness and preparedness.


## How to run
**Front-End**
[Click to download a releaed apk](https://github.com/GDSC-CAU/Pengy-FE/releases/download/Pengy-v0.1/app-release.apk). To install this, you need to able downloading an app from unknown sources.

or

using flutter
1. Clone this project
```bash
    git clone https://github.com/GDSC-CAU/Pengy-FE.git
```
2. Set .env in root project
```bash
  MAP_KEY=*Put your Google Maps API KEY*
```
3. Set local.properties in root project/android/local.properties
```bash
  google.map.key=*Put your Google Maps API KEY*
```
4. Run with Android Studio

[**Back-End**]
[click to redirect to Back-End repository](https://github.com/GDSC-CAU/Pengy-BE).
1. Clone this project
```bash
    git clone https://github.com/GDSC-CAU/Pengy-BE.git
```
2. Create a Python virtual environmen
```bash
    python -m venv venv
    ./venv/scripts/activate
```
3. Install dependencies and start the server.
```bash
    pip install -r requirements.txt
    python manage.py runserver
```

[**AI**]
[click to redirect to AI repository](https://github.com/GDSC-CAU/Pengy-AI).
This is a repository containing Jupyter notebooks used for training AI.

## Used open source
https://github.com/scholarly-python-package/scholarly

## Team
|Janghyeon Park (Leader)|Sunbin Do|Byeori Moon|Junhyung Park|
|:---:|:---:|:---:|:---:|
|Back-End/AI|	AI/Back-End|Front-End/Design|Front-End/AI|
|[park-janghyeon](https://github.com/park-janghyeon)|[typingmistake](https://github.com/typingmistake)|[byeori-moon](https://github.com/byeori-moon)|[DogJHDOG](https://github.com/DogJHDOG/)|

