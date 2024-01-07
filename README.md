# Single Shell Free Water Estimation

Adapted from https://github.com/neuro-stivenr/Fernet and https://github.com/neuro-stivenr/Fernet

## Original Description

This Python package contains FERNET, a tool for Free-watER iNvariant 
Estimation of Tensor on single shell diffusion MR data. 

FERNET uses NIfTI as its data format for MR images, using the "nii.gz" 
file extension. It uses the FSL convention for "bval" and "bvec" text files. 

## Notes about running
This requires a single shell file that is eddy current corrected with rotated bvecs. This guide should give good results for preprocessing diffusion data. Modify it as needed for your data: https://github.com/tannerjared/MRI_Guide/wiki/dwifslpreproc

For freewater calculations it is best to use b values ≤ 1000. If you have multishell data with higher b values, you can extract the ones you want using this FSL tool following this sample command (this is specific to a particular dwi sequence, adapt as needed). Note that I have b values of 101 in there because FSL's EDDY struggles with b values of 100 so I change them to 101 before running EDDY:
```
select_dwi_vols dwi_den_preproc_unbiased.nii.gz dwi_den_preproc_unbiased.bval dwi_den_preproc_unbiased_subset 0 -b 101 -b 400 -b 700 -b 1000 -obv dwi_den_preproc_unbiased.bvec
```
While this tool is for "single shell" free water estimation, there's likely no reason why it cannot be run on multi-shell data. It's best to run comparison tests. I've run the Pasternak Matlab code on multi-shell data (keeping b values ≤ 1000 or so (1200 might be appropriate too)) with good results.

I like to put all files in a single directory for processing but you can structure however you want. At a minimum you need the eddy corrected (and TOPUP if you can) dwi nifti, a brain mask (multipl ways to create but it will be produced if you follow the dwifslpreproc guide), and your bvec and bval files. You could also have CSF and white matter maks files as inputs. There are multiple ways to create those but that typically requires T1-weighted data. They should be registered to the DWI space first (or you can register your DWI to the anatomical T1 space and run this all on those images).

## Create a docker image
```
git clone https://github.com/tannerjared/Fernet.git 
cd Fernet
docker build -t fernet .
```
You can also pull one from Docker Hub
```
docker pull jjtanner/fernet
```
## Run docker image

Update paths as appropriate. This is for a single subject who already had eddy corrected diffusion data.
```
docker run -v /path/to/dwi_in:/dwi_in -v /path/to/fw_out:/fw_out fernet -d /dwi_in/jt2021_ecc.nii.gz -r /dwi_in/jt2021.bvec -b /dwi_in/jt2021.bval -m /dwi_in/jt2021_brain_mask.nii.gz -o /fw_out/jt2021
```

## As Singularity image for HPC
```
singularity build fernet.sif docker://jjtanner/fernet
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

I've not really tested them because my focus was on getting a Docker container and Singularity container working. I recommend using the Docker or Singularity containers.

```bash
make install
ln -s $(pwd)/fernet.sh <SOME DIR ON PATH>
```
