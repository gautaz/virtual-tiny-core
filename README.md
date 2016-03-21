# Virtual Tiny Core

![VTC logo](img/vtc.png)

VTC provides a way to create [Tiny Core](http://tinycorelinux.net/) images for virtual environments.

Once this repository is cloned locally, the following command is available:

```text
$ <path to repo>/vtc -h
Usage: vtc.sh [options...]

Generates an archive of a virtual Tiny Core machine

Options:
  -a <archive>   archive file to store the result in
                 --> C0r3.ova
  -b <builder>   builder to use
                 --> virtualbox
  -h             print this help and exits
  -i <iso>       either an ISO file URL to download or a path to an ISO file
                 --> http://tinycorelinux.net/7.x/x86_64/release/CorePure64-7.0.iso
  -k <key>       public ssh key to authorize on the tiny core machine
                 --> ~/.ssh/id_rsa.pub
  -n <name>      name of the machine
                 --> C0r3
  -p <port>      port to set for SSH daemon to listen on
                 --> 7103
  -w <seconds>   latency in seconds between console operations operated by the builder
                 --> 5
```

## Motivation

The project was initially holding a procedure used to create an OVA archive of a Tiny Core virtualbox machine.
This procedure is still available [here](doc/manual-procedure.md).

As [Packer](https://www.packer.io/) is [for now unable](https://github.com/mitchellh/packer/issues/810) to directly send [scancodes](https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html) to virtual machines, a quick bash script seemed to be the fastest way to automate completely this manual procedure.

## Why builders ?

This is the Packer way of naming the bits of code in charge of creating machines.
VTC only provides a [VirtualBox](https://www.virtualbox.org/) builder for now.

## TODO

Find a way to replace those messy keyboard scancodes by a connection to a serial console at first boot.

## Why the ugly logo ?

VTC stands in french for *Vélo Tout Chemin* which means hybrid bike.
A bicycle is lightweight but can still take you far away.

## License

> The MIT License (MIT)
>
> Copyright (c) 2016 gautaz
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
