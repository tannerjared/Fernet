from setuptools import setup, find_packages
import os

# This was updated by Jared Tanner, jjtanner@ufl.edu

setup(
    name='fernet',
    description='Single shell free-water correction for Diffusion Tensor Imaging data.',
    version='0.1.dev0',
    author='William Parker',
    author_email='William.Parker@uphs.upenn.edu',
    url='http://www.med.upenn.edu/sbia/',
    scripts=[
        os.path.join('scripts', 'fernet.py'),
        os.path.join('scripts', 'fernet_regions.py'),
        os.path.join('scripts', 'fernet_fw_dwi.py'),
    ],
# Uncomment the below if you want this to handle the required packages instead of the requirements.txt file
#    packages=find_packages(),
#    install_requires=[
#        'numpy>=1.10.4',
#        'scipy>=0.17.1',
#        'nibabel>=2.0.1',
#        'dipy>=0.10.1',
#    ],
)
