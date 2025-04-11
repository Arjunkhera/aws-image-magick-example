

## Steps to test

docker run -d --name amazonlinuxmagick amazonlinuxmagick tail -f /dev/null
docker exec -it amazonlinuxmagick /bin/bash
docker cp amazonlinuxmagick:/images/converted.jpeg ./
docker cp amazonlinuxmagick:/root/result ./imagemagick/
docker cp magick-test:/app/images/converted.jpeg ./images/converted-2.jpeg