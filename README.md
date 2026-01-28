This repository is to accompany the March 26 2026 Container training. This tutorial
is mostly standalone and can be used independent of the training.

# Follow along

## NOTE
If you find yourself encountering an error that looks like the below
when you execute `apptainer pull` or `apptainer build`, then try using the flag
`--disable-cache` i.e. `apptainer pull --disable-cache`. 

```
FATAL:   While performing build: conveyor failed to get: while fetching library image: cached file hash(sha256:74b3763bbffd3cbaa355240994d684318fe64087fd1f70bdd8eaa6c64072683b) and expected hash(sha256:4fa8838b548fe90a161541ba06777ca32ed235666b0f55d7df34150dbd11c237) does not match
```

If you encounter an error that says something along the lines of 'disk quota exceeded', 
that likely means you run out of space in your home directory. You can delete `~/.apptainer/cache` to 
remove the cached stuff from Apptainer.

Now onto the tutorial!

## apptainer pull, shell, exec commands

apptainer pull defaults to dockerhub, so you don't need to specify full url
Don't forget the `docker://` prefix if pulling from some container registry 
(dockerhub, quay, harbor, etc) and the image is an OCI image.

```
apptainer pull opensuse.sif docker://opensuse/leap:15.4
```

Better practice is to use full url to indicate which registry you are getting
the image from.

```
apptainer pull opensuse.sif docker://docker.io/opensuse/leap:15.4
```

To start a container and open an interactive shell with the image you pulled,
 use `apptainer shell`

```
apptainer shell opensuse.sif
Apptainer> cat /etc/os-release
NAME="openSUSE Leap"
VERSION="15.4"
ID="opensuse-leap"
ID_LIKE="suse opensuse"
VERSION_ID="15.4"
PRETTY_NAME="openSUSE Leap 15.4"
ANSI_COLOR="0;32"
CPE_NAME="cpe:/o:opensuse:leap:15.4"
BUG_REPORT_URL="https://bugs.opensuse.org"
HOME_URL="https://www.opensuse.org/"
DOCUMENTATION_URL="https://en.opensuse.org/Portal:Leap"
LOGO="distributor-logo-Leap"
```

The container you are pulling or building has to match the capabilities and 
architecture of the hardware you are using. Try pulling an Nvidia pytorch 
container onto Frontier and running it. It will fail.

```
apptainer pull pytorch.sif docker://nvcr.io/nvidia/pytorch:24.07-py3
apptainer shell --rocm pytorch.sif
> python3
>>> import torch
>>> t = torch.rand(2,3,4)
>>> t.to('cuda')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/usr/local/lib/python3.10/dist-packages/torch/cuda/__init__.py", line 311, in _lazy_init
    torch._C._cuda_init()
RuntimeError: Found no NVIDIA driver on your system. Please check that you have an NVIDIA GPU and installed a driver from http://www.nvidia.com/Download/index.aspx
```

To start a container and execute a command within it, use `apptainer exec`

```
apptainer exec opensuse.sif gcc --version
```


## To build container image from .def files

```
$ cd examples/1_buildcontainers

# simpledocker.def
$ apptainer build simpledocker.sif simpledocker.def

# simplelocalimage
$ apptainer pull --disable-cache opensuse.sif docker://docker.io/opensuse/leap:15.5
$ apptainer build simplelocalimage.sif simplelocalimage.def

# simpleoras
$ apptainer build simpleoras.sif simpleoras.def
```


## Copy a file from filesystem into container image during build, and setting environment variables in the container

```
$ cd examples/2_files
# create a file named hello.c that prints hello world
# then build the container

$ apptainer build copyfile.sif copyfile.def
```

