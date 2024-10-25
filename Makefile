export PATH := $(PWD)/bin:$(PATH)
export GOBIN := $(PWD)/bin
APP=etl
DOCKERFILE=Dockerfile

LAST_RUN_DIR=.last_run

define check_and_run
    @if [ ! -f $(1)/$(2) ] || [ `find $(1)/$(2) -mmin +60` ]; then \
        echo "Running $(2)..."; \
        $(3); \
        mkdir -p $(1); \
        touch $(1)/$(2); \
    else \
        echo "$(2) has been run recently."; \
    fi
endef

docker-build:
	$(call check_and_run,$(LAST_RUN_DIR),docker-build,docker build --file build/$(DOCKERFILE) --tag app:latest . --build-arg APP=app && minikube -p minikube image load app)

docker-build-gcp:
	$(call check_and_run,$(LAST_RUN_DIR),docker-build-gcp,docker build --file build/Dockerfile.gcloud --tag pubsub:latest . && minikube -p minikube image load pubsub)

terraform-plan:
	$(call check_and_run,$(LAST_RUN_DIR),terraform-plan,cd deploy/terraform && terraform init && terraform plan)

terraform-apply:
	$(call check_and_run,$(LAST_RUN_DIR),terraform-apply,cd deploy/terraform && terraform apply -auto-approve)

terraform-destroy:
	$(call check_and_run,$(LAST_RUN_DIR),terraform-destroy,cd deploy/terraform && terraform destroy -auto-approve && rm ./deploy/terraform/terraform.tfstate && rm ./deploy/terraform/terraform.tfstate.backup && rm ./deploy/terraform/.terraform.lock.hcl)

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