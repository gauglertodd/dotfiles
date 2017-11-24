from subprocess import call

import os

names = os.listdir(".")
names.remove('.git')
names.remove('copyscript.py')
for file in names:
    try:
        call(['cp', '-f', '-r', '/home/todd/' + file, "."])
    except:
        print "Fail on file " + file