You will see in the `copyfile.def` there are sections `%files` and `%environment`.
The `%files` section let you copy a file from the host filesystem into the container,
and `%environment` let you set environment variables that will be active during the 
container run (provided you don't override them when you launch your container). 

In this example, we are updating the PATH in the container to include `/mybin` which
is also where we are putting our hello world program. So we can execute this program
without needing the full file path.

```
$ apptainer exec copyfile.sif hello
$ apptainer shell copyfile.sif
Apptainer> echo $PATH
```

**Pause for Exercise:** Navigate to `exercises/1_simpleimage` and complete the 
exercise

## Pushing a SIF file you create to a registry that supports OCI Registry As Storage (ORAS)

SIF files are just files. So you can move them around just like an ordinary file.

SIF files are not OCI images i.e. they are not structured the same as Docker and Podman images.
So you can't push a SIF into an OCI registry as is. Some OCI registries support OCI Registry As 
Storage (ORAS) which allow you to push and store arbitrary software artifacts in an OCI
registry. You can use this to store a SIF file in a supported OCI registry like Dockerhub.

First create an account on [Dockerhub](hub.docker.com).
Then go to Account Settings -> Personal Access Token -> Generate New Token.
Copy the token (you will not be able to copy it later).

Then from the command line run the below command to establish a connection to Dockerhub.
Paste the token you just copied when prompted.

```
apptainer registry login --username <your username> oras://registry-1.docker.io
Password/Token:
```
Now you can push your SIF file into the registry
```
apptainer push opensuse.sif oras://registry-1.docker.io/<your dockerhub username>/opensuse:latest
```

Now you can go to Dockerhub and check that your SIF file has been uploaded. You will see that
it is labelled as an 'artifact'. Your user page can be reached at `hub.docker.com/u/<your username>`.

To get this image, you can run the `apptainer pull` command like so:

```
apptainer pull opensuse.sif oras://docker.io/subilabrahamornl/opensuse:latest
```

Notice in the above that you are using `docker.io` instead of `registry-1.docker.io`. This 
is an idiosyncracy of Dockerhub we have to live with for now.

There are other registries that support ORAS. See here: https://oras.land/adopters/


## Running your container in a job with Slurm
```
$ cd examples/3_simplejob
$ apptainer build simpleoras.sif simpleoras.def
```

Edit the submit.sl file to use your project id and then submit the submit.sl file
```
$ sbatch submit.sl
```

## Running containerized applications that use MPI and GPU

In order to let your application in your container use the MPI and GPU
facilities provided by Frontier, we need to set some environment variables. We
also need to make sure that we install a version of MPICH and ROCm inside the
container that is compatible with the versions on Frontier. MPICH 3.4.2 or
3.4.3 are ABI compatible with the Cray MPICH 8.x available on Frontier (or
4.1.2 if you are using Cray MPICH 9.x), so that is what is preferred you
install in your container. And install whichever version of ROCm in the
container image that you plan to load as a module on Frontier.

Clone the `olcf_container_examples` repository

```
git clone https://github.com/olcf/olcf_containers_examples
cd olcf_container_examples/frontier/containers_on_frontier_docs/gpu_aware_mpi_example
```


Take a moment to examine the opensusempich342rocm624.def. You can build it with
```
apptainer build opensusempich342rocm624.sif opensusempich342rocm624.def
```

This build will take a while, so to save you some time just copy the pre-built image
```
cp /lustre/orion/stf007/world-shared/subil/hands_on_containers_on_frontier_resources/opensusempich342rocm624.sif .
```

Take a moment to inspect the `submit.sbatch` file and read explanations for why we
are setting each of those environment variables. We have modules that will automatically 
handle all of this (which we will cover in a later section), but if you want a better 
understanding of what those modules are doing under the hood and why, this will explain it.

Submit the `submit.sbatch` file. The output file will be in the `logs` directory in the
current directory.


## Using the apptainer-enable-mpi and apptainer-enable-gpu modules

On Frontier, You don't have have to manage all the environment variables and settings
you encountered in the previous section. Frontier provides a few modules to make that
easier. 

To set up all the environment variables needed, you will load the following

```
module load olcf-container-tools
module load apptainer-enable-mpi
module load apptainer-enable-gpu
```

If you inspect modules with `module show <modulename>` you will see the environment
variables being set up. You will notice that the environment variables use a prefix
`APPTAINER_WRAPPER` instead of the normal `APPTAINER` or `APPTAINERENV` prefixes 
we saw in the `submit.sbatch` in the previous section. The modules we loaded sets up an 
apptainer wrapper (see 
`/sw/frontier/olcf-container-tools/apptainer-wrappers/bin/bash/apptainer`) which will
which will append the `APPTAINER_WRAPPER*` environment variables to the correct
`APPTAINER*` and `APPTAINERENV*` environment variables. This wrapper makes it so that
you can define values for the `APPTAINER*` or `APPTAINERENV*` environment variables 
with whatever you want e.g. you could set 

```
module load olcf-container-tools
module load apptainer-enable-mpi
module load apptainer-enable-gpu
export APPTAINERENV_LD_LIBRARY_PATH=$HOME/mylibs
apptainer exec mycontainersif.sif /checkldlibs.sh
```

And the apptainer wrapper, when executed, will modify the `APPTAINERENV_LD_LIBRARY_PATH`
to be `APPTAINERENV_LD_LIBRARY_PATH=$HOME/mylibs:$APPTAINER_WRAPPER_LD_LIBRARY_PATH` and
then execute the actual apptainer executable with your arguments.

To see an example of the modules in use, go to `olcf_container_examples`
repository you cloned in the previous section 

```
cd olcf_container_examples/frontier/containers_on_frontier_docs/apptainer_wrapper_lammps/gpu
apptainer build lammps.sif lammps.def
```

`lammps.sif` pulls one of the OLCF base images (which we'll talk about in the next section)
and builds a container with LAMMPS installed in it.

(To save you some time, copy the `lammps.sif` from
`/lustre/orion/stf007/world-shared/subil/hands_on_containers_on_frontier_resources`).

Open the `submit.slurm` to see how we load the modules and run LAMMPS with the
container.  Try submitting the job and see it work.

**NOTE**: Make sure you load the container modules only for running the
container. They should not be loaded during build. This is because
`APPTAINER_BINDPATH` environment variable which is set by one of the modules is
read by the `apptainer build` command, and will cause the build to fail with an
error message like
```
FATAL:   container creation failed: mount hook function failure: mount /opt/cray->/opt/cray error: while mounting /opt/cray: destination /opt/cray doesn't exist in container
```
`apptainer exec` is able to automatically create directories in the container
to mount the host directories listed in `APPTAINER_BINDPATH`, but that is not
done during `apptainer build` hence error.


**Pause for Exercise:** Navigate to `exercises/2_apptainermodule` and complete the exercise


## OLCF provided base images

OLCF provides a few base container images that aim to be compatible with
specific Programming Environment (PE) versions provided by HPE on Frontier.
The base image will have installed in it the compiler, the MPICH version, and
ROCm version that matches those in the specified PE version. You can see the
[Containers on Frontier docs section on base
images](https://docs.olcf.ornl.gov/software/containers_on_frontier.html#olcf-base-images-apptainer-modules)
for more information on what base images are available for which Cray PE
version and what software is in those base images.

If you are building and running an MPI+GPU application, it is HIGHLY recommended you
use one of the OLCF base images as your base.

**We currently cannot provide any base images installed with the Cray Clang
compilers, or other Cray software installed within the image. The base images
will only have non Cray software. We can provide base images with GNU and AMD
software that matches the versions in the GNU and AMD PEs provided in Frontier
, but we cannot provide Cray's own
proprietary software.**

You will remember that the LAMMPS container example from the previous section used
one of the base images (check the `lammps.def` file). 


**Pause for exercise:** Navigate to `exercises/3_mpigpuimage` and complete the
exercise where you will build and run a container with the OSU MPI
microbenchmarks.

## Multistage builds

An unfortunate aspect of container images sometimes is that since its often an
entire Linux distribution and then some, the container image files can get
pretty big! For example, if you look at the container image you created in the
previous section, it's around 4GB. The base images are big to provide everything 
you need to build and run. For the most part, this isn't an issue. Each
running container instance isn't resident in memory taking up 4GB at a time.
The only memory used is the memory used by the executable you are running from
the container, same as if you were running natively. 

However, if you still find yourself with a need to work with a smaller
container image (say you have to upload it somewhere with size limits), you can
go through and delete files you don't need by performing `rm` operations in the
`%post` section of you .def file to reduce the final size of your container
image. Or you can do a _multistage build_ where you build your executable in
one stage with all the required development libraries, and then copy that
executable into a smaller, more minimal container image that only has the
required runtime libraries. The containers images that are created during the
initial stages are deleted, and only the container image
created in the last stage is kept. 

There is no specific process to creating a runtime-only image, it all depends on
your application. Only you know what runtime files your particular application
needs that need to be copied into your final image. 

Let's look at an example.

```
cd examples/4_multistagebuild
```

The `lammps.def` file in this directory should look familiar. It's the image that we built
in one of the earlier sections. Compare the `lammps.def` file with the `lammpsmultistagesimple.def`.
In `lammpsmultistagesimple.def` we see how we have two "Stages", one named 'devel' and one named 
'final'. The `'devel' stage is the same as what we saw before. The 'final' stage uses the same base
image in the `From:` directive as the 'devel' stage, and then copies the `lmp` executable from the 
'devel' stage to the 'final' stage. The container image created in the 'final' stage is what is 
saved at the end of the build. The container image created in the 'devel' stage isn't saved.

There's no big difference in size between the container images created from `lammps.def` and
`lammpsmultistagesimple.def` because they both use the same base image which has the development
and runtime libraries. 

Now compare `lammpsmultistagesimple.def` and `lammpsmultistagecomplex.def`. Here, in the 'final' stage we
are using just `ubuntu:22.04` as our base which is a lot smaller in size than the OLCF base image.
And because we don't have all the runtime libraries that we need in this ubuntu image, we have 
to copy a bunch of them from the 'devel' stage into the 'final' stage to a location where your
application (which you are also copying into the 'final' stage) can discover them at runtime.

You will see that the container built by `lammpsmultistagecomplex.def` is a lot smaller.

If you go this route, there will be some trial and error involved when you identifying the runtime
libraries that you need to copy between stages. So use the bigger images as is since it is much more 
convenient. But multistage builds are a useful tool to have
in your back pocket should you ever need it.

(To save you some time, copy the `lammps.sif lammpsmultistagesimple.sif lammpsmultistagecomplex.sif`
from `/lustre/orion/stf007/world-shared/subil/hands_on_containers_on_frontier_resources`)



**Pause for Exercise:** Navigate to `exercises/4_stagedbuilds` and complete the exercise.
 




# Resources

- Apptainer documentation: https://apptainer.org/docs/user/main/index.html
- Containers on Frontier documentation: https://docs.olcf.ornl.gov/software/containers_on_frontier.html
- Container examples: https://github.com/olcf/olcf_containers_examples/
- Questions/Support when using containers on Frontier - help@olcf.ornl.gov




