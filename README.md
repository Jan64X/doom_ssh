# Doom ASCII Docker Image

Im not really sure what this is or who its for, but I'm just going to leave it here.
uhh run the container and just kinda play i guess, idk im sleepy.

Example usage ig:
```
docker run -d --name doom_ascii -p 8008:8008 -v /path/to/doom.wad:/wad/doom.wad doom_ascii
```

Building:
```
docker build -t doom_ascii .
```

I should propably add a a reminder how i built these images and pushed em...
```
DOCKERHUB_USERNAME="user"  # lowercase username
GITHUB_USERNAME="user"     # lowercase username
IMAGE_NAME="doom_ssh"

docker buildx build --platform linux/amd64,linux/arm64 \
  --tag ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:amd64 \
  --tag ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:arm64 \
  --tag ghcr.io/${GITHUB_USERNAME}/${IMAGE_NAME}:amd64 \
  --tag ghcr.io/${GITHUB_USERNAME}/${IMAGE_NAME}:arm64 \
  --push .
```
