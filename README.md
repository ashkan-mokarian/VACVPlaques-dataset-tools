# Description
Contains code and script for data analysis (exploration and preparation) for
VACV Plaques dataset.

# related to infectio-photorealism - Main steps to create dataset

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

# related to Infectio - Extract simulation model parameters

## Create reference metrics csv file for simulation evaluation
[create reference metrics notebook](./notebooks/6_create_reference_metrics_csv_for_infectio.ipynb)
is used to create a reference metrics csv file to evaluate simulation results.
Current metrics used are: mean and std values of infected cell counts, and mean
and std of the radius of the plaque at each time of experiment hours post
infection. and radial velocity. Also added another column to each metric, a list of all
the numbers that mean and std were computed, such that 2sample tests can be used.

Currently not using all the available dataset, but only the ones that are
clean. That is the ones that have a single plaque center.

## motility analysis based on trackmate results
[motility analysis notebook](./notebooks/3_motility_analysis_from_trackmate_results.ipynb)
shows frame to frame (backward difference) speed for different strains with 
inf_time (frames passed after infection) as parameter.

## direction deviation noise angle
[direction deviation angle notebook](./notebooks/4_direction_deviation_angle_from_trackmate.ipynb)
uses trackamte results to find the angle between the frame movement direction and
a central moving average of the movement over a longer period. Was hoping for smaller
angles but std of the angles are around 60 degrees which is too large to be consired
as just noise I would say.