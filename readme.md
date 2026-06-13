#Setup up helloworld application
-- Here, if we run hello application, it should be showing Hello World!

#Setup pipeline







# Run the local runner as a container
docker run -d --name local-runner \
  -e GITEA_INSTANCE_URL=http://host.docker.internal:3000 \
  -e GITEA_RUNNER_REGISTRATION_TOKEN=c7C09v3mwXkrEyGPoTCvRqCGHiDABv0JZ16oxdRv \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitea/act_runner:latest
  
  