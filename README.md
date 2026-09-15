# pathcolor – Colorized `echo $PATH` output

**pathcolor** is a lightweight plugin that enhances your `path` experience with colored output.

The basic idea was simply to make this variable easier to read by visually separating the different paths.

<img width="1147" height="177" alt="image" src="https://github.com/user-attachments/assets/25dc54be-81fa-4c7a-b50a-eb4f8d96b0c1" />

## Installation

### Oh My Zsh

Clone the repository into the OhMyZsh plugin directory:

```
git clone git@github.com:bouteillerAlan/pathcolor.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/pathcolor
```

Then add `pathcolor` in your plugin list

```
plugins=(... pathcolor)
```

Reload your shell:

```
source ~/.zshrc
```

### Any other way

- Copy or clone the `pathcolor.plugin.zsh` file
- Source it in your `.zshrc` or `.bashrc`

Reload your shell:
```
source ~/.zshrc
```
