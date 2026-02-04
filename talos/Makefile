TOOLS := opentofu curl git helm jq kubectl talosctl tee wget yq

.PHONY: install-tools
install-tools:
	@for tool in $(TOOLS); do \
	  if ! command -v $$tool &>/dev/null; then \
	    echo "Installing $$tool..."; \
	    yay -S --noconfirm $$tool; \
	  else \
	    echo "$$tool is already installed"; \
	  fi; \
	done

.PHONY: init	
init:
	@tofu -chdir=./ init

.PHONY: plan
plan:
	@tofu -chdir=./ plan

.PHONY: apply
apply:
	@tofu -chdir=./ apply

.PHONY: destroy
destroy:
	@tofu -chdir=./ destroy

.PHONY: read-kubeconfig
read-kubeconfig:
	@tofu -chdir=./ output -raw kubeconfig > ~/.kube/config

.PHONY: read-talosconfig
read-talosconfig:
	@tofu -chdir=./ output -raw talosconfig > ./talos/talosconfig
