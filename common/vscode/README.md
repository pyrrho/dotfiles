Keybindings
-----------

Keybindings should be soft-linked into environments s.t. updates can more easily be tracked.


* Windows
  ```
  ln -s C:\Path\to\...\keybindings.json %UserProfile%\AppData\Roaming\Code\User\keybindings.json
  ```

* Linux
  This one probably differs base on distro. The below is for Pop!_OS 22.04, manual installation
  ```
  ln -s "$(pwd)/keybindings.json" "${HOME}/.config/Code/User/keybindings.json"
  ```

* Mac
  ```
  ln -s "$(pwd)/keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"
  ```

Settings
--------

TODO

These need a pass
