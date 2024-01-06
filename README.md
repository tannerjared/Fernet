# Single Shell Free Water Estimation

Adapted from https://github.com/neuro-stivenr/Fernet and https://github.com/neuro-stivenr/Fernet

## Original Description

This Python package contains FERNET, a tool for Free-watER iNvariant 
Estimation of Tensor on single shell diffusion MR data. 

FERNET uses NIfTI as its data format for MR images, using the "nii.gz" 
file extension. It uses the FSL convention for "bval" and "bvec" text files. 

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
