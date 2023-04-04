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

To manage the dependencies of your projects, you can use the monoz bundle command. This command will create a new Gemfile.lock file in each project directory based on the dependencies specified in their respective Gemfiles.

To bundle all the projects in the Monoz repository, simply run:

```console
$ monoz bundle
```

This will create a `Gemfile.lock` file for each project in the repository.

If you want to update the dependencies of your projects, you can use the `monoz bundle update` command. This command will update the `Gemfile.lock` file of each project based on the latest available versions of their dependencies.

To update the dependencies of all projects in the Monoz repository, simply run:

```console
$ monoz bundle update
```

Note that when you add a new dependency to a project, you'll need to run `monoz bundle` to update its `Gemfile.lock` file before you can use the new dependency. Similarly, if you update the dependencies of a project's `Gemfile`, you'll need to run `monoz bundle` to update its `Gemfile.lock` file with the new versions.

### Inspect projects

You can inspect the projects in your Monoz repository using the monoz inspect command. This command will display a table that shows the projects in the repository, their type (app or gem), the gem name (if it's a gem), the test framework(s) used, and the projects that depend on them.

Here's an example output of the monoz inspect command:

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
