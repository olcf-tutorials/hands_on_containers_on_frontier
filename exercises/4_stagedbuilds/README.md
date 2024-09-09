Try creating a multistage build for the OSU benchmarks exercise you worked on. 
See if you can copy just the `osu_allgather` OSU benchmark executable and its required libraries
from the devel stage to a final stage in your def file, where the final stage is composed
of a minimal linux distro container image and the required files for the benchmark executables. 
And get this smaller container image to run correctly in a job.
