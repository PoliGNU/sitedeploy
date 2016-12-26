# PoliGNU and PoliGEN Webserver deploy

## Development Environment Setup

Firstly it is necessary to install Chef Kitchen tool and its dependencies. For
that, we are going to use the `bundler` tool [so we can manage our dependencies
with the Gemfile].

To make everybody lifes easier, we recommend you to use the `rbenv` tool to
install Ruby, Ruby Gems and all other ruby based tools.

The following steps are based on:
https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04

### Pre-requisite softwares:
First install [VirtualBox](http://virtualbox.org),
[Vagrant](http://vagrantup.com),
[Bats](https://github.com/sstephenson/bats) and curl.

### Update and install dependencies

Let’s install the dependencies required for rbenv and Ruby with `apt-get`:

```shell
$ sudo apt update
$ sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
```

Once we have all of the required system dependencies installed, we can move
onto the installation of rbenv itself.

### Install rbenv

Now we are ready to install rbenv. Let's clone the rbenv repository from git.
You should complete these steps from the user account from which you plan to
run Ruby.

```shell
$ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
```

From here, you should add `~/.rbenv/bin` to your `$PATH` so that you can use
rbenv's command line utility. Also adding `~/.rbenv/bin/rbenv` init to your
`~/.bash_profile` will let you load rbenv automatically.

```shell
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
```

Next, source rbenv by typing:

```shell
$ source ~/.bashrc
```

You can check to see if rbenv was set up properly by using the `type` command,
which will display more information about rbenv:

```shell
$ type rbenv
```

Your terminal window should output the following:

    Output
    rbenv is a function
    rbenv ()
    {
        local command;
        command="$1";
        if [ "$#" -gt 0 ]; then
            shift;
        fi;
        case "$command" in
            rehash | shell)
                eval "$(rbenv "sh-$command" "$@")"
            ;;
            *)
                command rbenv "$command" "$@"
            ;;
        esac
    }

In order to use the `rbenv install` command, which simplifies the installation
process for new versions of Ruby, you should install
[ruby-build](https://github.com/rbenv/ruby-build), which we will install as a
plugin for rbenv through git:

```shell
$ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

At this point, you should have both rbenv and ruby-build installed, and we can
move on to installing Ruby.

### Install Ruby
With the ruby-build rbenv plugin now installed, we can install whatever
versions of Ruby that we may need through a simple command. First, let's list
all the available versions of Ruby:

```shell
$ rbenv install -l
```

The output of that command should be a long list of versions that you can
choose to install.

We'll now install a particular version of Ruby. It's important to keep in mind
that installing Ruby can be a lengthy process, so be prepared for the
installation to take some time to complete.

As an example here, let's install Ruby version `2.3.3`, and once it's done
installing, we can set it as our default version with the *global* sub-command:

```shell
$ rbenv install 2.3.3
$ rbenv global 2.3.3
```

Verify that Ruby was properly installed by checking your version number:

```shell
$ ruby -v
```

If you installed version `2.3.3` of Ruby, your output to the above command
should look something like this:

    Output
    ruby 2.3.3p222 (2016-11-21 revision 56859) [x86_64-linux]

You now have at least one version of Ruby installed and have set your default
Ruby version.

### Working with Gems

Gems are packages that extend the functionality of Ruby. We will want to
install Rails through the `gem` command.

So that the process of installing Rails is less lengthy, we will turn off local
documentation for each gem we install. We will also install the bundler gem to
manage application dependencies:

```shell
$ echo "gem: --no-document" >> ~/.gemrc
$ gem install bundler
```

You can use the `gem env` command (the subcommand env is short for
`environment`) to learn more about the environment and configuration of gems.

### Installing `sitedeploy` dependencies

Being on the root folder of this repository, run the following command to
install our ruby-based dependencies:

```shell
$ bundle install
```

## Testing (with kitchen)

To run the test suit, you should run the following command:

```kitchen test```

`kitchen` will use the `Vagrant` to create a VirtualMachine (VM) and will
execute the tests inside this VM using the
`[Servspec](http://serverspec.org/)`.

After a successful test, the VM is destroyed. If the test has failed, then the
VM is kept, as is, so you can take a look on what went wrong.

To login on the VM, run:

```kitchen login```

To destroy the VM, run:

```kitchen destroy```

To test without destroying the VM, even if the test was successful, run:

```kitchen verify```

Using the `verify` is a good idea to speed up the dev-test cycle, avoiding the
need to wait the VM creating. Off course that depending on the recepie changes,
the recreation of the VM may be necessary.

The states of a kitchen created VM can be:
* `created`: VM created with Vagrant;
* `converged`: Chef executed on the VM;
* `verified`: Tests executed.

To verify the VM status, run:

```kitchen list```
