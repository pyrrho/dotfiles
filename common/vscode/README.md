Keybindings
-----------

Keybindings should be soft-linked into environments s.t. updates can more easily be tracked.


* Windows
  ```
  ln -s C:\Path\to\...\keybindings.json %UserProfile%\AppData\Roaming\Code\User\keybindings.json
  ```

* Linux
  ```
  ln -s $(pwd)/keybindings.json ????
  ```
  This one probably differs based on distro. TBD, I guess?

* Mac
  ```
  ln -s $(pwd)/keybindings.json "${HOME}/Library/Application Support/Code/User/keybindings.json"
  ```

Settings
--------

TODO

These need a pass