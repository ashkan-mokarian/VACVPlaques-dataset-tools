# Description
Contains codes and scripts for data analysis (exploration and preparation) for
VACV Plaques dataset.

# Main steps to create dataset for infectio-photorealism

## Creating spots .csv data using trackmate
[These options](./attachments/trackmate_configs.txt) are used with trackmate to
generate spots data. Trackmate batcher with an example xml file can be used to
parse batch of tiff files. It will create a .csv file for each .tiff file.
The original analysis provided with the dataset were not used, because they lead
to incorrect spot locations as can be seen in [here](./notebooks/0_read_spots_from_trackmate.ipynb).
If you check for different files, they lead to different offsets which are not
consistent. Therefore I ran the analysis again using trackmate and the config
provided.

Each .tiff image in original dataset has two channels, where one of the channles
is useless (some contain info, but most seem to be just noise). Therefore only
first channel is kept using fiji and [this script](./attachments/batch_first_channel.ijm).

[This](./notebooks/1_create_trackmate_spots_dataset.ipynb) is used to look at
the results of trackmate, and also to copy csv files to where the .tiff files are
to create a dataset.

## uint16 to uint8 conversion
original .tiff files are in the format uint16, which is not supported by pytorch
(ToTensor() transformation in torchvision does not support uint16).
Also, these files have a range much smaller than the dtype uint16 allows. Therefore
using cv2 to linearly rescale the values to the range of uint8 dtype. max and min
values for rescaling is computed using each .tiff file (contain 169 frames) and
not the whole dataset. [This notebook](./notebooks/2_plaque_u2tou1_and_statistics.ipynb) does this.