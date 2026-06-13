#Objective: Create HelloWorld application, create linux container image and push it to proget like registry

Repository structure:
cppapp
--.gitea
----workflows
------build-and-push.yml
	name: Build and Push to Local Registry

	on:
	push:
	branches: [ main ]
	
	jobs:
	build-linux-container:
	runs-on: ubuntu-latest
	steps:
	- name: Checkout Code
		uses: actions/checkout@v4
	
	# We skip creating a builder entirely and just use the default one
	# But we run inspect to make sure it's active and see its settings
	- name: Inspect Docker Buildx
		run: |
		docker buildx use default
		docker buildx inspect --bootstrap
	
	- name: Build and Push to Local Registry
		run: |
		docker buildx build \
		--file ./dockerfile \
		--tag host.docker.internal:5001/hello:latest \
		--push \
		.
	

--dockerfile
	#step 1. Build the linux binary
	FROM ubuntu:22.04 AS builder
	RUN apt-get update && apt-get install -y cmake g++ make
	
	WORKDIR /app
	COPY . .
	RUN mkdir build && cd build && cmake .. && make
	
	#Step 2. Minimal runtime image
	FROM ubuntu:22.04
	WORKDIR /root/
	COPY --from=builder /app/build/hello .
	CMD ["./hello"]

--CMakeLists.txt
	cmake_minimum_required(VERSION 3.10)
	project(hello VERSION 1.0)
	add_executable(hello main.cpp)

--main.cpp
	#include <iostream>
	int main()
	{
		std::cout << "Hello world" << std::endl;
	}


##Steps:

(Check that following results into hello application being created)
mkdir build
cd build
cmake ..
cmake --build .

1. Create above repository
2. brew install --cask docker (This installs Docker Desktop)
3. brew install cmake
4. brew install gitea	(This is like github but local)
5. In Terminal run => gitea web
	go to localhost:3000 and complete the account creation etc
	Choose SQLite for keeping it all localhost
	Go to Site Administration -> Actions -> Runners and copy the token to create a runner
	
	Create a runner in terminal:
	
	docker run -d --name local-runner \
	-e GITEA_INSTANCE_URL=http://host.docker.internal:3000 \
	-e GITEA_RUNNER_REGISTRATION_TOKEN=YOUR_TOKEN_HERE \
	-v /var/run/docker.sock:/var/run/docker.sock \
	gitea/act_runner:latest

6. Insecure Registry Handling
	Open your Docker Desktop Settings on your Mac:
	Go to Settings (Gear Icon) -> Docker Engine.
	Add your local registry to the insecure-registries array:
	{"insecure-registries": ["localhost:5001"]}
	Click Apply & restart.
	
7. Initialize the repo in the gitea web so that you can sync the local repo and commit to its
8. Run local/native registry (like proget) by running
	docker run -d -p 5001:5000 --restart always --name local-registry registry:2
9. Check in browser that http://localhost:5001/v2/_catalog results into {"repositories":[]}
10. Now, if you commit to the repo, it should results into {"repositories":["hello"]}
  