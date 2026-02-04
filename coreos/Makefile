.PHONY: init	
init:
	@tofu -chdir=./ init

.PHONY: plan
plan:
	@tofu -chdir=./ plan

.PHONY: apply
apply: convert-butane
	@tofu -chdir=./ apply

.PHONY: destroy
destroy:
	@tofu -chdir=./ destroy

