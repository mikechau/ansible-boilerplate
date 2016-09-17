# ansible-boilerplate

This repo is a boilerplate for getting started for repos containing Ansible
playbooks. `git clone` this project and be on your merry way.

## Prerequisites

### Install ansible

#### pip

- `pip install ansible` (may need to run this as `sudo`)

## Getting started

### Git clone

- `git clone --depth=1 --branch=master https://github.com/mikechau/ansible-boilerplate.git` - clone the latest copy of the repo
- `cd ansible-boilerplate && git remote rm origin` - remove the origin

---

### Directory structure

```
.
├── ansible.cfg
├── galaxy_roles
├── inventories
│   ├── group_vars
│   └── host_vars
├── LICENSE
├── log -> /tmp/ansible.log
├── notes
├── playbooks
├── README.md
├── requirements.yml
├── roles
└── tmp
```

#### ansible.cfg

This is a project specific configuration file to configure Ansible. [View](ansible.cfg)
to see a more detailed explanation of the default settings provided by this
project.

##### Read more

- [Ansible.cfg - http://docs.ansible.com/ansible/intro_configuration.html](http://docs.ansible.com/ansible/intro_configuration.html)

#### galaxy_roles

This is where you should install your third-party roles from [Ansible Galaxy](https://galaxy.ansible.com/).

Recommended to configure [requirements.yml](requirements.yml) with the third party roles you are
using.

##### Read more

- [Ansible Galaxy - http://docs.ansible.com/ansible/galaxy.html](http://docs.ansible.com/ansible/galaxy.html)

#### inventories

This is where you should put the list of hosts for Ansible to connect to. It
also contains directories for [group_vars](http://docs.ansible.com/ansible/intro_inventory.html#group-variables) and [host_vars](http://docs.ansible.com/ansible/intro_inventory.html#host-variables).

Example:

```
.
├── group_vars
├── host_vars
└── production
```

We have a file called `production`, but if you have a lot of environments,
instead of `production`, you might call it `production_app_name` or
`app_name_production`, etc.

In it you might define it like so:

```yml
# inventories/production
[application]
app01.server.com
app02.server.com
app03.server.com

[database]
db01.server.com

[production:children]
application
database
```

`production:children`, indicates to Ansible this is a group of made of all the
things in the groups listed below.

So its equivalent to manually writing:

```
# inventories/production
[production]
app01.server.com
app02.server.com
app03.server.com
db01.server.com
```

##### group_vars

This directory contains yaml files which correspond to a group name, and tells
Ansible to load the variables for the hosts in that group.

Example structure:

```
.
└── group_vars
    ├── all
    │   └── ubuntu.yml
    ├── application
    │   ├── rails.yml
    │   └── secret
    │       └── rails.yml
    └── database
        ├── mysql.yml
        ├── postgresql.yml
        └── secret
            ├── mysql.yml
            └── postgresql.yml
```

- `all` - is a Ansible group, where it will be loaded for all hosts.
- `application`-  is a user defined group of hosts, we defined this in our `production` hosts file in the previous example.
- `database` - is a user defined group of hosts, we defined this in our `production` hosts file in the previous example.

A group variable file looks like this:

```yml
# inventories/group_vars/application/rails.yml
---
rails_version: 5.0.0
```

So the `rails_version` variable will be available for all hosts listed under `application` (app[0-3].server.com).

**NOTE:** You might have noticed the `secret` directory, this is where you can
take advantage of [ansible-vault](http://docs.ansible.com/ansible/playbooks_vault.html). For secret specific variables such as api keys and etc,
I like to put them inside a `secret` folder, and encrypt the folder with `ansible-vault`.

Secrets are prefixed with the key `secret_`.

Example:

```yml
# Encrypted secrets for rails
# inventories/group_vars/application/secret/rails.yml
---
secret_rails_secret_token: 1db372dbc0a8200da1d7f9c51384fe0094c940628c497e7e519eb4977aba244cdad0ab9c4965383d2dc9244296ea6b889fe711d40dc590a4455d17e1a012db58
```

```yml
# Unencrypted secrets for rails
# inventories/group_vars/application/rails.yml
---
rails_version: 5.0.0
rails_secret_token: "{{ secret_rails_secret_token }}"
```

You can see our unencrypted variable file reference the encrypted variable file's variable in `secret`.

##### host_vars

`host_vars` work just like `group_vars`, but instead of naming it after a
group name, you use the `hostname`. The variables only be loaded for that specific host.

Example:

```
.
└── host_vars
    └── app01.server.com
        └── rails.yml
```

##### Read More

- [Inventory - http://docs.ansible.com/ansible/intro_inventory.html](http://docs.ansible.com/ansible/intro_inventory.html)
- [Variables - http://docs.ansible.com/ansible/playbooks_variables.html](http://docs.ansible.com/ansible/playbooks_variables.html)

---

#### log

By default this is just a symlink to `tmp/ansible.log`.

---

#### notes

This is where you can add your notes for things like manual configuration.

---

#### playbooks

This is where [playbooks](http://docs.ansible.com/ansible/playbooks.html)
should be placed.

##### Read More

- [Playbooks - http://docs.ansible.com/ansible/playbooks.html](http://docs.ansible.com/ansible/playbooks.html)

---

#### requirements.yml

Edit this yml file to add your third-party roles from Github or Ansible Galaxy.

Then install your roles with this command:

```bash
ansible-galaxy install -r requirements.yml
```

[Ansible Galaxy - requirements - http://docs.ansible.com/ansible/galaxy.html#advanced-control-over-role-requirements-files](http://docs.ansible.com/ansible/galaxy.html#advanced-control-over-role-requirements-files)

---

#### roles

This is where you can add your custom Ansible [roles](http://docs.ansible.com/ansible/playbooks_roles.html#roles) for usage by your playbooks.

##### Read more

[Roles - http://docs.ansible.com/ansible/playbooks_roles.html#roles](http://docs.ansible.com/ansible/playbooks_roles.html#roles)

---

#### tmp

A tmp directory for convenience. For example, you may prefer to write logs
here.

---

### LICENSE

MIT
