import cv2
import pandas as pd
import numpy as np
from ultralytics import YOLO

model=YOLO('yolov8n.pt')

def RGB(event, x, y, flags, param):
    if event == cv2.EVENT_MOUSEMOVE:
        colorBGR = [x,y]
        print(colorBGR)

cv2.namedWindow('Survielence Footage')
cv2.setMouseCallback('Survielence Footage', RGB)

IMAGE_SOURCE=cv2.VideoCapture(r"C:\Users\Hala's Laptop\Documents\YOLOv8 Everything\YOLOv8 Custom\Arafah.mp4")

count=0

while True:
    ret, frame = IMAGE_SOURCE.read()
    
    if ret is None:
        break
    count+=1
    if count%3 != 0:
        continue

    results=model.predict(frame)
    #print(results)
    a=results[0].boxes.boxes
    #print(a)
    px=pd.DataFrame(a).astype("float")
    #print(px)
    print("Number of objects detcted: ",px[px.columns[0]].count())

    cv2.imshow("Survielence Footage", frame)
    if cv2.waitKey(0)&0xFF==27:
        break

IMAGE_SOURCE.release()
cv2.destroyAllWindows()