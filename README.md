# vqgarm - VQGAN+CLIP for Process Architecture Testing

![Example Image](https://korii.slate.fr/sites/default/files/styles/1440x600/public/champdechienselectriques.jpg)
---
![Run Test](https://github.com/LibreCS/vqgarm/actions/workflows/running.yml/badge.svg) ![Build Test](https://github.com/LibreCS/vqgarm/actions/workflows/test.yml/badge.svg) ![Dependancies Test](https://github.com/LibreCS/vqgarm/actions/workflows/requirements.yml/badge.svg) ![GitHub last commit](https://img.shields.io/github/last-commit/LibreCS/vqgarm) ![GitHub](https://img.shields.io/github/license/LibreCS/vqgarm)
---
A repo for running VQGAN+CLIP locally. This started out as a Katherine Crowson VQGAN+CLIP derived Google colab notebook, and further derived from a project to run the notebook locally using Anaconda for Python found [in this repository](https://github.com/nerdyrodent/VQGAN-CLIP)

This project aims to provide compatibility for arm64-based systems and allow for testing of maching learning workloads across processor architectures.

---
## Hardware and OS Requirements

This project is only tested on an AMD-based x86-64 system (should not differ for Intel processors) and a Raspberry Pi 3B+. For simplicity, it will be tested in an arm64 docker container running on an Apple M1 Pro.

64-bit installations of your distro of choice (only tested on Ubuntu 20.04 LTS) are required for this project to run smoothly. Due to lack of development of certain dependancies namely conda and pytorch for armhf and other 32-bit OS's, the project is limited to 64-bit systems (or not, if you are willing and able to get the problematic dependancies installed)

---
## For x86-64 Processors

The project can be installed and run normally, and for testing purposes Ubuntu 20.04 LTS will be used to provide consistancy. Installation instructions can be found in the [original project repository](https://github.com/nerdyrodent/VQGAN-CLIP)

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

---
## For arm64 Processors

Ubuntu 20.04 or 22.04 for arm64 is recommended to provide maximum compatibility, and testing for arm64 compatibility will only be done with the Raspberry Pi model 3B+. 

This project's CI testing schema also tests for Windows 10 and macOS compatibility, so they are also theoretically functional.

### Anaconda for arm64

To install conda for arm64, download the installer from the [Anaconda Docs](https://docs.anaconda.com/anaconda/install/linux-aarch64/)
Run the installer script using (change the command based on the `Anaconda3-202X.XX-Linux-aarch64.sh` file)
```bash
bash ~/Anaconda3-2021.04-Linux-aarch64.sh
```
Have the changes take effect with 
```bash
source ~/.bashrc
```

VQGAN is built for Python 3.9, to install in the conda environment run 
```bash
conda install python=3.9
```

#### For Legacy Systems

Miniconda has wider compatibility for legacy systems, installation instructions can be found [in this thread](https://stackoverflow.com/questions/39371772/how-to-install-anaconda-on-raspberry-pi-3-model-b)

### Pytorch for arm64

Pytorch is also required, and installation instructions for arm systems can be found [on this page](http://mathinf.com/pytorch/arm64/)

To install pytorch stable using conda for cpu-only processing
```bash
conda install pytorch torchvision torchaudio cpuonly -c pytorch
```

Note: Pytorch nightly build can also be installed with these commands
```bash
python3 -m pip install numpy
python3 -m pip install --pre torch torchvision torchaudio -f https://download.pytorch.org/whl/nightly/cpu/torch_nightly.html
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

To use with a pretrained image generation model, configure and run the `download_models.sh` script to download your model of choice. A word of caution, these models are massive and take huge amounts of disk space, bandwith, and time to download, so choose your model(s) and download location carefully.

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
The original version of this project is intended to run on GPU CUDA cores and is more efficient in such configuration. To force CPU use, add tag `-cd cpu` in the execution of `generate.py`

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
