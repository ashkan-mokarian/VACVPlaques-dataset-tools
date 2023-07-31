// Define input and output directories
inputDir = "/Users/ashkanhzdr/workspace/dataset/plaques/full_dataset/dVGF_dF11_viruses/M061_20160921/tif/";
outputDir = "/Users/ashkanhzdr/workspace/dataset/plaques-ashkan/dVGF_dF11_viruses/train/"

// Get a list of all TIFF files in the input directory
list = getFileList(inputDir);

// Loop through each TIFF file
for (i = 0; i < list.length; i++) {
    inFile = inputDir + list[i];
    open(inFile);
    
    // Split channels and select the first channel (red)
    run("Split Channels");
    selectWindow("C1-" + list[i]);
    
    // Save the first channel as a new image in the output directory
    outFile = outputDir + "M061_" + list[i];
    saveAs("Tiff", outFile);
    close();
}

// Close ImageJ after processing all files
run("Quit");
