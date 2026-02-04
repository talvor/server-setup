# Top-level Makefile

.PHONY: talos
talos:
	$(MAKE) -C talos $(filter-out $@,$(MAKECMDGOALS))

