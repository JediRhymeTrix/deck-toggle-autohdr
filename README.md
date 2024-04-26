# Deck Toggle Auto HDR

This guide provides instructions for setting up an easy way to toggle Auto HDR on a per-game level for the Steam Deck OLED using Decky Loader and the Bash Shortcuts plugin. 
The included script will take the appid of the current game from Bash Shortcuts and automatically copy/link the required files into the game directory.

## Prerequisites

1. **Decky Loader** - Install from [Decky Loader](https://decky.xyz/).
2. **Bash Shortcuts Plugin** - Install from [Bash Shortcuts Plugin for Decky](https://github.com/Tormak9970/bash-shortcuts).

## Instructions

### Temporary Fix for Bash Shortcuts Plugin

Due to a current issue in the Bash Shortcuts plugin that prevents flags from being passed correctly to scripts, you need to perform the following steps:

1. Open the file `/home/deck/homebrew/plugins/bash-shortcuts/py_backend/instanceManager.py`.
2. Change line 28 from:
    ```python
    self.shortcutProcess = subprocess.Popen(command, shell=True)
    ```
    to:
    ```python
    self.shortcutProcess = subprocess.Popen(command, shell=False)
    ```
3. Restart the Deck to apply changes.

### Setting Up Auto HDR

1. Download `Auto-HDR_dx11_v2.zip` from this repository and extract it into the `Downloads` directory on your Deck.
2. Boot into game mode and navigate to the Bash Shortcuts plugin.
3. Create a new shortcut:
   - Navigate to plugin config > add shortcut.
   - Name the shortcut as desired.
   - Set the command to:
        ```bash
        /home/deck/Downloads/Auto-HDR_dx11_v2/autohdr_shortcut.sh
        ```
    - Configure the toggles as shown in the screenshot below:
   
     ![Configuration Screenshot](assets/screenshot_1.jpg)

   - Save the shortcut.
4. To enable Auto HDR for a game:
   - Go to the game view page for any installed Steam game or launch a game.
   - Open the Bash Shortcuts plugin in the Quick Access Menu (QAM) and run your newly created shortcut.
   - Once the shortcut has run, it should have copied the required files to the game's directory.
   - Either run the game if you were on the game view page, or exit and re-launch if the game was already running. Auto HDR should now be enabled.

5. To disable Auto HDR, repeat Step 4. The same shortcut will remove Auto HDR from the game.

## Limitations

The limitations are the same as those for the Reshade Auto HDR plugin. For more details, refer to this [Twitter post](https://twitter.com/JavaidUsama/status/1763443358318428400).

## Credits

- **Reshade and Auto-HDR Plugin Developers** - For building the functionality.
- **@JavaidUsama** - For sharing the the AutoHDR files on [Twitter](https://twitter.com/JavaidUsama/status/1763443358318428400).
- **Tormak** - For developing the Bash Shortcuts plugin.
- **Decky Loader Team** - For making plugin integration possible on the Steam Deck.

## Note

This guide and the scripts are currently in a very rough proof of concept stage. Plans for refinement are in place, especially once the issue with the Bash Shortcuts plugin is resolved.
    