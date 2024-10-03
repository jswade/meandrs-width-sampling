# MeanDRS Width Sampling
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13381368.svg)](https://doi.org/10.5281/zenodo.13381368)

[![License (3-Clause BSD)](https://img.shields.io/badge/license-BSD%203--Clause-yellow.svg)](https://github.com/jswade/meandrs-width-sampling/blob/main/LICENSE)

[![Docker Images](https://img.shields.io/badge/docker-images-blue?logo=docker)](https://hub.docker.com/r/jswade1/meandrs-width-sampling/tags)

[![GitHub CI Status](https://github.com/jswade/meandrs-width-sampling/actions/workflows/github_actions_CI.yml/badge.svg)](https://github.com/jswade/meandrs-width-sampling/actions/workflows/github_actions_CI.yml)

[![GitHub CD Status](https://github.com/jswade/meandrs-width-sampling/actions/workflows/github_actions_CD.yml/badge.svg)](https://github.com/jswade/meandrs-width-sampling/actions/workflows/github_actions_CD.yml)

The Earth’s rivers vary in size across several orders of magnitude. Yet, the 
relative significance of small upstream reaches compared to large downstream 
rivers in the global water cycle remains unclear, challenging the determination 
of adequate spatial resolution for observations. Using monthly simulations of 
river stores and fluxes from the MeanDRS river routing dataset, we sample 
global rivers by a range of estimated river width thresholds to investigate the
intrinsic spatial scales of the global river water cycle. We frame these 
scale-dependent river dynamics in terms of observational capabilities, 
assessing how the size of rivers that can be resolved influences our ability to
capture key global hydrologic stores and fluxes. 
 
We aim to answer two questions:
1.    What is the intrinsic spatial resolution of global river dynamics?
2.    How can the spatial scale of river processes be used to inform efficient 
monitoring and modeling strategies of global river stores and fluxes? 


## Installation with Docker
Installing meandrs-width-sampling is **by far the easiest with Docker**. This 
document was written and tested using
[Docker Community Edition](https://www.docker.com/community-edition#/download)
which is available for free and can be installed on a wide variety of operating
systems. To install it, follow the instructions in the link provided above.

Note that the experienced users may find more up-to-date installation
instructions in
[Dockerfile](https://github.com/jswade/meandrs-width-sampling/blob/main/Dockerfile).

### Download meandrs-width-sampling
Downloading meandrs-width-sampling with Docker can be done using:

```
$ docker pull jswade1/meandrs-width-sampling
```

### Install packages
With Docker, there is **no need to install anymore packages**.
meandrs-width-sampling is ready to go! To run it, just use:

```
$ docker run --rm -it jswade1/meandrs-width-sampling
```

## Installation on Debian
This document was written and tested on a machine with a **clean** image of 
[Debian 11.7.0 ARM64](https://cdimage.debian.org/cdimage/archive/11.7.0/arm64/iso-cd/debian-11.7.0-arm64-netinst.iso)
installed, *i.e.* **no upgrade** was performed. 
Similar steps **may** be applicable for Ubuntu.

Note that the experienced users may find more up-to-date installation 
instructions in
[github\_actions\_CI.yml](https://github.com/jswade/meandrs-width-sampling/blob/main/.github/workflows/github_actions_CI.yml).

### Download meandrs-width-sampling
First, update package index files: 

```
$ sudo apt-get update
```

Then make sure that `ca-certificates` are installed: 

```
$ sudo apt-get install -y ca-certificates
```

Then make sure that `git` is installed: 

```
$ sudo apt-get install -y --no-install-recommends git
```

Then download meandrs-width-sampling:

```
$ git clone https://github.com/jswade/meandrs-width-sampling
```

Finally, enter the meandrs-width-sampling directory:

```
$ cd meandrs-width-sampling/
```

### Install APT packages
Software packages for the Advanced Packaging Tool (APT) are summarized in 
[requirements.apt](https://github.com/jswade/meandrs-width-sampling/blob/main/requirements.apt)
and can be installed with `apt-get`. All packages can be installed at once using:

```
$ sudo apt-get install -y --no-install-recommends $(grep -v -E '(^#|^$)' requirements.apt)
```

> Alternatively, one may install the APT packages listed in 
> [requirements.apt](https://github.com/jswade/meandrs-width-sampling/blob/main/requirements.apt)
> one by one, for example:
>
> ```
> $ sudo apt-get install -y --no-install-recommends python3.9
>```

Also make sure that `python3` points to `python3.9`:

```
$ sudo rm -f /usr/bin/python3
$ sudo ln -s /usr/bin/python3.9 /usr/bin/python3
```

### Install Python packages
Python packages from the Python Package Index (PyPI) are summarized in
[requirements.pip](https://github.com/jswade/meandrs-width-sampling/blob/main/requirements.pip)
and can be installed with `pip`. But first, let's make sure that the latest
version of `pip` is installed

```
$ wget https://bootstrap.pypa.io/pip/get-pip.py
$ sudo python3 get-pip.py --no-cache-dir `grep 'pip==' requirements.pip` `grep 'setuptools==' requirements.pip` `grep 'wheel==' requirements.pip`
$ rm get-pip.py
```

All packages can be installed at once using:

```
$ sudo pip3 install --no-cache-dir -r requirements.pip
```

> Alternatively, one may install the PyPI packages listed in 
> [requirements.pip](https://github.com/jswade/meandrs-width-sampling/blob/main/requirements.pip)
> one by one, for example:
>
> ```
> $ sudo pip3 install pandas==1.3.5
> ```
