/*	" BlotMeUp "
 *	
 *	BlotMeUp is a mono imageJ tool to quantify protein of interest for 2D images from Western Blot.
 *	
 *	Centre de Biologie et Recherche en Santé | CBRS François Denis, UMR CNRS 7276
 *	Equipe B-NATION | B cell Nuclear ArchiTecture, Ig genes and ONcogenes
 *	2 rue du Pr Bernard Descottes, 87025 Limoges
 *	
 *	Copyright (C) Made on the 09.2023 and written by Jean-Yves Alejandro Frayssinhes.
 *	Contact: jean-yves.frayssinhes@cnrs.fr
 *	
 *	
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	any later version.
 *	
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *	
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *	
 */


macro "Western Blot Action Tool - T0504BT5504lTa504oTf504tT0a04MT5a04eT0f04UT5f04p" {
	Title = "Western blot - Quantification";
	Message = "WB quantification is about to begin.\nPress OK to continue."
		waitForUser(Title, Message);
	do {
			
		run("Close All");

	input = getDirectory("WB images folder to analyse.");
	file_list = getFileList(input);
	output = input + File.separator + "WB - Datas" + File.separator ;
		File.makeDirectory(output);

	for (w = 0; w < file_list.length; w++) {
	current_imagePath = input+file_list[w];
			if (!File.isDirectory(current_imagePath)){
		open(current_imagePath);
		getDimensions(width, height, channels, slices, frames);
		run("Close All");
			if (channels >= 1) {
		open(current_imagePath);
		image_name = getTitle();
		run("Duplicate...", "title=1");
		run("Duplicate...", "title=2");
		run("Invert");
		run("Duplicate...", "title=3");
		run("Subtract Background...", "rolling=70 create sliding");
		imageCalculator("Subtract create", "2","3");
		do {
		showMessage("You are about to identify the horizontal lane of protein.");
		selectImage("Result of 2");
		setAutoThreshold("Otsu dark");
		run("Threshold...");
	Title = "1/2";
	Message = "Highlight your positive signal only.\n1/3 - Select the algorithm you wish (Default, Li, Otsu etc...)\n Stick to it.\n2/3 - Slide the top bar until all objects are segmented.\n3/3 - Once satisfied, press OK.";
		waitForUser(Title, Message);
		run("Create Mask");
		run("Open");
		run("Fill Holes");
		run("Erode");
		run("Dilate");
		setTool("rectangle");
	Title1 = "2/2";
	Message1 = "The selection tool is automatically selected.\nFrame the lane of your protein of interest, then press OK.";
		waitForUser(Title1, Message1);
		run("Set Measurements...", "integrated limit display redirect=image_name decimal=4");
		run("Analyze Particles...", "size=5-Infinity add");
		run("ROI Manager...");
	Group = roiManager("count");
	for (b = 0 ; b < Group; b++) {
		roiManager("Select", b);
		roiManager("Rename", getString("Protein name: ", "Add a name"));
	}
		name_result = getString("Name your experiment: ", "Caspase-3 12h");
		selectImage(image_name);
		roiManager("Select", newArray());
		roiManager("Measure");
		selectWindow("Results");
		saveAs("Results", output + name_result + ".tsv");
		run("Clear Results");
		run("Close");
		roiManager("Select", newArray());
		run("Select All");
		roiManager("Save", output + name_result + ".zip");
		roiManager("delete");

	Question = getBoolean("Is there another protein lane to quantify on this blot?");
		} while (Question == 1);
		run("Close All");
}
}
}
		close("Threshold");
		close("ROI Manager");
		run("Close All");

	dialog = Dialog.create("Another WB images folder to quantify ?");
	Dialog.addMessage("Do you wish to quantify another WB images folder ?");
		Dialog.addChoice("Choose:", newArray("Yes", "No, I am done"));
		Dialog.show();
	choice = Dialog.getChoice();
} while (choice == "Yes") {
		Title2 = "Quantif has ended";
	Message2 = "Press OK to Continue";
		showMessage(Title2, Message2);
}
}

/*  BlotMeUp  Copyright (C) 09.2023  Jean-Yves Alejandro Frayssinhes
 *  This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
 *  This is free software, and you are welcome to redistribute it
 *  under certain conditions; type `show c' for details.
 */