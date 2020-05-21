# Elgato Stream Deck PowerShell Plugin

This project implements integration with Elgato's Stream Deck software on Microsoft Windows 10, using native PowerShell code.
This plugin enables a single action in Stream Deck software, under the `Custom` section called `Show GPU Wattage`. 

![Screenshot](/assets/2020-05-20-screenshot-stream-deck.png)

## Dependencies

* NVIDIA GPU (tested with NVIDIA GeForce RTX 2080)
* `nvidia-smi.exe` must be on your `PATH` environment variable
* Windows 10
* PowerShell ([pwsh]()) must be installed (NOT the version that's included with Windows)

## Installation

To install this plugin, place the contents under `$env:APPDATA\Elgato\StreamDeck\Plugins\net.trevorsullivan.pwsh.sdPlugin`.

**IMPORTANT**: The plugin folder **must** have an `.sdPlugin` suffix in order for Stream Deck to pick it up.

## Caveats

* Only a single instance of this plug-in can be used at any given time, due to how it works internally. 
  * It only supports updating a single "context", an Elgato Stream Deck API concept.
* There is code to help ensure that the WebSocket connection is terminated, and the `pwsh.exe` process terminates once Elgato Stream Deck is closed.
  * However, there is the possibility that you could end up with orphaned `pwsh.exe` processes. 
  * If you experience this behavior, please file an issue, and I probably won't get to it.

## License

This software is licensed under the MIT license. See `LICENSE`.

## Author 

https://github.com/pcgeek86
https://twitter.com/pcgeek86
https://trevorsullivan.net
