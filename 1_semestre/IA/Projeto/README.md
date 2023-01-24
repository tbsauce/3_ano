# ia-rush
Projecto de Inteligência Artificial 2022 - Rush Hour

## How to install

Make sure you are running Python 3.7 or higher

`$ pip install -r requirements.txt`

*Tip: you might want to create a virtualenv first*

## How to play

open 3 terminals:

`$ python3 server.py`

`$ python3 viewer.py`

`$ python3 client.py`

to play using the sample client make sure the client pygame window has focus

### Keys

Directions: arrows

## Debug Installation

Make sure pygame is properly installed:

python -m pygame.examples.aliens

# Tested on:
- OSX Monterey 12.5.1


# Upstream

git remote add upstream git@github.com:dgomes/ia-rush.git

git fetch upstream

git checkout main

git reset --hard

git merge --allow-unrelated-histories upstream/main
