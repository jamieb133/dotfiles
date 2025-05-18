import argparse, os, sys

user = input('Enter git username (q to quit): ')
if user == 'q':
    sys.exit(0)

email = input('Enter git email (q to quit): ')
if email == 'q':
    sys.exit(0)

os.system(f'git config --global user.name "{user}"')
os.system(f'git config --global user.email {email}')

