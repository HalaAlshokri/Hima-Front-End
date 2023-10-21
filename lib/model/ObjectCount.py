import schedule 
import time 
import numpy as np
import cv2
from ultralytics import YOLO
from keras.models import load_model  # TensorFlow is required for Keras to work

# Disable scientific notation for clarity // keras
np.set_printoptions(suppress=True)

# Load the models
TMmodel = load_model("keras_Model.h5", compile=False)
#YOLOmodel=YOLO('yolov8l') #to be deleted
YOLOmodel=YOLO('best(YOLOv8L).pt') #Loading our custom model

# Load the labels
class_names = ["Normal", "Crowd"]
#open("labels.txt", "r").readlines()

#Open camera source/s
IMAGE_SOURCE1=cv2.VideoCapture("assets/videos/Arafah.mp4")
IMAGE_SOURCE2=cv2.VideoCapture("assets/videos/Arafah(2).mp4")
IMAGE_SOURCE3=cv2.VideoCapture("assets/videos/Haram.mp4") #C:\Users\Hala's Laptop\Documents\YOLOv8 Everything\YOLOv8 Custom\
IMAGE_SOURCE4=cv2.VideoCapture(0)

sources_array=[IMAGE_SOURCE1,IMAGE_SOURCE2,IMAGE_SOURCE3,IMAGE_SOURCE4]

# creating a dictionary
areas = {
    "Zone A": 50, 
    "Zone B": 50,
    "Zone C": 50,
    "Zone D": 50
}

#Method to predict number of heads in a single frame
def predict(IMAGE_SOURCE):
    sucess, frame = IMAGE_SOURCE.read()

    if sucess:
        results=YOLOmodel(frame)
        count=len(results[0].boxes)

    return count

#Mathod to predict status: crowded or not
def crowdAlert(IMAGE_SOURCE):
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
        print(confidence_score)

        if confidence_score >= 0.9:
            return True
    
    return True

def redistribute(): 

    areas_crowd_count=[]
    areas_status=[]

    """"""
    for i in sources_array:
        count_heads=predict(i) #Heads count INT value
        status=crowdAlert(i) #Crowded or not BOOLEAN value

        areas_crowd_count.append(count_heads)
        areas_status.append(status)
    
    areas_crowd_count_perc=[]
    for i in areas_crowd_count:
        areas_crowd_count_perc.append(i/sum(areas_crowd_count))
    
    officers_sum=sum(areas.values())

    if (True) in areas_status:
        print("One of the areas is crowded!! We have {0} officers, crowd percentages {1}".format(officers_sum, areas_crowd_count_perc))
        for index, area in enumerate(areas):
            areas[area]=round(areas_crowd_count_perc[index]*officers_sum)
        
        print(areas)
    else:
        print("No area is crowded. We have {0} officers, crowd percentages {1}".format(officers_sum, areas_crowd_count_perc))


    #print("Detected head objects: ", count) 
    #print("Crowded? ", alert)
  
schedule.every(0.2).minutes.do(redistribute) 
  



while True: 
    schedule.run_pending() 
    time.sleep(1) 
