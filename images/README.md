# Image Build Guide

Packer images built are available on google cloud at [Cloud Images](<https://console.cloud.google.com/compute/images?project=learning-map-app>)

Custom Docker images are available on the google Container Registry at [Container Registry] (<https://console.cloud.google.com/gcr/images/learning-map-app?project=learning-map-app>).
Links to such images are at `gcr.io/learning-map-app/[image-name][:TAG|@DIGEST]`

To update or edit images

## For Packer Images

- Duplicate the `template`.json.tmpl file and rename (removing the .tmpl extension)
- Modify the packer template file and run the command
>- `packer build template-file.json`

## For Docker Images

- Modify the Dockerfile then build and tag the image
>- `docker build -t gcr.io/learning-map-app/[image-name][:TAG|@DIGEST] .`
>- [image-name] is the name of the image
>- [:TAG|@DIGEST] is optional and defaults to latest

- Push the image to the GCR
>- `docker push gcr.io/learning-map-app/[image-name][:TAG|@DIGEST]`

- For example

```shell
docker build -t gcr.io/learning-map-app/gcloud-circle:latest .
docker push gcr.io/learning-map-app/gcloud-circle:latest
```

N.B Before you can push or pull from the GCR, you would need to authenticate with docker.
This could be done by running the following command
`docker login -u _json_key --password-stdin https://gcr.io < keyfile.json`

Here, `keyfile.json` is a google service account file
