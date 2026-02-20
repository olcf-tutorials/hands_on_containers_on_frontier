# HINTS

## Exercise
* To create your image file, you should use an Apptainer command to build from the linked ROCm registry.
It's best to specify the pulled image's format as `docker`
* To run your submit script you can use `sbatch submit.sl`
* OLCF uses the port `3442` most commonly for PyTorch

## Bonus
* There is an Apptainer command you can use to drop yourself into a live container's shell.
You can find Apptainer commands here: https://apptainer.org/docs/user/main/cli