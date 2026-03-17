# vLLM On Frontier
## About
vLLM is an AI inferencing and serving application that can deploy and scale popular models on HPC systems.

You can read more about vLLM on the [project's documentation](https://docs.vllm.ai/en/latest/).

AMD provides ROCm container images that we can leverage on Frontier.
These images can be found on the ROCm Dockerhub page: https://hub.docker.com/r/rocm/vllm

This example was adapted from the OLCF Containers Example page found here: https://github.com/olcf/olcf_containers_examples/tree/main/frontier/sample_apps/vllm

## Example - Running astrollama-2-7b-base_abstract
### Download the Image
Download the vLLM container image from Dockerhub:
```bash
apptainer pull --disable-cache vllm_rocm.sif docker://docker.io/rocm/vllm:rocm6.3.1_vllm_0.8.5_20250513
```

> [!NOTE]
> You may notice that the version of ROCm we are using is older than the current version of ROCm.
> New vLLM images with newer versions of ROCm are not yet ready for Frontier.
> We are working closely with AMD to bring first-class support for Frontier to the vLLM image.

For your convenience in the case of long build times, a pre-built image has been made available here:
```bash
/lustre/orion/stf007/world-shared/2026-hands-on-containers/vllm_rocm.sif
# copy to your working directory
cp /lustre/orion/stf007/world-shared/2026-hands-on-containers/vllm_rocm.sif ./
```

### Download the Model
Download the `astrollama` model:
```bash
module load git-lfs
git lfs install
git clone https://huggingface.co/AstroMLab/astrollama-2-7b-base_abstract
```

For your convenience in the case of slow downloads, the model has been made available here:
```bash
/lustre/orion/stf007/world-shared/2026-hands-on-containers/astrollama-2-7b-base_abstract
# copy to your working directory
cp -r /lustre/orion/stf007/world-shared/2026-hands-on-containers/astrollama-2-7b-base_abstract ./
```

### Submit the Job
```bash
sbatch submit.sl
```

### Check the output
```bash
$ cat logs/headnodelog
$ cat logs/headnodelog | grep RayWorkerWrapper
# should show a progress bar like the following:
Capturing CUDA graph shapes:  97%|█████████▋| 34/35 [00:14<00:00,  2.31it/s](RayWorkerWrapper pid=423823, ip=10.128.40.0)
Capturing CUDA graph shapes: 100%|██████████| 35/35 [00:15<00:00,  2.29it/s](RayWorkerWrapper pid=423823, ip=10.128.40.0)
Capturing CUDA graph shapes:  69%|██████▊   | 24/35 [00:11<00:05,  2.07it/s] [repeated 25x across cluster]ip=10.128.34.16)
Capturing CUDA graph shapes:  97%|█████████▋| 34/35 [00:15<00:00,  2.24it/s] [repeated 3x across cluster] ip=10.128.36.16)
Capturing CUDA graph shapes: 100%|██████████| 35/35 [00:15<00:00,  2.23it/s](RayWorkerWrapper pid=322966, ip=10.128.36.16)

$ cat logs/vllmmult_*.out | grep Completion
# should show result of inference similar to the following:
Completion result: Completion(id='cmpl-cbf13732ffb74eebab29cb8e43a378f0', choices=[CompletionChoice(finish_reason='length', index=0, logprobs=None, text=' leading example for the formation of dwarf spheroidal (dS', stop_reason=None, prompt_logprobs=None)], created=1771614574, model='./astrollama-2-7b-base_abstract', object='text_completion', system_fingerprint=None, usage=CompletionUsage(completion_tokens=16, prompt_tokens=8, total_tokens=24, completion_tokens_details=None, prompt_tokens_details=None))
```