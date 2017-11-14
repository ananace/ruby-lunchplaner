all: image

image:
	docker build -t gitlab.it.liu.se:5000/aleol57/lunchplaner .

publish: image
	docker push gitlab.it.liu.se:5000/aleol57/lunchplaner

deploy: publish
	$(eval PREVID := $(shell kubectl get pods -l "app=lunch" -o name))
	echo "Prev: $(PREVID)"
	kubectl scale --replicas=2 deployment lunchplaner
	while [ $$(kubectl get pods -l "app=lunch" -o custom-columns=name:metadata.name,status:status.phase | tail -n+2 | grep Running | wc -l) -lt 2 ]; do sleep 5; done
	kubectl delete $(PREVID)
	kubectl scale --replicas=1 deployment lunchplaner

.PHONY: all deploy image publish
