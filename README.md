# Single Shell Free Water Estimation

Adapted from https://github.com/neuro-stivenr/Fernet

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

## Run docker image

Update paths as appropriate. This is for a single subject who already had eddy corrected diffusion data.
```
docker run -v /mnt/g/freewater_code/FW:/fw_data -v /mnt/g/freewater_code/FW_test_out:/fw_data_test_out fernet -d /fw_data/jt2021_ecc.nii.gz -r /fw_data/jt2021.bvec -b /fw_data/jt2021.bval -m /fw_data/jt2021_brain_mask.nii.gz -o /fw_data_test_out/jt2021
```

## Installation on UNIX-based system

```bash
make install
ln -s $(pwd)/fernet.sh <SOME DIR ON PATH>
```
