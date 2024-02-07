# FreeBSD 14 - Oh-My-Bash on FreeBSD



`bash` is so powerful against the old-school `sh`, that we are thirsty to take a look how beautiful the shell is with Oh-My-Bash.



## (A) Introduction to Oh My Bash

source: https://github.com/ohmybash/oh-my-bash?tab=readme-ov-file

Oh My Bash is an open source, community-driven framework for managing your [bash](https://www.gnu.org/software/bash/) configuration. Sounds boring. Let's try again.

Oh My Bash will not make you a 10x developer...but you might feel like one.

Once installed, your terminal shell will become the talk of the town or your money back! With each keystroke in your command prompt, you'll take advantage of the hundreds of powerful plugins and beautiful themes. Strangers will come up to you in cafés and ask you, "that is amazing! are you some sort of genius?"

Finally, you'll begin to get the sort of attention that you have always felt you deserved. ...or maybe you'll use the time that you're saving to start flossing more often.



## (B) Prerequisites

**Disclaimer:** *Oh My Bash works best on macOS and Linux.*

- Unix-like operating system (macOS or Linux)
- `curl` or `wget` should be installed
- `git` should be installed



## (C) Basic Installation



Oh My Bash is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

#### via curl

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

#### via wget

```
bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
```



This replaces `~/.bashrc` with the version provided by Oh My Bash. The original `.bashrc` is backed up with the name `~/.bashrc.omb-TIMESTAMP`. If `~/.bash_profile` does not exist, this also creates a new file `~/.bash_profile` with the default contents.

⚠️ If `~/.bash_profile` already existed before Oh My Bash is installed, please make sure that`~/.bash_profile` contains the line `source ~/.bashrc` or `. ~/.bashrc`. If not, please add the following three lines in `~/.bash_profile`:

```
if [[ -f ~/.bashrc ]]; then
  source ~/.bashrc
fi
```



## (D) Using Oh My Bash

### 1- Plugins

Oh My Bash comes with a shit load of plugins to take advantage of. You can take a look in the [plugins](https://github.com/ohmybash/oh-my-bash/tree/master/plugins) directory and/or the [wiki](https://github.com/ohmybash/oh-my-bash/wiki/Plugins) to see what's currently available.

#### Enabling Plugins

Once you spot a plugin (or several) that you'd like to use with Oh My Bash, you'll need to enable them in the `.bashrc` file. You'll find the bashrc file in your `$HOME` directory. Open it with your favorite text editor and you'll see a spot to list all the plugins you want to load.

For example, this line might begin to look like this:

```
plugins=(git bundler osx rake ruby)
```

### 2- Themes

We'll admit it. Early in the Oh My Bash world, we may have gotten a bit too theme happy. We have over one hundred themes now bundled. Most of them have [screenshots](https://github.com/ohmybash/oh-my-bash/wiki/Themes) on our wiki or alternatively [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/wiki/themes) wiki.

#### Selecting a Theme

*Powerline's theme is the default one. It's not the fanciest one. It's not the simplest one. It's just the right one (for me).*

Once you find a theme that you want to use, you will need to edit the `~/.bashrc` file. You'll see an environment variable (all caps) in there that looks like:

```
OSH_THEME="powerline"
```

To use a different theme, simply change the value to match the name of your desired theme. For example:

```
OSH_THEME="agnoster" # (this is one of the fancy ones)
# you might need to install a special Powerline font on your console's host for this to work
# see https://github.com/ohmybash/oh-my-bash/wiki/Themes#agnoster
```



In case you did not find a suitable theme for your needs, please have a look at the wiki for [more of them](https://github.com/ohmybash/oh-my-bash/wiki/External-themes).

If there are themes you don't like, you can add them to an ignored list:

```
OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")
```

The selected theme name can be checked by the following command:

```
$ echo "$OMB_THEME_RANDOM_SELECTED"
```



## (E) Fonts



### Regular X11-fonts

Enhance the fonts on FreeBSD by installing the `xorg-fonts`:

```
sudo pkg install x11-fonts/xorg-fonts
```



### Nerd Fonts - Fonts for Developers

Installation of Nerd Fonts does not change the function of anything, but simply adds fonts that are more pleasing to the eye than whatever the standard terminal font is currently.

Nerd Fonts are a collection of modified fonts aimed at developers. In particular, "iconic fonts" such as Font Awesome, FinaMono, etc. are used to add extra glyphs.

Nerd Fonts takes the most popular programming fonts and modifies them by adding a group of glyphs (icons). A font patcher is also available if the font you'd like to use has not already been edited. A convenient preview is available on the site, allowing you to see how the font should look in the editor. For more information, check the project's main [site](https://www.nerdfonts.com/).

Fonts are available for download at:

```
https://www.nerdfonts.com/font-downloads
```

I preferred specific font family - **FiraMono**, then we can download:

```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip
```

Next, unzip the contents of the folder and copy the fonts to `~/.local/share/fonts/` with:

```
mkdir ~/.local/share/fonts
unzip SourceCodePro.zip -d ~/.local/share/fonts/
fc-cache ~/.local/share/fonts
```

The last command above take a while to populate the cache with the newly installed fonts.

Then, we can go to the `preferences` of the terminal to select the new fonts.



## The End
