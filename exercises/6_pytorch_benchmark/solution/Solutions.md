# Solutions
Included is the correct submit script, which can be used to run both benchmarks 

## Exercise
Create your image with
```
apptainer build pytorch_rocm720.sif docker://docker.io/rocm/pytorch:rocm7.2_ubuntu24.04_py3.12_pytorch_release_2.8.0
```

## Bonus
To use your container's shell
```
apptainer shell --rocm pytorch_rocm720.sif
```