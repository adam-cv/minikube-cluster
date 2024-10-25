export PATH := $(PWD)/bin:$(PATH)
export GOBIN := $(PWD)/bin
APP=etl
DOCKERFILE=Dockerfile

docker-build:
	docker build --file build/$(DOCKERFILE) --tag app:latest . --build-arg APP=app && minikube -p minikube image load app

docker-build-gcp:
	docker-build-gcp,docker build --file build/Dockerfile.gcloud --tag pubsub:latest . && minikube -p minikube image load pubsub

terraform-plan:
	cd deploy/terraform && terraform init && terraform plan

terraform-apply:
	cd deploy/terraform && terraform apply -auto-approve

terraform-destroy:
	cd deploy/terraform && terraform destroy -auto-approve && rm ./deploy/terraform/terraform.tfstate && rm ./deploy/terraform/terraform.tfstate.backup && rm ./deploy/terraform/.terraform.lock.hcl

run:
	minikube start --cpus 4 --memory 8192 --kubernetes-version v1.30.5 && \
	minikube delete

clean:
	minikube delete && \
	rm -rf ./deploy/terraform/terraform.tfstate.backup && \
	rm -rf ./deploy/terraform/terraform.tfstate && \
	rm -rf ./deploy/terraform/.terraform.lock.hcl && \
	rm -rf ./deploy/terraform/.terraform && \
	rm -rf ./deploy/terraform/.last_run && \
	rm -rf $(LAST_RUN_DIR)

all: run terraform-plan terraform-apply

