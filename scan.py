import cv2
from PIL import Image
import pytesseract
import pyttsx3
import numpy as np

# Set Tesseract-OCR path
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

# Initialize the pyttsx3 engine for text-to-speech
engine = pyttsx3.init()

# Define the SpeakText function
def SpeakText(text):
    if text.strip():  # Check if the text is not empty
        engine.say(text)
        engine.runAndWait()
    else:
        print("No text to speak.")

# Enhanced image preprocessing
def preprocess_image(image_path):
    """
    Preprocess the image to improve OCR accuracy.
    :param image_path: Path to the image file.
    :return: Original image and preprocessed image.
    """
    image = cv2.imread(image_path)

    # Convert to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Apply bilateral filter to reduce noise while keeping edges sharp
    filtered = cv2.bilateralFilter(gray, 9, 75, 75)

    # Adaptive thresholding for dynamic lighting conditions
    adaptive_thresh = cv2.adaptiveThreshold(
        filtered, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2
    )

    # Perform morphological operations to remove noise
    kernel = np.ones((1, 1), np.uint8)
    cleaned = cv2.morphologyEx(adaptive_thresh, cv2.MORPH_CLOSE, kernel, iterations=1)

    return image, cleaned

# Extract text from a given bounding box
def extract_bbox_text(image, bbox):
    """
    Extract text from a given bounding box.
    :param image: Original image.
    :param bbox: Bounding box (x, y, w, h).
    :return: Extracted text from the bounding box.
    """
    x, y, w, h = bbox
    roi = image[y:y + h, x:x + w]
    text = pytesseract.image_to_string(roi, lang="eng")
    return text.strip()

# Extract the largest and second-largest bounding boxes and their texts
def extract_largest_and_second_largest_bbox_texts(image, binary_image):
    """
    Detect the largest and second-largest bounding boxes and extract texts within them.
    :param image: Original image.
    :param binary_image: Preprocessed binary image.
    :return: Texts from the largest and second-largest bounding boxes.
    """
    # Find contours in the binary image
    contours, _ = cv2.findContours(binary_image, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Sort contours by area in descending order
    sorted_contours = sorted(contours, key=cv2.contourArea, reverse=True)

    # Get the bounding boxes for the largest and second-largest contours
    largest_bbox = cv2.boundingRect(sorted_contours[0]) if len(sorted_contours) > 0 else None
    second_largest_bbox = cv2.boundingRect(sorted_contours[1]) if len(sorted_contours) > 1 else None

    # Extract texts from the bounding boxes
    largest_text = extract_bbox_text(image, largest_bbox) if largest_bbox else ""
    second_largest_text = extract_bbox_text(image, second_largest_bbox) if second_largest_bbox else ""

    return largest_text, second_largest_text

# Main function to process the image and extract information
def process_image(image_path):
    """
    Process the image to extract the largest and second-largest bounding boxes' texts.
    :param image_path: Path to the image file.
    """
    original_img, preprocessed_img = preprocess_image(image_path)
    largest_text, second_largest_text = extract_largest_and_second_largest_bbox_texts(original_img, preprocessed_img)

    print(f"Brand: {largest_text}")
    print(f"Product Name: {second_largest_text}")

    # Convert the extracted information to speech
    SpeakText(f"The brand is {largest_text} and the product name is {second_largest_text}.")

# Path to the wrapper image
image_path = "saved results/68.png"  # Replace with the correct path

# Process the image
process_image(image_path)
