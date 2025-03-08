---
layout: post
title:  "No Feature, No Problem"
date:   2025-03-03
---

This marks my first post on github pages, so welcome if you are here. I am a
former linux system administrator and have worked my way into software
engineering, mostly focused on DevOps at the moment. I also have a vested
interest in cybersecurity and I hope to meld the two together as I learn more.

I plan to post here about anything I learn that I feel is worth documenting
and sharing.

### Cool, so whats up first?

Glad you asked. I have an Ubuntu laptop that I use for alot of my personal dev
projects and I was getting sick of the default background. I found
[this repo](https://github.com/DenverCoder1/minimalistic-wallpaper-collection)
and was immediately filled with primal energy. The problem was, I couldn't
choose just one, I needed (most) of them. I needed a rotation.

I could use the randomized API offered by the repo owner, but hooking up to a
random API in a fire and forget script just doesn't ease my cyber anxiety
(no offense to the repo owner). After grabbing the wallpapers to store locally,
I found out Ubuntu DOES NOT have a built in way to rotate wallpapers.

Let's script it out.

#### **Step 1: Select a random image**
You have the wallpapers you want saved locally. Let's have our script select
one at random.
```bash
# select a random wallpaper from the directory
RANDOM_FILE=$(ls /home/josh/Pictures/wallpapers/ | xargs shuf -e | head -n1)
```
While this is pretty straightforward, I never knew about the `shuf` command
until I was looking into how to randomize a selection. `shuf` simply chooses
a random permutation and `-e` allows you to use your arguments as input. Perfect.

#### **Step 2: Prep for Cron**
Since we are going to be using cron to automate the running of our script at a
specific interval, we need to help it out by setting a specific environment
variable. Cron uses a **very limited** set of environment variables.
```bash
PID=$(pgrep gnome-session | head -n1)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)
```
#### **Step 3: Change the background**
Now lets change out that wallpaper and set it to the one that was randomly
chosen.
```bash
# run the command to change the background wallpaper
gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/josh/Pictures/wallpapers/$RANDOM_FILE"
```
Note that I am using a dark-profile for default background settings. If you are not, omit `picture-uri-dark`.
#### **Step 4: Create a cron job**
Finally, lets create our cronjob.
```bash
crontab -e
0 * * * * ~/scripts/rotate_wallpaper.sh
```
