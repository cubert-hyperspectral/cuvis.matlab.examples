![image](https://raw.githubusercontent.com/cubert-hyperspectral/cuvis.sdk/main/branding/logo/banner.png)

# cuvis.matlab.examples

## Preparation

To get the exampels running, first  you need to install the Cuvis C SDK (see [here](https://cloud.cubert-gmbh.de/s/q3YiPZPJe5oXziZ)), as explained for the MATLAB wrapper [here](https://github.com/cubert-hyperspectral/cuvis.matlab).

For running some of the examples, you have to use sample data (provided [here](https://cloud.cubert-gmbh.de/s/SrkSRja5FKGS2Tw)).

Make sure that the folder of the example data (cuvis_3.2.1_sample_data) and the folder cuvis.matlab.examples are in the same directory.

## Inventory

### 01_loadMeasurement
Load measurement from disk and print the value (count) for all available channels (wavelength) for one specific pixel.

### 02_reprocessMeasurement
Load measurement as well as references (dark, white, distance) from disk and reprocess the measurement to reflectance.

### 03_exportMeasurement
Load measurement from disk and save to different file formats.

### 04_changeDistance
Load measurement from disk and reprocess to a new given distance.

### 05_recordSingleImages
Setup camera and record measurements via looping software trigger, aka 
"single shot mode" or "software mode".

### 06_recordVideo
Setup camera and record measurements via internal clock triggering, aka "video mode". In this example the `cuvis.Worker` is used to make use of multithreading (`cuvis_worker_create`).

### 07_recordVideoFromSessionFile
Set up a virtual camera based on a pre-recorded session file to simulate actual camera behaviour.
