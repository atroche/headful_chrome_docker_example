This is a minimal failing example of running headful (non-headless) Chrome with Xvfb on Cloud Run. The local Docker image runs fine, but Chrome dumps its core on Cloud Run, despite the image being identical. It consists of a Dockerfile, and a shell script.

In the local test, I also use ffmpeg to make a video from Xvfb, to demonstrate that it works fine. I don't do this for the Cloud Run version.

To test locally:

```bash
docker build . -t headful_chrome
docker run --rm --name chrome_recording -v $PWD:/output  -it headful_chrome
```

The image can take a while to build, so you might prefer to pull from [its Docker Hub repo](https://hub.docker.com/r/atroche/headful_chrome_docker_example):

```bash
docker pull atroche/headful_chrome_docker_example
```

Then open up the `screen.webm` file in your working directory.

To test on Cloud Run, push the image up to GCR and create a service / deploy a revision from the image. It should fail
to deploy, and in the logs you should see some error logging from Chrome that looks like this:

![error logs](https://i.imgur.com/bIg2zzN.png)
