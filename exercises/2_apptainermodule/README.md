Build a container image based on the opensusempich342rocm624.sif image from
earlier with a script that prints out the `LD_LIBRARY_PATH` value. Create a job
script that updates the `APPTAINERENV_LD_LIBRARY_PATH` environment variable
with some value before running the srun command. And then in the srun, execute
with the container a script that prints out the value of the `LD_LIBRARY_PATH`
inside the running container.
