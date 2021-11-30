#!/usr/bin/env bash

set -eoux pipefail

yum update
yum install -y nginx
