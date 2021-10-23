//	BRO.ijm
// 
// BRO: Batch ROI Overlay
// V01.00
// Copyright (C) 2021 Dylan Terstege - Epp Lab
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details
//
// Your should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
//
// Created 10-23-2021 Dylan Terstege
// Epp Lab, University of Calgary
// Contact: dylan.terstege@ucalgary.ca
// GitHub: https://github.com/dterstege

//INITIALIZE
setOption("JFileChooser",true);
path=getDirectory("Select a parent folder containing the ROI folder and target image folder");
list=getFileList(path);
list=Array.sort(list);

//SET RECURSION FRAME
flag=1

//START RECURSION
do {
//WELCOME WINDOW
Dialog.create("BRO: Batch ROI Overlay");
Dialog.addMessage("                                 Welcome to BRO: \n                                Batch ROI Overlay\n \n-----------------------------------------------\n \n                  Overlay ROI Sets to target images\n                  Output a PNG to illustrate accuracy\n \n-----------------------------------------------");
Dialog.addMessage("\n \nSelect the appropriate subfolder within the current directory.");
Dialog.addChoice("Image Subfolder",list,list[0]);
Dialog.addChoice("ROI Subfolder",list,list[1]);
Dialog.addMessage("\n \n Ensure that corresponding file order aligns between folders.\n \n-----------------------------------------------\n \n \n \nCreated 10-23-2021 by Dylan Terstege\nEpp Lab, University of Calgary\nContact: dylan.terstege@ucalgary.ca");
Dialog.show();

//GET USER INPUTS
//images
imfolder=Dialog.getChoice;
imfile=path+imfolder;
imlist=getFileList(imfile);
imlist=Array.sort(imlist);
imcount=imlist.length;
//rois
roifolder=Dialog.getChoice;
roifile=path+roifolder;
roilist=getFileList(roifile);
roilist=Array.sort(roilist);
roicount=roilist.length;

//CHECK FOR AGREEMENT
if (roicount > imcount)
   waitForUser("Number of images and ROIs must be equivalent\n \n                  Too many ROI Set files");
else if (roicount < imcount)
   waitForUser("Number of images and ROIs must be equivalent\n \n                   Too many Image files");
else
   flag=0;} while (flag);
   

//CREATE OUTPUT DIRECTORY
outpath=path+"outputs";
File.makeDirectory(outpath);

//BATCH OVERLAY
setBatchMode(true);
for (ii=0; ii<(imcount); ii++){
   progress=(imcount+1-ii)/imcount;
   showProgress(progress);
   open(imfile+imlist[ii]);
   name=File.nameWithoutExtension;
   outfile=outpath+"/"+name+".png";
   roi=roifile+roilist[ii];
   roiManager("Open", roi);
   roiManager("Show All");
   run("Flatten");
   saveAs("png", outfile);
   close("*");
   close("ROI Manager");
}
progress=1;
showProgress(progress);
setOption("JFileChooser", false);
waitForUser("Batch ROI Overlay Complete"); 
