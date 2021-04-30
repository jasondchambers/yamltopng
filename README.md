# yamltopng
Uses [yamltogliffy](https://github.com/yzxbmlf/yamltogliffy) to produce a .gliffy file and then automates [Gliffy](https://www.gliffy.com) to produce 
a PNG image.

This tool doesn't really care about the what is in the .gliffy file. It could be
cute kittens. Therefore, this tool could easily be adapted to automate the task
of using Gliffy just to produce a PNG file.

Tested on macOS only, but could easily be adapted to work on Linux I guess.

## Usage

~~~~bash
./ymltopng.sh ~/org.yml ~/Downloads/org.png
~~~~

## Installation

There are quite a few steps involved before you can use the ymltopng. In
an ideal world, the complexity of the installation of dependencies would be 
masked behind a Docker image - however, there were significant challenges in 
driving Gliffy (required to produce the final PNG file) in headless mode 
preventing it at least for now from running inside a Docker container.

Therefore unfortunately, there is manual effort on your part in setting up the
various dependencies and getting things in place to be able to use the tool.

### 1. Gliffy account

You will need to have a Gliffy account subscription. This is required to enable
the export to PNG feature. If you don't have one, go ahead and sign up.

### 2. Storing your Gliffy credentials

Once you have your Gliffy account setup, you will need to store your
credentials in your home directory in a file called ~/drivegliffy.yml
as follows:

~~~~
gliffy_username: your username goes here
gliffy_password: your Gliffy password goes here
~~~~

### 3. Installing Chrome Driver - WebDriver for Chrome

Go ahead and install [Chrome Driver](http://chromedriver.chromium.org/downloads). As time passes, Chrome will be automatically 
updated creating compatibility issues with whatever version of Chrome Driver you 
have installed.

Therefore, you will find yourself having to manually updated Chrome Driver from time 
to time if yamltopng stops working.

### 4. Installing Ruby and associated Gems

This has been tested with the following version ruby 2.1.10p492. Other versions
may work fine - it's just that they haven't been tested. Bring up a
terminal and see if you have Ruby installed already and check the version.

~~~~bash
$ ruby --version
ruby 2.1.10p492 (2016-04-01 revision 54464) [x86_64-darwin17.0]
~~~~

If you get "command not found: ruby" then you will need to go ahead and
install [Ruby](https://www.ruby-lang.org/en/documentation/installation/).

Once you have Ruby installed, you will need to install some Gems:

~~~~bash
$ bundle install
~~~~

### 5. Installing the yamltpopng Docker image

Simply clone and build [yamltogliffy](https://github.com/yzxbmlf/yamltogliffy) (follow the instructions in the README.md)
