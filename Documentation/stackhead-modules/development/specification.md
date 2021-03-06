---
description: The specification describes how StackHead modules have to be structured.
---

# Specification

A StackHead module is an Ansible role that contains all steps and templates to:

1. Install and setup the software during server setup
2. Create configurations for this software during project deployment via Terraform

While the [regular Ansible role directory layout](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#directory-layout) apply, the role has also to adhere to this specification.

## Module types

There are the following module types:

* **webserver**: Configuration for reverse proxy webserver
* **container**: Configuration for launching containers
* **plugin**: Any additional software to install on your server (not bound to projects)

## Role name

A role name has to adhere to this schema: `stackhead_[type]_[name]`.

## Required files

Each StackHead module is to required to have a [module configuration file](module-configuration-file.md) in its root directory.

### Structure requirements

StackHead looks for files in the `tasks/steps` directory for the currently performed step.
Make sure the following files exist and the expected behaviour is implemented accordingly:

| file path | Expected behaviour | Required for which modules? |
| :--- | :--- | :--- |
| `tasks/steps/setup.yml` | The software is installed. | `webserver`, `container`, `plugins` |
| `tasks/steps/deploy.yml` | The software is configured for the given project. | `webserver`, `container` |
| `tasks/steps/destroy.yml` | The project configuration for the software is removed. Usually empty as resources created via Terraform are removed automatically. | `plugins` |

{% hint style="warning" %}
Note that `role_path` will most likely not refer to the path to your role, but to a StackHead role.
StackHead provides the path to your role as `module_role_path`, so you should use that preferably:
`{{ module_role_path | default(role_path) }}`
{% endhint %}

{% hint style="warning" %}
Please make sure you use `include_tasks` instead of `import_tasks` in your steps and files included into your steps!
{% endhint %}

### Migrations

Files inside the `tasks/migrations` directory are considered migrations.
They are executed before the first execution of a module step.

The migrations are executed once on the system and in alphabetical order.
Therefore we recommend prefixing them with a number (e.g.`0001-rename-terraform-provider.yml`) to ensure
they run in correct order.

The names of executed migration files are saved in `/stackhead/migrations/[module].migrations.lock`.
{% hint style="danger" %}
Never rename a migration that was already released or executed on a system!
{% endhint %}
