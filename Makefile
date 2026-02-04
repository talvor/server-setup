# Top-level Makefile

.PHONY: coreos
coreos:
	$(MAKE) -C coreos $(filter-out $@,$(MAKECMDGOALS))

.PHONY: talos
talos:
	$(MAKE) -C talos $(filter-out $@,$(MAKECMDGOALS))

