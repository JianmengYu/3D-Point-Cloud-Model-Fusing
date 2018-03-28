# Advanced Vision Coursework

This project process and combine 50 3D point cloud data from a Kinect Sensor:   
![alt text](https://github.com/JianmengYu/av_coursework/blob/master/original.jpg)  
To a single 3D point cloud below:  
![alt text](https://github.com/JianmengYu/av_coursework/blob/master/pic.png)

## Outputs

fusedPC    : `finalPC.mat`  
fusedImage : `combined box.fig`  

## Usage 

A startup.m MATLAB script is provided to load the required data automatically during startup. However it requires you to start MATLAB within the directory.  

```
git clone https://github.com/JianmengYu/av_coursework.git
cd av_coursework
matlab
```

The pointcloud used for the project is not included due to it's size (188 MB)  
Manually download this to the root folder of this repo.   
http://homepages.inf.ed.ac.uk/rbf/AVDATA/AV118DATA/assignment_1_box.mat

## Processing Steps

1) Startup functions loads everything you need.  
2) getMask generates mask for each PC. (removeBlue and removeSkin is used)    
3) getPC generates cleaned PC using getMask.  
4) getPlanes uses the filtered coordinates in cleaned PC to generate plane candidates.  
5) getCleanPlanes loads a cleaned PC, run it through getPlanes multiple time and obtain best planes.  
6) getCorner obtains main connection points and the size of the planes in one image.  
7) getRotatedPoints rotates the points obtained by getCorner, rotate main plane on XY-plane. Move the center to (0,0).  
8) fuseModel loads each frame, use getRotatedPoints and model.m to construct the final image.

## Functions Provided

`startup.m`  
Load everything you need.

`scripts/reload.m`  
Clean workspace and load everything.

`plot/playPlane2D.m`  
Shows the extracted planes on original images, use this to tune the model.m.

`fuseModel.m`  
Fuses the final model.

---

Functions for tuning:

`model.m`  
Contains descriptions and settings for fusing the box.

`util/getMask.m`  
Contains first stage cleaning parameters.

`util/getPlanes.m`  
Parameters for extracting planes.

`util/getCleanPlanes.m`
Parameters for selecting good planes.

## External Functions Used

For plane extraction, the MATLAB functions provided at:   
https://www.inf.ed.ac.uk/teaching/courses/av/MATLAB/TASK3/  
were used, these functions are stored at:   
`./bob's functions`:  
binarytest.m    fitplane.m      itree.m         rngdata.asc     verifymatch.m  
doall.m         fitplanes.m     modelfile.m     select_patch.m  
estimatepose.m  getallpoints.m  plotsolution.m  unarytest.m  


For transformation linear algebra functions, these are used:  
`./util/linear algebra`:  
getPlaneIntersection.m      projectPointOnLine.m  roty.m  
getPlaneLineIntersection.m  rotx.m                rotz.m  

They are obtained from:  
https://uk.mathworks.com/matlabcentral/fileexchange/17618-plane-intersection  
https://uk.mathworks.com/matlabcentral/fileexchange/17751-straight-line-and-plane-intersection  
https://uk.mathworks.com/matlabcentral/fileexchange/7844-geom2d?focused=8114527&tab=function

