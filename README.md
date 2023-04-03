# Monoz

Monoz is a command-line tool that helps you manage your **ruby** monorepo. It provides an easy way to manage multiple related **ruby** projects and their dependencies in a single repository. Monoz helps you keep track of your projects and their interdependencies, making it easier to maintain and scale your codebase.

## Installation

You can install Monoz by running the following command:

```console
gem install monoz
```

## Getting started

To initialize a Monoz repository in the current directory, simply run:

```console
monoz init
```

To initialize a Monoz repository in a specific directory, provide the path as an argument:

```console
monoz init path/to/repository
```

Once you've initialized your Monoz repository, you can start adding projects to it. Each project should contain at least a Gemfile and be placed in its own directory within the `apps/` or `gems/` folders in the Monoz repository.

## Contributing
We welcome contributions from everyone! If you're interested in contributing to Monoz, please check out our contributing guidelines for more information.

## License

Monoz is released under the MIT License.
