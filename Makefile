inventory = ansible/inventories/inventory
install_user = root

VENV_NAME?=venv
VENV_ACTIVATE=. $(VENV_NAME)/bin/activate
PYTHON=${VENV_NAME}/bin/python3

venv: $(VENV_NAME)/bin/activate
$(VENV_NAME)/bin/activate: env-requirements.txt
	test -d $(VENV_NAME) || virtualenv -p python3 $(VENV_NAME)
	${PYTHON} -m pip install -U pip
	${PYTHON} -m pip install -r env-requirements.txt
	touch $(VENV_NAME)/bin/activate

################################ GALAXY COMMANDS ################################

galaxy-install: venv
	$(VENV_ACTIVATE) && ansible-galaxy install -r roles/requirements.yml --roles-path=galaxy_roles

galaxy-force-update: venv
	$(VENV_ACTIVATE) && ansible-galaxy install -r roles/requirements.yml --roles-path=galaxy_roles --force-with-deps

############################## DEPLOYMENT COMMANDS ##############################

# deploy-users-new: galaxy-install
# 	$(VENV_ACTIVATE) && ansible-playbook -i $(inventory) playbooks/users-new.yml --user=$(install_user) -k -K

# deploy-users: galaxy-install
# 	$(VENV_ACTIVATE) && ansible-playbook -i $(inventory) playbooks/users.yml

# deploy-common: galaxy-install
# 	$(VENV_ACTIVATE) && ansible-playbook -i $(inventory) playbooks/common.yml

################################# TEST COMMANDS #################################

ping: galaxy-install
	$(VENV_ACTIVATE) && ansible-playbook -i $(inventory) playbooks/ping.yml

tests: galaxy-install
	$(VENV_ACTIVATE) && ansible-lint playbooks/*.yml
