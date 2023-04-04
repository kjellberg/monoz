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

You can also run other bundler commands on all projects in the repository using the `monoz bundle` command followed by the desired arguments. For example, to run Rubocop tests in all projects, you can use the following command:

```console
$ monoz bundle exec rubocop

kiqr_core: bundle exec rubocop ✓
content_api: bundle exec rubocop ✗
Configuration file not found: /some/path/.rubocop.yml

core_api: bundle exec rubocop ✓
kiqr_cloud: bundle exec rubocop ✓

Error: The command bundle exec rubocop failed to run in one or more project directories
```

This will execute the `bundle exec rubocop` command in each project directory, ensuring that all the necessary dependencies are installed and loaded for each project. Similarly, you can run other bundler commands such as `bundle install`, `bundle update`, and so on, by appending the desired arguments to the `monoz bundle` command.

### Running commands in projects

You can run any command in all projects of your Monoz repository using the `monoz run` command. Simply provide the command you want to run as an argument, and Monoz will execute it in each project directory.

For example, to create an empty file named test.txt in the tmp/ directory of all projects, you can use the following command:

```console
$ monoz run touch tmp/test.txt

kiqr_core: touch tmp/test.txt ✓
content_api: touch tmp/test.txt ✓
core_api: touch tmp/test.txt ✓
kiqr_cloud: touch tmp/test.txt ✓

The command ran successfully in all projects without any errors.
```

This will execute the `touch tmp/test.txt` command in each project directory, creating the test.txt file in the tmp/ directory. If a command fails to run in a project directory, Monoz will display an error message with the output of the command.

Note that if you need to run a command in a specific project, you can simply navigate to the project directory and run the command as you would in a regular Ruby project. The monoz run command is primarily useful for running commands across one ore many projects in a Monoz repository at once.

### Run in foreground / interactive mode

You can run commands in interactive mode using the flag `--tty`, or `-t`:

```console
$ monoz run bin/dev --filter=example_com --tty

example_com: bin/dev
23:41:04 web.1  | started with pid 96841
23:41:04 css.1  | started with pid 96842
23:41:05 web.1  | => Booting Puma
23:41:05 web.1  | => Rails 7.0.4.3 application starting in development 
23:41:05 web.1  | => Run `bin/rails server --help` for more startup options
23:41:06 web.1  | Puma starting in single mode...
23:41:06 web.1  | * Puma version: 5.6.5 (ruby 3.2.0-p0) ("Birdie's Version")
23:41:06 web.1  | *  Min threads: 5
23:41:06 web.1  | *  Max threads: 5
23:41:06 web.1  | *  Environment: development
23:41:06 web.1  | *          PID: 96841
23:41:06 web.1  | * Listening on http://127.0.0.1:3000
23:41:06 web.1  | * Listening on http://[::1]:3000
23:41:06 web.1  | Use Ctrl-C to stop
23:41:06 css.1  | 
23:41:06 css.1  | Rebuilding...
23:41:06 css.1  | 
23:41:06 css.1  | Done in 354ms.
```

### Filter projects

The `--filter` option in Monoz allows you to select certain projects based on specific criteria. This is useful if you only want to run a command on a specific subset of projects, rather than all of them. To use the `--filter` option, you simply specify a filter expression after the option. The filter expression is a comma-separated list of keywords that match the project names or tags in your Monoz configuration.

For example, suppose you have a Monoz configuration with several projects, some of which are tagged as **apps** and some of which are tagged as **gems**. You can use the `--filter` option to select only the **apps** projects by running the following command:

```console
$ monoz bundle --filter=apps
```

Similarly, if you only want to list only gem projects, you can use the following command:

```console
$ monoz projects --filter=gems
```

You can also use multiple keywords in the filter expression to select projects that match any of the keywords. For example, to run the `mrsk deploy` command on all **apps** and **apis** projects, you can use the following command:

```console
$ monoz run mrsk deploy --filter="apps,apis"
```

Finally, you can also specify individual project names in the filter expression. For example, to run the `rubocop` command on only the **gem1** and **gem2** projects, you can use the following command:

```console
$ monoz run rubocop --filter="gem1,gem2"
```

### List projects

You can inspect the projects in your Monoz repository using the `monoz projects` command. This command will display a table that shows the projects in the repository, their type (app or gem), the gem name (if it's a gem), the test framework(s) used, and the projects that depend on them.

Here's an example output of the `monoz projects` command:

```console
$ monoz projects

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
