# Single Shell Free Water Estimation

Adapted from https://github.com/neuro-stivenr/Fernet and https://github.com/DiCIPHR-Lab/Fernet

I mainly dockerized the code but I did update some of the specific functions to work with newer versions of numpy, nibabel, and dipy. You should be able to compare my scripts with the master/pre-fork scripts to see changes.

Summary of changes

1. I imported setuptools instead of distutils: The script now imports setup and find_packages from setuptools.
2. find_packages(): This function automatically finds all packages in the directory (that is, folders containing an __init__.py file).
3. Removed Extension import: Extension from distutils was not used.
4. Replaced nibabel's older get_data() with get_fdata()
5. Replaced NumPy's deprecated np.bool to bool

## Original Description with some edits

This Python package contains FERNET, a tool for Free-watER iNvariant 
Estimation of Tensor on single shell diffusion MR data. 

FERNET uses NIfTI as its data format for MR images, using the "nii.gz" 
file extension (.nii works too!). It uses the FSL convention for "bval" and "bvec" text files. 

## Notes about running
This method was developed and shown to work with single shell diffusion data (b = 800). Article here: https://doi.org/10.1371/journal.pone.0233645

However, multi-shell data will work (see linked paper).

As with any diffusion data, a minimum of eddy current correction with rotated bvecs is strongly recommended. Bias correction will also improve results. This guide should give good results for preprocessing diffusion data. Modify it as needed for your data: https://github.com/tannerjared/MRI_Guide/wiki/dwifslpreproc

For freewater calculations it is not clear if higher b values (≥~1000) provide benefit. In fact, the signal to noise reductions in data at higher b values can lead to increased free water modeling error. From the FERNET paper: "Although, as expected, the free water estimation became increasingly robust as SNR increased, the effect of SNR on the mean of free water estimation was negligible beyond an SNR of 20." The converse of this is that lower SNR should lead to increased errors in free water estimation. Because of this, if you have multishell data with higher b values, you might want to limit your data to b≤1000. You can extract directions you want using this FSL tool following this sample command (this is specific to a particular dwi sequence, adapt as needed). Note that I have b values of 101 in there because FSL's EDDY struggles with b values of 100 so I change them in the bval file to 101 before running EDDY:
```
select_dwi_vols dwi_den_preproc_unbiased.nii.gz dwi_den_preproc_unbiased.bval dwi_den_preproc_unbiased_subset 0 -b 101 -b 400 -b 700 -b 1000 -obv dwi_den_preproc_unbiased.bvec
```
If you have multi-shell data with higher b values (e.g., 2000 or 3000), it's best to run comparison tests with and without them in the data. If you only have single shell data (b≤1200 or so), you should be fine running this method. If you have multi-shell data, you should also be fine but again, maybe run some trials with and without the higher b values. As a note, I've run the original Pasternak Matlab code (this current method appears to be an adaptation of that), on both single shell and multi-shell data (keeping b values ≤ ~1000) with good results.

### Notes about data organization

I like to put all files in a single directory for processing but you can structure however you want. You need a preprocessed dwi nifti (eddy correction is minimum), a brain mask (multiple ways to create but it will be produced if you follow the dwifslpreproc guide), and your bvec and bval files. You could also have CSF and white matter maks files as inputs. There are multiple ways to create those but that typically requires T1-weighted data. They should be registered to the DWI space first, or you can register your DWI to the anatomical T1 space and run this all on those images.

## Create a docker image
Run this to build a container for your device or see below for pre-built containers (x64 and arm64).
```
git clone https://github.com/tannerjared/Fernet.git 
cd Fernet
docker build -t fernet .
```
You can also pull one from Docker Hub if using x64 processors (Intel, AMD)
```
docker pull jjtanner/fernet:latest
```
Container for macOS with Apple Silicon (arm64)
```
docker pull jjtanner/fernet:arm
```
## Run docker image

Update paths as appropriate. This is for a single subject who already had eddy corrected diffusion data.
```
docker run -v /path/to/dwi_in:/dwi_in -v /path/to/fw_out:/fw_out fernet -d /dwi_in/jt2021_ecc.nii.gz -r /dwi_in/jt2021.bvec -b /dwi_in/jt2021.bval -m /dwi_in/jt2021_brain_mask.nii.gz -o /fw_out/jt2021
```

## As Singularity image for HPC
```
singularity build fernet.sif docker://jjtanner/fernet:latest
```
Or, if you have the container locally built in Docker, you can run this to save it and build as a Singularity container
```
docker save -o fernet.tar fernet && singularity build fernet.sif docker-archive://fernet.tar
```

### Run singularity image
Update paths for where your input data are and where the output will be saved.
```
apptainer run --bind /path/to/dwi_in:/dwi_in --bind /path/to/fw_out:/fw_out fernet_latest.sif -d /dwi_in/jt2021_ecc.nii.gz -r /dwi_in/jt2021.bvec -b /dwi_in/jt2021.bval -m /dwi_in/jt2021_brain_mask.nii.gz -o /fw_out/jt2021
```

## Installation on UNIX-based system
These instructions are from https://github.com/neuro-stivenr/Fernet

I've not tested them because my focus was on getting Docker and Singularity containers working. I recommend using the Docker or Singularity containers because you won't need to install anything (assuming you have Docker and/or Singularity/Apptainer already set up).

```bash
make install
ln -s $(pwd)/fernet.sh <SOME DIR ON PATH>
```
