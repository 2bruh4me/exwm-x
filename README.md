- [Exwm-X](#orgb6d2dca)
  - [What is Exwm-X](#orgb9ae9ea)
  - [Feature](#org5624eae)
  - [Pictures](#orgdc462de)
  - [Install](#org446c9c4)
  - [Configure](#org43401f2)
    - [Edit "~/.initrc" file or "~/.xsession" file](#org0368d52)
    - [Make "~/.initrc" or "~/.xsession" excutable](#org75ef237)
    - [Edit "~/.exwm"](#org9a118b7)


<a id="orgb6d2dca"></a>

# Exwm-X


<a id="orgb9ae9ea"></a>

## What is Exwm-X

Exwm-X is an extension of exwm (emacs x window manager), which can make exwm easier for Mouse-Control-People to use.


<a id="org5624eae"></a>

## Feature

1.  Window operate buttons in mode-line.
2.  Move or resize a floating-window without press WIN key.
3.  Jump-or-exec, which will switch to an exist app instead of launch it again.


<a id="orgdc462de"></a>

## Pictures

1.  Tilling windows

    ![img](./snapshots/tilling-window.png)

2.  Floating windows

    ![img](./snapshots/floating-window.png)


<a id="org446c9c4"></a>

## Install

1.  Config melpa repository, please see：<http://melpa.org/#/getting-started>
2.  M-x package-install RET exwm-x RET


<a id="org43401f2"></a>

## Configure


<a id="org0368d52"></a>

### Edit "~/.initrc" file or "~/.xsession" file

You should edit "~/.initrc" file or "~/.xsession" file like below example:

    # Emacs X input method (exim) setting
    # export XMODIFIERS=@im=exim
    # export GTK_IM_MODULE=xim
    # export QT_IM_MODULE=xim
    # export CLUTTER_IM_MODULE=xim

    xhost +SI:localuser:$USER

    # Fallback cursor
    # xsetroot -cursor_name left_ptr

    # Keyboard repeat rate
    # xset r rate 200 60

    exec dbus-launch --exit-with-session emacs --eval '(cond ((file-exists-p "~/.exwm") (load-file "~/.exwm")) ((not (featurep (quote exwm))) (require (quote exwm)) (require (quote exwm-config)) (exwm-config-default) (message "exwm configuration not found. Falling back to default configuration...")))'


<a id="org75ef237"></a>

### Make "~/.initrc" or "~/.xsession" excutable

    chmod a+x ~/.xsession

or

    chmod a+x ~/.initrc


<a id="org9a118b7"></a>

### Edit "~/.exwm"

Add the below lines to your emacs configure file:

    (add-to-list 'load-path "/path/to/exwm-x")
    (require 'exwm)
    (require 'exwm-x)
    (require 'exwmx-xfce)
    (require 'exwmx-example) ;; Adjust this line.

Note: Package "exwmx-example" is Exwm-X buildin example, user can use it to test Exwm-X's features. If it doesn't suit for your need, just copy and paste its useful pieces to your own exwm config :-)