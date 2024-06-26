/*	" BlotMeUp "
 *	
 *	BlotMeUp is a mono imageJ tool to quantify protein of interest for 2D images from Western Blot.
 *	
 *	Centre de Biologie et Recherche en Santé | CBRS François Denis, UMR CNRS 7276
 *	Equipe B-NATION | B cell Nuclear ArchiTecture, Ig genes and ONcogenes
 *	2 rue du Pr Bernard Descottes, 87025 Limoges
 *	
 *	Copyright (C) Made on the 09.2023 and written by Jean-Yves Alejandro Frayssinhes.
 *	Tool training using datas from co-partner Suzan Ghaddar.
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

	array = newArray("Tif", "jpg", "png");
//	var file_extension = "Tif";

	Dialog.create("Image format");
//		Dialog.addString("The file extension of your image is: ", file_extension);
		Dialog.addChoice("The file extension of your image(s) is: ", array);
		Dialog.show();
//	file_extension = Dialog.getString();
	file_extension = Dialog.getChoice();

	input = getDirectory("WB images folder to analyse.");
	file_list = getFileList(input);
	output = input + File.separator + "WB - Datas" + File.separator ;
		File.makeDirectory(output);

setBatchMode(true);
	for (w = 0; w < file_list.length; w++) {
		if (endsWith(file_list[w], file_extension)) {
	current_imagePath = input+file_list[w];
		open(current_imagePath);
		getDimensions(width, height, channels, slices, frames);
		run("Close All");
setBatchMode(false);
			if (channels >= 1)	{
		open(current_imagePath);
			gray = is("grayscale");
			if (gray == 1) {
//		image_name = getTitle();
		LUT = is("Inverting LUT");
			if (LUT == 0) {
				run("Invert LUT");
				run("Invert");
			}
//		run("Duplicate...", "title="+1+"-"+image_name);
		second_name = getTitle();
		do {
		showMessage("You are about to identify the horizontal lane of protein.");
		selectImage(second_name);
		setAutoThreshold("Otsu no-reset");
		setThreshold(0, 65535,"over/under");
		run("Threshold...");
	Title = "1/2";
	Message = "Highlight your positive signal only.\n1/3 - Select the algorithm you wish (Default, Li, Otsu etc...)\nStick to it.\n2/3 - Slide the top bar until all objects are segmented.\n3/3 - Once satisfied, press OK.";
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
		selectImage("mask");
		run("Set Measurements...", "integrated limit display redirect=second_name decimal=4");
		run("Analyze Particles...", "size=0-Infinity add");
		run("ROI Manager...");
	Group = roiManager("count");
	for (b = 0 ; b < Group; b++) {
		roiManager("Select", b);
		roiManager("Rename", getString("Protein name: ", "Add a name"));
	}
		name_result = getString("Name your experiment: ", "Caspase-3 12h");
		selectImage(second_name);
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
		selectImage("mask");
		close();

	Question = getBoolean("Is there another protein lane to quantify on this blot?");
		} while (Question == 1);
		run("Close All");
}
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