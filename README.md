# NSP (New Swing Project)

[![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

NSP (New Swing Project) is a command-line tool that automates the initialization of Java Swing projects with various templates and configurations. It's designed to help developers quickly set up new projects with customizable options.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Options](#options)

## Features

- **Automated Project Setup**: Initialize new Java Swing projects with just a single command.
- **Customizable Templates**: Choose from different project templates and configurations.
- **Icon Generation**: Automatically add FontAwesome icons to your project.

## Installation

```bash
git clone https://github.com/yourusername/nsp.git
cd nsp
sudo ./install.sh
```

This will install the `nsp` command and its associated man page.

## Usage

### Basic Command

To initialize a new project:

```bash
nsp <project_name> [flags...]
```

Replace `<project_name>` with your desired project name.

### Options

- `-1`, `--oneFrame`: Create a project with a single-frame template.
- `-s`, `--separate`: Create a project with separate frames.
- `-i`, `--icon`: Include FontAwesome icons in your project.
- `-u`, `--util`: Include a Java file with various utility methods.
- `-v`, `--verbose`: Enable verbose mode for detailed output.
