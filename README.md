# Degenerative-disc-disease-diagnosis
Degenerative disc disease diagnosis from lumbar MR images using hybrid features

# Refer the paper: 
Beulah, A., T. Sree Sharmila, and V. K. Pramod. 
"Degenerative disc disease diagnosis from lumbar MR images using hybrid features." 
The Visual Computer 38, no. 8 (2022): 2771-2783.


## Degenerative disc disease diagnostic system
The proposed system to diagnose the degenerative disc is below. The mid-sagittal lumbar MR image is the input to this system which contains lumbar spine and its surrounding organs. Hence, it is necessary to segment the lumbar IVDs from MR image. The new segmentation algorithm segments the needed lumbar IVDs. A tight bounding box is generated over the segmented region in the original image. The degenerative and non-degenerative discs are separated to form the dataset, with the help of a medical expert. Then, the hybrid features are extracted for IVD regions. The model is built by trained features using SVM. When a new test image is given to the model, the image is automatically segmented to obtain lumbar IVDs and classifies each lumbar IVD as either disc degeneration or non-degeneration.
