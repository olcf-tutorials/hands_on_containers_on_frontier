# PyTorch Distributed Data Parallel Exercises
PyTorch examples borrowed from: [PrincetonUniversity/multi_gpu_training](https://github.com/PrincetonUniversity/multi_gpu_training/tree/main), from the OLCF docs, and from the [OLCF Container Example repository](https://github.com/olcf/olcf_containers_examples/tree/main/frontier/sample_apps/pytorch/amdrocmregistry)
## Exercise
1. Pull the ROCm 7.2.0/PyTorch 2.8.0 Image here to create an Apptainer image file
https://hub.docker.com/r/rocm/pytorch/tags

For your convenience in the case of long build times, a pre-built image has been made available here:
```bash
/lustre/orion/stf007/world-shared/2026-hands-on-containers/pytorch_rocm720.sif
# copy to your working directory
cp /lustre/orion/stf007/world-shared/2026-hands-on-containers/pytorch_rocm720.sif ./
```

2. Use your new image to run the included `microbench_olcf.py` by updating the TODO's in `submit.sl`.

HINT: the arguments required for `microbench_olcf.py` are the "master address" `--master_addr=` and "master port" `--master_port=`. The latter can be any number.

## Bonus
Use the image from the exercise above to run the other benchmark, `multinode_olcf_mnist_princeton_nompi4py.py`

1. Download the required data set.

This is easiest to accomplish inside of your existing image/container.
You can start a Python interpreter with the command `python3` inside the container and run the following Python code:
```python
from torchvision import datasets
dataset1=datasets.MNIST('./data',download=True)
```
2. Modify the `submit.sl` file to run the new Python script.

HINT: the arguments should be the same as they were for `microbench_olcf.py`.
