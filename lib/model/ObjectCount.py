import schedule 
import os
import time 
import numpy as np
import cv2
from ultralytics import YOLO
from keras.models import load_model  # TensorFlow is required for Keras to work
import math


from firebase_admin import firestore
#credentials.Certificate
cred = "lib\model\hima-front-end-firebase-adminsdk-ilbe6-21df361235.json"
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = cred
#firebase_admin.initialize_app(cred)


db = firestore.Client()

# Disable scientific notation for clarity // keras
np.set_printoptions(suppress=True)

# Load the models
TMmodel = load_model(r"U:\GithubRepos\Hima-Front-End\lib\model\keras_model.h5", compile=False)
#YOLOmodel=YOLO('yolov8l') #to be deleted
YOLOmodel=YOLO(r"U:\GithubRepos\Hima-Front-End\lib\model\YOLOv8L(368).pt") #Loading our custom model

# Load the labels
class_names = ["Normal", "Crowd"]
#open("labels.txt", "r").readlines()

#Open camera source/s
IMAGE_SOURCE1=cv2.VideoCapture("assets/videos/Arafah.mp4")
IMAGE_SOURCE2=cv2.VideoCapture("assets/videos/Arafah(2).mp4")
IMAGE_SOURCE3=cv2.VideoCapture("assets/videos/Haram.mp4") #C:\Users\Hala's Laptop\Documents\YOLOv8 Everything\YOLOv8 Custom\
IMAGE_SOURCE4=cv2.VideoCapture(0)

sources_array=[IMAGE_SOURCE1,IMAGE_SOURCE2,IMAGE_SOURCE3,IMAGE_SOURCE4]

# creating a dictionary (Area : Officers)
areas = {
    "Zone-A": 50, 
    "Zone-B": 50,
    "Zone-C": 50,
    "Zone-D": 50
}

#Method to predict number of heads in a single frame
def predict(IMAGE_SOURCE):
    sucess, frame = IMAGE_SOURCE.read()

    if sucess:
        results=YOLOmodel(frame)
        count=len(results[0].boxes)

    return count

#Mathod to predict status: crowded or not
def crowd_status(IMAGE_SOURCE):
    success, frame = IMAGE_SOURCE.read()

    if success:
        # Resize the raw image(frame) into (224-height,224-width) pixels
        frame = cv2.resize(frame, (224,224), interpolation=cv2.INTER_AREA)
        # Make the image(frame) a numpy array and reshape it to the models input shape.
        frame = np.asarray(frame, dtype=np.float32).reshape(1, 224, 224, 3)
        # Normalize the image(frame) array
        frame = (frame / 127.5) - 1

        # Predicts the model
        prediction = TMmodel.predict(frame)

        index = np.argmax(prediction)
        class_name = class_names[index] #Can be omitted
        confidence_score = prediction[0][1] #Only get Crowd class prediction

        if confidence_score >= 0.9:
            return True
    
    return  True

#Method to redistribute officers if an area is crowded
def redistribute(): 

    areas_crowd_count=[] #Takes count of heads detected per image source
    areas_status=[] #Takes crowd classification per image source

    for i in sources_array:
        count_heads=predict(i) #Heads count INT value
        status=crowd_status(i) #Crowded or not BOOLEAN value

        areas_crowd_count.append(count_heads)
        areas_status.append(status)

    my_formatter = "{0:.2f}"
    
    areas_crowd_count_perc=[] #Takes converted head counts to percentage out of 100
    for i in areas_crowd_count:
        areas_crowd_count_perc.append(i/sum(areas_crowd_count)) #Calculate crowd percentage for each area
    
    officers_sum=200  #200 Sum of all available officers

    if (True) in areas_status:
        for index, area in enumerate(areas):
            areas[area]=round(areas_crowd_count_perc[index]*officers_sum)

            firestore_current = db.collection("redistribution").document("current")
            # Set the capital field
            firestore_current.set(areas)
        
        print(areas) # ,areas_status

    
    #Testing purposes only!!!!!!!!!!!!!!!!!!!
    
    else:
        print("No area is crowded. We have {0} officers, crowd percentages {1}".format(officers_sum, areas_crowd_count_perc))
    """"""
  
schedule.every(0.1).minutes.do(redistribute) # Minutes could be adjusted as wanted or needed
  

while True: 
    schedule.run_pending() 
    time.sleep(1) 
