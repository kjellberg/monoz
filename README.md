# Monoz

Monoz is a command-line tool that helps you manage your **ruby** monorepo. It provides an easy way to manage multiple related **ruby** projects and their dependencies in a single repository. Monoz helps you keep track of your projects and their interdependencies, making it easier to maintain and scale your codebase. 

## Installation

You can install Monoz by running the following command:

```console
$ gem install monoz
```

## Getting started

To initialize a Monoz repository in the current directory, simply run:

```console
$ monoz init
```
*For a specific directory, provide the path as an argument.*


This will create a new Monoz repo with the following structure:

```
├── .git
├── apps
├── gems
└── monoz.yml
```

### Adding projects

Once you've initialized your Monoz repository, you can start adding projects to it.

To add a new project, simply create a new directory in either the `apps/` or `gems/` directory, depending on whether it's an application or a library.

For example, a Monoz repository with both a frontend and a backend application that shares the same libraries could look like this:

```
├── .git
├── apps
│   ├── example-com
│   └── example-com-admin
├── gems
│   ├── myengine
│   ├── sharedmodels
│   └── privatelibrary
└── monoz.yml
```

### Bundle projects

To manage the dependencies of your projects, you can use the `monoz bundle` command. This command will run `bundle` and create a new Gemfile.lock file in each project directory based on the dependencies specified in their respective `Gemfile`.

To bundle all the projects in the Monoz repository, simply run:

```console
$ monoz bundle

kiqr_core: bundle ✓
content_api: bundle ✓
core_api: bundle ✓
kiqr_cloud: bundle ✓

The command ran successfully in all projects without any errors.
```

If you instead want to update the dependencies of your projects, you can use the `monoz bundle update` command. This command will update the `Gemfile.lock` file of each project based on the latest available versions of their dependencies.

To update the dependencies of all projects in the Monoz repository, simply run:

```console
$ monoz bundle update
```

Note that when you add a new dependency to a project, you'll need to run `monoz bundle` to update its `Gemfile.lock` file before you can use the new dependency. Similarly, if you update the dependencies of a project's `Gemfile`, you'll need to run `monoz bundle` to update its `Gemfile.lock` file with the new versions.

#### Run other bundler commands

You can also run other bundler commands on all projects in the repository using the `monoz bundle` command followed by the desired arguments. For example, to run the RSpec tests for all projects, you can use the following command:

```console
$ monoz bundle exec rubocop

kiqr_core: bundle exec rubocop ✓
content_api: bundle exec rubocop ✗
Configuration file not found: /some/path/.rubocop.yml

core_api: bundle exec rubocop ✓
kiqr_cloud: bundle exec rubocop ✓

Error: The command bundle exec rubocop failed to run in one or more project directories
```

This will execute the `bundle exec rspec` command in each project directory, ensuring that all the necessary dependencies are installed and loaded for each project. Similarly, you can run other bundler commands such as `bundle install`, `bundle update`, and so on, by appending the desired arguments to the `monoz bundle` command.

### Inspect projects

You can inspect the projects in your Monoz repository using the `monoz inspect` command. This command will display a table that shows the projects in the repository, their type (app or gem), the gem name (if it's a gem), the test framework(s) used, and the projects that depend on them.

Here's an example output of the `monoz inspect` command:

```console
$ monoz inspect

o---------------o--------o-------------o---------------------o-------------------------------------o
|  Project      |  Type  |  Gem Name   |  Test Framework(s)  |  Dependants                         |
o---------------o--------o-------------o---------------------o-------------------------------------o
|  content_api  |  app   |             |  rspec              |                                     |
|  core_api     |  app   |             |  rspec              |                                     |
|  kiqr_cloud   |  app   |             |  rspec              |                                     |
|  kiqr_core    |  gem   |  kiqr_core  |  rspec              |  content_api, core_api, kiqr_cloud  |
o---------------o--------o-------------o---------------------o-------------------------------------o
```

## Contributing
We welcome contributions from everyone! If you're interested in contributing to Monoz, please check out our contributing guidelines for more information.

## License

Monoz is released under the MIT License.
