# Follow along

## Pulling an image from Dockerhub

```
# apptainer pull defaults to dockerhub, so you don't need to specify full url
# Don't forget the `docker://` prefix if pulling from some container registry 
# (dockerhub, quay, harbor, etc) and the image is an OCI image.
apptainer pull opensuse.sif docker://opensuse/leap:15.4
# better practice is to use full url
apptainer pull opensuse.sif docker://docker.io/opensuse/leap:15.4
```

Try pulling an Nvidia pytorch container and running it. It will fail.

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



# To build

```
# simpledocker.def
$ apptainer build simpledocker.sif simpledocker.def

# simplelocalimage
$ apptainer pull --disable-cache docker://docker.io/opensuse/leap:15.5
$ apptainer build simplelocalimage.sif simplelocalimage.def

# simpleoras
$ apptainer build simpleoras.sif simpleoras.def
```

