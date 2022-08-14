# vqgarm - VQGAN+CLIP for aarch64 testing

![Example Image](https://korii.slate.fr/sites/default/files/styles/1440x600/public/champdechienselectriques.jpg)
---
![Run Test](https://github.com/LibreCS/vqgarm/actions/workflows/running.yml/badge.svg) ![Build Test](https://github.com/LibreCS/vqgarm/actions/workflows/test.yml/badge.svg) ![Dependancies Test](https://github.com/LibreCS/vqgarm/actions/workflows/requirements.yml/badge.svg) ![GitHub last commit](https://img.shields.io/github/last-commit/LibreCS/vqgarm) ![GitHub](https://img.shields.io/github/license/LibreCS/vqgarm)
---
This started out as a Katherine Crowson VQGAN+CLIP derived Google notebook, and further derived from a project to run the notebook locally using Anaconda for Python found [in this repository.](https://github.com/nerdyrodent/VQGAN-CLIP)

This project aims to provide compatibility for aarch64 (arm64) systems and allow for testing of maching learning workloads across processor architectures.

---
## Hardware and OS Requirements

Ubuntu 20.04 and above is suggested for this installation, but it may work with macOS and with some dependancy fixes maybe even Windows. Creating a Docker container with a persistant volume for ingressing and egressing images is best to isolate the environement. 

This project is tested using CI actions on x86, but aarch64 testing cannot be automated and is only tested using Ubuntu Docker containers on an Apple M1 Pro. 

### ARMv7 and other 32-bit systems

Due to lack of development of certain dependancies namely conda and pytorch for armv7 and other 32-bit OS's, the project is limited to 64-bit systems (or not, if you are willing and able to get the problematic dependancies installed)

---
## For x86-64 Processors

The project can be installed and run normally. Installation instructions can be found in the [original project repository](https://github.com/nerdyrodent/VQGAN-CLIP) or with the quick scripts below.

#### Requirements
The system, VM, or container running the project will need basic depedancies installed with:
```bash
apt-get install git python3 python3-pip curl
```

#### Quick install scripts
```bash
git clone https://github.com/LibreCS/vqgarm
cd vqgarm
python3 -m pip install -r requirements.txt
git clone https://github.com/openai/CLIP
git clone https://github.com/CompVis/taming-transformers
mkdir checkpoints
curl -L -o checkpoints/vqgan_imagenet_f16_16384.yaml -C - 'https://heibox.uni-heidelberg.de/d/a7530b09fed84f80a887/files/?p=%2Fconfigs%2Fmodel.yaml&dl=1'
curl -L -o checkpoints/vqgan_imagenet_f16_16384.ckpt -C - 'https://heibox.uni-heidelberg.de/d/a7530b09fed84f80a887/files/?p=%2Fckpts%2Flast.ckpt&dl=1'
```

### Generating Images

Running `generate.py` will generate images, with tags controlling parameters.

- `-cd cpu` forces pytorch to use the CPU for generation (for our testing)
- `-i` controls the number of iterations of the GAN-CLIP system
- `-s` controls the resolution of the image in pixels
- `-p` controls the input phrase to be generated
- `-ii` specifies the path to the starting image (optional)

For example:
```bash
python3 generate.py -cd cpu -i 500 -s 400 400 -p "A painting of a wizard riding a white horse into the sunset"
```

---
## For arm64 Processors

Ubuntu for aarch64 is recommended for maxiumum compatibility, and lack of CI support for arm64 means this project will only be tested in an Ubuntu 20.04 aarch64 docker container. This project's CI testing schema also tests for Windows 10 and macOS compatibility, so they are also theoretically functional.

### Anaconda for arm64

To install conda for arm64, download the installer from the [Anaconda Docs.](https://docs.anaconda.com/anaconda/install/linux-aarch64/)
Run the installer script using:
```bash
bash /PATH/TO/Anaconda3-2021.04-Linux-aarch64.sh
# Replace that path and filename with the downloaded script name
```
Have the changes take effect with:
```bash
source ~/.bashrc
```

VQGAN is built for Python 3.9, to install in the conda environment run:
```bash
conda create --name vqgarm python=3.9
conda acvtivate vqgarm
```


### Pytorch for arm64

Pytorch is also required, and installation instructions for arm systems can be found [on this page](http://mathinf.com/pytorch/arm64/)

To install pytorch for arm64 [kumatea pytorch-aarch64](https://github.com/KumaTea/pytorch-aarch64):
```bash
conda install -c kumatea pytorch cpuonly
```
Alternatively, if numpy also needs to be installed for conda:
```bash
conda install -c kumatea pytorch numpy cpuonly
```

### Installation

Clone required repositories (using `git`):
```bash
git clone https://github.com/LibreCS/vqgarm
cd vqgarm
git clone 'https://github.com/openai/CLIP'
git clone 'https://github.com/CompVis/taming-transformers'
```

#### Quick ImageNet GAN Model Installation
See the section below on VQGAN models for installation instructions for different models, but these quick scripts install the ImageNet_16384 model:
```bash
mkdir checkpoints
curl -L -o checkpoints/vqgan_imagenet_f16_16384.yaml -C - 'https://heibox.uni-heidelberg.de/d/a7530b09fed84f80a887/files/?p=%2Fconfigs%2Fmodel.yaml&dl=1'
curl -L -o checkpoints/vqgan_imagenet_f16_16384.ckpt -C - 'https://heibox.uni-heidelberg.de/d/a7530b09fed84f80a887/files/?p=%2Fckpts%2Flast.ckpt&dl=1'
```

### Generating Images

Running `generate.py` will generate images, with tags controlling parameters.

- `-cd cpu` forces pytorch to use the CPU for generation (for our testing)
- `-i` controls the number of iterations of the GAN-CLIP system
- `-s` controls the resolution of the image in pixels
- `-p` controls the input phrase to be generated
- `-ii` specifies the path to the starting image (optional)

For example:
```bash
python3 generate.py -cd cpu -i 500 -s 400 400 -p "A painting of a wizard riding a white horse into the sunset"
```

---
## VQGAN Models

### Easy ImageNet use

To use the ImageNet GAN model, run the following in the project's conda environment:

```bash
mkdir checkpoints
curl -L -o checkpoints/vqgan_imagenet_f16_16384.yaml -C - 'https://heibox.uni-heidelberg.de/d/a7530b09fed84f80a887/files/?p=%2Fconfigs%2Fmodel.yaml&dl=1'
curl -L -o checkpoints/vqgan_imagenet_f16_16384.ckpt -C - 'https://heibox.uni-heidelberg.de/d/a7530b09fed84f80a887/files/?p=%2Fckpts%2Flast.ckpt&dl=1'
```


### Using other models

To use with a pretrained image generation model, configure and run the `download_models.sh` script to download your model of choice. 

Models can be chosen by editing this section of the `download_models.sh` script. If unchanged, the `Imagenet_16384` model will be downloaded by default.
```shell
# Which models to download?
IMAGENET_1024=false
IMAGENET_16384=true
GUMBEL=false
#WIKIART_1024=false
WIKIART_16384=false
COCO=false
FACESHQ=false
SFLCKR=false
```

### VQGAN Model Training from Custom Datasets
To train a custom VQGAN model off of custom datasets, use the code and follow the steps in [this project](https://github.com/CompVis/taming-transformers#training-on-custom-data)

As of now, custom model generation is only compatible with the CUDA version of Pytorch, so Nvidia GPU(s) are required. 

---
## Notes for Testing

### Test Execution
The original version of this project is intended to run on Nvidia CUDA cores cores and is more efficient in such configuration. To force CPU use, add tag `-cd cpu` in the execution of `generate.py`

For our benchmark testing, the following generate lines were used, each for each testing circumstance
```bash
python3 generate.py -cd cpu -i 500 -s 400 400 -p "A painting of a wizard riding a white horse into the sunset"
python3 generate.py -cd cpu -i 500 -s 400 400 -p "A drawing of a fiery bull fighting a white unicorn"
python3 generate.py -cd cpu -i 500 -s 400 400 -p "A sketch of a yellow bird perched on a green tree"
```
### For VRAM Allocation Errors
Image size is heavily dependant on avaliable VRAM, adjust the `-s 400 400` tag accordingly to accomodate avaliable hardware. Furthermore the tag `-ii /path_to/starting_image` can be used to set a starting image for VQGAN.

If your images look unfinished or blurry, increase the iteration tag `-i 500` to have VQGAN further optimize the image.

### Run Statistics
Runtime and process stats will be printed in this format after each test, if you would like to further build to automate iterative image generation
```python
print('Execution device: ' + args.cuda_device)
print('Processor: ' + platform.processor())
print('Iterations: ' + args.max_iterations)
print('Image Size: ' + args.size)
print('Execution time in seconds: ' + str(executionTime))
```
---
## Contribution

Contributions to this project are greatly appreciated, and no reasonable pull request will be denied. Even more appreciated is hardware testing changes on arm64 processors before pull requesting, which reduces the work required from the hardware team. 

---
