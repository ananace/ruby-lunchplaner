all: image

image:
	docker build -t gitlab.it.liu.se:5000/aleol57/lunchplaner .

publish: image
	docker push gitlab.it.liu.se:5000/aleol57/lunchplaner

deploy:
	$(eval PREVID := $(shell kubectl --namespace=lunchplaner get pods -l "app=production" -o name))
	echo "Prev: $(PREVID)"
	kubectl --namespace=lunchplaner scale --replicas=2 deployment lunchplaner
	while [ $$(kubectl --namespace=lunchplaner get pods -l "app=production" -o custom-columns=name:metadata.name,status:status.phase | tail -n+2 | grep Running | grep 1/1 | wc -l) -lt 2 ]; do sleep 5; done
	kubectl --namespace=lunchplaner delete $(PREVID) &
	kubectl --namespace=lunchplaner scale --replicas=1 deployment lunchplaner

.PHONY: all deploy image publish
