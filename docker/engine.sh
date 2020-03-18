#!/bin/bash
nginx
echo "HELLO"
hugo server -D -b http://39.106.79.246 -p 8080 --appendPort=false
