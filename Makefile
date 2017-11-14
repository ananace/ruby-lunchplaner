all: image

image:
	docker build -t gitlab.it.liu.se:5000/aleol57/lunchplaner .

publish: image
	docker push gitlab.it.liu.se:5000/aleol57/lunchplaner

.PHONY: all image publish
