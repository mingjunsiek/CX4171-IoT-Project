
import tensorflow.keras
from PIL import Image, ImageOps
import numpy as np
import base64
import os
import io
import json
import glob
from keras.models import load_model

# Disable scientific notation for clarity
np.set_printoptions(suppress=True)

# Called when the deployed service starts
def init():
    global model

    # Get the path where the deployed model can be found.
    model_path = os.path.join(os.getenv('AZUREML_MODEL_DIR'), './bank-note-model.h5')
    # load models
    model = load_model(model_path)

# Handle requests to the service
def run(data):
    try:
        # Pick out the text property of the JSON request.
        # This expects a request in the form of {"text": "some text to score for sentiment"}
        data = json.loads(data)
        prediction = predict(data['image_data'])
        #Return prediction
        return prediction
    except Exception as e:
        error = str(e)
        return error

def predict(image_data, include_neutral=True):
    
    note_classes = ['fifty_dollar', 'five_dollar', 'ten_dollar', 'two_dollar']
    data = np.ndarray(shape=(1, 224, 224, 3), dtype=np.float32)
    
    imgdata = base64.b64decode(str(image_data))
    image = Image.open(io.BytesIO(imgdata))

    #resize the image to a 224x224 with the same strategy as in TM2:
    #resizing the image to be at least 224x224 and then cropping from the center
    size = (224, 224)
    image = ImageOps.fit(image, size, Image.ANTIALIAS)
    
    #turn the image into a numpy array
    image_array = np.asarray(image)

    # Normalize the image
    normalized_image_array = (image_array.astype(np.float32) / 127.0) - 1

    # Load the image into the array
    data[0] = normalized_image_array

    # run the inference
    prediction = model.predict(data)
    return note_classes[prediction.argmax()]
