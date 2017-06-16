from subprocess import call
import os

names = os.listdir(".")
names.remove('.git')
for file in names:
    call(['cp', '-r', '/home/todd/' + file, "."])


