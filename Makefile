ST2_REPO_PATH?= /tmp/st2

VIRTUALENV_DIR ?= virtualenv

COMPONENTS_RUNNERS := $(wildcard /tmp/st2/contrib/runners/*)

.PHONY: .clone_st2_repo
.clone_st2_repo:
	@echo
	@echo "==================== cloning st2 ===================="
	@echo
	git clone -b remove_obsolete_runners_v310 --depth 1 https://github.com/StackStorm/st2.git $(ST2_REPO_PATH)

.PHONY: .install_st2_dependencies
.install_st2_dependencies: virtualenv
	@echo
	@echo "==================== installing st2 dependencies ===================="
	@echo
	$(VIRTUALENV_DIR)/bin/pip install -r $(ST2_REPO_PATH)/requirements.txt
	$(VIRTUALENV_DIR)/bin/pip install -r $(ST2_REPO_PATH)/test-requirements.txt
	@echo ""
	@echo "================== install runners ===================="
	@echo ""
	@for component in $(COMPONENTS_RUNNERS); do \
		echo "==========================================================="; \
		echo "Installing runner:" $$component; \
		echo "==========================================================="; \
        (. $(VIRTUALENV_DIR)/bin/activate; cd $$component; python setup.py develop); \
	done
	@echo ""
	@echo "================== register metrics drivers ======================"
	@echo ""
	# Install st2common to register metrics drivers
	(. $(VIRTUALENV_DIR)/bin/activate; cd $(ST2_REPO_PATH)/st2common; python setup.py develop)

.PHONY: .install_and_register_runner
.install_and_register_runner: virtualenv
	@echo
	@echo "==================== installing runner ===================="
	@echo
	# Install runner
	$(VIRTUALENV_DIR)/bin/python setup.py develop
	# Register runners
	./scripts/register-runners.sh

.PHONY: virtualenv
virtualenv: $(VIRTUALENV_DIR)/bin/activate
$(VIRTUALENV_DIR)/bin/activate:
	@echo
	@echo "==================== virtualenv ===================="
	@echo
	test -d $(VIRTUALENV_DIR) || virtualenv --no-site-packages $(VIRTUALENV_DIR)
