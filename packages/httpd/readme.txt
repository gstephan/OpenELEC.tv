Use a command like this to build the httpd addon (I have built it for RaspberryPi Arm processor):

PROJECT=RPi ARCH=arm PHP_VERSION=5.3.3 scripts/create_addon httpd

PHP_VERSION is the version of php that you want to build with apache.
Those php versions must exist as mk files in the folder of php addon.
There are currently 2 versions supported: 5.3.3 and 5.5.8.

